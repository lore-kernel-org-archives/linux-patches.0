Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537A3A93C;
	Tue, 13 Feb 2024 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845849; cv=none; b=qG7rKfDpZzN18ew94+JQPyN2F7SNVm2/cyhjWT1/YZRzEgrQzHaiKuaZJ4iL57UPTcHHvaCWknOtg+LPo9nMbPUCNJ3ZtZ0VAn0y/cLr3CpR9DQhhbilY9Y4CbFdsbf3uwAueVdisa+dfg6UjcdZ2gMmroMGydBxgZd22x3pd/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845849; c=relaxed/simple;
	bh=oR6fjsbodhjmPlPMku2wi6ObbfLdNM6sr5yYSMqcdR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWSwTtNTrl0g9u3BmX5sTC1ynlNpYUFjNhKRPPP7nYA0VVr/mrBRgt20mfFczZYem4W/SXxlEWOjn4ggIsxcSpq4oS71oKlYka6+x7qs5hDvAidsgAi8IrCWOvtk37k/zu7QVyYpQrCHMk5U49dFPqIsTrHJqeAr+Ot0Ii7VTeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOs1eifA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOs1eifA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AFEC433F1;
	Tue, 13 Feb 2024 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845849;
	bh=oR6fjsbodhjmPlPMku2wi6ObbfLdNM6sr5yYSMqcdR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOs1eifAw1lRy2Ag2lxzt6WhEHiEighLpH8FBWfbKitDcygjO3Pw0qvdKvtm6C353
	 SB6CJyZXHzJpMk6W4+ApVLdogDASox1TxbVD2Td22fe625TV5tOWrF7H+erNprhigk
	 ZALV/qw7Rw71kv5CR4gxlHaPHPICW9dcodWGnbxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Chen <vincent.chen@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 074/124] riscv: mm: execute local TLB flush after populating vmemmap
Date: Tue, 13 Feb 2024 18:21:36 +0100
Message-ID: <20240213171855.899103453@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Chen <vincent.chen@sifive.com>

[ Upstream commit d9807d60c145836043ffa602328ea1d66dc458b1 ]

The spare_init() calls memmap_populate() many times to create VA to PA
mapping for the VMEMMAP area, where all "struct page" are located once
CONFIG_SPARSEMEM_VMEMMAP is defined. These "struct page" are later
initialized in the zone_sizes_init() function. However, during this
process, no sfence.vma instruction is executed for this VMEMMAP area.
This omission may cause the hart to fail to perform page table walk
because some data related to the address translation is invisible to the
hart. To solve this issue, the local_flush_tlb_kernel_range() is called
right after the sparse_init() to execute a sfence.vma instruction for this
VMEMMAP area, ensuring that all data related to the address translation
is visible to the hart.

Fixes: d95f1a542c3d ("RISC-V: Implement sparsemem")
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240117140333.2479667-1-vincent.chen@sifive.com
Fixes: 7a92fc8b4d20 ("mm: Introduce flush_cache_vmap_early()")
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/tlbflush.h | 1 +
 arch/riscv/mm/init.c              | 4 ++++
 arch/riscv/mm/tlbflush.c          | 3 ++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index a60416bbe190..51664ae4852e 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -67,6 +67,7 @@ static inline void flush_tlb_kernel_range(unsigned long start,
 
 #define flush_tlb_mm(mm) flush_tlb_all()
 #define flush_tlb_mm_range(mm, start, end, page_size) flush_tlb_all()
+#define local_flush_tlb_kernel_range(start, end) flush_tlb_all()
 #endif /* !CONFIG_SMP || !CONFIG_MMU */
 
 #endif /* _ASM_RISCV_TLBFLUSH_H */
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index ad77ed410d4d..ee224fe18d18 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1385,6 +1385,10 @@ void __init misc_mem_init(void)
 	early_memtest(min_low_pfn << PAGE_SHIFT, max_low_pfn << PAGE_SHIFT);
 	arch_numa_init();
 	sparse_init();
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	/* The entire VMEMMAP region has been populated. Flush TLB for this region */
+	local_flush_tlb_kernel_range(VMEMMAP_START, VMEMMAP_END);
+#endif
 	zone_sizes_init();
 	arch_reserve_crashkernel();
 	memblock_dump_all();
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 8aadc5f71c93..1f90721d22e9 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -66,9 +66,10 @@ static inline void local_flush_tlb_range_asid(unsigned long start,
 		local_flush_tlb_range_threshold_asid(start, size, stride, asid);
 }
 
+/* Flush a range of kernel pages without broadcasting */
 void local_flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
-	local_flush_tlb_range_asid(start, end, PAGE_SIZE, FLUSH_TLB_NO_ASID);
+	local_flush_tlb_range_asid(start, end - start, PAGE_SIZE, FLUSH_TLB_NO_ASID);
 }
 
 static void __ipi_flush_tlb_all(void *info)
-- 
2.43.0



