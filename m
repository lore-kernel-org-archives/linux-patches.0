Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579A81DFEF;
	Wed, 20 Nov 2024 13:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107662; cv=none; b=RLdu8QCn8uB6P1Y36VEZHecNTVRLWQOGEOa/6YMpLrUHsBJP2F16NVjLXv85UP19FpoVSFQK6A408RUOMhd8Vxlr3vxiGS9R3M43ffZgMbp4zqt+21UVI609wlkPZ4M46mn5YSN5/i4RbHhfzmU6T2cmsM1Tf7ATorzvFuNbzSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107662; c=relaxed/simple;
	bh=iFCCXO6XJEABb+s+zKRc5noQ8UbIjC2ps2CL7ngTCYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiX+dmjQKpz+Rq1pTvu9Lak6x7pQ/t13f4rOwaC66sz77Y7zJYd9L7T/Vds0Spanu/Oy1AiPKvSN/O5QAATbTtAA+e02W3vEnVs7sUm6mbr2jTT4AUeR48E+7ehlsjh2PrdV5rVhY16OkMfQItCaxVXreFdYhPxhM94orzpF1Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcCj6oAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcCj6oAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E055C4CECD;
	Wed, 20 Nov 2024 13:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107662;
	bh=iFCCXO6XJEABb+s+zKRc5noQ8UbIjC2ps2CL7ngTCYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcCj6oACHspShuCKxAtivweE7g/k5Sf0ZBQoi+ET/yWY/BfbRfvU6Yoy5O5IabWcM
	 pjps30HyuTpHOtHmB9Xcke+7NfWhDmt3s1eN/3Cj0PF/PYiJlUyJEIsmIk6/Efk9cz
	 KGzLuQlTxmLpOYUOluD6WGtBqWz3Q+ZGPO+8Tp4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harith George <harith.g@alifsemi.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/73] ARM: 9419/1: mm: Fix kernel memory mapping for xip kernels
Date: Wed, 20 Nov 2024 13:58:01 +0100
Message-ID: <20241120125809.988257656@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

From: Harith G <harith.g@alifsemi.com>

[ Upstream commit ed6cbe6e5563452f305e89c15846820f2874e431 ]

The patchset introducing kernel_sec_start/end variables to separate the
kernel/lowmem memory mappings, broke the mapping of the kernel memory
for xipkernels.

kernel_sec_start/end variables are in RO area before the MMU is switched
on for xipkernels.
So these cannot be set early in boot in head.S. Fix this by setting these
after MMU is switched on.
xipkernels need two different mappings for kernel text (starting at
CONFIG_XIP_PHYS_ADDR) and data (starting at CONFIG_PHYS_OFFSET).
Also, move the kernel code mapping from devicemaps_init() to map_kernel().

Fixes: a91da5457085 ("ARM: 9089/1: Define kernel physical section start and end")
Signed-off-by: Harith George <harith.g@alifsemi.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/head.S |  8 ++++++--
 arch/arm/mm/mmu.c      | 34 +++++++++++++++++++++-------------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 29e2900178a1f..b97da9e069a06 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -252,11 +252,15 @@ __create_page_tables:
 	 */
 	add	r0, r4, #KERNEL_OFFSET >> (SECTION_SHIFT - PMD_ENTRY_ORDER)
 	ldr	r6, =(_end - 1)
+
+	/* For XIP, kernel_sec_start/kernel_sec_end are currently in RO memory */
+#ifndef CONFIG_XIP_KERNEL
 	adr_l	r5, kernel_sec_start		@ _pa(kernel_sec_start)
 #if defined CONFIG_CPU_ENDIAN_BE8 || defined CONFIG_CPU_ENDIAN_BE32
 	str	r8, [r5, #4]			@ Save physical start of kernel (BE)
 #else
 	str	r8, [r5]			@ Save physical start of kernel (LE)
+#endif
 #endif
 	orr	r3, r8, r7			@ Add the MMU flags
 	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ENTRY_ORDER)
