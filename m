Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5470624169B;
	Tue, 20 May 2025 13:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749554; cv=none; b=i1+aPwmGmec2kabVfXrPDsQvlcu63TJ0Q3+RtDHqGylyve5T/MItp1+xpRTH1ioim4AfODKX+WHwmwrIJKYDgb6shWQ8pMrgshTgVZtp7VFpBHbQ/vP3zVH/vfA9C5df+nRxncKmsUS+2pvayhcLTI7qylGcERjlc6iSmIBwnys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749554; c=relaxed/simple;
	bh=vjEbisoty+OYEpZ4lZrGGxud/t9N5b2XklgqRvRzQlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XvyLRp2PSUnThcivaEd2RJiui83M5LRDaZfiU4pg2FWe9PTZLHx8OeX7Vl+85Iq2eqLodqLKBErWsLYV8nSImjHyalzKZUvkebjer+84EFN+XlMczOwl6jSLjtAEJZpxz9xPU+ZNn09ZugRTSdUhGYVf7bh7sYzEV8Wx1z4W/fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxH3ul5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxH3ul5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7778C4CEE9;
	Tue, 20 May 2025 13:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749554;
	bh=vjEbisoty+OYEpZ4lZrGGxud/t9N5b2XklgqRvRzQlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxH3ul5Us94eSajDxiBjFW6TtLdghNVP0K7KQkUO+7UDXQCn1bZppwiTbrMs3q1HG
	 Q0ygNIa2UrmWwhGreFOCm20zvIYPQ46XftRvLmq044hZvCtQY1+wmhEvoBOj7g3npI
	 /Hoi2MFRhsps1mN1qtCH/3SOOw2YzIToALTWLaWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Lu <luxu.kernel@bytedance.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Zhaoyang Li <lizy04@hust.edu.cn>
Subject: [PATCH 6.1 81/97] riscv: mm: Fix the out of bound issue of vmemmap address
Date: Tue, 20 May 2025 15:50:46 +0200
Message-ID: <20250520125803.813630568@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Lu <luxu.kernel@bytedance.com>

commit f754f27e98f88428aaf6be6e00f5cbce97f62d4b upstream.

In sparse vmemmap model, the virtual address of vmemmap is calculated as:
((struct page *)VMEMMAP_START - (phys_ram_base >> PAGE_SHIFT)).
And the struct page's va can be calculated with an offset:
(vmemmap + (pfn)).

However, when initializing struct pages, kernel actually starts from the
first page from the same section that phys_ram_base belongs to. If the
first page's physical address is not (phys_ram_base >> PAGE_SHIFT), then
we get an va below VMEMMAP_START when calculating va for it's struct page.

For example, if phys_ram_base starts from 0x82000000 with pfn 0x82000, the
first page in the same section is actually pfn 0x80000. During
init_unavailable_range(), we will initialize struct page for pfn 0x80000
with virtual address ((struct page *)VMEMMAP_START - 0x2000), which is
below VMEMMAP_START as well as PCI_IO_END.

This commit fixes this bug by introducing a new variable
'vmemmap_start_pfn' which is aligned with memory section size and using
it to calculate vmemmap address instead of phys_ram_base.

Fixes: a11dd49dcb93 ("riscv: Sparse-Memory/vmemmap out-of-bounds fix")
Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Link: https://lore.kernel.org/r/20241209122617.53341-1-luxu.kernel@bytedance.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Zhaoyang Li <lizy04@hust.edu.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/page.h    |    1 +
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/riscv/mm/init.c             |   17 ++++++++++++++++-
 3 files changed, 18 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -115,6 +115,7 @@ struct kernel_mapping {
 
 extern struct kernel_mapping kernel_map;
 extern phys_addr_t phys_ram_base;
+extern unsigned long vmemmap_start_pfn;
 
 #define is_kernel_mapping(x)	\
 	((x) >= kernel_map.virt_addr && (x) < (kernel_map.virt_addr + kernel_map.size))
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -79,7 +79,7 @@
  * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if kernel
  * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
  */
-#define vmemmap		((struct page *)VMEMMAP_START - (phys_ram_base >> PAGE_SHIFT))
+#define vmemmap		((struct page *)VMEMMAP_START - vmemmap_start_pfn)
 
 #define PCI_IO_SIZE      SZ_16M
 #define PCI_IO_END       VMEMMAP_START
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -22,6 +22,7 @@
 #include <linux/hugetlb.h>
 
 #include <asm/fixmap.h>
+#include <asm/sparsemem.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/soc.h>
@@ -52,6 +53,13 @@ EXPORT_SYMBOL(pgtable_l5_enabled);
 phys_addr_t phys_ram_base __ro_after_init;
 EXPORT_SYMBOL(phys_ram_base);
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#define VMEMMAP_ADDR_ALIGN	(1ULL << SECTION_SIZE_BITS)
+
+unsigned long vmemmap_start_pfn __ro_after_init;
+EXPORT_SYMBOL(vmemmap_start_pfn);
+#endif
+
 unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)]
 							__page_aligned_bss;
 EXPORT_SYMBOL(empty_zero_page);
@@ -210,8 +218,12 @@ static void __init setup_bootmem(void)
 	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
 
 	phys_ram_end = memblock_end_of_DRAM();
-	if (!IS_ENABLED(CONFIG_XIP_KERNEL))
+	if (!IS_ENABLED(CONFIG_XIP_KERNEL)) {
 		phys_ram_base = memblock_start_of_DRAM();
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+		vmemmap_start_pfn = round_down(phys_ram_base, VMEMMAP_ADDR_ALIGN) >> PAGE_SHIFT;
+#endif
+}
 	/*
 	 * Reserve physical address space that would be mapped to virtual
 	 * addresses greater than (void *)(-PAGE_SIZE) because:
@@ -946,6 +958,9 @@ asmlinkage void __init setup_vm(uintptr_
 	kernel_map.xiprom_sz = (uintptr_t)(&_exiprom) - (uintptr_t)(&_xiprom);
 
 	phys_ram_base = CONFIG_PHYS_RAM_BASE;
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	vmemmap_start_pfn = round_down(phys_ram_base, VMEMMAP_ADDR_ALIGN) >> PAGE_SHIFT;
+#endif
 	kernel_map.phys_addr = (uintptr_t)CONFIG_PHYS_RAM_BASE;
 	kernel_map.size = (uintptr_t)(&_end) - (uintptr_t)(&_start);
 


