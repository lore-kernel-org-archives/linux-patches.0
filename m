Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD0224166E;
	Thu, 13 Feb 2025 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457397; cv=none; b=F4AlnX/++bdMiWunzjJMp2IYBrhvZWcFk+dDDMks/qX68bhpRJYBUkooMG192Espzl8FjxdjZJgP862Xkx4AURYIGfuDO5PdBX2n4bm0XW3ekj2kyuBv+YyAUGekCCsC86smLzDV9IZdec4T3U+EmjfZIBVvPPcd11vabzrL94I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457397; c=relaxed/simple;
	bh=bsApMNlGnKNxXD8Y38WzWoP7yeV2prZ17E2Bp24u9YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1y5AH+syo111nD9IguKNem1H4SFDm8JcwVLEuxY+rsAF9ikfEdSiivJypg3bxbdgM7vVyWqiNVPsl93zuPcgbJKz1k2PUwwYEWIIVH3jT5ABlZ9dV5pK463fCV7SJZ2xMEwL2/D//sMYFWbbq74EdomvTMHDpbIQDAVPMDMYe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVUm2oTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVUm2oTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16C3C4CED1;
	Thu, 13 Feb 2025 14:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457397;
	bh=bsApMNlGnKNxXD8Y38WzWoP7yeV2prZ17E2Bp24u9YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVUm2oTDam+039VLuF6nsf5NsaKMWp2WTxT7S6kaQtVlVMuyJxE/gEnLQruVAjKI7
	 keeEUiNmT9e67ynczeJWfTRw1xbCbhBWu6shPT5ZEKvv+A9ZpedhPxAncDl5+CNjKj
	 QKy14ODwMemDXnV3O1HEmpn2MChcK3tY5vL/OYQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Swapnil Sapkal <swapnil.sapkal@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/422] sched/fair: Fix inaccurate h_nr_runnable accounting with delayed dequeue
Date: Thu, 13 Feb 2025 15:24:08 +0100
Message-ID: <20250213142440.377054883@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
index 65e7be6448720..ddc096d6b0c20 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5481,6 +5481,15 @@ static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
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
 
@@ -5493,6 +5502,16 @@ static void set_delayed(struct sched_entity *se)
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



