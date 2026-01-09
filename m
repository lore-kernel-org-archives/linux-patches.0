Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC1833290A;
	Fri,  9 Jan 2026 11:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959356; cv=none; b=APbhladO4rFYHoh6EvZCFGa8b8P6y6v2Ae4kgnRz2WdOd2V2dxmGCbRX4FAhpV41JtbSzMglNzHK+J90tYY5HGUugXcG/auv0LxvoSs8nNgoqfzhpaN2S/5bW1oodAHje6ZEeYoYHsUxCL6iIwRi59wcdAB2LtnqwxhXBWKhyBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959356; c=relaxed/simple;
	bh=xJxiwScoJvHTq0M4eptLbe/PQ91IZQYQjzL/4fmnUyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScmHV33E9Fu8PwnAeP5naeka7wvjcMMB4t7p+BlN2ReaoSzHmG0I5imyGjHkwLWbBIHvg0XKv16jgiidNinAtDQUnKVex5iGIYQ/kwAnXCXiBZ+dORQL6bPRM6wpzVCmL/OzeImC5Gn8/dsFvmaOVEtgfvNPQDe+lpyNFGKawPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FX2m/ZWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FX2m/ZWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8F2C4CEF1;
	Fri,  9 Jan 2026 11:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959356;
	bh=xJxiwScoJvHTq0M4eptLbe/PQ91IZQYQjzL/4fmnUyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FX2m/ZWwi1YXcNlzpK9Yg/MFlTQis9IgXcp7hywA4UKbIUjc7fFDJnjYbpX5iOcoY
	 ArLCcFUB3IyreLVEqLILNXXqyXgslJ8XWEe5liDgiHnujFgEOPtszKcl4uU1I2OZH/
	 rwcEt+qIgNOl1qb32xHVNlTo71Kit1SxnqzLXAoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Robin Gong <yibin.gong@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/737] spi: imx: keep dma request disabled before dma transfer setup
Date: Fri,  9 Jan 2026 12:32:42 +0100
Message-ID: <20260109112134.867837726@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Gong <yibin.gong@nxp.com>

[ Upstream commit 86d57d9c07d54e8cb385ffe800930816ccdba0c1 ]

Since sdma hardware configure postpone to transfer phase, have to disable
dma request before dma transfer setup because there is a hardware
limitation on sdma event enable(ENBLn) as below:

"It is thus essential for the Arm platform to program them before any DMA
 request is triggered to the SDMA, otherwise an unpredictable combination
 of channels may be started."

Signed-off-by: Carlos Song <carlos.song@nxp.com>
Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Link: https://patch.msgid.link/20251024055320.408482-1-carlos.song@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index da4442954375b..76f8747c29432 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -503,9 +503,15 @@ static void mx51_ecspi_trigger(struct spi_imx_data *spi_imx)
 {
 	u32 reg;
 
-	reg = readl(spi_imx->base + MX51_ECSPI_CTRL);
-	reg |= MX51_ECSPI_CTRL_XCH;
-	writel(reg, spi_imx->base + MX51_ECSPI_CTRL);
+	if (spi_imx->usedma) {
+		reg = readl(spi_imx->base + MX51_ECSPI_DMA);
+		reg |= MX51_ECSPI_DMA_TEDEN | MX51_ECSPI_DMA_RXDEN;
+		writel(reg, spi_imx->base + MX51_ECSPI_DMA);
+	} else {
+		reg = readl(spi_imx->base + MX51_ECSPI_CTRL);
+		reg |= MX51_ECSPI_CTRL_XCH;
+		writel(reg, spi_imx->base + MX51_ECSPI_CTRL);
+	}
 }
 
 static void mx51_ecspi_disable(struct spi_imx_data *spi_imx)
@@ -699,7 +705,6 @@ static void mx51_setup_wml(struct spi_imx_data *spi_imx)
 	writel(MX51_ECSPI_DMA_RX_WML(spi_imx->wml - 1) |
 		MX51_ECSPI_DMA_TX_WML(tx_wml) |
 		MX51_ECSPI_DMA_RXT_WML(spi_imx->wml) |
-		MX51_ECSPI_DMA_TEDEN | MX51_ECSPI_DMA_RXDEN |
 		MX51_ECSPI_DMA_RXTDEN, spi_imx->base + MX51_ECSPI_DMA);
 }
 
@@ -1458,6 +1463,8 @@ static int spi_imx_dma_transfer(struct spi_imx_data *spi_imx,
 	reinit_completion(&spi_imx->dma_tx_completion);
 	dma_async_issue_pending(controller->dma_tx);
 
+	spi_imx->devtype_data->trigger(spi_imx);
+
 	transfer_timeout = spi_imx_calculate_timeout(spi_imx, transfer->len);
 
 	/* Wait SDMA to finish the data transfer.*/
-- 
2.51.0



