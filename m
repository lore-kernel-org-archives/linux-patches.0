Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E20226D0B;
	Mon, 10 Mar 2025 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627257; cv=none; b=XV+zk23ZxEI3umdKosxFpERlbnjCwYgVsLATY0w9vao6Tdh8MTXTs9lnCmxrqxNjkN8yG4EH4EUBLsRpeYMrZvLBGAeCRYGK6I4HG3SzBnxEX498Yt2N22PpndCCgc7AUDEPKEVvC4J0D8VO+vbAcHEwPxnBaJzWdHHuzcg8vAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627257; c=relaxed/simple;
	bh=a58PannorxVF+EfZFdd2PhRAmebVEKi59PNgsRD/Z6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc825zITlfDX+sIJKOAElYb+jz47oPDEJuMqc2fCOTGhj9uVMwR03RbWUZPCcW7Z2AnFH8XA14o+5r4bbKBG4w+M0Pg2CLzr1S4ig0WypaW/ohsr5UK1XXVIKdts76yAR2jrF9tj4iT6hHNQPH4ZOSs6pfZW8Y4zzbi24aGfl6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2z/htp4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2z/htp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC60C4CEED;
	Mon, 10 Mar 2025 17:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627257;
	bh=a58PannorxVF+EfZFdd2PhRAmebVEKi59PNgsRD/Z6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2z/htp4/NV9ikjf4gWuLYa1RAef6F+IbKDHAqSi7V5pNYV2K47SD+apKXc7HC2J8
	 dwfLVXbFn5boK6tlF0q98f8DGJ1S4wWjBqihwilQfw2EseR7K2/m9qEi4VGjcitU9T
	 OAomfcUkOs84QmxJC7h1QAtlA2nA5tb9DYQj6yto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ethan D. Twardy" <ethan.twardy@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 067/269] rust: kbuild: expand rusttest target for macros
Date: Mon, 10 Mar 2025 18:03:40 +0100
Message-ID: <20250310170500.400589552@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile      |   17 +++++++++++++----
 rust/macros/lib.rs |    2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -129,6 +129,14 @@ rusttestlib-macros: private rustc_test_l
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
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -132,7 +132,7 @@ pub fn module(ts: TokenStream) -> TokenS
 /// calls to this function at compile time:
 ///
 /// ```compile_fail
-/// # use kernel::error::VTABLE_DEFAULT_ERROR;
+/// # // Intentionally missing `use`s to simplify `rusttest`.
 /// kernel::build_error(VTABLE_DEFAULT_ERROR)
 /// ```
 ///


