Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25EB20CCCD;
	Fri,  7 Mar 2025 22:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387988; cv=none; b=dtrbRvijdfI64bVgL8XOJ9Z7xw1a6P4TVFZdbBTpkuckHB7dBL5ANXWLz5Jq8Ywd9MO+MMOKNmtgNdim+MT7ywl5e1MQHv9rAq5J3IACU3iooxoNEgRs9A1TT7uALAjZNL9noo8WCfiQh2c7mvZmNi3OqvpQjfKI6QE1Wunoi3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387988; c=relaxed/simple;
	bh=flhTccNi/7DGRCJXxE23C5TiTUIeuroWj/okRnkGpcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmRtEMy+rw2niHWXn7Zw5O6JUJw74uTzkqlwUYDhhofwDWxxIV7KA7idXJFWYNgYuCVQi1gdgcA2Mf75qn1nMX/fSDscBKFJ5hCO1bDdRjkC0/8/lmNdZfwR7jURKZj0n55e8hHd+ioGrRqg42MEO+kFN+dP94UGpE7LT0V89N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gEVq2Wn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEVq2Wn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAC3C4CED1;
	Fri,  7 Mar 2025 22:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387988;
	bh=flhTccNi/7DGRCJXxE23C5TiTUIeuroWj/okRnkGpcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEVq2Wn5XjoxEgxHFgULzvxZN3WkR3mxEDEbR9JGWIrDvRfDEZ1ym3LEFFOtc37ex
	 o2XGqU2ghNAmTcsb8obAxFHCoCNqmOzDo/7Q7av7a69//GrNbZyJaBJiSxlElgckkB
	 atEZYPvJCx7e0l8M3dNb543UF40zUfpDZg7WEkmVa9Q4K4lv6WKZsd+Y14m8V31Pu3
	 EVEYrj2Qo2Vbqh8F9Uhbd5GXFl/l2+NuDFXEx7RPO7FjQimwGlEutaEuR7f03y8K8v
	 gCjS+hVQpTXP4SHE28Lkfl5ypK0EKr7lSKsN1aG7V0Lofl1IMnbe4rYAJU0svKH6wT
	 BbXUwgwco7gLQ==
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
Subject: [PATCH 6.12.y 56/60] rust: kbuild: expand rusttest target for macros
Date: Fri,  7 Mar 2025 23:50:03 +0100
Message-ID: <20250307225008.779961-57-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Ethan D. Twardy" <ethan.twardy@gmail.com>

commit b2c261fa8629dff2bd1143fa790797a773ace102 upstream.

Previously, the rusttest target for the macros crate did not specify
the dependencies necessary to run the rustdoc tests. These tests rely on
the kernel crate, so add the dependencies.

Signed-off-by: Ethan D. Twardy <ethan.twardy@gmail.com>
Link: https://github.com/Rust-for-Linux/linux/issues/1076
Link: https://lore.kernel.org/r/20240704145607.17732-2-ethan.twardy@gmail.com
[ Rebased (`alloc` is gone nowadays, sysroot handling is simpler) and
  simplified (reused `rustdoc_test` rule instead of adding a new one,
  no need for `rustdoc-compiler_builtins`, removed unneeded `macros`
  explicit path). Made `vtable` example fail (avoiding to increase
  the complexity in the `rusttest` target). Removed unstable
  `-Zproc-macro-backtrace` option. Reworded accordingly. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/Makefile      | 17 +++++++++++++----
 rust/macros/lib.rs |  2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/rust/Makefile b/rust/Makefile
index 9358d3eb7555..5e7612f69cea 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -129,6 +129,14 @@ rusttestlib-macros: private rustc_test_library_proc = yes
 rusttestlib-macros: $(src)/macros/lib.rs FORCE
 	+$(call if_changed,rustc_test_library)
 
+rusttestlib-kernel: private rustc_target_flags = \
+    --extern build_error --extern macros \
+    --extern bindings --extern uapi
+rusttestlib-kernel: $(src)/kernel/lib.rs \
+    rusttestlib-bindings rusttestlib-uapi rusttestlib-build_error \
+    $(obj)/libmacros.so $(obj)/bindings.o FORCE
+	+$(call if_changed,rustc_test_library)
+
 rusttestlib-bindings: $(src)/bindings/lib.rs FORCE
 	+$(call if_changed,rustc_test_library)
 
@@ -181,19 +189,20 @@ quiet_cmd_rustc_test = RUSTC T  $<
 
 rusttest: rusttest-macros rusttest-kernel
 
-rusttest-macros: private rustc_target_flags = --extern proc_macro
+rusttest-macros: private rustc_target_flags = --extern proc_macro \
+	--extern macros --extern kernel
 rusttest-macros: private rustdoc_test_target_flags = --crate-type proc-macro
-rusttest-macros: $(src)/macros/lib.rs FORCE
+rusttest-macros: $(src)/macros/lib.rs \
+    rusttestlib-macros rusttestlib-kernel FORCE
 	+$(call if_changed,rustc_test)
 	+$(call if_changed,rustdoc_test)
 
 rusttest-kernel: private rustc_target_flags = \
     --extern build_error --extern macros --extern bindings --extern uapi
-rusttest-kernel: $(src)/kernel/lib.rs \
+rusttest-kernel: $(src)/kernel/lib.rs rusttestlib-kernel \
     rusttestlib-build_error rusttestlib-macros rusttestlib-bindings \
     rusttestlib-uapi FORCE
 	+$(call if_changed,rustc_test)
-	+$(call if_changed,rustc_test_library)
 
 ifdef CONFIG_CC_IS_CLANG
 bindgen_c_flags = $(c_flags)
diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
index 939ae00b723a..b16402a16acd 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -132,7 +132,7 @@ pub fn module(ts: TokenStream) -> TokenStream {
 /// calls to this function at compile time:
 ///
 /// ```compile_fail
-/// # use kernel::error::VTABLE_DEFAULT_ERROR;
+/// # // Intentionally missing `use`s to simplify `rusttest`.
 /// kernel::build_error(VTABLE_DEFAULT_ERROR)
 /// ```
 ///
-- 
2.48.1

