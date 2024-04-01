Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B29C482DF;
	Mon,  1 Apr 2024 17:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991219; cv=none; b=c2F3/iZZAkHil1XgMEYgJFq7bjNVh/rGUTyDfGHQKolqTWT3nRkERzBQYe0JJrTQkG7xKL4TerQFIXR1A2YNkkc/IbWUFUCtQI99Wp3qkJq8zdI5Rr4T5etvnaIN4kzldVWYFv73vOoDlcO3SCSA0pgzIKLHbpT3D17gSfvT2w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991219; c=relaxed/simple;
	bh=Mv4u2dCpUYmG12oHJ0MgOxCytAr/IvKGwzxJOaNc9l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7LaKJje09FfiBIM1q11DEUH+qD5VwRUVd8ixl9ku7xsg9UyZ4iOr2vfOlKOtvOoZU+R9oNFtkU8xPA44HIrHClFIlXrhPk2J4oC+fLZVkcZRPiO4o4WAVRGffA3CFkUU86fWwWl7WqBRThalxjvSgYEDtCan7TysoKE27uZkk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAhhrgJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAhhrgJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87848C433C7;
	Mon,  1 Apr 2024 17:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991218;
	bh=Mv4u2dCpUYmG12oHJ0MgOxCytAr/IvKGwzxJOaNc9l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAhhrgJuQhFgvNDDH0AprwGIwcYW0euKkVueS2oxbfEAGjdZm1AQU+WubCGWgle1r
	 5BRL2ISWWKg8F1MIiMxZTkryZthv6P9hIbVXfGTctJpSjXjXKoSdIK01lGteuxxh76
	 hCODrJe23K2jojG/GFyz2yK03gePSBBl7HBzsdOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6.1 198/272] blk-mq: release scheduler resource when request completes
Date: Mon,  1 Apr 2024 17:46:28 +0200
Message-ID: <20240401152537.071372186@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

commit e5c0ca13659e9d18f53368d651ed7e6e433ec1cf upstream.

Chuck reported [1] an IO hang problem on NFS exports that reside on SATA
devices and bisected to commit 615939a2ae73 ("blk-mq: defer to the normal
submission path for post-flush requests").

We analysed the IO hang problem, found there are two postflush requests
waiting for each other.

The first postflush request completed the REQ_FSEQ_DATA sequence, so go to
the REQ_FSEQ_POSTFLUSH sequence and added in the flush pending list, but
failed to blk_kick_flush() because of the second postflush request which
is inflight waiting in scheduler queue.

The second postflush waiting in scheduler queue can't be dispatched because
the first postflush hasn't released scheduler resource even though it has
completed by itself.

Fix it by releasing scheduler resource when the first postflush request
completed, so the second postflush can be dispatched and completed, then
make blk_kick_flush() succeed.

While at it, remove the check for e->ops.finish_request, as all
schedulers set that. Reaffirm this requirement by adding a WARN_ON_ONCE()
at scheduler registration time, just like we do for insert_requests and
dispatch_request.

[1] https://lore.kernel.org/all/7A57C7AE-A51A-4254-888B-FE15CA21F9E9@oracle.com/

Link: https://lore.kernel.org/linux-block/20230819031206.2744005-1-chengming.zhou@linux.dev/
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202308172100.8ce4b853-oliver.sang@intel.com
Fixes: 615939a2ae73 ("blk-mq: defer to the normal submission path for post-flush requests")
Reported-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Tested-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20230813152325.3017343-1-chengming.zhou@linux.dev
[axboe: folded in incremental fix and added tags]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[bvanassche: changed RQF_USE_SCHED into RQF_ELVPRIV; restored the
finish_request pointer check before calling finish_request and removed
the new warning from the elevator code. This patch fixes an I/O hang
when submitting a REQ_FUA request to a request queue for a zoned block
device for which FUA has been disabled (QUEUE_FLAG_FUA is not set).]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -675,6 +675,22 @@ out_queue_exit:
 }
 EXPORT_SYMBOL_GPL(blk_mq_alloc_request_hctx);
 
+static void blk_mq_finish_request(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+
+	if ((rq->rq_flags & RQF_ELVPRIV) &&
+	    q->elevator->type->ops.finish_request) {
+		q->elevator->type->ops.finish_request(rq);
+		/*
+		 * For postflush request that may need to be
+		 * completed twice, we should clear this flag
+		 * to avoid double finish_request() on the rq.
+		 */
+		rq->rq_flags &= ~RQF_ELVPRIV;
+	}
+}
+
 static void __blk_mq_free_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
@@ -701,9 +717,7 @@ void blk_mq_free_request(struct request
 {
 	struct request_queue *q = rq->q;
 
-	if ((rq->rq_flags & RQF_ELVPRIV) &&
-	    q->elevator->type->ops.finish_request)
-		q->elevator->type->ops.finish_request(rq);
+	blk_mq_finish_request(rq);
 
 	if (unlikely(laptop_mode && !blk_rq_is_passthrough(rq)))
 		laptop_io_completion(q->disk->bdi);
@@ -1025,6 +1039,8 @@ inline void __blk_mq_end_request(struct
 	if (blk_mq_need_time_stamp(rq))
 		__blk_mq_end_request_acct(rq, ktime_get_ns());
 
+	blk_mq_finish_request(rq);
+
 	if (rq->end_io) {
 		rq_qos_done(rq->q, rq);
 		if (rq->end_io(rq, error) == RQ_END_IO_FREE)
@@ -1079,6 +1095,8 @@ void blk_mq_end_request_batch(struct io_
 		if (iob->need_ts)
 			__blk_mq_end_request_acct(rq, now);
 
+		blk_mq_finish_request(rq);
+
 		rq_qos_done(rq->q, rq);
 
 		/*


