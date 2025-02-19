Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFF01C3BE9;
	Wed, 19 Feb 2025 08:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955166; cv=none; b=jhZEJSpD/G30vZcmxSCssxOmbZ9ltWfJC3WrISUBMoYnsr03bDc0w/1nGb+01iSXMtNuB1k2uvtBc3u+y7IvEcLy7zmbrPVyAuWLb056Ryl9BDNHa0j1G1PB4AFtwsrElc87roTk+GOEGN1pNM1M8zyMC1Aj5wEt+LimJMFjOgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955166; c=relaxed/simple;
	bh=Mm3iElm1Eqt39zXEsaeraoKbt6li4vsCrP2X17DcG3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhhZQ/I5OtcRSrutidrtIHGMbSYEiBfxa9KbrTpeaFZHcBxUUHkKBZ9C8HxiLh5f1MzL+WaVXVkc8JQC2ZE4T/BlhhS1oFluDmKVaFGgYOud359flo4tAdy9SRlCYm5/YmBwyXUhKjSdz1ThtjXUFcXDShog4uQUdr1iJXYoylY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxFEYQ8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxFEYQ8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A04CC4CED1;
	Wed, 19 Feb 2025 08:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955166;
	bh=Mm3iElm1Eqt39zXEsaeraoKbt6li4vsCrP2X17DcG3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxFEYQ8TEjw5oI7HLRiSJbeM1LYxqTmo4zSy0YXOJsTnuPMahBAvz03nOpmqxUC9s
	 X8HR/PAW3a9h63GvH/9o2Dc5fLLYx4Fygj/UER9roS6bDvc9Jl2uinbnVDyramW5hH
	 QYkyDk91DxstJxhYnb1JeWe9z+JujQ+KWotS9OJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 153/230] sched_ext: Fix incorrect autogroup migration detection
Date: Wed, 19 Feb 2025 09:27:50 +0100
Message-ID: <20250219082607.676829525@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit d6f3e7d564b2309e1f17e709a70eca78d7ca2bb8 upstream.

scx_move_task() is called from sched_move_task() and tells the BPF scheduler
that cgroup migration is being committed. sched_move_task() is used by both
cgroup and autogroup migrations and scx_move_task() tried to filter out
autogroup migrations by testing the destination cgroup and PF_EXITING but
this is not enough. In fact, without explicitly tagging the thread which is
doing the cgroup migration, there is no good way to tell apart
scx_move_task() invocations for racing migration to the root cgroup and an
autogroup migration.

This led to scx_move_task() incorrectly ignoring a migration from non-root
cgroup to an autogroup of the root cgroup triggering the following warning:

  WARNING: CPU: 7 PID: 1 at kernel/sched/ext.c:3725 scx_cgroup_can_attach+0x196/0x340
  ...
  Call Trace:
  <TASK>
    cgroup_migrate_execute+0x5b1/0x700
    cgroup_attach_task+0x296/0x400
    __cgroup_procs_write+0x128/0x140
    cgroup_procs_write+0x17/0x30
    kernfs_fop_write_iter+0x141/0x1f0
    vfs_write+0x31d/0x4a0
    __x64_sys_write+0x72/0xf0
    do_syscall_64+0x82/0x160
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fix it by adding an argument to sched_move_task() that indicates whether the
moving is for a cgroup or autogroup migration. After the change,
scx_move_task() is called only for cgroup migrations and renamed to
scx_cgroup_move_task().

Link: https://github.com/sched-ext/scx/issues/370
Fixes: 819513666966 ("sched_ext: Add cgroup support")
Cc: stable@vger.kernel.org # v6.12+
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/autogroup.c |    4 ++--
 kernel/sched/core.c      |    7 ++++---
 kernel/sched/ext.c       |   15 +--------------
 kernel/sched/ext.h       |    4 ++--
 kernel/sched/sched.h     |    2 +-
 5 files changed, 10 insertions(+), 22 deletions(-)

--- a/kernel/sched/autogroup.c
+++ b/kernel/sched/autogroup.c
@@ -150,7 +150,7 @@ void sched_autogroup_exit_task(struct ta
 	 * see this thread after that: we can no longer use signal->autogroup.
 	 * See the PF_EXITING check in task_wants_autogroup().
 	 */
-	sched_move_task(p);
+	sched_move_task(p, true);
 }
 
 static void
