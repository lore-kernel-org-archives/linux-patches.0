Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8262D1FB24
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B86C433C8;
	Tue,  1 Aug 2023 09:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882290;
	bh=B2L++1REw280gUtS+wMInmWJ0TE/a2go2Yu1ppkM1dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oicmGH617vpwoJAG+MPHEXfc6lVeypXh8SwcC3W9Clv0t37RsgGZNXdpXrzL+8qF8
	 8/8+ZIFy0XFgdSdeo1JM4LQnNuCVg6n7hXA66yWawMvRtq3BaGsA+eHSvxBlSvZNE3
	 pydcz/TD0UVPuDz6psnA3mptRlg12hGasrukRkMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/228] MIPS: Loongson: Move arch cflags to MIPS top level Makefile
Date: Tue,  1 Aug 2023 11:18:03 +0200
Message-ID: <20230801091923.784646409@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 194a835210521282ad31e8f7047556318611f596 ]

Arch cflags should be independent to Platform.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: 531b3d1195d0 ("MIPS: Loongson: Fix build error when make modules_install")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Makefile             | 38 ++++++++++++++++++++++++++++++++++
 arch/mips/loongson2ef/Platform | 35 -------------------------------
 arch/mips/loongson64/Platform  | 16 --------------
 3 files changed, 38 insertions(+), 51 deletions(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 85d3c3b4b7bdc..ca457f19f7fe0 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -190,9 +190,47 @@ endif
 cflags-$(CONFIG_CAVIUM_CN63XXP1) += -Wa,-mfix-cn63xxp1
 cflags-$(CONFIG_CPU_BMIPS)	+= -march=mips32 -Wa,-mips32 -Wa,--trap
 
+cflags-$(CONFIG_CPU_LOONGSON2E) += -march=loongson2e -Wa,--trap
+cflags-$(CONFIG_CPU_LOONGSON2F) += -march=loongson2f -Wa,--trap
+# Some -march= flags enable MMI instructions, and GCC complains about that
+# support being enabled alongside -msoft-float. Thus explicitly disable MMI.
+cflags-$(CONFIG_CPU_LOONGSON2EF) += $(call cc-option,-mno-loongson-mmi)
+ifdef CONFIG_CPU_LOONGSON64
+cflags-$(CONFIG_CPU_LOONGSON64)	+= -Wa,--trap
+cflags-$(CONFIG_CC_IS_GCC) += -march=loongson3a
+cflags-$(CONFIG_CC_IS_CLANG) += -march=mips64r2
+endif
+cflags-$(CONFIG_CPU_LOONGSON64) += $(call cc-option,-mno-loongson-mmi)
+
 cflags-$(CONFIG_CPU_R4000_WORKAROUNDS)	+= $(call cc-option,-mfix-r4000,)
 cflags-$(CONFIG_CPU_R4400_WORKAROUNDS)	+= $(call cc-option,-mfix-r4400,)
 cflags-$(CONFIG_CPU_DADDI_WORKAROUNDS)	+= $(call cc-option,-mno-daddi,)
+ifdef CONFIG_CPU_LOONGSON2F_WORKAROUNDS
+cflags-$(CONFIG_CPU_NOP_WORKAROUNDS) += -Wa,-mfix-loongson2f-nop
+cflags-$(CONFIG_CPU_JUMP_WORKAROUNDS) += -Wa,-mfix-loongson2f-jump
+endif
+
+#
+# Some versions of binutils, not currently mainline as of 2019/02/04, support
+# an -mfix-loongson3-llsc flag which emits a sync prior to each ll instruction
+# to work around a CPU bug (see __SYNC_loongson3_war in asm/sync.h for a
+# description).
+#
+# We disable this in order to prevent the assembler meddling with the
+# instruction that labels refer to, ie. if we label an ll instruction:
+#
+# 1: ll v0, 0(a0)
+#
+# ...then with the assembler fix applied the label may actually point at a sync
+# instruction inserted by the assembler, and if we were using the label in an
+# exception table the table would no longer contain the address of the ll
+# instruction.
+#
+# Avoid this by explicitly disabling that assembler behaviour. If upstream
+# binutils does not merge support for the flag then we can revisit & remove
+# this later - for now it ensures vendor toolchains don't cause problems.
+#
+cflags-$(CONFIG_CPU_LOONGSON64)	+= $(call as-option,-Wa$(comma)-mno-fix-loongson3-llsc,)
 
 # For smartmips configurations, there are hundreds of warnings due to ISA overrides
 # in assembly and header files. smartmips is only supported for MIPS32r1 onwards
diff --git a/arch/mips/loongson2ef/Platform b/arch/mips/loongson2ef/Platform
index c6f7a4b959978..d446b705fba47 100644
--- a/arch/mips/loongson2ef/Platform
+++ b/arch/mips/loongson2ef/Platform
@@ -2,41 +2,6 @@
 # Loongson Processors' Support
 #
 
-cflags-$(CONFIG_CPU_LOONGSON2EF)	+= -Wa,--trap
-cflags-$(CONFIG_CPU_LOONGSON2E) += -march=loongson2e
-cflags-$(CONFIG_CPU_LOONGSON2F) += -march=loongson2f
-#
-# Some versions of binutils, not currently mainline as of 2019/02/04, support
-# an -mfix-loongson3-llsc flag which emits a sync prior to each ll instruction
-# to work around a CPU bug (see __SYNC_loongson3_war in asm/sync.h for a
-# description).
-#
-# We disable this in order to prevent the assembler meddling with the
-# instruction that labels refer to, ie. if we label an ll instruction:
-#
-# 1: ll v0, 0(a0)
-#
-# ...then with the assembler fix applied the label may actually point at a sync
-# instruction inserted by the assembler, and if we were using the label in an
-# exception table the table would no longer contain the address of the ll
-# instruction.
-#
-# Avoid this by explicitly disabling that assembler behaviour. If upstream
-# binutils does not merge support for the flag then we can revisit & remove
-# this later - for now it ensures vendor toolchains don't cause problems.
-#
-cflags-$(CONFIG_CPU_LOONGSON2EF)	+= $(call cc-option,-Wa$(comma)-mno-fix-loongson3-llsc,)
-
-# Enable the workarounds for Loongson2f
-ifdef CONFIG_CPU_LOONGSON2F_WORKAROUNDS
-cflags-$(CONFIG_CPU_NOP_WORKAROUNDS) += -Wa,-mfix-loongson2f-nop
-cflags-$(CONFIG_CPU_JUMP_WORKAROUNDS) += -Wa,-mfix-loongson2f-jump
-endif
-
-# Some -march= flags enable MMI instructions, and GCC complains about that
-# support being enabled alongside -msoft-float. Thus explicitly disable MMI.
-cflags-y += $(call cc-option,-mno-loongson-mmi)
-
 #
 # Loongson Machines' Support
 #
diff --git a/arch/mips/loongson64/Platform b/arch/mips/loongson64/Platform
index 473404cae1c44..49c9889e3d563 100644
--- a/arch/mips/loongson64/Platform
+++ b/arch/mips/loongson64/Platform
@@ -1,19 +1,3 @@
-#
-# Loongson Processors' Support
-#
-
-
-cflags-$(CONFIG_CPU_LOONGSON64)	+= -Wa,--trap
-
-ifdef CONFIG_CPU_LOONGSON64
-cflags-$(CONFIG_CC_IS_GCC) += -march=loongson3a
-cflags-$(CONFIG_CC_IS_CLANG) += -march=mips64r2
-endif
-
-# Some -march= flags enable MMI instructions, and GCC complains about that
-# support being enabled alongside -msoft-float. Thus explicitly disable MMI.
-cflags-y += $(call cc-option,-mno-loongson-mmi)
-
 #
 # Loongson Machines' Support
 #
-- 
2.39.2



