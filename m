Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC25E1CF284;
	Wed,  2 Oct 2024 13:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875701; cv=none; b=WG8R+WiY7fosSe1RYUczXYhCsigdebdinl28WqpzthWPRe8Kct5D95srqomcsoALkPJO4dk7kpt2f39Sc1cpRwW98GDl/w4DaqdhK0W3iC1b0mj+HHeSS/9j4SIBIRYfOKOSqs5kgHT/MNHp/36J6yrqnbd1gztq7H7z22PUdms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875701; c=relaxed/simple;
	bh=ve8ksDnY3/3Yv84XKcyqpjMD+PegQBCf4J4tgxY4OOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kO1VYn0kho0APZEk13Ad/3pVAyN+pdTqD47kJyaPpE9nd5ehM9miHxamCXtaUbPqop9+IILZ8Ow9+lKpk5apz9ntWwB3JdwX7iG1AkA27zyfsld+A33sl1LpJwdKfe9M+3Y2GYwIkymlEPAhne7w5PrNa40orYmyR6yTUqsZb7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwyZ6Zh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwyZ6Zh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D3EC4CEC5;
	Wed,  2 Oct 2024 13:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875701;
	bh=ve8ksDnY3/3Yv84XKcyqpjMD+PegQBCf4J4tgxY4OOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwyZ6Zh696ypShyyeZTfpphdZuGpsJPf+ib/0KQ0BUkDUyV/AUvOJKjrU9iCuY6Pp
	 WPkV9P+pyfPU6cwTY/XNUdEgzbWd0M2RMFI2q0vtLqlIGxGIWzMjUpVg6d97WY9odc
	 RujJooWrTaU6s2JH8mSzpKxOYsnFJDgLHJ3vuFbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Lutomirski <luto@kernel.org>,
	Yosry Ahmed <yosryahmed@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 160/695] x86/mm: Use IPIs to synchronize LAM enablement
Date: Wed,  2 Oct 2024 14:52:38 +0200
Message-ID: <20241002125828.863332963@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 6d3d20e3e43a9..d8d582b750d4f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -798,6 +798,27 @@ static long prctl_map_vdso(const struct vdso_image *image, unsigned long addr)
 
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
@@ -814,6 +835,10 @@ static int prctl_enable_tagged_addr(struct mm_struct *mm, unsigned long nr_bits)
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
+	/*
+	 * MM_CONTEXT_LOCK_LAM is set on clone.  Prevent LAM from
+	 * being enabled unless the process is single threaded:
+	 */
 	if (test_bit(MM_CONTEXT_LOCK_LAM, &mm->context.flags)) {
 		mmap_write_unlock(mm);
 		return -EBUSY;
@@ -830,9 +855,7 @@ static int prctl_enable_tagged_addr(struct mm_struct *mm, unsigned long nr_bits)
 		return -EINVAL;
 	}
 
-	write_cr3(__read_cr3() | mm->context.lam_cr3_mask);
-	set_tlbstate_lam_mode(mm);
-	set_bit(MM_CONTEXT_LOCK_LAM, &mm->context.flags);
+	mm_enable_lam(mm);
 
 	mmap_write_unlock(mm);
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 44ac64f3a047c..a041d2ecd8380 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -503,9 +503,9 @@ void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
 {
 	struct mm_struct *prev = this_cpu_read(cpu_tlbstate.loaded_mm);
 	u16 prev_asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
-	unsigned long new_lam = mm_lam_cr3_mask(next);
 	bool was_lazy = this_cpu_read(cpu_tlbstate_shared.is_lazy);
 	unsigned cpu = smp_processor_id();
+	unsigned long new_lam;
 	u64 next_tlb_gen;
 	bool need_flush;
 	u16 new_asid;
@@ -619,9 +619,7 @@ void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
 			cpumask_clear_cpu(cpu, mm_cpumask(prev));
 		}
 
-		/*
-		 * Start remote flushes and then read tlb_gen.
-		 */
+		/* Start receiving IPIs and then read tlb_gen (and LAM below) */
 		if (next != &init_mm)
 			cpumask_set_cpu(cpu, mm_cpumask(next));
 		next_tlb_gen = atomic64_read(&next->context.tlb_gen);
@@ -633,6 +631,7 @@ void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
 		barrier();
 	}
 
+	new_lam = mm_lam_cr3_mask(next);
 	set_tlbstate_lam_mode(next);
 	if (need_flush) {
 		this_cpu_write(cpu_tlbstate.ctxs[new_asid].ctx_id, next->context.ctx_id);
-- 
2.43.0



