Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7162F204F9D;
	Tue,  3 Dec 2024 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240235; cv=none; b=LFqdKC4oKVHiuD/e4gZYTsl4yKa5yZF3PQYjR6juHYa38Rm9EopOEE6RzjSB4V/A3Ppm9geZOrVXb5dKOGZamxpMWz4G9e7qYmWhtTeI6bZpPTgD5KTNA39OTO5BG8RudMisbHAPUQKoE1JIiMb5+iAsAmFWpRzrAnMce4wgvFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240235; c=relaxed/simple;
	bh=4TrFMZHjIJLA1wJxaJEeffAk13tPsi30NR4DU6Ph8Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJP7Xl+kZjy2XeKOw54xTmSwjG6NBg/yXjI2Ox6DkSgfi0EHXPm2r8tuN6dhjgnOPW7Ht9mC4P9TS4JnrstBI3oOJeq0sSCK3lKxpkjUOlZOxF/DyX8ExcXvLI9M77js23rofhLmfu19qB26N9ygi0a23s84LTrSRXNbuXAEfTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T38+vl8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T38+vl8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14EBC4CED8;
	Tue,  3 Dec 2024 15:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240235;
	bh=4TrFMZHjIJLA1wJxaJEeffAk13tPsi30NR4DU6Ph8Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T38+vl8Q3jgqTc97z51OftfAuMgKrKIpc/TzyasTyaeugNCjxgCEeyPP/mI9yuuMQ
	 JIxw8jd/HEei5O/hwIQwy+FKn0ZdFfD7DFheNAV8p9icKPh5QxCQuzCNwcODf81+iZ
	 +xhgtgeu3S+1E3ojukbW9J5X1gAK185Cvtru+VTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/826] nvme-pci: reverse request order in nvme_queue_rqs
Date: Tue,  3 Dec 2024 15:36:05 +0100
Message-ID: <20241203144744.948307361@linuxfoundation.org>
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



