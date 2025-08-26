Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4F2321456;
	Tue, 26 Aug 2025 11:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208126; cv=none; b=En3n3ybCABKctGjyiClU34xQ4LhKhxEdKUviDIYbAVvKB5+LXlPsrnl+oFvZSdeHSIXRQaxURPHDsBCeWx86EMguEkAVYi4OJE2kAnMWXT0B+g2MradFQzbEqFRmee7SZhX4U4PxqDlssuNAS0AwaxZmAgc+1AKuD8WRY/zneTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208126; c=relaxed/simple;
	bh=nGZ8NF27N/MVGdWC5NVZquEixrF4k2E3PFcsA7fqRys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2Oa7a5Pb6ALkCS8E82SuNfkwqiBnIk2OKQk+vVn3V1AwojDlm4zoTI8EMDNma4fWltNCDSjYodW/lysotzjgKyR8JmleRuDI9kxMFJS0oTkh7lti2bU7oJtYlvrGjjnj412AHayq2F/sWLXUlBYmGAUj3qaXUP1x6/v1Su0N68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qyxOmVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qyxOmVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30FFC4CEF1;
	Tue, 26 Aug 2025 11:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208126;
	bh=nGZ8NF27N/MVGdWC5NVZquEixrF4k2E3PFcsA7fqRys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qyxOmVGpxPWqMwh4HnenoURh/9oED84dznO+/hqQOkWUZPkbI051x9HzTIab0BKg
	 xcFsTpxlEMQKdGBCfsG0XW1EoSLyejpB1YT89Xl7hqrsfH807IhdqO9heOMuPoNLHs
	 qqahc98hF8HJtRdM1FD2cGZ1X/2JP6HQh9Z3oDx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Ming Lei <ming.lei@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 446/457] block: avoid cpu_hotplug_lock depedency on freeze_lock
Date: Tue, 26 Aug 2025 13:12:10 +0200
Message-ID: <20250826110948.308981499@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 370ac285f23aecae40600851fb4a1a9e75e50973 ]

A recent lockdep[1] splat observed while running blktest block/005
reveals a potential deadlock caused by the cpu_hotplug_lock dependency
on ->freeze_lock. This dependency was introduced by commit 033b667a823e
("block: blk-rq-qos: guard rq-qos helpers by static key").

That change added a static key to avoid fetching q->rq_qos when
neither blk-wbt nor blk-iolatency is configured. The static key
dynamically patches kernel text to a NOP when disabled, eliminating
overhead of fetching q->rq_qos in the I/O hot path. However, enabling
a static key at runtime requires acquiring both cpu_hotplug_lock and
jump_label_mutex. When this happens after the queue has already been
frozen (i.e., while holding ->freeze_lock), it creates a locking
dependency from cpu_hotplug_lock to ->freeze_lock, which leads to a
potential deadlock reported by lockdep [1].

To resolve this, replace the static key mechanism with q->queue_flags:
QUEUE_FLAG_QOS_ENABLED. This flag is evaluated in the fast path before
accessing q->rq_qos. If the flag is set, we proceed to fetch q->rq_qos;
otherwise, the access is skipped.

Since q->queue_flags is commonly accessed in IO hotpath and resides in
the first cacheline of struct request_queue, checking it imposes minimal
overhead while eliminating the deadlock risk.

This change avoids the lockdep splat without introducing performance
regressions.

[1] https://lore.kernel.org/linux-block/4fdm37so3o4xricdgfosgmohn63aa7wj3ua4e5vpihoamwg3ui@fq42f5q5t5ic/

Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Closes: https://lore.kernel.org/linux-block/4fdm37so3o4xricdgfosgmohn63aa7wj3ua4e5vpihoamwg3ui@fq42f5q5t5ic/
Fixes: 033b667a823e ("block: blk-rq-qos: guard rq-qos helpers by static key")
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250814082612.500845-4-nilay@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-debugfs.c |  1 +
 block/blk-rq-qos.c     |  9 ++++---
 block/blk-rq-qos.h     | 54 ++++++++++++++++++++++++------------------
 include/linux/blkdev.h |  1 +
 4 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 29b3540dd180..bdcb27ab5606 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -95,6 +95,7 @@ static const char *const blk_queue_flag_name[] = {
 	QUEUE_FLAG_NAME(SQ_SCHED),
 	QUEUE_FLAG_NAME(DISABLE_WBT_DEF),
 	QUEUE_FLAG_NAME(NO_ELV_SWITCH),
+	QUEUE_FLAG_NAME(QOS_ENABLED),
 };
 #undef QUEUE_FLAG_NAME
 
diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index b1e24bb85ad2..654478dfbc20 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -2,8 +2,6 @@
 
 #include "blk-rq-qos.h"
 
-__read_mostly DEFINE_STATIC_KEY_FALSE(block_rq_qos);
-
 /*
  * Increment 'v', if 'v' is below 'below'. Returns true if we succeeded,
  * false if 'v' + 1 would be bigger than 'below'.
@@ -319,8 +317,8 @@ void rq_qos_exit(struct request_queue *q)
 		struct rq_qos *rqos = q->rq_qos;
 		q->rq_qos = rqos->next;
 		rqos->ops->exit(rqos);
-		static_branch_dec(&block_rq_qos);
 	}
+	blk_queue_flag_clear(QUEUE_FLAG_QOS_ENABLED, q);
 	mutex_unlock(&q->rq_qos_mutex);
 }
 
@@ -346,7 +344,7 @@ int rq_qos_add(struct rq_qos *rqos, struct gendisk *disk, enum rq_qos_id id,
 		goto ebusy;
 	rqos->next = q->rq_qos;
 	q->rq_qos = rqos;
-	static_branch_inc(&block_rq_qos);
+	blk_queue_flag_set(QUEUE_FLAG_QOS_ENABLED, q);
 
 	blk_mq_unfreeze_queue(q, memflags);
 
@@ -374,10 +372,11 @@ void rq_qos_del(struct rq_qos *rqos)
 	for (cur = &q->rq_qos; *cur; cur = &(*cur)->next) {
 		if (*cur == rqos) {
 			*cur = rqos->next;
-			static_branch_dec(&block_rq_qos);
 			break;
 		}
 	}
+	if (!q->rq_qos)
+		blk_queue_flag_clear(QUEUE_FLAG_QOS_ENABLED, q);
 	blk_mq_unfreeze_queue(q, memflags);
 
 	mutex_lock(&q->debugfs_mutex);
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 28125fc49eff..1fe22000a379 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -12,7 +12,6 @@
 #include "blk-mq-debugfs.h"
 
 struct blk_mq_debugfs_attr;
-extern struct static_key_false block_rq_qos;
 
 enum rq_qos_id {
 	RQ_QOS_WBT,
@@ -113,49 +112,55 @@ void __rq_qos_queue_depth_changed(struct rq_qos *rqos);
 
 static inline void rq_qos_cleanup(struct request_queue *q, struct bio *bio)
 {
-	if (static_branch_unlikely(&block_rq_qos) && q->rq_qos)
+	if (unlikely(test_bit(QUEUE_FLAG_QOS_ENABLED, &q->queue_flags)) &&
+			q->rq_qos)
 		__rq_qos_cleanup(q->rq_qos, bio);
 }
 
 static inline void rq_qos_done(struct request_queue *q, struct request *rq)
 {
-	if (static_branch_unlikely(&block_rq_qos) && q->rq_qos &&
-	    !blk_rq_is_passthrough(rq))
+	if (unlikely(test_bit(QUEUE_FLAG_QOS_ENABLED, &q->queue_flags)) &&
+			q->rq_qos && !blk_rq_is_passthrough(rq))
 		__rq_qos_done(q->rq_qos, rq);
 }
 
 static inline void rq_qos_issue(struct request_queue *q, struct request *rq)
 {
-	if (static_branch_unlikely(&block_rq_qos) && q->rq_qos)
+	if (unlikely(test_bit(QUEUE_FLAG_QOS_ENABLED, &q->queue_flags)) &&
+			q->rq_qos)
 		__rq_qos_issue(q->rq_qos, rq);
 }
 
 static inline void rq_qos_requeue(struct request_queue *q, struct request *rq)
 {
-	if (static_branch_unlikely(&block_rq_qos) && q->rq_qos)
+	if (unlikely(test_bit(QUEUE_FLAG_QOS_ENABLED, &q->queue_flags)) &&
+			q->rq_qos)
 		__rq_qos_requeue(q->rq_qos, rq);
 }
 
 static inline void rq_qos_done_bio(struct bio *bio)
 {
-	if (static_branch_unlikely(&block_rq_qos) &&
-	    bio->bi_bdev && (bio_flagged(bio, BIO_QOS_THROTTLED) ||
-			     bio_flagged(bio, BIO_QOS_MERGED))) {
-		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-
-		/*
-		 * If a bio has BIO_QOS_xxx set, it implicitly implies that
-		 * q->rq_qos is present. So, we skip re-checking q->rq_qos
-		 * here as an extra optimization and directly call
-		 * __rq_qos_done_bio().
-		 */
-		__rq_qos_done_bio(q->rq_qos, bio);
-	}
+	struct request_queue *q;
+
+	if (!bio->bi_bdev || (!bio_flagged(bio, BIO_QOS_THROTTLED) &&
+			     !bio_flagged(bio, BIO_QOS_MERGED)))
+		return;
+
+	q = bdev_get_queue(bio->bi_bdev);
+
+	/*
+	 * If a bio has BIO_QOS_xxx set, it implicitly implies that
+	 * q->rq_qos is present. So, we skip re-checking q->rq_qos
+	 * here as an extra optimization and directly call
+	 * __rq_qos_done_bio().
+	 */
+	__rq_qos_done_bio(q->rq_qos, bio);
 }
 
 static inline void rq_qos_throttle(struct request_queue *q, struct bio *bio)
 {
-	if (static_branch_unlikely(&block_rq_qos) && q->rq_qos) {
+	if (unlikely(test_bit(QUEUE_FLAG_QOS_ENABLED, &q->queue_flags)) &&
+			q->rq_qos) {
 		bio_set_flag(bio, BIO_QOS_THROTTLED);
 		__rq_qos_throttle(q->rq_qos, bio);
 	}
@@ -164,14 +169,16 @@ static inline void rq_qos_throttle(struct request_queue *q, struct bio *bio)
 static inline void rq_qos_track(struct request_queue *q, struct request *rq,
 				struct bio *bio)
 {
-	if (static_branch_unlikely(&block_rq_qos) && q->rq_qos)
+	if (unlikely(test_bit(QUEUE_FLAG_QOS_ENABLED, &q->queue_flags)) &&
+			q->rq_qos)
 		__rq_qos_track(q->rq_qos, rq, bio);
 }
 
 static inline void rq_qos_merge(struct request_queue *q, struct request *rq,
 				struct bio *bio)
 {
-	if (static_branch_unlikely(&block_rq_qos) && q->rq_qos) {
+	if (unlikely(test_bit(QUEUE_FLAG_QOS_ENABLED, &q->queue_flags)) &&
+			q->rq_qos) {
 		bio_set_flag(bio, BIO_QOS_MERGED);
 		__rq_qos_merge(q->rq_qos, rq, bio);
 	}
@@ -179,7 +186,8 @@ static inline void rq_qos_merge(struct request_queue *q, struct request *rq,
 
 static inline void rq_qos_queue_depth_changed(struct request_queue *q)
 {
-	if (static_branch_unlikely(&block_rq_qos) && q->rq_qos)
+	if (unlikely(test_bit(QUEUE_FLAG_QOS_ENABLED, &q->queue_flags)) &&
+			q->rq_qos)
 		__rq_qos_queue_depth_changed(q->rq_qos);
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 620345ce3aaa..3921188c9e13 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -652,6 +652,7 @@ enum {
 	QUEUE_FLAG_SQ_SCHED,		/* single queue style io dispatch */
 	QUEUE_FLAG_DISABLE_WBT_DEF,	/* for sched to disable/enable wbt */
 	QUEUE_FLAG_NO_ELV_SWITCH,	/* can't switch elevator any more */
+	QUEUE_FLAG_QOS_ENABLED,		/* qos is enabled */
 	QUEUE_FLAG_MAX
 };
 
-- 
2.50.1



