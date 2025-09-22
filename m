Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949BE2F1FE3;
	Mon, 22 Sep 2025 19:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570272; cv=none; b=bUqcHX55uShmASMC8MZgI+MEXtf9Q7h7au/LMgslxcL0ohec5u5BNgbQlxJ1u2HAGwaT3FVKj3YsUh4OIgs4TKM707LR73da+UY7VuEqNd29FJgzY5XWkGfML251xx0aDfcqNOZ/Qdudxd7SGCCPe5pdq1bvl1rPUcNvMBYFzYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570272; c=relaxed/simple;
	bh=gDYcfhcobfuljAwndTPJp7VEE+ajFlBDnP/bp3a0XOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEOs/rq7ul2Dp2Dr+5DsvUpN7GCQXLpRUHaZbYV5kcbTRk7HlpGHEuGVqqqFRz0HENNS3dJjWWUx7387NyaecuTFOrs3l/rX8y7diidBVR9vGLwDnibz3Dey3dYrVBeR3Gh4YjJGcoj/OIh9SWmRVe+qySZjf1Pz6IjxJPMAvfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGzXZSjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGzXZSjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E191EC4CEF0;
	Mon, 22 Sep 2025 19:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570272;
	bh=gDYcfhcobfuljAwndTPJp7VEE+ajFlBDnP/bp3a0XOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGzXZSjjOkHTMDFbTHFmQLPAVbFIA0fXzDQi8Ndwzzki4O3Nz5pE0XsGVS3IZRbb6
	 PDNbC2pRe4WbO+7Xr7suPFeaAHgyNkpEoPdjRXu0UrH9U27mMADuhTguTWqN4k9HGl
	 0FJz6cYvlceu19J0BXY0QnF2FNWvgAk3JcmSS/uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	WANG Rui <wangrui@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 072/149] LoongArch: Handle jump tables options for RUST
Date: Mon, 22 Sep 2025 21:29:32 +0200
Message-ID: <20250922192414.700724139@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 74f8295c6fb8436bec9995baf6ba463151b6fb68 upstream.

When compiling with LLVM and CONFIG_RUST is set, there exist objtool
warnings in rust/core.o and rust/kernel.o, like this:

    rust/core.o: warning: objtool:
_RNvXs1_NtNtCs5QSdWC790r4_4core5ascii10ascii_charNtB5_9AsciiCharNtNtB9_3fmt5Debug3fmt+0x54:
sibling call from callable instruction with modified stack frame

For this special case, the related object file shows that there is no
generated relocation section '.rela.discard.tablejump_annotate' for the
table jump instruction jirl, thus objtool can not know that what is the
actual destination address.

If rustc has the option "-Cllvm-args=--loongarch-annotate-tablejump",
pass the option to enable jump tables for objtool, otherwise it should
pass "-Zno-jump-tables" to keep compatibility with older rustc.

How to test:

  $ rustup component add rust-src
  $ make LLVM=1 rustavailable
  $ make ARCH=loongarch LLVM=1 clean defconfig
  $ scripts/config -d MODVERSIONS \
    -e RUST -e SAMPLES -e SAMPLES_RUST \
    -e SAMPLE_RUST_CONFIGFS -e SAMPLE_RUST_MINIMAL \
    -e SAMPLE_RUST_MISC_DEVICE -e SAMPLE_RUST_PRINT \
    -e SAMPLE_RUST_DMA -e SAMPLE_RUST_DRIVER_PCI \
    -e SAMPLE_RUST_DRIVER_PLATFORM -e SAMPLE_RUST_DRIVER_FAUX \
    -e SAMPLE_RUST_DRIVER_AUXILIARY -e SAMPLE_RUST_HOSTPROGS
  $ make ARCH=loongarch LLVM=1 olddefconfig all

Cc: stable@vger.kernel.org
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://lore.kernel.org/rust-for-linux/CANiq72mNeCuPkCDrG2db3w=AX+O-zYrfprisDPmRac_qh65Dmg@mail.gmail.com/
Suggested-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Kconfig  |    4 ++++
 arch/loongarch/Makefile |    5 +++++
 2 files changed, 9 insertions(+)

--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -301,6 +301,10 @@ config AS_HAS_LVZ_EXTENSION
 config CC_HAS_ANNOTATE_TABLEJUMP
 	def_bool $(cc-option,-mannotate-tablejump)
 
+config RUSTC_HAS_ANNOTATE_TABLEJUMP
+	depends on RUST
+	def_bool $(rustc-option,-Cllvm-args=--loongarch-annotate-tablejump)
+
 menu "Kernel type and options"
 
 source "kernel/Kconfig.hz"
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -106,6 +106,11 @@ KBUILD_CFLAGS			+= -mannotate-tablejump
 else
 KBUILD_CFLAGS			+= -fno-jump-tables # keep compatibility with older compilers
 endif
+ifdef CONFIG_RUSTC_HAS_ANNOTATE_TABLEJUMP
+KBUILD_RUSTFLAGS		+= -Cllvm-args=--loongarch-annotate-tablejump
+else
+KBUILD_RUSTFLAGS		+= -Zno-jump-tables # keep compatibility with older compilers
+endif
 ifdef CONFIG_LTO_CLANG
 # The annotate-tablejump option can not be passed to LLVM backend when LTO is enabled.
 # Ensure it is aware of linker with LTO, '--loongarch-annotate-tablejump' also needs to


