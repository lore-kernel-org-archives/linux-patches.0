Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0274E26E6F2;
	Tue,  6 Jan 2026 17:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721424; cv=none; b=JH4DNaxVL062NXGj9lmeFmVNiz9rS2k2pQmT2JsWP+9LOiDNeTT3MId/p7OVPfMBPHpvdZuCq7Un5vitQprb/9vM5jllrl9z3LDmLSU1PiAdagzZHKOmUYtNpldVt6psgFWW4V/hxdR4mIlEVq4G39eLFqktSRabUsvoUeupbN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721424; c=relaxed/simple;
	bh=BhRCOohn4hbHUeuaWiV1DDl7OMz1rjfz2almXtCLIhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cR9K6OqefeVh3JTq1qAS0xJOJT+6z5ywRAP2JXfi0lC0XKK+o1Z60mTHODQhtRdCePg6WF5op/leIW9vji7nKUteOmesi2kQR1dgHpxRTzxBZhysrQgSMalRcVLiApMHSWvhOM5ZQwN4adoI4d1cO588LoHq8My0oVIbSu7PYQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAOtyseQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAOtyseQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235F9C19425;
	Tue,  6 Jan 2026 17:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721423;
	bh=BhRCOohn4hbHUeuaWiV1DDl7OMz1rjfz2almXtCLIhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAOtyseQ6YqLp78u1CeEHn8UZ/992WrcJpHtwgbxVqepAIQoE3d60qO2K5EixnQrf
	 N7ZhVUohMiv5Ccmu11DEUHmYWhl0Nlus84bNjEY2EYfLNktFkKhi7kkbKNkI9UW49H
	 uctpTusDCuIii0ubBgo/NHmxYk/I/7vpNy7B4e/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 490/567] sched_ext: Fix incorrect sched_class settings for per-cpu migration tasks
Date: Tue,  6 Jan 2026 18:04:32 +0100
Message-ID: <20260106170509.488341378@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang@linux.dev>

[ Upstream commit 1dd6c84f1c544e552848a8968599220bd464e338 ]

When loading the ebpf scheduler, the tasks in the scx_tasks list will
be traversed and invoke __setscheduler_class() to get new sched_class.
however, this would also incorrectly set the per-cpu migration
task's->sched_class to rt_sched_class, even after unload, the per-cpu
migration task's->sched_class remains sched_rt_class.

The log for this issue is as follows:

./scx_rustland --stats 1
[  199.245639][  T630] sched_ext: "rustland" does not implement cgroup cpu.weight
[  199.269213][  T630] sched_ext: BPF scheduler "rustland" enabled
04:25:09 [INFO] RustLand scheduler attached

bpftrace -e 'iter:task /strcontains(ctx->task->comm, "migration")/
{ printf("%s:%d->%pS\n", ctx->task->comm, ctx->task->pid, ctx->task->sched_class); }'
Attaching 1 probe...
migration/0:24->rt_sched_class+0x0/0xe0
migration/1:27->rt_sched_class+0x0/0xe0
migration/2:33->rt_sched_class+0x0/0xe0
migration/3:39->rt_sched_class+0x0/0xe0
migration/4:45->rt_sched_class+0x0/0xe0
migration/5:52->rt_sched_class+0x0/0xe0
migration/6:58->rt_sched_class+0x0/0xe0
migration/7:64->rt_sched_class+0x0/0xe0

sched_ext: BPF scheduler "rustland" disabled (unregistered from user space)
EXIT: unregistered from user space
04:25:21 [INFO] Unregister RustLand scheduler

bpftrace -e 'iter:task /strcontains(ctx->task->comm, "migration")/
{ printf("%s:%d->%pS\n", ctx->task->comm, ctx->task->pid, ctx->task->sched_class); }'
Attaching 1 probe...
migration/0:24->rt_sched_class+0x0/0xe0
migration/1:27->rt_sched_class+0x0/0xe0
migration/2:33->rt_sched_class+0x0/0xe0
migration/3:39->rt_sched_class+0x0/0xe0
migration/4:45->rt_sched_class+0x0/0xe0
migration/5:52->rt_sched_class+0x0/0xe0
migration/6:58->rt_sched_class+0x0/0xe0
migration/7:64->rt_sched_class+0x0/0xe0

This commit therefore generate a new scx_setscheduler_class() and
add check for stop_sched_class to replace __setscheduler_class().

Fixes: f0e1a0643a59 ("sched_ext: Implement BPF extensible scheduler class")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -1057,6 +1057,14 @@ static struct scx_dispatch_q *find_user_
 	return rhashtable_lookup_fast(&dsq_hash, &dsq_id, dsq_hash_params);
 }
 
+static const struct sched_class *scx_setscheduler_class(struct task_struct *p)
+{
+	if (p->sched_class == &stop_sched_class)
+		return &stop_sched_class;
+
+	return __setscheduler_class(p->policy, p->prio);
+}
+
 /*
  * scx_kf_mask enforcement. Some kfuncs can only be called from specific SCX
  * ops. When invoking SCX ops, SCX_CALL_OP[_RET]() should be used to indicate
@@ -4653,8 +4661,7 @@ static void scx_ops_disable_workfn(struc
 	scx_task_iter_start(&sti);
 	while ((p = scx_task_iter_next_locked(&sti))) {
 		const struct sched_class *old_class = p->sched_class;
-		const struct sched_class *new_class =
-			__setscheduler_class(p->policy, p->prio);
+		const struct sched_class *new_class = scx_setscheduler_class(p);
 		struct sched_enq_and_set_ctx ctx;
 
 		if (old_class != new_class && p->se.sched_delayed)
@@ -5368,8 +5375,7 @@ static int scx_ops_enable(struct sched_e
 	scx_task_iter_start(&sti);
 	while ((p = scx_task_iter_next_locked(&sti))) {
 		const struct sched_class *old_class = p->sched_class;
-		const struct sched_class *new_class =
-			__setscheduler_class(p->policy, p->prio);
+		const struct sched_class *new_class = scx_setscheduler_class(p);
 		struct sched_enq_and_set_ctx ctx;
 
 		if (!tryget_task_struct(p))


