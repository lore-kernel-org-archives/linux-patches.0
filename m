Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D981D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBC1C433C8;
	Wed,  4 Oct 2023 18:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442891;
	bh=VkcDXMeGzYYFb7AUH4+ZsV2rDeD3RYAKkWnCswPvwo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cw5VsrIimcCj/G7h6SkUkBsrOLXvzHMqByGQ72PlJ7OnYuesUqpXE/4HggEjnf0gY
	 US2DFB9TY2v2BDzpC3dAdEGgiGTYUqqveqFottDC+8mptn5zsnjVxHgepsA06Vf6tZ
	 O5nm7ZpipaJltQ49c8wyaN39sHJd1SdMm4hSHYKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/183] nvme-pci: factor the iod mempool creation into a helper
Date: Wed,  4 Oct 2023 19:56:16 +0200
Message-ID: <20231004175210.087357670@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 081a7d958ce4b65f9aab6e70e65b0b2e0b92297c ]

Add a helper to create the iod mempool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by Gerd Bayer <gbayer@linxu.ibm.com>
Stable-dep-of: dad651b2a44e ("nvme-pci: do not set the NUMA node of device if it has none")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index bb3813e8474f4..161cc4cd41fa9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -384,14 +384,6 @@ static int nvme_pci_npages_sgl(void)
 			NVME_CTRL_PAGE_SIZE);
 }
 
-static size_t nvme_pci_iod_alloc_size(void)
-{
-	size_t npages = max(nvme_pci_npages_prp(), nvme_pci_npages_sgl());
-
-	return sizeof(__le64 *) * npages +
-		sizeof(struct scatterlist) * NVME_MAX_SEGS;
-}
-
 static int nvme_admin_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 				unsigned int hctx_idx)
 {
@@ -2662,6 +2654,22 @@ static void nvme_release_prp_pools(struct nvme_dev *dev)
 	dma_pool_destroy(dev->prp_small_pool);
 }
 
+static int nvme_pci_alloc_iod_mempool(struct nvme_dev *dev)
+{
+	size_t npages = max(nvme_pci_npages_prp(), nvme_pci_npages_sgl());
+	size_t alloc_size = sizeof(__le64 *) * npages +
+			    sizeof(struct scatterlist) * NVME_MAX_SEGS;
+
+	WARN_ON_ONCE(alloc_size > PAGE_SIZE);
+	dev->iod_mempool = mempool_create_node(1,
+			mempool_kmalloc, mempool_kfree,
+			(void *)alloc_size, GFP_KERNEL,
+			dev_to_node(dev->dev));
+	if (!dev->iod_mempool)
+		return -ENOMEM;
+	return 0;
+}
+
 static void nvme_free_tagset(struct nvme_dev *dev)
 {
 	if (dev->tagset.tags)
@@ -2963,7 +2971,6 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	int node, result = -ENOMEM;
 	struct nvme_dev *dev;
 	unsigned long quirks = id->driver_data;
-	size_t alloc_size;
 
 	node = dev_to_node(&pdev->dev);
 	if (node == NUMA_NO_NODE)
@@ -3008,21 +3015,9 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		quirks |= NVME_QUIRK_SIMPLE_SUSPEND;
 	}
 
-	/*
-	 * Double check that our mempool alloc size will cover the biggest
-	 * command we support.
-	 */
-	alloc_size = nvme_pci_iod_alloc_size();
-	WARN_ON_ONCE(alloc_size > PAGE_SIZE);
-
-	dev->iod_mempool = mempool_create_node(1, mempool_kmalloc,
-						mempool_kfree,
-						(void *) alloc_size,
-						GFP_KERNEL, node);
-	if (!dev->iod_mempool) {
-		result = -ENOMEM;
+	result = nvme_pci_alloc_iod_mempool(dev);
+	if (result)
 		goto release_pools;
-	}
 
 	result = nvme_init_ctrl(&dev->ctrl, &pdev->dev, &nvme_pci_ctrl_ops,
 			quirks);
-- 
2.40.1



