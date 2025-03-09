Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE68C1AC43A;
	Sun,  9 Mar 2025 09:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513806; cv=none; b=a09K52TqUN8vSyR01zUHLrv+6a1aYzTkgMN2MQEbCtwQToVxOkYPgP8kLfD7LXdZ1mZdb+d1zV5+k1yxuAxzBs4wO5Vv8TOyypqb9fLnIO1NDVNuEA3FN+BAc6UkOB16Q9gvXSPYoObOrZOr3YINmaIwg/96fkQwYb39fgJGvHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513806; c=relaxed/simple;
	bh=hMeaGpA9Me/VZqO4+cLZiKoMPl6HN7q11RvKUfNR29M=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=pHSVvfn/O+i0CRKgAIjwb/LJMeM5fNc7i9KgEHJIUzdMR1DzT7/qBLF7F4DKMsn5RBow+s9rp33mhzCnrghj02TEzFRF4gyqDD/hmMgLy3bXJrLWFFujd+PJMRdA5mp+E5P9q8mOnqWk8xt88vTqDZnTr3CoPRDAfBU0+Lq9Ykg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Edn6W7C4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Edn6W7C4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9E1C4CEEC;
	Sun,  9 Mar 2025 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513806;
	bh=hMeaGpA9Me/VZqO4+cLZiKoMPl6HN7q11RvKUfNR29M=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Edn6W7C4fmywYVX8umdqutBDnqlqjyeGUc4nMiz9BN4DC7h0QufBggeFAhT7CWsc8
	 i/6RhNh+Cy7iqVzZ8920067OkU7jFIIqD5UoSM+IHSl+vdIW0x50AHbUQNRwYa9oOC
	 tPi64UXN5oRQV7tAmLwsxsPHpHGfIO8t1qTJzVA8=
Subject: Patch "rust: map `__kernel_size_t` and friends also to usize/isize" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org,tmgross@umich.edu
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:51 +0100
In-Reply-To: <20250307225008.779961-59-ojeda@kernel.org>
Message-ID: <2025030951-reversion-unclad-0236@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    rust: map `__kernel_size_t` and friends also to usize/isize

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-map-__kernel_size_t-and-friends-also-to-usize-isize.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121513-greg=kroah.com@vger.kernel.org Fri Mar  7 23:53:16 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:50:05 +0100
Subject: rust: map `__kernel_size_t` and friends also to usize/isize
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-59-ojeda@kernel.org>

From: Gary Guo <gary@garyguo.net>

commit 2fd6f55c048d0c863ffbc8590b1bd2edb5ff13e5 upstream.

Currently bindgen has special logic to recognise `size_t` and `ssize_t`
and map them to Rust `usize` and `isize`. Similarly, `ptrdiff_t` is
mapped to `isize`.

However this falls short for `__kernel_size_t`, `__kernel_ssize_t` and
`__kernel_ptrdiff_t`. To ensure that they are mapped to usize/isize
rather than 32/64 integers depending on platform, blocklist them in
bindgen parameters and manually provide their definition.

Signed-off-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Link: https://lore.kernel.org/r/20240913213041.395655-3-gary@garyguo.net
[ Formatted comment. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/bindgen_parameters |    5 +++++
 rust/bindings/lib.rs    |    5 +++++
 rust/uapi/lib.rs        |    5 +++++
 3 files changed, 15 insertions(+)

--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -1,5 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 
+# We want to map these types to `isize`/`usize` manually, instead of
+# define them as `int`/`long` depending on platform bitwidth.
+--blocklist-type __kernel_s?size_t
+--blocklist-type __kernel_ptrdiff_t
+
 --opaque-type xregs_state
 --opaque-type desc_struct
 --opaque-type arch_lbr_state
--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -27,6 +27,11 @@
 #[allow(dead_code)]
 #[allow(clippy::undocumented_unsafe_blocks)]
 mod bindings_raw {
+    // Manual definition for blocklisted types.
+    type __kernel_size_t = usize;
+    type __kernel_ssize_t = isize;
+    type __kernel_ptrdiff_t = isize;
+
     // Use glob import here to expose all helpers.
     // Symbols defined within the module will take precedence to the glob import.
     pub use super::bindings_helper::*;
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -25,4 +25,9 @@
     unsafe_op_in_unsafe_fn
 )]
 
+// Manual definition of blocklisted types.
+type __kernel_size_t = usize;
+type __kernel_ssize_t = isize;
+type __kernel_ptrdiff_t = isize;
+
 include!(concat!(env!("OBJTREE"), "/rust/uapi/uapi_generated.rs"));


Patches currently in stable-queue which might be from ojeda@kernel.org are

