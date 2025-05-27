Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E956627FD4C;
	Tue, 27 May 2025 17:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366822; cv=none; b=LFdqcipTIu85WiZFvbGAneqUPKV31m1OqTXrIi2wHS4nkLFdxodazI79cwau8zP6vH8wkBR6LufoghRgeDadMZlH6W7qc7N0esQL+bchnmCVCgnOdREEKt/iNUqvSa939PDxU9/ilhOR1fNZr1SYCiYV1/KMwiQtvoEFtNNHlz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366822; c=relaxed/simple;
	bh=CMqChhqvR10GbeVOyiTHY0Scv8HpigkAeM0bAvOCShc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TxtPi3E9CwXrU797I39RkAkdyoYwH8eDHivEGdXayjRVRD7xhFN0+sYCuP1TSfFr/3E5UJXnj0W5VXdaRGXn6LfKrk6RrU1Aud0JdbJp9RhLPm2IMN4QgUWjs/w5jdi6afMI9TUhStHLNhMj2sjnpsBUZESAcXX4Ti/DJrFTKzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0oLrBG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0oLrBG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C90DC4CEEB;
	Tue, 27 May 2025 17:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366821;
	bh=CMqChhqvR10GbeVOyiTHY0Scv8HpigkAeM0bAvOCShc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0oLrBG7O2usb44IuNnaYFaunlGwZrUM+jJxcM3xComS7sbwUzLcGndIUychiWEzi
	 fEbX8Cql8bb5p/i8n7ZZrBhhFAy56j8tArIw3BiCC/n6Px+zlPLmS+dWlpzNGOlM6V
	 fbacm8LTXMTeMvqYTw+xmU8MOqacuhw4HuvFhrXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 156/783] riscv: Call secondary mmu notifier when flushing the tlb
Date: Tue, 27 May 2025 18:19:13 +0200
Message-ID: <20250527162519.525299435@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit d9be2b9b60497a82aeceec3a98d8b37fdd2960f2 ]

This is required to allow the IOMMU driver to correctly flush its own
TLB.

Reviewed-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20250113142424.30487-1-alexghiti@rivosinc.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/tlbflush.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 9b6e86ce38674..bb77607c87aa2 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -4,6 +4,7 @@
 #include <linux/smp.h>
 #include <linux/sched.h>
 #include <linux/hugetlb.h>
+#include <linux/mmu_notifier.h>
 #include <asm/sbi.h>
 #include <asm/mmu_context.h>
 
@@ -78,10 +79,17 @@ static void __ipi_flush_tlb_range_asid(void *info)
 	local_flush_tlb_range_asid(d->start, d->size, d->stride, d->asid);
 }
 
-static void __flush_tlb_range(const struct cpumask *cmask, unsigned long asid,
+static inline unsigned long get_mm_asid(struct mm_struct *mm)
+{
+	return mm ? cntx2asid(atomic_long_read(&mm->context.id)) : FLUSH_TLB_NO_ASID;
+}
+
+static void __flush_tlb_range(struct mm_struct *mm,
+			      const struct cpumask *cmask,
 			      unsigned long start, unsigned long size,
 			      unsigned long stride)
 {
+	unsigned long asid = get_mm_asid(mm);
 	unsigned int cpu;
 
 	if (cpumask_empty(cmask))
@@ -105,30 +113,26 @@ static void __flush_tlb_range(const struct cpumask *cmask, unsigned long asid,
 	}
 
 	put_cpu();
-}
 
-static inline unsigned long get_mm_asid(struct mm_struct *mm)
-{
-	return cntx2asid(atomic_long_read(&mm->context.id));
+	if (mm)
+		mmu_notifier_arch_invalidate_secondary_tlbs(mm, start, start + size);
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	__flush_tlb_range(mm_cpumask(mm), get_mm_asid(mm),
-			  0, FLUSH_TLB_MAX_SIZE, PAGE_SIZE);
+	__flush_tlb_range(mm, mm_cpumask(mm), 0, FLUSH_TLB_MAX_SIZE, PAGE_SIZE);
 }
 
 void flush_tlb_mm_range(struct mm_struct *mm,
 			unsigned long start, unsigned long end,
 			unsigned int page_size)
 {
-	__flush_tlb_range(mm_cpumask(mm), get_mm_asid(mm),
-			  start, end - start, page_size);
+	__flush_tlb_range(mm, mm_cpumask(mm), start, end - start, page_size);
 }
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 {
-	__flush_tlb_range(mm_cpumask(vma->vm_mm), get_mm_asid(vma->vm_mm),
+	__flush_tlb_range(vma->vm_mm, mm_cpumask(vma->vm_mm),
 			  addr, PAGE_SIZE, PAGE_SIZE);
 }
 
@@ -161,13 +165,13 @@ void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 		}
 	}
 
-	__flush_tlb_range(mm_cpumask(vma->vm_mm), get_mm_asid(vma->vm_mm),
+	__flush_tlb_range(vma->vm_mm, mm_cpumask(vma->vm_mm),
 			  start, end - start, stride_size);
 }
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
-	__flush_tlb_range(cpu_online_mask, FLUSH_TLB_NO_ASID,
+	__flush_tlb_range(NULL, cpu_online_mask,
 			  start, end - start, PAGE_SIZE);
 }
 
@@ -175,7 +179,7 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 void flush_pmd_tlb_range(struct vm_area_struct *vma, unsigned long start,
 			unsigned long end)
 {
-	__flush_tlb_range(mm_cpumask(vma->vm_mm), get_mm_asid(vma->vm_mm),
+	__flush_tlb_range(vma->vm_mm, mm_cpumask(vma->vm_mm),
 			  start, end - start, PMD_SIZE);
 }
 #endif
@@ -189,7 +193,10 @@ void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
 			       struct mm_struct *mm,
 			       unsigned long uaddr)
 {
+	unsigned long start = uaddr & PAGE_MASK;
+
 	cpumask_or(&batch->cpumask, &batch->cpumask, mm_cpumask(mm));
+	mmu_notifier_arch_invalidate_secondary_tlbs(mm, start, start + PAGE_SIZE);
 }
 
 void arch_flush_tlb_batched_pending(struct mm_struct *mm)
@@ -199,7 +206,7 @@ void arch_flush_tlb_batched_pending(struct mm_struct *mm)
 
 void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
-	__flush_tlb_range(&batch->cpumask, FLUSH_TLB_NO_ASID, 0,
-			  FLUSH_TLB_MAX_SIZE, PAGE_SIZE);
+	__flush_tlb_range(NULL, &batch->cpumask,
+			  0, FLUSH_TLB_MAX_SIZE, PAGE_SIZE);
 	cpumask_clear(&batch->cpumask);
 }
-- 
2.39.5



