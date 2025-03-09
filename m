Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313BF1AE00E;
	Sun,  9 Mar 2025 09:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513764; cv=none; b=oOdCozCAc2X2Ug05RfktbAYQ6h9ubMBov4Wxx7oTru9aQwN3XlVcB9IDwiywb8A/RV+KBo/Em/ImV9i1paxjTwYzRI2Ty6VvDzpPbGgmhShWMbqTvYsxLrc3+E2ui6AQx/MEMEvv8mINU/v6BQAIKECryIupke50vF4I00OYDoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513764; c=relaxed/simple;
	bh=67nPWCwLV48Yx6H3WYqUoIQA0TjHAm4NPyadO5/ZuX4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=DSMJtnK+rz92LOFGb4+aHh31WzFqRecFUGOp3nXgyVxMJqjnVz6zmsmi3v+KOkf4ioEUAL0RhFRtHh3vIhT/L6cVONJCyPYZ/XnkW+vD9SDy7sf/H9ELWy2nGdyiZXrc0b3J7TKkgq7Ir9QkydHGr98QuBX3O94C6RAH1FoQ2jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/yRFZX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/yRFZX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDCAC4CEE5;
	Sun,  9 Mar 2025 09:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513763;
	bh=67nPWCwLV48Yx6H3WYqUoIQA0TjHAm4NPyadO5/ZuX4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=o/yRFZX2ftpXVYqJVWsoMsRHdNGuPY3R+0reZOWGZ2MNoEC9ExS0UDRqyFUAxyVoF
	 B0hAk9oPQVt8G/ONdyyZThl07pqYsl3FF+IzNHYLdBo43+3oseLr5R6ex04Yfj83f0
	 hgDZWonzGwyx95hFd/e6EAmpC46A8m5fbED2LBTs=
Subject: Patch "rust: alloc: Fix `ArrayLayout` allocations" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gregkh@linuxfoundation.org,hi@alyssa.is,j@jannau.net,lina@asahilina.net,neal@gompa.dev,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:49 +0100
In-Reply-To: <20250307225008.779961-61-ojeda@kernel.org>
Message-ID: <2025030949-encrust-litigator-a85c@gregkh>
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

    rust: alloc: Fix `ArrayLayout` allocations

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-alloc-fix-arraylayout-allocations.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121515-greg=kroah.com@vger.kernel.org Fri Mar  7 23:53:26 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:50:07 +0100
Subject: rust: alloc: Fix `ArrayLayout` allocations
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-61-ojeda@kernel.org>

From: Asahi Lina <lina@asahilina.net>

commit b7ed2b6f4e8d7f64649795e76ee9db67300de8eb upstream.

We were accidentally allocating a layout for the *square* of the object
size due to a variable shadowing mishap.

Fixes memory bloat and page allocation failures in drm/asahi.

Reported-by: Janne Grunau <j@jannau.net>
Fixes: 9e7bbfa18276 ("rust: alloc: introduce `ArrayLayout`")
Signed-off-by: Asahi Lina <lina@asahilina.net>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Link: https://lore.kernel.org/r/20241123-rust-fix-arraylayout-v1-1-197e64c95bd4@asahilina.net
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc/layout.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/alloc/layout.rs
+++ b/rust/kernel/alloc/layout.rs
@@ -45,7 +45,7 @@ impl<T> ArrayLayout<T> {
     /// When `len * size_of::<T>()` overflows or when `len * size_of::<T>() > isize::MAX`.
     pub const fn new(len: usize) -> Result<Self, LayoutError> {
         match len.checked_mul(core::mem::size_of::<T>()) {
-            Some(len) if len <= ISIZE_MAX => {
+            Some(size) if size <= ISIZE_MAX => {
                 // INVARIANT: We checked above that `len * size_of::<T>() <= isize::MAX`.
                 Ok(Self {
                     len,


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
