Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBEE18BC36;
	Fri,  7 Mar 2025 22:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387869; cv=none; b=IMIu4scD9rIJz+h2cY9cotyLHTNncbnJ/cYRkxeoADCz+IqwTG78mO4feAsnH6XGNZfQzniPJdI+tAWqTLgNrymL6j+P4pFesQnuhvnFMEdavuJUxM4nNQRW9bM5Vbo6ZKqnAKinXXnEicGfpwiDCA4ahetFKWl9ObdKR0JofGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387869; c=relaxed/simple;
	bh=sgb9roCamCt1UqlkFgft3zpl62r1p/bZz8kV9L9O8/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYJGkZOeWe9unjxPfZm/hZ5XCxJSGtqnhKd+6vvH9wuYiVVqmu9yagOfLpxIoqVh3oECPPphfOVCa35aGVHEq6EBkttV74pX3OQbVVP2hzvq+Y47RefvUa1oScWvDUkeDQDDtbwNxFmos3pkxO1QYUuQGe/vB1O4xkiAsgE/9qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZfKd0/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZfKd0/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4034C4CEE5;
	Fri,  7 Mar 2025 22:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387868;
	bh=sgb9roCamCt1UqlkFgft3zpl62r1p/bZz8kV9L9O8/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZfKd0/BTLTuxjBI8pZGL0WEj7Eho+XuhyELIIx00Ncc343DCCMZDyOZFYiQfHwIq
	 r9y8XXbTuvkpLY/y214BO4txP7QjIQLooO+Untxuspex4fvBLkiIBWpTuWfWVODpSM
	 74hy6oQUJSB/+wwWUwlgWXSW5nPSRp+Urf5/TT2+pMUHWMoEBiUA3zX9QTwqKIwZOU
	 JOXDFEkbltiwEG/T46TqPUkzqcvPIsb2ih1Ybl7bBkaGJheCK3IU4iUdPjsCD/1KX/
	 9utiRPS4pPfd2rdCTsVHHQIVgb3++zVNw4MEAXcFPKrnoHwO0okqv1AXFZ+bzhYfON
	 fh/6avRVujiFA==
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
Subject: [PATCH 6.12.y 12/60] rust: replace `clippy::dbg_macro` with `disallowed_macros`
Date: Fri,  7 Mar 2025 23:49:19 +0100
Message-ID: <20250307225008.779961-13-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 .clippy.toml               |  6 ++++++
 Makefile                   |  1 -
 rust/kernel/std_vendor.rs  | 10 +++++-----
 samples/rust/rust_print.rs |  1 +
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/.clippy.toml b/.clippy.toml
index f66554cd5c45..ad9f804fb677 100644
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
diff --git a/Makefile b/Makefile
index 43cc17c514dc..d005a439a67c 100644
--- a/Makefile
+++ b/Makefile
@@ -452,7 +452,6 @@ export rust_common_flags := --edition=2021 \
 			    -Wrust_2018_idioms \
 			    -Wunreachable_pub \
 			    -Wclippy::all \
-			    -Wclippy::dbg_macro \
 			    -Wclippy::ignored_unit_patterns \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
diff --git a/rust/kernel/std_vendor.rs b/rust/kernel/std_vendor.rs
index 67bf9d37ddb5..085b23312c65 100644
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
diff --git a/samples/rust/rust_print.rs b/samples/rust/rust_print.rs
index 6eabb0d79ea3..ed1137ab2018 100644
--- a/samples/rust/rust_print.rs
+++ b/samples/rust/rust_print.rs
@@ -15,6 +15,7 @@
 
 struct RustPrint;
 
+#[allow(clippy::disallowed_macros)]
 fn arc_print() -> Result {
     use kernel::sync::*;
 
-- 
2.48.1

