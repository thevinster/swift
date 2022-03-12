// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend -enable-testing -enable-library-evolution -module-name=resilient %S/Inputs/resilient-class.swift -emit-module -emit-module-path %t/resilient.swiftmodule
// RUN: %target-swift-frontend -I %t -emit-ir %s | %FileCheck %s

// Check that linking succeeds.
// RUN: %empty-directory(%t)
// RUN: %target-build-swift-dylib(%t/%target-library-name(resilient)) %S/Inputs/resilient-class.swift -module-name resilient -emit-module -emit-module-path %t/resilient.swiftmodule -enable-library-evolution -enable-testing
// RUN: %target-build-swift -I %t -L %t -lresilient %s -o %t/main %target-rpath(%t)
// RUN: %target-build-swift -O -I %t -L %t -lresilient %s -o %t/main %target-rpath(%t)

@testable import resilient

// Don't access via the class offset global. Use a fragile access pattern instead.

// CHECK-NOT: s9resilient8SubClassCMo

public func testCase() {
  let t = SubClass()
  print(t.y)
}
