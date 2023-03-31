Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503D38F54
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 21:53:37 +0000 (UTC)
Date: Fri, 31 Mar 2023 21:53:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680299614; x=1680558814;
	bh=DPTzK+Qui1IJXTgvMYy9gbdRtBobG73CivdLCgcwUrA=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=GJKpOeXlyfaIGROdt2A8y+Ftn/Jd2JxDZTszCitNIuOOeDCJb0m8PjU1KZ8Qe6nMg
	 N574iFyvm1sGmspnBarR5Da/i93FbOzPe/mBjs/BkNWW3w1FtygzX2xOePNjMDiEL2
	 3e9MynpzyOPJpBzR/qfbMg+tmeC/xSImhXv34r580U9eu7FjAeQitSN/izDpu5FAp8
	 OuJvpogDGDVLjlbxYzwvjjv0MKZGn+ZaZqD/sJDrMUceazE6id61jLDU0eQUiykCt8
	 edbHUtSZ7rKWBbLXakNTqTbg8ss2GJhF3Er6zwmGIltxGNO0o56blGbLMNLB6U/htB
	 P9kfOVaHuVNGw==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: y86-dev@protonmail.com
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH v4 08/15] rust: init/sync: add `InPlaceInit` trait to pin-initialize smart pointers
Message-ID: <20230331215053.585759-9-y86-dev@protonmail.com>
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

The `InPlaceInit` trait that provides two functions, for initializing
using `PinInit<T, E>` and `Init<T>`. It is implemented by `Arc<T>`,
`UniqueArc<T>` and `Box<T>`.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Gary Guo <gary@garyguo.net>
---
 rust/kernel/init.rs     | 128 ++++++++++++++++++++++++++++++++++++----
 rust/kernel/sync/arc.rs |  23 ++++++++
 2 files changed, 138 insertions(+), 13 deletions(-)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index 14cc5d2dafef..cf2b9ee6ce0e 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -114,10 +114,16 @@
 //! [`impl Init<T, E>`]: Init
 //! [`Opaque`]: kernel::types::Opaque
 //! [`pin_data`]: ::macros::pin_data
-//! [`UniqueArc<T>`]: kernel::sync::UniqueArc

+use crate::{
+    error::{self, Error},
+    sync::UniqueArc,
+};
 use alloc::boxed::Box;
-use core::{cell::Cell, convert::Infallible, marker::PhantomData, mem::Mayb=
eUninit, ptr};
+use core::{
+    alloc::AllocError, cell::Cell, convert::Infallible, marker::PhantomDat=
a, mem::MaybeUninit,
+    pin::Pin, ptr,
+};

 #[doc(hidden)]
 pub mod __internal;
@@ -309,7 +315,6 @@ pub mod macros;
 ///
 /// [`try_pin_init!`]: kernel::try_pin_init
 /// [`NonNull<Self>`]: core::ptr::NonNull
-/// [`Error`]: kernel::error::Error
 // For a detailed example of how this macro works, see the module document=
ation of the hidden
 // module `__internal` inside of `init/__internal.rs`.
 #[macro_export]
