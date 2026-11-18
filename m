Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046827;
	b=jlpFVaPRxT7G6Uj/u/aSc2H87ttK0S5SZTUZR1EbruYHsn8GBjmdnH9qA4BNnf7k2xfw
	 F325m1keFnJ5oSkISG/b9bgHk55EWvFLXC72p36PU8M9zrLyas4DkK52B4tS/zs3PSM71
	 rcHecVOsQZkbQWCIoJ1eYe7fZCxw5sMvvla0dJmRmgglYR2WMBavCZ4xbzXLDY8adiU8b
	 MqZMOT4DP9qh2lHDoOluPde4bW27GUcVoYAMgpoRUvgKN45KRgy9vCKn3Dx6L/zbHxMvI
	 74bEV8EjHXAQnJnDuZdP38Vp4Jor4N5uBA+DUzI8T55VbH0iHXo3xeODQpR5wTnwOlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=py8xLuD3xrR4mJGZj+ZEouViYPz9jxFhACvfEj2AMUw=;
	b=wz6N/XaEhyDV8EB7Magzq0q3S/73dV8Za1Q2q7Dxn6DHFY6DbvVCy6ziTNhrPvV48HT4
	 of3V+bq8V8NP18ByjCxmjwMXVRdAs6QFfQPzsIdaR71XaIew6qgdswVp1fTpJqDmO7bRp
	 Wd7qs7rTzPGrdoHqx1A45+kXOEYr1+5beCtNDOZqpdGgq+kPzRbFGCci6FlCTHXfYh717
	 K5BYsSO2lCyvaG5V8bDVGngT78/7Hkcu4c8HlqMTtkwhBa8KaHgQgnz+ACsrOFjU16Zq0
	 zGciYAiA4iLmKdKbxmeLLg4Mbi+b2ymfM/9DuPjTl20NBYE8U0wT9s2oEwJZcRxWosA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ele8JCDD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A46606A330;
	Thu, 19 Nov 2026 00:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ele8JCDD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BD61F000C4;
	Thu, 19 Nov 2026 00:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046827;
	bh=py8xLuD3xrR4mJGZj+ZEouViYPz9jxFhACvfEj2AMUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ele8JCDDqbK/n4gLrhC1TUoACOe8JG5bNlOkbEQ0Kwx+vjhdssKienE+dY+lumUBq
	 MgHNnUKF3LSmuKoKxJCNsqi6PQr/OuAxdJxblOWdU/2G1c8199k6y8405AmjCcIDxU
	 JM2x0dxrNdPRLHP/SmyxZ9Cd05ru+KjyOQHV5St0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1418/2857] alpha: do not skip TLB shootdown IPIs for kthread-borrowed mms
Date: Wed, 18 Nov 2026 15:40:52 +0100
Message-ID: <20261118150252.381658075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit fe221b7b2d3ecd042dd391f74ff6a6fdeb7c2038 ]

Keep the older 6.1.y callback argument cast.  The Alpha migration
callback is present here, so that hunk is retained.  The prerequisite
which stops clearing remote MMU contexts is already in the 6.1.y base;
the remaining stale-TLB prerequisites are in the current stable queue.

flush_tlb_mm(), flush_tlb_page() and flush_icache_user_page() skip the
shootdown IPI when mm_users <= 1, on the assumption that no other CPU can
be running the mm. A task that borrows an mm through kthread_use_mm()
takes mmgrab() rather than mmget(), so it never appears in mm_users, and
kthread_use_mm() may be handed an mm that is already the caller's
active_mm and loaded on that CPU. Such a CPU was not only left without
an IPI, its mm->context[cpu] was cleared from under it.

mm->context[cpu] is already the record of which CPUs hold an ASN for the
mm. Test it rather than clearing it: take the shortcut only when no
other CPU has one, and otherwise fall through to the IPI, which
invalidates those CPUs properly. A CPU that merely ran the mm in the
past also holds a context and now costs an IPI, which errs in the safe
direction.

Change ipi_flush_tlb_mm(), ipi_flush_icache_page() and the migration
callback ipi_flush_mm_and_page() to test current->mm, like
ipi_flush_tlb_page(). A CPU that only retains the mm lazily then clears
its own slot through flush_tlb_other(), rather than publishing a new ASN
on every IPI or migration rendezvous. The migration callback still does
its per-VA tbi() afterwards. Returning to the mm allocates a fresh ASN
through ev5_switch_mm(), or through the direct-load path when
kthread_use_mm() switches current's mm.

Once these historical slots are gone, the shortcut is available again
if mm_users remains at most one and no other CPU has taken or kept a
context. An explicit kthread_use_mm() borrower has current->mm set and
still receives the invalidate it needs.

