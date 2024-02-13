Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82375F54E;
	Tue, 13 Feb 2024 17:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845466; cv=none; b=BAZqgPfCaQBDRfXCuQfh28ElLvZHNyZlayedxozEBg72dJzroJl8F26xVx8zbuGArSC+hOrcu4+WZzfXt6GZuSTVwuA4M0atLy/BZUopT+/9hLAzphAlb+YvCu5FIXaCYs4MzLzLZLouev+qiOjAzrcZu+Ewj6Qn9lqkT5QK7dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845466; c=relaxed/simple;
	bh=FypfKiNBKjgdHH1F1PAmuxCqCc5HZFg/rS+peVauS5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDu4yKPnLbg+3VJpTadVmybPSQ1vY9n5/W55Ie7zrgGiTw2xZ3O2d6MTCCsRwI0E9QfXeIJstFc30Vwa8ByIyeuz2Z+8IeolNeYB1aXLvwFFxBnfEz2uh84wn3G5UJ98C+hken/9r9ls/DimIfAwaB+iXPEpkcUIZO520FiDCwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWokEbCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWokEbCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246C5C433C7;
	Tue, 13 Feb 2024 17:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845466;
	bh=FypfKiNBKjgdHH1F1PAmuxCqCc5HZFg/rS+peVauS5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWokEbCSeS5rwXrL5SFM6wQr7IfV44+3Mozl+8pLinoHfxpyde2jOA3cGssNHnxbU
	 UrfE14BMnIucCIDRBuVMxKY9o7Y+uVqVjg+yyo+poifokobdhHFrXYUTp7y1S6MJqD
	 9olna5I6Ko/Px62weQ4Kqjo+pmsfcj1sTCF5/ZGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 6.6 087/121] riscv: Improve flush_tlb_kernel_range()
Date: Tue, 13 Feb 2024 18:21:36 +0100
Message-ID: <20240213171855.533305508@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 5e22bfd520ea8740e9a20314d2a890baf304c9d2 ]

This function used to simply flush the whole tlb of all harts, be more
subtile and try to only flush the range.

The problem is that we can only use PAGE_SIZE as stride since we don't know
the size of the underlying mapping and then this function will be improved
only if the size of the region to flush is < threshold * PAGE_SIZE.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> # On RZ/Five SMARC
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Tested-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20231030133027.19542-5-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: d9807d60c145 ("riscv: mm: execute local TLB flush after populating vmemmap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/tlbflush.h | 11 +++++-----
 arch/riscv/mm/tlbflush.c          | 34 ++++++++++++++++++++++---------
 2 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index 170a49c531c6..8f3418c5f172 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -40,6 +40,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr);
 void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 		     unsigned long end);
+void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 void flush_pmd_tlb_range(struct vm_area_struct *vma, unsigned long start,
@@ -56,15 +57,15 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 	local_flush_tlb_all();
 }
 
-#define flush_tlb_mm(mm) flush_tlb_all()
-#define flush_tlb_mm_range(mm, start, end, page_size) flush_tlb_all()
-#endif /* !CONFIG_SMP || !CONFIG_MMU */
-
 /* Flush a range of kernel pages */
 static inline void flush_tlb_kernel_range(unsigned long start,
 	unsigned long end)
 {
-	flush_tlb_all();
+	local_flush_tlb_all();
 }
 
+#define flush_tlb_mm(mm) flush_tlb_all()
+#define flush_tlb_mm_range(mm, start, end, page_size) flush_tlb_all()
+#endif /* !CONFIG_SMP || !CONFIG_MMU */
+
 #endif /* _ASM_RISCV_TLBFLUSH_H */
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 88fa8b18ca22..8723adc884c7 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -96,20 +96,27 @@ static void __flush_tlb_range(struct mm_struct *mm, unsigned long start,
 			      unsigned long size, unsigned long stride)
 {
 	struct flush_tlb_range_data ftd;
-	struct cpumask *cmask = mm_cpumask(mm);
+	const struct cpumask *cmask;
 	unsigned long asid = FLUSH_TLB_NO_ASID;
-	unsigned int cpuid;
 	bool broadcast;
 
-	if (cpumask_empty(cmask))
-		return;
+	if (mm) {
+		unsigned int cpuid;
+
+		cmask = mm_cpumask(mm);
+		if (cpumask_empty(cmask))
+			return;
 
-	cpuid = get_cpu();
-	/* check if the tlbflush needs to be sent to other CPUs */
-	broadcast = cpumask_any_but(cmask, cpuid) < nr_cpu_ids;
+		cpuid = get_cpu();
+		/* check if the tlbflush needs to be sent to other CPUs */
+		broadcast = cpumask_any_but(cmask, cpuid) < nr_cpu_ids;
 
-	if (static_branch_unlikely(&use_asid_allocator))
-		asid = atomic_long_read(&mm->context.id) & asid_mask;
+		if (static_branch_unlikely(&use_asid_allocator))
+			asid = atomic_long_read(&mm->context.id) & asid_mask;
+	} else {
+		cmask = cpu_online_mask;
+		broadcast = true;
+	}
 
 	if (broadcast) {
 		if (riscv_use_ipi_for_rfence()) {
@@ -127,7 +134,8 @@ static void __flush_tlb_range(struct mm_struct *mm, unsigned long start,
 		local_flush_tlb_range_asid(start, size, stride, asid);
 	}
 
-	put_cpu();
+	if (mm)
+		put_cpu();
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
@@ -152,6 +160,12 @@ void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 {
 	__flush_tlb_range(vma->vm_mm, start, end - start, PAGE_SIZE);
 }
+
+void flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+	__flush_tlb_range(NULL, start, end - start, PAGE_SIZE);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void flush_pmd_tlb_range(struct vm_area_struct *vma, unsigned long start,
 			unsigned long end)
-- 
2.43.0