queue-6.12/drm-panic-avoid-reimplementing-iterator-find.patch
queue-6.12/documentation-rust-add-coding-guidelines-on-lints.patch
queue-6.12/rust-provide-proper-code-documentation-titles.patch
queue-6.12/rust-alloc-make-allocator-module-public.patch
queue-6.12/rust-alloc-remove-vecext-extension.patch
queue-6.12/rust-alloc-implement-reallocfunc.patch
queue-6.12/rust-alloc-separate-aligned_size-from-krealloc_aligned.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_comment-lint.patch
queue-6.12/rust-alloc-update-module-comment-of-alloc.rs.patch
queue-6.12/rust-kbuild-expand-rusttest-target-for-macros.patch
queue-6.12/rust-error-use-core-alloc-layouterror.patch
queue-6.12/rust-str-test-replace-alloc-format.patch
queue-6.12/loongarch-use-asm_reachable.patch
queue-6.12/rust-alloc-implement-allocator-for-kmalloc.patch
queue-6.12/rust-alloc-implement-collect-for-intoiter.patch
queue-6.12/rust-alloc-introduce-arraylayout.patch
queue-6.12/rust-alloc-implement-vmalloc-allocator.patch
queue-6.12/documentation-rust-discuss-in-the-guidelines.patch
queue-6.12/rust-error-check-for-config-test-in-error-name.patch
queue-6.12/rust-enable-clippy-ignored_unit_patterns-lint.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_doc-lint.patch
queue-6.12/rust-alloc-add-box-to-prelude.patch
queue-6.12/kbuild-rust-remove-the-alloc-crate-and-globalalloc.patch
queue-6.12/rust-alloc-add-allocator-trait.patch
queue-6.12/rust-treewide-switch-to-our-kernel-box-type.patch
queue-6.12/rust-introduce-.clippy.toml.patch
queue-6.12/rust-alloc-rename-kernelallocator-to-kmalloc.patch
queue-6.12/rust-alloc-implement-cmalloc-in-module-allocator_test.patch
queue-6.12/drm-panic-allow-verbose-version-check.patch
queue-6.12/rust-map-__kernel_size_t-and-friends-also-to-usize-isize.patch
queue-6.12/rust-alloc-add-module-allocator_test.patch
queue-6.12/rust-replace-clippy-dbg_macro-with-disallowed_macros.patch
queue-6.12/rust-alloc-add-__gfp_nowarn-to-flags.patch
queue-6.12/rust-enable-clippy-s-check-private-items.patch
queue-6.12/rust-error-make-conversion-functions-public.patch
queue-6.12/rust-sort-global-rust-flags.patch
queue-6.12/rust-alloc-implement-contains-for-flags.patch
queue-6.12/rust-init-remove-unneeded.patch
queue-6.12/rust-use-custom-ffi-integer-types.patch
queue-6.12/rust-sync-remove-unneeded.patch
queue-6.12/rust-treewide-switch-to-the-kernel-vec-type.patch
queue-6.12/rust-alloc-implement-kvmalloc-allocator.patch
queue-6.12/drm-panic-correctly-indent-continuation-of-line-in-list-item.patch
queue-6.12/rust-alloc-implement-kernel-vec-type.patch
queue-6.12/rust-workqueue-remove-unneeded.patch
queue-6.12/rust-error-optimize-error-type-to-use-nonzero.patch
queue-6.12/drm-panic-remove-unnecessary-borrow-in-alignment_pattern.patch
queue-6.12/rust-alloc-remove-extension-of-std-s-box.patch
queue-6.12/rust-block-fix-formatting-in-gendisk-doc.patch
queue-6.12/rust-enable-rustdoc-unescaped_backticks-lint.patch
queue-6.12/rust-fix-size_t-in-bindgen-prototypes-of-c-builtins.patch
queue-6.12/rust-enable-clippy-undocumented_unsafe_blocks-lint.patch
queue-6.12/rust-alloc-add-vec-to-prelude.patch
queue-6.12/rust-alloc-implement-intoiterator-for-vec.patch
queue-6.12/rust-alloc-implement-kernel-box.patch
queue-6.12/drm-panic-remove-redundant-field-when-assigning-value.patch
queue-6.12/rust-types-avoid-repetition-in-as-from-bytes-impls.patch
queue-6.12/rust-start-using-the-attribute.patch
queue-6.12/drm-panic-allow-verbose-boolean-for-clarity.patch
queue-6.12/maintainers-add-entry-for-the-rust-alloc-module.patch
queue-6.12/rust-alloc-fix-arraylayout-allocations.patch
queue-6.12/drm-panic-prefer-eliding-lifetimes.patch
