Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86A7749E
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 19:36:01 +0000 (UTC)
Date: Wed, 05 Apr 2023 19:35:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680723360; x=1680982560;
	bh=35ec0Ze6x4vGPDCyxTq1eqzjMeEQtTPCRJPMgIkdSpQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=k1bDJwnR1Mh5ZCHYhOi0VM/5Cn3q9uKQ1GskpL23RktG+pOXwX88WsSJXTjsDDUkF
	 c1zIHMckBu0PVMq/kK60tC8HnenbCK2ohcsaUTBBt/6uK+ZOi/MnaSqgKEGA4h83oe
	 efi1oMZyyYlrh+IVcx6MNdIfLLttFbdSIBHVfZ3Pr1S9x02NAOAi1sAtnaUNp1z21U
	 Fai1shhRJxAk4LQ2FoxPIWFwaFp2WHfctXuslED7lCPFz0NxaEygg7CwZsXy0rKiWq
	 O++PlEtzDODy8C3qq66iTxGLSiBJfEwuDRgz95b3FysbGrwUkVQViH9KW45RQfdQH7
	 uVZFH9hdVPqrA==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>, Andreas Hindborg <nmi@metaspace.dk>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Wedson Almeida Filho <walmeida@microsoft.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH v6 04/15] rust: sync: add `assume_init` to `UniqueArc`
Message-ID: <20230405193445.745024-5-y86-dev@protonmail.com>
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

Adds the `assume_init` function to `UniqueArc<MaybeUninit<T>>` that
unsafely assumes the value to be initialized and yields a value of type
`UniqueArc<T>`. This function is used when manually initializing the
pointee of an `UniqueArc`.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Reviewed-by: Wedson Almeida Filho <walmeida@microsoft.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/sync/arc.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index aa7135f0f238..eee7008e5e3e 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -489,6 +489,17 @@ impl<T> UniqueArc<MaybeUninit<T>> {
     /// Converts a `UniqueArc<MaybeUninit<T>>` into a `UniqueArc<T>` by wr=
iting a value into it.
     pub fn write(mut self, value: T) -> UniqueArc<T> {
         self.deref_mut().write(value);
+        // SAFETY: We just wrote the value to be initialized.
+        unsafe { self.assume_init() }
+    }
+
+    /// Unsafely assume that `self` is initialized.
+    ///
+    /// # Safety
+    ///
+    /// The caller guarantees that the value behind this pointer has been =
initialized. It is
+    /// *immediate* UB to call this when the value is not initialized.
+    pub unsafe fn assume_init(self) -> UniqueArc<T> {
         let inner =3D ManuallyDrop::new(self).inner.ptr;
         UniqueArc {
             // SAFETY: The new `Arc` is taking over `ptr` from `self.inner=
` (which won't be
--
2.39.2


