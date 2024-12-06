Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5BD149C6F;
	Fri,  6 Dec 2024 15:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498241; cv=none; b=TIDHgQ408PnKQJfRsclOQ1rBjFS4UzNof0SQol3F2d2I1ZjCM7YBDR/VR09GkhskgtxC+oS7pB6Rs0SGaRD4jiDK76iKyLIpH2lB0kQVEN0Ib5ZtzTWSS41tuAPmoU7NKdB+ngVWPv9MT1NYicMPs86oexP4zgobDFKue+61Bn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498241; c=relaxed/simple;
	bh=SNhdGEIBYahX/X6HXhuVcE+9QJ7QCf1nGMDnzJ4qrlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWzhmK0wGI1gI8ymh0xmgyvMkqOAbqP2CW0U3xzB403/ieK6XTsGEW0xo4v/5PzSG2za6Y1NgcK9nFSRmU+HBNbbm5zWFNNBdu5iFnFtcwjPOJqffaHQ0eW/BKbhlLcQtPfLaX7TPej4/5dkvtjBNnc6Js+cPmfL+E9/p6bKJ3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLnHeH+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLnHeH+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73EEC4CED1;
	Fri,  6 Dec 2024 15:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498241;
	bh=SNhdGEIBYahX/X6HXhuVcE+9QJ7QCf1nGMDnzJ4qrlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLnHeH+ob23dHbwwPuSnLokIHslm/AaUuZ4bDvfb49d0z+2XNCcqhT3UlwU6qqzbS
	 xhwBbrDNEsPQyxEjfbU697Zyghf+FsV6Zx7HyhcQkzYmjhz3dDgmk6Cfb9bMdtx6pa
	 3+kr4zOsZvn8DpcZbkkGBtyAfWTENY3etcjjAtrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 527/676] block: fix ordering between checking QUEUE_FLAG_QUIESCED request adding
Date: Fri,  6 Dec 2024 15:35:46 +0100
Message-ID: <20241206143713.946259896@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muchun Song <songmuchun@bytedance.com>

commit 6bda857bcbb86fb9d0e54fbef93a093d51172acc upstream.

Supposing the following scenario.

CPU0                        CPU1

blk_mq_insert_request()     1) store
                            blk_mq_unquiesce_queue()
                            blk_queue_flag_clear()                3) store
                              blk_mq_run_hw_queues()
                                blk_mq_run_hw_queue()
                                  if (!blk_mq_hctx_has_pending()) 4) load
                                    return
blk_mq_run_hw_queue()
  if (blk_queue_quiesced()) 2) load
    return
  blk_mq_sched_dispatch_requests()

The full memory barrier should be inserted between 1) and 2), as well as
between 3) and 4) to make sure that either CPU0 sees QUEUE_FLAG_QUIESCED
is cleared or CPU1 sees dispatch list or setting of bitmap of software
queue. Otherwise, either CPU will not rerun the hardware queue causing
starvation.

So the first solution is to 1) add a pair of memory barrier to fix the
problem, another solution is to 2) use hctx->queue->queue_lock to
synchronize QUEUE_FLAG_QUIESCED. Here, we chose 2) to fix it since
memory barrier is not easy to be maintained.

Fixes: f4560ffe8cec ("blk-mq: use QUEUE_FLAG_QUIESCED to quiesce queue")
Cc: stable@vger.kernel.org
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241014092934.53630-3-songmuchun@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |   49 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 14 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2252,6 +2252,24 @@ void blk_mq_delay_run_hw_queue(struct bl
 }
 EXPORT_SYMBOL(blk_mq_delay_run_hw_queue);
 
+static inline bool blk_mq_hw_queue_need_run(struct blk_mq_hw_ctx *hctx)
+{
+	bool need_run;
+
+	/*
+	 * When queue is quiesced, we may be switching io scheduler, or
+	 * updating nr_hw_queues, or other things, and we can't run queue
+	 * any more, even blk_mq_hctx_has_pending() can't be called safely.
+	 *
+	 * And queue will be rerun in blk_mq_unquiesce_queue() if it is
+	 * quiesced.
+	 */
+	__blk_mq_run_dispatch_ops(hctx->queue, false,
+		need_run = !blk_queue_quiesced(hctx->queue) &&
+		blk_mq_hctx_has_pending(hctx));
+	return need_run;
+}
+
 /**
  * blk_mq_run_hw_queue - Start to run a hardware queue.
  * @hctx: Pointer to the hardware queue to run.
@@ -2272,20 +2290,23 @@ void blk_mq_run_hw_queue(struct blk_mq_h
 
 	might_sleep_if(!async && hctx->flags & BLK_MQ_F_BLOCKING);
 
-	/*
-	 * When queue is quiesced, we may be switching io scheduler, or
-	 * updating nr_hw_queues, or other things, and we can't run queue
-	 * any more, even __blk_mq_hctx_has_pending() can't be called safely.
-	 *
-	 * And queue will be rerun in blk_mq_unquiesce_queue() if it is
-	 * quiesced.
-	 */
-	__blk_mq_run_dispatch_ops(hctx->queue, false,
-		need_run = !blk_queue_quiesced(hctx->queue) &&
-		blk_mq_hctx_has_pending(hctx));
-
-	if (!need_run)
-		return;
+	need_run = blk_mq_hw_queue_need_run(hctx);
+	if (!need_run) {
+		unsigned long flags;
+
+		/*
+		 * Synchronize with blk_mq_unquiesce_queue(), because we check
+		 * if hw queue is quiesced locklessly above, we need the use
+		 * ->queue_lock to make sure we see the up-to-date status to
+		 * not miss rerunning the hw queue.
+		 */
+		spin_lock_irqsave(&hctx->queue->queue_lock, flags);
+		need_run = blk_mq_hw_queue_need_run(hctx);
+		spin_unlock_irqrestore(&hctx->queue->queue_lock, flags);
+
+		if (!need_run)
+			return;
+	}
 
 	if (async || !cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask)) {
 		blk_mq_delay_run_hw_queue(hctx, 0);


