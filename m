Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463D01714A1;
	Thu, 15 Aug 2024 13:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730078; cv=none; b=tWzBHujHGzk7gZyTodJiNECuaGde6UtdBvxYEZHqG0ibIECJBfergRGFKPDzQ8LcCXb+alUg38ci+n+L4cK4B6X5hUVW9x9gok5sIe1I+pweLZtvMzJl1NdzDAMlceunHORjnGc7jJRF84RGXenuAxz1X1AhhtRFhzY7vIpZ2jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730078; c=relaxed/simple;
	bh=TgwfJey8obEZUaciqYmUir+J8g2Af0x4SRVvjNJ08Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6pSVfTakoMUdCM41k+h8x4xqdud84j+oZeUZ6ErQoOq9lhr7y2CaRMA+wQ+ZTrMRT3MH3yuIYjNBN7cPiqKwCHt5S77cZ83x3Ug2qky0cxfU9lOHsFnqMG5ttAOxov+xbaTgxAV7UpjPwEJdB2Ycf3wKQWDg/WR0/EgvNq0T9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aB9rlKqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aB9rlKqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD22EC32786;
	Thu, 15 Aug 2024 13:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730078;
	bh=TgwfJey8obEZUaciqYmUir+J8g2Af0x4SRVvjNJ08Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aB9rlKqkjRErCReo/b7EjHYA6DJhaIdHprYq50s9Sr793HX2hta13yR+VtjdWSbM/
	 SSoGRtvqKW8xXLRAs1jB1vAlNV9TBgCpffNGXtzpvy6x6ar5Tw3S5rMpKPd/0IEPNM
	 D61sMQHaL9o/1HqxAMNIgmAfYFPMkeJr9UYKNasw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 295/484] nvme: separate command prep and issue
Date: Thu, 15 Aug 2024 15:22:33 +0200
Message-ID: <20240815131952.801069318@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 62451a2b2e7ea17c4a547ada6a5deebf8787a27a ]

Add a nvme_prep_rq() helper to setup a command, and nvme_queue_rq() is
adapted to use this helper.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c31fad147038 ("nvme-pci: add missing condition check for existence of mapped data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 63 +++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 04e51134165dd..01f16989d0d84 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -886,55 +886,32 @@ static blk_status_t nvme_map_metadata(struct nvme_dev *dev, struct request *req,
 	return BLK_STS_OK;
 }
 
-/*
- * NOTE: ns is NULL when called on the admin queue.
- */
-static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
-			 const struct blk_mq_queue_data *bd)
+static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 {
-	struct nvme_ns *ns = hctx->queue->queuedata;
-	struct nvme_queue *nvmeq = hctx->driver_data;
-	struct nvme_dev *dev = nvmeq->dev;
-	struct request *req = bd->rq;
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct nvme_command *cmnd = &iod->cmd;
 	blk_status_t ret;
 
 	iod->aborted = 0;
 	iod->npages = -1;
 	iod->nents = 0;
 
-	/*
-	 * We should not need to do this, but we're still using this to
-	 * ensure we can drain requests on a dying queue.
-	 */
-	if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)))
-		return BLK_STS_IOERR;
-
-	if (!nvme_check_ready(&dev->ctrl, req, true))
-		return nvme_fail_nonready_command(&dev->ctrl, req);
-
-	ret = nvme_setup_cmd(ns, req);
+	ret = nvme_setup_cmd(req->q->queuedata, req);
 	if (ret)
 		return ret;
 
 	if (blk_rq_nr_phys_segments(req)) {
-		ret = nvme_map_data(dev, req, cmnd);
+		ret = nvme_map_data(dev, req, &iod->cmd);
 		if (ret)
 			goto out_free_cmd;
 	}
 
 	if (blk_integrity_rq(req)) {
-		ret = nvme_map_metadata(dev, req, cmnd);
+		ret = nvme_map_metadata(dev, req, &iod->cmd);
 		if (ret)
 			goto out_unmap_data;
 	}
 
 	blk_mq_start_request(req);
-	spin_lock(&nvmeq->sq_lock);
-	nvme_sq_copy_cmd(nvmeq, &iod->cmd);
-	nvme_write_sq_db(nvmeq, bd->last);
-	spin_unlock(&nvmeq->sq_lock);
 	return BLK_STS_OK;
 out_unmap_data:
 	nvme_unmap_data(dev, req);
@@ -943,6 +920,38 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return ret;
 }
 
+/*
+ * NOTE: ns is NULL when called on the admin queue.
+ */
+static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
+			 const struct blk_mq_queue_data *bd)
+{
+	struct nvme_queue *nvmeq = hctx->driver_data;
+	struct nvme_dev *dev = nvmeq->dev;
+	struct request *req = bd->rq;
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	blk_status_t ret;
+
+	/*
+	 * We should not need to do this, but we're still using this to
+	 * ensure we can drain requests on a dying queue.
+	 */
+	if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)))
+		return BLK_STS_IOERR;
+
+	if (unlikely(!nvme_check_ready(&dev->ctrl, req, true)))
+		return nvme_fail_nonready_command(&dev->ctrl, req);
+
+	ret = nvme_prep_rq(dev, req);
+	if (unlikely(ret))
+		return ret;
+	spin_lock(&nvmeq->sq_lock);
+	nvme_sq_copy_cmd(nvmeq, &iod->cmd);
+	nvme_write_sq_db(nvmeq, bd->last);
+	spin_unlock(&nvmeq->sq_lock);
+	return BLK_STS_OK;
+}
+
 static void nvme_pci_complete_rq(struct request *req)
 {
 	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
-- 
2.43.0



