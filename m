Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBAF4CF477;
	Sat, 17 Oct 2026 15:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252503; cv=none; b=R4Srq9Y8Q/CWmOjqfaJ/kyBJs2jGryVAuAjB/lnVO0Jhavn1qjXyzo7POw0nlRtDEvJUF9VnGcE2yfKra427ZC4YdnPXTsnbklt1sOZ4Vat4rhIFl4hCmD2aqHo5HQjL/yJgrHV0FZh7TwscYA/tRG8m6oHbk+ZBaXwRe7SqXxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252503; c=relaxed/simple;
	bh=lXo3XB2LLXpwbEN6NZ2kvp9NJdBhq4itzGBNwc/k3ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMn4pfzAxKbj2JpuMfEFVUn35ok1NXmScVoXLMl1pGZ9JU5gzlBU8zWJFQf8yYVI9KwQL9R6phyzeHZ4r29hM/W1+BbvyrBlV05CGvcaRFTrKOAKHSL1CwcGohF/FTpBKiwaAPkOFmNQ6z+31GR3rYmAQJ9O1HvBeDIbP7baXwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5nAIt+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5nAIt+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57BB1F000C4;
	Sat, 17 Oct 2026 15:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252502;
	bh=YEdzEzWfLhYbY9uvwhRajioeH3keF106taevMd5mSRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5nAIt+HYrLEW2pVrEy/0GzWkWtxFpGzTh++6+WqaH+miZMZpyNSvUqA1v+jf1ImE
	 JXQeG9f+glGr7FtG1CJ4XJtjtz1ZyiSMqf0Ct+AVjde6j8eq+SvCgdqW0Xs6Gfn77f
	 kSfyQcvdOd+uKAMQES/otyh0hsFSaE9JZ1u5ev4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alap Mohan <mohaalap@meta.com>,
	Joonwoo Park <joonwoo@meta.com>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 04/10] sched_ext: Fix CPU hotplug hang when a dying CPUs tasks sit in the BPF scheduler
Date: Sat, 17 Oct 2026 17:54:33 +0200
Message-ID: <20261017155059.859400220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
References: <20261017155059.698368299@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit d35a535d3e3e71f92a051d94e415f43612c4edfc ]

A CPU going down has to empty its own rq. Its hotplug thread waits in
sched_cpu_wait_empty() until nothing else is left, and the only thing that
wakes it is balance_push(), which runs from __schedule() on the dying CPU
and pushes off the migratable tasks the CPU picks.

sched_ext breaks this. A task sitting on a user DSQ or held by the BPF
scheduler is still counted on its rq, but an inactive CPU no longer calls
ops.dispatch() and can't pull the task back. The dying CPU goes idle with
the task still counted, and one of two things happens:

- Another CPU consumes the task. The rq empties without a __schedule() on
  the dying CPU, so the hotplug thread is never woken and cpu_down() hangs
  holding cpu_hotplug_lock.
- The task is affine only to the dying CPU. Nothing can move it, and the
  offline stalls until the watchdog ejects the BPF scheduler.

When the rq goes offline, re-enqueue every task on it that isn't already on
the local DSQ. An enqueue on an offline rq lands on the local DSQ, so the
dying CPU itself picks the tasks and balance_push() pushes them off, the
same as for the other sched classes. From then on no sched_ext path on
another CPU can pull a task off the rq.

ops.dispatch() currently stops as soon as the CPU goes inactive, and CPU
hotplug then waits for an RCU grace period before taking the rq offline. A
BPF-held task affine only to the dying CPU and preempted inside an RCU
read-side critical section would block that grace period, and the rq would
never go offline. Test SCX_RQ_ONLINE directly so that ops.dispatch() keeps
running until the rq goes offline. Only the dying CPU's own hotplug thread
clears the flag during teardown, and task_can_run_on_remote_rq() still keeps
other rqs' tasks off the CPU.

Fixes: f0e1a0643a59 ("sched_ext: Implement BPF extensible scheduler class")
Fixes: 991ef53a4832 ("sched_ext: Make scx_rq_online() also test cpu_active() in addition to SCX_RQ_ONLINE")
Cc: stable@vger.kernel.org # v6.12+
Reported-by: Alap Mohan <mohaalap@meta.com>
Reported-by: Joonwoo Park <joonwoo@meta.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
[ sashal: Omitted rescue-related changes because the rescue machinery is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 29 ++++++++++++++++++++++++++---
 kernel/sched/sched.h   |  5 +++--
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index a9f33e2b17ace..8d4992e7e0120 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -2031,8 +2031,8 @@ static void set_task_runnable(struct rq *rq, struct task_struct *p)
 	}
 
 	/*
-	 * list_add_tail() must be used. scx_bypass() depends on tasks being
-	 * appended to the runnable_list.
+	 * list_add_tail() must be used. scx_bypass() and rq_offline_scx()
+	 * depend on tasks being appended to the runnable_list.
 	 */
 	list_add_tail(&p->scx.runnable_node, &rq->scx.runnable_list);
 }
@@ -2868,7 +2868,13 @@ scx_dispatch_sched(struct scx_sched *sch, struct rq *rq,
 #endif	/* CONFIG_EXT_SUB_SCHED */
 	}
 
-	if (unlikely(!SCX_HAS_OP(sch, dispatch)) || !scx_rq_online(rq))
+	/*
+	 * scx_rq_online() can't be used. Its cpu_active() test goes false
+	 * before CPU hotplug waits for an RCU grace period, and
+	 * rq_offline_scx() moves this CPU's tasks to the local DSQ only after
+	 * the wait. The grace period can depend on those tasks running.
+	 */
+	if (unlikely(!SCX_HAS_OP(sch, dispatch)) || !(rq->scx.flags & SCX_RQ_ONLINE))
 		return SCX_DSP_NONE;
 
 	dspc->rq = rq;
@@ -3608,7 +3614,24 @@ static void rq_online_scx(struct rq *rq)
 
 static void rq_offline_scx(struct rq *rq)
 {
+	struct task_struct *p, *n;
+
 	rq->scx.flags &= ~SCX_RQ_ONLINE;
+
+	/* sched domain rebuilds call rq_offline with the CPU staying alive */
+	if (cpu_active(cpu_of(rq)))
+		return;
+
+	/*
+	 * An offline CPU no longer calls ops.dispatch(). Re-enqueue its tasks
+	 * onto the local DSQ so that they run here and balance_push() moves
+	 * them off.
+	 */
+	list_for_each_entry_safe_reverse(p, n, &rq->scx.runnable_list, scx.runnable_node) {
+		if (p->scx.dsq == &rq->scx.local_dsq)
+			continue;
+		guard(sched_change)(p, DEQUEUE_SAVE | DEQUEUE_MOVE | DEQUEUE_NOCLOCK);
+	}
 }
 
 static bool check_rq_for_timeouts(struct rq *rq)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a6c6f8165eecc..d25defb116caa 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4185,8 +4185,9 @@ extern void balance_callbacks(struct rq *rq, struct balance_callback *head);
  * after which it is enqueued again.
  *
  * Typically this must be called while holding task_rq_lock, since most/all
- * properties are serialized under those locks. There is currently one
- * exception to this rule in sched/ext which only holds rq->lock.
+ * properties are serialized under those locks. There are currently two
+ * exceptions to this rule in sched/ext which only hold rq->lock: scx_bypass()
+ * and rq_offline_scx().
  */
 
 /*
-- 
2.53.0



