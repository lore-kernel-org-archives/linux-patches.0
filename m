Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED30618A922;
	Mon, 28 Oct 2024 06:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098167; cv=none; b=cZyIG1GjT0hRf8mDGjJXQHXcMC8VRgZLAjWxhbCdRldDUaO5MKDAi5DkGjptvHK/O8EGpqdz8MU3ea6HCNsj57488zyJTjhDeZXnLLHYm/8q/nl4SXhMIbklWt95luo5lAtZjOJEvAiPcaOhhQQj/oD3WSWEx2zYWtmBz1z/uFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098167; c=relaxed/simple;
	bh=L885g8ybO95FJt3A6PADSTTSeqSpTN4r1wpEA7gArCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAowkgln6gWXygOVeHVzjw23tr8kUmLRW3L/wRlzHS43ilWnzGMc1DJ804DGqkNcxnF6AV+WnBZNeJOqOGUBooSj3WdpRAKUTLWAeYrNW+a8t8huivFu9wPzojybzPBKPjqRHdeVW0GSgiRrJvUNZlmSllI74KhTbtVj7WTUBdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0A5PTZbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0A5PTZbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E17C4CEC3;
	Mon, 28 Oct 2024 06:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098166;
	bh=L885g8ybO95FJt3A6PADSTTSeqSpTN4r1wpEA7gArCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0A5PTZbd9jaElmLwmRPkpszjchByW3osErRzu5UeC6Ji2XM4r2KWaJLDKGzp7O+9r
	 TMS6OZ9L4x1p2eJVi9n/uJ7Z4FBD/DQo1xjONg/1saIuyU4kcFQ4ZzwWIneZkr6ry2
	 QzJjFpUL/EarSe9su0cn8WyRw5BAnWV98Rdm9hrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 107/261] nvme-pci: fix race condition between reset and nvme_dev_disable()
Date: Mon, 28 Oct 2024 07:24:09 +0100
Message-ID: <20241028062314.711092856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 26bc0a81f64ce00fc4342c38eeb2eddaad084dd2 ]

nvme_dev_disable() modifies the dev->online_queues field, therefore
nvme_pci_update_nr_queues() should avoid racing against it, otherwise
we could end up passing invalid values to blk_mq_update_nr_hw_queues().

 WARNING: CPU: 39 PID: 61303 at drivers/pci/msi/api.c:347
          pci_irq_get_affinity+0x187/0x210
 Workqueue: nvme-reset-wq nvme_reset_work [nvme]
 RIP: 0010:pci_irq_get_affinity+0x187/0x210
 Call Trace:
  <TASK>
  ? blk_mq_pci_map_queues+0x87/0x3c0
  ? pci_irq_get_affinity+0x187/0x210
  blk_mq_pci_map_queues+0x87/0x3c0
  nvme_pci_map_queues+0x189/0x460 [nvme]
  blk_mq_update_nr_hw_queues+0x2a/0x40
  nvme_reset_work+0x1be/0x2a0 [nvme]

Fix the bug by locking the shutdown_lock mutex before using
dev->online_queues. Give up if nvme_dev_disable() is running or if
it has been executed already.

Fixes: 949928c1c731 ("NVMe: Fix possible queue use after freed")
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 7990c3f22ecf6..4b9fda0b1d9a3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2506,17 +2506,29 @@ static unsigned int nvme_pci_nr_maps(struct nvme_dev *dev)
 	return 1;
 }
 
-static void nvme_pci_update_nr_queues(struct nvme_dev *dev)
+static bool nvme_pci_update_nr_queues(struct nvme_dev *dev)
 {
 	if (!dev->ctrl.tagset) {
 		nvme_alloc_io_tag_set(&dev->ctrl, &dev->tagset, &nvme_mq_ops,
 				nvme_pci_nr_maps(dev), sizeof(struct nvme_iod));
-		return;
+		return true;
+	}
+
+	/* Give up if we are racing with nvme_dev_disable() */
+	if (!mutex_trylock(&dev->shutdown_lock))
+		return false;
+
+	/* Check if nvme_dev_disable() has been executed already */
+	if (!dev->online_queues) {
+		mutex_unlock(&dev->shutdown_lock);
+		return false;
 	}
 
 	blk_mq_update_nr_hw_queues(&dev->tagset, dev->online_queues - 1);
 	/* free previously allocated queues that are no longer usable */
 	nvme_free_queues(dev, dev->online_queues);
+	mutex_unlock(&dev->shutdown_lock);
+	return true;
 }
 
 static int nvme_pci_enable(struct nvme_dev *dev)
@@ -2797,7 +2809,8 @@ static void nvme_reset_work(struct work_struct *work)
 		nvme_dbbuf_set(dev);
 		nvme_unquiesce_io_queues(&dev->ctrl);
 		nvme_wait_freeze(&dev->ctrl);
-		nvme_pci_update_nr_queues(dev);
+		if (!nvme_pci_update_nr_queues(dev))
+			goto out;
 		nvme_unfreeze(&dev->ctrl);
 	} else {
 		dev_warn(dev->ctrl.device, "IO queues lost\n");
-- 
2.43.0



