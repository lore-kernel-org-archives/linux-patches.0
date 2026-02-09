Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148391AF0AF;
	Mon,  9 Feb 2026 14:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647632; cv=none; b=mFfto+B8uSwnblIkCvLWjq3sRHrv5ATaBSpHIzcledM9IvgDCRU2CHgQeqTJBU0mkNbFKESd96hiVRCLGhbK+k0qkOAHePzbKit9iIyYdDSSn9gR6O9/1TBJJyn6HfCXsEplDK9ocDNSewohTo+vkiRJKX4Ptj+nzgkZgmzwqPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647632; c=relaxed/simple;
	bh=5oNqdpxw1khcCzu8MmUnwSzgd2rGu54I7EdKP5uYO7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQANdAV+MUIibh3/47rxpkZzoMRufInU8tQR4wFLcBExCp/suSwE+0H4VWhq7bsKn6Lv9SGJsxyYspbSdKl83Tj8iH9ah+BbBcq4LOo3qLwC/zvch7I2NtSETUGFMhU3bmYpJb5t3bH5M53R12qj1GX715F5703MoGn/5oSts6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2xLKR8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2xLKR8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829EFC116C6;
	Mon,  9 Feb 2026 14:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647632;
	bh=5oNqdpxw1khcCzu8MmUnwSzgd2rGu54I7EdKP5uYO7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2xLKR8EdshDVzi1A1V0wDb0p8g9KiG2ebCzK398NUK+Sh5H90qZhvy8rJUHv4Wqt
	 Fo8bQ3mfhE9WVzaIasgf2wZhkJx8g5FNVRtmwbYWojSEJRyfMQnb1QewSjNpw6DI+1
	 yL7ZDljMNdOV4dJpawu9FlPRb1ZSMzptHXv9gILM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 156/175] nvme-pci: handle changing device dma map requirements
Date: Mon,  9 Feb 2026 15:23:49 +0100
Message-ID: <20260209142326.106854609@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 071be3b0b6575d45be9df9c5b612f5882bfc5e88 ]

The initial state of dma_needs_unmap may be false, but change to true
while mapping the data iterator. Enabling swiotlb is one such case that
can change the result. The nvme driver needs to save the mapped dma
vectors to be unmapped later, so allocate as needed during iteration
rather than assume it was always allocated at the beginning. This fixes
a NULL dereference from accessing an uninitialized dma_vecs when the
device dma unmapping requirements change mid-iteration.

Fixes: b8b7570a7ec8 ("nvme-pci: fix dma unmapping when using PRPs and not using the IOVA mapping")
Link: https://lore.kernel.org/linux-nvme/20260202125738.1194899-1-pradeep.pragallapati@oss.qualcomm.com/
Reported-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 45 +++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 28f638413e122..391c854428d3e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -771,6 +771,32 @@ static void nvme_unmap_data(struct request *req)
 		nvme_free_descriptors(req);
 }
 
+static bool nvme_pci_prp_save_mapping(struct request *req,
+				      struct device *dma_dev,
+				      struct blk_dma_iter *iter)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+
+	if (dma_use_iova(&iod->dma_state) || !dma_need_unmap(dma_dev))
+		return true;
+
+	if (!iod->nr_dma_vecs) {
+		struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
+
+		iod->dma_vecs = mempool_alloc(nvmeq->dev->dmavec_mempool,
+				GFP_ATOMIC);
+		if (!iod->dma_vecs) {
+			iter->status = BLK_STS_RESOURCE;
+			return false;
+		}
+	}
+
+	iod->dma_vecs[iod->nr_dma_vecs].addr = iter->addr;
+	iod->dma_vecs[iod->nr_dma_vecs].len = iter->len;
+	iod->nr_dma_vecs++;
+	return true;
+}
+
 static bool nvme_pci_prp_iter_next(struct request *req, struct device *dma_dev,
 		struct blk_dma_iter *iter)
 {
@@ -780,12 +806,7 @@ static bool nvme_pci_prp_iter_next(struct request *req, struct device *dma_dev,
 		return true;
 	if (!blk_rq_dma_map_iter_next(req, dma_dev, &iod->dma_state, iter))
 		return false;
-	if (!dma_use_iova(&iod->dma_state) && dma_need_unmap(dma_dev)) {
-		iod->dma_vecs[iod->nr_dma_vecs].addr = iter->addr;
-		iod->dma_vecs[iod->nr_dma_vecs].len = iter->len;
-		iod->nr_dma_vecs++;
-	}
-	return true;
+	return nvme_pci_prp_save_mapping(req, dma_dev, iter);
 }
 
 static blk_status_t nvme_pci_setup_data_prp(struct request *req,
@@ -798,15 +819,8 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	unsigned int prp_len, i;
 	__le64 *prp_list;
 
-	if (!dma_use_iova(&iod->dma_state) && dma_need_unmap(nvmeq->dev->dev)) {
-		iod->dma_vecs = mempool_alloc(nvmeq->dev->dmavec_mempool,
-				GFP_ATOMIC);
-		if (!iod->dma_vecs)
-			return BLK_STS_RESOURCE;
-		iod->dma_vecs[0].addr = iter->addr;
-		iod->dma_vecs[0].len = iter->len;
-		iod->nr_dma_vecs = 1;
-	}
+	if (!nvme_pci_prp_save_mapping(req, nvmeq->dev->dev, iter))
+		return iter->status;
 
 	/*
 	 * PRP1 always points to the start of the DMA transfers.
@@ -1148,6 +1162,7 @@ static blk_status_t nvme_prep_rq(struct request *req)
 	iod->nr_descriptors = 0;
 	iod->total_len = 0;
 	iod->meta_total_len = 0;
+	iod->nr_dma_vecs = 0;
 
 	ret = nvme_setup_cmd(req->q->queuedata, req);
 	if (ret)
-- 
2.51.0



