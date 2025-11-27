Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436C5334684;
	Thu, 27 Nov 2025 15:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255610; cv=none; b=BmwLoPt/DjbPB0uso8GAHx66y1KCtlV9zI3f3YBtURX5KVPAJuiZ0RK67cc7V8h5lnZGN0iZZ54LUZwgf/X0oZytcpblz0PAAa2NHCZVtXEctI+ZJmyxfARelkrk0gh6crvm/0xvmAXjiLPMcWrdHmyHfeYT4r+2x4wffxKvjMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255610; c=relaxed/simple;
	bh=rFg2VIXQr21m/oj+26taJ2GNX4LOiaHUh71DUoELc3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkSswx1ONhpg7v84m9mgOKlwoDaxtwcmJt6/lHjkIJwT7JAK/HGMPH49r6atexCy+3oH23EAu3Ikwd8wj5f2yoDIzjCnnZEqiQilbptQxHdTyFGrBQwltsRb8YM+QvYjhEr2YmpRc3HQ2YshSgriu02uFTSr+FPgvKKlMQxXMps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arXlxsjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arXlxsjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A8EC4CEF8;
	Thu, 27 Nov 2025 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255610;
	bh=rFg2VIXQr21m/oj+26taJ2GNX4LOiaHUh71DUoELc3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arXlxsjqUSaPuNUipMrbOu0SrliGjFvhOqSRg7Qj2HnIGfgSzak2ZULvYN/P2AZR2
	 RMKlB+O1baEZ4yczYqYbyGuJgEBlfWZ0nb+avnZgjo80xo7szfxIglG1MY2LLK2mfT
	 U+rqAAQZTDC2sLmIVl6ByC8gIh8IhBQQoEE9Hjho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 052/175] LoongArch: Fix NUMA node parsing with numa_memblks
Date: Thu, 27 Nov 2025 15:45:05 +0100
Message-ID: <20251127144044.865597576@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

commit acf5de1b23b0275eb69f235c8e9f2cef19fa39a1 upstream.

On physical machine, NUMA node id comes from high bit 44:48 of physical
address. However it is not true on virt machine. With general method, it
comes from ACPI SRAT table.

Here the common function numa_memblks_init() is used to parse NUMA node
information with numa_memblks.

Cc: <stable@vger.kernel.org>
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/numa.c |   60 ++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 42 deletions(-)

--- a/arch/loongarch/kernel/numa.c
+++ b/arch/loongarch/kernel/numa.c
@@ -158,35 +158,9 @@ static void __init node_mem_init(unsigne
 
 #ifdef CONFIG_ACPI_NUMA
 
-/*
- * add_numamem_region
- *
- * Add a uasable memory region described by BIOS. The
- * routine gets each intersection between BIOS's region
- * and node's region, and adds them into node's memblock
- * pool.
- *
- */
-static void __init add_numamem_region(u64 start, u64 end, u32 type)
-{
-	u32 node = pa_to_nid(start);
-	u64 size = end - start;
-	static unsigned long num_physpages;
-
-	if (start >= end) {
-		pr_debug("Invalid region: %016llx-%016llx\n", start, end);
-		return;
-	}
-
-	num_physpages += (size >> PAGE_SHIFT);
-	pr_info("Node%d: mem_type:%d, mem_start:0x%llx, mem_size:0x%llx Bytes\n",
-		node, type, start, size);
-	pr_info("       start_pfn:0x%llx, end_pfn:0x%llx, num_physpages:0x%lx\n",
-		start >> PAGE_SHIFT, end >> PAGE_SHIFT, num_physpages);
-	memblock_set_node(start, size, &memblock.memory, node);
-}
+static unsigned long num_physpages;
 
-static void __init init_node_memblock(void)
+static void __init info_node_memblock(void)
 {
 	u32 mem_type;
 	u64 mem_end, mem_start, mem_size;
@@ -206,12 +180,20 @@ static void __init init_node_memblock(vo
 		case EFI_BOOT_SERVICES_DATA:
 		case EFI_PERSISTENT_MEMORY:
 		case EFI_CONVENTIONAL_MEMORY:
-			add_numamem_region(mem_start, mem_end, mem_type);
+			num_physpages += (mem_size >> PAGE_SHIFT);
+			pr_info("Node%d: mem_type:%d, mem_start:0x%llx, mem_size:0x%llx Bytes\n",
+				(u32)pa_to_nid(mem_start), mem_type, mem_start, mem_size);
+			pr_info("       start_pfn:0x%llx, end_pfn:0x%llx, num_physpages:0x%lx\n",
+				mem_start >> PAGE_SHIFT, mem_end >> PAGE_SHIFT, num_physpages);
 			break;
 		case EFI_PAL_CODE:
 		case EFI_UNUSABLE_MEMORY:
 		case EFI_ACPI_RECLAIM_MEMORY:
-			add_numamem_region(mem_start, mem_end, mem_type);
+			num_physpages += (mem_size >> PAGE_SHIFT);
+			pr_info("Node%d: mem_type:%d, mem_start:0x%llx, mem_size:0x%llx Bytes\n",
+				(u32)pa_to_nid(mem_start), mem_type, mem_start, mem_size);
+			pr_info("       start_pfn:0x%llx, end_pfn:0x%llx, num_physpages:0x%lx\n",
+				mem_start >> PAGE_SHIFT, mem_end >> PAGE_SHIFT, num_physpages);
 			fallthrough;
 		case EFI_RESERVED_TYPE:
 		case EFI_RUNTIME_SERVICES_CODE:
@@ -249,22 +231,16 @@ int __init init_numa_memory(void)
 	for (i = 0; i < NR_CPUS; i++)
 		set_cpuid_to_node(i, NUMA_NO_NODE);
 
-	numa_reset_distance();
-	nodes_clear(numa_nodes_parsed);
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-	WARN_ON(memblock_clear_hotplug(0, PHYS_ADDR_MAX));
-
 	/* Parse SRAT and SLIT if provided by firmware. */
-	ret = acpi_disabled ? fake_numa_init() : acpi_numa_init();
+	if (!acpi_disabled)
+		ret = numa_memblks_init(acpi_numa_init, false);
+	else
+		ret = numa_memblks_init(fake_numa_init, false);
+
 	if (ret < 0)
 		return ret;
 
-	node_possible_map = numa_nodes_parsed;
-	if (WARN_ON(nodes_empty(node_possible_map)))
-		return -EINVAL;
-
-	init_node_memblock();
+	info_node_memblock();
 	if (!memblock_validate_numa_coverage(SZ_1M))
 		return -EINVAL;
 


