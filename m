Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867C86FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 15:45:13 +0000 (UTC)
Date: Mon, 03 Apr 2023 15:44:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680536711; x=1680795911;
	bh=NOtOxMB2O2qfeH9Un+9EFwj4vLjfj5tD+KDIQcfJKm8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Kc1mKsi1EvChhlr+Hwv9ESwI6XrDrz59+80MK5y+srICbJj3Iyqt3j9WKmqUy55cT
	 3ReN/JTZwA+EW11d4LmcW391LGo5uIetEYXEN8UKX3SPJOKKHTYwypvgEMOGHHt7Ap
	 DfrqbMjuY5SRN6LXqPmGw6kk7Sj7qQaBX54KFAXarPhO2bE09bn6tCnh0OKJDN9g8P
	 Ajvy1fqYT4xzYh4Hs2BjBlhpivyKAFzEw/agEE5MfJw2JLzzVXDIM8fB3hzTFS2dtr
	 Ovp5RUvygyq+2DflraBsuTI3JxSzOeoBdS6Kx0RRk4ptf20y/vyOZ6ZaI8OkHAgf38
	 d8yaP6h8Wdnhw==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH v5 03/15] rust: sync: change error type of constructor functions
Message-ID: <20230403154422.168633-4-y86-dev@protonmail.com>
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

Change the error type of the constructors of `Arc` and `UniqueArc` to be
`AllocError` instead of `Error`. This makes the API more clear as to
what can go wrong when calling `try_new` or its variants.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/sync/arc.rs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index f2f1c83d72ba..aa7135f0f238 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -17,11 +17,11 @@

 use crate::{
     bindings,
-    error::Result,
     types::{ForeignOwnable, Opaque},
 };
 use alloc::boxed::Box;
 use core::{
+    alloc::AllocError,
     marker::{PhantomData, Unsize},
     mem::{ManuallyDrop, MaybeUninit},
     ops::{Deref, DerefMut},
@@ -149,7 +149,7 @@ unsafe impl<T: ?Sized + Sync + Send> Sync for Arc<T> {}

 impl<T> Arc<T> {
     /// Constructs a new reference counted instance of `T`.
-    pub fn try_new(contents: T) -> Result<Self> {
+    pub fn try_new(contents: T) -> Result<Self, AllocError> {
         // INVARIANT: The refcount is initialised to a non-zero value.
         let value =3D ArcInner {
             // SAFETY: There are no safety requirements for this FFI call.
@@ -469,7 +469,7 @@ pub struct UniqueArc<T: ?Sized> {

 impl<T> UniqueArc<T> {
     /// Tries to allocate a new [`UniqueArc`] instance.
-    pub fn try_new(value: T) -> Result<Self> {
+    pub fn try_new(value: T) -> Result<Self, AllocError> {
         Ok(Self {
             // INVARIANT: The newly-created object has a ref-count of 1.
             inner: Arc::try_new(value)?,
@@ -477,7 +477,7 @@ impl<T> UniqueArc<T> {
     }

     /// Tries to allocate a new [`UniqueArc`] instance whose contents are =
not initialised yet.
-    pub fn try_new_uninit() -> Result<UniqueArc<MaybeUninit<T>>> {
+    pub fn try_new_uninit() -> Result<UniqueArc<MaybeUninit<T>>, AllocErro=
r> {
         Ok(UniqueArc::<MaybeUninit<T>> {
             // INVARIANT: The newly-created object has a ref-count of 1.
             inner: Arc::try_new(MaybeUninit::uninit())?,
--
2.39.2