@@ -363,8 +368,6 @@ macro_rules! pin_init {
 ///     }
 /// }
 /// ```
-///
-/// [`Error`]: kernel::error::Error
 // For a detailed example of how this macro works, see the module document=
ation of the hidden
 // module `__internal` inside of `init/__internal.rs`.
 #[macro_export]
@@ -586,8 +589,6 @@ macro_rules! try_pin_init {
 ///
 /// This initializer is for initializing data in-place that might later be=
 moved. If you want to
 /// pin-initialize, use [`pin_init!`].
-///
-/// [`Error`]: kernel::error::Error
 // For a detailed example of how this macro works, see the module document=
ation of the hidden
 // module `__internal` inside of `init/__internal.rs`.
 #[macro_export]
@@ -638,8 +639,6 @@ macro_rules! init {
 ///     }
 /// }
 /// ```
-///
-/// [`Error`]: kernel::error::Error
 // For a detailed example of how this macro works, see the module document=
ation of the hidden
 // module `__internal` inside of `init/__internal.rs`.
 #[macro_export]
@@ -845,7 +844,8 @@ macro_rules! try_init {
 /// A pin-initializer for the type `T`.
 ///
 /// To use this initializer, you will need a suitable memory location that=
 can hold a `T`. This can
-/// be [`Box<T>`], [`Arc<T>`], [`UniqueArc<T>`].
+/// be [`Box<T>`], [`Arc<T>`], [`UniqueArc<T>`]. Use the [`InPlaceInit::pi=
n_init`] function of a
+/// smart pointer like [`Arc<T>`] on this.
 ///
 /// Also see the [module description](self).
 ///
@@ -864,7 +864,6 @@ macro_rules! try_init {
 ///
 /// [`Arc<T>`]: crate::sync::Arc
 /// [`Arc::pin_init`]: crate::sync::Arc::pin_init
-/// [`UniqueArc<T>`]: kernel::sync::UniqueArc
 #[must_use =3D "An initializer must be used in order to create its value."=
]
 pub unsafe trait PinInit<T: ?Sized, E =3D Infallible>: Sized {
     /// Initializes `slot`.
@@ -881,7 +880,8 @@ pub unsafe trait PinInit<T: ?Sized, E =3D Infallible>: =
Sized {
 /// An initializer for `T`.
 ///
 /// To use this initializer, you will need a suitable memory location that=
 can hold a `T`. This can
-/// be [`Box<T>`], [`Arc<T>`], [`UniqueArc<T>`]. Because [`PinInit<T, E>`]=
 is a super trait, you can
+/// be [`Box<T>`], [`Arc<T>`], [`UniqueArc<T>`]. Use the [`InPlaceInit::in=
it`] function of a smart
+/// pointer like [`Arc<T>`] on this. Because [`PinInit<T, E>`] is a super =
trait, you can
 /// use every function that takes it as well.
 ///
 /// Also see the [module description](self).
@@ -906,7 +906,6 @@ pub unsafe trait PinInit<T: ?Sized, E =3D Infallible>: =
Sized {
 /// move the pointee after initialization.
 ///
 /// [`Arc<T>`]: crate::sync::Arc
-/// [`UniqueArc<T>`]: kernel::sync::UniqueArc
 #[must_use =3D "An initializer must be used in order to create its value."=
]
 pub unsafe trait Init<T: ?Sized, E =3D Infallible>: PinInit<T, E> {
     /// Initializes `slot`.
@@ -981,3 +980,106 @@ unsafe impl<T> Init<T> for T {
         Ok(())
     }
 }
+
+/// Smart pointer that can initialize memory in-place.
+pub trait InPlaceInit<T>: Sized {
+    /// Use the given pin-initializer to pin-initialize a `T` inside of a =
new smart pointer of this
+    /// type.
+    ///
+    /// If `T: !Unpin` it will not be able to move afterwards.
+    fn try_pin_init<E>(init: impl PinInit<T, E>) -> Result<Pin<Self>, E>
+    where
+        E: From<AllocError>;
+
+    /// Use the given pin-initializer to pin-initialize a `T` inside of a =
new smart pointer of this
+    /// type.
+    ///
+    /// If `T: !Unpin` it will not be able to move afterwards.
+    fn pin_init<E>(init: impl PinInit<T, E>) -> error::Result<Pin<Self>>
+    where
+        Error: From<E>,
+    {
+        // SAFETY: We delegate to `init` and only change the error type.
+        let init =3D unsafe {
+            pin_init_from_closure(|slot| init.__pinned_init(slot).map_err(=
|e| Error::from(e)))
+        };
+        Self::try_pin_init(init)
+    }
+
+    /// Use the given initializer to in-place initialize a `T`.
+    fn try_init<E>(init: impl Init<T, E>) -> Result<Self, E>
+    where
+        E: From<AllocError>;
+
+    /// Use the given initializer to in-place initialize a `T`.
+    fn init<E>(init: impl Init<T, E>) -> error::Result<Self>
+    where
+        Error: From<E>,
+    {
+        // SAFETY: We delegate to `init` and only change the error type.
+        let init =3D unsafe {
+            init_from_closure(|slot| init.__pinned_init(slot).map_err(|e| =
Error::from(e)))
+        };
+        Self::try_init(init)
+    }
+}
+
+impl<T> InPlaceInit<T> for Box<T> {
+    #[inline]
+    fn try_pin_init<E>(init: impl PinInit<T, E>) -> Result<Pin<Self>, E>
+    where
+        E: From<AllocError>,
+    {
+        let mut this =3D Box::try_new_uninit()?;
+        let slot =3D this.as_mut_ptr();
+        // SAFETY: When init errors/panics, slot will get deallocated but =
not dropped,
+        // slot is valid and will not be moved, because we pin it later.
+        unsafe { init.__pinned_init(slot)? };
+        // SAFETY: All fields have been initialized.
+        Ok(unsafe { this.assume_init() }.into())
+    }
+
+    #[inline]
+    fn try_init<E>(init: impl Init<T, E>) -> Result<Self, E>
+    where
+        E: From<AllocError>,
+    {
+        let mut this =3D Box::try_new_uninit()?;
+        let slot =3D this.as_mut_ptr();
+        // SAFETY: When init errors/panics, slot will get deallocated but =
not dropped,
+        // slot is valid.
+        unsafe { init.__init(slot)? };
+        // SAFETY: All fields have been initialized.
+        Ok(unsafe { this.assume_init() })
+    }
+}
+
+impl<T> InPlaceInit<T> for UniqueArc<T> {
+    #[inline]
+    fn try_pin_init<E>(init: impl PinInit<T, E>) -> Result<Pin<Self>, E>
+    where
+        E: From<AllocError>,
+    {
+        let mut this =3D UniqueArc::try_new_uninit()?;
+        let slot =3D this.as_mut_ptr();
+        // SAFETY: When init errors/panics, slot will get deallocated but =
not dropped,
+        // slot is valid and will not be moved, because we pin it later.
+        unsafe { init.__pinned_init(slot)? };
+        // SAFETY: All fields have been initialized.
+        Ok(unsafe { this.assume_init() }.into())
+    }
+
+    #[inline]
+    fn try_init<E>(init: impl Init<T, E>) -> Result<Self, E>
+    where
+        E: From<AllocError>,
+    {
+        let mut this =3D UniqueArc::try_new_uninit()?;
+        let slot =3D this.as_mut_ptr();
+        // SAFETY: When init errors/panics, slot will get deallocated but =
not dropped,
+        // slot is valid.
+        unsafe { init.__init(slot)? };
+        // SAFETY: All fields have been initialized.
+        Ok(unsafe { this.assume_init() })
+    }
+}
diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index eee7008e5e3e..24dc96603090 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -17,6 +17,7 @@

 use crate::{
     bindings,
+    init::{InPlaceInit, Init, PinInit},
     types::{ForeignOwnable, Opaque},
 };
 use alloc::boxed::Box;
@@ -163,6 +164,28 @@ impl<T> Arc<T> {
         // `Arc` object.
         Ok(unsafe { Self::from_inner(Box::leak(inner).into()) })
     }
+
+    /// Use the given initializer to in-place initialize a `T`.
+    ///
+    /// If `T: !Unpin` it will not be able to move afterwards.
+    #[inline]
+    pub fn pin_init<E>(init: impl PinInit<T, E>) -> Result<Self>
+    where
+        Error: From<E>,
+    {
+        UniqueArc::pin_init(init).map(|u| u.into())
+    }
+
+    /// Use the given initializer to in-place initialize a `T`.
+    ///
+    /// This is equivalent to [`pin_init`], since an [`Arc`] is always pin=
ned.
+    #[inline]
+    pub fn init<E>(init: impl Init<T, E>) -> Result<Self>
+    where
+        Error: From<E>,
+    {
+        UniqueArc::init(init).map(|u| u.into())
+    }
 }

 impl<T: ?Sized> Arc<T> {
--
2.39.2


