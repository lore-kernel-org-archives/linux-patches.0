Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F05A18BC36;
	Fri,  7 Mar 2025 22:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387892; cv=none; b=WOBtPoPHO90pOPCX3s6kvIQkjfE9YPLI0sVki/TRLUF6VLt7BEt4T8cifir1/ytMw7wE3rxqibFPjQ0r5hjCU6AFFteAA0mbxnRtPAQFg3/Otd0rIvOjloj5m9TE8Rdqto+KB7oOkj/t6nka6ytW71i+XmOd8tLK5pOiGlZBuIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387892; c=relaxed/simple;
	bh=dVNgUt810C/rJwZVaRG0Ia5N9+h4eBDEIQikpsZjg50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuFbDKuMlFOa+LldV7bdTcDqmueOtH8MB4Ok9MoTPI1ptUwT+GQUf3ye+CVbel9ScEHg+/Rpkr2Oc/TAtDd2EZhKPQJ60t+fiMJK+9nj95CL5v6gSoYjxXcqSWA6u9AyOWkWAhvwx1a+DCyZJRVDOuAT6FvB+DmhdDDlORZGlL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0B7ynL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0B7ynL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACB2C4CED1;
	Fri,  7 Mar 2025 22:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387890;
	bh=dVNgUt810C/rJwZVaRG0Ia5N9+h4eBDEIQikpsZjg50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0B7ynL81wfUZCDrPolqwxXrJTqLzmJRVZmpbYQcgiUdixj9EKugXzeEnx/bhpMFi
	 BOH3n2Zb01ZCUtR7H15FHWPut73atXKJIQiPYdCOZEtM4gxOg3kzJXpunXP/6DRw5y
	 GKGi3qMKMeKwsK19ZT5WeLHEd6SSqldDotX2hq6zL4yUeiDKYJbM1LBd+dohGW283v
	 XfOAWowmlgbBGFA3cnGEEp1dpzsMnsxMEHBfZUy3wznFZb0nHakOkyK8oIiCtIgCWD
	 lfFiro+K4jCmsRfPYPWZM4g5Z7MxVtEUi90u3nlOp2NuV+wQJ3tjlMiajHyCF6WRYM
	 kAqTc+jywUxMg==
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
Subject: [PATCH 6.12.y 20/60] rust: alloc: add `Allocator` trait
Date: Fri,  7 Mar 2025 23:49:27 +0100
Message-ID: <20250307225008.779961-21-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

commit b7a084ba4fbb8f416ce8d19c93a3a2bee63c9c89 upstream.

Add a kernel specific `Allocator` trait, that in contrast to the one in
Rust's core library doesn't require unstable features and supports GFP
flags.

