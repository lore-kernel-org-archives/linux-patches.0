Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5F03815DD;
	Thu, 20 Aug 2026 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239132; cv=none; b=hkgAHprJaBlosoD1epv50U0nqx8gaEkFmKQ2rswCECXGCi4X9BlmpXYlsa3vNL+VOwcLbiGwt8PMlDOKnErhPhxEl2Bn0rKbkwDp9SJOUOqnJMrAOOiqU7U4IouasxS4GupaFBlqH9xj/k1nLN5dZukvnechoJNrr6G8crR6QkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239132; c=relaxed/simple;
	bh=zqfj3SBZk8waWfdLoY5a27jjKgwmWjtHkxipEXVXqUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjWZcFPxrOhroYCDpOrAGEoONFWH4o7p4zN+kjVHR9hP1k6YnOU0s9FgbnpvYNM+HDztnfyO4fc1V3z6mxMUp6MUjSVwtGoF7BvspFbZ8IPMq9edIxC7xiR9cFpVEITzQEFv8PcnV+DrWqgdmQm9eGsdglnizOzPFFdQa+X6jZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iL5vU4Rc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iL5vU4Rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B001F000E9;
	Thu, 20 Aug 2026 15:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239129;
	bh=3cVRQ7V3lZtUUsIMJWwR+uiz4YULWH57uO39fKdUfqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iL5vU4RcMo/qv0LjJbbHfv+vGX+BCecnlxej7bO5YhJGzfxmL/CuWsKtCDf/Klyfq
	 buZleMFPBxn2nOWnLL/I748o44Whqlm33rLaFku2nbZ/yWyy22V9/pLCn36CikH+Yl
	 IOVU/Op3EDwGzq5PJfPLgoTArmT+ojejkQWsAVYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 158/217] sched_ext: Reorganize enable/disable path for multi-scheduler support
Date: Thu, 20 Aug 2026 16:55:26 +0200
Message-ID: <20260820145242.510599570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit dbd542a8fac7bcfba91e353f2a522e1bf2fbee27 ]

In preparation for multiple scheduler support, reorganize the enable and
disable paths to make scheduler instances explicit. Extract
scx_root_disable() from scx_disable_workfn(). Rename scx_enable_workfn()
to scx_root_enable_workfn(). Change scx_disable() to take @sch parameter
and only queue disable_work if scx_claim_exit() succeeds for consistency.
Move exit_kind validation into scx_claim_exit(). The sysrq handler now
prints a message when no scheduler is loaded.

These changes don't materially affect user-visible behavior.

v2: Keep scx_enable() name as-is and only rename the workfn to
    scx_root_enable_workfn(). Change scx_enable() return type to s32.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Stable-dep-of: 5f8b69642d18 ("sched_ext: Take cgroup_lock() first in scx_cgroup_lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   78 +++++++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 35 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3029,8 +3029,8 @@ void sched_ext_free(struct task_struct *
 	raw_spin_unlock_irqrestore(&scx_tasks_lock, flags);
 
 	/*
-	 * @p is off scx_tasks and wholly ours. scx_enable()'s READY -> ENABLED
-	 * transitions can't race us. Disable ops for @p.
+	 * @p is off scx_tasks and wholly ours. scx_root_enable()'s READY ->
+	 * ENABLED transitions can't race us. Disable ops for @p.
 	 */
 	if (scx_get_task_state(p) != SCX_TASK_NONE) {
 		struct rq_flags rf;
@@ -3962,24 +3962,12 @@ static void free_kick_pseqs(void)
 	}
 }
 
