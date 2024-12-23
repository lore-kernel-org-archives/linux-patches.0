Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58206186E58;
	Mon, 23 Dec 2024 16:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969851; cv=none; b=nR7Aj3XotQkoG3XulPrUryF0ghwvgpHRus2eKXf34GtGYoYolLvMy0zyw3f0wncUBxcl+QY3tVxdDziz3k36vxUdtIw0uqP2WV5a+SlZEED4v82rc5Q7ItPQ2xCmc04EPOW6SdVBcQg89wPBodorS+PG0Wap8ZNDpqtfWVMD0OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969851; c=relaxed/simple;
	bh=idORojhTFVd2UldjYHzwxsddX+GLMvDJtl5Mo4kvMpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4iREXdJJQMSMydSZClqWYLRWTnjxhhAe2O3lWTQptvxXKqRs5qjJzf7EFqY/iTbQtbIeulmCtPKvdTadl+/7Nkz7AbbW+0wcqtZ0Jm+7dQP6feQabNxLCxRs6FKU5tiTOSyWwp2BcuPq6L17LWkNOLGihAAGxjkYevEa1OKPHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7hoYYMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7hoYYMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AF0C4CED3;
	Mon, 23 Dec 2024 16:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969851;
	bh=idORojhTFVd2UldjYHzwxsddX+GLMvDJtl5Mo4kvMpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7hoYYMNupX9U2EpqgfU7kHVLI4kzXsabACxGPYclxFTvaauJ6qO6YXzyBuQpw0WQ
	 zT9cA2HcLSav+dofPRg2SEx/kJ3nscrRiOZhlnaWz2iGtc7rVfmrAelhRuhFjlEjPY
	 s77LcYHlrXx/Pc3HmeXs4p4sC61K4wJSxT7b3Kkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 072/160] block: Revert "block: Fix potential deadlock while freezing queue and acquiring sysfs_lock"
Date: Mon, 23 Dec 2024 16:58:03 +0100
Message-ID: <20241223155411.468118682@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

commit 224749be6c23efe7fb8a030854f4fc5d1dd813b3 upstream.

This reverts commit be26ba96421ab0a8fa2055ccf7db7832a13c44d2.

