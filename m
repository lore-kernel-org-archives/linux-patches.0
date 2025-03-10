Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B486717CA12;
	Mon, 10 Mar 2025 17:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627127; cv=none; b=ZyT11q2nR+8QYwp7QOfV8QRn10BYA2fbkTDQj883/ZRj7QcM+kASCt2RhxWjsUEq5HQhC2R07njNL81YuAvVq7hRzwgFZQUOvvOzWXJjkPIVzptfPd9OVvdtuTG2Ov4oaJe52tyf5FMMAV11CHSFrPueWgQPP/mv5j3XxrARDyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627127; c=relaxed/simple;
	bh=jps000z7eNbOZkao7cGtZfQw9kTRL9GaITwL5qq3X7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqfCpxhtpY5SyOVEGyUoUWyS8mxjkccKL2XSF0VMtq8WSocQambK93Hc0URre6Uf4L0F16inTPM0PTBd7euAAmJk8rZi5MzdXjXV2HJ8cNAsCwC3zJUVObn2SjFI56t8CEAfz5zbaXfUUgZYIW1OtIacg5xHzNj1SJjJoxtGmMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ztl63uqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ztl63uqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6E7C4CEE5;
	Mon, 10 Mar 2025 17:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627127;
	bh=jps000z7eNbOZkao7cGtZfQw9kTRL9GaITwL5qq3X7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ztl63uqQZYSFE2Qf+MrsIVKGneYW4Sc7uytiz0SAF2Lsu1tJBZ4GcVwqIJusm+fmQ
	 4U77swBEeYL38BcNF04xbnufLtTEIBfrgSusZvsb/4J5XRjizDJ8/XFTYtC+0l9niW
	 Ki/UYzZa2OlyZToEbSajK+bdxjC/i4l1K4XaitQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 023/269] rust: replace `clippy::dbg_macro` with `disallowed_macros`
Date: Mon, 10 Mar 2025 18:02:56 +0100
Message-ID: <20250310170458.635933069@linuxfoundation.org>
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
 


