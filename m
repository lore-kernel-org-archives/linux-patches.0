Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B236F1B415F;
	Sun,  9 Mar 2025 09:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513865; cv=none; b=bNrt/h7a0Jv0tFu+HZ6JN0GMiHWXKRFoH/cnYOb8GMPAr+US38rCozI+eM7S6nGZOO0yCm5jdr7qo3PNG94a0WUX+/wgTof2t26oFMAHOoMcEzPAFjjDNz3tT6+E+F2hD07hIO9PDc3TpbQxsWE7cUW4A1j3CZq7uemdlfpc8/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513865; c=relaxed/simple;
	bh=6bDhGWu02ipzvB71zugTDv+dHhCZMUCAECmW20XLF/U=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=EWj5PSOxznm7FYStpH90h8KMtSDeyw0jSgtVjhJ9cJ9Uslt2h3ZKFGYYGMlvztySHvW3ekQ4Gts5s+fkTlXR3O/Fe8c2KyQBYBEiY2VJ3MUKrFv4Rccj5nU+yQIxNCg9Df/iiIKAKWg3j2o5U9qa1kl//iM0MpHi78Sh0A03Dmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWbjb+RT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWbjb+RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36281C4CEED;
	Sun,  9 Mar 2025 09:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513865;
	bh=6bDhGWu02ipzvB71zugTDv+dHhCZMUCAECmW20XLF/U=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=KWbjb+RT/669EOxpywFPl9cyP0IZuWVXaJwlNwgZT2driwZUDz1romJ/VI5TCFwJp
	 FeUOwmi42ACdxLxGk4rjBIJrhT60fQT+osMljijdp4823VfzLTr5da8L2stWQF5zRi
	 OyocIaaWgHTVmjNczXQNYPq+jH4PkfevAiMqGl2Q=
Subject: Patch "rust: replace `clippy::dbg_macro` with `disallowed_macros`" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:52 +0100
In-Reply-To: <20250307225008.779961-13-ojeda@kernel.org>
Message-ID: <2025030952-childhood-unmoral-28ef@gregkh>
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

    rust: replace `clippy::dbg_macro` with `disallowed_macros`

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-replace-clippy-dbg_macro-with-disallowed_macros.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121467-greg=kroah.com@vger.kernel.org Fri Mar  7 23:51:13 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:19 +0100
Subject: rust: replace `clippy::dbg_macro` with `disallowed_macros`
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-13-ojeda@kernel.org>

From: Miguel Ojeda <ojeda@kernel.org>

commit 8577c9dca799bd74377f7c30015d8cdc53a53ca2 upstream.

Back when we used Rust 1.60.0 (before Rust was merged in the kernel),
we added `-Wclippy::dbg_macro` to the compilation flags. This worked
great with our custom `dbg!` macro (vendored from `std`, but slightly
modified to use the kernel printing facilities).

However, in the very next version, 1.61.0, it stopped working [1] since
the lint started to use a Rust diagnostic item rather than a path to find
the `dbg!` macro [1]. This behavior remains until the current nightly
(1.83.0).

Therefore, currently, the `dbg_macro` is not doing anything, which
explains why we can invoke `dbg!` in samples/rust/rust_print.rs`, as well
as why changing the `#[allow()]`s to `#[expect()]`s in `std_vendor.rs`
doctests does not work since they are not fulfilled.

One possible workaround is using `rustc_attrs` like the standard library
does. However, this is intended to be internal, and we just started
supporting several Rust compiler versions, so it is best to avoid it.

Therefore, instead, use `disallowed_macros`. It is a stable lint and
is more flexible (in that we can provide different macros), although
its diagnostic message(s) are not as nice as the specialized one (yet),
and does not allow to set different lint levels per macro/path [2].

In turn, this requires allowing the (intentional) `dbg!` use in the
sample, as one would have expected.

Finally, in a single case, the `allow` is fixed to be an inner attribute,
since otherwise it was not being applied.

Link: https://github.com/rust-lang/rust-clippy/issues/11303 [1]
Link: https://github.com/rust-lang/rust-clippy/issues/11307 [2]
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-13-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .clippy.toml               |    6 ++++++
 Makefile                   |    1 -
 rust/kernel/std_vendor.rs  |   10 +++++-----
 samples/rust/rust_print.rs |    1 +
 4 files changed, 12 insertions(+), 6 deletions(-)

--- a/.clippy.toml
+++ b/.clippy.toml
@@ -1 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+disallowed-macros = [
+    # The `clippy::dbg_macro` lint only works with `std::dbg!`, thus we simulate
+    # it here, see: https://github.com/rust-lang/rust-clippy/issues/11303.
+    { path = "kernel::dbg", reason = "the `dbg!` macro is intended as a debugging tool" },
+]
--- a/Makefile
+++ b/Makefile
@@ -452,7 +452,6 @@ export rust_common_flags := --edition=20
 			    -Wrust_2018_idioms \
 			    -Wunreachable_pub \
 			    -Wclippy::all \
-			    -Wclippy::dbg_macro \
 			    -Wclippy::ignored_unit_patterns \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
--- a/rust/kernel/std_vendor.rs
+++ b/rust/kernel/std_vendor.rs
@@ -14,7 +14,7 @@
 ///
 /// ```rust
 /// let a = 2;
-/// # #[allow(clippy::dbg_macro)]
+/// # #[allow(clippy::disallowed_macros)]
 /// let b = dbg!(a * 2) + 1;
 /// //      ^-- prints: [src/main.rs:2] a * 2 = 4
 /// assert_eq!(b, 5);
@@ -52,7 +52,7 @@
 /// With a method call:
 ///
 /// ```rust
-/// # #[allow(clippy::dbg_macro)]
+/// # #[allow(clippy::disallowed_macros)]
 /// fn foo(n: usize) {
 ///     if dbg!(n.checked_sub(4)).is_some() {
 ///         // ...
@@ -71,7 +71,7 @@
 /// Naive factorial implementation:
 ///
 /// ```rust
-/// # #[allow(clippy::dbg_macro)]
+/// # #[allow(clippy::disallowed_macros)]
 /// # {
 /// fn factorial(n: u32) -> u32 {
 ///     if dbg!(n <= 1) {
@@ -118,7 +118,7 @@
 /// a tuple (and return it, too):
 ///
 /// ```
-/// # #[allow(clippy::dbg_macro)]
+/// # #![allow(clippy::disallowed_macros)]
 /// assert_eq!(dbg!(1usize, 2u32), (1, 2));
 /// ```
 ///
@@ -127,7 +127,7 @@
 /// invocations. You can use a 1-tuple directly if you need one:
 ///
 /// ```
-/// # #[allow(clippy::dbg_macro)]
+/// # #[allow(clippy::disallowed_macros)]
 /// # {
 /// assert_eq!(1, dbg!(1u32,)); // trailing comma ignored
 /// assert_eq!((1,), dbg!((1u32,))); // 1-tuple
--- a/samples/rust/rust_print.rs
+++ b/samples/rust/rust_print.rs
@@ -15,6 +15,7 @@ module! {
 
 struct RustPrint;
 
+#[allow(clippy::disallowed_macros)]
 fn arc_print() -> Result {
     use kernel::sync::*;
 


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
