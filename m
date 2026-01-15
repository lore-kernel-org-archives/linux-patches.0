Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38EF2D73AB;
	Thu, 15 Jan 2026 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499596; cv=none; b=cT90UMGjkGTClEbIXY8OOa7liAAr6bn01M8YEjab1fe7tnxolAY3tYrIeApOYZQ1jaMxKG92kV5Rk5I2DILC3mS7WPmRoy8l5wh/U0AuLve4WTcPT6atSAfiQ4Ahd6UV+Mv8sSAlsPNCTpUyQPmx9+FQr9ppU0S6vwKCFAUN53o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499596; c=relaxed/simple;
	bh=99EjvocyOPlEBw/Xz0TvSQzhPvzVO4XtCtaqraAWNl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cn6dT3lXLiUOJXShoSYdsKYatmqgW2ZSjZZFPA1dizDHgEIHb1ITHcpn4p16lsgNjGLnL9vti1nJazsuYTk6+coNqUNeBIHyTLdZ3PVhokPM/iQUNRGZZJd/SDQsqmS8y5Y01ArdyPoZElFuqU6Xou2dSlVEsF07/o2vu+SRZhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SqkQ0t8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SqkQ0t8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7F6C116D0;
	Thu, 15 Jan 2026 17:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499596;
	bh=99EjvocyOPlEBw/Xz0TvSQzhPvzVO4XtCtaqraAWNl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SqkQ0t8Mq+RWWnTRlOJs5dKfEkhnBZoTYLmx4fhIJfeNs8A0IE54bnRMtWOXwTwc
	 tTv8LjXZtE37TOhicwR8WAsNqLmRBWqbMH5lxU0/0HxXoImMlBFi5uLGb6y25/QJJZ
	 L3qiRjmXo1e8OoGU+p2+ZumL9YrLU9dIdvz1Wn8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/451] firewire: nosy: switch from pci_ to dma_ API
Date: Thu, 15 Jan 2026 17:48:04 +0100
Message-ID: <20260115164241.121734215@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 01d12a6656f7fa239cddbd713656be83cdbdc9b3 ]

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'add_card()', GFP_KERNEL can be used because
this flag is already used a few lines above and no lock is taken in the
between.

While at it, also remove some useless casting.

@@ @@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@ @@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@ @@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@ @@
-    PCI_DMA_NONE
+    DMA_NONE

