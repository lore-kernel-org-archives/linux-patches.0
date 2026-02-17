Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683E8320CD9;
	Tue, 17 Feb 2026 20:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360838; cv=none; b=W53J95WhqhAl9I1NXNukolavphSZ6SUrrhZC+aMQyPJBa4HCf1aCSdvXU5KjgnSPCwD78NX1hqBhB7z8maxMjMyzHQibT0GJ1KqNgEdi1toBzOogoF1tvYJBRAeFxmm3HutJchD16TyIOrLCYmFcCKVO6Z3wY4H49/7qHwKmQvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360838; c=relaxed/simple;
	bh=qoe2CfW+wUozm/ht/UpvCUCmaSXKSPXEl+fynINZMF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9845JAsyaYDQab7+82cCmjpcnI5unQDbON2pm8k0mspPvMSNFtAYO6wLGQQiulb8X58gmNv7sdE8DuxS9E8ZDuZl2ImCiSWFeKAb3ikrjo0JzLuUz3Q27dbdv2ecoa4qu6o5xQhTpltfThvwI1Pxufx69x5BjnE3+0WfLsTsSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oa2xCTsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oa2xCTsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9F6C4CEF7;
	Tue, 17 Feb 2026 20:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360838;
	bh=qoe2CfW+wUozm/ht/UpvCUCmaSXKSPXEl+fynINZMF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oa2xCTsQniDJ21x7FchgUYWDr2FhA1oJbDeOXIB4g2r0McTambnsfosCz+0pBTgBc
	 yh8uKQ2Xg1AATT8Pz0lzZSse44WUcc53iQTmFrL4+5YsYbzPAVnF/yrnB5C59D4Y8S
	 +LrZ80kDqOlEm1tJfwClgaJx7OgmkZD2qeY81Iy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 29/39] LoongArch: Add writecombine support for DMW-based ioremap()
Date: Tue, 17 Feb 2026 21:30:51 +0100
Message-ID: <20260217200005.332863620@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 8e02c3b782ec64343f3cccc8dc5a8be2b379e80b upstream.

Currently, only TLB-based ioremap() support writecombine, so add the
counterpart for DMW-based ioremap() with help of DMW2. The base address
(WRITECOMBINE_BASE) is configured as 0xa000000000000000.

DMW3 is unused by kernel now, however firmware may leave garbage in them
and interfere kernel's address mapping. So clear it as necessary.

BTW, centralize the DMW configuration to macro SETUP_DMWINS.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/addrspace.h   |    4 ++++
 arch/loongarch/include/asm/io.h          |   10 ++++++++--
 arch/loongarch/include/asm/loongarch.h   |   10 +++++++++-
 arch/loongarch/include/asm/stackframe.h  |   11 +++++++++++
 arch/loongarch/kernel/head.S             |   11 ++---------
 arch/loongarch/power/suspend_asm.S       |    6 +-----
 drivers/firmware/efi/libstub/loongarch.c |    2 ++
 7 files changed, 37 insertions(+), 17 deletions(-)

--- a/arch/loongarch/include/asm/addrspace.h
+++ b/arch/loongarch/include/asm/addrspace.h
@@ -36,6 +36,10 @@ extern unsigned long vm_map_base;
 #define UNCACHE_BASE		CSR_DMW0_BASE
 #endif
 
+#ifndef WRITECOMBINE_BASE
+#define WRITECOMBINE_BASE	CSR_DMW2_BASE
+#endif
+
 #define DMW_PABITS	48
 #define TO_PHYS_MASK	((1ULL << DMW_PABITS) - 1)
 
