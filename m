Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA7D171A4;
	Sat,  3 Feb 2024 04:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933903; cv=none; b=LTXjZ/AhU65CldZo4iVjPDbfPCPr4CGegOr8N6i2HUUiDL+KVzDSDcFNRrSJkTSOQ7sSeNvQEGqssk16SsJ0ic3XHTZh0LJGxHUpMAZ7tXaJuNyphnwZOxBW7QA/UMgOOp0fXxFpQqIeaqM0LJgBW6hjlNzbF/+n7OkEfCeQi/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933903; c=relaxed/simple;
	bh=WIx9SsFNl0VeNJEc5Ls/eBDjJC7lmrCjmITYIjpCjnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmiGziCBTE7LT9S9WcVmGtaprk7F9U6ZcnRHr6gclr+vYwti7X7rJXP4ywHPUGrzUzaSIIlJ9oVmbw3wJbhB5SqhUElXOR4r52c7vTN1nfsDB+rc3VBQ/vMnO5oDY/GrWQ2XJEdlRnDiY2p+idxU8XZ1/w6YYiVTqFBetYWAaQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urrXBMZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urrXBMZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B76C433B1;
	Sat,  3 Feb 2024 04:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933903;
	bh=WIx9SsFNl0VeNJEc5Ls/eBDjJC7lmrCjmITYIjpCjnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urrXBMZSmQTxFI9s0q+Vpca7L6ju56ODOufA16aHa1fsIgDRHbiSOxkP/FlAbGspX
	 rZCZUPUACS/BStcvTt/B5CbRXl/exbBktTVZGkaReqzAp7qn/XbHkuEaqOOpdOESDY
	 0BtQjeCIpvmoQGuU6/AO+AA0fJLPwKtFTv5mwarg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Stodden <dns@arista.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Dmitry Safonov <dima@arista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 251/353] PCI: switchtec: Fix stdev_release() crash after surprise hot remove
Date: Fri,  2 Feb 2024 20:06:09 -0800
Message-ID: <20240203035411.668685003@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Stodden <dns@arista.com>

[ Upstream commit df25461119d987b8c81d232cfe4411e91dcabe66 ]

A PCI device hot removal may occur while stdev->cdev is held open. The call
to stdev_release() then happens during close or exit, at a point way past
switchtec_pci_remove(). Otherwise the last ref would vanish with the
trailing put_device(), just before return.

At that later point in time, the devm cleanup has already removed the
stdev->mmio_mrpc mapping. Also, the stdev->pdev reference was not a counted
one. Therefore, in DMA mode, the iowrite32() in stdev_release() will cause
a fatal page fault, and the subsequent dma_free_coherent(), if reached,
would pass a stale &stdev->pdev->dev pointer.

Fix by moving MRPC DMA shutdown into switchtec_pci_remove(), after
stdev_kill(). Counting the stdev->pdev ref is now optional, but may prevent
future accidents.

Reproducible via the script at
https://lore.kernel.org/r/20231113212150.96410-1-dns@arista.com

Link: https://lore.kernel.org/r/20231122042316.91208-2-dns@arista.com
Signed-off-by: Daniel Stodden <dns@arista.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/switch/switchtec.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index 5b921387eca6..1804794d0e68 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1308,13 +1308,6 @@ static void stdev_release(struct device *dev)
 {
 	struct switchtec_dev *stdev = to_stdev(dev);
 
-	if (stdev->dma_mrpc) {
-		iowrite32(0, &stdev->mmio_mrpc->dma_en);
-		flush_wc_buf(stdev);
-		writeq(0, &stdev->mmio_mrpc->dma_addr);
-		dma_free_coherent(&stdev->pdev->dev, sizeof(*stdev->dma_mrpc),
-				stdev->dma_mrpc, stdev->dma_mrpc_dma_addr);
-	}
 	kfree(stdev);
 }
 
@@ -1358,7 +1351,7 @@ static struct switchtec_dev *stdev_create(struct pci_dev *pdev)
 		return ERR_PTR(-ENOMEM);
 
 	stdev->alive = true;
-	stdev->pdev = pdev;
+	stdev->pdev = pci_dev_get(pdev);
 	INIT_LIST_HEAD(&stdev->mrpc_queue);
 	mutex_init(&stdev->mrpc_mutex);
 	stdev->mrpc_busy = 0;
@@ -1391,6 +1384,7 @@ static struct switchtec_dev *stdev_create(struct pci_dev *pdev)
 	return stdev;
 
 err_put:
+	pci_dev_put(stdev->pdev);
 	put_device(&stdev->dev);
 	return ERR_PTR(rc);
 }
@@ -1644,6 +1638,18 @@ static int switchtec_init_pci(struct switchtec_dev *stdev,
 	return 0;
 }
 
+static void switchtec_exit_pci(struct switchtec_dev *stdev)
+{
+	if (stdev->dma_mrpc) {
+		iowrite32(0, &stdev->mmio_mrpc->dma_en);
+		flush_wc_buf(stdev);
+		writeq(0, &stdev->mmio_mrpc->dma_addr);
+		dma_free_coherent(&stdev->pdev->dev, sizeof(*stdev->dma_mrpc),
+				  stdev->dma_mrpc, stdev->dma_mrpc_dma_addr);
+		stdev->dma_mrpc = NULL;
+	}
+}
+
 static int switchtec_pci_probe(struct pci_dev *pdev,
 			       const struct pci_device_id *id)
 {
@@ -1703,6 +1709,9 @@ static void switchtec_pci_remove(struct pci_dev *pdev)
 	ida_free(&switchtec_minor_ida, MINOR(stdev->dev.devt));
 	dev_info(&stdev->dev, "unregistered.\n");
 	stdev_kill(stdev);
+	switchtec_exit_pci(stdev);
+	pci_dev_put(stdev->pdev);
+	stdev->pdev = NULL;
 	put_device(&stdev->dev);
 }
 
-- 
2.43.0



