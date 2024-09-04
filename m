Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FDE1714B4;
	Wed,  4 Sep 2024 20:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482726; cv=none; b=OO4GJAHimwwiqSvaK/RfDgotZQ7Dz+NPStj14bAmKfnUosVncRHplRuWecR4OhbU3kg36EkrI9ePEcTm/gZ7Sy2Q+SLKkB6klz/+XKqNlCop+juefYW3d9OwXAyCDHSM0jA8GThd01MaUPtPoOd8ihrRAGcnV66QRxUK6HuG+AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482726; c=relaxed/simple;
	bh=GCoMjmNj5/XSFld4YyYz7jnEzqA8ETrIM9dohxikmcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4snJsm6MJzICnUqGfF8bD/sEzQrE4v6pu87HnCzc322kewoefUeqaYqocqs25rWU2cTu13XNmxqvXiJh1jTcyl/B4NllJ322i5+NGhvBzIuqn2jlN9WmMV4wMCTuirkb4Q9COwCYQDkOfC0AUgG/aSChuO9De3XgKXbEYYMMxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2WgcxrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2WgcxrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39B6C4CEC2;
	Wed,  4 Sep 2024 20:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482725;
	bh=GCoMjmNj5/XSFld4YyYz7jnEzqA8ETrIM9dohxikmcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2WgcxrFj+PUSL2LxBGgpdLHtv5MR2gLSHpwMesVKiqcLk1cZ/pyO520zKtr4vf+M
	 7GvN+3ChqkCmg5yrslYmyBPvv2PZ/ecmRL/dPXNG96NEH7RdpoauEablZlX+qybywm
	 CYuSd6OVcMaSj6ZCMPP8m8MDQgPT6oqdld2ftjmm9/g3I+FvB6bChxyWryWBjOpt9n
	 VfdBK5eXPXC3iNEE3NsTSNK+JfoEmgQaeDuDGKz87W9nkwHWKJHCxeilT7AtOguK5t
	 Ix7bLzU4mOybjMjy0wq1HftpT1Ip2JoKRv8iQ6f9g53lUeh6DvIbWJgxXN/SL0oQn3
	 vGyubBvQPFrtQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 12/19] rust: replace `clippy::dbg_macro` with `disallowed_macros`
Date: Wed,  4 Sep 2024 22:43:40 +0200
Message-ID: <20240904204347.168520-13-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 234ab97de796..f236dd5fb6d9 100644
--- a/Makefile
+++ b/Makefile
@@ -451,7 +451,6 @@ export rust_common_flags := --edition=2021 \
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
2.46.0

