Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC35415F01;
	Fri,  4 Sep 2026 05:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498496; cv=none; b=l19+AcU1zHQnagXGuDI8CKBuLXhCAsLWTeTOAXN3DOox85QlcN+gZhRDXAS+0MHqGxm21WjhcDm06gVn0IszGxmFDm+Kqqvitwc8Ffu+sCCsccZpD/naUdLuzF6IDllHAhtqtjW/8vqmrUtmqMLAj58hP7vHTjjzdkqeukf/e6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498496; c=relaxed/simple;
	bh=3TjpdpP/6UioRZu+uo6jZB5POc2F60dCUI7u5oDgZE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOIZbeU6nlAMAiIpBot8C3/l2PKhXJzZVPL90UNyITJLF3N04hkPch/f+T4NgOTMHY9Wtu4qhU9jR9ZREO9dJT/tV9RO+HmnF2qpp5HtuXivsisXDXeyDzps1q/eTYLZpEulwWAdDXlWuJAr3kQKURFNLO691lJi0NnXtVKOly8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYkxstEP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYkxstEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF851F00A3D;
	Fri,  4 Sep 2026 05:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498489;
	bh=Q+CXxTRccDK2JsvuP26cLdKBzmLppxq9qXlBVQk7riA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYkxstEPttl5SbI/R9ecO4D9dZFMtHKAjuk7oxU0sbbl0pLiW4FsQjYdInitNcwiQ
	 W5IJOjjsfRyd0bCDcWn3fPO11UKE5BfVoB+1LXIPFF9stRLWVAO6uVZEW/Xvs8RB3c
	 JQ4gR1aaSFmR8/ULywFxzB5nN6jhnTkQ8vmJDyZ4=
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
Subject: [PATCH 7.2 040/713] kbuild: rust: keep Rust objects out of Clang LTO with inline helpers
Date: Fri,  4 Sep 2026 06:50:08 +0200
Message-ID: <20260904045804.729506589@linuxfoundation.org>
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

commit 5febf432df1cfa5b25d99b54c32103fafbdd0eb9 upstream.

Under `CONFIG_LTO_CLANG` + `CONFIG_RUST_INLINE_HELPERS`, one may hit
`objtool` errors such as:

    vmlinux.o: error: objtool: _R..._3Gsp4boot+0xd6a:
    can't find jump dest instruction at .text._R..._3Gsp4boot+0x1dfd

The reason is that in such builds, the Clang invocation that compiles
the combined Rust plus helpers bitcode emits LLVM bitcode (again) --
the final code generation happens in the linker's LTO step, which the
`-mllvm` trap options passed to Clang do not reach.

This, in turn, means that unreachable traps are missing, and the
impossible paths do not merely fallthrough to the next symbol, but past
the end of their own section, since LTO builds place each function in
its own section.

Thus filter `CC_FLAGS_LTO` out of the Clang invocation, so that it always
emits machine code directly, with the traps in place.

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
Link: https://patch.msgid.link/20260816133233.197500-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile          |    2 +-
 scripts/Makefile.build |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -645,7 +645,7 @@ quiet_cmd_rustc_library = $(if $(skip_cl
 		-Zunstable-options \
 	$(if $(link_helper),;$(LLVM_LINK) --internalize --suppress-warnings $(patsubst %.o,%.bc,$@) \
 		$(obj)/helpers/helpers$(if $(part-of-module),_module).bc -o $(patsubst %.o,%.m.bc,$@); \
-		$(CC) $(CLANG_FLAGS) $(KBUILD_CFLAGS) \
+		$(CC) $(CLANG_FLAGS) $(filter-out $(CC_FLAGS_LTO),$(KBUILD_CFLAGS)) \
 		$(CC_FLAGS_RUST_INLINE_HELPERS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@ \
 		$(cmd_ld_single)) \
 	$(if $(rustc_objcopy),;$(OBJCOPY) $(rustc_objcopy) $@) \
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -346,7 +346,7 @@ quiet_cmd_rustc_o_rs = $(RUSTC_OR_CLIPPY
       cmd_rustc_o_rs = $(rust_common_cmd) --emit=$(if $(CONFIG_RUST_INLINE_HELPERS),llvm-bc=$(patsubst %.o,%.bc,$@),obj=$@) $< \
 	$(if $(CONFIG_RUST_INLINE_HELPERS),;$(LLVM_LINK) --internalize --suppress-warnings $(patsubst %.o,%.bc,$@) \
 		$(objtree)/rust/helpers/helpers$(if $(part-of-module),_module).bc -o $(patsubst %.o,%.m.bc,$@); \
-		$(CC) $(CLANG_FLAGS) $(KBUILD_CFLAGS) \
+		$(CC) $(CLANG_FLAGS) $(filter-out $(CC_FLAGS_LTO),$(KBUILD_CFLAGS)) \
 		$(CC_FLAGS_RUST_INLINE_HELPERS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@ \
 		$(cmd_ld_single)) \
 	$(cmd_objtool)


