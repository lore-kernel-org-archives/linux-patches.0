Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A48D18BC36;
	Fri,  7 Mar 2025 22:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387893; cv=none; b=c7dHsye9EANuTuYvh/GJuhu95gSD4FS8fY2mqhJfbEn21mHWEbdIOH9m0fK96q3Wd7nUf3QKNxQpVOwXi9Ix1e1KKS4u8l0YDP+sBUNKsaolRdPEMfN8La2OGqJtRBltZ+IETWzdmtGd3hduxtrmUQbs3yr/UsULZtTn9PtNRF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387893; c=relaxed/simple;
	bh=Sy0ODO6cjtKhF3ADgoqsNZvfBB5PSN1mZU/b2+88z5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPGOR2YJCWOKjaG/card9wT6mR0Xuaj9YAzGsCnobXSMzmT+cWAjN1injuy46oGV6mcPLFLKRERf83ma/7gwIRpN1iifuakLimPdMHLPoVZYCoRGw92Ee1ljtgl2TPf9QANwksswe1RcIp7qVPujcAoC6FAbrG7pmr3vGHLD0eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pEUugQ7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pEUugQ7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49513C4CEE3;
	Fri,  7 Mar 2025 22:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387893;
	bh=Sy0ODO6cjtKhF3ADgoqsNZvfBB5PSN1mZU/b2+88z5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEUugQ7OE3ps1hblCFyjIfRjLd9pBKdwNsqqGGWqNNBklx7MuLGJP8Xdtyj8cVUMx
	 HYUf3Ok7MnXxdRwkM6+/vb7vD83J3o4fu+VfqZzU+sP173H6skMXH30FrRujzQH8/X
	 TxHDT/plehOSXlthvQm6R56XIov0zeUBNuCD0/hgCLKyLaGnPY9AgMiBgR3PeN0IJf
	 JLHbtYu4jBTgSRTAyF9g4Up8DUqY/wwZgFKhcoHYgFtgV/xbeNMBwnWcUJDQfGppzj
	 wOL9B9PkxhtzjiHjRmmqghaVM7XtE8/UgEy6VekoFaUcOwKpIm54mrzZu7PqQYZEaW
	 HWkwm8PoU5/CQ==
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
Subject: [PATCH 6.12.y 21/60] rust: alloc: separate `aligned_size` from `krealloc_aligned`
Date: Fri,  7 Mar 2025 23:49:28 +0100
Message-ID: <20250307225008.779961-22-ojeda@kernel.org>
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

commit a654a6e09644266e38ac05415ef7737d299c4497 upstream.

Separate `aligned_size` from `krealloc_aligned`.

Subsequent patches implement `Allocator` derivates, such as `Kmalloc`,
that require `aligned_size` and replace the original `krealloc_aligned`.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-3-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc/allocator.rs | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index 91216b36af69..765f72d5bc21 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -8,6 +8,17 @@
 
 struct KernelAllocator;
 
+/// Returns a proper size to alloc a new object aligned to `new_layout`'s alignment.
+fn aligned_size(new_layout: Layout) -> usize {
+    // Customized layouts from `Layout::from_size_align()` can have size < align, so pad first.
+    let layout = new_layout.pad_to_align();
+
+    // Note that `layout.size()` (after padding) is guaranteed to be a multiple of `layout.align()`
+    // which together with the slab guarantees means the `krealloc` will return a properly aligned
+    // object (see comments in `kmalloc()` for more information).
+    layout.size()
+}
+
 /// Calls `krealloc` with a proper size to alloc a new object aligned to `new_layout`'s alignment.
 ///
 /// # Safety
@@ -15,13 +26,7 @@
 /// - `ptr` can be either null or a pointer which has been allocated by this allocator.
 /// - `new_layout` must have a non-zero size.
 pub(crate) unsafe fn krealloc_aligned(ptr: *mut u8, new_layout: Layout, flags: Flags) -> *mut u8 {
-    // Customized layouts from `Layout::from_size_align()` can have size < align, so pad first.
-    let layout = new_layout.pad_to_align();
-
-    // Note that `layout.size()` (after padding) is guaranteed to be a multiple of `layout.align()`
-    // which together with the slab guarantees means the `krealloc` will return a properly aligned
-    // object (see comments in `kmalloc()` for more information).
-    let size = layout.size();
+    let size = aligned_size(new_layout);
 
     // SAFETY:
     // - `ptr` is either null or a pointer returned from a previous `k{re}alloc()` by the
-- 
2.48.1

