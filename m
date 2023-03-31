Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011D88F54
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 21:52:55 +0000 (UTC)
Date: Fri, 31 Mar 2023 21:52:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680299574; x=1680558774;
	bh=Za/m4aK9PnJEmnWJB3YV+TN80PGCqO5M482kG2Z4FzU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=bp06f2HFPkWAuvmFbH5+BrrVjCnYBmETv//Z6r7awcX8quV3JtC6GLwpBD0ePTaBi
	 YM6jx4Cu64pWBD4kceJX0BMGE2V6tuP1hNmHw/N0fF+acmzXr/fsy6RnshFkPdjWXL
	 Jb96CjH2DWAFhWw8gwsTA0qBHkJDdKtpg3Xbzw7EhCENzdg7XuS3D8fctEWEerrqJp
	 UMOkOOKdu6Ho8/nYBHJqLKhnKBdIoNUbdCI2MrlZ5kDn1jlaV7mHBDb3K0+0J3jNuk
	 3DHBySotwGyvFPp5eRWFCAWc5u6TinoRUcqrZuCltH70oEUL2YEKy2zIbgF6vAqfKJ
	 wFOnlHfHhRF2w==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: y86-dev@protonmail.com
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH v4 05/15] rust: types: add `Opaque::raw_get`
Message-ID: <20230331215053.585759-6-y86-dev@protonmail.com>
In-Reply-To: <20230331215053.585759-1-y86-dev@protonmail.com>
References: <20230331215053.585759-1-y86-dev@protonmail.com>
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

This function mirrors `UnsafeCell::raw_get`. It avoids creating a
reference and allows solely using raw pointers.
The `pin-init` API will be using this, since uninitialized memory
requires raw pointers.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/types.rs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 9d0fdbc55843..ff2b2fac951d 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -238,6 +238,14 @@ impl<T> Opaque<T> {
     pub fn get(&self) -> *mut T {
         UnsafeCell::raw_get(self.0.as_ptr())
     }
+
+    /// Gets the value behind `this`.
+    ///
+    /// This function is useful to get access to the value without creatin=
g intermediate
+    /// references.
+    pub const fn raw_get(this: *const Self) -> *mut T {
+        UnsafeCell::raw_get(this.cast::<UnsafeCell<T>>())
+    }
 }

 /// A sum type that always holds either a value of type `L` or `R`.
--
2.39.2


