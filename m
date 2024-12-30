Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD7E537E9;
	Mon, 30 Dec 2024 15:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573584; cv=none; b=MAP0NL/Uof7xIH930pY6f17jbR8vi1hJN4WIWW52n8csCmkhybpM3iC7pDj/J8ZJ5Lt1RZ7CMc5k+lAWBcHcaU+tL7GksXWG71F4VYO2YbZrKm4sTkSOyKS1qxt8BujudVVOFX9CCpKG7nd/EJ1en2zE8BLKKBz7RMgL+B9ot6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573584; c=relaxed/simple;
	bh=frv26Nc95T++ohfuhiVknhTRqHxL53syBsT8hXs7YfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2OnssPi40/yxiVCEUBYu7AXXq0+6BjwknK/KBzBfxAqaNMasoRaWQD8Z0tp35pw+WcYijHQRWSZHZokiOvd0qD50DFfhomusG2CamSZD2Xp+JP0E76OmBbVcx8CLwG7DEiFB14Zc5sGevtIVTs05Jotzkie2xS8BaiMZyXaxyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SN/A6SVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SN/A6SVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CC4C4CED0;
	Mon, 30 Dec 2024 15:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573583;
	bh=frv26Nc95T++ohfuhiVknhTRqHxL53syBsT8hXs7YfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SN/A6SVeIod2y8k4deUdaJ6c5mhGMUUi8zMiJPWHJmFoTHlt6vTl2RyYmcrzCty4K
	 wtF+Xwi0s/CN4jzhxLqyEVCnr5I4MZO5q6ZXsNVdAw5rmHPdJ1/dhrPsKtpKRJ56P+
	 Sx8m6igqk2CZl73XR5dheyZKlvt8khWFnCT2N0fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ferry Toth <fntoth@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 19/60] dmaengine: dw: Select only supported masters for ACPI devices
Date: Mon, 30 Dec 2024 16:42:29 +0100
Message-ID: <20241230154208.016893451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit f0e870a0e9c5521f2952ea9f3ea9d3d122631a89 upstream.

The recently submitted fix-commit revealed a problem in the iDMA 32-bit
platform code. Even though the controller supported only a single master
the dw_dma_acpi_filter() method hard-coded two master interfaces with IDs
0 and 1. As a result the sanity check implemented in the commit
b336268dde75 ("dmaengine: dw: Add peripheral bus width verification")
got incorrect interface data width and thus prevented the client drivers
from configuring the DMA-channel with the EINVAL error returned. E.g.,
the next error was printed for the PXA2xx SPI controller driver trying
to configure the requested channels:

> [  164.525604] pxa2xx_spi_pci 0000:00:07.1: DMA slave config failed
> [  164.536105] pxa2xx_spi_pci 0000:00:07.1: failed to get DMA TX descriptor
> [  164.543213] spidev spi-SPT0001:00: SPI transfer failed: -16

The problem would have been spotted much earlier if the iDMA 32-bit
controller supported more than one master interfaces. But since it
supports just a single master and the iDMA 32-bit specific code just
ignores the master IDs in the CTLLO preparation method, the issue has
been gone unnoticed so far.

Fix the problem by specifying the default master ID for both memory
and peripheral devices in the driver data. Thus the issue noticed for
the iDMA 32-bit controllers will be eliminated and the ACPI-probed
DW DMA controllers will be configured with the correct master ID by
default.

Cc: stable@vger.kernel.org
Fixes: b336268dde75 ("dmaengine: dw: Add peripheral bus width verification")
Fixes: 199244d69458 ("dmaengine: dw: add support of iDMA 32-bit hardware")
Reported-by: Ferry Toth <fntoth@gmail.com>
Closes: https://lore.kernel.org/dmaengine/ZuXbCKUs1iOqFu51@black.fi.intel.com/
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/dmaengine/ZuXgI-VcHpMgbZ91@black.fi.intel.com/
Tested-by: Ferry Toth <fntoth@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20241104095142.157925-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw/acpi.c     |    6 ++++--
 drivers/dma/dw/internal.h |    8 ++++++++
 drivers/dma/dw/pci.c      |    4 ++--
 3 files changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/dma/dw/acpi.c
+++ b/drivers/dma/dw/acpi.c
@@ -8,13 +8,15 @@
 
 static bool dw_dma_acpi_filter(struct dma_chan *chan, void *param)
 {
+	struct dw_dma *dw = to_dw_dma(chan->device);
+	struct dw_dma_chip_pdata *data = dev_get_drvdata(dw->dma.dev);
 	struct acpi_dma_spec *dma_spec = param;
 	struct dw_dma_slave slave = {
 		.dma_dev = dma_spec->dev,
 		.src_id = dma_spec->slave_id,
 		.dst_id = dma_spec->slave_id,
-		.m_master = 0,
-		.p_master = 1,
+		.m_master = data->m_master,
+		.p_master = data->p_master,
 	};
 
 	return dw_dma_filter(chan, &slave);
--- a/drivers/dma/dw/internal.h
+++ b/drivers/dma/dw/internal.h
@@ -51,11 +51,15 @@ struct dw_dma_chip_pdata {
 	int (*probe)(struct dw_dma_chip *chip);
 	int (*remove)(struct dw_dma_chip *chip);
 	struct dw_dma_chip *chip;
+	u8 m_master;
+	u8 p_master;
 };
 
 static __maybe_unused const struct dw_dma_chip_pdata dw_dma_chip_pdata = {
 	.probe = dw_dma_probe,
 	.remove = dw_dma_remove,
+	.m_master = 0,
+	.p_master = 1,
 };
 
 static const struct dw_dma_platform_data idma32_pdata = {
@@ -72,6 +76,8 @@ static __maybe_unused const struct dw_dm
 	.pdata = &idma32_pdata,
 	.probe = idma32_dma_probe,
 	.remove = idma32_dma_remove,
+	.m_master = 0,
+	.p_master = 0,
 };
 
 static const struct dw_dma_platform_data xbar_pdata = {
@@ -88,6 +94,8 @@ static __maybe_unused const struct dw_dm
 	.pdata = &xbar_pdata,
 	.probe = idma32_dma_probe,
 	.remove = idma32_dma_remove,
+	.m_master = 0,
+	.p_master = 0,
 };
 
 #endif /* _DMA_DW_INTERNAL_H */
--- a/drivers/dma/dw/pci.c
+++ b/drivers/dma/dw/pci.c
@@ -56,10 +56,10 @@ static int dw_pci_probe(struct pci_dev *
 	if (ret)
 		return ret;
 
-	dw_dma_acpi_controller_register(chip->dw);
-
 	pci_set_drvdata(pdev, data);
 
+	dw_dma_acpi_controller_register(chip->dw);
+
 	return 0;
 }
 


