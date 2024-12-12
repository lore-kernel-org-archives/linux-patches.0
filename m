Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E40A22C354;
	Thu, 12 Dec 2024 16:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020889; cv=none; b=Y6XXacfKGXIPIVMIeEDepKaZ0xoPHb/+CsZbofHPJ3PQKeNlmmUf8bJLZ9q+rtbSdp01j75VXQZ3XKS4gkjmRTUGO5fPaWHxK+BS+Ap1JVBMryiwLEwEBr0XHNUQJ22XT27WGr23SPNk/mG2VC9T95DRBNh4rFD8pY53+k9Evuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020889; c=relaxed/simple;
	bh=qFIkncYmvslN1Aodfv6vyL5PHopOUmxqVs9zFDx9rTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCSy9Ggi9RqjaNMe/NEm5uUyg5e/DOr3STg2UVOGCIdZQFwdDkfBzyIdfcolMQE2BItIMynkY+pJqBKDEGGnLuE3UhgwnQJHzyVNAP8j58nCWUBYIMSK+3LkMQTowdNdDPjv8slPKNMVUFOu9jbj41lP6KBCR9bWBRwexoChUto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XR4F56HI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XR4F56HI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF05CC4CECE;
	Thu, 12 Dec 2024 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020889;
	bh=qFIkncYmvslN1Aodfv6vyL5PHopOUmxqVs9zFDx9rTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XR4F56HIzyTwO8SHYCCTisY6tlAquKX8nmPB6RysOzCF0+xbNqCHu4pxu9HQfSx+Z
	 assIIuBrAdGhAIp16hS7HlahPe8320QRtgC1neN5SjPgvA2bT0nWi/CJBxzy7h5jR7
	 ToOK2qBXKAC8cWzYfPTMz3h6AoW2P4LQaBqlHbjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 558/772] powerpc/vdso: Improve linker flags
Date: Thu, 12 Dec 2024 15:58:23 +0100
Message-ID: <20241212144413.021916638@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit f0a42fbab447ed9f55bbd99751183e71f3a1f6ec ]

When clang's -Qunused-arguments is dropped from KBUILD_CPPFLAGS, there
are several warnings in the PowerPC vDSO:

  clang-16: error: -Wl,-soname=linux-vdso32.so.1: 'linker' input unused [-Werror,-Wunused-command-line-argument]
  clang-16: error: -Wl,--hash-style=both: 'linker' input unused [-Werror,-Wunused-command-line-argument]
  clang-16: error: argument unused during compilation: '-shared' [-Werror,-Wunused-command-line-argument]

  clang-16: error: argument unused during compilation: '-nostdinc' [-Werror,-Wunused-command-line-argument]
  clang-16: error: argument unused during compilation: '-Wa,-maltivec' [-Werror,-Wunused-command-line-argument]

The first group of warnings point out that linker flags were being added
to all invocations of $(CC), even though they will only be used during
the final vDSO link. Move those flags to ldflags-y.

The second group of warnings are compiler or assembler flags that will
be unused during linking. Filter them out from KBUILD_CFLAGS so that
they are not used during linking.

Additionally, '-z noexecstack' was added directly to the ld_and_check
rule in commit 1d53c0192b15 ("powerpc/vdso: link with -z noexecstack")
but now that there is a common ldflags variable, it can be moved there.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: d677ce521334 ("powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso/Makefile | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index 45c0cc5d34b64..d4023bceec348 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -47,13 +47,17 @@ KCOV_INSTRUMENT := n
 UBSAN_SANITIZE := n
 KASAN_SANITIZE := n
 
-ccflags-y := -shared -fno-common -fno-builtin -nostdlib -Wl,--hash-style=both
-ccflags-$(CONFIG_LD_IS_LLD) += $(call cc-option,--ld-path=$(LD),-fuse-ld=lld)
-
-CC32FLAGS := -Wl,-soname=linux-vdso32.so.1 -m32
+ccflags-y := -fno-common -fno-builtin
+ldflags-y := -Wl,--hash-style=both -nostdlib -shared -z noexecstack
+ldflags-$(CONFIG_LD_IS_LLD) += $(call cc-option,--ld-path=$(LD),-fuse-ld=lld)
+# Filter flags that clang will warn are unused for linking
+ldflags-y += $(filter-out $(CC_FLAGS_FTRACE) -Wa$(comma)%, $(KBUILD_CFLAGS))
+
+CC32FLAGS := -m32
+LD32FLAGS := -Wl,-soname=linux-vdso32.so.1
 AS32FLAGS := -D__VDSO32__
 
-CC64FLAGS := -Wl,-soname=linux-vdso64.so.1
+LD64FLAGS := -Wl,-soname=linux-vdso64.so.1
 AS64FLAGS := -D__VDSO64__
 
 targets += vdso32.lds
@@ -92,15 +96,15 @@ include/generated/vdso64-offsets.h: $(obj)/vdso64.so.dbg FORCE
 
 # actual build commands
 quiet_cmd_vdso32ld_and_check = VDSO32L $@
-      cmd_vdso32ld_and_check = $(VDSOCC) $(c_flags) $(CC32FLAGS) -o $@ -Wl,-T$(filter %.lds,$^) $(filter %.o,$^) -z noexecstack ; $(cmd_vdso_check)
+      cmd_vdso32ld_and_check = $(VDSOCC) $(ldflags-y) $(CC32FLAGS) $(LD32FLAGS) -o $@ -Wl,-T$(filter %.lds,$^) $(filter %.o,$^); $(cmd_vdso_check)
 quiet_cmd_vdso32as = VDSO32A $@
       cmd_vdso32as = $(VDSOCC) $(a_flags) $(CC32FLAGS) $(AS32FLAGS) -c -o $@ $<
 quiet_cmd_vdso32cc = VDSO32C $@
       cmd_vdso32cc = $(VDSOCC) $(c_flags) $(CC32FLAGS) -c -o $@ $<
 
 quiet_cmd_vdso64ld_and_check = VDSO64L $@
-      cmd_vdso64ld_and_check = $(VDSOCC) $(c_flags) $(CC64FLAGS) -o $@ -Wl,-T$(filter %.lds,$^) $(filter %.o,$^) -z noexecstack ; $(cmd_vdso_check)
+      cmd_vdso64ld_and_check = $(VDSOCC) $(ldflags-y) $(LD64FLAGS) -o $@ -Wl,-T$(filter %.lds,$^) $(filter %.o,$^); $(cmd_vdso_check)
 quiet_cmd_vdso64as = VDSO64A $@
-      cmd_vdso64as = $(VDSOCC) $(a_flags) $(CC64FLAGS) $(AS64FLAGS) -c -o $@ $<
+      cmd_vdso64as = $(VDSOCC) $(a_flags) $(AS64FLAGS) -c -o $@ $<
 
 OBJECT_FILES_NON_STANDARD := y
-- 
2.43.0



