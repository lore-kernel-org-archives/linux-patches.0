Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055582;
	b=jq6SSX8B4OsIMyTV0FgJRfIQ5r73TZgtUbvnW9Rq8ixFfsNmctkeSIiMWxmegbQa1bcg
	 padyvWYM3tMR2VwwTf5t1AaLH/x1TLyzf6WBwP5TKJW0mjU87JPaztHt8c8d19IBYuDCW
	 t0Odxt9VJUqW/YYm+COt15dkZ0ACt2QDahZDaetcByJ5/ptfVuDzfeEXekgVMNQeAs2G/
	 RAUvSOFKZpboeVv1dufdFaJ5XDaWkLemHzM4+J1Ye8/bFhnHDx7FZpDVlpZ/4j+fnae8N
	 v1CgDEpNvUyyUf4Cj3S15puq9g15v4MoBVgopj+bk5s3xzluSvXR40CoLVsYuxgLN6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3GkRFvB6TeKMbUnQKBloPWtpPaMVxGGg4MAIm3RHigw=;
	b=pav9SpgCmeZhmvYe0A4zUlFAcBpo2BfVAU15EDPaki2CvBiWd/6Sv698mgm08Pn01rr0
	 OY7BnMRlNvJ4lcvt/9gOlE98+fv9SJn41+EbOGx8geVdrDSVpYDmvtJU3WuAJFzxuCPW3
	 1TmznUlyuJqvFkyZP+/iUPmUncPrwEt7PTsXPwmNqcsgKXopgSnfaG+T41CWEjheEyifQ
	 9CCaJdqD/Eauwowfsua8PL7KsGJ4J9Yjp/vz/1FSzhRIkGh3iOp60G0QASzmflJikznOv
	 9EYJq4ruIaHbTOxEA4FeGDe0/4bWHvkAfMWdFVwHw65JLDuFpmxUnHlG8egDlEcxwHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fbpi4dqp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1843A60A260F;
	Thu, 19 Nov 2026 02:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fbpi4dqp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346DD1F000C4;
	Thu, 19 Nov 2026 02:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055581;
	bh=3GkRFvB6TeKMbUnQKBloPWtpPaMVxGGg4MAIm3RHigw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbpi4dqpS+h6JYrZpbGFIMkzueJMiGQWHyiAB5Vcnzh8tbD9L02LHafOOlM07MlLr
	 VKVe+SW90XJMQFIBA3H4SVoKaioEC21gyusE4qt2m6XmA+WDP8kVCX4w72LxZ8uIYw
	 P9LlQud5byvrhk1QqtoxQykfzKCg7ltkjxB9sk34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1643/2214] spi: rspi: Fix DMA mode when the DMA controller is built as a module
Date: Wed, 18 Nov 2026 15:55:19 +0100
Message-ID: <20261118150117.647745720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit 7b85114d47f693b709b2e8e22e44cdf58c04b111 ]

On the Renesas RZ/G2L platform, the RSPI driver falls back to PIO mode
instead of using DMA when the DMA controller driver is built as a module
(CONFIG_RZ_DMAC=m):

    renesas_spi 1004b000.spi: dma_request_slave_channel_compat failed
    renesas_spi 1004b000.spi: DMA not available, using PIO

The driver requests DMA channels through dma_request_slave_channel_compat()
which returns either a valid pointer or NULL and cannot handle
-EPROBE_DEFER. If the DMA controller has not probed yet, the driver falls
back to PIO directly.

Fix this by replacing the dma_request_slave_channel_compat() call with a
regular dma_request_chan() call. dma_request_slave_channel_compat() is
always passed a NULL fn_param in all code paths, so it actually behaves
like a plain dma_request_chan() call.

