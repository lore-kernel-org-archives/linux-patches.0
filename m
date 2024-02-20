Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EF0151CFB;
	Tue, 20 Feb 2024 21:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463679; cv=none; b=a2aj2Q9fj2GsJzTZJGfzqTVIKONJbj7jIlQ8VETA2Y9f0b+SoGA+oHGPwD/8+lwPf4AJdNP05/4+5+5BLzBhcRa3SeBcHD9nXKdWeRcZYqocGhGkFGvFqXG9yugBZ/UFi5n5mSkBWUp2l8szc5QA8lHQNjl3A4UvxmARR5aqTq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463679; c=relaxed/simple;
	bh=lkPZjqMxzH3IAL3zHBydF6otLYytUT4RxjhvVTFS+gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7LHsPBJCRCo475WOhV294p7fHG1scg4w8GibLYzYKpCjHwLdxFCtG4WlrKLl6LXxNjTA4XeyEBN88HKZZPUH8H3dAl0KgO4m9xOmxOJUn5rpo78wufuH7Fn9IrlYNdhUyAv72ayBvRMGbA1jESzUucxcWLh3sFj/Gr3FX1g22M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQV4/yKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQV4/yKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753D1C433F1;
	Tue, 20 Feb 2024 21:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463678;
	bh=lkPZjqMxzH3IAL3zHBydF6otLYytUT4RxjhvVTFS+gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQV4/yKeWMEgVmanpodQHFEQEnh6ncuZnOI+OZ2Lglj8XYr5LWevaVlm587L5TP3e
	 ObILzqmu6hoNoeH7DpMMSTRh8BOLLvGvuMfGKEmugb5HhD6vDVWaw4aU59XYh5nQR/
	 DCIbEw3cg2ay65ZUimuWO6SIpTrZAjXUzgDYcEPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/331] powerpc/6xx: set High BAT Enable flag on G2_LE cores
Date: Tue, 20 Feb 2024 21:53:26 +0100
Message-ID: <20240220205640.412408376@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4ae4ab9090a2..ade5f094dbd2 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -617,6 +617,8 @@
 #endif
 #define SPRN_HID2	0x3F8		/* Hardware Implementation Register 2 */
 #define SPRN_HID2_GEKKO	0x398		/* Gekko HID2 Register */
+#define SPRN_HID2_G2_LE	0x3F3		/* G2_LE HID2 Register */
+#define  HID2_G2_LE_HBE	(1<<18)		/* High BAT Enable (G2_LE) */
 #define SPRN_IABR	0x3F2	/* Instruction Address Breakpoint Register */
 #define SPRN_IABR2	0x3FA		/* 83xx */
 #define SPRN_IBCR	0x135		/* 83xx Insn Breakpoint Control Reg */
diff --git a/arch/powerpc/kernel/cpu_setup_6xx.S b/arch/powerpc/kernel/cpu_setup_6xx.S
index f29ce3dd6140..bfd3f442e5eb 100644
--- a/arch/powerpc/kernel/cpu_setup_6xx.S
+++ b/arch/powerpc/kernel/cpu_setup_6xx.S
@@ -26,6 +26,15 @@ BEGIN_FTR_SECTION
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
@@ -115,6 +124,16 @@ SYM_FUNC_START_LOCAL(setup_604_hid0)
 	blr
 SYM_FUNC_END(setup_604_hid0)
 
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
@@ -495,4 +514,3 @@ _GLOBAL(__restore_cpu_setup)
 	mtcr	r7
 	blr
 _ASM_NOKPROBE_SYMBOL(__restore_cpu_setup)
-
-- 
2.43.0