--- a/arch/loongarch/include/asm/io.h
+++ b/arch/loongarch/include/asm/io.h
@@ -30,10 +30,16 @@ extern void __init early_iounmap(void __
 static inline void __iomem *ioremap_prot(phys_addr_t offset, unsigned long size,
 					 unsigned long prot_val)
 {
-	if (prot_val & _CACHE_CC)
+	switch (prot_val & _CACHE_MASK) {
+	case _CACHE_CC:
 		return (void __iomem *)(unsigned long)(CACHE_BASE + offset);
-	else
+	case _CACHE_SUC:
 		return (void __iomem *)(unsigned long)(UNCACHE_BASE + offset);
+	case _CACHE_WUC:
+		return (void __iomem *)(unsigned long)(WRITECOMBINE_BASE + offset);
+	default:
+		return NULL;
+	}
 }
 
 #define ioremap(offset, size)		\
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -856,7 +856,7 @@
 #define LOONGARCH_CSR_DMWIN2		0x182	/* 64 direct map win2: MEM */
 #define LOONGARCH_CSR_DMWIN3		0x183	/* 64 direct map win3: MEM */
 
-/* Direct Map window 0/1 */
+/* Direct Map window 0/1/2/3 */
 #define CSR_DMW0_PLV0		_CONST64_(1 << 0)
 #define CSR_DMW0_VSEG		_CONST64_(0x8000)
 #define CSR_DMW0_BASE		(CSR_DMW0_VSEG << DMW_PABITS)
@@ -868,6 +868,14 @@
 #define CSR_DMW1_BASE		(CSR_DMW1_VSEG << DMW_PABITS)
 #define CSR_DMW1_INIT		(CSR_DMW1_BASE | CSR_DMW1_MAT | CSR_DMW1_PLV0)
 
+#define CSR_DMW2_PLV0		_CONST64_(1 << 0)
+#define CSR_DMW2_MAT		_CONST64_(2 << 4)
+#define CSR_DMW2_VSEG		_CONST64_(0xa000)
+#define CSR_DMW2_BASE		(CSR_DMW2_VSEG << DMW_PABITS)
+#define CSR_DMW2_INIT		(CSR_DMW2_BASE | CSR_DMW2_MAT | CSR_DMW2_PLV0)
+
+#define CSR_DMW3_INIT		0x0
+
 /* Performance Counter registers */
 #define LOONGARCH_CSR_PERFCTRL0		0x200	/* 32 perf event 0 config */
 #define LOONGARCH_CSR_PERFCNTR0		0x201	/* 64 perf event 0 count value */
--- a/arch/loongarch/include/asm/stackframe.h
+++ b/arch/loongarch/include/asm/stackframe.h
@@ -37,6 +37,17 @@
 	cfi_restore \reg \offset \docfi
 	.endm
 
+	.macro SETUP_DMWINS temp
+	li.d	\temp, CSR_DMW0_INIT	# WUC, PLV0, 0x8000 xxxx xxxx xxxx
+	csrwr	\temp, LOONGARCH_CSR_DMWIN0
+	li.d	\temp, CSR_DMW1_INIT	# CAC, PLV0, 0x9000 xxxx xxxx xxxx
+	csrwr	\temp, LOONGARCH_CSR_DMWIN1
+	li.d	\temp, CSR_DMW2_INIT	# WUC, PLV0, 0xa000 xxxx xxxx xxxx
+	csrwr	\temp, LOONGARCH_CSR_DMWIN2
+	li.d	\temp, CSR_DMW3_INIT	# 0x0, unused
+	csrwr	\temp, LOONGARCH_CSR_DMWIN3
+	.endm
+
 /* Jump to the runtime virtual address. */
 	.macro JUMP_VIRT_ADDR temp1 temp2
 	li.d	\temp1, CACHE_BASE
--- a/arch/loongarch/kernel/head.S
+++ b/arch/loongarch/kernel/head.S
@@ -44,11 +44,7 @@ SYM_DATA(kernel_fsize, .long _kernel_fsi
 SYM_CODE_START(kernel_entry)			# kernel entry point
 
 	/* Config direct window and set PG */
-	li.d		t0, CSR_DMW0_INIT	# UC, PLV0, 0x8000 xxxx xxxx xxxx
-	csrwr		t0, LOONGARCH_CSR_DMWIN0
-	li.d		t0, CSR_DMW1_INIT	# CA, PLV0, 0x9000 xxxx xxxx xxxx
-	csrwr		t0, LOONGARCH_CSR_DMWIN1
-
+	SETUP_DMWINS	t0
 	JUMP_VIRT_ADDR	t0, t1
 
 	/* Enable PG */
@@ -119,11 +115,8 @@ SYM_CODE_END(kernel_entry)
  * function after setting up the stack and tp registers.
  */
 SYM_CODE_START(smpboot_entry)
-	li.d		t0, CSR_DMW0_INIT	# UC, PLV0
-	csrwr		t0, LOONGARCH_CSR_DMWIN0
-	li.d		t0, CSR_DMW1_INIT	# CA, PLV0
-	csrwr		t0, LOONGARCH_CSR_DMWIN1
 
+	SETUP_DMWINS	t0
 	JUMP_VIRT_ADDR	t0, t1
 
 	/* Enable PG */
--- a/arch/loongarch/power/suspend_asm.S
+++ b/arch/loongarch/power/suspend_asm.S
@@ -73,11 +73,7 @@ SYM_FUNC_START(loongarch_suspend_enter)
 	 * Reload all of the registers and return.
 	 */
 SYM_INNER_LABEL(loongarch_wakeup_start, SYM_L_GLOBAL)
-	li.d		t0, CSR_DMW0_INIT	# UC, PLV0
-	csrwr		t0, LOONGARCH_CSR_DMWIN0
-	li.d		t0, CSR_DMW1_INIT	# CA, PLV0
-	csrwr		t0, LOONGARCH_CSR_DMWIN1
-
+	SETUP_DMWINS	t0
 	JUMP_VIRT_ADDR	t0, t1
 
 	/* Enable PG */
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -74,6 +74,8 @@ efi_status_t efi_boot_kernel(void *handl
 	/* Config Direct Mapping */
 	csr_write64(CSR_DMW0_INIT, LOONGARCH_CSR_DMWIN0);
 	csr_write64(CSR_DMW1_INIT, LOONGARCH_CSR_DMWIN1);
+	csr_write64(CSR_DMW2_INIT, LOONGARCH_CSR_DMWIN2);
+	csr_write64(CSR_DMW3_INIT, LOONGARCH_CSR_DMWIN3);
 
 	real_kernel_entry = (void *)kernel_entry_address(kernel_addr, image);
 