@@
expression e1, e2, e3;
@@
-    pci_alloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3;
@@
-    pci_zalloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3, e4;
@@
-    pci_free_consistent(e1, e2, e3, e4)
+    dma_free_coherent(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_single(e1, e2, e3, e4)
+    dma_map_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_single(e1, e2, e3, e4)
+    dma_unmap_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4, e5;
@@
-    pci_map_page(e1, e2, e3, e4, e5)
+    dma_map_page(&e1->dev, e2, e3, e4, e5)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_page(e1, e2, e3, e4)
+    dma_unmap_page(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_sg(e1, e2, e3, e4)
+    dma_map_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_sg(e1, e2, e3, e4)
+    dma_unmap_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
+    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_device(e1, e2, e3, e4)
+    dma_sync_single_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
+    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
+    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_consistent_dma_mask(e1, e2)
+    dma_set_coherent_mask(&e1->dev, e2)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/e1d7fa558f31abf294659a9d4edcc1e4fc065fab.1623590706.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c48c0fd0e196 ("firewire: nosy: Fix dma_free_coherent() size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/nosy.c | 43 +++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
index 42d9f25efc5c..ea31ac7ac1ca 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -513,12 +513,12 @@ remove_card(struct pci_dev *dev)
 		wake_up_interruptible(&client->buffer.wait);
 	spin_unlock_irq(&lynx->client_list_lock);
 
-	pci_free_consistent(lynx->pci_device, sizeof(struct pcl),
-			    lynx->rcv_start_pcl, lynx->rcv_start_pcl_bus);
-	pci_free_consistent(lynx->pci_device, sizeof(struct pcl),
-			    lynx->rcv_pcl, lynx->rcv_pcl_bus);
-	pci_free_consistent(lynx->pci_device, PAGE_SIZE,
-			    lynx->rcv_buffer, lynx->rcv_buffer_bus);
+	dma_free_coherent(&lynx->pci_device->dev, sizeof(struct pcl),
+			  lynx->rcv_start_pcl, lynx->rcv_start_pcl_bus);
+	dma_free_coherent(&lynx->pci_device->dev, sizeof(struct pcl),
+			  lynx->rcv_pcl, lynx->rcv_pcl_bus);
+	dma_free_coherent(&lynx->pci_device->dev, PAGE_SIZE, lynx->rcv_buffer,
+			  lynx->rcv_buffer_bus);
 
 	iounmap(lynx->registers);
 	pci_disable_device(dev);
@@ -534,7 +534,7 @@ add_card(struct pci_dev *dev, const struct pci_device_id *unused)
 	u32 p, end;
 	int ret, i;
 
-	if (pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
+	if (dma_set_mask(&dev->dev, DMA_BIT_MASK(32))) {
 		dev_err(&dev->dev,
 		    "DMA address limits not supported for PCILynx hardware\n");
 		return -ENXIO;
@@ -566,12 +566,16 @@ add_card(struct pci_dev *dev, const struct pci_device_id *unused)
 		goto fail_deallocate_lynx;
 	}
 
-	lynx->rcv_start_pcl = pci_alloc_consistent(lynx->pci_device,
-				sizeof(struct pcl), &lynx->rcv_start_pcl_bus);
-	lynx->rcv_pcl = pci_alloc_consistent(lynx->pci_device,
-				sizeof(struct pcl), &lynx->rcv_pcl_bus);
-	lynx->rcv_buffer = pci_alloc_consistent(lynx->pci_device,
-				RCV_BUFFER_SIZE, &lynx->rcv_buffer_bus);
+	lynx->rcv_start_pcl = dma_alloc_coherent(&lynx->pci_device->dev,
+						 sizeof(struct pcl),
+						 &lynx->rcv_start_pcl_bus,
+						 GFP_KERNEL);
+	lynx->rcv_pcl = dma_alloc_coherent(&lynx->pci_device->dev,
+					   sizeof(struct pcl),
+					   &lynx->rcv_pcl_bus, GFP_KERNEL);
+	lynx->rcv_buffer = dma_alloc_coherent(&lynx->pci_device->dev,
+					      RCV_BUFFER_SIZE,
+					      &lynx->rcv_buffer_bus, GFP_KERNEL);
 	if (lynx->rcv_start_pcl == NULL ||
 	    lynx->rcv_pcl == NULL ||
 	    lynx->rcv_buffer == NULL) {
@@ -669,14 +673,15 @@ add_card(struct pci_dev *dev, const struct pci_device_id *unused)
 
 fail_deallocate_buffers:
 	if (lynx->rcv_start_pcl)
-		pci_free_consistent(lynx->pci_device, sizeof(struct pcl),
-				lynx->rcv_start_pcl, lynx->rcv_start_pcl_bus);
+		dma_free_coherent(&lynx->pci_device->dev, sizeof(struct pcl),
+				  lynx->rcv_start_pcl,
+				  lynx->rcv_start_pcl_bus);
 	if (lynx->rcv_pcl)
-		pci_free_consistent(lynx->pci_device, sizeof(struct pcl),
-				lynx->rcv_pcl, lynx->rcv_pcl_bus);
+		dma_free_coherent(&lynx->pci_device->dev, sizeof(struct pcl),
+				  lynx->rcv_pcl, lynx->rcv_pcl_bus);
 	if (lynx->rcv_buffer)
-		pci_free_consistent(lynx->pci_device, PAGE_SIZE,
-				lynx->rcv_buffer, lynx->rcv_buffer_bus);
+		dma_free_coherent(&lynx->pci_device->dev, PAGE_SIZE,
+				  lynx->rcv_buffer, lynx->rcv_buffer_bus);
 	iounmap(lynx->registers);
 
 fail_deallocate_lynx:
-- 
2.51.0



