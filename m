Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38384AD24
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 22:33:17 +0000 (UTC)
Date: Wed, 29 Mar 2023 22:33:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680129195; x=1680388395;
	bh=V+3/FcGLR6mUBShB+6Z9iCT8/lNGpbiYW8ilej7HttM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=bDcPvqDeoH3HgHItPWiY5emWTJ2TX1MqqC7sOLgsCNM8WmYcK/611sDpdtejDg9vS
	 CD8Uz3Hwdb7Q9J60WqcXrp0iCYnz/5jejXKuwNbraYsuR0pz0CgmfM/jQAM0meV9NK
	 EcW/syx2qDYE2D0ZGrv+njm9ulKY2QONkjjIBI4CcAQkx4OOFEFsWgL2H6KMTj8M8F
	 +9h6gMRCzyieRB66Hz34ZmRHoPQBUCF8jLbwAJLsjhARLowJJof0wyKAVV+o1dTk6c
	 jiKOnUKHa05PP1d8O8K5ZWVQaWRCG8N9IsrwDv+zdYLDx5c1GPnkxX+jzVvWvnUo6r
	 3YK7ZkTB84MUQ==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: y86-dev@protonmail.com
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [PATCH v3 03/13] rust: types: add `Opaque::raw_get`
Message-ID: <20230329223239.138757-4-y86-dev@protonmail.com>
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

This function mirrors `UnsafeCell::raw_get`. It avoids creating a
reference and allows solely using raw pointers.
The `pin-init` API will be using this, since uninitialized memory
requires raw pointers.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
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


