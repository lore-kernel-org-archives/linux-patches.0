Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA022877E0;
	Thu, 21 Aug 2025 21:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810978; cv=none; b=ZHizUsMKHEOkwO4vYNXtOxa5GLwxeHXowQoWFZgBgivEWBjFtuAsA3OCNT47YMWe2vkXDyZGK6DBzWR7kpwJ1k/AfNDtR8siFwAF+1EtZkbtKhNRtnfsZZPBJoLpNVd3e8KxFMC4OPQSqyoTRn3ybPKR5GoaF1dgHXOh81t2m6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810978; c=relaxed/simple;
	bh=7h8ti9XOt72qE84+ULVgnYhwitUoyvrNFp92nIqSGEA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=I7As2xl9nVMpL937CmN5sIlKRQj5blJBM7qNwihgFyljMnox0fa2M1UJd+Th1NvCUFpA8rNBjHgyCXgFw8ZHDYhwhyv/ocGBLHEGbPbHqcmww/6OgeGKkpLiviMbjAu1i1e2Ox5Er3DGruTQFnpHVugpubUv90jctqDOhZOSRk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMoIeyFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMoIeyFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008D6C4CEF4;
	Thu, 21 Aug 2025 21:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755810977;
	bh=7h8ti9XOt72qE84+ULVgnYhwitUoyvrNFp92nIqSGEA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vMoIeyFy572B7PTFUhy5H1niwxvd3fwampoMwUF95XRQbNvpYxsqJ4nG3NThTrEDx
	 +BaxNY1b+Qi9FcYnTexNa0ZDcmY2XwO6ATU839IiqBK8jTdHWeSOSusvi/4duRHMvC
	 KEigXlH+5IBOfA1uwyQoL/fy/EYFh83mL0T6WlWp9WRPKE0VlSvhocHbYbckzw4lDs
	 pZ5OYkfterg+rHTumzTu6y8VDNlAG3CjlKdjsXuzBl7xyXgBgRLZQLDVSHTZ5DIin/
	 XaILz7QpUpC5sSVmkjVR7HS8xMBsYmYchJJWd/NCc4O9qjSfY+H30f2dzquaB/bh79
	 oxmL3u2cgFWiA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Aug 2025 14:15:45 -0700
Subject: [PATCH v2 08/12] riscv: Unconditionally use linker relaxation
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-bump-min-llvm-ver-15-v2-8-635f3294e5f0@kernel.org>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2269; i=nathan@kernel.org;
 h=from:subject:message-id; bh=7h8ti9XOt72qE84+ULVgnYhwitUoyvrNFp92nIqSGEA=;
 b=kA0DAAoWHWsmkXHAGpYByyZiAGinjIOhQOiqLNj+4gr9X47U1dRdW0L4ONYNUiHHiMK3aXUZK
 Ih1BAAWCgAdFiEEe+MlxzExnM0B2MqSHWsmkXHAGpYFAminjIMACgkQHWsmkXHAGpYVZAD/dRSq
 mvKqOGqvjn5OGz9gbrBLdK1f9FTL23YwJ8grFDUBAKe8W5R3ih+p+sgomqLX5Ndj0FbMGv/BrHQ
 6tEoLjKYN
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, CONFIG_RISCV_USE_LINKER_RELAXATION will
always be enabled, so it can be removed.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-riscv@lists.infradead.org
---
 arch/riscv/Kconfig  | 6 ------
 arch/riscv/Makefile | 9 +--------
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 1d53bf02d0fa..d482236e93f4 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -246,15 +246,9 @@ config HAVE_SHADOW_CALL_STACK
 	# https://github.com/riscv-non-isa/riscv-elf-psabi-doc/commit/a484e843e6eeb51f0cb7b8819e50da6d2444d769
 	depends on $(ld-option,--no-relax-gp)
 
-config RISCV_USE_LINKER_RELAXATION
-	def_bool y
-	# https://github.com/llvm/llvm-project/commit/6611d58f5bbcbec77262d392e2923e1d680f6985
-	depends on !LD_IS_LLD || LLD_VERSION >= 150000
-
 # https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc21dd18e5b0918f6
 config ARCH_HAS_BROKEN_DWARF5
 	def_bool y
-	depends on RISCV_USE_LINKER_RELAXATION
 	# https://github.com/llvm/llvm-project/commit/1df5ea29b43690b6622db2cad7b745607ca4de6a
 	depends on AS_IS_LLVM && AS_VERSION < 180000
 	# https://github.com/llvm/llvm-project/commit/7ffabb61a5569444b5ac9322e22e5471cc5e4a77
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index df57654a615e..ecf2fcce2d92 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -46,17 +46,10 @@ else
 	KBUILD_LDFLAGS += -melf32lriscv
 endif
 
-ifndef CONFIG_RISCV_USE_LINKER_RELAXATION
-	KBUILD_CFLAGS += -mno-relax
-	KBUILD_AFLAGS += -mno-relax
-ifndef CONFIG_AS_IS_LLVM
-	KBUILD_CFLAGS += -Wa,-mno-relax
-	KBUILD_AFLAGS += -Wa,-mno-relax
-endif
 # LLVM has an issue with target-features and LTO: https://github.com/llvm/llvm-project/issues/59350
 # Ensure it is aware of linker relaxation with LTO, otherwise relocations may
 # be incorrect: https://github.com/llvm/llvm-project/issues/65090
-else ifeq ($(CONFIG_LTO_CLANG),y)
+ifeq ($(CONFIG_LTO_CLANG),y)
 	KBUILD_LDFLAGS += -mllvm -mattr=+c -mllvm -mattr=+relax
 endif
 

-- 
2.50.1