Commit be26ba96421a ("block: Fix potential deadlock while freezing queue and
acquiring sysfs_loc") actually reverts commit 22465bbac53c ("blk-mq: move cpuhp
callback registering out of q->sysfs_lock"), and causes the original resctrl
lockdep warning.

So revert it and we need to fix the issue in another way.

Cc: Nilay Shroff <nilay@linux.ibm.com>
Fixes: be26ba96421a ("block: Fix potential deadlock while freezing queue and acquiring sysfs_loc")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241218101617.3275704-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq-sysfs.c |   16 ++++++++++------
 block/blk-mq.c       |   29 +++++++++++------------------
 block/blk-sysfs.c    |    4 ++--
 3 files changed, 23 insertions(+), 26 deletions(-)

--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -275,13 +275,15 @@ void blk_mq_sysfs_unregister_hctxs(struc
 	struct blk_mq_hw_ctx *hctx;
 	unsigned long i;
 
-	lockdep_assert_held(&q->sysfs_dir_lock);
-
+	mutex_lock(&q->sysfs_dir_lock);
 	if (!q->mq_sysfs_init_done)
-		return;
+		goto unlock;
 
 	queue_for_each_hw_ctx(q, hctx, i)
 		blk_mq_unregister_hctx(hctx);
+
+unlock:
+	mutex_unlock(&q->sysfs_dir_lock);
 }
 
 int blk_mq_sysfs_register_hctxs(struct request_queue *q)
@@ -290,10 +292,9 @@ int blk_mq_sysfs_register_hctxs(struct r
 	unsigned long i;
 	int ret = 0;
 
-	lockdep_assert_held(&q->sysfs_dir_lock);
-
+	mutex_lock(&q->sysfs_dir_lock);
 	if (!q->mq_sysfs_init_done)
-		return ret;
+		goto unlock;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		ret = blk_mq_register_hctx(hctx);
@@ -301,5 +302,8 @@ int blk_mq_sysfs_register_hctxs(struct r
 			break;
 	}
 
+unlock:
+	mutex_unlock(&q->sysfs_dir_lock);
+
 	return ret;
 }
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4462,8 +4462,7 @@ static void blk_mq_realloc_hw_ctxs(struc
 	unsigned long i, j;
 
 	/* protect against switching io scheduler  */
-	lockdep_assert_held(&q->sysfs_lock);
-
+	mutex_lock(&q->sysfs_lock);
 	for (i = 0; i < set->nr_hw_queues; i++) {
 		int old_node;
 		int node = blk_mq_get_hctx_node(set, i);
@@ -4496,6 +4495,7 @@ static void blk_mq_realloc_hw_ctxs(struc
 
 	xa_for_each_start(&q->hctx_table, j, hctx, j)
 		blk_mq_exit_hctx(q, set, hctx, j);
+	mutex_unlock(&q->sysfs_lock);
 
 	/* unregister cpuhp callbacks for exited hctxs */
 	blk_mq_remove_hw_queues_cpuhp(q);
@@ -4527,14 +4527,10 @@ int blk_mq_init_allocated_queue(struct b
 
 	xa_init(&q->hctx_table);
 
-	mutex_lock(&q->sysfs_lock);
-
 	blk_mq_realloc_hw_ctxs(set, q);
 	if (!q->nr_hw_queues)
 		goto err_hctxs;
 
-	mutex_unlock(&q->sysfs_lock);
-
 	INIT_WORK(&q->timeout_work, blk_mq_timeout_work);
 	blk_queue_rq_timeout(q, set->timeout ? set->timeout : 30 * HZ);
 
@@ -4553,7 +4549,6 @@ int blk_mq_init_allocated_queue(struct b
 	return 0;
 
 err_hctxs:
-	mutex_unlock(&q->sysfs_lock);
 	blk_mq_release(q);
 err_exit:
 	q->mq_ops = NULL;
@@ -4934,12 +4929,12 @@ static bool blk_mq_elv_switch_none(struc
 		return false;
 
 	/* q->elevator needs protection from ->sysfs_lock */
-	lockdep_assert_held(&q->sysfs_lock);
+	mutex_lock(&q->sysfs_lock);
 
 	/* the check has to be done with holding sysfs_lock */
 	if (!q->elevator) {
 		kfree(qe);
-		goto out;
+		goto unlock;
 	}
 
 	INIT_LIST_HEAD(&qe->node);
@@ -4949,7 +4944,9 @@ static bool blk_mq_elv_switch_none(struc
 	__elevator_get(qe->type);
 	list_add(&qe->node, head);
 	elevator_disable(q);
-out:
+unlock:
+	mutex_unlock(&q->sysfs_lock);
+
 	return true;
 }
 
@@ -4978,9 +4975,11 @@ static void blk_mq_elv_switch_back(struc
 	list_del(&qe->node);
 	kfree(qe);
 
+	mutex_lock(&q->sysfs_lock);
 	elevator_switch(q, t);
 	/* drop the reference acquired in blk_mq_elv_switch_none */
 	elevator_put(t);
+	mutex_unlock(&q->sysfs_lock);
 }
 
 static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
@@ -5000,11 +4999,8 @@ static void __blk_mq_update_nr_hw_queues
 	if (set->nr_maps == 1 && nr_hw_queues == set->nr_hw_queues)
 		return;
 
-	list_for_each_entry(q, &set->tag_list, tag_set_list) {
-		mutex_lock(&q->sysfs_dir_lock);
-		mutex_lock(&q->sysfs_lock);
+	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_freeze_queue(q);
-	}
 	/*
 	 * Switch IO scheduler to 'none', cleaning up the data associated
 	 * with the previous scheduler. We will switch back once we are done
@@ -5060,11 +5056,8 @@ switch_back:
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_elv_switch_back(&head, q);
 
-	list_for_each_entry(q, &set->tag_list, tag_set_list) {
+	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_unfreeze_queue(q);
-		mutex_unlock(&q->sysfs_lock);
-		mutex_unlock(&q->sysfs_dir_lock);
-	}
 
 	/* Free the excess tags when nr_hw_queues shrink. */
 	for (i = set->nr_hw_queues; i < prev_nr_hw_queues; i++)
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -690,11 +690,11 @@ queue_attr_store(struct kobject *kobj, s
 			return res;
 	}
 
-	mutex_lock(&q->sysfs_lock);
 	blk_mq_freeze_queue(q);
+	mutex_lock(&q->sysfs_lock);
 	res = entry->store(disk, page, length);
-	blk_mq_unfreeze_queue(q);
 	mutex_unlock(&q->sysfs_lock);
+	blk_mq_unfreeze_queue(q);
 	return res;
 }
 


