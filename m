Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72393330B2B;
	Mon, 29 Dec 2025 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025141; cv=none; b=VfufGkbeKZXrCkw0t53ZeoZhdRcMPrOl7aG/7pDjM0v/6R63vODkIG9J95hBYMxSeoDUBMJbJmQAKUpv+aqAG1bSePKSvuzasO2nV1LyWcslYodH51zW1NLrajtzh+6N+u1m8A8/c5p9oFvCeI8nxojolQQe060hkNl768zP4F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025141; c=relaxed/simple;
	bh=HipSkR5idjP6tB0n27awtBOMmAWoFMZwbDQuWNJMIUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DM7X8BjN0VHYeqwI1nZMdYcRlZA7AUmHAFe7QgRlo/5+qoFVoNv2yQMaJ63SxSe9gyCCI1YQp+qWask8ENfTsFnDzxkG3sxYb3HW//qrhG3igv2UwOHmInhVl9tZs7G/wAqjaFAlNwKNj2KSAjRqcjrKDltf6eqhEpfLSs5lCGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WahPBm5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WahPBm5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F76C4CEF7;
	Mon, 29 Dec 2025 16:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025141;
	bh=HipSkR5idjP6tB0n27awtBOMmAWoFMZwbDQuWNJMIUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WahPBm5icO2CVVUD1IFYVG88+Mku3P+g4+9TS3W1ZTGvEexQdcCLIyUC6ypKqCDBq
	 iTtX1ouLcKdYyBzoeZx7yvCvKGBg3Xb06A572QENBHUYvlW89008CmP6KFmEf0V9it
	 YAAqYMMcDfx9SoSjAH9rHL/D2G6ZgotNj1UyiL90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/430] block: unify elevator tags and type xarrays into struct elv_change_ctx
Date: Mon, 29 Dec 2025 17:08:31 +0100
Message-ID: <20251229160728.380064293@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 232143b605387b372dee0ec7830f93b93df5f67d ]

Currently, the nr_hw_queues update path manages two disjoint xarrays —
one for elevator tags and another for elevator type — both used during
elevator switching. Maintaining these two parallel structures for the
same purpose adds unnecessary complexity and potential for mismatched
state.

This patch unifies both xarrays into a single structure, struct
elv_change_ctx, which holds all per-queue elevator change context. A
single xarray, named elv_tbl, now maps each queue (q->id) in a tagset
to its corresponding elv_change_ctx entry, encapsulating the elevator
tags, type and name references.

