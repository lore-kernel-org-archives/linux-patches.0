Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571262773F7;
	Fri, 21 Nov 2025 13:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731439; cv=none; b=KC5ZItEnQazoe7Gb+cQnQHStB+k4n9jhsu4d6lpSxU2SSR8lxcVw7Pv1Fun8KOIuvz/iwkmi0kpuqb/45WqKWWFpjAsssMXiFjzQsUDz0jeBOLTLnA1wXSB24Ti9r11wOSUx0BejPcvxt29/VDlahy899OnpVMr2iZDZyRwp8b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731439; c=relaxed/simple;
	bh=O43wpPtvF15b0mgdR8fRScPhVkai7gY9WbHwWCaUzko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFzh2LzbL/QABoMJ8aAGj2A0Tdt5LakXUnnM0KTgdHsPvY6Bl+6j1UQEW/0cLGhS67RJqBdCIre54s1tmf1lddM1IjUBQltqbiDUV/xDn8z+JPpz/mmeXua8NF63f2rgvQg6bu+DdU5RB/vnHCMhIIOVygr9+6ntEu9Mo9+TxWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oz6Hdw9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oz6Hdw9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF72C4CEF1;
	Fri, 21 Nov 2025 13:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731439;
	bh=O43wpPtvF15b0mgdR8fRScPhVkai7gY9WbHwWCaUzko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oz6Hdw9VBp0NUReeujiSY7qsS4E8WkkfmF0DhudTMabOX9TLaT3a5BuqyiSvlYcFw
	 icf9hkyPnX8aRCuN6J9e7yyI9UmAtNTDVz75dSLGajCAwLc93A8DFJGwgv8aSCr9XE
	 st387BHMt0177uQD6E1ESC66gU8Wjb3LL1VYNXg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 208/247] LoongArch: Consolidate max_pfn & max_low_pfn calculation
Date: Fri, 21 Nov 2025 14:12:35 +0100
Message-ID: <20251121130202.192735749@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit ce5ad03e459ecb3b4993a8f311fd4f2fb3e6ef81 upstream.

Now there 5 places which calculate max_pfn & max_low_pfn:
1. in fdt_setup() for FDT systems;
2. in memblock_init() for ACPI systems;
3. in init_numa_memory() for NUMA systems;
4. in arch_mem_init() to recalculate for "mem=" cmdline;
5. in paging_init() to recalculate for NUMA systems.

Since memblock_init() is called both for ACPI and FDT systems, move the
calculation out of the for_each_efi_memory_desc() loop can eliminate the
first case. The last case is very questionable (may be derived from the
MIPS/Loongson code) and breaks the "mem=" cmdline, so should be removed.
And then the NUMA version of paging_init() can be also eliminated.

After consolidation there are 3 places of calculation:
1. in memblock_init() for both ACPI and FDT systems;
2. in init_numa_memory() to recalculate for NUMA systems;
3. in arch_mem_init() to recalculate for the "mem=" cmdline.

For all cases the calculation is:
max_pfn = PFN_DOWN(memblock_end_of_DRAM());
max_low_pfn = min(PFN_DOWN(HIGHMEM_START), max_pfn);

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/mem.c   |    7 +++----
 arch/loongarch/kernel/numa.c  |   23 ++---------------------
 arch/loongarch/kernel/setup.c |    5 ++---
 arch/loongarch/mm/init.c      |    2 --
 4 files changed, 7 insertions(+), 30 deletions(-)

