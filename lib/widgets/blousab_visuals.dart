import 'dart:io';
import 'package:flutter/material.dart';

/// Reusable visual primitives for the supplied neon-blue/purple reference.
/// Presentational only: no transport, persistence or permission side effects.
class BlousabVisuals {
  static const Color deep = Color(0xFF050916);
  static const Color panel = Color(0xFF0C142B);
  static const Color electric = Color(0xFF167BFF);
  static const Color cyan = Color(0xFF28C7FF);
  static const Color violet = Color(0xFFB238FF);
  static const Color border = Color(0xFF3858BD);
  static const Gradient neon = LinearGradient(
    begin: Alignment.topRight, end: Alignment.bottomLeft,
    colors: [cyan, electric, violet],
  );
  static BoxDecoration panelDecoration({bool selected = false, double radius = 12}) => BoxDecoration(
    color: selected ? const Color(0xFF11235D) : panel,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: selected ? cyan : border, width: selected ? 1.3 : .85),
    boxShadow: [BoxShadow(color: electric.withOpacity(selected ? .29 : .11), blurRadius: selected ? 16 : 7)],
  );
}

class BlousabNeonPanel extends StatelessWidget {
  const BlousabNeonPanel({super.key, required this.child, this.padding = const EdgeInsets.all(10), this.selected = false, this.margin = EdgeInsets.zero});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Card(margin: margin, child: Padding(padding: padding, child: child));
    }
    return Container(margin: margin, decoration: BlousabVisuals.panelDecoration(selected: selected), padding: padding, child: child);
  }
}

class BlousabProfileAvatar extends StatelessWidget {
  const BlousabProfileAvatar({super.key, required this.name, this.photoPath, this.radius = 24, this.online = false});
  final String name;
  final String? photoPath;
  final double radius;
  final bool online;
  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    final hasPhoto = path != null && path.isNotEmpty && File(path).existsSync();
    return SizedBox(width: radius * 2 + 8, height: radius * 2 + 8, child: Stack(children: [
      Container(
        padding: const EdgeInsets.all(2.4),
        decoration: const BoxDecoration(gradient: BlousabVisuals.neon, shape: BoxShape.circle),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFF172B65),
          backgroundImage: hasPhoto ? FileImage(File(path!)) : null,
          child: hasPhoto ? null : Text(name.isEmpty ? 'ب' : name.substring(0, 1), style: TextStyle(fontSize: radius * .72, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
      if (online) Positioned(left: 1, bottom: 1, child: Container(width: 12, height: 12,
        decoration: BoxDecoration(color: const Color(0xFF1CE96E), shape: BoxShape.circle, border: Border.all(color: BlousabVisuals.deep, width: 2)))),
    ]));
  }
}

/// Subtle reference-like B motifs behind chats; does not intercept taps.
class BlousabChatWallpaper extends StatelessWidget {
  const BlousabChatWallpaper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Stack(children: [
    Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _BlousabMotifPainter()))),
    child,
  ]);
}

class _BlousabMotifPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const style = TextStyle(color: Color(0x0C3975FF), fontSize: 45, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic);
    for (double y = 14; y < size.height; y += 94) {
      for (double x = 12; x < size.width; x += 112) {
        final painter = TextPainter(text: const TextSpan(text: 'B', style: style), textDirection: TextDirection.ltr)..layout();
        canvas.save();
        canvas.translate(x + (y.toInt() % 2) * 21, y);
        canvas.rotate(-.19);
        painter.paint(canvas, Offset.zero);
        canvas.restore();
      }
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
