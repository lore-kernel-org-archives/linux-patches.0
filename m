Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76AA3D1CCA;
	Tue, 21 Jul 2026 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653675; cv=none; b=klsrKjUpjJY+WgyUDozF0sjL6Mi5PVmvufL+YUNqlae93xEhx047LnI/qBMuU7rCvJBetgfgyGwa/QP3RAJQUwNpa+TKUjM80a39D3J2C8f3Y5Bg+ta2DE26CD5dINu+YAhAYcJaS13zA7R5habMgWkZThMzXADFkLC8XvwpgLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653675; c=relaxed/simple;
	bh=9GGAARgwEDcZRIsfsYZy9VCnMHf+chPEZosmOumlQi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1dthzsfsZ2J+1pATV7AnwE/vEKxxMeG2KIVEB2tbwRujYw29/C4ikyGogLkHcxMUWtAQc4vfFphinZpv2TGs6AOnLZgZsb+jTXXAipqBl40eIa5xVnS9opdXb3HT/JFMlo7ZAIi2saFc9tLB7cH3u902+cEKDykKbfefJ2ekQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JR0Mas98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JR0Mas98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DDB1F000E9;
	Tue, 21 Jul 2026 17:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653673;
	bh=DtvmeY+O9w8qcqmMDxNG5seDGpLJ7ETozbolXRLJTtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JR0Mas98L1xCkFW39YH0qFv2ThD6AJ+TJ5zOgAc0LKM3RnQc+29Jx4otQOHxSCyEw
	 rc/PJyxSlECOE03ZQyK9kWs4OPqFJ8cVa9lpI/fjo30T5fHUYg2PQ+VeTyySHL1SXf
	 xt5YVCaBZC7yDmFCFueaGnHF3RBieIIDmXDDwfrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joshua Liu <josliu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1415/2077] arm64: Avoid eager DVMSync reclaim batches with C1-Pro SME erratum
Date: Tue, 21 Jul 2026 17:18:08 +0200
Message-ID: <20260721152626.179547942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit 534eb6940a89ff7ca3f2ab6582f3548ca97674c3 ]

The C1-Pro SME DVMSync workaround currently samples mm_cpumask() from
arch_tlbbatch_add_pending(). It requires a DSB after every batched TLBI
so that the mask read is ordered after the hardware DVMSync, defeating
much of the reclaim batching benefit.

Introduce the sme_active_cpus mask tracking which CPUs run in user-space
with SME enabled and use it for batch flushing instead of accumulating
the mm_cpumask() of the unmapped pages.

Fixes: 0baba94a9779 ("arm64: errata: Work around early CME DVMSync acknowledgement")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Tested-by: Joshua Liu <josliu@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/tlbbatch.h | 10 ++-----
 arch/arm64/include/asm/tlbflush.h | 49 +++++--------------------------
 arch/arm64/kernel/fpsimd.c        | 10 +++++--
 arch/arm64/kernel/process.c       | 35 ----------------------
 4 files changed, 17 insertions(+), 87 deletions(-)

diff --git a/arch/arm64/include/asm/tlbbatch.h b/arch/arm64/include/asm/tlbbatch.h
index 6297631532e59f..767f35ea62b39c 100644
--- a/arch/arm64/include/asm/tlbbatch.h
+++ b/arch/arm64/include/asm/tlbbatch.h
@@ -2,17 +2,11 @@
 #ifndef _ARCH_ARM64_TLBBATCH_H
 #define _ARCH_ARM64_TLBBATCH_H
 
-#include <linux/cpumask.h>
-
 struct arch_tlbflush_unmap_batch {
-#ifdef CONFIG_ARM64_ERRATUM_4193714
 	/*
-	 * Track CPUs that need SME DVMSync on completion of this batch.
-	 * Otherwise, the arm64 HW can do tlb shootdown, so we don't need to
-	 * record cpumask for sending IPI
+	 * For arm64, HW can do TLB shootdown, so we don't need to record a
+	 * cpumask for sending IPIs.
 	 */
-	cpumask_var_t cpumask;
-#endif
 };
 
 #endif /* _ARCH_ARM64_TLBBATCH_H */
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index c0bf5b39804119..57b4eda6a72bba 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -82,6 +82,8 @@ static inline unsigned long get_trans_granule(void)
 
 #ifdef CONFIG_ARM64_ERRATUM_4193714
 
+extern cpumask_t sme_active_cpus;
+
 void sme_do_dvmsync(const struct cpumask *mask);
 
 static inline void sme_dvmsync(struct mm_struct *mm)
@@ -92,42 +94,12 @@ static inline void sme_dvmsync(struct mm_struct *mm)
 	sme_do_dvmsync(mm_cpumask(mm));
 }
 
-static inline void sme_dvmsync_add_pending(struct arch_tlbflush_unmap_batch *batch,
-					   struct mm_struct *mm)
+static inline void sme_dvmsync_batch(void)
 {
 	if (!alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714))
 		return;
 
