Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07A030CDA4;
	Mon, 13 Oct 2025 15:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369144; cv=none; b=tvFdIqi4lLKrSgTp5+Qf2GKgGUgOowgd+ue89utHr9sTvWdELF1QwuNZwIQYCGwEkxqthju1r5fTmIkJe7eEpwsibnsVb+CdEGff7VZ0r/7yfbsBLViwwz+dDQ/qRWJzy02Pkl8uqVsUUd/RVOXbKYgrG2IE6sIuo4+S9E6zbaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369144; c=relaxed/simple;
	bh=910yYNPSk9i3PIMftAqyKNlUcf80tZt8+GobEQbaobk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWb/5Mcj6964XCTUzATv9w3o1SqlmEQgiZxBSSZUY5PdvaV4EKIAQ9Bfi3BjOgxH+RHTB9SN0iemGWz1lXBjl8aPyLQXQTAIp4KMm4B1CgE7MHKktMZ02Qa6LdbSiCBDoiNGXlvgZHkyJ1IUCBvwXdPX5bzaS2Txy0LZUEpOhtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smAsGHaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smAsGHaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D23C4CEE7;
	Mon, 13 Oct 2025 15:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369144;
	bh=910yYNPSk9i3PIMftAqyKNlUcf80tZt8+GobEQbaobk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smAsGHazPksNX6J6pqHucLsWttijawCDr90zS/DhVStsKTV77/00GODAR4Gugco7r
	 HBfrIEJ9p7NipCqBjob4OuT2JlfVy1h0vpi6YVsedK/mTiseGAIgZ84pTUwSYiO/3z
	 oLtsY3ZdNXoYTG6sNRK9fviX6Wfm8ioc+Lr6itV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 126/563] blk-mq: check invalid nr_requests in queue_requests_store()
Date: Mon, 13 Oct 2025 16:39:47 +0200
Message-ID: <20251013144415.859167519@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit b46d4c447db76e36906ed59ebb9b3ef8f3383322 ]

queue_requests_store() is the only caller of
blk_mq_update_nr_requests(), and blk_mq_update_nr_requests() is the
only caller of blk_mq_tag_update_depth(), however, they all have
checkings for nr_requests input by user.

Make code cleaner by moving all the checkings to the top function:

1) nr_requests > reserved tags;
2) if there is elevator, 4 <= nr_requests <= 2048;
3) if elevator is none, 4 <= nr_requests <= tag_set->queue_depth;

Meanwhile, case 2 is the only case tags can grow and -ENOMEM might be
returned.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b86433721f46 ("blk-mq: fix potential deadlock while nr_requests grown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-tag.c | 16 +---------------
 block/blk-mq.c     |  8 ++------
 block/blk-mq.h     |  2 +-
 block/blk-sysfs.c  | 13 +++++++++++++
 4 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 5cffa5668d0c3..725210f27471c 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -584,14 +584,10 @@ void blk_mq_free_tags(struct blk_mq_tags *tags)
 }
 
 int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
-			    struct blk_mq_tags **tagsptr, unsigned int tdepth,
-			    bool can_grow)
+			    struct blk_mq_tags **tagsptr, unsigned int tdepth)
 {
 	struct blk_mq_tags *tags = *tagsptr;
 
-	if (tdepth <= tags->nr_reserved_tags)
-		return -EINVAL;
-
 	/*
 	 * If we are allowed to grow beyond the original size, allocate
 	 * a new set of tags before freeing the old one.
@@ -600,16 +596,6 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 		struct blk_mq_tag_set *set = hctx->queue->tag_set;
 		struct blk_mq_tags *new;
 
-		if (!can_grow)
-			return -EINVAL;
-
-		/*
-		 * We need some sort of upper limit, set it high enough that
-		 * no valid use cases should require more.
-		 */
-		if (tdepth > MAX_SCHED_RQ)
-			return -EINVAL;
-
 		/*
 		 * Only the sbitmap needs resizing since we allocated the max
 		 * initially.
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f5e713224d819..a81ef562014d6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4932,9 +4932,6 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 	int ret = 0;
 	unsigned long i;
 
-	if (q->nr_requests == nr)
-		return 0;
-
 	blk_mq_quiesce_queue(q);
 
 	queue_for_each_hw_ctx(q, hctx, i) {
@@ -4946,10 +4943,9 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		 */
 		if (hctx->sched_tags) {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
-						      nr, true);
+						      nr);
 		} else {
-			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
-						      false);
+			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr);
 		}
 		if (ret)
 			goto out;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index affb2e14b56e3..2b3ade60c90b2 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -171,7 +171,7 @@ void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
 		unsigned int tag);
 void blk_mq_put_tags(struct blk_mq_tags *tags, int *tag_array, int nr_tags);
 int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
-		struct blk_mq_tags **tags, unsigned int depth, bool can_grow);
+		struct blk_mq_tags **tags, unsigned int depth);
 void blk_mq_tag_resize_shared_tags(struct blk_mq_tag_set *set,
 		unsigned int size);
 void blk_mq_tag_update_sched_shared_tags(struct request_queue *q);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 4a7f1a349998b..b61e956a868e7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -78,12 +78,25 @@ queue_requests_store(struct gendisk *disk, const char *page, size_t count)
 
 	memflags = blk_mq_freeze_queue(q);
 	mutex_lock(&q->elevator_lock);
+
+	if (nr == q->nr_requests)
+		goto unlock;
+
 	if (nr < BLKDEV_MIN_RQ)
 		nr = BLKDEV_MIN_RQ;
 
+	if (nr <= q->tag_set->reserved_tags ||
+	    (q->elevator && nr > MAX_SCHED_RQ) ||
+	    (!q->elevator && nr > q->tag_set->queue_depth)) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
 	err = blk_mq_update_nr_requests(disk->queue, nr);
 	if (err)
 		ret = err;
+
+unlock:
 	mutex_unlock(&q->elevator_lock);
 	blk_mq_unfreeze_queue(q, memflags);
 	return ret;
-- 
2.51.0



