Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB711F943F;
	Tue, 17 Dec 2024 17:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456776; cv=none; b=K6ZBdk2UChAGN+vPAcvtJhRg6JvTDCzsZz0zt07+GCGUrRzjveRxHYELRExoOCgci11yU7deQGFu/QZVXLzOcZHDRF/iLvhXqhnYOfHdtrKf3lzthC6Q4ssBq5OyALZp32fadYu+D5PIkXMkJDfs1QDAKujcTYvsGLJ7nu5KTAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456776; c=relaxed/simple;
	bh=3h18GEkKqDlDlBhZk+CtxGEQpJOUeD1NCA+/eYfzThg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bzc/Is9ATCfTHB9dULinZRXLxj+eETwKj/IYzLS3n0Y4oU5nEiI4ibsForhUdHnt6yhU6MH7lYHT6o61oYGJxj10ScQxlJWb0YuBowes1TqG1QVlpjGX/5lt8vdn5bnNWj1H6KGsjC7WMkP4Jy+2AkS3IqZkn3cJdJAS3kGbH4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdEPjG7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdEPjG7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D18C4CED3;
	Tue, 17 Dec 2024 17:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456775;
	bh=3h18GEkKqDlDlBhZk+CtxGEQpJOUeD1NCA+/eYfzThg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdEPjG7S/CmOCUR0GMFwRo16WE7xqhWnhC0wRxwMrCzu5xjJLHWyKW9esnQTQvcfT
	 rJjQyDwroRdI+s/aiF64jgkn7XRMo8LgfaIcf0zeda/DH8y4IaOp8gE7xZhCASqeCg
	 zRheDgX6wyq4v8qm3/+CJt1r1+LK8dh/nnmpn5KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Babu Moger <babu.moger@amd.com>,
	Luck Tony <tony.luck@intel.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/172] blk-mq: move cpuhp callback registering out of q->sysfs_lock
Date: Tue, 17 Dec 2024 18:08:37 +0100
Message-ID: <20241217170553.007478693@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 22465bbac53c821319089016f268a2437de9b00a ]

Registering and unregistering cpuhp callback requires global cpu hotplug lock,
which is used everywhere. Meantime q->sysfs_lock is used in block layer
almost everywhere.

It is easy to trigger lockdep warning[1] by connecting the two locks.

Fix the warning by moving blk-mq's cpuhp callback registering out of
q->sysfs_lock. Add one dedicated global lock for covering registering &
unregistering hctx's cpuhp, and it is safe to do so because hctx is
guaranteed to be live if our request_queue is live.

