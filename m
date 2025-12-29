Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF69F31ED83;
	Mon, 29 Dec 2025 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025497; cv=none; b=r+VljCyoCtGqKMqWQgix4fb288SIaTUCWzniP2RZyFBFoVRRwzPmy9TXIdfx5UrDwgrE8AgMc9KHGwQhGzfvt6HjRxPoPx5ndcuZCO2M1ZE3IKdgrzZ7Vu/hMj3amJYkpyEeCKZoXuXjtxDq6nY979VM5WU2dCnRnybozDhbIDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025497; c=relaxed/simple;
	bh=hNrcEPESMZa1tDwz5NWUnAbzMeg5BbBFqMySLg2wPbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMNVnTi/4vK3Y4t9gaK+8zi74hf4NeHmT77Zg5Bnd3u2U0vJAIKD8Je/wYsxynPcPS8LFYecohPUMbeENIh4ht3yhVD5VegT4kSPPWeaGO3hAxM52+X+uRq/Z0GiEsfCnQmKQsNF8XfjlkmQF3DWM1zQmXiDrosLeh4oYU5V0oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSbyjmUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSbyjmUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E5EC4CEF7;
	Mon, 29 Dec 2025 16:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025497;
	bh=hNrcEPESMZa1tDwz5NWUnAbzMeg5BbBFqMySLg2wPbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSbyjmUjXTyUcztQBnY60OAh0I8yZ7D7cCCtK2DsBCNK5n5B2xmQNAUrpGOnvUAv4
	 bgZGt0k6FkmvvesrWL7WF5ouyoca+5QkAJKMUdLrimCBH/VvAv0z6M7rNkPi+xIZPQ
	 bPclNZLO/XFDilBAd61uc4dcAvbPB69RwI0EOAu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 233/430] sched_ext: Factor out local_dsq_post_enq() from dispatch_enqueue()
Date: Mon, 29 Dec 2025 17:10:35 +0100
Message-ID: <20251229160732.927879290@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

commit 530b6637c79e728d58f1d9b66bd4acf4b735b86d upstream.

Factor out local_dsq_post_enq() which performs post-enqueue handling for
local DSQs - triggering resched_curr() if SCX_ENQ_PREEMPT is specified or if
the current CPU is idle. No functional change.

This will be used by the next patch to fix move_local_task_to_local_dsq().

Cc: stable@vger.kernel.org # v6.12+
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -906,6 +906,22 @@ static void refill_task_slice_dfl(struct
 	__scx_add_event(sch, SCX_EV_REFILL_SLICE_DFL, 1);
 }
 
+static void local_dsq_post_enq(struct scx_dispatch_q *dsq, struct task_struct *p,
+			       u64 enq_flags)
+{
+	struct rq *rq = container_of(dsq, struct rq, scx.local_dsq);
+	bool preempt = false;
+
+	if ((enq_flags & SCX_ENQ_PREEMPT) && p != rq->curr &&
+	    rq->curr->sched_class == &ext_sched_class) {
+		rq->curr->scx.slice = 0;
+		preempt = true;
+	}
+
+	if (preempt || sched_class_above(&ext_sched_class, rq->curr->sched_class))
+		resched_curr(rq);
+}
+
 static void dispatch_enqueue(struct scx_sched *sch, struct scx_dispatch_q *dsq,
 			     struct task_struct *p, u64 enq_flags)
 {
@@ -1003,22 +1019,10 @@ static void dispatch_enqueue(struct scx_
 	if (enq_flags & SCX_ENQ_CLEAR_OPSS)
 		atomic_long_set_release(&p->scx.ops_state, SCX_OPSS_NONE);
 
-	if (is_local) {
-		struct rq *rq = container_of(dsq, struct rq, scx.local_dsq);
-		bool preempt = false;
-
-		if ((enq_flags & SCX_ENQ_PREEMPT) && p != rq->curr &&
-		    rq->curr->sched_class == &ext_sched_class) {
-			rq->curr->scx.slice = 0;
-			preempt = true;
-		}
-
-		if (preempt || sched_class_above(&ext_sched_class,
-						 rq->curr->sched_class))
-			resched_curr(rq);
-	} else {
+	if (is_local)
+		local_dsq_post_enq(dsq, p, enq_flags);
+	else
 		raw_spin_unlock(&dsq->lock);
-	}
 }
 
 static void task_unlink_from_dsq(struct task_struct *p,


