Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3854126C18;
	Wed,  5 Feb 2025 13:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763450; cv=none; b=HQ4fVKiens4Do2TEFe+njRjPfM2TCPp9JKHe6k8jcSDdaF+PgsRsn1O1RpqBxlHMtfoOJenCLN3zYfUz8wF/sKbSCbdo37c1hgNQAXm+CdbV1uVx5wOkX7vcf8cRWUUESD257r+4ujtCD2RO7K8JXLB2dIO4Idu3Ij6bdMQFyFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763450; c=relaxed/simple;
	bh=ip8XZ0fXQruBclAqM/LuP/IiF/XRPSlr4PhAoP3Lk7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRcN21I4bNUm4LMgCLxyVo0CqXqPt72utmI1KX30cCRmLW1/5G+VeXD3NsNc3wVGPcbNsxjKIgHXqdQnPOucPrK2wD5wNiGzHVs/+8o/wmhTrBQ6SMUN+kc0Hi0JWvlcew61g5NFPoDs+O0JJhTJIrcWVZY5eDX2rF4aTZzo3ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgDG0vrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgDG0vrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E026AC4CED1;
	Wed,  5 Feb 2025 13:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763449;
	bh=ip8XZ0fXQruBclAqM/LuP/IiF/XRPSlr4PhAoP3Lk7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgDG0vrjtB+AF2lOySNTQtdiDYE14aFZNeOaChpvjAxZfvHan+3KwsPLUeyPlkot9
	 NL1FmO7G1UwB0z/hiCiFekbxVJ7pC5xfzcqiHIvjm0kFy+kHJQOoYlFm1dFXX3rq9O
	 yS3UfJOCM2Yio55/OmXhkBYr6QYF4wd4++3NWxlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/590] block: dont update BLK_FEAT_POLL in __blk_mq_update_nr_hw_queues
Date: Wed,  5 Feb 2025 14:36:10 +0100
Message-ID: <20250205134455.823743905@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d432c817c21a48c3baaa0d28e4d3e74b6aa238a0 ]

When __blk_mq_update_nr_hw_queues changes the number of tag sets, it
might have to disable poll queues.  Currently it does so by adjusting
the BLK_FEAT_POLL, which is a bit against the intent of features that
describe hardware / driver capabilities, but more importantly causes
nasty lock order problems with the broadly held freeze when updating the
number of hardware queues and the limits lock.  Fix this by leaving
BLK_FEAT_POLL alone, and instead check for the number of poll queues in
the bio submission and poll handlers.  While this adds extra work to the
fast path, the variables are in cache lines used by these operations
anyway, so it should be cheap enough.

Fixes: 8023e144f9d6 ("block: move the poll flag to queue_limits")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://lore.kernel.org/r/20250110054726.1499538-5-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c  |  7 +++----
 block/blk-mq.c    | 26 +++++---------------------
 block/blk-mq.h    |  6 ++++++
 block/blk-sysfs.c |  9 ++++++++-
 4 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 487e8cafccc55..42023addf9cda 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -951,14 +951,13 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 	 */
 	if (!percpu_ref_tryget(&q->q_usage_counter))
 		return 0;
-	if (!(q->limits.features & BLK_FEAT_POLL)) {
-		ret = 0;
-	} else if (queue_is_mq(q)) {
+	if (queue_is_mq(q)) {
 		ret = blk_mq_poll(q, cookie, iob, flags);
 	} else {
 		struct gendisk *disk = q->disk;
 
-		if (disk && disk->fops->poll_bio)
+		if ((q->limits.features & BLK_FEAT_POLL) && disk &&
+		    disk->fops->poll_bio)
 			ret = disk->fops->poll_bio(bio, iob, flags);
 	}
 	blk_queue_exit(q);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 784d41eb0abba..662e52ab06467 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3101,8 +3101,7 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
 	}
 