@@ -264,6 +268,7 @@ __create_page_tables:
 	add	r3, r3, #1 << SECTION_SHIFT
 	cmp	r0, r6
 	bls	1b
+#ifndef CONFIG_XIP_KERNEL
 	eor	r3, r3, r7			@ Remove the MMU flags
 	adr_l	r5, kernel_sec_end		@ _pa(kernel_sec_end)
 #if defined CONFIG_CPU_ENDIAN_BE8 || defined CONFIG_CPU_ENDIAN_BE32
@@ -271,8 +276,7 @@ __create_page_tables:
 #else
 	str	r3, [r5]			@ Save physical end of kernel (LE)
 #endif
-
-#ifdef CONFIG_XIP_KERNEL
+#else
 	/*
 	 * Map the kernel image separately as it is not located in RAM.
 	 */
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 463fc2a8448f0..a39a7043f1896 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1401,18 +1401,6 @@ static void __init devicemaps_init(const struct machine_desc *mdesc)
 		create_mapping(&map);
 	}
 
-	/*
-	 * Map the kernel if it is XIP.
-	 * It is always first in the modulearea.
-	 */
-#ifdef CONFIG_XIP_KERNEL
-	map.pfn = __phys_to_pfn(CONFIG_XIP_PHYS_ADDR & SECTION_MASK);
-	map.virtual = MODULES_VADDR;
-	map.length = ((unsigned long)_exiprom - map.virtual + ~SECTION_MASK) & SECTION_MASK;
-	map.type = MT_ROM;
-	create_mapping(&map);
-#endif
-
 	/*
 	 * Map the cache flushing regions.
 	 */
@@ -1602,12 +1590,27 @@ static void __init map_kernel(void)
 	 * This will only persist until we turn on proper memory management later on
 	 * and we remap the whole kernel with page granularity.
 	 */
+#ifdef CONFIG_XIP_KERNEL
+	phys_addr_t kernel_nx_start = kernel_sec_start;
+#else
 	phys_addr_t kernel_x_start = kernel_sec_start;
 	phys_addr_t kernel_x_end = round_up(__pa(__init_end), SECTION_SIZE);
 	phys_addr_t kernel_nx_start = kernel_x_end;
+#endif
 	phys_addr_t kernel_nx_end = kernel_sec_end;
 	struct map_desc map;
 
+	/*
+	 * Map the kernel if it is XIP.
+	 * It is always first in the modulearea.
+	 */
+#ifdef CONFIG_XIP_KERNEL
+	map.pfn = __phys_to_pfn(CONFIG_XIP_PHYS_ADDR & SECTION_MASK);
+	map.virtual = MODULES_VADDR;
+	map.length = ((unsigned long)_exiprom - map.virtual + ~SECTION_MASK) & SECTION_MASK;
+	map.type = MT_ROM;
+	create_mapping(&map);
+#else
 	map.pfn = __phys_to_pfn(kernel_x_start);
 	map.virtual = __phys_to_virt(kernel_x_start);
 	map.length = kernel_x_end - kernel_x_start;
@@ -1617,7 +1620,7 @@ static void __init map_kernel(void)
 	/* If the nx part is small it may end up covered by the tail of the RWX section */
 	if (kernel_x_end == kernel_nx_end)
 		return;
-
+#endif
 	map.pfn = __phys_to_pfn(kernel_nx_start);
 	map.virtual = __phys_to_virt(kernel_nx_start);
 	map.length = kernel_nx_end - kernel_nx_start;
@@ -1762,6 +1765,11 @@ void __init paging_init(const struct machine_desc *mdesc)
 {
 	void *zero_page;
 
+#ifdef CONFIG_XIP_KERNEL
+	/* Store the kernel RW RAM region start/end in these variables */
+	kernel_sec_start = CONFIG_PHYS_OFFSET & SECTION_MASK;
+	kernel_sec_end = round_up(__pa(_end), SECTION_SIZE);
+#endif
 	pr_debug("physical kernel sections: 0x%08llx-0x%08llx\n",
 		 kernel_sec_start, kernel_sec_end);
 
-- 
2.43.0



