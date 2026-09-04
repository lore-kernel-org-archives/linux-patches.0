Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D6041685A;
	Fri,  4 Sep 2026 05:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498494; cv=none; b=J0uFYc7i4/g2PkOrHnTDgxUlWP54ivEWiaJqXRwRZF/t4WXyqKfLeJOHMPs3zpOuvANrSERMS7UMkKgEo5rm86nsuhly+DABV+23+bd7d3mAqZzF+Kl+91s3nCUCjFC6pPF7yGQ/IZ8fdgdjmD+rYc/aMQHbaZzC876mIGQYfsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498494; c=relaxed/simple;
	bh=I2oIyIVM3D+3JbJouItqHjzcYK1LHVHUFONRRRhhjN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDsN+EGH9biEhaAD1BJ2kRmJDc+9XvdET1JStyd89uTyiY5IF3jpcFTbI9zri4piZbYEKyLdmDcLEVRJ4OncRxubRfdlzUIz4IPKTa7SPFC9jco3FNhm+r1fHjdotgjYl6zVDmpFigX2YGBoXvbw1YsI6NfDAtQgZSfjPfyx+cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNW4GzOw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNW4GzOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30391F00A3E;
	Fri,  4 Sep 2026 05:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498486;
	bh=gJCILEvprfoOS1UYAq1fOJy0XL8cPs+ygzLchb5gx6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNW4GzOwNCagijg4briL6raKPyP7JXVxj/tkHrRUpSlLppu6bG6z2d7zTAm1mhiX9
	 GgjpG3p/uL1jzLGSVtmPIN85e3odvmJA/2XIG9hbV12IOdfSzjdMOG38t2Rq1jue1N
	 uV5kU0QuJatU32coYUEGE6vU3aU962wfv1KHaGGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Boqun Feng <boqun@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Matthew Maurer <mmaurer@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 039/713] kbuild: rust: preserve unreachable traps with inline helpers
Date: Fri,  4 Sep 2026 06:50:07 +0200
Message-ID: <20260904045804.707731174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 0bff7711c19ba05ff3b686554c5a2d503c3e9797 upstream.

When `CONFIG_RUST_INLINE_HELPERS` is enabled, it is possible to hit
`objtool` warnings like:

    vmlinux.o: warning: objtool: _R..._4cmdq12CommandToGsp4init()
    falls through to next function _R..._4core5array4iter8IntoIterRShKj3_EEEBa_()

`rustc` normally emits traps for unreachable paths. However, under
`CONFIG_RUST_INLINE_HELPERS=y`, `rustc` emits LLVM bitcode and Clang
performs final code generation after the helper bitcode is linked,
but Clang does not trap unreachable IR by default.

In turn, this means `objtool` follows compiler-generated impossible Rust
`enum` paths through alignment padding into the next function, resulting
in fallthrough warnings.

Thus pass the LLVM `trap-unreachable` option to the final Clang invocation
and suppress traps immediately after `noreturn` calls, which `objtool`
already recognizes as dead ends. The combination of both flags makes it
match `rustc`'s behavior.

Rust 1.85.0 (the minimum supported one) supports LLVM >= 18, and both
flags are available in LLVM 18.

Assisted-by: LLM
Cc: Gary Guo <gary@garyguo.net>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Matthew Maurer <mmaurer@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Fixes: 3a2486cc1da5 ("kbuild: rust: provide an option to inline C helpers into Rust")
Acked-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260816133233.197500-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile               |   10 ++++++++++
 rust/Makefile          |    3 ++-
 scripts/Makefile.build |    3 ++-
 3 files changed, 14 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1083,6 +1083,16 @@ endif
 export CC_FLAGS_SCS
 endif
 
+ifdef CONFIG_RUST_INLINE_HELPERS
+# `rustc` normally emits traps for unreachable paths during code generation.
+# With inline helpers, Clang performs code generation from the linked bitcode
+# instead, so request the same behavior explicitly. Otherwise `objtool` may
+# follow an impossible Rust path into the next function.
+CC_FLAGS_RUST_INLINE_HELPERS := -mllvm -trap-unreachable \
+				-mllvm -no-trap-after-noreturn
+export CC_FLAGS_RUST_INLINE_HELPERS
+endif
+
 ifdef CONFIG_LTO_CLANG
 ifdef CONFIG_LTO_CLANG_FULL
 CC_FLAGS_LTO	:= -flto
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -645,7 +645,8 @@ quiet_cmd_rustc_library = $(if $(skip_cl
 		-Zunstable-options \
 	$(if $(link_helper),;$(LLVM_LINK) --internalize --suppress-warnings $(patsubst %.o,%.bc,$@) \
 		$(obj)/helpers/helpers$(if $(part-of-module),_module).bc -o $(patsubst %.o,%.m.bc,$@); \
-		$(CC) $(CLANG_FLAGS) $(KBUILD_CFLAGS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@ \
+		$(CC) $(CLANG_FLAGS) $(KBUILD_CFLAGS) \
+		$(CC_FLAGS_RUST_INLINE_HELPERS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@ \
 		$(cmd_ld_single)) \
 	$(if $(rustc_objcopy),;$(OBJCOPY) $(rustc_objcopy) $@) \
 	$(cmd_objtool)
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -346,7 +346,8 @@ quiet_cmd_rustc_o_rs = $(RUSTC_OR_CLIPPY
       cmd_rustc_o_rs = $(rust_common_cmd) --emit=$(if $(CONFIG_RUST_INLINE_HELPERS),llvm-bc=$(patsubst %.o,%.bc,$@),obj=$@) $< \
 	$(if $(CONFIG_RUST_INLINE_HELPERS),;$(LLVM_LINK) --internalize --suppress-warnings $(patsubst %.o,%.bc,$@) \
 		$(objtree)/rust/helpers/helpers$(if $(part-of-module),_module).bc -o $(patsubst %.o,%.m.bc,$@); \
-		$(CC) $(CLANG_FLAGS) $(KBUILD_CFLAGS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@ \
+		$(CC) $(CLANG_FLAGS) $(KBUILD_CFLAGS) \
+		$(CC_FLAGS_RUST_INLINE_HELPERS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@ \
 		$(cmd_ld_single)) \
 	$(cmd_objtool)
 


