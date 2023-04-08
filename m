Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE141841
	for <patches@lists.linux.dev>; Sat,  8 Apr 2023 12:25:43 +0000 (UTC)
Date: Sat, 08 Apr 2023 12:25:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680956741; x=1681215941;
	bh=35ec0Ze6x4vGPDCyxTq1eqzjMeEQtTPCRJPMgIkdSpQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=FYV5X6kKzH5aJLDgjemr4GztE2oe4Czvvz/JEScQv86bVFwyj0bZQ1YRQ1hXChD9m
	 3TfJzwTozZAHgbsWWOZFmPzRq+oxCGxUubp6HDE1DA/kfD2Jl3me0k1jwGXVMFL7z1
	 G3PtJmyAHAvFh4bu8fmOqU6fUhvBZ4zTl2OnBlgsn5wTU0dbtv4rMv8j6Hgx+MG3iv
	 /jmRBJoVztPeM8++iv/hgDoghU2IlJTC/z5XU/5+0xPRd8G9p/+5WdM5jBE9tJkzxm
	 bWSk1b7oP1fY8hLYYx7rVrfQl3Efnj57NMVrR1orrmdGJfkmE2/0WKmBJ1K/XEuJWK
	 usrgK6JiuE8fg==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>, Andreas Hindborg <nmi@metaspace.dk>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Wedson Almeida Filho <walmeida@microsoft.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH v7 04/15] rust: sync: add `assume_init` to `UniqueArc`
Message-ID: <20230408122429.1103522-5-y86-dev@protonmail.com>
In-Reply-To: <20230408122429.1103522-1-y86-dev@protonmail.com>
References: <20230408122429.1103522-1-y86-dev@protonmail.com>
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


