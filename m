Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808564FE2CE;
	Tue, 13 Oct 2026 12:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893481; cv=none; b=sUE7hZpVCa/4OavS8/hnBflcu9Cg/1Rx1644vYnzIBrDFqhpzEsZSLJQgiDDKdZFQMY9a4eW/QzboybmJjBZx3VlWSaHXvXZGhujnRTXtGFBSCKLyI6SoDJRvEams3CC7KbX7Bw0qRg5XHLRctStFjFfTmPiKrujonQ5lbk/tpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893481; c=relaxed/simple;
	bh=22gxvxORiGKVFtTYETvWOjMiqQ2fE/IaX50jz5JvaXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVHIIbV1WlL8k/Cfj+kYsofsR2vsc6fc531yoiqDdhofazY5m121BsK6bdP5lTCYrFLgGJJBETKFz974TuPf3DJiLnaDKU0an894ifRjyx1IqlMmROvOgWzrsX8ZgA/DTVQDwmWB312GyKpWpqOeuIIb6nXIjj5khRUxBabbqS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDPmIm+4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDPmIm+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D568F1F000FF;
	Tue, 13 Oct 2026 12:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893480;
	bh=8Tdcb1yNcmSpUb+bYA5m+lc88hliwC1skzpP/EZ79kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDPmIm+4oyxGhdiEKyEm2FXTxHHWUHQcUGwCTgS2SfeoKa5G+uQGjGRZhb9bu7Pn/
	 y/9YxS81XyAM85jW11M+iWxl43CcK6tMmi01LSBbfVSS3NeQLGY/xc7g7ePtmUDYOV
	 cHiw0gSGwMln3RaBC95dFzx41tfcMuvypeiiNnzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 239/621] nvme-pci: fix dma mapping leak on data setup error
Date: Tue, 13 Oct 2026 13:33:54 +0200
Message-ID: <20261013112926.529467253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

[ Upstream commit 1bf86336e4b6cf40873fda47a7fe191446864937 ]

We're leaking the initial DMA mapping during iteration if we fail to
allocate the tracking descriptor for both PRP and SGL. Unmap the
iterator directly; we can't use the existing unmap helper because it
depends on the tracking descriptor being successfully allocated, so a
new one for an in-use iterator is provided.

The mappings were also leaking when the driver detects an invalid
bio_vec when mapping PRPs, so fix that too.

Fixes: b8b7570a7ec87 ("nvme-pci: fix dma unmapping when using PRPs and not using the IOVA mapping")
Fixes: 7ce3c1dd78fca ("nvme-pci: convert the data mapping to blk_rq_dma_map")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f424cfba833e4..993dc5c9cd68c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -827,6 +827,17 @@ static bool nvme_pci_prp_iter_next(struct request *req, struct device *dma_dev,
 	return nvme_pci_prp_save_mapping(req, dma_dev, iter);
 }
 
+static void nvme_unmap_iter(struct request *req, struct blk_dma_iter *iter,
+			    struct dma_iova_state *state)
+{
+	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
+	struct device *dev = nvmeq->dev->dev;
+
+	if (!blk_dma_unmap(req, dev, state, iter->len,
+			   iter->p2pdma.map == PCI_P2PDMA_MAP_BUS_ADDR))
+		dma_unmap_page(dev, iter->addr, iter->len, rq_dma_dir(req));
+}
+
 static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 		struct blk_dma_iter *iter)
 {
@@ -837,8 +848,10 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	unsigned int prp_len, i;
 	__le64 *prp_list;
 
-	if (!nvme_pci_prp_save_mapping(req, nvmeq->dev->dev, iter))
+	if (!nvme_pci_prp_save_mapping(req, nvmeq->dev->dev, iter)) {
+		nvme_unmap_iter(req, iter, &iod->dma_state);
 		return iter->status;
+	}
 
 	/*
 	 * PRP1 always points to the start of the DMA transfers.
@@ -943,6 +956,7 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	dev_err_once(nvmeq->dev->dev,
 		"Incorrectly formed request for payload:%d nents:%d\n",
 		blk_rq_payload_bytes(req), blk_rq_nr_phys_segments(req));
+	nvme_unmap_data(req);
 	return BLK_STS_IOERR;
 }
 
@@ -986,8 +1000,11 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 
 	sg_list = dma_pool_alloc(nvme_dma_pool(nvmeq, iod), GFP_ATOMIC,
 			&sgl_dma);
-	if (!sg_list)
+	if (!sg_list) {
+		nvme_unmap_iter(req, iter, &iod->dma_state);
 		return BLK_STS_RESOURCE;
+	}
+
 	iod->descriptors[iod->nr_descriptors++] = sg_list;
 
 	do {
@@ -1119,8 +1136,10 @@ static blk_status_t nvme_pci_setup_meta_iter(struct request *req)
 
 	sg_list = dma_pool_alloc(nvmeq->descriptor_pools.small, GFP_ATOMIC,
 			&sgl_dma);
-	if (!sg_list)
+	if (!sg_list) {
+		nvme_unmap_iter(req, &iter, &iod->meta_dma_state);
 		return BLK_STS_RESOURCE;
+	}
 
 	iod->meta_descriptor = sg_list;
 	iod->meta_dma = sgl_dma;
-- 
2.53.0



