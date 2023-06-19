Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C07E3C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF58FC433C8;
	Mon, 19 Jun 2023 10:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171230;
	bh=eqUhZ8kU7v90zdtnUx/g8qxvfoBvtQM+b8PJaSn/kls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OMS9TGP+E3z9YWVnpJacLrZvL5LerGkLbPaOqm5iwryzH4dMbXfLZxH+OpZmcy+9
	 mVyxTGvw7yowcD8xNDphU+hfENoGKxqKqE0fddiFkaVmhTwEQfuOeg53+1NCW3WfTP
	 YBuvnP1O2IeO40SpT7CLEyi/zsHDbZK7k929GD4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Shin <jaeshin@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Waiman Long <longman@redhat.com>,
	mkoutny@suse.com,
	Yosry Ahmed <yosryahmed@google.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.3 187/187] blk-cgroup: Flush stats before releasing blkcg_gq
Date: Mon, 19 Jun 2023 12:30:05 +0200
Message-ID: <20230619102206.774579013@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

commit 20cb1c2fb7568a6054c55defe044311397e01ddb upstream.

As noted by Michal, the blkg_iostat_set's in the lockless list hold
reference to blkg's to protect against their removal. Those blkg's
hold reference to blkcg. When a cgroup is being destroyed,
cgroup_rstat_flush() is only called at css_release_work_fn() which
is called when the blkcg reference count reaches 0. This circular
dependency will prevent blkcg and some blkgs from being freed after
they are made offline.

It is less a problem if the cgroup to be destroyed also has other
controllers like memory that will call cgroup_rstat_flush() which will
clean up the reference count. If block is the only controller that uses
rstat, these offline blkcg and blkgs may never be freed leaking more
and more memory over time.

To prevent this potential memory leak:

- flush blkcg per-cpu stats list in __blkg_release(), when no new stat
can be added

- add global blkg_stat_lock for covering concurrent parent blkg stat
update

- don't grab bio->bi_blkg reference when adding the stats into blkcg's
per-cpu stat list since all stats are guaranteed to be consumed before
releasing blkg instance, and grabbing blkg reference for stats was the
most fragile part of original patch

Based on Waiman's patch:

https://lore.kernel.org/linux-block/20221215033132.230023-3-longman@redhat.com/

Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
Cc: stable@vger.kernel.org
Reported-by: Jay Shin <jaeshin@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: mkoutny@suse.com
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230609234249.1412858-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c |   40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -35,6 +35,8 @@
 #include "blk-throttle.h"
 #include "blk-rq-qos.h"
 
+static void __blkcg_rstat_flush(struct blkcg *blkcg, int cpu);
+
 /*
  * blkcg_pol_mutex protects blkcg_policy[] and policy [de]activation.
  * blkcg_pol_register_mutex nests outside of it and synchronizes entire
@@ -58,6 +60,8 @@ static LIST_HEAD(all_blkcgs);		/* protec
 bool blkcg_debug_stats = false;
 static struct workqueue_struct *blkcg_punt_bio_wq;
 
+static DEFINE_RAW_SPINLOCK(blkg_stat_lock);
+
 #define BLKG_DESTROY_BATCH_SIZE  64
 
 /*
@@ -165,8 +169,18 @@ static void blkg_free(struct blkcg_gq *b
 static void __blkg_release(struct rcu_head *rcu)
 {
 	struct blkcg_gq *blkg = container_of(rcu, struct blkcg_gq, rcu_head);
+	struct blkcg *blkcg = blkg->blkcg;
+	int cpu;
 
 	WARN_ON(!bio_list_empty(&blkg->async_bios));
+	/*
+	 * Flush all the non-empty percpu lockless lists before releasing
+	 * us, given these stat belongs to us.
+	 *
+	 * blkg_stat_lock is for serializing blkg stat update
+	 */
+	for_each_possible_cpu(cpu)
+		__blkcg_rstat_flush(blkcg, cpu);
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
@@ -888,17 +902,12 @@ static void blkcg_iostat_update(struct b
 	u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
 }
 
-static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
+static void __blkcg_rstat_flush(struct blkcg *blkcg, int cpu)
 {
-	struct blkcg *blkcg = css_to_blkcg(css);
 	struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
 	struct llist_node *lnode;
 	struct blkg_iostat_set *bisc, *next_bisc;
 
-	/* Root-level stats are sourced from system-wide IO stats */
-	if (!cgroup_parent(css->cgroup))
-		return;
-
 	rcu_read_lock();
 
 	lnode = llist_del_all(lhead);
@@ -906,6 +915,14 @@ static void blkcg_rstat_flush(struct cgr
 		goto out;
 
 	/*
+	 * For covering concurrent parent blkg update from blkg_release().
+	 *
+	 * When flushing from cgroup, cgroup_rstat_lock is always held, so
+	 * this lock won't cause contention most of time.
+	 */
+	raw_spin_lock(&blkg_stat_lock);
+
+	/*
 	 * Iterate only the iostat_cpu's queued in the lockless list.
 	 */
 	llist_for_each_entry_safe(bisc, next_bisc, lnode, lnode) {
@@ -928,13 +945,19 @@ static void blkcg_rstat_flush(struct cgr
 		if (parent && parent->parent)
 			blkcg_iostat_update(parent, &blkg->iostat.cur,
 					    &blkg->iostat.last);
-		percpu_ref_put(&blkg->refcnt);
 	}
-
+	raw_spin_unlock(&blkg_stat_lock);
 out:
 	rcu_read_unlock();
 }
 
+static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
+{
+	/* Root-level stats are sourced from system-wide IO stats */
+	if (cgroup_parent(css->cgroup))
+		__blkcg_rstat_flush(css_to_blkcg(css), cpu);
+}
+
 /*
  * We source root cgroup stats from the system-wide stats to avoid
  * tracking the same information twice and incurring overhead when no
@@ -2063,7 +2086,6 @@ void blk_cgroup_bio_start(struct bio *bi
 
 		llist_add(&bis->lnode, lhead);
 		WRITE_ONCE(bis->lqueued, true);
-		percpu_ref_get(&bis->blkg->refcnt);
 	}
 
 	u64_stats_update_end_irqrestore(&bis->sync, flags);


