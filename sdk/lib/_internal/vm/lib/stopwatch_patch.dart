// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.6

// part of "core_patch.dart";

@patch
class Stopwatch {
  static const _maxInt = 0x7FFFFFFFFFFFFFFF;

  @patch
  static void _initTicker() {
    if (_frequency == null) {
      _frequency = _computeFrequency();
    }
  }

  // Returns the current clock tick.
  @patch
  static int _now() native "Stopwatch_now";

  // Returns the frequency of clock ticks in Hz.
  static int _computeFrequency() native "Stopwatch_frequency";

  @patch
  int get elapsedMicroseconds {
    int ticks = elapsedTicks;
    // Special case the more likely frequencies to avoid division,
    // or divide by a known value.
    if (_frequency == 1000000000) return ticks ~/ 1000;
    if (_frequency == 1000000) return ticks;
    if (_frequency == 1000) return ticks * 1000;
    if (ticks <= (_maxInt ~/ 1000000)) {
      return (ticks * 1000000) ~/ _frequency;
    }
    // Multiplication would have overflowed.
    int ticksPerSecond = ticks ~/ _frequency;
    int remainingTicks = ticks.remainder(_frequency);
    return ticksPerSecond * 1000000 + (remainingTicks * 1000000) ~/ _frequency;
  }

  @patch
  int get elapsedMilliseconds {
    int ticks = elapsedTicks;
    if (_frequency == 1000000000) return ticks ~/ 1000000;
    if (_frequency == 1000000) return ticks ~/ 1000;
    if (_frequency == 1000) return ticks;
    if (ticks <= (_maxInt ~/ 1000)) {
      return (ticks * 1000) ~/ _frequency;
    }
    // Multiplication would have overflowed.
    int ticksPerSecond = ticks ~/ _frequency;
    int remainingTicks = ticks.remainder(_frequency);
    return ticksPerSecond * 1000 + (remainingTicks * 1000) ~/ _frequency;
  }
}