This unification simplifies the code, improves maintainability, and
clarifies ownership of per-queue elevator state.

Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 9869d3a6fed3 ("block: fix race between wbt_enable_default and IO submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c | 76 +++++++++++++++++++++++++++++++++-----------
 block/blk-mq-sched.h |  3 ++
 block/blk-mq.c       | 50 +++++++++++++++++------------
 block/blk.h          |  7 ++--
 block/elevator.c     | 31 ++++--------------
 block/elevator.h     | 15 +++++++++
 6 files changed, 115 insertions(+), 67 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index e0bed16485c3..3d9386555a50 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -427,11 +427,11 @@ void blk_mq_free_sched_tags(struct elevator_tags *et,
 	kfree(et);
 }
 
-void blk_mq_free_sched_tags_batch(struct xarray *et_table,
+void blk_mq_free_sched_tags_batch(struct xarray *elv_tbl,
 		struct blk_mq_tag_set *set)
 {
 	struct request_queue *q;
-	struct elevator_tags *et;
+	struct elv_change_ctx *ctx;
 
 	lockdep_assert_held_write(&set->update_nr_hwq_lock);
 
@@ -444,13 +444,47 @@ void blk_mq_free_sched_tags_batch(struct xarray *et_table,
 		 * concurrently.
 		 */
 		if (q->elevator) {
-			et = xa_load(et_table, q->id);
-			if (unlikely(!et))
+			ctx = xa_load(elv_tbl, q->id);
+			if (!ctx || !ctx->et) {
 				WARN_ON_ONCE(1);
-			else
-				blk_mq_free_sched_tags(et, set);
+				continue;
+			}
+			blk_mq_free_sched_tags(ctx->et, set);
+			ctx->et = NULL;
+		}
+	}
+}
+
+void blk_mq_free_sched_ctx_batch(struct xarray *elv_tbl)
+{
+	unsigned long i;
+	struct elv_change_ctx *ctx;
+
+	xa_for_each(elv_tbl, i, ctx) {
+		xa_erase(elv_tbl, i);
+		kfree(ctx);
+	}
+}
+
+int blk_mq_alloc_sched_ctx_batch(struct xarray *elv_tbl,
+		struct blk_mq_tag_set *set)
+{
+	struct request_queue *q;
+	struct elv_change_ctx *ctx;
+
+	lockdep_assert_held_write(&set->update_nr_hwq_lock);
+
+	list_for_each_entry(q, &set->tag_list, tag_set_list) {
+		ctx = kzalloc(sizeof(struct elv_change_ctx), GFP_KERNEL);
+		if (!ctx)
+			return -ENOMEM;
+
+		if (xa_insert(elv_tbl, q->id, ctx, GFP_KERNEL)) {
+			kfree(ctx);
+			return -ENOMEM;
 		}
 	}
+	return 0;
 }
 
 struct elevator_tags *blk_mq_alloc_sched_tags(struct blk_mq_tag_set *set,
@@ -498,12 +532,13 @@ struct elevator_tags *blk_mq_alloc_sched_tags(struct blk_mq_tag_set *set,
 	return NULL;
 }
 
-int blk_mq_alloc_sched_tags_batch(struct xarray *et_table,
+int blk_mq_alloc_sched_tags_batch(struct xarray *elv_tbl,
 		struct blk_mq_tag_set *set, unsigned int nr_hw_queues)
 {
+	struct elv_change_ctx *ctx;
 	struct request_queue *q;
 	struct elevator_tags *et;
-	gfp_t gfp = GFP_NOIO | __GFP_ZERO | __GFP_NOWARN | __GFP_NORETRY;
+	int ret = -ENOMEM;
 
 	lockdep_assert_held_write(&set->update_nr_hwq_lock);
 
@@ -516,26 +551,31 @@ int blk_mq_alloc_sched_tags_batch(struct xarray *et_table,
 		 * concurrently.
 		 */
 		if (q->elevator) {
-			et = blk_mq_alloc_sched_tags(set, nr_hw_queues,
+			ctx = xa_load(elv_tbl, q->id);
+			if (WARN_ON_ONCE(!ctx)) {
+				ret = -ENOENT;
+				goto out_unwind;
+			}
+
+			ctx->et = blk_mq_alloc_sched_tags(set, nr_hw_queues,
 					blk_mq_default_nr_requests(set));
-			if (!et)
+			if (!ctx->et)
 				goto out_unwind;
-			if (xa_insert(et_table, q->id, et, gfp))
-				goto out_free_tags;
+
 		}
 	}
 	return 0;
-out_free_tags:
-	blk_mq_free_sched_tags(et, set);
 out_unwind:
 	list_for_each_entry_continue_reverse(q, &set->tag_list, tag_set_list) {
 		if (q->elevator) {
-			et = xa_load(et_table, q->id);
-			if (et)
-				blk_mq_free_sched_tags(et, set);
+			ctx = xa_load(elv_tbl, q->id);
+			if (ctx && ctx->et) {
+				blk_mq_free_sched_tags(ctx->et, set);
+				ctx->et = NULL;
+			}
 		}
 	}
-	return -ENOMEM;
+	return ret;
 }
 
 /* caller must have a reference to @e, will grab another one if successful */
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 8e21a6b1415d..2fddbc91a235 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -27,6 +27,9 @@ struct elevator_tags *blk_mq_alloc_sched_tags(struct blk_mq_tag_set *set,
 		unsigned int nr_hw_queues, unsigned int nr_requests);
 int blk_mq_alloc_sched_tags_batch(struct xarray *et_table,
 		struct blk_mq_tag_set *set, unsigned int nr_hw_queues);
+int blk_mq_alloc_sched_ctx_batch(struct xarray *elv_tbl,
+		struct blk_mq_tag_set *set);
+void blk_mq_free_sched_ctx_batch(struct xarray *elv_tbl);
 void blk_mq_free_sched_tags(struct elevator_tags *et,
 		struct blk_mq_tag_set *set);
 void blk_mq_free_sched_tags_batch(struct xarray *et_table,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f901aeba8552..180d45db5624 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4996,27 +4996,28 @@ struct elevator_tags *blk_mq_update_nr_requests(struct request_queue *q,
  * Switch back to the elevator type stored in the xarray.
  */
 static void blk_mq_elv_switch_back(struct request_queue *q,
-		struct xarray *elv_tbl, struct xarray *et_tbl)
+		struct xarray *elv_tbl)
 {
-	struct elevator_type *e = xa_load(elv_tbl, q->id);
-	struct elevator_tags *t = xa_load(et_tbl, q->id);
+	struct elv_change_ctx *ctx = xa_load(elv_tbl, q->id);
+
+	if (WARN_ON_ONCE(!ctx))
+		return;
 
 	/* The elv_update_nr_hw_queues unfreezes the queue. */
-	elv_update_nr_hw_queues(q, e, t);
+	elv_update_nr_hw_queues(q, ctx);
 
 	/* Drop the reference acquired in blk_mq_elv_switch_none. */
-	if (e)
-		elevator_put(e);
+	if (ctx->type)
+		elevator_put(ctx->type);
 }
 
 /*
- * Stores elevator type in xarray and set current elevator to none. It uses
- * q->id as an index to store the elevator type into the xarray.
+ * Stores elevator name and type in ctx and set current elevator to none.
  */
 static int blk_mq_elv_switch_none(struct request_queue *q,
 		struct xarray *elv_tbl)
 {
-	int ret = 0;
+	struct elv_change_ctx *ctx;
 
 	lockdep_assert_held_write(&q->tag_set->update_nr_hwq_lock);
 
@@ -5028,10 +5029,11 @@ static int blk_mq_elv_switch_none(struct request_queue *q,
 	 * can't run concurrently.
 	 */
 	if (q->elevator) {
+		ctx = xa_load(elv_tbl, q->id);
+		if (WARN_ON_ONCE(!ctx))
+			return -ENOENT;
 
-		ret = xa_insert(elv_tbl, q->id, q->elevator->type, GFP_KERNEL);
-		if (WARN_ON_ONCE(ret))
-			return ret;
+		ctx->name = q->elevator->type->elevator_name;
 
 		/*
 		 * Before we switch elevator to 'none', take a reference to
@@ -5042,9 +5044,14 @@ static int blk_mq_elv_switch_none(struct request_queue *q,
 		 */
 		__elevator_get(q->elevator->type);
 
+		/*
+		 * Store elevator type so that we can release the reference
+		 * taken above later.
+		 */
+		ctx->type = q->elevator->type;
 		elevator_set_none(q);
 	}
-	return ret;
+	return 0;
 }
 
 static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
@@ -5054,7 +5061,7 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 	int prev_nr_hw_queues = set->nr_hw_queues;
 	unsigned int memflags;
 	int i;
-	struct xarray elv_tbl, et_tbl;
+	struct xarray elv_tbl;
 	bool queues_frozen = false;
 
 	lockdep_assert_held(&set->tag_list_lock);
@@ -5068,11 +5075,12 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 
 	memflags = memalloc_noio_save();
 
-	xa_init(&et_tbl);
-	if (blk_mq_alloc_sched_tags_batch(&et_tbl, set, nr_hw_queues) < 0)
-		goto out_memalloc_restore;
-
 	xa_init(&elv_tbl);
+	if (blk_mq_alloc_sched_ctx_batch(&elv_tbl, set) < 0)
+		goto out_free_ctx;
+
+	if (blk_mq_alloc_sched_tags_batch(&elv_tbl, set, nr_hw_queues) < 0)
+		goto out_free_ctx;
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
 		blk_mq_debugfs_unregister_hctxs(q);
@@ -5118,7 +5126,7 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 		/* switch_back expects queue to be frozen */
 		if (!queues_frozen)
 			blk_mq_freeze_queue_nomemsave(q);
-		blk_mq_elv_switch_back(q, &elv_tbl, &et_tbl);
+		blk_mq_elv_switch_back(q, &elv_tbl);
 	}
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
@@ -5129,9 +5137,9 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 		blk_mq_add_hw_queues_cpuhp(q);
 	}
 
+out_free_ctx:
+	blk_mq_free_sched_ctx_batch(&elv_tbl);
 	xa_destroy(&elv_tbl);
-	xa_destroy(&et_tbl);
-out_memalloc_restore:
 	memalloc_noio_restore(memflags);
 
 	/* Free the excess tags when nr_hw_queues shrink. */
diff --git a/block/blk.h b/block/blk.h
index 170794632135..a7992680f9e1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -11,8 +11,7 @@
 #include <xen/xen.h>
 #include "blk-crypto-internal.h"
 
-struct elevator_type;
-struct elevator_tags;
+struct elv_change_ctx;
 
 /*
  * Default upper limit for the software max_sectors limit used for regular I/Os.
@@ -333,8 +332,8 @@ bool blk_bio_list_merge(struct request_queue *q, struct list_head *list,
 
 bool blk_insert_flush(struct request *rq);
 
-void elv_update_nr_hw_queues(struct request_queue *q, struct elevator_type *e,
-		struct elevator_tags *t);
+void elv_update_nr_hw_queues(struct request_queue *q,
+		struct elv_change_ctx *ctx);
 void elevator_set_default(struct request_queue *q);
 void elevator_set_none(struct request_queue *q);
 
diff --git a/block/elevator.c b/block/elevator.c
index e2ebfbf107b3..cd7bdff205c8 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -45,19 +45,6 @@
 #include "blk-wbt.h"
 #include "blk-cgroup.h"
 
-/* Holding context data for changing elevator */
-struct elv_change_ctx {
-	const char *name;
-	bool no_uevent;
-
-	/* for unregistering old elevator */
-	struct elevator_queue *old;
-	/* for registering new elevator */
-	struct elevator_queue *new;
-	/* holds sched tags data */
-	struct elevator_tags *et;
-};
-
 static DEFINE_SPINLOCK(elv_list_lock);
 static LIST_HEAD(elv_list);
 
@@ -706,32 +693,28 @@ static int elevator_change(struct request_queue *q, struct elv_change_ctx *ctx)
  * The I/O scheduler depends on the number of hardware queues, this forces a
  * reattachment when nr_hw_queues changes.
  */
-void elv_update_nr_hw_queues(struct request_queue *q, struct elevator_type *e,
-		struct elevator_tags *t)
+void elv_update_nr_hw_queues(struct request_queue *q,
+		struct elv_change_ctx *ctx)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
-	struct elv_change_ctx ctx = {};
 	int ret = -ENODEV;
 
 	WARN_ON_ONCE(q->mq_freeze_depth == 0);
 
-	if (e && !blk_queue_dying(q) && blk_queue_registered(q)) {
-		ctx.name = e->elevator_name;
-		ctx.et = t;
-
+	if (ctx->type && !blk_queue_dying(q) && blk_queue_registered(q)) {
 		mutex_lock(&q->elevator_lock);
 		/* force to reattach elevator after nr_hw_queue is updated */
-		ret = elevator_switch(q, &ctx);
+		ret = elevator_switch(q, ctx);
 		mutex_unlock(&q->elevator_lock);
 	}
 	blk_mq_unfreeze_queue_nomemrestore(q);
 	if (!ret)
-		WARN_ON_ONCE(elevator_change_done(q, &ctx));
+		WARN_ON_ONCE(elevator_change_done(q, ctx));
 	/*
 	 * Free sched tags if it's allocated but we couldn't switch elevator.
 	 */
-	if (t && !ctx.new)
-		blk_mq_free_sched_tags(t, set);
+	if (ctx->et && !ctx->new)
+		blk_mq_free_sched_tags(ctx->et, set);
 }
 
 /*
diff --git a/block/elevator.h b/block/elevator.h
index c4d20155065e..bad43182361e 100644
--- a/block/elevator.h
+++ b/block/elevator.h
@@ -32,6 +32,21 @@ struct elevator_tags {
 	struct blk_mq_tags *tags[];
 };
 
+/* Holding context data for changing elevator */
+struct elv_change_ctx {
+	const char *name;
+	bool no_uevent;
+
+	/* for unregistering old elevator */
+	struct elevator_queue *old;
+	/* for registering new elevator */
+	struct elevator_queue *new;
+	/* store elevator type */
+	struct elevator_type *type;
+	/* holds sched tags data */
+	struct elevator_tags *et;
+};
+
 struct elevator_mq_ops {
 	int (*init_sched)(struct request_queue *, struct elevator_queue *);
 	void (*exit_sched)(struct elevator_queue *);
-- 
2.51.0



