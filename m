Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619954;
	b=18T9/qH5Tca1GGdbpaBC4wYAyyd+DEKqat6AVmV0tbBtxA5vMN33W4tee3GFWnfHjPnO
	 wHMsVAlMcOXn/WWaSPCZvje33LVgrGaTUvAlo7VnXTr99uJqTIU3N5BOMFD/MRY6RzauZ
	 c2wEAEhUadwnGC9w+D85q+l89y/lIWVlcozzu5O3Y1t6UWCLDoncaC9CjOPbQWAAk+UmX
	 m4ra+fv3+7XIIM3GA179oVl9enswVMmkCb1r/7d9xGHogU6TpxURh1zfuuwcGyQFTfA0C
	 4VqJVVhVpYxJXRi5moENNcUylBXpiqPqH4GjrGuv/G1f+J4laJ3H0N/gmRPTg+KhAEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o8Zv1MMotOEL05iy5Rjraqiz0wMJs96Yt2U+zl6zQ20=;
	b=ZUDaUqTH4rve9/60IWXQMZVIKY1v7kbmbdNWqBVMtcbYkgygrsFVFfT8rfyBkIdgYS7X
	 /DhuTp7LdO92GLuuiPh3wu11o125JlS+X5ZwDaRF3wbEb28oZoovYNGz7x0m8ONeuaA6Y
	 dEuEUS6CSpkG105/vRqJ/ZK1e0AZVgcrbWuJlRjHVU6FG1PJ+NGuvPMf0vTZNNpeD3UgL
	 CeDrjmjDhKJRk8/BqarLig1tA/b/xEYu2W83rsLonqSRzMyXDZqy4naiMej85b/sb6sSw
	 5yRtazfObzFrzrhX7DclXw3IRJ/vH7wxEL35Sl352ccxinLMXMWb59Qqj4VwH2H1pBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZdLU1Ae;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23F2606A31E;
	Wed, 25 Nov 2026 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZdLU1Ae
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5651F000C6;
	Wed, 25 Nov 2026 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619954;
	bh=o8Zv1MMotOEL05iy5Rjraqiz0wMJs96Yt2U+zl6zQ20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZdLU1AecLN3THx6Wa1VFkQMhjPigsOkGAM0OD/Hbp3WgdwkRjOTAl9TL6a02kB1r
	 SdltsHESEpxNNwwuVwRmvoUXzrlez43JbOsx1BG6ZAc9or41nqCSdbTq/4G3EEoEBA
	 GFerVjeogS7kJgUcT6M9o1qCzcSvzmYwy3tvVBx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>
Subject: [PATCH 7.3 0761/1005] sched_ext: Fix stale pick when the donor changes during dispatch
Date: Wed, 25 Nov 2026 15:34:59 +0100
Message-ID: <20261125143839.573833993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 9ce6fca02867911ba79bc3664219effe8c7be8f4 upstream.

Dispatch takes rq->donor as @prev and can drop the rq lock. With proxy
execution, @prev may not be the running task, and another CPU can reset the
donor to rq->curr meanwhile, through proxy_needs_return() on a wakeup or
sched_proxy_block_task() on a class or scheduler change. The wakeup case:

1. dispatch_one() drops the rq lock, e.g. to move a task from another CPU.
2. Another CPU wakes the donor, which proxy execution migrated to this CPU.
   proxy_needs_return() dequeues it and resets the donor to rq->curr, and
   the wakeup enqueues it, possibly on another CPU.
3. dispatch_one() sees @prev queued and returns SCX_DSP_PREV.
4. do_pick_task_scx() returns @prev, and this CPU runs a task that is queued
   on another rq.

Under core scheduling, the core pick runs dispatch for the sibling rqs with
each sibling's donor as @prev, and a sibling can switch @prev out while
dispatch has the lock dropped.

Whatever dispatch concluded, and whatever it does with @prev after the drop,
is about a task the rq no longer owns, whether it keeps @prev running or
hands it to ops.dispatch().

rq_modified_above() catches the change only when rq->curr is in a class
above ext, and the dl_server pick skips that check. dispatch_core_pick()
retries after a lock drop, but by then dispatch has used @prev.

Restart the pick when @prev is no longer the donor. dispatch_one() tests
after each step that can drop the lock, and scx_dispatch_sched() decides per
ops.dispatch() call whether to hand @prev over, which also covers a class or
scheduler change across a drop.

With proxy execution alone, the donor only ever changes to rq->curr during a
pick, so the retried pick can't go stale again. Under core scheduling, the
restart goes through the core pick, which already retries after any lock
drop.

7a3a6bfbd62a ("sched: Rework prev_balance() to avoid stale prev references")
closed the same window in prev_balance() by reading rq->donor instead of
taking @prev. That doesn't work here, as dispatch never evaluated the new
donor, which may not even be a sched_ext task.

Verified with synthetic reproducers for both cases.

v2: Also cover rq lock drops inside dispatch (sashiko).

v3: Don't keep a stale @prev after ops.dispatch() (sashiko).

