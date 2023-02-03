Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFC71FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F39C433EF;
	Fri,  3 Feb 2023 10:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419507;
	bh=z08Ete9BJLhcQxw97ah8s8eVvvnmyKERcvbE0mE76vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jByH/Ie6MgV/403bSdA39zhLd8l/ZE3ACSQliyrFIWlBROqj9KF6fNEQzyUUPp2c
	 gB3b5Ss4TTDJKXoN8QchiXO84gSbM/0J+/WP8FQGyGyi3A3zGtysFNoY+Eaqwn5u8q
	 gSs29gJAZ7BX3fS2SjjQBmkljXhrJwfU4JA4ljXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Swati Agarwal <swati.agarwal@xilinx.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/80] dmaengine: xilinx_dma: Fix devm_platform_ioremap_resource error handling
Date: Fri,  3 Feb 2023 11:12:21 +0100
Message-Id: <20230203101016.334388298@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Swati Agarwal <swati.agarwal@xilinx.com>

[ Upstream commit 91df7751eb890e970afc08f50b8f0fa5ea39e03d ]

Add missing cleanup in devm_platform_ioremap_resource().
When probe fails remove dma channel resources and disable clocks in
accordance with the order of resources allocated .

Signed-off-by: Swati Agarwal <swati.agarwal@xilinx.com>
Link: https://lore.kernel.org/r/20220817061125.4720-2-swati.agarwal@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 596b53ccc36a ("dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 6687cee26843..c56ce7cd1f6f 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2663,9 +2663,10 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 	/* Request and map I/O memory */
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	xdev->regs = devm_ioremap_resource(&pdev->dev, io);
-	if (IS_ERR(xdev->regs))
-		return PTR_ERR(xdev->regs);
-
+	if (IS_ERR(xdev->regs)) {
+		err = PTR_ERR(xdev->regs);
+		goto disable_clks;
+	}
 	/* Retrieve the DMA engine properties from the device tree */
 	xdev->has_sg = of_property_read_bool(node, "xlnx,include-sg");
 	xdev->max_buffer_len = GENMASK(XILINX_DMA_MAX_TRANS_LEN_MAX - 1, 0);
@@ -2759,7 +2760,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 	for_each_child_of_node(node, child) {
 		err = xilinx_dma_child_probe(xdev, child);
 		if (err < 0)
-			goto disable_clks;
+			goto error;
 	}
 
 	if (xdev->dma_config->dmatype == XDMA_TYPE_VDMA) {
@@ -2792,12 +2793,12 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 
 	return 0;
 
-disable_clks:
-	xdma_disable_allclks(xdev);
 error:
 	for (i = 0; i < xdev->nr_channels; i++)
 		if (xdev->chan[i])
 			xilinx_dma_chan_remove(xdev->chan[i]);
+disable_clks:
+	xdma_disable_allclks(xdev);
 
 	return err;
 }
-- 
2.39.0



