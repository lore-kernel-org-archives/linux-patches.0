Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CFB1C687;
	Mon,  4 Mar 2024 21:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588115; cv=none; b=WioRugqpjugNwRi8Kufzvf5kAHSZkpAh4e1e9+cp9xC0I0R7mWrApWJgkuQgfTaT/ASxAzB2m29/y1DaQnx/Wv/soOJyd4wtWc8L3JaDyC64TwqielynXZciDtxgU2DkFO40hmdZDJ6ar/L2kUzYXTT+pQeCaySKyJlJY2vDw70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588115; c=relaxed/simple;
	bh=JwSo3bHjgsZFJA79pCypt98drCsDZpD19vima9wIjTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPjqTroC/mV8C5VJn/CIXCdqdMOhczMzNDDM7Sh6KxuHQCbswVbbNfzWMmXafv0NhkenP0R2Idla0H+rb88kkmhaL9oWHUi1Ftvu0muyo2MDYeohQd6YMTQsmdXcW4CBsAdmdLGDGlgYlhUj1ZOvsPApDfPGFHv5Xmro7UtgEhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2u8OOBcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2u8OOBcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061C0C433F1;
	Mon,  4 Mar 2024 21:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588115;
	bh=JwSo3bHjgsZFJA79pCypt98drCsDZpD19vima9wIjTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2u8OOBcUJpPE6X29Em++wrT+ICdCnZezSjtKcCnPNfxzqNIjyZLHTFjHfNnEdhG7k
	 KF1i/nBIMBIqawsZZdf+0DiVxe54I4vgkPdaaSwZ4n0m1FaI3PSseDAqPWFTUcfND9
	 RAnuPjkpeb9LGrv55sNrxbhjdxYQ4J9IMtqk9CVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Curtis Klein <curtis.klein@hpe.com>,
	Yi Zhao <yi.zhao@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 27/42] dmaengine: fsl-qdma: init irq after reg initialization
Date: Mon,  4 Mar 2024 21:23:54 +0000
Message-ID: <20240304211538.551765232@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

From: Curtis Klein <curtis.klein@hpe.com>

commit 87a39071e0b639f45e05d296cc0538eef44ec0bd upstream.

Initialize the qDMA irqs after the registers are configured so that
interrupts that may have been pending from a primary kernel don't get
processed by the irq handler before it is ready to and cause panic with
the following trace:

  Call trace:
   fsl_qdma_queue_handler+0xf8/0x3e8
   __handle_irq_event_percpu+0x78/0x2b0
   handle_irq_event_percpu+0x1c/0x68
   handle_irq_event+0x44/0x78
   handle_fasteoi_irq+0xc8/0x178
   generic_handle_irq+0x24/0x38
   __handle_domain_irq+0x90/0x100
   gic_handle_irq+0x5c/0xb8
   el1_irq+0xb8/0x180
   _raw_spin_unlock_irqrestore+0x14/0x40
   __setup_irq+0x4bc/0x798
   request_threaded_irq+0xd8/0x190
   devm_request_threaded_irq+0x74/0xe8
   fsl_qdma_probe+0x4d4/0xca8
   platform_drv_probe+0x50/0xa0
   really_probe+0xe0/0x3f8
   driver_probe_device+0x64/0x130
   device_driver_attach+0x6c/0x78
   __driver_attach+0xbc/0x158
   bus_for_each_dev+0x5c/0x98
   driver_attach+0x20/0x28
   bus_add_driver+0x158/0x220
   driver_register+0x60/0x110
   __platform_driver_register+0x44/0x50
   fsl_qdma_driver_init+0x18/0x20
   do_one_initcall+0x48/0x258
   kernel_init_freeable+0x1a4/0x23c
   kernel_init+0x10/0xf8
   ret_from_fork+0x10/0x18

Cc: stable@vger.kernel.org
Fixes: b092529e0aa0 ("dmaengine: fsl-qdma: Add qDMA controller driver for Layerscape SoCs")
Signed-off-by: Curtis Klein <curtis.klein@hpe.com>
Signed-off-by: Yi Zhao <yi.zhao@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240201220406.440145-1-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-qdma.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/dma/fsl-qdma.c
+++ b/drivers/dma/fsl-qdma.c
@@ -1203,10 +1203,6 @@ static int fsl_qdma_probe(struct platfor
 	if (!fsl_qdma->queue)
 		return -ENOMEM;
 
-	ret = fsl_qdma_irq_init(pdev, fsl_qdma);
-	if (ret)
-		return ret;
-
 	fsl_qdma->irq_base = platform_get_irq_byname(pdev, "qdma-queue0");
 	if (fsl_qdma->irq_base < 0)
 		return fsl_qdma->irq_base;
@@ -1245,16 +1241,19 @@ static int fsl_qdma_probe(struct platfor
 
 	platform_set_drvdata(pdev, fsl_qdma);
 
-	ret = dma_async_device_register(&fsl_qdma->dma_dev);
+	ret = fsl_qdma_reg_init(fsl_qdma);
 	if (ret) {
-		dev_err(&pdev->dev,
-			"Can't register NXP Layerscape qDMA engine.\n");
+		dev_err(&pdev->dev, "Can't Initialize the qDMA engine.\n");
 		return ret;
 	}
 
-	ret = fsl_qdma_reg_init(fsl_qdma);
+	ret = fsl_qdma_irq_init(pdev, fsl_qdma);
+	if (ret)
+		return ret;
+
+	ret = dma_async_device_register(&fsl_qdma->dma_dev);
 	if (ret) {
-		dev_err(&pdev->dev, "Can't Initialize the qDMA engine.\n");
+		dev_err(&pdev->dev, "Can't register NXP Layerscape qDMA engine.\n");
 		return ret;
 	}
 


