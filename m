Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139A8D516
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 19:50:27 +0000 (UTC)
Date: Tue, 21 Mar 2023 19:50:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1679428225; x=1679687425;
	bh=+p+odlGt4Lpa7j8EN6KwSae2Ae/jbNLZRSBVIgNchK8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ZWimU1u/tRce1Mxz5ecaVPMKqjL4yJUpOxb+ZGSdYyUVD6VkjzFJQjhS+kawVYSzv
	 nw/t3h0YWanoOp6hEZtOc3V//NDlXM1wzgW7elSg4u5fPmUHykFyYvr3Byg/nRRvcw
	 wNXK4RhrTKqBsj6MdgJyNjSiDZ0U92FOKPKmlCC/ks8rwhYJajqoFk4qV+cEUZ05AP
	 B8rTj9FUHq/OXcnoQX8okfDxICJYkJWfB4Wp0v5A9F6Oun6HBMkGxWHfcrPD0kqSIm
	 nQGqAti6lV6lsT++J9p5+yGi6Gs/ltT4YJMaYNFdyIyFeS8b+/6WDgWo4KU39uB7vg
	 a8pZlbHLUerdg==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [PATCH v2 4/5] rust: init: add common init-helper functions for `Opaque`
Message-ID: <20230321194934.908891-5-y86-dev@protonmail.com>
In-Reply-To: <20230321194934.908891-1-y86-dev@protonmail.com>
References: <20230321194934.908891-1-y86-dev@protonmail.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add helper functions to more easily initialize `Opaque<T>` via FFI.
These functions take a function pointer to the FFI-initialization
function and take between 0-4 other arguments. It then returns an
initializer that uses the FFI function along with the given arguments to
initialize an `Opaque<T>`.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
---
 rust/kernel/init.rs        |  1 +
 rust/kernel/init/common.rs | 42 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 rust/kernel/init/common.rs

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index 895845db6f2b..5b8adb8727b2 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -207,6 +207,7 @@ use core::{
     ptr,
 };

+pub mod common;
 #[doc(hidden)]
 pub mod macros;

diff --git a/rust/kernel/init/common.rs b/rust/kernel/init/common.rs
new file mode 100644
index 000000000000..f8c6e9dff786
--- /dev/null
+++ b/rust/kernel/init/common.rs
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: Apache-2.0 OR MIT
+
+//! Module containing common kernel initializer functions.
+
+use crate::{
+    init::{self, PinInit},
+    types::Opaque,
+};
+
+macro_rules! create_func {
+    ($name:ident $(, $arg_name:ident: $arg_typ:ident)*) =3D> {
+        /// Create an initializer using the given initializer function fro=
m C.
+        ///
+        /// # Safety
+        ///
+        /// The given function **must** under all circumstances initialize=
 the memory location to a
+        /// valid `T`. If it fails to do so it results in UB.
+        ///
+        /// If any parameters are given, those need to be valid for the fu=
nction. Valid means that
+        /// calling the function with those parameters complies with the a=
bove requirement **and**
+        /// every other requirement on the function itself.
+        pub unsafe fn $name<T $(, $arg_typ)*>(
+            init_func: unsafe extern "C" fn(*mut T $(, $arg_name: $arg_typ=
)*),
+            $($arg_name: $arg_typ,)*
+        ) -> impl PinInit<Opaque<T>> {
+            // SAFETY: The safety contract of this function ensures that `=
init_func` fully
+            // initializes `slot`.
+            unsafe {
+                init::pin_init_from_closure(move |slot| {
+                    init_func(Opaque::raw_get(slot) $(, $arg_name)*);
+                    Ok(())
+                })
+            }
+        }
+    }
+}
+
+create_func!(ffi_init);
+create_func!(ffi_init1, arg1: A1);
+create_func!(ffi_init2, arg1: A1, arg2: A2);
+create_func!(ffi_init3, arg1: A1, arg2: A2, arg3: A3);
+create_func!(ffi_init4, arg1: A1, arg2: A2, arg3: A3, arg4: A4);
--
2.39.2


