Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57CC5FEFF;
	Tue, 13 Feb 2024 17:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845473; cv=none; b=IbnenhNznEkJH27/UMBHZGe8Y/S8U1Ht57PActjRpKIV94RkkzsdjKhkIbXRC4UqYEAZ0cOO2EO879+CV0ktmizuSqi6vdhvhVJqAgS1pCfM1e+0u5u4DmlJ1uMlXdzWyqgGK6LXoTwxoKZ0gOqk4exBOZTi0ZszlJpssjLSOTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845473; c=relaxed/simple;
	bh=ywwFuIsUynJfgRdbh8vqlUDdb3XxEFvfNQd4kExDd1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0vkAzEX5GKX/cPZokueyjVg92+9f8eAG+74y/BqGJjfmlzD4njWzQWz0/k6EH61qhzwJipRo+NAywPl4IAMNenMo3CWSRK16Dk8iYS7HHIRTFV3oJQXVLtVgwlusEqQhKC3LB8knq1H1auZ5P/3OU/B6dSlk6r70k5DfWlm5Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9Mvumer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9Mvumer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27F2C433F1;
	Tue, 13 Feb 2024 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845472;
	bh=ywwFuIsUynJfgRdbh8vqlUDdb3XxEFvfNQd4kExDd1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9MvumerOb0AxhTYBGS1ERmxWmN5RyWys3KxPTqdFjUywcW5NePIGsZ95dUUP3iIU
	 zx4/4vlT/Nm3HhU0R0oUTbb0NXyWGrPGB1+24/mkn5DPRAnObkMLYOf3s1uUhrmWOc
	 Sre86gNmCth6W+TpfJkieVhGCs9V7zfq/D0//FxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Chen <vincent.chen@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/121] riscv: mm: execute local TLB flush after populating vmemmap
Date: Tue, 13 Feb 2024 18:21:38 +0100
Message-ID: <20240213171855.592015433@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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
index e71dd19ac801..b50faa232b5e 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1502,6 +1502,10 @@ void __init misc_mem_init(void)
 	early_memtest(min_low_pfn << PAGE_SHIFT, max_low_pfn << PAGE_SHIFT);
 	arch_numa_init();
 	sparse_init();
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	/* The entire VMEMMAP region has been populated. Flush TLB for this region */
+	local_flush_tlb_kernel_range(VMEMMAP_START, VMEMMAP_END);
+#endif
 	zone_sizes_init();
 	reserve_crashkernel();
 	memblock_dump_all();
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index b1ab6cf78e9e..bdee5de918e0 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -65,9 +65,10 @@ static inline void local_flush_tlb_range_asid(unsigned long start,
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