-	/*
-	 * Order the mm_cpumask() read after the hardware DVMSync.
-	 */
-	dsb(ish);
-	if (cpumask_empty(mm_cpumask(mm)))
-		return;
-
-	/*
-	 * Allocate the batch cpumask on first use. Fall back to an immediate
-	 * IPI for this mm in case of failure.
-	 */
-	if (!cpumask_available(batch->cpumask) &&
-	    !zalloc_cpumask_var(&batch->cpumask, GFP_ATOMIC)) {
-		sme_do_dvmsync(mm_cpumask(mm));
-		return;
-	}
-
-	cpumask_or(batch->cpumask, batch->cpumask, mm_cpumask(mm));
-}
-
-static inline void sme_dvmsync_batch(struct arch_tlbflush_unmap_batch *batch)
-{
-	if (!alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714))
-		return;
-
-	if (!cpumask_available(batch->cpumask))
-		return;
-
-	sme_do_dvmsync(batch->cpumask);
-	cpumask_clear(batch->cpumask);
+	sme_do_dvmsync(&sme_active_cpus);
 }
 
 #else
@@ -135,11 +107,7 @@ static inline void sme_dvmsync_batch(struct arch_tlbflush_unmap_batch *batch)
 static inline void sme_dvmsync(struct mm_struct *mm)
 {
 }
-static inline void sme_dvmsync_add_pending(struct arch_tlbflush_unmap_batch *batch,
-					   struct mm_struct *mm)
-{
-}
-static inline void sme_dvmsync_batch(struct arch_tlbflush_unmap_batch *batch)
+static inline void sme_dvmsync_batch(void)
 {
 }
 
@@ -285,11 +253,11 @@ static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
 	sme_dvmsync(mm);
 }
 
-static inline void __tlbi_sync_s1ish_batch(struct arch_tlbflush_unmap_batch *batch)
+static inline void __tlbi_sync_s1ish_batch(void)
 {
 	dsb(ish);
 	__repeat_tlbi_sync(vale1is, 0);
-	sme_dvmsync_batch(batch);
+	sme_dvmsync_batch();
 }
 
 static inline void __tlbi_sync_s1ish_kernel(void)
@@ -434,7 +402,7 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
  */
 static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
-	__tlbi_sync_s1ish_batch(batch);
+	__tlbi_sync_s1ish_batch();
 }
 
 /*
@@ -722,7 +690,6 @@ static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *b
 
 	__flush_tlb_range(&vma, start, end, PAGE_SIZE, 3,
 			  TLBF_NOWALKCACHE | TLBF_NOSYNC);
-	sme_dvmsync_add_pending(batch, mm);
 }
 
 static inline bool __pte_flags_need_flush(ptdesc_t oldval, ptdesc_t newval)
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 60a45d600b460a..ab3b63621fd00b 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1366,6 +1366,7 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
  * SME/CME erratum handling.
  */
 static cpumask_t sme_dvmsync_cpus;
+cpumask_t sme_active_cpus;
 
 /*
  * These helpers are only called from non-preemptible contexts, so
@@ -1379,13 +1380,15 @@ void sme_set_active(void)
 		return;
 
 	cpumask_set_cpu(cpu, mm_cpumask(current->mm));
+	cpumask_set_cpu(cpu, &sme_active_cpus);
 
 	/*
 	 * A subsequent (post ERET) SME access may use a stale address
 	 * translation. On C1-Pro, a TLBI+DSB on a different CPU will wait for
-	 * the completion of cpumask_set_cpu() above as it appears in program
-	 * order before the SME access. The post-TLBI+DSB read of mm_cpumask()
-	 * will lead to the IPI being issued.
+	 * the completion of the cpumask_set_cpu() operations above as they
+	 * appear in program order before the SME access. The post-TLBI+DSB
+	 * read of mm_cpumask() or sme_active_cpus will lead to the IPI being
+	 * issued.
 	 *
 	 * https://lore.kernel.org/r/ablEXwhfKyJW1i7l@J2N7QTR9R3
 	 */
@@ -1403,6 +1406,7 @@ void sme_clear_active(void)
 	 * completed on entering EL1.
 	 */
 	cpumask_clear_cpu(cpu, mm_cpumask(current->mm));
+	cpumask_clear_cpu(cpu, &sme_active_cpus);
 }
 
 static void sme_dvmsync_ipi(void *unused)
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 033643cd4e5ede..581f80e9b9b730 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -341,41 +341,8 @@ void flush_thread(void)
 	flush_gcs();
 }
 
-#ifdef CONFIG_ARM64_ERRATUM_4193714
-
-static void arch_dup_tlbbatch_mask(struct task_struct *dst)
-{
-	/*
-	 * Clear the inherited cpumask with memset() to cover both cases where
-	 * cpumask_var_t is a pointer or an array. It will be allocated lazily
-	 * in sme_dvmsync_add_pending() if CPUMASK_OFFSTACK=y.
-	 */
-	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714))
-		memset(&dst->tlb_ubc.arch.cpumask, 0,
-		       sizeof(dst->tlb_ubc.arch.cpumask));
-}
-
-static void arch_release_tlbbatch_mask(struct task_struct *tsk)
-{
-	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714))
-		free_cpumask_var(tsk->tlb_ubc.arch.cpumask);
-}
-
-#else
-
-static void arch_dup_tlbbatch_mask(struct task_struct *dst)
-{
-}
-
-static void arch_release_tlbbatch_mask(struct task_struct *tsk)
-{
-}
-
-#endif /* CONFIG_ARM64_ERRATUM_4193714 */
-
 void arch_release_task_struct(struct task_struct *tsk)
 {
-	arch_release_tlbbatch_mask(tsk);
 	fpsimd_release_task(tsk);
 }
 
@@ -391,8 +358,6 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 
 	*dst = *src;
 
-	arch_dup_tlbbatch_mask(dst);
-
 	/*
 	 * Drop stale reference to src's sve_state and convert dst to
 	 * non-streaming FPSIMD mode.
-- 
2.53.0



