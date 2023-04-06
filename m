Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1127A41
	for <patches@lists.linux.dev>; Thu,  6 Apr 2023 06:56:16 +0000 (UTC)
Date: Thu, 06 Apr 2023 06:56:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680764174; x=1681023374;
	bh=x9eH5jLzlqlD1oeTC6skO4fRxBR6eOlDpRkl8IwVxoE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=bACR+JIcC17dQkUDTOdz3igPN7NdemtDMVCzZ9hrPxMBnu4Mc0kiG1Cy9Ru+wU8cn
	 1jiZsOHRVr1JoF6hkeyTq4S/3xn7F8kIEVf7q37xeNSRpLETOALYDxKutilYck4OyR
	 kXvod+SRn7yF4H9AU1NsJblvg6tId10aJd5eFe6McqlmYLM2vEYxovQo5ouw7Lc3bA
	 RBQU2g2dYhRAmLwyJsxlR53JMN/yEh6akzWNywUE/+l+N/7axerMOt3yciStV5CkbA
	 dgkT0S0TWKcWe+5U8VZ1JlhWiqq9ivCieB9AW3t1ruk7TxYh8nsimAU9dpUA89Cijd
	 CLEFtR3gl3h3g==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>, Andreas Hindborg <nmi@metaspace.dk>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <a.hindborg@samsung.com>
Subject: [PATCH v6.1] rust: types: add `Opaque::pin_init`
Message-ID: <20230406065546.787669-1-y86-dev@protonmail.com>
In-Reply-To: <20230405193445.745024-14-y86-dev@protonmail.com>
References: <20230405193445.745024-1-y86-dev@protonmail.com> <20230405193445.745024-14-y86-dev@protonmail.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add support for pin-init in combination with `Opaque<T>`, the `pin_init`
function initializes the contents via a user-supplied initializer for
`T`.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Gary Guo <gary@garyguo.net>
---
 rust/kernel/init.rs  |  3 +++
 rust/kernel/types.rs | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index ffd539e2f5ef..23d879e53b26 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -177,6 +177,9 @@
 //! }
 //! ```
 //!
+//! For more information on how to use [`pin_init_from_closure()`], take a=
 look at the uses inside
+//! the `kernel` crate. The [`sync`] module is a good starting point.
+//!
 //! [`sync`]: kernel::sync
 //! [pinning]: https://doc.rust-lang.org/std/pin/index.html
 //! [structurally pinned fields]:
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index ff2b2fac951d..cf1cbd6a1447 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -2,6 +2,7 @@

 //! Kernel types.

+use crate::init::{self, PinInit};
 use alloc::boxed::Box;
 use core::{
     cell::UnsafeCell,
@@ -234,6 +235,23 @@ impl<T> Opaque<T> {
         Self(MaybeUninit::uninit())
     }

+    /// Creates a pin-initializer for `Opaque<T>`.
+    ///
+    /// # Safety
+    ///
+    /// [`PinInit<T, E>`] promises that the [`Pin` `Drop` guarantee] is up=
held for the type `T` if
+    /// initialization succeeds. `Opaque` is a wrapper that allows holding=
 uninitialized values of
+    /// `T`, so it does not drop the `T` when it is dropped. When calling =
this function the caller
+    /// needs to guarantee that:
+    /// - either `T` does not have drop glue ([`core::mem::needs_drop`] re=
tuns `false`),
+    /// - or the caller ensures the drop guarantee manually.
+    ///
+    /// [`Pin` `Drop` guarantee]: https://doc.rust-lang.org/core/pin/index=
.html#drop-guarantee
+    pub unsafe fn pin_init<E>(init: impl PinInit<T, E>) -> impl PinInit<Se=
lf, E> {
+        // SAFETY: `init` initializes the only field of this struct.
+        unsafe { init::pin_init_from_closure(|slot| init.__pinned_init(Sel=
f::raw_get(slot))) }
+    }
+
     /// Returns a raw pointer to the opaque data.
     pub fn get(&self) -> *mut T {
         UnsafeCell::raw_get(self.0.as_ptr())
--
2.39.2