Fixes: e825b8dd2b36 ("spi: rspi: Add DT support to DMA setup")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Link: https://patch.msgid.link/20260921195943.107247-1-ovidiu.panait.rb@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rspi.c | 49 ++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index ec5b98ac3a223..ab42104f1e718 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -22,7 +22,6 @@
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
-#include <linux/sh_dma.h>
 #include <linux/spi/spi.h>
 #include <linux/spinlock.h>
 
@@ -1091,24 +1090,15 @@ static irqreturn_t rspi_irq_tx(int irq, void *_sr)
 
 static struct dma_chan *rspi_request_dma_chan(struct device *dev,
 					      enum dma_transfer_direction dir,
-					      unsigned int id,
 					      dma_addr_t port_addr)
 {
-	dma_cap_mask_t mask;
 	struct dma_chan *chan;
 	struct dma_slave_config cfg;
 	int ret;
 
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-
-	chan = dma_request_slave_channel_compat(mask, shdma_chan_filter,
-				(void *)(unsigned long)id, dev,
-				dir == DMA_MEM_TO_DEV ? "tx" : "rx");
-	if (!chan) {
-		dev_warn(dev, "dma_request_slave_channel_compat failed\n");
-		return NULL;
-	}
+	chan = dma_request_chan(dev, dir == DMA_MEM_TO_DEV ? "tx" : "rx");
+	if (IS_ERR(chan))
+		return chan;
 
 	memset(&cfg, 0, sizeof(cfg));
 	cfg.dst_addr = port_addr + RSPI_SPDR;
@@ -1121,7 +1111,7 @@ static struct dma_chan *rspi_request_dma_chan(struct device *dev,
 	if (ret) {
 		dev_warn(dev, "dmaengine_slave_config failed %d\n", ret);
 		dma_release_channel(chan);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	return chan;
@@ -1130,29 +1120,23 @@ static struct dma_chan *rspi_request_dma_chan(struct device *dev,
 static int rspi_request_dma(struct device *dev, struct spi_controller *ctlr,
 			    const struct resource *res)
 {
-	unsigned int dma_tx_id, dma_rx_id;
+	struct dma_chan *chan;
 
-	if (dev->of_node) {
-		/* In the OF case we will get the slave IDs from the DT */
-		dma_tx_id = 0;
-		dma_rx_id = 0;
-	} else {
-		/* The driver assumes no error. */
+	if (!dev->of_node)
 		return 0;
-	}
 
-	ctlr->dma_tx = rspi_request_dma_chan(dev, DMA_MEM_TO_DEV, dma_tx_id,
-					     res->start);
-	if (!ctlr->dma_tx)
-		return -ENODEV;
+	chan = rspi_request_dma_chan(dev, DMA_MEM_TO_DEV, res->start);
+	if (IS_ERR(chan))
+		return PTR_ERR(chan);
+	ctlr->dma_tx = chan;
 
-	ctlr->dma_rx = rspi_request_dma_chan(dev, DMA_DEV_TO_MEM, dma_rx_id,
-					     res->start);
-	if (!ctlr->dma_rx) {
+	chan = rspi_request_dma_chan(dev, DMA_DEV_TO_MEM, res->start);
+	if (IS_ERR(chan)) {
 		dma_release_channel(ctlr->dma_tx);
 		ctlr->dma_tx = NULL;
-		return -ENODEV;
+		return PTR_ERR(chan);
 	}
+	ctlr->dma_rx = chan;
 
 	ctlr->can_dma = rspi_can_dma;
 	dev_info(dev, "DMA available");
@@ -1377,6 +1361,11 @@ static int rspi_probe(struct platform_device *pdev)
 	}
 
 	ret = rspi_request_dma(&pdev->dev, ctlr, res);
+	if (ret == -EPROBE_DEFER) {
+		dev_err_probe(&pdev->dev, ret,
+			      "failed to request DMA channels\n");
+		goto error2;
+	}
 	if (ret < 0)
 		dev_warn(&pdev->dev, "DMA not available, using PIO\n");
 
-- 
2.53.0