-	if ((bio->bi_opf & REQ_POLLED) &&
-	    !(q->limits.features & BLK_FEAT_POLL)) {
+	if ((bio->bi_opf & REQ_POLLED) && !blk_mq_can_poll(q)) {
 		bio->bi_status = BLK_STS_NOTSUPP;
 		bio_endio(bio);
 		goto queue_exit;
@@ -4333,12 +4332,6 @@ void blk_mq_release(struct request_queue *q)
 	blk_mq_sysfs_deinit(q);
 }
 
-static bool blk_mq_can_poll(struct blk_mq_tag_set *set)
-{
-	return set->nr_maps > HCTX_TYPE_POLL &&
-		set->map[HCTX_TYPE_POLL].nr_queues;
-}
-
 struct request_queue *blk_mq_alloc_queue(struct blk_mq_tag_set *set,
 		struct queue_limits *lim, void *queuedata)
 {
@@ -4349,7 +4342,7 @@ struct request_queue *blk_mq_alloc_queue(struct blk_mq_tag_set *set,
 	if (!lim)
 		lim = &default_lim;
 	lim->features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT;
-	if (blk_mq_can_poll(set))
+	if (set->nr_maps > HCTX_TYPE_POLL)
 		lim->features |= BLK_FEAT_POLL;
 
 	q = blk_alloc_queue(lim, set->numa_node);
@@ -5037,8 +5030,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 fallback:
 	blk_mq_update_queue_map(set);
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
-		struct queue_limits lim;
-
 		blk_mq_realloc_hw_ctxs(set, q);
 
 		if (q->nr_hw_queues != set->nr_hw_queues) {
@@ -5052,13 +5043,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 			set->nr_hw_queues = prev_nr_hw_queues;
 			goto fallback;
 		}
-		lim = queue_limits_start_update(q);
-		if (blk_mq_can_poll(set))
-			lim.features |= BLK_FEAT_POLL;
-		else
-			lim.features &= ~BLK_FEAT_POLL;
-		if (queue_limits_commit_update(q, &lim) < 0)
-			pr_warn("updating the poll flag failed\n");
 		blk_mq_map_swqueue(q);
 	}
 
@@ -5118,9 +5102,9 @@ static int blk_hctx_poll(struct request_queue *q, struct blk_mq_hw_ctx *hctx,
 int blk_mq_poll(struct request_queue *q, blk_qc_t cookie,
 		struct io_comp_batch *iob, unsigned int flags)
 {
-	struct blk_mq_hw_ctx *hctx = xa_load(&q->hctx_table, cookie);
-
-	return blk_hctx_poll(q, hctx, iob, flags);
+	if (!blk_mq_can_poll(q))
+		return 0;
+	return blk_hctx_poll(q, xa_load(&q->hctx_table, cookie), iob, flags);
 }
 
 int blk_rq_poll(struct request *rq, struct io_comp_batch *iob,
diff --git a/block/blk-mq.h b/block/blk-mq.h
index f4ac1af77a267..364c0415293cf 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -451,4 +451,10 @@ do {								\
 #define blk_mq_run_dispatch_ops(q, dispatch_ops)		\
 	__blk_mq_run_dispatch_ops(q, true, dispatch_ops)	\
 
+static inline bool blk_mq_can_poll(struct request_queue *q)
+{
+	return (q->limits.features & BLK_FEAT_POLL) &&
+		q->tag_set->map[HCTX_TYPE_POLL].nr_queues;
+}
+
 #endif
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 207577145c54f..692b27266220f 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -256,10 +256,17 @@ static ssize_t queue_##_name##_show(struct gendisk *disk, char *page)	\
 		!!(disk->queue->limits.features & _feature));		\
 }
 
-QUEUE_SYSFS_FEATURE_SHOW(poll, BLK_FEAT_POLL);
 QUEUE_SYSFS_FEATURE_SHOW(fua, BLK_FEAT_FUA);
 QUEUE_SYSFS_FEATURE_SHOW(dax, BLK_FEAT_DAX);
 
+static ssize_t queue_poll_show(struct gendisk *disk, char *page)
+{
+	if (queue_is_mq(disk->queue))
+		return sysfs_emit(page, "%u\n", blk_mq_can_poll(disk->queue));
+	return sysfs_emit(page, "%u\n",
+		!!(disk->queue->limits.features & BLK_FEAT_POLL));
+}
+
 static ssize_t queue_zoned_show(struct gendisk *disk, char *page)
 {
 	if (blk_queue_is_zoned(disk->queue))
-- 
2.39.5



