Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681BE17B425;
	Tue, 27 May 2025 17:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366286; cv=none; b=N+EZFHPEcPV7o4jBmkOdS2TNeTA9m22QadopoR+TZOW0NaDgYDt11iicPK3+Qeo2toJXRo9i+PatUMeWgPzpPfqPV9HowxZGOiUUzyq+YD35jIKJzj2RX5FZK4dcQFmafeFpnQyapFF0VAGjF/MP9emT0fLvdHFRGbsc2/uHUYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366286; c=relaxed/simple;
	bh=eGzRJyauqewvL0QgSYH+wtTWvyhIW2go+oVKWllU30c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oH4Ur/+a7Tg70qWzDVooresFycd/y/MnPnfHIBlpw5MRJE7M1jQnQ5sp61XP3rvSvMvADhK0dh7wfJroSQtXPLr7+y/OSg4C3oARSqS0F8F7TySKiI4bz+qZ8oaKBgmrdqEBkA7WPhqDjxF1CVSmSLgcbVvlIsSOcLytk+J7BjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niLWBlds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niLWBlds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A6AC4CEE9;
	Tue, 27 May 2025 17:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366286;
	bh=eGzRJyauqewvL0QgSYH+wtTWvyhIW2go+oVKWllU30c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niLWBldsZLlCpSt0NEkZtCDrmipW3qtARr2FvLLvZnum6rpdk7No5oBtDL0hsGPJ2
	 ETnSJL4t4yDid5Kyc6TkLI8x9YdRCVRhWbvZPVdYCFUw+/nc6pTXFiH1wCWSRIceJn
	 G+Nd/rIEYxq0KKP7pHX334zmxq7sH3/wyTtG9Yx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 007/783] nvmet: pci-epf: Keep completion queues mapped
Date: Tue, 27 May 2025 18:16:44 +0200
Message-ID: <20250527162513.346024912@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit ea7789c1541084a3dae65ffd36778348dd98f61b ]

Instead of mapping and unmapping the completion queues memory to the
host PCI address space whenever nvmet_pci_epf_cq_work() is called, map
a completion queue to the host PCI address space when the completion
queue is created with nvmet_pci_epf_create_cq() and unmap it when the
completion queue is deleted with nvmet_pci_epf_delete_cq().

This removes the completion queue mapping/unmapping from
nvmet_pci_epf_cq_work() and significantly increases performance. For
a single job 4K random read QD=1 workload, the IOPS is increased from
23 KIOPS to 25 KIOPS. Some significant throughput increasde for high
queue depth and large IOs workloads can also be seen.

