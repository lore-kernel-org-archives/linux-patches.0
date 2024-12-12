Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B850B226537;
	Thu, 12 Dec 2024 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019018; cv=none; b=t3oDCfnwwITY615jg18r+j9cMc0siqusgVYn46z3/lR6cjegDO9Kux0R+80q3mai271shggo4Z3EeJjj1pDkzPltjZsMSGGOAiAcAljjfo1gEkpHtnbv7WejyIk3G9/+twHVGLN9eVsYKZSZTCnvVyT7RLyFFA8cc+mDzopjgf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019018; c=relaxed/simple;
	bh=/e3sZ5iYMYh5Tmc3aNVXLcp+PhL0eOTf1/lXRu4c6Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLFhii28CEMy0wChhUio7A4eXVZYRRUoKsejyfORswHP4HDj2ZnXn9jwLbdGrcOQvg5/T3F/3R9NO1JV5IYH6QjOP2TFdGMXSYe6zkN9lmMm7Kmc9kp7je2O1AdhPz25No/sUucy8L3DSSDHQzYrr3/FLnxOxr7+4/L6YpA1mxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pc5unsQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pc5unsQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDC4C4CECE;
	Thu, 12 Dec 2024 15:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019018;
	bh=/e3sZ5iYMYh5Tmc3aNVXLcp+PhL0eOTf1/lXRu4c6Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pc5unsQG9Aw46mrAngIc3qggsbhTgecO86SHeL5gNqfPg13SQFIOvoFoXesoGWXri
	 +QgBPXb3jAPiJmMp0uQWXLa8wtGRyy6aqXX7N09dn6xVBHF1+o4nrmHL2rAqPgcuWC
	 80qMjlQDSAOwYTUynk3qrTxpZXDqDTv/H619bLMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/772] virtio_blk: reverse request order in virtio_queue_rqs
Date: Thu, 12 Dec 2024 15:50:11 +0100
Message-ID: <20241212144352.668836819@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index 505026f0025c7..28644729dc976 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -399,18 +399,18 @@ static bool virtblk_prep_rq_batch(struct request *req)
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
@@ -423,37 +423,33 @@ static bool virtblk_add_req_batch(struct virtio_blk_vq *vq,
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



