Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1E820F98
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8B3C433C7;
	Fri, 21 Jul 2023 19:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966795;
	bh=PSEs42YtM/obmdP9OGaXjEvt9wOXMSBOwCdN9Md7loo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W503JHY8siAyOGkT+AfDPoCoLVHo3rHQyn0uGKRaAK0n9IGpHM3YPgzuPV9nLHpyb
	 VzC3xNb5A2R+yA5FIXOov1CCRpuhlgkWdVjympJbdSwfLpGYXcBpoHhg7mY94PqMmx
	 0DMTKXsBDwN3E+z5bx7U9fm/n2TZi/cEICAFoEAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 442/532] nvme-pci: remove nvme_queue from nvme_iod
Date: Fri, 21 Jul 2023 18:05:46 +0200
Message-ID: <20230721160638.531904205@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit a53232cb3abef51524f06ee9d8fbc3364ad95794 ]

We can get the nvme_queue from the req just as easily, so remove the
duplicate path to the same structure to save some space.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: b8f6446b6853 ("nvme-pci: fix DMA direction of unmapping integrity data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a646757f76b34..26b315c5025ad 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -224,7 +224,6 @@ struct nvme_queue {
 struct nvme_iod {
 	struct nvme_request req;
 	struct nvme_command cmd;
-	struct nvme_queue *nvmeq;
 	bool use_sgl;
 	int aborted;
 	int npages;		/* In the PRP list. 0 means small pool in use */
@@ -422,11 +421,6 @@ static int nvme_init_request(struct blk_mq_tag_set *set, struct request *req,
 {
 	struct nvme_dev *dev = set->driver_data;
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	int queue_idx = (set == &dev->tagset) ? hctx_idx + 1 : 0;
-	struct nvme_queue *nvmeq = &dev->queues[queue_idx];
-
-	BUG_ON(!nvmeq);
-	iod->nvmeq = nvmeq;
 
 	nvme_req(req)->ctrl = &dev->ctrl;
 	nvme_req(req)->cmd = &iod->cmd;
@@ -529,7 +523,7 @@ static void **nvme_pci_iod_list(struct request *req)
 
 static inline bool nvme_pci_use_sgls(struct nvme_dev *dev, struct request *req)
 {
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
 	int nseg = blk_rq_nr_phys_segments(req);
 	unsigned int avg_seg_size;
 
@@ -537,7 +531,7 @@ static inline bool nvme_pci_use_sgls(struct nvme_dev *dev, struct request *req)
 
 	if (!nvme_ctrl_sgl_supported(&dev->ctrl))
 		return false;
-	if (!iod->nvmeq->qid)
+	if (!nvmeq->qid)
 		return false;
 	if (!sgl_threshold || avg_seg_size < sgl_threshold)
 		return false;
@@ -846,6 +840,7 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 	int nr_mapped;
 
 	if (blk_rq_nr_phys_segments(req) == 1) {
+		struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
 		struct bio_vec bv = req_bvec(req);
 
 		if (!is_pci_p2pdma_page(bv.bv_page)) {
@@ -853,7 +848,7 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 				return nvme_setup_prp_simple(dev, req,
 							     &cmnd->rw, &bv);
 
-			if (iod->nvmeq->qid && sgl_threshold &&
+			if (nvmeq->qid && sgl_threshold &&
 			    nvme_ctrl_sgl_supported(&dev->ctrl))
 				return nvme_setup_sgl_simple(dev, req,
 							     &cmnd->rw, &bv);
@@ -963,12 +958,16 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 static void nvme_pci_complete_rq(struct request *req)
 {
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct nvme_dev *dev = iod->nvmeq->dev;
+	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
+	struct nvme_dev *dev = nvmeq->dev;
+
+	if (blk_integrity_rq(req)) {
+	        struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
-	if (blk_integrity_rq(req))
 		dma_unmap_page(dev->dev, iod->meta_dma,
 			       rq_integrity_vec(req)->bv_len, rq_data_dir(req));
+	}
+
 	if (blk_rq_nr_phys_segments(req))
 		nvme_unmap_data(dev, req);
 	nvme_complete_rq(req);
@@ -1194,8 +1193,7 @@ static int adapter_delete_sq(struct nvme_dev *dev, u16 sqid)
 
 static void abort_endio(struct request *req, blk_status_t error)
 {
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct nvme_queue *nvmeq = iod->nvmeq;
+	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
 
 	dev_warn(nvmeq->dev->ctrl.device,
 		 "Abort status: 0x%x", nvme_req(req)->status);
@@ -1249,7 +1247,7 @@ static void nvme_warn_reset(struct nvme_dev *dev, u32 csts)
 static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct nvme_queue *nvmeq = iod->nvmeq;
+	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
 	struct nvme_dev *dev = nvmeq->dev;
 	struct request *abort_req;
 	struct nvme_command cmd = { };
-- 
2.39.2



