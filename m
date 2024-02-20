Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B59E14A4E2;
	Tue, 20 Feb 2024 21:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462854; cv=none; b=h0RWYrHs4o5supkmzH/vsc7X07pt5J+T0XuLwvOJQpp3vDiufwfzm+O59KwES35VPCT/44coeJ374psnBu2+lTHCQt8TGbVPmpuAm3CL5ZQ8qy07jqr5KI/jTtdxBYza08CvGuRqItYKL+JG9lfJr4mf5gY2xZidpPb08xdddPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462854; c=relaxed/simple;
	bh=ErR+YrrDfnJ8A1ddpsbi5FiSrXc2AeYA3lJQPUYaTtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGjDVPAh4hmcK2TRncv1w2Cn8e276nca2jeK8i07/F1egGZ3dbym38tzBFnodpJdr+7R+vEVUsm2nbv1sLT7yU8ni/DSxcB5Lvg6eZpdw3H6n02wc6Qhj3M067ibqEy+i2kgvG3DFBv68xJPu5CYuiQzCtummUDXoO5aUje9A0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7r9+UH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7r9+UH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB365C433C7;
	Tue, 20 Feb 2024 21:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462854;
	bh=ErR+YrrDfnJ8A1ddpsbi5FiSrXc2AeYA3lJQPUYaTtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7r9+UH2y7eIaYqXnLUqxnQ9y3YFVLzY4yJgIgJ1ZL0R3PNNkAZ+onQNIz3GcOtHH
	 pLO2aQ5/08ITwLZ+BoFapSnCB/bIcf4YA9Vt1Kw14vwMHCUaMQP5k4nHOP6bUVzpT9
	 7HhagqZfpURPlqdIyjML9eBcmZm4wYPNOWvx7CVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/197] powerpc/6xx: set High BAT Enable flag on G2_LE cores
Date: Tue, 20 Feb 2024 21:50:16 +0100
Message-ID: <20240220204842.785276426@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit a038a3ff8c6582404834852c043dadc73a5b68b4 ]

MMU_FTR_USE_HIGH_BATS is set for G2_LE cores and derivatives like e300cX,
but the high BATs need to be enabled in HID2 to work. Add register
definitions and add the needed setup to __setup_cpu_603.

This fixes boot on CPUs like the MPC5200B with STRICT_KERNEL_RWX enabled
on systems where the flag has not been set by the bootloader already.

Fixes: e4d6654ebe6e ("powerpc/mm/32s: rework mmu_mapin_ram()")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240124103838.43675-1-matthias.schiffer@ew.tq-group.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/reg.h      |  2 ++
 arch/powerpc/kernel/cpu_setup_6xx.S | 20 +++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 8fda87af2fa5..6c0ab745f0c8 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -608,6 +608,8 @@
 #endif
 #define SPRN_HID2	0x3F8		/* Hardware Implementation Register 2 */
 #define SPRN_HID2_GEKKO	0x398		/* Gekko HID2 Register */
+#define SPRN_HID2_G2_LE	0x3F3		/* G2_LE HID2 Register */
+#define  HID2_G2_LE_HBE	(1<<18)		/* High BAT Enable (G2_LE) */
 #define SPRN_IABR	0x3F2	/* Instruction Address Breakpoint Register */
 #define SPRN_IABR2	0x3FA		/* 83xx */
 #define SPRN_IBCR	0x135		/* 83xx Insn Breakpoint Control Reg */
diff --git a/arch/powerpc/kernel/cpu_setup_6xx.S b/arch/powerpc/kernel/cpu_setup_6xx.S
index f8b5ff64b604..6cbad50c71f6 100644
--- a/arch/powerpc/kernel/cpu_setup_6xx.S
+++ b/arch/powerpc/kernel/cpu_setup_6xx.S
@@ -24,6 +24,15 @@ BEGIN_FTR_SECTION
 	bl	__init_fpu_registers
 END_FTR_SECTION_IFCLR(CPU_FTR_FPU_UNAVAILABLE)
 	bl	setup_common_caches
+
+	/*
+	 * This assumes that all cores using __setup_cpu_603 with
+	 * MMU_FTR_USE_HIGH_BATS are G2_LE compatible
+	 */
+BEGIN_MMU_FTR_SECTION
+	bl      setup_g2_le_hid2
+END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
+
 	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_604)
@@ -111,6 +120,16 @@ setup_604_hid0:
 	isync
 	blr
 
+/* Enable high BATs for G2_LE and derivatives like e300cX */
+SYM_FUNC_START_LOCAL(setup_g2_le_hid2)
+	mfspr	r11,SPRN_HID2_G2_LE
+	oris	r11,r11,HID2_G2_LE_HBE@h
+	mtspr	SPRN_HID2_G2_LE,r11
+	sync
+	isync
+	blr
+SYM_FUNC_END(setup_g2_le_hid2)
+
 /* 7400 <= rev 2.7 and 7410 rev = 1.0 suffer from some
  * erratas we work around here.
  * Moto MPC710CE.pdf describes them, those are errata
@@ -485,4 +504,3 @@ _GLOBAL(__restore_cpu_setup)
 	mtcr	r7
 	blr
 _ASM_NOKPROBE_SYMBOL(__restore_cpu_setup)
-
-- 
2.43.0



