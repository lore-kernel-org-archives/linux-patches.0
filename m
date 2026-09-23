Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBA3417BF9;
	Wed, 23 Sep 2026 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175233; cv=none; b=nGGOyM9U22VuWB+jZzIjJd0Ta4C3f+bULvcLDv1yGHL/TD8tnrCJoYGfsblBAmOxAgpNJJGpWXI8B4Yx+4olSJc80qNPHiKZvdjvNMRBX8FyMwdwCSLlnfmtjIaZtF4gBx8+vNBDzLLpJ/mOk/PR64XnjCQa7PdEKVZIGnROTEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175233; c=relaxed/simple;
	bh=YCGHVqtY85P7xxfqwxYIOJri2E0p8uN8+CDCedlnlwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEZ8VlWdBOQ/OPhnqDD1Orp8Cgt8g+cM7XtXbkrnI22dfEcOdTLWzraVVHFSdJoGZQK1Kbka75CSDF64Q3a3GeazZxmTwI8s437OtIHpZxOBEDK1XLT7P38UNticMs5lrMzIWoQeylCyx5i/IlkMHGm3bcE6M4/qVKMkmVxi/lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyz/qjOV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyz/qjOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1801F00893;
	Wed, 23 Sep 2026 14:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175232;
	bh=jKdImYFyeBkgCxz8fnIOfeISbSiaTLBk6/sq4732R30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyz/qjOV5n0HB1Gpe85jLiqQnQ5eYWxc6BEmDkxY3v5kOGEZUoFXzhkKYW8uv25at
	 iBnvX/n1o8cC8r9tuHS5uTjdg9aBKJ68wTtHIxXMCuiXVIyAvM+NRUzSEqFhs+Pi9U
	 cKZcqucQfE8ZiqyPuEXMaKkdFo8ec3hJtblzU7oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 363/398] signal: Move MMCID exit out of sighand lock
Date: Wed, 23 Sep 2026 16:07:17 +0200
Message-ID: <20260923140652.838084479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 2b1642b881088bbf73fcb1147c474a198ec46729 ]

There is no need anymore to keep this under sighand lock as the current
code and the upcoming replacement are not depending on the exit state of a
task anymore.

That allows to use a mutex in the exit path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20251119172549.706439391@linutronix.de

[Backport to 6.18: Keep the MMCID declarations and CONFIG_SCHED_MM_CID
stub in include/linux/mm.h, where they live in this tree, and rename the
existing exit helper and its barrier-comment references there and in
kernel/sched/core.c. Preserve the stable helper's runqueue locking,
mm_cid_active store, memory barrier and per-CPU CID release, as well as
the separate sched_mm_cid_before_execve() implementation. This tree does
not have the upstream MMCID refactoring that moved the declarations to
sched.h and made the exec helper call the exit helper.

Move the existing exit cleanup before exit_signals() in do_exit(), as
upstream does. This removes the MMCID calls from the exit_signals() code
rewritten by d2710c8d938ae ("signal: Prevent exec() race"), allowing that
fix to apply without importing unrelated MMCID changes. No functions are
added.]

[ sashal: Reduced backport -- upstream 2b1642b881088 touches 4 file(s), this
  backport carries 4. Not backported here:
  include/linux/sched.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: d2710c8d938a ("signal: Prevent exec() race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h  |    4 ++--
 kernel/exit.c       |    1 +
 kernel/sched/core.c |    6 +++---
 kernel/signal.c     |    2 --
 4 files changed, 6 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2516,7 +2516,7 @@ struct zap_details {
 void sched_mm_cid_before_execve(struct task_struct *t);
 void sched_mm_cid_after_execve(struct task_struct *t);
 void sched_mm_cid_fork(struct task_struct *t);
-void sched_mm_cid_exit_signals(struct task_struct *t);
+void sched_mm_cid_exit(struct task_struct *t);
 static inline int task_mm_cid(struct task_struct *t)
 {
 	return t->mm_cid;
@@ -2525,7 +2525,7 @@ static inline int task_mm_cid(struct tas
 static inline void sched_mm_cid_before_execve(struct task_struct *t) { }
 static inline void sched_mm_cid_after_execve(struct task_struct *t) { }
 static inline void sched_mm_cid_fork(struct task_struct *t) { }
-static inline void sched_mm_cid_exit_signals(struct task_struct *t) { }
+static inline void sched_mm_cid_exit(struct task_struct *t) { }
 static inline int task_mm_cid(struct task_struct *t)
 {
 	/*
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -924,6 +924,7 @@ void __noreturn do_exit(long code)
 	user_events_exit(tsk);
 
 	io_uring_files_cancel();
+	sched_mm_cid_exit(tsk);
 	exit_signals(tsk);  /* sets PF_EXITING */
 
 	seccomp_filter_release(tsk);
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10545,7 +10545,7 @@ int __sched_mm_cid_migrate_from_try_stea
 	 *
 	 * The implicit barrier after cmpxchg per-mm/cpu cid before loading
 	 * rq->curr->mm_cid_active matches the barrier in
-	 * sched_mm_cid_exit_signals(), sched_mm_cid_before_execve(), and
+	 * sched_mm_cid_exit(), sched_mm_cid_before_execve(), and
 	 * sched_mm_cid_after_execve() between store to t->mm_cid_active and
 	 * load of per-mm/cpu cid.
 	 */
@@ -10665,7 +10665,7 @@ static void sched_mm_cid_remote_clear(st
 	 *
 	 * The implicit barrier after cmpxchg per-mm/cpu cid before loading
 	 * rq->curr->mm_cid_active matches the barrier in
-	 * sched_mm_cid_exit_signals(), sched_mm_cid_before_execve(), and
+	 * sched_mm_cid_exit(), sched_mm_cid_before_execve(), and
 	 * sched_mm_cid_after_execve() between store to t->mm_cid_active and
 	 * load of per-mm/cpu cid.
 	 */
@@ -10810,7 +10810,7 @@ void task_tick_mm_cid(struct rq *rq, str
 	task_work_add(curr, work, TWA_RESUME);
 }
 
-void sched_mm_cid_exit_signals(struct task_struct *t)
+void sched_mm_cid_exit(struct task_struct *t)
 {
 	struct mm_struct *mm = t->mm;
 	struct rq *rq;
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3150,7 +3150,6 @@ void exit_signals(struct task_struct *ts
 	cgroup_threadgroup_change_begin(tsk);
 
 	if (thread_group_empty(tsk) || (tsk->signal->flags & SIGNAL_GROUP_EXIT)) {
-		sched_mm_cid_exit_signals(tsk);
 		tsk->flags |= PF_EXITING;
 		cgroup_threadgroup_change_end(tsk);
 		return;
@@ -3161,7 +3160,6 @@ void exit_signals(struct task_struct *ts
 	 * From now this task is not visible for group-wide signals,
 	 * see wants_signal(), do_signal_stop().
 	 */
-	sched_mm_cid_exit_signals(tsk);
 	tsk->flags |= PF_EXITING;
 
 	cgroup_threadgroup_change_end(tsk);


