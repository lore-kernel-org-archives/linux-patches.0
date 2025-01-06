Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1EE13C3D6;
	Mon,  6 Jan 2025 15:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178821; cv=none; b=ZcieZHMN46wIgW4V53DOXL2v4WlNBESbt0EsOQ1IbaELSDM0lqkVAMQI17uIbMkN22/kUNCV0S6uzhddQA2URZna4lttcm9D40+IepvcUrjaku3ChG0XB4yDwvimFXGZ7DIopOhtFfMdbdV5ITjtE9/lWj2IadDUFi/kt7B9xlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178821; c=relaxed/simple;
	bh=oC6DWaleHqYgzrSFq0QfN58+TMKXxNor94Uk+tWbgCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rliXhEOSfFTuY3o77/FSTpAGYpi4XOD6xhZGo/ouwnZhfBZaLXdI9xo5ktL1B+iQvlDxjim6DNt/mg2eGZzvsfV5qVLa7R7APCAO6q/dMboxFX2j5NXPzgP5sENPHm+tmk06bSfyYIgM5H/mfaQGAVY8E9hRHglQG33y9CoW1Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rh1I3t5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rh1I3t5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65730C4CED2;
	Mon,  6 Jan 2025 15:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178820;
	bh=oC6DWaleHqYgzrSFq0QfN58+TMKXxNor94Uk+tWbgCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rh1I3t5iy6RhXSJ5GqpK174iLAycy+gwVxnsZKTyMBo7s1wIbgt8ELI9fCxo88BiE
	 3DLGBg/IcCyQFaymY6QRa+X0vRIYCa9a0FJc3pLUnoWWwjUJkZaxcrU428s9a6y9Ww
	 EKLpqaxU6sEirUJsdxEr3geE7vleDgKygIAln9X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ferry Toth <fntoth@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 072/168] dmaengine: dw: Select only supported masters for ACPI devices
Date: Mon,  6 Jan 2025 16:16:20 +0100
Message-ID: <20250106151141.185652999@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -60,10 +60,10 @@ static int dw_pci_probe(struct pci_dev *
 	if (ret)
 		return ret;
 
-	dw_dma_acpi_controller_register(chip->dw);
-
 	pci_set_drvdata(pdev, data);
 
+	dw_dma_acpi_controller_register(chip->dw);
+
 	return 0;
 }
 


