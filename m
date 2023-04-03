Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B8E6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 16:06:07 +0000 (UTC)
Date: Mon, 03 Apr 2023 16:05:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680537965; x=1680797165;
	bh=XWxRNYRILriG9buCxYWPZvFrye6VcAJ3FED3SsdC9Ao=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=DNemyBNee5laXKlZlC9N3u/jVkMv95G0Y5gTfsiY/jTLdk6pd7mfz1X6r5tcTmeF4
	 VcUlu9g/J2T5F9gpKVvgWSnOOs7PzhTDbR6ZvLyh3Agmwe9Q5RmblclrHZ146+rzwe
	 HlzN5ebC9XdP1sckq0vpMIvpaa+2Untc/k5jPZSfvSkGxucnhlFJzlk40Ww1Ok8hgM
	 ojQ6HkuI27Ro8cDEfiAjC9Xjnq+xS367rd8cMeeCGkBFf471aCOQ8lGtRqT+tM3ZMO
	 YkmsVEZLwqfAkaJux71zb015oyobOFsnzMe//LHWYJduW0ePYwWwCPqp6krjf7c21b
	 NzfMxxS43tyUg==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <a.hindborg@samsung.com>
Subject: [PATCH v5 14/15] rust: sync: reduce stack usage of `UniqueArc::try_new_uninit`
Message-ID: <20230403160511.174894-7-y86-dev@protonmail.com>
In-Reply-To: <20230403154422.168633-1-y86-dev@protonmail.com>
References: <20230403154422.168633-1-y86-dev@protonmail.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

`UniqueArc::try_new_uninit` calls `Arc::try_new(MaybeUninit::uninit())`.
This results in the uninitialized memory being placed on the stack,
which may be arbitrarily large due to the generic `T` and thus could
cause a stack overflow for large types.

Change the implementation to use the pin-init API which enables in-place
initialization. In particular it avoids having to first construct and
then move the uninitialized memory from the stack into the final location.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
---
 rust/kernel/lib.rs      |  1 -
 rust/kernel/sync/arc.rs | 16 +++++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 821bd067151c..2d7606135ef6 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -28,7 +28,6 @@
 #[cfg(not(CONFIG_RUST))]
 compile_error!("Missing kernel configuration for conditional compilation")=
;

-#[allow(unused_extern_crates)]
 // Allow proc-macros to refer to `::kernel` inside the `kernel` crate (thi=
s crate).
 extern crate self as kernel;

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 43a53fbe175d..d05caa723718 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -18,7 +18,8 @@
 use crate::{
     bindings,
     error::{self, Error},
-    init::{InPlaceInit, Init, PinInit},
+    init::{self, InPlaceInit, Init, PinInit},
+    try_init,
     types::{ForeignOwnable, Opaque},
 };
 use alloc::boxed::Box;
@@ -30,6 +31,7 @@ use core::{
     pin::Pin,
     ptr::NonNull,
 };
+use macros::pin_data;

 /// A reference-counted pointer to an instance of `T`.
 ///
@@ -122,6 +124,7 @@ pub struct Arc<T: ?Sized> {
     _p: PhantomData<ArcInner<T>>,
 }

+#[pin_data]
 #[repr(C)]
 struct ArcInner<T: ?Sized> {
     refcount: Opaque<bindings::refcount_t>,
@@ -502,9 +505,16 @@ impl<T> UniqueArc<T> {

     /// Tries to allocate a new [`UniqueArc`] instance whose contents are =
not initialised yet.
     pub fn try_new_uninit() -> Result<UniqueArc<MaybeUninit<T>>, AllocErro=
r> {
-        Ok(UniqueArc::<MaybeUninit<T>> {
+        // INVARIANT: The refcount is initialised to a non-zero value.
+        let inner =3D Box::try_init::<AllocError>(try_init!(ArcInner {
+            // SAFETY: There are no safety requirements for this FFI call.
+            refcount: Opaque::new(unsafe { bindings::REFCOUNT_INIT(1) }),
+            data <- init::uninit::<T, AllocError>(),
+        }? AllocError))?;
+        Ok(UniqueArc {
             // INVARIANT: The newly-created object has a ref-count of 1.
-            inner: Arc::try_new(MaybeUninit::uninit())?,
+            // SAFETY: The pointer from the `Box` is valid.
+            inner: unsafe { Arc::from_inner(Box::leak(inner).into()) },
         })
     }
 }
--
2.39.2


