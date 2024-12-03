Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB7E203718;
	Tue,  3 Dec 2024 15:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240240; cv=none; b=mDhyrT6Kpf5eRnZqMaAOCFMQRuiKolO9MaxKaHbiPpgbD1ghbeLbJFxpc96/GKjzV5eb5VTJwxCQ1IgYDvj5VDGONOlhm17dCltSVd75Q+iaxlWLaud8EnDkAhPHzORcRYw/NPEjanJUXC3+cWsbN1UlrrVVaFWSdr9yOEBePjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240240; c=relaxed/simple;
	bh=hpUe97/qNBE0Gzuhr1q+Ub5MTcVoeEzwqHxZBeOtCTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWYxbaG+x93f4RW97GruIExTokitWUbfYh1kw2DmD0Pk8n0Zxl+8iA9a7T2BACMLhaaRHcvHKHyp/t33aQs4kkxgS6daldZcRMlMGIgRaUf2nkWL+iVbszpy9QF2vmLWxiVuG7PBYqKbjSOvHsmSENyBzvCpNHJ9cV1cx0ykIhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZNIHbQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZNIHbQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA97C4CECF;
	Tue,  3 Dec 2024 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240237;
	bh=hpUe97/qNBE0Gzuhr1q+Ub5MTcVoeEzwqHxZBeOtCTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZNIHbQVvQmqLsVwtD6sJdADqO6vUpWwh26nNGPRgSxCz9u//3A4ertxlofbl4zET
	 9SmqLVQwM9YtvXBtgfJ5opnrgZvKz3hSm1BxB50fyweAqn3sgghbbjEMcN9Sqo4map
	 vXhJat8g8VLHjImdv/mMcYbJRtRCbB1/Bugg7KJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/826] virtio_blk: reverse request order in virtio_queue_rqs
Date: Tue,  3 Dec 2024 15:36:06 +0100
Message-ID: <20241203144744.988264691@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7f212e997edbb7a2cb85cef2ac14265dfaf88717 ]

blk_mq_flush_plug_list submits requests in the reverse order that they
were submitted, which leads to a rather suboptimal I/O pattern
especially in rotational devices. Fix this by rewriting virtio_queue_rqs
so that it always pops the requests from the passed in request list, and
then adds them to the head of a local submit list. This actually
simplifies the code a bit as it removes the complicated list splicing,
at the cost of extra updates of the rq_next pointer. As that should be
cache hot anyway it should be an easy price to pay.

Fixes: 0e9911fa768f ("virtio-blk: support mq_ops->queue_rqs()")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241113152050.157179-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 46 +++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 194417abc1053..43c96b73a7118 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -471,18 +471,18 @@ static bool virtblk_prep_rq_batch(struct request *req)
 	return virtblk_prep_rq(req->mq_hctx, vblk, req, vbr) == BLK_STS_OK;
 }
 
-static bool virtblk_add_req_batch(struct virtio_blk_vq *vq,
+static void virtblk_add_req_batch(struct virtio_blk_vq *vq,
 					struct request **rqlist)
 {
+	struct request *req;
 	unsigned long flags;
-	int err;
 	bool kick;
 
 	spin_lock_irqsave(&vq->lock, flags);
 
-	while (!rq_list_empty(*rqlist)) {
-		struct request *req = rq_list_pop(rqlist);
+	while ((req = rq_list_pop(rqlist))) {
 		struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
+		int err;
 
 		err = virtblk_add_req(vq->vq, vbr);
 		if (err) {
@@ -495,37 +495,33 @@ static bool virtblk_add_req_batch(struct virtio_blk_vq *vq,
 	kick = virtqueue_kick_prepare(vq->vq);
 	spin_unlock_irqrestore(&vq->lock, flags);
 
-	return kick;
+	if (kick)
+		virtqueue_notify(vq->vq);
 }
 
 static void virtio_queue_rqs(struct request **rqlist)
 {
-	struct request *req, *next, *prev = NULL;
+	struct request *submit_list = NULL;
 	struct request *requeue_list = NULL;
+	struct request **requeue_lastp = &requeue_list;
+	struct virtio_blk_vq *vq = NULL;
+	struct request *req;
 
-	rq_list_for_each_safe(rqlist, req, next) {
-		struct virtio_blk_vq *vq = get_virtio_blk_vq(req->mq_hctx);
-		bool kick;
-
-		if (!virtblk_prep_rq_batch(req)) {
-			rq_list_move(rqlist, &requeue_list, req, prev);
-			req = prev;
-			if (!req)
-				continue;
-		}
+	while ((req = rq_list_pop(rqlist))) {
+		struct virtio_blk_vq *this_vq = get_virtio_blk_vq(req->mq_hctx);
 
-		if (!next || req->mq_hctx != next->mq_hctx) {
-			req->rq_next = NULL;
-			kick = virtblk_add_req_batch(vq, rqlist);
-			if (kick)
-				virtqueue_notify(vq->vq);
+		if (vq && vq != this_vq)
+			virtblk_add_req_batch(vq, &submit_list);
+		vq = this_vq;
 
-			*rqlist = next;
-			prev = NULL;
-		} else
-			prev = req;
+		if (virtblk_prep_rq_batch(req))
+			rq_list_add(&submit_list, req); /* reverse order */
+		else
+			rq_list_add_tail(&requeue_lastp, req);
 	}
 
+	if (vq)
+		virtblk_add_req_batch(vq, &submit_list);
 	*rqlist = requeue_list;
 }
 
-- 
2.43.0