The caller-side tests in flush_tlb_mm() and flush_icache_user_page()
remain current->active_mm. A kernel thread that flushes its lazily held
mm can therefore publish its own context slot. Those branches also
perform the shortcut check, which excludes the calling CPU's slot, so
leave them unchanged. This is distinct from a remote lazy CPU keeping
its slot populated through repeated callbacks.

Together with the preceding patch, dropping these clearing loops leaves
every runtime write to mm->context[] targeting the writing CPU's own slot,
so the array becomes a lockless publication of which CPUs may be using the
mm, with a single writer per slot. Mark the two stores that are now
observed from other CPUs; flush_tlb_other() already uses WRITE_ONCE().
The uniprocessor flush_icache_user_page() is left alone, as nothing reads
another CPU's slot there, and init_new_context() runs before the mm is
shared.

Order the slot reads after the page-table changes with smp_mb(). On the
publishing CPU, the store in ev5_switch_mm() precedes the mb() in Alpha's
arch_spin_unlock(), when finish_lock_switch() drops the rq lock. This
relies on Alpha's unlock implementation, not a generic scheduler promise
of a full barrier on unlock; document that reliance at the store. Also
issue smp_mb() after publishing in __load_new_mm_context(), before loading
and using the mm.

This covers every caller, including check_mmu_context(), which can
publish a replacement after finish_lock_switch() has already run.

This requires the preceding removal of remote slot clearing from
migrate_flush_tlb_page(). It also requires the stale-TLB series to set
need_new_asn on both the reused and newly allocated ASN paths. Otherwise
an IPI between finish_lock_switch() and check_mmu_context() can zero a
new slot while asn_lock is set, and the task can return to user space
with a live ASN that the shortcut cannot see.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org> # 53ab52cfe5ce: alpha: load the MMU context when switch_mm() switches the current task
Cc: <stable@vger.kernel.org> # 01df8f401888: alpha: run check_mmu_context() from finish_arch_post_lock_switch()
Cc: <stable@vger.kernel.org> # ef43cfc28c42: alpha: only use a targeted tbi() when the target mm is really current
Cc: <stable@vger.kernel.org> # 738cf8f7a78f: alpha: invalidate the local context in flush_tlb_page()
Cc: <stable@vger.kernel.org> # 62c92086f30e: alpha: fix the local TLB invalidate in flush_tlb_page()
Cc: <stable@vger.kernel.org> # 3faee097b939: alpha: fix the local TLB invalidate in the UP flush_tlb_page()
Cc: <stable@vger.kernel.org> # b2c3b654bb64: alpha: invalidate the local context in flush_tlb_mm()
Cc: <stable@vger.kernel.org> # f19ae6f51a38: alpha: invalidate the local context in flush_icache_user_page()
Cc: <stable@vger.kernel.org> # 471e7f9c890b: alpha: do not clear remote MMU contexts in migrate_flush_tlb_page()
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010144621.974850-3-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
(cherry picked from commit fe221b7b2d3ecd042dd391f74ff6a6fdeb7c2038)
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/mmu_context.h |  7 +++-
 arch/alpha/kernel/smp.c              | 52 ++++++++++++++--------------
 arch/alpha/mm/fault.c                |  4 ++-
 arch/alpha/mm/tlbflush.c             |  2 +-
 4 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/arch/alpha/include/asm/mmu_context.h b/arch/alpha/include/asm/mmu_context.h
index 14f85e7e88387..723dc3821c423 100644
--- a/arch/alpha/include/asm/mmu_context.h
+++ b/arch/alpha/include/asm/mmu_context.h
@@ -160,7 +160,12 @@ ev5_switch_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm,
 	mmc = next_mm->context[cpu];
 	if ((mmc ^ asn) & ~HARDWARE_ASN_MASK) {
 		mmc = __get_new_mm_context(next_mm, cpu);
-		next_mm->context[cpu] = mmc;
+		/*
+		 * Ordered before any user access through the mm by the
+		 * mb() in arch_spin_unlock(), when finish_lock_switch()
+		 * drops the rq lock.
+		 */
+		WRITE_ONCE(next_mm->context[cpu], mmc);
 	}
 #ifdef CONFIG_SMP
 	/* A deferred shootdown can also invalidate a newly allocated ASN. */
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index afa4b990f9226..530825b0fa8ec 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -629,12 +629,30 @@ static void
 ipi_flush_tlb_mm(void *x)
 {
 	struct mm_struct *mm = (struct mm_struct *) x;
-	if (mm == current->active_mm && !asn_locked())
+	if (mm == current->mm && !asn_locked())
 		flush_tlb_current(mm);
 	else
 		flush_tlb_other(mm);
 }
 
