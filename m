Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915E84CB3D;
	Wed, 29 Nov 2023 23:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sOrZxI4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FF9C433CC;
	Wed, 29 Nov 2023 23:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701300605;
	bh=A8sPnu2KKz5CALRbBlnZLQ9BA9ZLoGfN4oxpbkVxKs8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=sOrZxI4i2MaUtp68oIZ9YXBhsRtPYuENl8cd8ASOnSMgmuOvvfgmhOkdjL15yzPRm
	 R1mFwLl9Dp0klcSgLGhHmhC1fkDRw8icGapy4fbK+W9gcg8DrmGQyJCdtVGwC04IMB
	 aKPa0FlMnrqtnWzZsTYDqK2m4vGPHjC90zuD508f3ZGkTrRmapE0I5nGMwaOQsfMcQ
	 AvLczgF1SgSmtsgmkIB+UIOnH1f2caTLiRRr6HmyTstvlWDz+0gsWyjUM22FW/TirZ
	 5Ps0CivWpSDLK2cEOZl7P/mbZx4Qz1IekgyD3vgdd8OqyN0yXJ142m6phTWhXsUeFq
	 q80MmGPKlaicw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 29 Nov 2023 16:29:48 -0700
Subject: [PATCH 2/2] riscv: Restrict DWARF5 when building with LLVM to
 known working versions
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231129-riscv-restrict-dwarf5-llvm-v1-2-ec0d368fb538@kernel.org>
References: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
In-Reply-To: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
To: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
 conor@kernel.org
Cc: maskray@google.com, ndesaulniers@google.com, 
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2408; i=nathan@kernel.org;
 h=from:subject:message-id; bh=A8sPnu2KKz5CALRbBlnZLQ9BA9ZLoGfN4oxpbkVxKs8=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKnpJ6sn+67d9mzvBvNy7bmKz/wSdxrVrHNi3/4rx9P+n
 H7gr4mzOkpZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBESiYxMsxc23QiQlXUI+RL
 SMQWizPzZm46NG/1VO/Tr9f6vJq76e1+RobXN5c9Zr365cEirbTq0h0lz1eabZDp3/oqwF94UkR
 44zYWAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

LLVM prior to 18.0.0 would generate incorrect debug info for DWARF5 due
to linker relaxation, which was worked around in clang by defaulting
RISC-V to DWARF4 [1]. Unfortunately, this workaround does not work for
the kernel because the DWARF version can be independently changed from
the default in Kconfig.

Do not allow DWARF5 to be selected for RISC-V when using linker
relaxation (ld.lld >= 15.0.0) and a version of LLVM that does not have
the fixes (the integrated assembler [2] and ld.lld [3] < 18.0.0)
necessary to generate the correct debug info.

Link: https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc21dd18e5b0918f6 [1]
Link: https://github.com/llvm/llvm-project/commit/1df5ea29b43690b6622db2cad7b745607ca4de6a [2]
Link: https://github.com/llvm/llvm-project/commit/7ffabb61a5569444b5ac9322e22e5471cc5e4a77 [3]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/riscv/Kconfig | 9 +++++++++
 lib/Kconfig.debug  | 1 +
 2 files changed, 10 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 72be1d8122a3..81b473cb47b0 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -186,6 +186,15 @@ config RISCV_USE_LINKER_RELAXATION
 	# https://github.com/llvm/llvm-project/commit/6611d58f5bbcbec77262d392e2923e1d680f6985
 	depends on !LD_IS_LLD || LLD_VERSION >= 150000
 
+# https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc21dd18e5b0918f6
+config ARCH_HAS_BROKEN_DWARF5
+	def_bool y
+	depends on RISCV_USE_LINKER_RELAXATION
+	# https://github.com/llvm/llvm-project/commit/1df5ea29b43690b6622db2cad7b745607ca4de6a
+	depends on AS_IS_LLVM && AS_VERSION < 180000
+	# https://github.com/llvm/llvm-project/commit/7ffabb61a5569444b5ac9322e22e5471cc5e4a77
+	depends on LD_IS_LLD && LLD_VERSION < 180000
+
 config ARCH_MMAP_RND_BITS_MIN
 	default 18 if 64BIT
 	default 8
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cc7d53d9dc01..a0ebce05a368 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -282,6 +282,7 @@ config DEBUG_INFO_DWARF4
 config DEBUG_INFO_DWARF5
 	bool "Generate DWARF Version 5 debuginfo"
 	select DEBUG_INFO
+	depends on !ARCH_HAS_BROKEN_DWARF5
 	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
 	help
 	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc

-- 
2.43.0

