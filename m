Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D16E8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F0CC433C7;
	Sun, 16 Jul 2023 20:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540793;
	bh=XUZIgryo3JdXy54WDljTwgv4sUUZze75GhEf4k8JkEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TO9Z/+VD0R1Y58FST+Ot1SBxq0fP5c3dwujKnpDHkbxZNkTwo8kx026QAe0Iemshj
	 y7BjzjCP9xYzx1H7BOGK9pHl62Xhue3MKcGJCUmixHEZtQtIyuuJxPBbi2YiEVB2Ly
	 H0cfKujwLSfs7i1MEgW7fIH+503QjKmN9s/R5hfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 462/591] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Sun, 16 Jul 2023 21:50:01 +0200
Message-ID: <20230716194935.854833912@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Waiman Long <longman@redhat.com>

[ Upstream commit 3b8cc6298724021da845f2f9fd7dd4b6829a6817 ]

For a system with many CPUs and block devices, the time to do
blkcg_rstat_flush() from cgroup_rstat_flush() can be rather long. It
can be especially problematic as interrupt is disabled during the flush.
It was reported that it might take seconds to complete in some extreme
cases leading to hard lockup messages.

As it is likely that not all the percpu blkg_iostat_set's has been
updated since the last flush, those stale blkg_iostat_set's don't need
to be flushed in this case. This patch optimizes blkcg_rstat_flush()
by keeping a lockless list of recently updated blkg_iostat_set's in a
newly added percpu blkcg->lhead pointer.

The blkg_iostat_set is added to a lockless list on the update side
in blk_cgroup_bio_start(). It is removed from the lockless list when
flushed in blkcg_rstat_flush(). Due to racing, it is possible that
blk_iostat_set's in the lockless list may have no new IO stats to be
flushed, but that is OK.

To protect against destruction of blkg, a percpu reference is gotten
when putting into the lockless list and put back when removed.

When booting up an instrumented test kernel with this patch on a
2-socket 96-thread system with cgroup v2, out of the 2051 calls to
cgroup_rstat_flush() after bootup, 1788 of the calls were exited
immediately because of empty lockless list. After an all-cpu kernel
build, the ratio became 6295424/6340513. That was more than 99%.

Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20221105005902.407297-3-longman@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ad7c3b41e86b ("blk-throttle: Fix io statistics for cgroup v1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 76 ++++++++++++++++++++++++++++++++++++++++++----
 block/blk-cgroup.h | 10 ++++++
 2 files changed, 80 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 60f366f98fa2b..2c7be256ff879 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -60,6 +60,37 @@ static struct workqueue_struct *blkcg_punt_bio_wq;
 
 #define BLKG_DESTROY_BATCH_SIZE  64
 
+/*
+ * Lockless lists for tracking IO stats update
+ *
+ * New IO stats are stored in the percpu iostat_cpu within blkcg_gq (blkg).
+ * There are multiple blkg's (one for each block device) attached to each
+ * blkcg. The rstat code keeps track of which cpu has IO stats updated,
+ * but it doesn't know which blkg has the updated stats. If there are many
+ * block devices in a system, the cost of iterating all the blkg's to flush
+ * out the IO stats can be high. To reduce such overhead, a set of percpu
+ * lockless lists (lhead) per blkcg are used to track the set of recently
+ * updated iostat_cpu's since the last flush. An iostat_cpu will be put
+ * onto the lockless list on the update side [blk_cgroup_bio_start()] if
+ * not there yet and then removed when being flushed [blkcg_rstat_flush()].
+ * References to blkg are gotten and then put back in the process to
+ * protect against blkg removal.
+ *
+ * Return: 0 if successful or -ENOMEM if allocation fails.
+ */
+static int init_blkcg_llists(struct blkcg *blkcg)
+{
+	int cpu;
+
+	blkcg->lhead = alloc_percpu_gfp(struct llist_head, GFP_KERNEL);
+	if (!blkcg->lhead)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu)
+		init_llist_head(per_cpu_ptr(blkcg->lhead, cpu));
+	return 0;
+}
+
 /**
  * blkcg_css - find the current css
  *
@@ -237,8 +268,10 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 	blkg->blkcg = blkcg;
 
 	u64_stats_init(&blkg->iostat.sync);
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
 		u64_stats_init(&per_cpu_ptr(blkg->iostat_cpu, cpu)->sync);
+		per_cpu_ptr(blkg->iostat_cpu, cpu)->blkg = blkg;
+	}
 
 	for (i = 0; i < BLKCG_MAX_POLS; i++) {
 		struct blkcg_policy *pol = blkcg_policy[i];
@@ -831,7 +864,9 @@ static void blkcg_iostat_update(struct blkcg_gq *blkg, struct blkg_iostat *cur,
 static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 {
 	struct blkcg *blkcg = css_to_blkcg(css);
-	struct blkcg_gq *blkg;
+	struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
+	struct llist_node *lnode;
+	struct blkg_iostat_set *bisc, *next_bisc;
 
 	/* Root-level stats are sourced from system-wide IO stats */
 	if (!cgroup_parent(css->cgroup))