-static void scx_disable_workfn(struct kthread_work *work)
+static void scx_root_disable(struct scx_sched *sch)
 {
-	struct scx_sched *sch = container_of(work, struct scx_sched, disable_work);
 	struct scx_exit_info *ei = sch->exit_info;
 	struct scx_task_iter sti;
 	struct task_struct *p;
-	int kind, cpu;
-
-	kind = atomic_read(&sch->exit_kind);
-	while (true) {
-		if (kind == SCX_EXIT_DONE)	/* already disabled? */
-			return;
-		WARN_ON_ONCE(kind == SCX_EXIT_NONE);
-		if (atomic_try_cmpxchg(&sch->exit_kind, &kind, SCX_EXIT_DONE))
-			break;
-	}
-	ei->kind = kind;
-	ei->reason = scx_exit_reason(ei->kind);
+	int cpu;
 
 	/* guarantee forward progress by bypassing scx_ops */
 	scx_bypass(true);
@@ -4124,6 +4112,9 @@ static bool scx_claim_exit(struct scx_sc
 
 	lockdep_assert_preemption_disabled();
 
+	if (WARN_ON_ONCE(kind == SCX_EXIT_NONE || kind == SCX_EXIT_DONE))
+		kind = SCX_EXIT_ERROR;
+
 	if (!atomic_try_cmpxchg(&sch->exit_kind, &none, kind))
 		return false;
 
@@ -4136,21 +4127,31 @@ static bool scx_claim_exit(struct scx_sc
 	return true;
 }
 
-static void scx_disable(enum scx_exit_kind kind)
+static void scx_disable_workfn(struct kthread_work *work)
 {
-	struct scx_sched *sch;
+	struct scx_sched *sch = container_of(work, struct scx_sched, disable_work);
+	struct scx_exit_info *ei = sch->exit_info;
+	int kind;
 
-	if (WARN_ON_ONCE(kind == SCX_EXIT_NONE || kind == SCX_EXIT_DONE))
-		kind = SCX_EXIT_ERROR;
+	kind = atomic_read(&sch->exit_kind);
+	while (true) {
+		if (kind == SCX_EXIT_DONE)	/* already disabled? */
+			return;
+		WARN_ON_ONCE(kind == SCX_EXIT_NONE);
+		if (atomic_try_cmpxchg(&sch->exit_kind, &kind, SCX_EXIT_DONE))
+			break;
+	}
+	ei->kind = kind;
+	ei->reason = scx_exit_reason(ei->kind);
 
-	rcu_read_lock();
-	sch = rcu_dereference(scx_root);
-	if (sch) {
-		guard(preempt)();
-		scx_claim_exit(sch, kind);
+	scx_root_disable(sch);
+}
+
+static void scx_disable(struct scx_sched *sch, enum scx_exit_kind kind)
+{
+	guard(preempt)();
+	if (scx_claim_exit(sch, kind))
 		kthread_queue_work(sch->helper, &sch->disable_work);
-	}
-	rcu_read_unlock();
 }
 
 static void dump_newline(struct seq_buf *s)
@@ -4662,10 +4663,9 @@ struct scx_enable_cmd {
 	int			ret;
 };
 
-static void scx_enable_workfn(struct kthread_work *work)
+static void scx_root_enable_workfn(struct kthread_work *work)
 {
-	struct scx_enable_cmd *cmd =
-		container_of(work, struct scx_enable_cmd, work);
+	struct scx_enable_cmd *cmd = container_of(work, struct scx_enable_cmd, work);
 	struct sched_ext_ops *ops = cmd->ops;
 	struct scx_sched *sch;
 	struct scx_task_iter sti;
@@ -4915,12 +4915,12 @@ err_disable:
 	 * Flush scx_disable_work to ensure that error is reported before init
 	 * completion. sch's base reference will be put by bpf_scx_unreg().
 	 */
-	scx_error(sch, "scx_enable() failed (%d)", ret);
+	scx_error(sch, "scx_root_enable() failed (%d)", ret);
 	kthread_flush_work(&sch->disable_work);
 	cmd->ret = 0;
 }
 
-static int scx_enable(struct sched_ext_ops *ops, struct bpf_link *link)
+static s32 scx_enable(struct sched_ext_ops *ops, struct bpf_link *link)
 {
 	static struct kthread_worker *helper;
 	static DEFINE_MUTEX(helper_mutex);
@@ -4946,7 +4946,7 @@ static int scx_enable(struct sched_ext_o
 		mutex_unlock(&helper_mutex);
 	}
 
-	kthread_init_work(&cmd.work, scx_enable_workfn);
+	kthread_init_work(&cmd.work, scx_root_enable_workfn);
 	cmd.ops = ops;
 
 	kthread_queue_work(READ_ONCE(helper), &cmd.work);
@@ -5089,7 +5089,7 @@ static void bpf_scx_unreg(void *kdata, s
 	struct sched_ext_ops *ops = kdata;
 	struct scx_sched *sch = ops->priv;
 
-	scx_disable(SCX_EXIT_UNREG);
+	scx_disable(sch, SCX_EXIT_UNREG);
 	kthread_flush_work(&sch->disable_work);
 	kobject_put(&sch->kobj);
 }
@@ -5217,7 +5217,15 @@ static struct bpf_struct_ops bpf_sched_e
 
 static void sysrq_handle_sched_ext_reset(u8 key)
 {
-	scx_disable(SCX_EXIT_SYSRQ);
+	struct scx_sched *sch;
+
+	rcu_read_lock();
+	sch = rcu_dereference(scx_root);
+	if (likely(sch))
+		scx_disable(sch, SCX_EXIT_SYSRQ);
+	else
+		pr_info("sched_ext: BPF schedulers not loaded\n");
+	rcu_read_unlock();
 }
 
 static const struct sysrq_key_op sysrq_sched_ext_reset_op = {


