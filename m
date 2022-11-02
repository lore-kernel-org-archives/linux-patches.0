Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B3B7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF82C433D6;
	Wed,  2 Nov 2022 02:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357842;
	bh=tWIsELuOCx9lIJ4AZ8gpZXYvm7gRFtTae0YUW5nOPYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9Mq/WNHP02Bw08T4XSc4X32rU192rFvqldlQ9PVT56EU7Y5PULwJp4WePm0EYPkZ
	 UStdFRF0LeBUAlBa4xjZAD7kGBx6DwWIr1p80MxOFCnGbVSbRoif6lcYPXIWTnCw4c
	 NazCtKo+R0x82XraHTllHaU8EIkw+/9gkD60GWo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 238/240] riscv: fix detection of toolchain Zihintpause support
Date: Wed,  2 Nov 2022 03:33:33 +0100
Message-Id: <20221102022116.788038832@linuxfoundation.org>
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

[ Upstream commit aae538cd03bc8fc35979653d9180922d146da0ca ]

It is not sufficient to check if a toolchain supports a particular
extension without checking if the linker supports that extension
too. For example, Clang 15 supports Zihintpause but GNU bintutils
2.35.2 does not, leading build errors like so:

riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_c2p0_zihintpause2p0: Invalid or unknown z ISA extension: 'zihintpause'

Add a TOOLCHAIN_HAS_ZIHINTPAUSE which checks if each of the compiler,
assembler and linker support the extension. Replace the ifdef in the
vdso with one depending on this new symbol.

Fixes: 8eb060e10185 ("arch/riscv: add Zihintpause support")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20221006173520.1785507-3-conor@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig                      | 7 +++++++
 arch/riscv/Makefile                     | 3 +--
 arch/riscv/include/asm/vdso/processor.h | 2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index e646298d2d65..9d5b7fa1b622 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -426,6 +426,13 @@ config RISCV_ISA_ZICBOM
 
 	   If you don't know what to do here, say Y.
 
+config TOOLCHAIN_HAS_ZIHINTPAUSE
+	bool
+	default y
+	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zihintpause)
+	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zihintpause)
+	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23600
+
 config FPU
 	bool "FPU support"
 	default y
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index d1dbbe0fb0f8..e5a608e37f45 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -62,8 +62,7 @@ riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
 riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICBOM) := $(riscv-march-y)_zicbom
 
 # Check if the toolchain supports Zihintpause extension
-toolchain-supports-zihintpause := $(call cc-option-yn, -march=$(riscv-march-y)_zihintpause)
-riscv-march-$(toolchain-supports-zihintpause) := $(riscv-march-y)_zihintpause
+riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) := $(riscv-march-y)_zihintpause
 
 KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
 KBUILD_AFLAGS += -march=$(riscv-march-y)
diff --git a/arch/riscv/include/asm/vdso/processor.h b/arch/riscv/include/asm/vdso/processor.h
index 1e4f8b4aef79..fa70cfe507aa 100644
--- a/arch/riscv/include/asm/vdso/processor.h
+++ b/arch/riscv/include/asm/vdso/processor.h
@@ -21,7 +21,7 @@ static inline void cpu_relax(void)
 		 * Reduce instruction retirement.
 		 * This assumes the PC changes.
 		 */
-#ifdef __riscv_zihintpause
+#ifdef CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE
 		__asm__ __volatile__ ("pause");
 #else
 		/* Encoding of the pause instruction */
-- 
2.35.1