Since the functions nvmet_pci_epf_map_queue() and
nvmet_pci_epf_unmap_queue() are called respectively only from
nvmet_pci_epf_create_cq() and nvmet_pci_epf_delete_cq(), these functions
are removed and open-coded in their respective call sites.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 85adf2094abb ("nvmet: pci-epf: clear completion queue IRQ flag on delete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pci-epf.c | 63 ++++++++++++++---------------------
 1 file changed, 25 insertions(+), 38 deletions(-)

diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index bc1daa9aede9d..81957b6e84986 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -1264,6 +1264,7 @@ static u16 nvmet_pci_epf_create_cq(struct nvmet_ctrl *tctrl,
 	struct nvmet_pci_epf_ctrl *ctrl = tctrl->drvdata;
 	struct nvmet_pci_epf_queue *cq = &ctrl->cq[cqid];
 	u16 status;
+	int ret;
 
 	if (test_bit(NVMET_PCI_EPF_Q_LIVE, &cq->flags))
 		return NVME_SC_QID_INVALID | NVME_STATUS_DNR;
@@ -1298,6 +1299,24 @@ static u16 nvmet_pci_epf_create_cq(struct nvmet_ctrl *tctrl,
 	if (status != NVME_SC_SUCCESS)
 		goto err;
 
+	/*
+	 * Map the CQ PCI address space and since PCI endpoint controllers may
+	 * return a partial mapping, check that the mapping is large enough.
+	 */
+	ret = nvmet_pci_epf_mem_map(ctrl->nvme_epf, cq->pci_addr, cq->pci_size,
+				    &cq->pci_map);
+	if (ret) {
+		dev_err(ctrl->dev, "Failed to map CQ %u (err=%d)\n",
+			cq->qid, ret);
+		goto err_internal;
+	}
+
+	if (cq->pci_map.pci_size < cq->pci_size) {
+		dev_err(ctrl->dev, "Invalid partial mapping of queue %u\n",
+			cq->qid);
+		goto err_unmap_queue;
+	}
+
 	set_bit(NVMET_PCI_EPF_Q_LIVE, &cq->flags);
 
 	dev_dbg(ctrl->dev, "CQ[%u]: %u entries of %zu B, IRQ vector %u\n",
@@ -1305,6 +1324,10 @@ static u16 nvmet_pci_epf_create_cq(struct nvmet_ctrl *tctrl,
 
 	return NVME_SC_SUCCESS;
 
+err_unmap_queue:
+	nvmet_pci_epf_mem_unmap(ctrl->nvme_epf, &cq->pci_map);
+err_internal:
+	status = NVME_SC_INTERNAL | NVME_STATUS_DNR;
 err:
 	if (test_and_clear_bit(NVMET_PCI_EPF_Q_IRQ_ENABLED, &cq->flags))
 		nvmet_pci_epf_remove_irq_vector(ctrl, cq->vector);
@@ -1322,6 +1345,7 @@ static u16 nvmet_pci_epf_delete_cq(struct nvmet_ctrl *tctrl, u16 cqid)
 	cancel_delayed_work_sync(&cq->work);
 	nvmet_pci_epf_drain_queue(cq);
 	nvmet_pci_epf_remove_irq_vector(ctrl, cq->vector);
+	nvmet_pci_epf_mem_unmap(ctrl->nvme_epf, &cq->pci_map);
 
 	return NVME_SC_SUCCESS;
 }
@@ -1554,36 +1578,6 @@ static void nvmet_pci_epf_free_queues(struct nvmet_pci_epf_ctrl *ctrl)
 	ctrl->cq = NULL;
 }
 
-static int nvmet_pci_epf_map_queue(struct nvmet_pci_epf_ctrl *ctrl,
-				   struct nvmet_pci_epf_queue *queue)
-{
-	struct nvmet_pci_epf *nvme_epf = ctrl->nvme_epf;
-	int ret;
-
-	ret = nvmet_pci_epf_mem_map(nvme_epf, queue->pci_addr,
-				      queue->pci_size, &queue->pci_map);
-	if (ret) {
-		dev_err(ctrl->dev, "Failed to map queue %u (err=%d)\n",
-			queue->qid, ret);
-		return ret;
-	}
-
-	if (queue->pci_map.pci_size < queue->pci_size) {
-		dev_err(ctrl->dev, "Invalid partial mapping of queue %u\n",
-			queue->qid);
-		nvmet_pci_epf_mem_unmap(nvme_epf, &queue->pci_map);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static inline void nvmet_pci_epf_unmap_queue(struct nvmet_pci_epf_ctrl *ctrl,
-					     struct nvmet_pci_epf_queue *queue)
-{
-	nvmet_pci_epf_mem_unmap(ctrl->nvme_epf, &queue->pci_map);
-}
-
 static void nvmet_pci_epf_exec_iod_work(struct work_struct *work)
 {
 	struct nvmet_pci_epf_iod *iod =
@@ -1749,11 +1743,7 @@ static void nvmet_pci_epf_cq_work(struct work_struct *work)
 	struct nvme_completion *cqe;
 	struct nvmet_pci_epf_iod *iod;
 	unsigned long flags;
-	int ret, n = 0;
-
-	ret = nvmet_pci_epf_map_queue(ctrl, cq);
-	if (ret)
-		goto again;
+	int ret = 0, n = 0;
 
 	while (test_bit(NVMET_PCI_EPF_Q_LIVE, &cq->flags) && ctrl->link_up) {
 
@@ -1809,8 +1799,6 @@ static void nvmet_pci_epf_cq_work(struct work_struct *work)
 		n++;
 	}
 
-	nvmet_pci_epf_unmap_queue(ctrl, cq);
-
 	/*
 	 * We do not support precise IRQ coalescing time (100ns units as per
 	 * NVMe specifications). So if we have posted completion entries without
@@ -1819,7 +1807,6 @@ static void nvmet_pci_epf_cq_work(struct work_struct *work)
 	if (n)
 		nvmet_pci_epf_raise_irq(ctrl, cq, true);
 
-again:
 	if (ret < 0)
 		queue_delayed_work(system_highpri_wq, &cq->work,
 				   NVMET_PCI_EPF_CQ_RETRY_INTERVAL);
-- 
2.39.5



