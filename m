Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98828F54
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 21:54:59 +0000 (UTC)
Date: Fri, 31 Mar 2023 21:54:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680299697; x=1680558897;
	bh=KCurfW5Y+j7R5fMbjmPJwPW9L2YVYu9q3k1eOHB2SiI=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=wxkdvrmXC/k4XiTyxLpBUK+Cqntvv+0ZjbikRImKsmvixU+eA6ryqIS9apKPmgana
	 Ez+zL/wUyzlotdDxsXXe6U1I1SzleZvchId1yRlFa84YWxfolCXFFxyrXvHrvYdZuV
	 Ox28mr33BMaizAA1dwxWFip6LQBuGhlFUpJmfNBNBJzlGLyc9DSlDLpJPWDp9Yju1R
	 KZveNXe7wfAE1ukEJ8/KtRn0IxqwP7zGAaCqHhUQmPj13oI5t4hJzmhXsTUmepU3FP
	 A0gyw27n11yAPgKQrz7gWFlfUI8QfSfhDAHm3imB5edueXzruT809K3erxWCPhlvjb
	 iLNbQbj//iRQw==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: y86-dev@protonmail.com
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <a.hindborg@samsung.com>
Subject: [PATCH v4 15/15] rust: sync: add functions for initializing `UniqueArc<MaybeUninit<T>>`
Message-ID: <20230331215053.585759-16-y86-dev@protonmail.com>
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

Add two functions `init_with` and `pin_init_with` to
`UniqueArc<MaybeUninit<T>>` to initialize the memory of already allocated
`UniqueArc`s. This is useful when you want to allocate memory check some
condition inside of a context where allocation is forbidden and then
conditionally initialize an object.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
---
 rust/kernel/sync/arc.rs | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 5f64affd8f33..fddb7a2b1890 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -540,6 +540,30 @@ impl<T> UniqueArc<MaybeUninit<T>> {
             inner: unsafe { Arc::from_inner(inner.cast()) },
         }
     }
+
+    /// Initialize `self` using the given initializer.
+    pub fn init_with<E>(mut self, init: impl Init<T, E>) -> core::result::=
Result<UniqueArc<T>, E> {
+        // SAFETY: The supplied pointer is valid for initialization.
+        match unsafe { init.__init(self.as_mut_ptr()) } {
+            // SAFETY: Initialization completed successfully.
+            Ok(()) =3D> Ok(unsafe { self.assume_init() }),
+            Err(err) =3D> Err(err),
+        }
+    }
+
+    /// Pin-initialize `self` using the given pin-initializer.
+    pub fn pin_init_with<E>(
+        mut self,
+        init: impl PinInit<T, E>,
+    ) -> core::result::Result<Pin<UniqueArc<T>>, E> {
+        // SAFETY: The supplied pointer is valid for initialization and we=
 will later pin the value
+        // to ensure it does not move.
+        match unsafe { init.__pinned_init(self.as_mut_ptr()) } {
+            // SAFETY: Initialization completed successfully.
+            Ok(()) =3D> Ok(unsafe { self.assume_init() }.into()),
+            Err(err) =3D> Err(err),
+        }
+    }
 }

 impl<T: ?Sized> From<UniqueArc<T>> for Pin<UniqueArc<T>> {
--
2.39.2


