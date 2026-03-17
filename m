Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF96B3ED106;
	Tue, 17 Mar 2026 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766173; cv=none; b=Fs3Jnj3PLpecnh4GE15h5RMkLhxRiNYk/TuSh3gImMSyHBEap4qPwn7fHVtnCFObfzdDbnszYIwln0zpJzR8NFP6A0zpaIcdrYTBwGWwRNaO5TIocF+4bpXX8JzUm1aAoSzJ4FfE05NeAH69re3ucCW2y7Mr/CR8iTdhycEPu+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766173; c=relaxed/simple;
	bh=HSd+26l2e3zu9UClgbyp9wZhO3TTtn/tyF8ZwmLEToM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc2X0MZBGd7sgK73P0MWI9LnW64GXf9DxSqAzjh7jMAoolPY2QtpclhPzNDxngea0kAs52iSHk3kSoMGupQWSm8vkrQTSyWtwYsCdeOdH2fK7Gy4eKOobKSJqgA3mQ2T6lgdDxzK+2vy19SqL4T7Y61HQXLC24PJ98Md+di5SCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsyOHe9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsyOHe9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C96CC4CEF7;
	Tue, 17 Mar 2026 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766172;
	bh=HSd+26l2e3zu9UClgbyp9wZhO3TTtn/tyF8ZwmLEToM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsyOHe9B+y7LLatAzuEDFRc4nAfVR9bD+cyNEQsNc6Rch4iswJwCpsmjj+vb2FVzY
	 1TEiingYkaelDdSzjKESOXg6uLEukaIx0JernYVfZyiD7lxC3ngEPSBDWeKDR+TQUa
	 u9n8zT2yLHIy95J4k57WyA8/mJDQHzQ7Uogzc4m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 185/378] sched/mmcid: Prevent CID stalls due to concurrent forks
Date: Tue, 17 Mar 2026 17:32:22 +0100
Message-ID: <20260317163013.813886843@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit b2e48c429ec54715d16fefa719dd2fbded2e65be ]

A newly forked task is accounted as MMCID user before the task is visible
in the process' thread list and the global task list. This creates the
following problem:

 CPU1			CPU2
 fork()
   sched_mm_cid_fork(tnew1)
     tnew1->mm.mm_cid_users++;
     tnew1->mm_cid.cid = getcid()
-> preemption
			fork()
			  sched_mm_cid_fork(tnew2)
			    tnew2->mm.mm_cid_users++;
                            // Reaches the per CPU threshold
			    mm_cid_fixup_tasks_to_cpus()
			    for_each_other(current, p)
			         ....

As tnew1 is not visible yet, this fails to fix up the already allocated CID
of tnew1. As a consequence a subsequent schedule in might fail to acquire a
(transitional) CID and the machine stalls.

Move the invocation of sched_mm_cid_fork() after the new task becomes
visible in the thread and the task list to prevent this.

This also makes it symmetrical vs. exit() where the task is removed as CID
user before the task is removed from the thread and task lists.

Fixes: fbd0e71dc370 ("sched/mmcid: Provide CID ownership mode fixup functions")
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260310202525.969061974@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h |  2 --
 kernel/fork.c         |  2 --
 kernel/sched/core.c   | 22 +++++++++++++++-------
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index eb1c4c347a5cf..0719862970a28 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2313,7 +2313,6 @@ static __always_inline void alloc_tag_restore(struct alloc_tag *tag, struct allo
 #ifdef CONFIG_SCHED_MM_CID
 void sched_mm_cid_before_execve(struct task_struct *t);
 void sched_mm_cid_after_execve(struct task_struct *t);
-void sched_mm_cid_fork(struct task_struct *t);
 void sched_mm_cid_exit(struct task_struct *t);
 static __always_inline int task_mm_cid(struct task_struct *t)
 {
@@ -2322,7 +2321,6 @@ static __always_inline int task_mm_cid(struct task_struct *t)
 #else
 static inline void sched_mm_cid_before_execve(struct task_struct *t) { }
 static inline void sched_mm_cid_after_execve(struct task_struct *t) { }
-static inline void sched_mm_cid_fork(struct task_struct *t) { }
 static inline void sched_mm_cid_exit(struct task_struct *t) { }
 static __always_inline int task_mm_cid(struct task_struct *t)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 68ccbaea7398a..2d79096e0fecb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1585,7 +1585,6 @@ static int copy_mm(u64 clone_flags, struct task_struct *tsk)
 
 	tsk->mm = mm;
 	tsk->active_mm = mm;
-	sched_mm_cid_fork(tsk);
 	return 0;
 }
 
@@ -2496,7 +2495,6 @@ __latent_entropy struct task_struct *copy_process(
 	exit_nsproxy_namespaces(p);
 bad_fork_cleanup_mm:
 	if (p->mm) {
-		sched_mm_cid_exit(p);
 		mm_clear_owner(p->mm, p);
 		mmput(p->mm);
 	}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dbf4e32a063f7..ca6e6e4b17eaf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4708,8 +4708,11 @@ void sched_cancel_fork(struct task_struct *p)
 	scx_cancel_fork(p);
 }
 
+static void sched_mm_cid_fork(struct task_struct *t);
+
 void sched_post_fork(struct task_struct *p)
 {
+	sched_mm_cid_fork(p);
 	uclamp_post_fork(p);
 	scx_post_fork(p);
 }
@@ -10594,12 +10597,13 @@ static void mm_cid_do_fixup_tasks_to_cpus(struct mm_struct *mm)
 	 * possible switch back to per task mode happens either in the
 	 * deferred handler function or in the next fork()/exit().
 	 *
-	 * The caller has already transferred. The newly incoming task is
-	 * already accounted for, but not yet visible.
+	 * The caller has already transferred so remove it from the users
+	 * count. The incoming task is already visible and has mm_cid.active,
+	 * but has task::mm_cid::cid == UNSET. Still it needs to be accounted
+	 * for. Concurrent fork()s might add more threads, but all of them have
+	 * task::mm_cid::active = 0, so they don't affect the accounting here.
 	 */
-	users = mm->mm_cid.users - 2;
-	if (!users)
-		return;
+	users = mm->mm_cid.users - 1;
 
 	guard(rcu)();
 	for_other_threads(current, t) {
@@ -10636,12 +10640,15 @@ static bool sched_mm_cid_add_user(struct task_struct *t, struct mm_struct *mm)
 	return mm_update_max_cids(mm);
 }
 
-void sched_mm_cid_fork(struct task_struct *t)
+static void sched_mm_cid_fork(struct task_struct *t)
 {
 	struct mm_struct *mm = t->mm;
 	bool percpu;
 
-	WARN_ON_ONCE(!mm || t->mm_cid.cid != MM_CID_UNSET);
+	if (!mm)
+		return;
+
+	WARN_ON_ONCE(t->mm_cid.cid != MM_CID_UNSET);
 
 	guard(mutex)(&mm->mm_cid.mutex);
 	scoped_guard(raw_spinlock_irq, &mm->mm_cid.lock) {
@@ -10833,6 +10840,7 @@ void mm_init_cid(struct mm_struct *mm, struct task_struct *p)
 }
 #else /* CONFIG_SCHED_MM_CID */
 static inline void mm_update_cpus_allowed(struct mm_struct *mm, const struct cpumask *affmsk) { }
+static inline void sched_mm_cid_fork(struct task_struct *t) { }
 #endif /* !CONFIG_SCHED_MM_CID */
 
 static DEFINE_PER_CPU(struct sched_change_ctx, sched_change_ctx);
-- 
2.51.0



