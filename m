Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A5B1AC43A;
	Sun,  9 Mar 2025 09:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513770; cv=none; b=e/IElP7DGe5v81GvYm8NX6xfNa33sV/QLxVA/HgfQ0qgr+qEvSduLr60GJsi/e2jOMi++62Mma8RgqunRrbf1n7McQeP81p+vfG9/n5JrcBJva+kpopgiAJF+xQ+BxGVC7ifS/W4mCLoHl/LiErZCk20t0MghzBvNowEiOLzR+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513770; c=relaxed/simple;
	bh=fM204/hgAFJDPwaLJdqDuHo0lT7TuOul3ai4NwGhAHc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=sziUZi5JNH0aFrMzebFkltPthK/3YeLT6G9Qg8h0sPeJKdqjF2X5ktCpDnEHFc2S5kvrkaeXOGN0MG2WczRLi1RN7It/8YkR1H8QulO82ej0qH9/GDPaBj3wd4wajQo+H4esMAWNDAsEUNB7cg47N4hWjyNgKgYtdT+YZzAN0Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbeB8zXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbeB8zXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2F8C4CEE5;
	Sun,  9 Mar 2025 09:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513769;
	bh=fM204/hgAFJDPwaLJdqDuHo0lT7TuOul3ai4NwGhAHc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=ZbeB8zXRypZa4daiks9IoJRES969oc6kN4qo1jTbmbb+AkKjdLwggLPw9Stidw8TR
	 tLvnHH66bZPQdF1EEL3OkUmVUzdKivw2f8/SWUQtuxzDA/5zyka058wgP/b4WpHy8A
	 ESzeYfDfcugMc2AC/Y4uotBDeUaH21VQjB76vXJQ=
Subject: Patch "rust: enable `clippy::unnecessary_safety_comment` lint" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org,tmgross@umich.edu,vincenzopalazzodev@gmail.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:50 +0100
In-Reply-To: <20250307225008.779961-6-ojeda@kernel.org>
Message-ID: <2025030950-twentieth-unwanted-8002@gregkh>
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

    rust: enable `clippy::unnecessary_safety_comment` lint

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-enable-clippy-unnecessary_safety_comment-lint.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121460-greg=kroah.com@vger.kernel.org Fri Mar  7 23:50:52 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:12 +0100
Subject: rust: enable `clippy::unnecessary_safety_comment` lint
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-6-ojeda@kernel.org>

From: Miguel Ojeda <ojeda@kernel.org>

commit c28bfe76e4ba707775a205b0274710de7aa1e31c upstream.

In Rust 1.67.0, Clippy added the `unnecessary_safety_comment` lint [1],
which is the "inverse" of `undocumented_unsafe_blocks`: it finds places
where safe code has a `// SAFETY` comment attached.

The lint currently finds 3 places where we had such mistakes, thus it
seems already quite useful.

Thus clean those and enable it.

Link: https://rust-lang.github.io/rust-clippy/master/index.html#/unnecessary_safety_comment [1]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-6-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                 |    1 +
 rust/kernel/sync/arc.rs  |    2 +-
 rust/kernel/workqueue.rs |    4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -459,6 +459,7 @@ export rust_common_flags := --edition=20
 			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \
+			    -Wclippy::unnecessary_safety_comment \
 			    -Wrustdoc::missing_crate_level_docs
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -338,7 +338,7 @@ impl<T: 'static> ForeignOwnable for Arc<
     }
 
     unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> ArcBorrow<'a, T> {
-        // SAFETY: By the safety requirement of this function, we know that `ptr` came from
+        // By the safety requirement of this function, we know that `ptr` came from
         // a previous call to `Arc::into_foreign`.
         let inner = NonNull::new(ptr as *mut ArcInner<T>).unwrap();
 
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -526,7 +526,7 @@ where
     T: HasWork<T, ID>,
 {
     unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
-        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
+        // The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
         let ptr = ptr as *mut Work<T, ID>;
         // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
         let ptr = unsafe { T::work_container_of(ptr) };
@@ -573,7 +573,7 @@ where
     T: HasWork<T, ID>,
 {
     unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
-        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
+        // The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
         let ptr = ptr as *mut Work<T, ID>;
         // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
         let ptr = unsafe { T::work_container_of(ptr) };


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