@@ -182,7 +182,7 @@ autogroup_move_group(struct task_struct
 	 * sched_autogroup_exit_task().
 	 */
 	for_each_thread(p, t)
-		sched_move_task(t);
+		sched_move_task(t, true);
 
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8953,7 +8953,7 @@ static void sched_change_group(struct ta
  * now. This function just updates tsk->se.cfs_rq and tsk->se.parent to reflect
  * its new group.
  */
-void sched_move_task(struct task_struct *tsk)
+void sched_move_task(struct task_struct *tsk, bool for_autogroup)
 {
 	int queued, running, queue_flags =
 		DEQUEUE_SAVE | DEQUEUE_MOVE | DEQUEUE_NOCLOCK;
@@ -8982,7 +8982,8 @@ void sched_move_task(struct task_struct
 		put_prev_task(rq, tsk);
 
 	sched_change_group(tsk, group);
-	scx_move_task(tsk);
+	if (!for_autogroup)
+		scx_cgroup_move_task(tsk);
 
 	if (queued)
 		enqueue_task(rq, tsk, queue_flags);
@@ -9083,7 +9084,7 @@ static void cpu_cgroup_attach(struct cgr
 	struct cgroup_subsys_state *css;
 
 	cgroup_taskset_for_each(task, css, tset)
-		sched_move_task(task);
+		sched_move_task(task, false);
 
 	scx_cgroup_finish_attach();
 }
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3919,25 +3919,12 @@ err:
 	return ops_sanitize_err("cgroup_prep_move", ret);
 }
 
-void scx_move_task(struct task_struct *p)
+void scx_cgroup_move_task(struct task_struct *p)
 {
 	if (!scx_cgroup_enabled)
 		return;
 
 	/*
-	 * We're called from sched_move_task() which handles both cgroup and
-	 * autogroup moves. Ignore the latter.
-	 *
-	 * Also ignore exiting tasks, because in the exit path tasks transition
-	 * from the autogroup to the root group, so task_group_is_autogroup()
-	 * alone isn't able to catch exiting autogroup tasks. This is safe for
-	 * cgroup_move(), because cgroup migrations never happen for PF_EXITING
-	 * tasks.
-	 */
-	if (task_group_is_autogroup(task_group(p)) || (p->flags & PF_EXITING))
-		return;
-
-	/*
 	 * @p must have ops.cgroup_prep_move() called on it and thus
 	 * cgrp_moving_from set.
 	 */
--- a/kernel/sched/ext.h
+++ b/kernel/sched/ext.h
@@ -73,7 +73,7 @@ static inline void scx_update_idle(struc
 int scx_tg_online(struct task_group *tg);
 void scx_tg_offline(struct task_group *tg);
 int scx_cgroup_can_attach(struct cgroup_taskset *tset);
-void scx_move_task(struct task_struct *p);
+void scx_cgroup_move_task(struct task_struct *p);
 void scx_cgroup_finish_attach(void);
 void scx_cgroup_cancel_attach(struct cgroup_taskset *tset);
 void scx_group_set_weight(struct task_group *tg, unsigned long cgrp_weight);
@@ -82,7 +82,7 @@ void scx_group_set_idle(struct task_grou
 static inline int scx_tg_online(struct task_group *tg) { return 0; }
 static inline void scx_tg_offline(struct task_group *tg) {}
 static inline int scx_cgroup_can_attach(struct cgroup_taskset *tset) { return 0; }
-static inline void scx_move_task(struct task_struct *p) {}
+static inline void scx_cgroup_move_task(struct task_struct *p) {}
 static inline void scx_cgroup_finish_attach(void) {}
 static inline void scx_cgroup_cancel_attach(struct cgroup_taskset *tset) {}
 static inline void scx_group_set_weight(struct task_group *tg, unsigned long cgrp_weight) {}
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -572,7 +572,7 @@ extern void sched_online_group(struct ta
 extern void sched_destroy_group(struct task_group *tg);
 extern void sched_release_group(struct task_group *tg);
 
-extern void sched_move_task(struct task_struct *tsk);
+extern void sched_move_task(struct task_struct *tsk, bool for_autogroup);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);