[1] https://lore.kernel.org/lkml/Z04pz3AlvI4o0Mr8@agluck-desk3/

Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Peter Newman <peternewman@google.com>
Cc: Babu Moger <babu.moger@amd.com>
Reported-by: Luck Tony <tony.luck@intel.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20241206111611.978870-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: be26ba96421a ("block: Fix potential deadlock while freezing queue and acquiring sysfs_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 92 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b4fba7b398e5..1030875a3e95 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -43,6 +43,7 @@
 
 static DEFINE_PER_CPU(struct llist_head, blk_cpu_done);
 static DEFINE_PER_CPU(call_single_data_t, blk_cpu_csd);
+static DEFINE_MUTEX(blk_mq_cpuhp_lock);
 
 static void blk_mq_insert_request(struct request *rq, blk_insert_t flags);
 static void blk_mq_request_bypass_insert(struct request *rq,
@@ -3740,13 +3741,91 @@ static int blk_mq_hctx_notify_dead(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static void blk_mq_remove_cpuhp(struct blk_mq_hw_ctx *hctx)
+static void __blk_mq_remove_cpuhp(struct blk_mq_hw_ctx *hctx)
 {
-	if (!(hctx->flags & BLK_MQ_F_STACKING))
+	lockdep_assert_held(&blk_mq_cpuhp_lock);
+
+	if (!(hctx->flags & BLK_MQ_F_STACKING) &&
+	    !hlist_unhashed(&hctx->cpuhp_online)) {
 		cpuhp_state_remove_instance_nocalls(CPUHP_AP_BLK_MQ_ONLINE,
 						    &hctx->cpuhp_online);
-	cpuhp_state_remove_instance_nocalls(CPUHP_BLK_MQ_DEAD,
-					    &hctx->cpuhp_dead);
+		INIT_HLIST_NODE(&hctx->cpuhp_online);
+	}
+
+	if (!hlist_unhashed(&hctx->cpuhp_dead)) {
+		cpuhp_state_remove_instance_nocalls(CPUHP_BLK_MQ_DEAD,
+						    &hctx->cpuhp_dead);
+		INIT_HLIST_NODE(&hctx->cpuhp_dead);
+	}
+}
+
+static void blk_mq_remove_cpuhp(struct blk_mq_hw_ctx *hctx)
+{
+	mutex_lock(&blk_mq_cpuhp_lock);
+	__blk_mq_remove_cpuhp(hctx);
+	mutex_unlock(&blk_mq_cpuhp_lock);
+}
+
+static void __blk_mq_add_cpuhp(struct blk_mq_hw_ctx *hctx)
+{
+	lockdep_assert_held(&blk_mq_cpuhp_lock);
+
+	if (!(hctx->flags & BLK_MQ_F_STACKING) &&
+	    hlist_unhashed(&hctx->cpuhp_online))
+		cpuhp_state_add_instance_nocalls(CPUHP_AP_BLK_MQ_ONLINE,
+				&hctx->cpuhp_online);
+
+	if (hlist_unhashed(&hctx->cpuhp_dead))
+		cpuhp_state_add_instance_nocalls(CPUHP_BLK_MQ_DEAD,
+				&hctx->cpuhp_dead);
+}
+
+static void __blk_mq_remove_cpuhp_list(struct list_head *head)
+{
+	struct blk_mq_hw_ctx *hctx;
+
+	lockdep_assert_held(&blk_mq_cpuhp_lock);
+
+	list_for_each_entry(hctx, head, hctx_list)
+		__blk_mq_remove_cpuhp(hctx);
+}
+
+/*
+ * Unregister cpuhp callbacks from exited hw queues
+ *
+ * Safe to call if this `request_queue` is live
+ */
+static void blk_mq_remove_hw_queues_cpuhp(struct request_queue *q)
+{
+	LIST_HEAD(hctx_list);
+
+	spin_lock(&q->unused_hctx_lock);
+	list_splice_init(&q->unused_hctx_list, &hctx_list);
+	spin_unlock(&q->unused_hctx_lock);
+
+	mutex_lock(&blk_mq_cpuhp_lock);
+	__blk_mq_remove_cpuhp_list(&hctx_list);
+	mutex_unlock(&blk_mq_cpuhp_lock);
+
+	spin_lock(&q->unused_hctx_lock);
+	list_splice(&hctx_list, &q->unused_hctx_list);
+	spin_unlock(&q->unused_hctx_lock);
+}
+
+/*
+ * Register cpuhp callbacks from all hw queues
+ *
+ * Safe to call if this `request_queue` is live
+ */
+static void blk_mq_add_hw_queues_cpuhp(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned long i;
+
+	mutex_lock(&blk_mq_cpuhp_lock);
+	queue_for_each_hw_ctx(q, hctx, i)
+		__blk_mq_add_cpuhp(hctx);
+	mutex_unlock(&blk_mq_cpuhp_lock);
 }
 
 /*
@@ -3797,8 +3876,6 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
 
-	blk_mq_remove_cpuhp(hctx);
-
 	xa_erase(&q->hctx_table, hctx_idx);
 
 	spin_lock(&q->unused_hctx_lock);
@@ -3815,6 +3892,7 @@ static void blk_mq_exit_hw_queues(struct request_queue *q,
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (i == nr_queue)
 			break;
+		blk_mq_remove_cpuhp(hctx);
 		blk_mq_exit_hctx(q, set, hctx, i);
 	}
 }
@@ -3878,6 +3956,8 @@ blk_mq_alloc_hctx(struct request_queue *q, struct blk_mq_tag_set *set,
 	INIT_DELAYED_WORK(&hctx->run_work, blk_mq_run_work_fn);
 	spin_lock_init(&hctx->lock);
 	INIT_LIST_HEAD(&hctx->dispatch);
+	INIT_HLIST_NODE(&hctx->cpuhp_dead);
+	INIT_HLIST_NODE(&hctx->cpuhp_online);
 	hctx->queue = q;
 	hctx->flags = set->flags & ~BLK_MQ_F_TAG_QUEUE_SHARED;
 
@@ -4416,6 +4496,12 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 	xa_for_each_start(&q->hctx_table, j, hctx, j)
 		blk_mq_exit_hctx(q, set, hctx, j);
 	mutex_unlock(&q->sysfs_lock);
+
+	/* unregister cpuhp callbacks for exited hctxs */
+	blk_mq_remove_hw_queues_cpuhp(q);
+
+	/* register cpuhp for new initialized hctxs */
+	blk_mq_add_hw_queues_cpuhp(q);
 }
 
 int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
-- 
2.39.5