+/* True if a CPU other than this one holds an ASN for MM.  */
+static bool
+mm_context_elsewhere(struct mm_struct *mm)
+{
+	int cpu, this_cpu = smp_processor_id();
+
+	/* Pairs with the barrier the publishing CPU issues before using MM.  */
+	smp_mb();
+
+	for_each_online_cpu(cpu) {
+		if (cpu == this_cpu)
+			continue;
+		if (READ_ONCE(mm->context[cpu]))
+			return true;
+	}
+	return false;
+}
+
 void
 flush_tlb_mm(struct mm_struct *mm)
 {
@@ -642,14 +660,8 @@ flush_tlb_mm(struct mm_struct *mm)
 
 	if (mm == current->active_mm) {
 		flush_tlb_current(mm);
-		if (atomic_read(&mm->mm_users) <= 1) {
-			int cpu, this_cpu = smp_processor_id();
-			for (cpu = 0; cpu < NR_CPUS; cpu++) {
-				if (!cpu_online(cpu) || cpu == this_cpu)
-					continue;
-				if (mm->context[cpu])
-					mm->context[cpu] = 0;
-			}
+		if (atomic_read(&mm->mm_users) <= 1 &&
+		    !mm_context_elsewhere(mm)) {
 			preempt_enable();
 			return;
 		}
@@ -694,14 +706,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 	/* As in ipi_flush_tlb_page(): a targeted tbi() needs MM current.  */
 	if (mm == current->mm) {
 		flush_tlb_current_page(mm, vma, addr);
-		if (atomic_read(&mm->mm_users) <= 1) {
-			int cpu, this_cpu = smp_processor_id();
-			for (cpu = 0; cpu < NR_CPUS; cpu++) {
-				if (!cpu_online(cpu) || cpu == this_cpu)
-					continue;
-				if (mm->context[cpu])
-					mm->context[cpu] = 0;
-			}
+		if (atomic_read(&mm->mm_users) <= 1 &&
+		    !mm_context_elsewhere(mm)) {
 			preempt_enable();
 			return;
 		}
@@ -732,7 +738,7 @@ static void
 ipi_flush_icache_page(void *x)
 {
 	struct mm_struct *mm = (struct mm_struct *) x;
-	if (mm == current->active_mm && !asn_locked())
+	if (mm == current->mm && !asn_locked())
 		__load_new_mm_context(mm);
 	else
 		flush_tlb_other(mm);
@@ -751,14 +757,8 @@ flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 
 	if (mm == current->active_mm) {
 		__load_new_mm_context(mm);
-		if (atomic_read(&mm->mm_users) <= 1) {
-			int cpu, this_cpu = smp_processor_id();
-			for (cpu = 0; cpu < NR_CPUS; cpu++) {
-				if (!cpu_online(cpu) || cpu == this_cpu)
-					continue;
-				if (mm->context[cpu])
-					mm->context[cpu] = 0;
-			}
+		if (atomic_read(&mm->mm_users) <= 1 &&
+		    !mm_context_elsewhere(mm)) {
 			preempt_enable();
 			return;
 		}
diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index 1179b7df4af9c..de5e04dd88931 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -45,7 +45,9 @@ __load_new_mm_context(struct mm_struct *next_mm)
 	struct pcb_struct *pcb;
 
 	mmc = __get_new_mm_context(next_mm, smp_processor_id());
-	next_mm->context[smp_processor_id()] = mmc;
+	WRITE_ONCE(next_mm->context[smp_processor_id()], mmc);
+	/* Publish the context before this CPU can access the mm. */
+	smp_mb();
 
 	pcb = &current_thread_info()->pcb;
 	pcb->asn = mmc & HARDWARE_ASN_MASK;
diff --git a/arch/alpha/mm/tlbflush.c b/arch/alpha/mm/tlbflush.c
index 239c72b8a7412..a2aef90e6234b 100644
--- a/arch/alpha/mm/tlbflush.c
+++ b/arch/alpha/mm/tlbflush.c
@@ -66,7 +66,7 @@ static void ipi_flush_mm_and_page(void *x)
 	struct tlb_mm_and_addr *d = x;
 
 	/* Part 1: mm context side (Alpha uses ASN/context as a key mechanism). */
-	if (d->mm == current->active_mm && !asn_locked())
+	if (d->mm == current->mm && !asn_locked())
 		__load_new_mm_context(d->mm);
 	else
 		flush_tlb_other(d->mm);
-- 
2.53.0



