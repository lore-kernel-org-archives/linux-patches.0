Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196E23925B
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE8CC433EF;
	Wed,  7 Jun 2023 20:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169126;
	bh=8benZ98uBA14ERcJvDswwwXXMdd86DiMEZYqyLhDmvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrPaq9nH9fPcw9U4lqkea6TQJxZg2W8IaeAvgp1T34VJo4yQeftm3stPopMCTYOjr
	 1HwEetYnptF9SoM/tGYLTN3FDXiHHZvkTm77EZfxu247xnSmIq1nW1erPTauB9H1ap
	 NpY4vZce5hJSGM24Wja0vY88LGhJnZ5Ls+Hl8aZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/61] media: netup_unidvb: fix irq init by register it at the end of probe
Date: Wed,  7 Jun 2023 22:15:38 +0200
Message-ID: <20230607200843.510260428@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200835.310274198@linuxfoundation.org>
References: <20230607200835.310274198@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Chen <harperchen1110@gmail.com>

[ Upstream commit e6ad6233592593079db5c8fa592c298e51bc1356 ]

IRQ handler netup_spi_interrupt() takes spinlock spi->lock. The lock
is initialized in netup_spi_init(). However, irq handler is registered
before initializing the lock.

Spinlock dma->lock and i2c->lock suffer from the same problem.

Fix this by registering the irq at the end of probe.

Link: https://lore.kernel.org/linux-media/20230315134518.1074497-1-harperchen1110@gmail.com
Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/pci/netup_unidvb/netup_unidvb_core.c  | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 4f2ea0f035ae5..0a9086f8c759d 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -897,12 +897,7 @@ static int netup_unidvb_initdev(struct pci_dev *pci_dev,
 		ndev->lmmio0, (u32)pci_resource_len(pci_dev, 0),
 		ndev->lmmio1, (u32)pci_resource_len(pci_dev, 1),
 		pci_dev->irq);
-	if (request_irq(pci_dev->irq, netup_unidvb_isr, IRQF_SHARED,
-			"netup_unidvb", pci_dev) < 0) {
-		dev_err(&pci_dev->dev,
-			"%s(): can't get IRQ %d\n", __func__, pci_dev->irq);
-		goto irq_request_err;
-	}
+
 	ndev->dma_size = 2 * 188 *
 		NETUP_DMA_BLOCKS_COUNT * NETUP_DMA_PACKETS_COUNT;
 	ndev->dma_virt = dma_alloc_coherent(&pci_dev->dev,
@@ -943,6 +938,14 @@ static int netup_unidvb_initdev(struct pci_dev *pci_dev,
 		dev_err(&pci_dev->dev, "netup_unidvb: DMA setup failed\n");
 		goto dma_setup_err;
 	}
+
+	if (request_irq(pci_dev->irq, netup_unidvb_isr, IRQF_SHARED,
+			"netup_unidvb", pci_dev) < 0) {
+		dev_err(&pci_dev->dev,
+			"%s(): can't get IRQ %d\n", __func__, pci_dev->irq);
+		goto dma_setup_err;
+	}
+
 	dev_info(&pci_dev->dev,
 		"netup_unidvb: device has been initialized\n");
 	return 0;
@@ -961,8 +964,6 @@ static int netup_unidvb_initdev(struct pci_dev *pci_dev,
 	dma_free_coherent(&pci_dev->dev, ndev->dma_size,
 			ndev->dma_virt, ndev->dma_phys);
 dma_alloc_err:
-	free_irq(pci_dev->irq, pci_dev);
-irq_request_err:
 	iounmap(ndev->lmmio1);
 pci_bar1_error:
 	iounmap(ndev->lmmio0);
-- 
2.39.2



