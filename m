Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A611A749B
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 19:35:59 +0000 (UTC)
Date: Wed, 05 Apr 2023 19:35:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680723351; x=1680982551;
	bh=/3m6gBMij6Ax7PcQaOILDRRx86A/6McrrYe3eb+j60U=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=d5UfZ3bOq8HhPP+stoilwMW+1Gwq/mN7HWJhmR+DzEOP7+jOZScHJaoU0RLORcrSo
	 b27+pNIWMk2q5iDrnfUueRCAuLsc+94p3nquMLIdamW9dAPu/vKRxfOGpvTZIhzCZ2
	 2PnsqfKZUjrOcnnR7u+LTQFl/CJU28DBs6DNRUWwP1OB/Lfvw80VUShqIsvuQ6T0HZ
	 TehbYVMMxqSXg2tQGxCsyiKgfoGGYwRnzcdzY4h7J6pVK1Dm3nWAHeq7xRJanuqIWX
	 diCA3Io77s/t+JIlfQjKKJrVF5c7XzuinbQfxe6WLwxPgIweAK3CELvYPDBdYvkcpg
	 KCsOGNZGA9LBg==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>, Andreas Hindborg <nmi@metaspace.dk>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH v6 03/15] rust: sync: change error type of constructor functions
Message-ID: <20230405193445.745024-4-y86-dev@protonmail.com>
In-Reply-To: <20230405193445.745024-1-y86-dev@protonmail.com>
References: <20230405193445.745024-1-y86-dev@protonmail.com>
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
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
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


