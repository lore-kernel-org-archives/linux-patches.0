Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093458F54
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 21:54:43 +0000 (UTC)
Date: Fri, 31 Mar 2023 21:54:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680299680; x=1680558880;
	bh=5Fn50wx9SjwjEk+7PFvrVXZ6Yt0uZEDngF0z84FHnKc=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=rpl7HOJlJTDiEG+BmuTzQHlWSHu2+U/blhvLlzXyQhzz6HEl0LLvfR+RJZaLdgU5x
	 wy4YjiDBPq3QrCgHdYLrpaBKuPgSDp/UTF02H07Gg7s/hWGahPBI7C2UfhhalDMH9z
	 V9j0Bh5KZWdTTXkuugNCdeNGj8ZDa0RcrXmURX4W09gfCCoYeS7bfkX3d7KaFF5xsx
	 u7bQhmnHgWTudRL9qRHFvo+d1crdrVx6Q1cllbsnYOPztVMm5F2VuUT4oIgUMBl8r0
	 5yU9XftQvtDwWeqZbdSBDlv6WzRTwN1k2Ps8T03vZdkqNOXQusNPMkirvlJp59ylG0
	 xeYIRQ7xpT97g==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: y86-dev@protonmail.com
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <a.hindborg@samsung.com>
Subject: [PATCH v4 13/15] rust: types: add common init-helper functions for `Opaque`
Message-ID: <20230331215053.585759-14-y86-dev@protonmail.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

From: Benno Lossin <y86-dev@protonmail.com>

Add helper functions to more easily initialize `Opaque<T>` via FFI and
rust raw initializer functions.
These functions take a function pointer to the FFI/raw initialization
function and take between 0-4 other arguments. It then returns an
initializer that uses the FFI/raw initialization function along with the
given arguments to initialize an `Opaque<T>`.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Gary Guo <gary@garyguo.net>
---
 rust/kernel/init.rs  |  9 +++++++++
 rust/kernel/types.rs | 47 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index fef14c3c0642..7b452e458391 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -177,6 +177,14 @@
 //! }
 //! ```
 //!
+//! For the special case where initializing a field is a single FFI-functi=
on call that cannot fail,
+//! there exist helper functions [`Opaque::ffi_init`]. These functions ini=
tialize a single
+//! [`Opaque`] field by just delegating to the FFI-function. You can use t=
hese in combination with
+//! [`pin_init!`].
+//!
+//! For more information on how to use [`pin_init_from_closure()`], take a=
 look at the uses inside
+//! the `kernel` crate. The [`sync`] module is a good starting point.
+//!
 //! [`sync`]: kernel::sync
 //! [pinning]: https://doc.rust-lang.org/std/pin/index.html
 //! [structurally pinned fields]:
@@ -187,6 +195,7 @@
 //! [`impl PinInit<T, E>`]: PinInit
 //! [`impl Init<T, E>`]: Init
 //! [`Opaque`]: kernel::types::Opaque
+//! [`Opaque::ffi_init`]: kernel::types::Opaque::ffi_init
 //! [`pin_data`]: ::macros::pin_data

 use crate::{
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index ff2b2fac951d..dbfae9bb97ce 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -2,6 +2,7 @@

 //! Kernel types.

+use crate::init::{self, PinInit};
 use alloc::boxed::Box;
 use core::{
     cell::UnsafeCell,
@@ -248,6 +249,52 @@ impl<T> Opaque<T> {
     }
 }

+macro_rules! opaque_init_funcs {
+    ($($abi:literal $name:ident($($arg_name:ident: $arg_typ:ident),*);)*) =
=3D> {
+        impl<T> Opaque<T> {
+            $(
+                /// Create an initializer using the given initializer func=
tion.
+                ///
+                /// # Safety
+                ///
+                /// The given function **must** under all circumstances in=
itialize the memory
+                /// location to a valid `T`. If it fails to do so it resul=
ts in UB.
+                ///
+                /// If any parameters are given, those need to be valid fo=
r the function. Valid
+                /// means that calling the function with those parameters =
complies with the above
+                /// requirement **and** every other requirement on the fun=
ction itself.
+                pub unsafe fn $name<$($arg_typ),*>(
+                    init_func: unsafe extern $abi fn(*mut T $(, $arg_typ)*=
),
+                    $($arg_name: $arg_typ,)*
+                ) -> impl PinInit<Self> {
+                    // SAFETY: The safety contract of this function ensure=
s that `init_func` fully
+                    // initializes `slot`.
+                    unsafe {
+                        init::pin_init_from_closure(move |slot| {
+                            init_func(Self::raw_get(slot) $(, $arg_name)*)=
;
+                            Ok(())
+                        })
+                    }
+                }
+            )*
+        }
+    }
+}
+
+opaque_init_funcs! {
+    "C" ffi_init();
+    "C" ffi_init1(arg1: A1);
+    "C" ffi_init2(arg1: A1, arg2: A2);
+    "C" ffi_init3(arg1: A1, arg2: A2, arg3: A3);
+    "C" ffi_init4(arg1: A1, arg2: A2, arg3: A3, arg4: A4);
+
+    "Rust" manual_init();
+    "Rust" manual_init1(arg1: A1);
+    "Rust" manual_init2(arg1: A1, arg2: A2);
+    "Rust" manual_init3(arg1: A1, arg2: A2, arg3: A3);
+    "Rust" manual_init4(arg1: A1, arg2: A2, arg3: A3, arg4: A4);
+}
+
 /// A sum type that always holds either a value of type `L` or `R`.
 pub enum Either<L, R> {
     /// Constructs an instance of [`Either`] containing a value of type `L=
`.
--
2.39.2


