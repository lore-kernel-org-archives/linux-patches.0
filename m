Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA4D339B4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fam92ueq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA38C433C8;
	Mon,  9 Oct 2023 13:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858896;
	bh=wH7ODUTxoi5gY9nKVc6XOe1ujn6t2tlKVERet+Xfwqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fam92ueqR35rdiiTCcadJq2OFfusu0+MN7L5W+s3LQwA0puI8EkQQV+TLnBqYplzP
	 ej7sxdympdTXTuIE0D/MsmQJNY4W30VFVccgjzMSWAYEcNmglKSecmKvSHDrKGOFGk
	 jovKV5RKTL/DToEgv6FXYfdYdxKLIxefJgFzIA5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/226] nvme-pci: factor out a nvme_pci_alloc_dev helper
Date: Mon,  9 Oct 2023 15:01:36 +0200
Message-ID: <20231009130130.280021788@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2e87570be9d2746e7c4e7ab1cc18fd3ca7de2768 ]

Add a helper that allocates the nvme_dev structure up to the point where
we can call nvme_init_ctrl.  This pairs with the free_ctrl method and can
thus be used to cleanup the teardown path and make it more symmetric.

Note that this now calls nvme_init_ctrl a lot earlier during probing,
which also means the per-controller character device shows up earlier.
Due to the controller state no commnds can be send on it, but it might
make sense to delay the cdev registration until nvme_init_ctrl_finish.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by Gerd Bayer <gbayer@linxu.ibm.com>
Stable-dep-of: dad651b2a44e ("nvme-pci: do not set the NUMA node of device if it has none")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 81 +++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 48886355ce90c..c329f73dbbf38 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2572,6 +2572,7 @@ static void nvme_free_tagset(struct nvme_dev *dev)
 	dev->ctrl.tagset = NULL;
 }
 
+/* pairs with nvme_pci_alloc_dev */
 static void nvme_pci_free_ctrl(struct nvme_ctrl *ctrl)
 {
 	struct nvme_dev *dev = to_nvme_dev(ctrl);
@@ -2857,19 +2858,23 @@ static void nvme_async_probe(void *data, async_cookie_t cookie)
 	nvme_put_ctrl(&dev->ctrl);
 }
 
-static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static struct nvme_dev *nvme_pci_alloc_dev(struct pci_dev *pdev,
+		const struct pci_device_id *id)
 {
-	int node, result = -ENOMEM;
-	struct nvme_dev *dev;
 	unsigned long quirks = id->driver_data;
+	int node = dev_to_node(&pdev->dev);
+	struct nvme_dev *dev;
+	int ret = -ENOMEM;
 
-	node = dev_to_node(&pdev->dev);
 	if (node == NUMA_NO_NODE)
 		set_dev_node(&pdev->dev, first_memory_node);
 
 	dev = kzalloc_node(sizeof(*dev), GFP_KERNEL, node);
 	if (!dev)
-		return -ENOMEM;
+		return NULL;
+	INIT_WORK(&dev->ctrl.reset_work, nvme_reset_work);
+	INIT_WORK(&dev->remove_work, nvme_remove_dead_ctrl_work);
+	mutex_init(&dev->shutdown_lock);
 
 	dev->nr_write_queues = write_queues;
 	dev->nr_poll_queues = poll_queues;
@@ -2877,25 +2882,11 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->queues = kcalloc_node(dev->nr_allocated_queues,
 			sizeof(struct nvme_queue), GFP_KERNEL, node);
 	if (!dev->queues)
-		goto free;
+		goto out_free_dev;
 
 	dev->dev = get_device(&pdev->dev);
-	pci_set_drvdata(pdev, dev);
-
-	result = nvme_dev_map(dev);
-	if (result)
-		goto put_pci;
-
-	INIT_WORK(&dev->ctrl.reset_work, nvme_reset_work);
-	INIT_WORK(&dev->remove_work, nvme_remove_dead_ctrl_work);
-	mutex_init(&dev->shutdown_lock);
-
-	result = nvme_setup_prp_pools(dev);
-	if (result)
-		goto unmap;
 
 	quirks |= check_vendor_combination_bug(pdev);
-
 	if (!noacpi && acpi_storage_d3(&pdev->dev)) {
 		/*
 		 * Some systems use a bios work around to ask for D3 on
@@ -2905,34 +2896,54 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			 "platform quirk: setting simple suspend\n");
 		quirks |= NVME_QUIRK_SIMPLE_SUSPEND;
 	}
+	ret = nvme_init_ctrl(&dev->ctrl, &pdev->dev, &nvme_pci_ctrl_ops,
+			     quirks);
+	if (ret)
+		goto out_put_device;
+	return dev;
 
-	result = nvme_pci_alloc_iod_mempool(dev);
+out_put_device:
+	put_device(dev->dev);
+	kfree(dev->queues);
+out_free_dev:
+	kfree(dev);
+	return ERR_PTR(ret);
+}
+
+static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct nvme_dev *dev;
+	int result = -ENOMEM;
+
+	dev = nvme_pci_alloc_dev(pdev, id);
+	if (!dev)
+		return -ENOMEM;
+
+	result = nvme_dev_map(dev);
 	if (result)
-		goto release_pools;
+		goto out_uninit_ctrl;
 
-	result = nvme_init_ctrl(&dev->ctrl, &pdev->dev, &nvme_pci_ctrl_ops,
-			quirks);
+	result = nvme_setup_prp_pools(dev);
+	if (result)
+		goto out_dev_unmap;
+
+	result = nvme_pci_alloc_iod_mempool(dev);
 	if (result)
-		goto release_mempool;
+		goto out_release_prp_pools;
 
 	dev_info(dev->ctrl.device, "pci function %s\n", dev_name(&pdev->dev));
+	pci_set_drvdata(pdev, dev);
 
 	nvme_reset_ctrl(&dev->ctrl);
 	async_schedule(nvme_async_probe, dev);
-
 	return 0;
 
- release_mempool:
-	mempool_destroy(dev->iod_mempool);
- release_pools:
+out_release_prp_pools:
 	nvme_release_prp_pools(dev);
- unmap:
+out_dev_unmap:
 	nvme_dev_unmap(dev);
- put_pci:
-	put_device(dev->dev);
- free:
-	kfree(dev->queues);
-	kfree(dev);
+out_uninit_ctrl:
+	nvme_uninit_ctrl(&dev->ctrl);
 	return result;
 }
 
-- 
2.40.1



