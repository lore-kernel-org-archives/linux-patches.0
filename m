Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E071AC43A;
	Sun,  9 Mar 2025 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513824; cv=none; b=j74wOnXp3HjT+SlZlcftz9DdHv6XTW2ZrN2iSrVKnteIM2gqfjl8VB6388976iyoR/2gJpMjX42Q3knXC4JFMrOfSktxEpaK9kYEDCPtAxAhM5uU+hgxiAhNKjTCa8OQitwDRjGcBquehC0lrjHkE8woLmMx72YwXRjdlq4z7u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513824; c=relaxed/simple;
	bh=g/p7KVky5RuMKpEN7Fo1UMXZzXgEVWg0n/lgzI5ErMQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=o062QyGiirisvTaru5ZAlD4Nozc0bi/HPTcTkqy/r7qev5xRDD3kdS3SAvlz5bZtP01dvsDOisfhVDfICsZIwcLkFu6rjlGcCCAxWJ+i3SzDvhiYk9v/442HSntoyfeDticOK+6sqBbWLKFEo5pFxe9SMzz7TD9V1pILRSL16Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXu62q7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXu62q7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E37C4CEE5;
	Sun,  9 Mar 2025 09:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513824;
	bh=g/p7KVky5RuMKpEN7Fo1UMXZzXgEVWg0n/lgzI5ErMQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=MXu62q7u08b215wRenKmdz5j4ZEBkX22DnnDLIvjq4rPcgW2SXG/L+fMCU2wLJpyp
	 RmCu9u5N8nwBQWSsgl7wtgHQGcAQ/7TffowJK8uSzhS1KhOV/3tqobio4Cx6I8Asut
	 z3KCw8ula1jgBYwNq8hvifLD3xS8koUq19ieoKxY=
Subject: Patch "rust: fix size_t in bindgen prototypes of C builtins" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:51 +0100
In-Reply-To: <20250307225008.779961-58-ojeda@kernel.org>
Message-ID: <2025030951-registry-corset-5d91@gregkh>
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

    rust: fix size_t in bindgen prototypes of C builtins

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-fix-size_t-in-bindgen-prototypes-of-c-builtins.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121512-greg=kroah.com@vger.kernel.org Fri Mar  7 23:53:18 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:50:04 +0100
Subject: rust: fix size_t in bindgen prototypes of C builtins
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-58-ojeda@kernel.org>

From: Gary Guo <gary@garyguo.net>

commit 75c1fd41a671a0843b89d1526411a837a7163fa2 upstream.

Without `-fno-builtin`, for functions like memcpy/memmove (and many
others), bindgen seems to be using the clang-provided prototype. This
prototype is ABI-wise compatible, but the issue is that it does not have
the same information as the source code w.r.t. typedefs.

For example, bindgen generates the following:

    extern "C" {
        pub fn strlen(s: *const core::ffi::c_char) -> core::ffi::c_ulong;
    }

note that the return type is `c_ulong` (i.e. unsigned long), despite the
size_t-is-usize behavior (this is default, and we have not opted out
from it using --no-size_t-is-usize).

Similarly, memchr's size argument should be of type `__kernel_size_t`,
but bindgen generates `c_ulong` directly.

We want to ensure any `size_t` is translated to Rust `usize` so that we
can avoid having them be different type on 32-bit and 64-bit
architectures, and hence would require a lot of excessive type casts
when calling FFI functions.

I found that this bindgen behavior (which probably is caused by
libclang) can be disabled by `-fno-builtin`. Using the flag for compiled
code can result in less optimisation because compiler cannot assume
about their properties anymore, but this should not affect bindgen.

[ Trevor asked: "I wonder how reliable this behavior is. Maybe bindgen
  could do a better job controlling this, is there an open issue?".

  Gary replied: ..."apparently this is indeed the suggested approach in
  https://github.com/rust-lang/rust-bindgen/issues/1770". - Miguel ]

Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240913213041.395655-2-gary@garyguo.net
[ Formatted comment. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -264,7 +264,11 @@ else
 bindgen_c_flags_lto = $(bindgen_c_flags)
 endif
 
-bindgen_c_flags_final = $(bindgen_c_flags_lto) -D__BINDGEN__
+# `-fno-builtin` is passed to avoid `bindgen` from using `clang` builtin
+# prototypes for functions like `memcpy` -- if this flag is not passed,
+# `bindgen`-generated prototypes use `c_ulong` or `c_uint` depending on
+# architecture instead of generating `usize`.
+bindgen_c_flags_final = $(bindgen_c_flags_lto) -fno-builtin -D__BINDGEN__
 
 # Each `bindgen` release may upgrade the list of Rust target versions. By
 # default, the highest stable release in their list is used. Thus we need to set


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
