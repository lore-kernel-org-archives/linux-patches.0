Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0219C2253FD;
	Thu, 12 Dec 2024 16:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021674; cv=none; b=YjVc0w+83sk6sVp6YbY2AipiUUaNwudjfEChI0O6CEy0Y1tpH45RypDiiAH7Fuv9Cm7Ex+DJrvuW3qsLGf+3wcqrG23TD7N0ZruuxpKv6IjrA+3H0tfoGULmiQ1p/Gd5lHf1RJXhmC4OHy+kmHqVwifuDeUoC+KYKOOeAbL0ixE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021674; c=relaxed/simple;
	bh=FyZPqs4aBb8gx9A2zidsebURhaKWmAFTFUdD6phBAqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMD9sL/JMnvTVwUfIktQlbXczP4CbyWhv3ZVD2dAkf+rTeLRP7PtRt386Ya7BsVZU1nWdNgNZX9YPFbCDqNIlfAiaH2DPzspOzg9YE78wxCc+K81M3mTwCN7pe9tJyuDsMftTIMkll0ynnfyMJncm5fDcCpI4j7lM+IpogRNb5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIsk7gia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIsk7gia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E8AC4CECE;
	Thu, 12 Dec 2024 16:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021673;
	bh=FyZPqs4aBb8gx9A2zidsebURhaKWmAFTFUdD6phBAqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIsk7giaYV6E2DoZkwCUBzLR6XMNdjcOqH2H3xl9/+e7VuN84XWBx1M7OCla9Z5DY
	 DTb0LCXWR8bgd5ZR4F2kAKgzboLBQ+5WNsXGT85PsRYj5GbVT/chgRmzGPyZLyagsn
	 PZAR7VZIOKXstttwx8y5ApGIQ3sEcT0jljhA0L50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harith George <harith.g@alifsemi.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/565] ARM: 9419/1: mm: Fix kernel memory mapping for xip kernels
Date: Thu, 12 Dec 2024 15:53:38 +0100
Message-ID: <20241212144312.365206316@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3fc7f9750ce4b..0638d20061d8c 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -252,11 +252,15 @@ __create_page_tables:
 	 */
 	add	r0, r4, #KERNEL_OFFSET >> (SECTION_SHIFT - PMD_ORDER)
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
 	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ORDER)
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
index 83a91e0ab8480..fc0ef1c913c1b 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1381,18 +1381,6 @@ static void __init devicemaps_init(const struct machine_desc *mdesc)
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
@@ -1582,12 +1570,27 @@ static void __init map_kernel(void)
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
@@ -1597,7 +1600,7 @@ static void __init map_kernel(void)
 	/* If the nx part is small it may end up covered by the tail of the RWX section */
 	if (kernel_x_end == kernel_nx_end)
 		return;
-
+#endif
 	map.pfn = __phys_to_pfn(kernel_nx_start);
 	map.virtual = __phys_to_virt(kernel_nx_start);
 	map.length = kernel_nx_end - kernel_nx_start;
@@ -1742,6 +1745,11 @@ void __init paging_init(const struct machine_desc *mdesc)
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



