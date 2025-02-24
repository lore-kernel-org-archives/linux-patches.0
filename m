Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCB1824A3;
	Mon, 24 Feb 2025 14:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408388; cv=none; b=r/0jX+JbGumRW2UbFP5TADdguwfcFkB4EDXyN78GX1uhsHfNgHER7dg+SFSMfgAY7m7+DVGVK5rLChTNuJ84dHtJxkHsa3kHq1eg9Y46dF8Te4jYBiaD2MJaiDU9UNjvNS5hLAHfxyHM0my9RLeaRIhCP2sJ6Qx/w79ciW49mT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408388; c=relaxed/simple;
	bh=PMvox3xMYbl7WiSJTlIdEICbSrpurN7CnPQzOq0sZZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbUoOeyFWVgUgF8wMtMIZAaI7OBd8VmDDBc6dF9sIoA/vh1wQQC23CHrXRbJmMY2RPbq+u32Zw/0g9qZkelXDbegYMehyGciJhZA/5T0qIylmwa3X6jhjJiq/9J0WkF5CqQ39kJbTfVrx2byeWTje1BHYtG/pgOlHt6rHZFWKU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8kLD/lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8kLD/lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DE5C4CED6;
	Mon, 24 Feb 2025 14:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408388;
	bh=PMvox3xMYbl7WiSJTlIdEICbSrpurN7CnPQzOq0sZZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8kLD/lzm5EsdoojsvyUMdzR4jiGks8evIb7sc26dkJkflFbkWWSMYSsrDLtsTaVa
	 kkPSbhE95uZI0v70XQsWNhdXqfKCowa07h3uKtpqEPuWUZ2TrVqG4+TuT9qWKv1NNX
	 U7x/wSoohsxvERGRHPSQOPzy/Ju4MpMjtGQKKqaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/154] sched_ext: Fix migration disabled handling in targeted dispatches
Date: Mon, 24 Feb 2025 15:34:02 +0100
Message-ID: <20250224142608.779388192@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

[ Upstream commit 32966821574cd2917bd60f2554f435fe527f4702 ]

A dispatch operation that can target a specific local DSQ -
scx_bpf_dsq_move_to_local() or scx_bpf_dsq_move() - checks whether the task
can be migrated to the target CPU using task_can_run_on_remote_rq(). If the
task can't be migrated to the targeted CPU, it is bounced through a global
DSQ.

task_can_run_on_remote_rq() assumes that the task is on a CPU that's
different from the targeted CPU but the callers doesn't uphold the
assumption and may call the function when the task is already on the target
CPU. When such task has migration disabled, task_can_run_on_remote_rq() ends
up returning %false incorrectly unnecessarily bouncing the task to a global
DSQ.

Fix it by updating the callers to only call task_can_run_on_remote_rq() when
the task is on a different CPU than the target CPU. As this is a bit subtle,
for clarity and documentation:

- Make task_can_run_on_remote_rq() trigger SCHED_WARN_ON() if the task is on
  the same CPU as the target CPU.

- is_migration_disabled() test in task_can_run_on_remote_rq() cannot trigger
  if the task is on a different CPU than the target CPU as the preceding
  task_allowed_on_cpu() test should fail beforehand. Convert the test into
  SCHED_WARN_ON().

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 4c30f5ce4f7a ("sched_ext: Implement scx_bpf_dispatch[_vtime]_from_dsq()")
Fixes: 0366017e0973 ("sched_ext: Use task_can_run_on_remote_rq() test in dispatch_to_local_dsq()")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 97076748dee0e..0fc18fc5753b0 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2300,12 +2300,16 @@ static void move_remote_task_to_local_dsq(struct task_struct *p, u64 enq_flags,
  *
  * - The BPF scheduler is bypassed while the rq is offline and we can always say
  *   no to the BPF scheduler initiated migrations while offline.
+ *
+ * The caller must ensure that @p and @rq are on different CPUs.
  */
 static bool task_can_run_on_remote_rq(struct task_struct *p, struct rq *rq,
 				      bool trigger_error)
 {
 	int cpu = cpu_of(rq);
 
+	SCHED_WARN_ON(task_cpu(p) == cpu);
+
 	/*
 	 * We don't require the BPF scheduler to avoid dispatching to offline
 	 * CPUs mostly for convenience but also because CPUs can go offline
@@ -2319,8 +2323,11 @@ static bool task_can_run_on_remote_rq(struct task_struct *p, struct rq *rq,
 		return false;
 	}
 
-	if (unlikely(is_migration_disabled(p)))
-		return false;
+	/*
+	 * If @p has migration disabled, @p->cpus_ptr only contains its current
+	 * CPU and the above task_allowed_on_cpu() test should have failed.
+	 */
+	SCHED_WARN_ON(is_migration_disabled(p));
 
 	if (!scx_rq_online(rq))
 		return false;
@@ -2424,7 +2431,8 @@ static struct rq *move_task_between_dsqs(struct task_struct *p, u64 enq_flags,
 
 	if (dst_dsq->id == SCX_DSQ_LOCAL) {
 		dst_rq = container_of(dst_dsq, struct rq, scx.local_dsq);
-		if (!task_can_run_on_remote_rq(p, dst_rq, true)) {
+		if (src_rq != dst_rq &&
+		    unlikely(!task_can_run_on_remote_rq(p, dst_rq, true))) {
 			dst_dsq = find_global_dsq(p);
 			dst_rq = src_rq;
 		}
@@ -2541,7 +2549,8 @@ static void dispatch_to_local_dsq(struct rq *rq, struct scx_dispatch_q *dst_dsq,
 	}
 
 #ifdef CONFIG_SMP
-	if (unlikely(!task_can_run_on_remote_rq(p, dst_rq, true))) {
+	if (src_rq != dst_rq &&
+	    unlikely(!task_can_run_on_remote_rq(p, dst_rq, true))) {
 		dispatch_enqueue(find_global_dsq(p), p,
 				 enq_flags | SCX_ENQ_CLEAR_OPSS);
 		return;
-- 
2.39.5



