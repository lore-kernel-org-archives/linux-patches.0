Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E76222154C;
	Mon, 10 Mar 2025 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627286; cv=none; b=P5CP8ncOXB6+Oty1A2JW0NfuzM+wpd7RZC0iCMG8sl77qUMubtmGmFdzNbLmi1D6TxvlC/BmrPm+zV5RYP9hMLOAnnbhaoAwMYo0M9pR+1+FLHS9U38/6zMz+gDqCDsbnw/SlJ6piDwrx1Rrr2CzOLJu4d5Kcqi8rJR/vwCjShI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627286; c=relaxed/simple;
	bh=v/uLL9o937fQHEh2taIWHhETdUQ8cA8rEWrrDpg1msY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpFzDPiMG+RKXB2pyDQpsCmugxBDwuQ+9ALd5wW383MlvkwvL9fJf6BvrniRkZIVN+6S9ovIIQn7y82g3TxjOUNPk3tDg4AgdsQsnOEEnBUSS0QFdOhSv4E5pmlaxZsb3/uGdzI9drT8o3r3sOWWNHLiEgAaw6igQrRNSYYNXOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rG+CEe5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rG+CEe5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B2BC4CEE5;
	Mon, 10 Mar 2025 17:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627286;
	bh=v/uLL9o937fQHEh2taIWHhETdUQ8cA8rEWrrDpg1msY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rG+CEe5XoVObYjPf/oahrReyd2iYpsSUZ7NXtEsXFJmuliyKARWTfOVTuBr6pvJSt
	 S5wypGd4s4TnI85GXq1buBY06Ps4qs/0WaEvpjGRPdFEMzQwBguh/IZw7DP7lljTRG
	 m6z0ily++XkcrjLBOswACdVDia1ru2EDzx/uD2TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Benno Lossin <benno.lossin@proton.me>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 045/269] rust: alloc: introduce `ArrayLayout`
Date: Mon, 10 Mar 2025 18:03:18 +0100
Message-ID: <20250310170459.518866042@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc.rs        |    1 
 rust/kernel/alloc/layout.rs |   91 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)
 create mode 100644 rust/kernel/alloc/layout.rs

--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -5,6 +5,7 @@
 #[cfg(not(any(test, testlib)))]
 pub mod allocator;
 pub mod kbox;
+pub mod layout;
 pub mod vec_ext;
 
 #[cfg(any(test, testlib))]
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


