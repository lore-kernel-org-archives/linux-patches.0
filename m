Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6F23128BC;
	Mon, 29 Dec 2025 16:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025625; cv=none; b=kRGcCixtyJrPSdp4G31d/4RAIccQI3qAHQodPB2A2m20JI20f96PwCcS3opzSsndgPSUkOJXOucFajcrjXJMmQXCXiYKo6HN+LpYqVxSWjDDkszKteQSDkYivApllBNwOQ/WQwNDzVYXDofq3cKCliFO6/4Et2mybTbRJWskOIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025625; c=relaxed/simple;
	bh=JPs6kp974DM+wmrH/DaeO7WdyTcrhrg5r8+AsCgADNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOAnF/1QJurBcUi9d+6Aa3zkMTks9X9j4AOotEL2wDq6c7sIKu1xSca464RvTcZT+H2gGpFH2P7B+YBVv9vEa3M8rYE9JU+WkpyLV7QixauPe3e+VSjYBWdmULZzRVqbklqJ/xGu2/ucNYNkCbipxUwaTyZLQoIG2vZrQqU7oHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M16UuCYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M16UuCYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36997C116C6;
	Mon, 29 Dec 2025 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025625;
	bh=JPs6kp974DM+wmrH/DaeO7WdyTcrhrg5r8+AsCgADNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M16UuCYH4N3rIkvQ2HcACCEFxn5wmCvpG+Nz76dMlQJ+aAfoyAs2Ej/eJWoer9mZg
	 MqYKjXURbBBQPAl6gHOA+ZPG1mL3wnDAbqWnq8L0sXmxYuPWzVDfZA8h1/JnZrI7Fo
	 3JeP3PphqDQUabrZKV95Ai5AHVPkKSacV4GNpM/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 236/430] sched_ext: Fix missing post-enqueue handling in move_local_task_to_local_dsq()
Date: Mon, 29 Dec 2025 17:10:38 +0100
Message-ID: <20251229160733.039409122@linuxfoundation.org>
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

commit f5e1e5ec204da11fa87fdf006d451d80ce06e118 upstream.

move_local_task_to_local_dsq() is used when moving a task from a non-local
DSQ to a local DSQ on the same CPU. It directly manipulates the local DSQ
without going through dispatch_enqueue() and was missing the post-enqueue
handling that triggers preemption when SCX_ENQ_PREEMPT is set or the idle
task is running.

The function is used by move_task_between_dsqs() which backs
scx_bpf_dsq_move() and may be called while the CPU is busy.

Add local_dsq_post_enq() call to move_local_task_to_local_dsq(). As the
dispatch path doesn't need post-enqueue handling, add SCX_RQ_IN_BALANCE
early exit to keep consume_dispatch_q() behavior unchanged and avoid
triggering unnecessary resched when scx_bpf_dsq_move() is used from the
dispatch path.

Fixes: 4c30f5ce4f7a ("sched_ext: Implement scx_bpf_dispatch[_vtime]_from_dsq()")
Cc: stable@vger.kernel.org # v6.12+
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -919,6 +919,14 @@ static void local_dsq_post_enq(struct sc
 	struct rq *rq = container_of(dsq, struct rq, scx.local_dsq);
 	bool preempt = false;
 
+	/*
+	 * If @rq is in balance, the CPU is already vacant and looking for the
+	 * next task to run. No need to preempt or trigger resched after moving
+	 * @p into its local DSQ.
+	 */
+	if (rq->scx.flags & SCX_RQ_IN_BALANCE)
+		return;
+
 	if ((enq_flags & SCX_ENQ_PREEMPT) && p != rq->curr &&
 	    rq->curr->sched_class == &ext_sched_class) {
 		rq->curr->scx.slice = 0;
@@ -1524,6 +1532,8 @@ static void move_local_task_to_local_dsq
 
 	dsq_mod_nr(dst_dsq, 1);
 	p->scx.dsq = dst_dsq;
+
+	local_dsq_post_enq(dst_dsq, p, enq_flags);
 }
 
 /**


