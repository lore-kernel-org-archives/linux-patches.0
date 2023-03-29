Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664F929A0
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 22:33:14 +0000 (UTC)
Date: Wed, 29 Mar 2023 22:32:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680129186; x=1680388386;
	bh=sT/rlttzNSF7UJt0mIvVFloU5vc3XfQjYu+rGHSgh10=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Tn7sB5nJn4N2i7HWNE/zjhOZpRWOd6S0DMu6MgG5akvtvuHDXIMQntUfXxB7q8YFV
	 ww54eUY7myQqcAwFR7VLBnTJTYefMwwIJUSd+2AvdYeIzSkTteD8eSVbrwMy0TkhKX
	 bm6D5yLgYepYQXtfCdLvSC/u8be2ZT1Il99R8/invz9CO7ra4RUXBVVKTI1+W/eZV0
	 0GULkuJc0PI+XbKrRe06xlv447qC+Wd5YlyjG3y+uesNyVLx/41cwZmwPKvNUSg3d0
	 yjgz38rp3F0VIWeivFzxTGKsqB/1Sk1y44SEDCduZiTPdsjZ4RsqMtPW3Z7rHkVwU2
	 8adQcBLMH0gHg==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: y86-dev@protonmail.com
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [PATCH v3 02/13] rust: sync: add `assume_init` to `UniqueArc`
Message-ID: <20230329223239.138757-3-y86-dev@protonmail.com>
In-Reply-To: <20230329223239.138757-1-y86-dev@protonmail.com>
References: <20230329223239.138757-1-y86-dev@protonmail.com>
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

Adds the `assume_init` function to `UniqueArc<MaybeUninit<T>>` that
unsafely assumes the value to be initialized and yields a value of type
`UniqueArc<T>`. This function is used when manually initializing the
pointee of an `UniqueArc`.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
---
 rust/kernel/sync/arc.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index f2f1c83d72ba..16ec174637b2 100644
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


