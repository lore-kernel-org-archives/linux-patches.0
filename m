Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C021F4283;
	Tue,  3 Dec 2024 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237846; cv=none; b=cIr//UWno+3JZYfGrzv2RKF6F9ZFCVz3V6HMZ8KOJUrjyAOJmtiUZDUjzoTjsDnMyQxHlQUTRlHM6ZVIm0HI8vrWrgKPMp0/8I7uVVnwF8jXsk86xqFj67cEawNJwyWfBCdXiKaiC+mlQdP6Q9+ghkgX2FZvnxgXPoV2EUFCoAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237846; c=relaxed/simple;
	bh=BRxEMmRd55Y+uibLcJ97NUaZb4c5NDQgCnPAhN908X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/NRlTbnD0TM94l12fTe5gcFHb4j/VkdIgmcPNg/1f5Sq4UYo8zgyPc4rybFfPqhUmCFjwbtEInzhFM2LZdBVwi5+ogjZ+8oGWxXlyDizLga3vOpHNg8tzbiqUGf4MdXdbgbaNQUUAsiAIYLtWVp13jPpIg486qGIj4Tpebthf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a03wDeXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a03wDeXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84334C4CECF;
	Tue,  3 Dec 2024 14:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237845;
	bh=BRxEMmRd55Y+uibLcJ97NUaZb4c5NDQgCnPAhN908X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a03wDeXPwUxGdpa0McUA5p/9M1Lv/+iSOQX/VbV/W+QsEXBaSCCYkaAf3o3bdqgW5
	 JEK/i0uzsZxCBRQ41PZ4Qv3sGuw3S6xb02kbABND2P3uFw8xOP2CbTqK5YWTKHqXxo
	 Tlrb7mUMgVYrENzR72lBVHRsEqAHbDGMWvWbYHJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 086/817] nvme-pci: reverse request order in nvme_queue_rqs
Date: Tue,  3 Dec 2024 15:34:18 +0100
Message-ID: <20241203143959.056753040@linuxfoundation.org>
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

[ Upstream commit beadf0088501d9dcf2454b05d90d5d31ea3ba55f ]

blk_mq_flush_plug_list submits requests in the reverse order that they
were submitted, which leads to a rather suboptimal I/O pattern especially
in rotational devices.  Fix this by rewriting nvme_queue_rqs so that it
always pops the requests from the passed in request list, and then adds
them to the head of a local submit list.  This actually simplifies the
code a bit as it removes the complicated list splicing, at the cost of
extra updates of the rq_next pointer.  As that should be cache hot
anyway it should be an easy price to pay.

Fixes: d62cbcf62f2f ("nvme: add support for mq_ops->queue_rqs()")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241113152050.157179-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 34daf6d8db07b..55af3dfbc2607 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -905,9 +905,10 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 static void nvme_submit_cmds(struct nvme_queue *nvmeq, struct request **rqlist)
 {
+	struct request *req;
+
 	spin_lock(&nvmeq->sq_lock);
-	while (!rq_list_empty(*rqlist)) {
-		struct request *req = rq_list_pop(rqlist);
+	while ((req = rq_list_pop(rqlist))) {
 		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
 		nvme_sq_copy_cmd(nvmeq, &iod->cmd);
@@ -932,31 +933,25 @@ static bool nvme_prep_rq_batch(struct nvme_queue *nvmeq, struct request *req)
 
 static void nvme_queue_rqs(struct request **rqlist)
 {
-	struct request *req, *next, *prev = NULL;
+	struct request *submit_list = NULL;
 	struct request *requeue_list = NULL;
+	struct request **requeue_lastp = &requeue_list;
+	struct nvme_queue *nvmeq = NULL;
+	struct request *req;
 
-	rq_list_for_each_safe(rqlist, req, next) {
-		struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
-
-		if (!nvme_prep_rq_batch(nvmeq, req)) {
-			/* detach 'req' and add to remainder list */
-			rq_list_move(rqlist, &requeue_list, req, prev);
-
-			req = prev;
-			if (!req)
-				continue;
-		}
+	while ((req = rq_list_pop(rqlist))) {
+		if (nvmeq && nvmeq != req->mq_hctx->driver_data)
+			nvme_submit_cmds(nvmeq, &submit_list);
+		nvmeq = req->mq_hctx->driver_data;
 
-		if (!next || req->mq_hctx != next->mq_hctx) {
-			/* detach rest of list, and submit */
-			req->rq_next = NULL;
-			nvme_submit_cmds(nvmeq, rqlist);
-			*rqlist = next;
-			prev = NULL;
-		} else
-			prev = req;
+		if (nvme_prep_rq_batch(nvmeq, req))
+			rq_list_add(&submit_list, req); /* reverse order */
+		else
+			rq_list_add_tail(&requeue_lastp, req);
 	}
 
+	if (nvmeq)
+		nvme_submit_cmds(nvmeq, &submit_list);
 	*rqlist = requeue_list;
 }
 
-- 
2.43.0



