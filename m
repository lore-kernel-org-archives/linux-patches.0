Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903E832ABC0;
	Thu, 28 May 2026 20:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999206; cv=none; b=EFBuxMVRard93L0JZBrcZmmFmo0eR43aeE7b7SfeDKtXOksuGjjGXLqXOD0AQRwtKjd2pVpsNRG9atzBuuhRucLn3SYxHQ2l1PYrGCfdSMxIUxw9dIXIRTAxoIBeXP9UwmrW7VZa3kUy4OIOb41nCO/CAEuQXvKaltpWRmxOl7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999206; c=relaxed/simple;
	bh=eHdlIqDj4pAemVMaLxX5kCBB1m5ThRXJK11PJuRzNT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpTeNzLP9Ep0WuMgG8KrWocTfcZkKB5xaSpHR6MoWUTbjanmrhND7fnLR6l427m12THD/ZcSHUwsUGtCriYrj9wAg9lrJ5LCqaFLrPSsugUZOtPH5E72MTgw+yeRqWZF/tS8SBj/ok+2H33lYF0zoQPtT70dvUy3OHuRlJFlsIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmwwlcd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmwwlcd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6301F000E9;
	Thu, 28 May 2026 20:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999205;
	bh=8q26XA0fye5jf4ML5p7lDGvz3TZWDMDbFdypYjbIYlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmwwlcd5EGX/+w+0Zs1PtRVTUUCegSk7RP6dlsdoytMCpVT70c7Sd5ql8RyprfJ+t
	 JIpIki8Bh1+pIsKCwJOSglD4AZSYx31sForAmmovfes1ZshLp5E3DVFcPdCc8pzI3f
	 F2BSHPEsJTXmVomXiW//707cY1L01IYBLNcq14Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 447/461] nvme-pci: fix dma mapping leak on data setup error
Date: Thu, 28 May 2026 21:49:36 +0200
Message-ID: <20260528194700.474408065@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/nvme/host/pci.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5b998db940bd6..a0e9767bc21e6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -997,6 +997,23 @@ static bool nvme_pci_prp_iter_next(struct request *req, struct device *dma_dev,
 	return nvme_pci_prp_save_mapping(req, dma_dev, iter);
 }
 
+static void nvme_unmap_iter(struct request *req, struct blk_dma_iter *iter,
+			    struct dma_iova_state *state)
+{
+	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
+	struct device *dev = nvmeq->dev->dev;
+
+	if (!blk_rq_dma_unmap(req, dev, state, iter->len, iter->p2pdma.map)) {
+		unsigned int attrs = 0;
+
+		if (iter->p2pdma.map == PCI_P2PDMA_MAP_THRU_HOST_BRIDGE)
+			attrs |= DMA_ATTR_MMIO;
+
+		dma_unmap_phys(dev, iter->addr, iter->len, rq_dma_dir(req),
+			       attrs);
+	}
+}
+
 static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 		struct blk_dma_iter *iter)
 {
@@ -1007,8 +1024,10 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	unsigned int prp_len, i;
 	__le64 *prp_list;
 
-	if (!nvme_pci_prp_save_mapping(req, nvmeq->dev->dev, iter))
+	if (!nvme_pci_prp_save_mapping(req, nvmeq->dev->dev, iter)) {
+		nvme_unmap_iter(req, iter, &iod->dma_state);
 		return iter->status;
+	}
 
 	/*
 	 * PRP1 always points to the start of the DMA transfers.
@@ -1113,6 +1132,7 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	dev_err_once(nvmeq->dev->dev,
 		"Incorrectly formed request for payload:%d nents:%d\n",
 		blk_rq_payload_bytes(req), blk_rq_nr_phys_segments(req));
+	nvme_unmap_data(req);
 	return BLK_STS_IOERR;
 }
 
@@ -1156,8 +1176,11 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 
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
@@ -1314,8 +1337,10 @@ static blk_status_t nvme_pci_setup_meta_iter(struct request *req)
 
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



