Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C460313559;
	Mon, 13 Oct 2025 15:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369204; cv=none; b=Io9wy6MBSEhe3I0lRMF0zJudEpu0OoK/3vAVC3MNxl9qTuFuYdo5jY/vPKho2J4CnBkmmJSHqWiLsSoup7TeZZh3zu5/sq2WFxBEtk798wy0fTbXJ7GXpgZI9OV31bdhUx5NyKX3xfYG7IqnSUy1xqKBt4HhrY+S/dcTvTDmAn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369204; c=relaxed/simple;
	bh=NfnZwPpP4GB+Z//8w6U8MefPQVoJ/ZijoIrMHVblQZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toHSpxmDnZEHu3ppXy/qUgF2BNytzsXtHX8hWGi0IQbV218bSXJK1ZB5sjaU7AnfpmCBaCxpf/HpozPalVxRwSQgF2XEAAdeOBf4mfURHazDahRi2llHAuh00ifU9RQE4CpW5p9hdJ8gVypKLC9u8ek2Scz2Xg4oHoTq/4MIzQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WO8tebLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WO8tebLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9BAC116B1;
	Mon, 13 Oct 2025 15:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369204;
	bh=NfnZwPpP4GB+Z//8w6U8MefPQVoJ/ZijoIrMHVblQZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WO8tebLVA3FprdyQoOwNE+C1+XVMULjrcmJvlBfRHvrtvXO0NeGjtoY/NimZMBQnx
	 Q4pPpsO/WRgwq8zkt+Rcuds/tfWkxOP+lpqxI47yRG783njPSdW4+NvMnMiE+QJC6q
	 b1GhTPSpoEGoC4A1sVkqCO/X0OtfbX/dcXyRVNWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 131/563] blk-mq: fix potential deadlock while nr_requests grown
Date: Mon, 13 Oct 2025 16:39:52 +0200
Message-ID: <20251013144416.039595640@linuxfoundation.org>
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

[ Upstream commit b86433721f46d934940528f28d49c1dedb690df1 ]

Allocate and free sched_tags while queue is freezed can deadlock[1],
this is a long term problem, hence allocate memory before freezing
queue and free memory after queue is unfreezed.

[1] https://lore.kernel.org/all/0659ea8d-a463-47c8-9180-43c719e106eb@linux.ibm.com/
Fixes: e3a2b3f931f5 ("blk-mq: allow changing of queue depth through sysfs")

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c    | 22 +++++++++-------------
 block/blk-mq.h    |  5 ++++-
 block/blk-sysfs.c | 29 +++++++++++++++++++++--------
 3 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1bafbdced7bd5..f8a8a23b90402 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4925,11 +4925,13 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 }
 EXPORT_SYMBOL(blk_mq_free_tag_set);
 
-int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
+struct elevator_tags *blk_mq_update_nr_requests(struct request_queue *q,
+						struct elevator_tags *et,
+						unsigned int nr)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
+	struct elevator_tags *old_et = NULL;
 	struct blk_mq_hw_ctx *hctx;
-	int ret = 0;
 	unsigned long i;
 
 	blk_mq_quiesce_queue(q);
@@ -4964,24 +4966,18 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		}
 	} else {
 		/* Non-shared sched tags, and tags grow */
-		queue_for_each_hw_ctx(q, hctx, i) {
-			if (!hctx->sched_tags)
-				continue;
-			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
-						      nr);
-			if (ret)
-				goto out;
-		}
+		queue_for_each_hw_ctx(q, hctx, i)
+			hctx->sched_tags = et->tags[i];
+		old_et =  q->elevator->et;
+		q->elevator->et = et;
 	}
 
 	q->nr_requests = nr;
 	if (q->elevator && q->elevator->type->ops.depth_updated)
 		q->elevator->type->ops.depth_updated(q);
 
-out:
 	blk_mq_unquiesce_queue(q);
-
-	return ret;
+	return old_et;
 }
 
 /*
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 731f4578d9a84..6c9d03625ba12 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -6,6 +6,7 @@
 #include "blk-stat.h"
 
 struct blk_mq_tag_set;
+struct elevator_tags;
 
 struct blk_mq_ctxs {
 	struct kobject kobj;
@@ -45,7 +46,9 @@ void blk_mq_submit_bio(struct bio *bio);
 int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, struct io_comp_batch *iob,
 		unsigned int flags);
 void blk_mq_exit_queue(struct request_queue *q);
-int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr);
+struct elevator_tags *blk_mq_update_nr_requests(struct request_queue *q,
+						struct elevator_tags *tags,
+						unsigned int nr);
 void blk_mq_wake_waiters(struct request_queue *q);
 bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *,
 			     bool);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 163264e4ec629..9b03261b3e042 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -64,11 +64,12 @@ static ssize_t queue_requests_show(struct gendisk *disk, char *page)
 static ssize_t
 queue_requests_store(struct gendisk *disk, const char *page, size_t count)
 {
-	unsigned long nr;
-	int ret, err;
-	unsigned int memflags;
 	struct request_queue *q = disk->queue;
 	struct blk_mq_tag_set *set = q->tag_set;
+	struct elevator_tags *et = NULL;
+	unsigned int memflags;
+	unsigned long nr;
+	int ret;
 
 	if (!queue_is_mq(q))
 		return -EINVAL;
@@ -102,16 +103,28 @@ queue_requests_store(struct gendisk *disk, const char *page, size_t count)
 		goto unlock;
 	}
 
+	if (!blk_mq_is_shared_tags(set->flags) && q->elevator &&
+	    nr > q->elevator->et->nr_requests) {
+		/*
+		 * Tags will grow, allocate memory before freezing queue to
+		 * prevent deadlock.
+		 */
+		et = blk_mq_alloc_sched_tags(set, q->nr_hw_queues, nr);
+		if (!et) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
+	}
+
 	memflags = blk_mq_freeze_queue(q);
 	mutex_lock(&q->elevator_lock);
-
-	err = blk_mq_update_nr_requests(disk->queue, nr);
-	if (err)
-		ret = err;
-
+	et = blk_mq_update_nr_requests(q, et, nr);
 	mutex_unlock(&q->elevator_lock);
 	blk_mq_unfreeze_queue(q, memflags);
 
+	if (et)
+		blk_mq_free_sched_tags(et, set);
+
 unlock:
 	up_write(&set->update_nr_hwq_lock);
 	return ret;
-- 
2.51.0



