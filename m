Received: from mail-4325.protonmail.ch (mail-4325.protonmail.ch [185.70.43.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797DE15A6
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 01:24:43 +0000 (UTC)
Date: Mon, 13 Mar 2023 01:24:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1678670676; x=1678929876;
	bh=cuPbajrG04DWKCw3k4p3kDYIB2rguZndGg7ZIQkRsVg=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=bgkauahIibdtHbqnw5u75ZP+3pa8tnBflxvHg0QDi+LaQ4hS5neh7oZPKGxxF8YMX
	 uiFMBdnsvkybeMOngMrw5QQBU8O93YuyGNKnhIclhiE99yvkUPeB493/O2LHmIPdtC
	 td7WAurrA1L9hA4RA7Ylv90LdtVgeHkIJIZ3ZujOGEcCAZBPwrJP/miBJ073UuMT0+
	 5rZRh/N7nTEZAsX6c/bOncyEsIKOKeTGbruRtiHKGP6MyRTGZjsGx31iuV4Pj3EEYA
	 8QOqfgyNMFsyCSx7lRyv+P87iGZ1DO79SG3Kx5YYASMkqYWe3yjA7wJmbzIFycP7kI
	 7FT3k9SJgOjMA==
To: "ojeda@kernel.org" <ojeda@kernel.org>, "alex.gaynor@gmail.com" <alex.gaynor@gmail.com>, "wedsonaf@gmail.com" <wedsonaf@gmail.com>, "boqun.feng@gmail.com" <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, "bjorn3_gh@protonmail.com" <bjorn3_gh@protonmail.com>
From: y86-dev <y86-dev@protonmail.com>
Cc: "rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: [PATCH v1 3/3] rust: sync: reduce stack usage of `UniqueArc::try_new_uninit`
Message-ID: <Rip04cG4jD8kWRp4EAJ_UjB6HDenuUkC6m3lOTvzG8e7QLFEmrX4q3jgqZEzjmpd4MIplGcEjzWJ2Yj3nlDEqgfqxsnLq3_gPxW4Oo-8PN8=@protonmail.com>
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
---
 rust/kernel/lib.rs      |  1 -
 rust/kernel/sync/arc.rs | 12 +++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 3e2777d26ff5..d9df77132fa2 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -27,7 +27,6 @@
 #[cfg(not(CONFIG_RUST))]
 compile_error!("Missing kernel configuration for conditional compilation")=
;
=20
-#[allow(unused_extern_crates)]
 // Allow proc-macros to refer to `::kernel` inside the `kernel` crate (thi=
s crate).
 extern crate self as kernel;
=20
diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 5b4f64dd3ac8..6782d66039e1 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -18,6 +18,7 @@
 use crate::{
     bindings,
     error::{Error, Result},
+    init,
     init::{InPlaceInit, Init, PinInit},
     types::{ForeignOwnable, Opaque},
 };
@@ -29,6 +30,7 @@ use core::{
     pin::Pin,
     ptr::NonNull,
 };
+use macros::pin_data;
=20
 /// A reference-counted pointer to an instance of `T`.
 ///
@@ -121,6 +123,7 @@ pub struct Arc<T: ?Sized> {
     _p: PhantomData<ArcInner<T>>,
 }
=20
+#[pin_data]
 #[repr(C)]
 struct ArcInner<T: ?Sized> {
     refcount: Opaque<bindings::refcount_t>,
@@ -501,9 +504,16 @@ impl<T> UniqueArc<T> {
=20
     /// Tries to allocate a new [`UniqueArc`] instance whose contents are =
not initialised yet.
     pub fn try_new_uninit() -> Result<UniqueArc<MaybeUninit<T>>> {
+        // INVARIANT: The refcount is initialised to a non-zero value.
+        let inner =3D Box::init(init!(ArcInner<MaybeUninit<T>> {
+            // SAFETY: There are no safety requirements for this FFI call.
+            refcount: Opaque::new(unsafe { bindings::REFCOUNT_INIT(1) }),
+            data <- init::uninit(),
+        }))?;
         Ok(UniqueArc::<MaybeUninit<T>> {
             // INVARIANT: The newly-created object has a ref-count of 1.
-            inner: Arc::try_new(MaybeUninit::uninit())?,
+            // SAFETY: The pointer from the `Box` is valid.
+            inner: unsafe { Arc::from_inner(Box::leak(inner).into()) },
         })
     }
 }
--=20
2.39.2