--- a/arch/loongarch/kernel/mem.c
+++ b/arch/loongarch/kernel/mem.c
@@ -13,7 +13,7 @@
 void __init memblock_init(void)
 {
 	u32 mem_type;
-	u64 mem_start, mem_end, mem_size;
+	u64 mem_start, mem_size;
 	efi_memory_desc_t *md;
 
 	/* Parse memory information */
@@ -21,7 +21,6 @@ void __init memblock_init(void)
 		mem_type = md->type;
 		mem_start = md->phys_addr;
 		mem_size = md->num_pages << EFI_PAGE_SHIFT;
-		mem_end = mem_start + mem_size;
 
 		switch (mem_type) {
 		case EFI_LOADER_CODE:
@@ -31,8 +30,6 @@ void __init memblock_init(void)
 		case EFI_PERSISTENT_MEMORY:
 		case EFI_CONVENTIONAL_MEMORY:
 			memblock_add(mem_start, mem_size);
-			if (max_low_pfn < (mem_end >> PAGE_SHIFT))
-				max_low_pfn = mem_end >> PAGE_SHIFT;
 			break;
 		case EFI_PAL_CODE:
 		case EFI_UNUSABLE_MEMORY:
@@ -49,6 +46,8 @@ void __init memblock_init(void)
 		}
 	}
 
+	max_pfn = PFN_DOWN(memblock_end_of_DRAM());
+	max_low_pfn = min(PFN_DOWN(HIGHMEM_START), max_pfn);
 	memblock_set_current_limit(PFN_PHYS(max_low_pfn));
 
 	/* Reserve the first 2MB */
--- a/arch/loongarch/kernel/numa.c
+++ b/arch/loongarch/kernel/numa.c
@@ -272,7 +272,8 @@ int __init init_numa_memory(void)
 		node_mem_init(node);
 		node_set_online(node);
 	}
-	max_low_pfn = PHYS_PFN(memblock_end_of_DRAM());
+	max_pfn = PFN_DOWN(memblock_end_of_DRAM());
+	max_low_pfn = min(PFN_DOWN(HIGHMEM_START), max_pfn);
 
 	setup_nr_node_ids();
 	loongson_sysconf.nr_nodes = nr_node_ids;
@@ -283,26 +284,6 @@ int __init init_numa_memory(void)
 
 #endif
 
-void __init paging_init(void)
-{
-	unsigned int node;
-	unsigned long zones_size[MAX_NR_ZONES] = {0, };
-
-	for_each_online_node(node) {
-		unsigned long start_pfn, end_pfn;
-
-		get_pfn_range_for_nid(node, &start_pfn, &end_pfn);
-
-		if (end_pfn > max_low_pfn)
-			max_low_pfn = end_pfn;
-	}
-#ifdef CONFIG_ZONE_DMA32
-	zones_size[ZONE_DMA32] = MAX_DMA32_PFN;
-#endif
-	zones_size[ZONE_NORMAL] = max_low_pfn;
-	free_area_init(zones_size);
-}
-
 int pcibus_to_node(struct pci_bus *bus)
 {
 	return dev_to_node(&bus->dev);
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -294,8 +294,6 @@ static void __init fdt_setup(void)
 
 	early_init_dt_scan(fdt_pointer, __pa(fdt_pointer));
 	early_init_fdt_reserve_self();
-
-	max_low_pfn = PFN_PHYS(memblock_end_of_DRAM());
 #endif
 }
 
@@ -390,7 +388,8 @@ static void __init check_kernel_sections
 static void __init arch_mem_init(char **cmdline_p)
 {
 	/* Recalculate max_low_pfn for "mem=xxx" */
-	max_pfn = max_low_pfn = PHYS_PFN(memblock_end_of_DRAM());
+	max_pfn = PFN_DOWN(memblock_end_of_DRAM());
+	max_low_pfn = min(PFN_DOWN(HIGHMEM_START), max_pfn);
 
 	if (usermem)
 		pr_info("User-defined physical RAM map overwrite\n");
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -60,7 +60,6 @@ int __ref page_is_ram(unsigned long pfn)
 	return memblock_is_memory(addr) && !memblock_is_reserved(addr);
 }
 
-#ifndef CONFIG_NUMA
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
@@ -72,7 +71,6 @@ void __init paging_init(void)
 
 	free_area_init(max_zone_pfns);
 }
-#endif /* !CONFIG_NUMA */
 
 void __ref free_initmem(void)
 {