Subsequent patches add the following trait implementors: `Kmalloc`,
`Vmalloc` and `KVmalloc`.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-2-dakr@kernel.org
[ Fixed typo. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc.rs | 101 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index 1966bd407017..998779cc6976 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -11,6 +11,7 @@
 /// Indicates an allocation error.
 #[derive(Copy, Clone, PartialEq, Eq, Debug)]
 pub struct AllocError;
+use core::{alloc::Layout, ptr::NonNull};
 
 /// Flags to be used when allocating memory.
 ///
@@ -86,3 +87,103 @@ pub mod flags {
     /// small allocations.
     pub const GFP_NOWAIT: Flags = Flags(bindings::GFP_NOWAIT);
 }
+
+/// The kernel's [`Allocator`] trait.
+///
+/// An implementation of [`Allocator`] can allocate, re-allocate and free memory buffers described
+/// via [`Layout`].
+///
+/// [`Allocator`] is designed to be implemented as a ZST; [`Allocator`] functions do not operate on
+/// an object instance.
+///
+/// In order to be able to support `#[derive(SmartPointer)]` later on, we need to avoid a design
+/// that requires an `Allocator` to be instantiated, hence its functions must not contain any kind
+/// of `self` parameter.
+///
+/// # Safety
+///
+/// - A memory allocation returned from an allocator must remain valid until it is explicitly freed.
+///
+/// - Any pointer to a valid memory allocation must be valid to be passed to any other [`Allocator`]
+///   function of the same type.
+///
+/// - Implementers must ensure that all trait functions abide by the guarantees documented in the
+///   `# Guarantees` sections.
+pub unsafe trait Allocator {
+    /// Allocate memory based on `layout` and `flags`.
+    ///
+    /// On success, returns a buffer represented as `NonNull<[u8]>` that satisfies the layout
+    /// constraints (i.e. minimum size and alignment as specified by `layout`).
+    ///
+    /// This function is equivalent to `realloc` when called with `None`.
+    ///
+    /// # Guarantees
+    ///
+    /// When the return value is `Ok(ptr)`, then `ptr` is
+    /// - valid for reads and writes for `layout.size()` bytes, until it is passed to
+    ///   [`Allocator::free`] or [`Allocator::realloc`],
+    /// - aligned to `layout.align()`,
+    ///
+    /// Additionally, `Flags` are honored as documented in
+    /// <https://docs.kernel.org/core-api/mm-api.html#mm-api-gfp-flags>.
+    fn alloc(layout: Layout, flags: Flags) -> Result<NonNull<[u8]>, AllocError> {
+        // SAFETY: Passing `None` to `realloc` is valid by its safety requirements and asks for a
+        // new memory allocation.
+        unsafe { Self::realloc(None, layout, Layout::new::<()>(), flags) }
+    }
+
+    /// Re-allocate an existing memory allocation to satisfy the requested `layout`.
+    ///
+    /// If the requested size is zero, `realloc` behaves equivalent to `free`.
+    ///
+    /// If the requested size is larger than the size of the existing allocation, a successful call
+    /// to `realloc` guarantees that the new or grown buffer has at least `Layout::size` bytes, but
+    /// may also be larger.
+    ///
+    /// If the requested size is smaller than the size of the existing allocation, `realloc` may or
+    /// may not shrink the buffer; this is implementation specific to the allocator.
+    ///
+    /// On allocation failure, the existing buffer, if any, remains valid.
+    ///
+    /// The buffer is represented as `NonNull<[u8]>`.
+    ///
+    /// # Safety
+    ///
+    /// - If `ptr == Some(p)`, then `p` must point to an existing and valid memory allocation
+    ///   created by this [`Allocator`]; if `old_layout` is zero-sized `p` does not need to be a
+    ///   pointer returned by this [`Allocator`].
+    /// - `ptr` is allowed to be `None`; in this case a new memory allocation is created and
+    ///   `old_layout` is ignored.
+    /// - `old_layout` must match the `Layout` the allocation has been created with.
+    ///
+    /// # Guarantees
+    ///
+    /// This function has the same guarantees as [`Allocator::alloc`]. When `ptr == Some(p)`, then
+    /// it additionally guarantees that:
+    /// - the contents of the memory pointed to by `p` are preserved up to the lesser of the new
+    ///   and old size, i.e. `ret_ptr[0..min(layout.size(), old_layout.size())] ==
+    ///   p[0..min(layout.size(), old_layout.size())]`.
+    /// - when the return value is `Err(AllocError)`, then `ptr` is still valid.
+    unsafe fn realloc(
+        ptr: Option<NonNull<u8>>,
+        layout: Layout,
+        old_layout: Layout,
+        flags: Flags,
+    ) -> Result<NonNull<[u8]>, AllocError>;
+
+    /// Free an existing memory allocation.
+    ///
+    /// # Safety
+    ///
+    /// - `ptr` must point to an existing and valid memory allocation created by this [`Allocator`];
+    ///   if `old_layout` is zero-sized `p` does not need to be a pointer returned by this
+    ///   [`Allocator`].
+    /// - `layout` must match the `Layout` the allocation has been created with.
+    /// - The memory allocation at `ptr` must never again be read from or written to.
+    unsafe fn free(ptr: NonNull<u8>, layout: Layout) {
+        // SAFETY: The caller guarantees that `ptr` points at a valid allocation created by this
+        // allocator. We are passing a `Layout` with the smallest possible alignment, so it is
+        // smaller than or equal to the alignment previously used with this allocation.
+        let _ = unsafe { Self::realloc(Some(ptr), Layout::new::<()>(), layout, Flags(0)) };
+    }
+}
-- 
2.48.1

