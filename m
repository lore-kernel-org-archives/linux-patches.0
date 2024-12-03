Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A206D1F7557;
	Tue,  3 Dec 2024 15:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239765; cv=none; b=B3WJC2Wxm7moYatxUBsfIG9kicdSJ9VcuN4ll399fxddnv6wkETlagxMuMihXl3WJ7ARirN8rrdICUluSmLuakqvGQShoJYDDrTy2PWD2MtdQdbDn0rV3mlHxvQ+UHOylCrETWOYBw9Gvg8YeJ1xImcLNtw0FiYnE7LXnIolXBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239765; c=relaxed/simple;
	bh=0Jdo9yRRkLlXoP1wsHA8PLz3lNKGc+8q3094+ORiU7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sX0XMTCcWgPM9/Hl/FZx39KPiM/rB7nM6w/iGkoOKefCKN6kJxo+9NyH4plNlfZWCdSl1Yq3kvt1mq7sBze+KWgEQSQndyfRaYFqW/m0NPz6FTxmKgJn1QrQLyGxTyBxmQVLYJS+vZsk9Io2cz3lpC/ty6pN4Duz4Ckx5yiPoi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKO92HTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKO92HTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262A9C4CECF;
	Tue,  3 Dec 2024 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239765;
	bh=0Jdo9yRRkLlXoP1wsHA8PLz3lNKGc+8q3094+ORiU7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKO92HTYXl50qA56tAGG0dziTcNigNi2gJ+vzrxlGUqos4q2NOnUgzVnNlu0j3tpK
	 kDh04YoVbKcs8cYty/9oZtjnIu4xQt+bb9WyjlH0LURjs8x3jWb+zU3/8ZaE2ZMEcl
	 xnbP/9yDGOCpth+t5jFOWSVSpp6gjfZcpSCm+Kro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 727/817] block: fix ordering between checking BLK_MQ_S_STOPPED request adding
Date: Tue,  3 Dec 2024 15:44:59 +0100
Message-ID: <20241203144024.372333022@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muchun Song <songmuchun@bytedance.com>

commit 96a9fe64bfd486ebeeacf1e6011801ffe89dae18 upstream.

Supposing first scenario with a virtio_blk driver.

CPU0                        CPU1

blk_mq_try_issue_directly()
  __blk_mq_issue_directly()
    q->mq_ops->queue_rq()
      virtio_queue_rq()
        blk_mq_stop_hw_queue()
                            virtblk_done()
  blk_mq_request_bypass_insert()  1) store
                              blk_mq_start_stopped_hw_queue()
                                clear_bit(BLK_MQ_S_STOPPED)       3) store
                                blk_mq_run_hw_queue()
                                  if (!blk_mq_hctx_has_pending()) 4) load
                                    return
                                  blk_mq_sched_dispatch_requests()
  blk_mq_run_hw_queue()
    if (!blk_mq_hctx_has_pending())
      return
    blk_mq_sched_dispatch_requests()
      if (blk_mq_hctx_stopped())  2) load
        return
      __blk_mq_sched_dispatch_requests()

Supposing another scenario.

CPU0                        CPU1

blk_mq_requeue_work()
  blk_mq_insert_request() 1) store
                            virtblk_done()
                              blk_mq_start_stopped_hw_queue()
  blk_mq_run_hw_queues()        clear_bit(BLK_MQ_S_STOPPED)       3) store
                                blk_mq_run_hw_queue()
                                  if (!blk_mq_hctx_has_pending()) 4) load
                                    return
                                  blk_mq_sched_dispatch_requests()
    if (blk_mq_hctx_stopped())  2) load
      continue
    blk_mq_run_hw_queue()

Both scenarios are similar, the full memory barrier should be inserted
between 1) and 2), as well as between 3) and 4) to make sure that either
CPU0 sees BLK_MQ_S_STOPPED is cleared or CPU1 sees dispatch list.
Otherwise, either CPU will not rerun the hardware queue causing
starvation of the request.

The easy way to fix it is to add the essential full memory barrier into
helper of blk_mq_hctx_stopped(). In order to not affect the fast path
(hardware queue is not stopped most of the time), we only insert the
barrier into the slow path. Actually, only slow path needs to care about
missing of dispatching the request to the low-level device driver.

Fixes: 320ae51feed5 ("blk-mq: new multi-queue block IO queueing mechanism")
Cc: stable@vger.kernel.org
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241014092934.53630-4-songmuchun@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    6 ++++++
 block/blk-mq.h |   13 +++++++++++++
 2 files changed, 19 insertions(+)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2413,6 +2413,12 @@ void blk_mq_start_stopped_hw_queue(struc
 		return;
 
 	clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
+	/*
+	 * Pairs with the smp_mb() in blk_mq_hctx_stopped() to order the
+	 * clearing of BLK_MQ_S_STOPPED above and the checking of dispatch
+	 * list in the subsequent routine.
+	 */
+	smp_mb__after_atomic();
 	blk_mq_run_hw_queue(hctx, async);
 }
 EXPORT_SYMBOL_GPL(blk_mq_start_stopped_hw_queue);
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -230,6 +230,19 @@ static inline struct blk_mq_tags *blk_mq
 
 static inline bool blk_mq_hctx_stopped(struct blk_mq_hw_ctx *hctx)
 {
+	/* Fast path: hardware queue is not stopped most of the time. */
+	if (likely(!test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
+		return false;
+
+	/*
+	 * This barrier is used to order adding of dispatch list before and
+	 * the test of BLK_MQ_S_STOPPED below. Pairs with the memory barrier
+	 * in blk_mq_start_stopped_hw_queue() so that dispatch code could
+	 * either see BLK_MQ_S_STOPPED is cleared or dispatch list is not
+	 * empty to avoid missing dispatching requests.
+	 */
+	smp_mb();
+
 	return test_bit(BLK_MQ_S_STOPPED, &hctx->state);
 }
 


