Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27041D043B;
	Wed,  2 Oct 2024 14:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879410; cv=none; b=D+ylDGMLsKOy2W8ccqncSWozNKQD/+V+0OtijsMwWzdMd32REVOxGydEhQrk4YIzZFYMcCFf8tdRJOqPDWFH9Lo8oM+iyXF1cprRa5y/jp5xSLEb9fYyepkqo1OLEjcQMXJPmWgyUeXYxsjVgF/Iy7AtWeyEeG7Kj5ystW38aV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879410; c=relaxed/simple;
	bh=Zim/qLekzb1gOcH4MbDNtIxHpMwCq+DbVlihyyF4hzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bt7EQYDXD0xJFCXtoJwOk1W2WWRWibkgKBQlD4BMAulnFWvNUvxT2uDgproU/Xqoj4vNjGnpL2F/XX2W3LjWBBET/p9WQ20FWV6fqqrpqG5f6nOzKpJprtr8BXxdyc5u5rt4uHYB6HDbqD1UbkMieZAlXEVS2Fz0HYO4/KX6HBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8CI6Tml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8CI6Tml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A56C4CEC2;
	Wed,  2 Oct 2024 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879410;
	bh=Zim/qLekzb1gOcH4MbDNtIxHpMwCq+DbVlihyyF4hzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8CI6Tml9ItBx6DHncnYSbKsBP3FH1ZkIlPMR+FDTsgMSiB6U75Upk+O7Z5ifCy0z
	 izVv/KBgaG4XL/7vd4YMVIkQTllHPxDTdD+MnSCbmNKRKhPh6xJ2p5KeW7WwVWHW1l
	 ieIqW6aJpYWdjAznNVPJiCewuTer3pTAwtPS90qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Lutomirski <luto@kernel.org>,
	Yosry Ahmed <yosryahmed@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/538] x86/mm: Use IPIs to synchronize LAM enablement
Date: Wed,  2 Oct 2024 14:55:49 +0200
Message-ID: <20241002125756.575458524@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit 3b299b99556c1753923f8d9bbd9304bcd139282f ]

LAM can only be enabled when a process is single-threaded.  But _kernel_
threads can temporarily use a single-threaded process's mm.

If LAM is enabled by a userspace process while a kthread is using its
mm, the kthread will not observe LAM enablement (i.e.  LAM will be
disabled in CR3). This could be fine for the kthread itself, as LAM only
affects userspace addresses. However, if the kthread context switches to
a thread in the same userspace process, CR3 may or may not be updated
because the mm_struct doesn't change (based on pending TLB flushes). If
CR3 is not updated, the userspace thread will run incorrectly with LAM
disabled, which may cause page faults when using tagged addresses.
Example scenario:

CPU 1                                   CPU 2
/* kthread */
kthread_use_mm()
                                        /* user thread */
                                        prctl_enable_tagged_addr()
                                        /* LAM enabled on CPU 2 */
/* LAM disabled on CPU 1 */
                                        context_switch() /* to CPU 1 */
/* Switching to user thread */
switch_mm_irqs_off()
/* CR3 not updated */
/* LAM is still disabled on CPU 1 */

Synchronize LAM enablement by sending an IPI to all CPUs running with
the mm_struct to enable LAM. This makes sure LAM is enabled on CPU 1
in the above scenario before prctl_enable_tagged_addr() returns and
userspace starts using tagged addresses, and before it's possible to
run the userspace process on CPU 1.

In switch_mm_irqs_off(), move reading the LAM mask until after
mm_cpumask() is updated. This ensures that if an outdated LAM mask is
written to CR3, an IPI is received to update it right after IRQs are
re-enabled.

[ dhansen: Add a LAM enabling helper and comment it ]

Fixes: 82721d8b25d7 ("x86/mm: Handle LAM on context switch")
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/all/20240702132139.3332013-2-yosryahmed%40google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/process_64.c | 29 ++++++++++++++++++++++++++---
 arch/x86/mm/tlb.c            |  7 +++----
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 4989095ab7696..d595ef7c1de05 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -750,6 +750,27 @@ static long prctl_map_vdso(const struct vdso_image *image, unsigned long addr)
 
 #define LAM_U57_BITS 6
 
+static void enable_lam_func(void *__mm)
+{
+	struct mm_struct *mm = __mm;
+
+	if (this_cpu_read(cpu_tlbstate.loaded_mm) == mm) {
+		write_cr3(__read_cr3() | mm->context.lam_cr3_mask);
+		set_tlbstate_lam_mode(mm);
+	}
+}
+
+static void mm_enable_lam(struct mm_struct *mm)
+{
+	/*
+	 * Even though the process must still be single-threaded at this
+	 * point, kernel threads may be using the mm.  IPI those kernel
+	 * threads if they exist.
+	 */
+	on_each_cpu_mask(mm_cpumask(mm), enable_lam_func, mm, true);
+	set_bit(MM_CONTEXT_LOCK_LAM, &mm->context.flags);
+}
+
 static int prctl_enable_tagged_addr(struct mm_struct *mm, unsigned long nr_bits)
 {
 	if (!cpu_feature_enabled(X86_FEATURE_LAM))
@@ -766,6 +787,10 @@ static int prctl_enable_tagged_addr(struct mm_struct *mm, unsigned long nr_bits)
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
+	/*
+	 * MM_CONTEXT_LOCK_LAM is set on clone.  Prevent LAM from
+	 * being enabled unless the process is single threaded:
+	 */
 	if (test_bit(MM_CONTEXT_LOCK_LAM, &mm->context.flags)) {
 		mmap_write_unlock(mm);
 		return -EBUSY;
@@ -782,9 +807,7 @@ static int prctl_enable_tagged_addr(struct mm_struct *mm, unsigned long nr_bits)
 		return -EINVAL;
 	}
 
-	write_cr3(__read_cr3() | mm->context.lam_cr3_mask);
-	set_tlbstate_lam_mode(mm);
-	set_bit(MM_CONTEXT_LOCK_LAM, &mm->context.flags);
+	mm_enable_lam(mm);
 
 	mmap_write_unlock(mm);
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 453ea95b667da..2fbae48f0b470 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -497,9 +497,9 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 {
 	struct mm_struct *real_prev = this_cpu_read(cpu_tlbstate.loaded_mm);
 	u16 prev_asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
-	unsigned long new_lam = mm_lam_cr3_mask(next);
 	bool was_lazy = this_cpu_read(cpu_tlbstate_shared.is_lazy);
 	unsigned cpu = smp_processor_id();
+	unsigned long new_lam;
 	u64 next_tlb_gen;
 	bool need_flush;
 	u16 new_asid;
@@ -622,9 +622,7 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 			cpumask_clear_cpu(cpu, mm_cpumask(real_prev));
 		}
 
-		/*
-		 * Start remote flushes and then read tlb_gen.
-		 */
+		/* Start receiving IPIs and then read tlb_gen (and LAM below) */
 		if (next != &init_mm)
 			cpumask_set_cpu(cpu, mm_cpumask(next));
 		next_tlb_gen = atomic64_read(&next->context.tlb_gen);
@@ -636,6 +634,7 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 		barrier();
 	}
 
+	new_lam = mm_lam_cr3_mask(next);
 	set_tlbstate_lam_mode(next);
 	if (need_flush) {
 		this_cpu_write(cpu_tlbstate.ctxs[new_asid].ctx_id, next->context.ctx_id);
-- 
2.43.0



