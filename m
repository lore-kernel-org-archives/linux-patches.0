Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6241FE44E;
	Wed, 19 Feb 2025 08:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954374; cv=none; b=tGz2K3ZVLxCTNSEoFrSE5bD45jidjnidyXumEVcSh7MaoDrRcnXHMHlK9O90d2Be0n4Ze1zV4J4/4cBKgXBZrKsxZsvmXUIK74+CEuSDUrG0Ax6s0MBq0Jjq0vUPogSukxomp8oK5cgNjVaQ4uxAvbxPcqj/MSD8zKwgU92kNe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954374; c=relaxed/simple;
	bh=q1STI0Lqmh24deoLI55ENOeWSOyUVE+iIM/C8rmezlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeKnEhIyU+AXDsiacbZvl1+zgq6U66aGtmzLCwyD99TWSgj4m4MX1PpGxzFyZn1x6yF7ixtaWBNr/M4vn+L30kMAaPxjar0aRZcKN/4Yb3NI2IqzlfbpmY3CnRF1iT0+TYN9FPJ6LzVR/0D/Fr1xk9R9uXza285UeKAxVBoyM2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMVLMweF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMVLMweF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C52C4CEE7;
	Wed, 19 Feb 2025 08:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954374;
	bh=q1STI0Lqmh24deoLI55ENOeWSOyUVE+iIM/C8rmezlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMVLMweF1W58I6zypRpjtlvvyNH8lvSXYxKEsl25rTCbUQYtwZtXvxffKeQEu6FMW
	 pgHS5MyUqBVmy3zkC9piJOSvai785Du4o2i8EFsQl/OD5BrWyqnezQxiwlpw2xEsbN
	 nnhNUjJ/Ow8nTprqTNW+hmVW1Bm04KnOgtRo0y88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.13 185/274] sched_ext: Fix migration disabled handling in targeted dispatches
Date: Wed, 19 Feb 2025 09:27:19 +0100
Message-ID: <20250219082616.825115719@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 32966821574cd2917bd60f2554f435fe527f4702 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2313,12 +2313,16 @@ static void move_remote_task_to_local_ds
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
@@ -2332,8 +2336,11 @@ static bool task_can_run_on_remote_rq(st
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
@@ -2437,7 +2444,8 @@ static struct rq *move_task_between_dsqs
 
 	if (dst_dsq->id == SCX_DSQ_LOCAL) {
 		dst_rq = container_of(dst_dsq, struct rq, scx.local_dsq);
-		if (!task_can_run_on_remote_rq(p, dst_rq, true)) {
+		if (src_rq != dst_rq &&
+		    unlikely(!task_can_run_on_remote_rq(p, dst_rq, true))) {
 			dst_dsq = find_global_dsq(p);
 			dst_rq = src_rq;
 		}
@@ -2591,7 +2599,8 @@ static void dispatch_to_local_dsq(struct
 	}
 
 #ifdef CONFIG_SMP
-	if (unlikely(!task_can_run_on_remote_rq(p, dst_rq, true))) {
+	if (src_rq != dst_rq &&
+	    unlikely(!task_can_run_on_remote_rq(p, dst_rq, true))) {
 		dispatch_enqueue(find_global_dsq(p), p,
 				 enq_flags | SCX_ENQ_CLEAR_OPSS);
 		return;


