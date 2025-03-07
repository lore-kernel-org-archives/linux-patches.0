Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBBF20D503;
	Fri,  7 Mar 2025 22:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387928; cv=none; b=QkqVeY2WpwbsU/1+NvBnOi+GMdMkXPwdsdU/q5YVWqKH6qtN21dYNQZ6ma7u6XY7/sj4HwL7tNedi3N6guX4BneF4ekNFm1sm3/0oHTefI9ahOrbc1D/r6C1S4DY/O9KjTbYgav3LgovN5/Aen5AJEnmjHs08YseKb5QWs14JAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387928; c=relaxed/simple;
	bh=nOpixD6tN41RrJzxhOAg/Npk09GzWLn23x3tvHZSuq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0bmx4W70xZVfD9vBB6na05W5LH7dK0sIUmqiMG7bnnnwFrmo4kALvTGGx5T7mg9NytKBGLrBjL7dEAPwxNLXEF5aeYcJxwNSL9rLeRLamWnGDJcyNaxrAfbdh8KqnaWUjbXzzhS8QnKfHcJl6OLUsFdpUqIRw2to+v+zO09hKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKO8D3KU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKO8D3KU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D629C4CED1;
	Fri,  7 Mar 2025 22:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387928;
	bh=nOpixD6tN41RrJzxhOAg/Npk09GzWLn23x3tvHZSuq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKO8D3KUDg40bGkKHD4ibPqGvhUof9s+ryCrB0VXyLwBkQgCaTFMzy+YPbUJNG5XP
	 7Hok3HTY2YubwYStD2OwHe3CYifgbPh2FZfPv9Tg6P1fJjMysqmsq/q1qcUhf4wNFh
	 skiL7aFgr/1RwBk1L13DfuiXS7DhxKD2gSkuz2lYPK4bZ27NwTIcvNJ2k0WwLqEnfy
	 ciQ0T+lkulLRh3gLnLelzHdDX+9lU19v02s8Cp/atqzv6hSslkdoomG42juBCfOY8l
	 OvnXwXiC1RAFJQS8pXQ48D81FuMZsF/TTyuczCrULmxEOSLFDbWZC91K/HK1AB8DVQ
	 7D0yhtZV/BKQA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 34/60] rust: alloc: introduce `ArrayLayout`
Date: Fri,  7 Mar 2025 23:49:41 +0100
Message-ID: <20250307225008.779961-35-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benno Lossin <benno.lossin@proton.me>

commit 9e7bbfa182767f638ba61dba3518ff78da9f31ff upstream.

When allocating memory for arrays using allocators, the `Layout::array`
function is typically used. It returns a result, since the given size
might be too big. However, `Vec` and its iterators store their allocated
capacity and thus they already did check that the size is not too big.

The `ArrayLayout` type provides this exact behavior, as it can be
infallibly converted into a `Layout`. Instead of a `usize` capacity,
`Vec` and other similar array-storing types can use `ArrayLayout`
instead.

Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Benno Lossin <benno.lossin@proton.me>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-16-dakr@kernel.org
[ Formatted a few comments. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc.rs        |  1 +
 rust/kernel/alloc/layout.rs | 91 +++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)
 create mode 100644 rust/kernel/alloc/layout.rs

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index 94f4de5e0cdc..c679d93b0523 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -5,6 +5,7 @@
 #[cfg(not(any(test, testlib)))]
 pub mod allocator;
 pub mod kbox;
+pub mod layout;
 pub mod vec_ext;
 
 #[cfg(any(test, testlib))]
diff --git a/rust/kernel/alloc/layout.rs b/rust/kernel/alloc/layout.rs
new file mode 100644
index 000000000000..7e0c2f46157b
--- /dev/null
+++ b/rust/kernel/alloc/layout.rs
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Memory layout.
+//!
+//! Custom layout types extending or improving [`Layout`].
+
+use core::{alloc::Layout, marker::PhantomData};
+
+/// Error when constructing an [`ArrayLayout`].
+pub struct LayoutError;
+
+/// A layout for an array `[T; n]`.
+///
+/// # Invariants
+///
+/// - `len * size_of::<T>() <= isize::MAX`.
+pub struct ArrayLayout<T> {
+    len: usize,
+    _phantom: PhantomData<fn() -> T>,
+}
+
+impl<T> Clone for ArrayLayout<T> {
+    fn clone(&self) -> Self {
+        *self
+    }
+}
+impl<T> Copy for ArrayLayout<T> {}
+
+const ISIZE_MAX: usize = isize::MAX as usize;
+
+impl<T> ArrayLayout<T> {
+    /// Creates a new layout for `[T; 0]`.
+    pub const fn empty() -> Self {
+        // INVARIANT: `0 * size_of::<T>() <= isize::MAX`.
+        Self {
+            len: 0,
+            _phantom: PhantomData,
+        }
+    }
+
+    /// Creates a new layout for `[T; len]`.
+    ///
+    /// # Errors
+    ///
+    /// When `len * size_of::<T>()` overflows or when `len * size_of::<T>() > isize::MAX`.
+    pub const fn new(len: usize) -> Result<Self, LayoutError> {
+        match len.checked_mul(core::mem::size_of::<T>()) {
+            Some(len) if len <= ISIZE_MAX => {
+                // INVARIANT: We checked above that `len * size_of::<T>() <= isize::MAX`.
+                Ok(Self {
+                    len,
+                    _phantom: PhantomData,
+                })
+            }
+            _ => Err(LayoutError),
+        }
+    }
+
+    /// Creates a new layout for `[T; len]`.
+    ///
+    /// # Safety
+    ///
+    /// `len` must be a value, for which `len * size_of::<T>() <= isize::MAX` is true.
+    pub unsafe fn new_unchecked(len: usize) -> Self {
+        // INVARIANT: By the safety requirements of this function
+        // `len * size_of::<T>() <= isize::MAX`.
+        Self {
+            len,
+            _phantom: PhantomData,
+        }
+    }
+
+    /// Returns the number of array elements represented by this layout.
+    pub const fn len(&self) -> usize {
+        self.len
+    }
+
+    /// Returns `true` when no array elements are represented by this layout.
+    pub const fn is_empty(&self) -> bool {
+        self.len == 0
+    }
+}
+
+impl<T> From<ArrayLayout<T>> for Layout {
+    fn from(value: ArrayLayout<T>) -> Self {
+        let res = Layout::array::<T>(value.len);
+        // SAFETY: By the type invariant of `ArrayLayout` we have
+        // `len * size_of::<T>() <= isize::MAX` and thus the result must be `Ok`.
+        unsafe { res.unwrap_unchecked() }
+    }
+}
-- 
2.48.1

