Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A517B7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA3EC433D6;
	Wed,  2 Nov 2022 02:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357836;
	bh=7EVNh/iJMpTpD+7Jpy18jFkcaWpqtj5NMe4bAOLLbsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3QkhstwI5sTp2/ptJqNuubL1LQDZEWwlPhNtLc61pZ5sPmb+ol2EXWoGIbV7tR/P
	 TVgHy/BvTf5n7zmnyzjNEGPqDQ6ICFJEcX4UtFDeYzQgN2JNZghWcww6tMFor9t1Ry
	 feNEGV7rp5gfel7dQop3VxUe50JCw281U/mB+kP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hilman <khilman@baylibre.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 237/240] riscv: fix detection of toolchain Zicbom support
Date: Wed,  2 Nov 2022 03:33:32 +0100
Message-Id: <20221102022116.764526019@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit b8c86872d1dc171d8f1c137917d6913cae2fa4f2 ]

It is not sufficient to check if a toolchain supports a particular
extension without checking if the linker supports that extension too.
For example, Clang 15 supports Zicbom but GNU bintutils 2.35.2 does
not, leading build errors like so:

riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_c2p0_zicbom1p0_zihintpause2p0: Invalid or unknown z ISA extension: 'zicbom'

Convert CC_HAS_ZICBOM to TOOLCHAIN_HAS_ZICBOM & check if the linker
also supports Zicbom.

Reported-by: Kevin Hilman <khilman@baylibre.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1714
Link: https://storage.kernelci.org/next/master/next-20220920/riscv/defconfig+CONFIG_EFI=n/clang-16/logs/kernel.log
Fixes: 1631ba1259d6 ("riscv: Add support for non-coherent devices using zicbom extension")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20221006173520.1785507-2-conor@kernel.org
[Palmer: Check for ld-2.38, not 2.39, as 2.38 no longer errors.]
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig  | 10 ++++++----
 arch/riscv/Makefile |  3 +--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index cea22ccb57cb..e646298d2d65 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -402,14 +402,16 @@ config RISCV_ISA_SVPBMT
 
 	   If you don't know what to do here, say Y.
 
-config CC_HAS_ZICBOM
+config TOOLCHAIN_HAS_ZICBOM
 	bool
-	default y if 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicbom)
-	default y if 32BIT && $(cc-option,-mabi=ilp32 -march=rv32ima_zicbom)
+	default y
+	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zicbom)
+	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zicbom)
+	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23800
 
 config RISCV_ISA_ZICBOM
 	bool "Zicbom extension support for non-coherent DMA operation"
-	depends on CC_HAS_ZICBOM
+	depends on TOOLCHAIN_HAS_ZICBOM
 	depends on !XIP_KERNEL && MMU
 	select RISCV_DMA_NONCOHERENT
 	select RISCV_ALTERNATIVE
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index e7d52a2301e2..d1dbbe0fb0f8 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -59,8 +59,7 @@ toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zi
 riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
 
 # Check if the toolchain supports Zicbom extension
-toolchain-supports-zicbom := $(call cc-option-yn, -march=$(riscv-march-y)_zicbom)
-riscv-march-$(toolchain-supports-zicbom) := $(riscv-march-y)_zicbom
+riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICBOM) := $(riscv-march-y)_zicbom
 
 # Check if the toolchain supports Zihintpause extension
 toolchain-supports-zihintpause := $(call cc-option-yn, -march=$(riscv-march-y)_zihintpause)
-- 
2.35.1