@@ -839,12 +874,21 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	rcu_read_lock();
 
-	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
+	lnode = llist_del_all(lhead);
+	if (!lnode)
+		goto out;
+
+	/*
+	 * Iterate only the iostat_cpu's queued in the lockless list.
+	 */
+	llist_for_each_entry_safe(bisc, next_bisc, lnode, lnode) {
+		struct blkcg_gq *blkg = bisc->blkg;
 		struct blkcg_gq *parent = blkg->parent;
-		struct blkg_iostat_set *bisc = per_cpu_ptr(blkg->iostat_cpu, cpu);
 		struct blkg_iostat cur;
 		unsigned int seq;
 
+		WRITE_ONCE(bisc->lqueued, false);
+
 		/* fetch the current per-cpu values */
 		do {
 			seq = u64_stats_fetch_begin(&bisc->sync);
@@ -857,8 +901,10 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 		if (parent && parent->parent)
 			blkcg_iostat_update(parent, &blkg->iostat.cur,
 					    &blkg->iostat.last);
+		percpu_ref_put(&blkg->refcnt);
 	}
 
+out:
 	rcu_read_unlock();
 }
 
@@ -1136,6 +1182,7 @@ static void blkcg_css_free(struct cgroup_subsys_state *css)
 
 	mutex_unlock(&blkcg_pol_mutex);
 
+	free_percpu(blkcg->lhead);
 	kfree(blkcg);
 }
 
@@ -1158,6 +1205,9 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 		}
 	}
 
+	if (init_blkcg_llists(blkcg))
+		goto free_blkcg;
+
 	for (i = 0; i < BLKCG_MAX_POLS ; i++) {
 		struct blkcg_policy *pol = blkcg_policy[i];
 		struct blkcg_policy_data *cpd;
@@ -1199,7 +1249,8 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 	for (i--; i >= 0; i--)
 		if (blkcg->cpd[i])
 			blkcg_policy[i]->cpd_free_fn(blkcg->cpd[i]);
-
+	free_percpu(blkcg->lhead);
+free_blkcg:
 	if (blkcg != &blkcg_root)
 		kfree(blkcg);
 unlock:
@@ -1952,6 +2003,7 @@ static int blk_cgroup_io_type(struct bio *bio)
 
 void blk_cgroup_bio_start(struct bio *bio)
 {
+	struct blkcg *blkcg = bio->bi_blkg->blkcg;
 	int rwd = blk_cgroup_io_type(bio), cpu;
 	struct blkg_iostat_set *bis;
 	unsigned long flags;
@@ -1970,9 +2022,21 @@ void blk_cgroup_bio_start(struct bio *bio)
 	}
 	bis->cur.ios[rwd]++;
 
+	/*
+	 * If the iostat_cpu isn't in a lockless list, put it into the
+	 * list to indicate that a stat update is pending.
+	 */
+	if (!READ_ONCE(bis->lqueued)) {
+		struct llist_head *lhead = this_cpu_ptr(blkcg->lhead);
+
+		llist_add(&bis->lnode, lhead);
+		WRITE_ONCE(bis->lqueued, true);
+		percpu_ref_get(&bis->blkg->refcnt);
+	}
+
 	u64_stats_update_end_irqrestore(&bis->sync, flags);
 	if (cgroup_subsys_on_dfl(io_cgrp_subsys))
-		cgroup_rstat_updated(bio->bi_blkg->blkcg->css.cgroup, cpu);
+		cgroup_rstat_updated(blkcg->css.cgroup, cpu);
 	put_cpu();
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index aa2b286bc825f..1e94e404eaa80 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -18,6 +18,7 @@
 #include <linux/cgroup.h>
 #include <linux/kthread.h>
 #include <linux/blk-mq.h>
+#include <linux/llist.h>
 
 struct blkcg_gq;
 struct blkg_policy_data;
@@ -43,6 +44,9 @@ struct blkg_iostat {
 
 struct blkg_iostat_set {
 	struct u64_stats_sync		sync;
+	struct blkcg_gq		       *blkg;
+	struct llist_node		lnode;
+	int				lqueued;	/* queued in llist */
 	struct blkg_iostat		cur;
 	struct blkg_iostat		last;
 };
@@ -97,6 +101,12 @@ struct blkcg {
 	struct blkcg_policy_data	*cpd[BLKCG_MAX_POLS];
 
 	struct list_head		all_blkcgs_node;
+
+	/*
+	 * List of updated percpu blkg_iostat_set's since the last flush.
+	 */
+	struct llist_head __percpu	*lhead;
+
 #ifdef CONFIG_BLK_CGROUP_FC_APPID
 	char                            fc_app_id[FC_APPID_LEN];
 #endif
-- 
2.39.2