v4: Also cover a sibling switching @prev out under core scheduling. Retitle.

Fixes: 7b0888b7cc19 ("sched_ext: Implement core-sched support")
Fixes: c6fe97c34a1a ("sched: Allow enabling proxy exec with sched_ext")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c     |   10 ++++++++++
 kernel/sched/ext/inlines.h |   37 +++++++++++++++++++++++++++++++++----
 2 files changed, 43 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -3007,6 +3007,12 @@ static enum scx_dsp_verdict dispatch_one
 		rq->scx.cpu_released = false;
 	}
 
+	/* the ecaps sync may have dropped the rq lock */
+	if (scx_dsp_prev_stale(rq, prev)) {
+		verdict = SCX_DSP_RETRY;
+		goto has_tasks;
+	}
+
 	if (prev->sched_class == &ext_sched_class) {
 		update_curr_scx(rq);
 
@@ -3034,6 +3040,10 @@ static enum scx_dsp_verdict dispatch_one
 	}
 
 	verdict = scx_dispatch_sched(root_sch, rq, prev, false);
+
+	/* scx_dispatch_sched() may have dropped the rq lock */
+	if (scx_dsp_prev_stale(rq, prev))
+		verdict = SCX_DSP_RETRY;
 	if (verdict != SCX_DSP_NONE)
 		goto has_tasks;
 
--- a/kernel/sched/ext/inlines.h
+++ b/kernel/sched/ext/inlines.h
@@ -18,9 +18,32 @@ enum scx_dsp_verdict {
 	SCX_DSP_NONE,		/* nothing to run */
 	SCX_DSP_LOCAL,		/* local DSQ has tasks */
 	SCX_DSP_PREV,		/* keep running @prev */
-	SCX_DSP_RETRY,		/* pick helpers only: restart the pick */
+	SCX_DSP_RETRY,		/* restart the pick */
 };
 
+/**
+ * scx_dsp_prev_stale - Test whether dispatch's @prev went stale
+ * @rq: rq being dispatched for
+ * @prev: @rq's donor when dispatch started
+ *
+ * @prev can stop being @rq's donor while dispatch has the rq lock dropped. With
+ * proxy execution, @prev may not be the running task, and another CPU can reset
+ * the donor to rq->curr. With core scheduling, the core pick runs dispatch for
+ * the sibling rqs too, and a sibling can switch @prev out. Dispatch restarts
+ * the pick when that happened and doesn't hand the old donor to the BPF
+ * scheduler.
+ *
+ * With proxy execution alone, the donor only ever changes to rq->curr during a
+ * pick. Only __schedule() on this CPU sets a different donor, after the pick,
+ * so the restarted pick takes rq->curr as @prev and can't go stale again. Under
+ * core scheduling, the restart goes through the core pick, which already
+ * retries whenever dispatch dropped the lock.
+ */
+static inline bool scx_dsp_prev_stale(struct rq *rq, struct task_struct *prev)
+{
+	return (sched_proxy_exec() || sched_core_enabled(rq)) && unlikely(prev != rq->donor);
+}
+
 /*
  * One user of this function is scx_bpf_sub_dispatch() which can be called
  * recursively as sub-sched dispatches nest. Always inline to reduce stack usage
@@ -33,8 +56,7 @@ scx_dispatch_sched(struct scx_sched *sch
 	struct scx_dsp_ctx *dspc = &this_cpu_ptr(sch->pcpu)->dsp_ctx;
 	int nr_loops = SCX_DSP_MAX_LOOPS;
 	s32 cpu = cpu_of(rq);
-	bool prev_on_sch = (prev->sched_class == &ext_sched_class) &&
-		scx_task_on_sched(sch, prev);
+	bool prev_on_sch;
 
 	if (scx_consume_global_dsq(sch, rq))
 		return SCX_DSP_LOCAL;
@@ -106,6 +128,11 @@ scx_dispatch_sched(struct scx_sched *sch
 			rq->scx.sub_dispatch_prev = prev;
 #endif
 
+		/* the dispatch so far may have dropped the rq lock */
+		prev_on_sch = !scx_dsp_prev_stale(rq, prev) &&
+			      prev->sched_class == &ext_sched_class &&
+			      scx_task_on_sched(sch, prev);
+
 		SCX_CALL_OP(sch, dispatch, rq, scx_cpu_arg(cpu),
 			    prev_on_sch ? prev : NULL);
 
@@ -116,7 +143,9 @@ scx_dispatch_sched(struct scx_sched *sch
 
 		scx_flush_dispatch_buf(sch, rq);
 
-		if ((prev->scx.flags & SCX_TASK_QUEUED) && prev->scx.slice)
+		/* ops.dispatch() and the flush may have dropped the rq lock */
+		if (!scx_dsp_prev_stale(rq, prev) &&
+		    (prev->scx.flags & SCX_TASK_QUEUED) && prev->scx.slice)
 			return SCX_DSP_PREV;
 		if (rq->scx.local_dsq.nr)
 			return SCX_DSP_LOCAL;


