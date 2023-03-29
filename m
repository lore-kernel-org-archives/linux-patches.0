Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3DCAD30
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 22:33:50 +0000 (UTC)
Date: Wed, 29 Mar 2023 22:33:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680129227; x=1680388427;
	bh=Bdc006Fpq8n7WyytZe9I903nLq3Fv9jO+Q4yAlMCUQY=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=w5ZUkhdmGEPDEY/1o6VefbNUusRzKSfHdwn7YLG0PZcAudrlpoUNyKpn+xGayAbJB
	 p4pWCHvD1FuTc/ntKfgTwYgcW/FQ3j3f+axtcMtYy4FS8gqEJ9UEdMQ3aCpNt2P8VZ
	 WBXDYIbHqYymKfUnt/5bd31fcxsTezM1nOd8RWf+Y7nAHaetKED2LTXptMZ6gBWQ8P
	 fwdhpe4kURLsv8QGapI+q0v29B8wZdhJCswUrlN8aYJssWBc2QWdsLmZ0zMAuieycv
	 kjBdd07o9HPGfYTAL5JJqZfQet9SyemuTcc45d+Fbb6B0Pby7D5TWXrE9Nwdz9O6Kx
	 nJdIVjozJb01g==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: y86-dev@protonmail.com
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [PATCH v3 11/13] rust: types: add common init-helper functions for `Opaque`
Message-ID: <20230329223239.138757-12-y86-dev@protonmail.com>
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
---
 rust/kernel/init.rs  |  9 +++++++++
 rust/kernel/types.rs | 47 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index a923546696ce..485970b6522d 100644
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


