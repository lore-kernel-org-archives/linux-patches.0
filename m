Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8354D13F434;
	Thu, 13 Feb 2025 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458995; cv=none; b=L5jHGgjQAnYRPscIb5+tfPZ5SgO1cUAJU2R14Nmg+WfigP4RG2Jhs0n85N/lPXlVfuOKRHbX8MPPV18IdmKv8DHrXFsQLpUGnvlobOzioGvYBcf1kVgP0Br/15v4qsygfrkIUO8MCEgo/F51f9TfOhjOnVs+QYZKx7qqP65jpc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458995; c=relaxed/simple;
	bh=OAslttIImXKHVHvab7V+o3FOS5VzSwWYyGtotf45GJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwebX1GUUviALvbHn1wKsKuMkRLLD9Idi6sSRaUCfyNsQnsS1GkEgg+1KfE4+geQQWgoDqGR47sGxKFLHnQHNzF8wkFMxbvzPlx377+m3vYTe+k2kgGU8kv5wfowwtEIj9FQlcLdf1jR4CyjXPeg7ACD/s0S/tL3AvL7UtyhrsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvbVVdwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvbVVdwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03A7C4CED1;
	Thu, 13 Feb 2025 15:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458995;
	bh=OAslttIImXKHVHvab7V+o3FOS5VzSwWYyGtotf45GJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvbVVdwSON5uC/oqd2iuEic6n33i5ZKm//icrpszhCfArirD6+E53/BFKxP5zD2/L
	 dZaN+GttDfT4drQxlnOJiJDNSNjX/WAHYJ8D60409hMo2/+PRXlnSYbzl1WC0b9656
	 ZhGA44hRy6glDyzi9pR7cvmzXa4GLxKHx9t+UiyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Swapnil Sapkal <swapnil.sapkal@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 105/443] sched/fair: Fix inaccurate h_nr_runnable accounting with delayed dequeue
Date: Thu, 13 Feb 2025 15:24:30 +0100
Message-ID: <20250213142444.662530602@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit 3429dd57f0deb1a602c2624a1dd7c4c11b6c4734 ]

set_delayed() adjusts cfs_rq->h_nr_runnable for the hierarchy when an
entity is delayed irrespective of whether the entity corresponds to a
task or a cfs_rq.

Consider the following scenario:

	root
       /    \
      A	     B (*) delayed since B is no longer eligible on root
      |	     |
    Task0  Task1 <--- dequeue_task_fair() - task blocks

When Task1 blocks (dequeue_entity() for task's se returns true),
dequeue_entities() will continue adjusting cfs_rq->h_nr_* for the
hierarchy of Task1. However, when the sched_entity corresponding to
cfs_rq B is delayed, set_delayed() will adjust the h_nr_runnable for the
hierarchy too leading to both dequeue_entity() and set_delayed()
decrementing h_nr_runnable for the dequeue of the same task.

A SCHED_WARN_ON() to inspect h_nr_runnable post its update in
dequeue_entities() like below:

    cfs_rq->h_nr_runnable -= h_nr_runnable;
    SCHED_WARN_ON(((int) cfs_rq->h_nr_runnable) < 0);

is consistently tripped when running wakeup intensive workloads like
hackbench in a cgroup.

This error is self correcting since cfs_rq are per-cpu and cannot
migrate. The entitiy is either picked for full dequeue or is requeued
when a task wakes up below it. Both those paths call clear_delayed()
which again increments h_nr_runnable of the hierarchy without
considering if the entity corresponds to a task or not.

h_nr_runnable will eventually reflect the correct value however in the
interim, the incorrect values can still influence PELT calculation which
uses se->runnable_weight or cfs_rq->h_nr_runnable.

Since only delayed tasks take the early return path in
dequeue_entities() and enqueue_task_fair(), adjust the
h_nr_runnable in {set,clear}_delayed() only when a task is delayed as
this path skips the h_nr_* update loops and returns early.

For entities corresponding to cfs_rq, the h_nr_* update loop in the
caller will do the right thing.

Fixes: 76f2f783294d ("sched/eevdf: More PELT vs DELAYED_DEQUEUE")
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Tested-by: Swapnil Sapkal <swapnil.sapkal@amd.com>
Link: https://lkml.kernel.org/r/20250117105852.23908-1-kprateek.nayak@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8800679b508d9..7d0a05660e5ef 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5372,6 +5372,15 @@ static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 static void set_delayed(struct sched_entity *se)
 {
 	se->sched_delayed = 1;
+
+	/*
+	 * Delayed se of cfs_rq have no tasks queued on them.
+	 * Do not adjust h_nr_runnable since dequeue_entities()
+	 * will account it for blocked tasks.
+	 */
+	if (!entity_is_task(se))
+		return;
+
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
@@ -5384,6 +5393,16 @@ static void set_delayed(struct sched_entity *se)
 static void clear_delayed(struct sched_entity *se)
 {
 	se->sched_delayed = 0;
+
+	/*
+	 * Delayed se of cfs_rq have no tasks queued on them.
+	 * Do not adjust h_nr_runnable since a dequeue has
+	 * already accounted for it or an enqueue of a task
+	 * below it will account for it in enqueue_task_fair().
+	 */
+	if (!entity_is_task(se))
+		return;
+
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-- 
2.39.5



