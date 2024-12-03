Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB951F754C;
	Tue,  3 Dec 2024 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237854; cv=none; b=gi2gP6cVipYT4OCMPJQzkPGK0xVvsqc9roYvDVUY6SFOkPzRZxJhxNdUldE2+Q+Phf5BkvKMHj991Ap2M6J/iLmyZX3aElT9p4zw2pl6i3Uq/H9oYGQ4MbG+XvWHQjt/TSeSQ6aJUnY9PZJ4k2aV+qKvCMqMK6ZD0QJzkQOCDkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237854; c=relaxed/simple;
	bh=oe8XBwJtuJjonr5/C4we+bbZ4bjIakLqaAoKlya5y+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IL48frUAZx2uqCaUXlFsHrtuhCzR/5jKKRgT2Xju5sBh7JHFC6vJLZeBB1IUDFqJqXdZDvUMnfE44Q9paXjKU4zrGeX75rS3I4UMrV8N+c7PZ0hx+dagceyk4dcCI+zbv1HvU71EA3e7+Ifih43DGYUU/z1y1BIM0G63kBGyXrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9uQyiEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9uQyiEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2115EC4CED9;
	Tue,  3 Dec 2024 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237854;
	bh=oe8XBwJtuJjonr5/C4we+bbZ4bjIakLqaAoKlya5y+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9uQyiEo1CiJ6M6ep0Cd2ctBL2ik7DVkhFu+6ro+Re4PFwBOpOBp0/DaBi0zx8Mbf
	 7QtETQjLOa9sBHcuMTnsTI57rLulBcespH8EMaY+DITrKSIfGxEQbt7eVLdvk2BxT+
	 usTnywMDX4VogEl3isuw+JLl/T2upc4kYh+cFTFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 087/817] virtio_blk: reverse request order in virtio_queue_rqs
Date: Tue,  3 Dec 2024 15:34:19 +0100
Message-ID: <20241203143959.096383965@linuxfoundation.org>
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



