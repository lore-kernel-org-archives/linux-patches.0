Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5A11DD0EF;
	Wed, 10 Dec 2025 07:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352023; cv=none; b=EAZ9hpWP+f+8e8kCYdq14N5BN5CRGfaM8dgUQr7EhMnTA6AE3uRk15ALDzElmDkceRUQsnJ8HDxd7KDYubYlfm4r+t2mopSCIBAukyiIRMtASI/mCEUiRD3xgki2FUIkQItDyhSBCmRo0zXLjwXL3KSBjL6G3MmSNxDaL8uwK4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352023; c=relaxed/simple;
	bh=Oh13nmvh0eD3W8bme2BOrSnF4vf+MgoGm6gQvLUXJ08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACwOL+l2nFUr6Dyq3w8s9ilHjoD7wMZe606omqvBDmpMNplFUp337bp2LmrjMqIwBb0GJIDKBV42SFAVEc0QTZOoAhojObAZMRzB+1ERuTa9QCZSo3sRcUvOIA6bH3w5pebet3dBWB5avBC30m7yFI/mtU+ukpJ0QsGg3FABkn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUug7vMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUug7vMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78207C4CEF1;
	Wed, 10 Dec 2025 07:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352022;
	bh=Oh13nmvh0eD3W8bme2BOrSnF4vf+MgoGm6gQvLUXJ08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUug7vMF5OIu91pjORkdiuTHOJ9TgnFy2mZvD/I7BWcxuMnU/Z8SjaypDHAET/bQN
	 l53yCYeDtO0wFmIzmjEwqZcsFfR8V9s/drUmGDfGObM3Zv9jh9bUcaLsmkTkrXMx9W
	 4WRxlR7ILOwVq/gqGRVSWnDiDMeX2qLr38jsR710=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Robin Gong <yibin.gong@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 21/60] spi: imx: keep dma request disabled before dma transfer setup
Date: Wed, 10 Dec 2025 16:29:51 +0900
Message-ID: <20251210072948.356025091@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 155ddeb8fcd46..bbf1fd4fe1e92 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -519,9 +519,15 @@ static void mx51_ecspi_trigger(struct spi_imx_data *spi_imx)
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
@@ -759,7 +765,6 @@ static void mx51_setup_wml(struct spi_imx_data *spi_imx)
 	writel(MX51_ECSPI_DMA_RX_WML(spi_imx->wml - 1) |
 		MX51_ECSPI_DMA_TX_WML(tx_wml) |
 		MX51_ECSPI_DMA_RXT_WML(spi_imx->wml) |
-		MX51_ECSPI_DMA_TEDEN | MX51_ECSPI_DMA_RXDEN |
 		MX51_ECSPI_DMA_RXTDEN, spi_imx->base + MX51_ECSPI_DMA);
 }
 
@@ -1520,6 +1525,8 @@ static int spi_imx_dma_transfer(struct spi_imx_data *spi_imx,
 	reinit_completion(&spi_imx->dma_tx_completion);
 	dma_async_issue_pending(controller->dma_tx);
 
+	spi_imx->devtype_data->trigger(spi_imx);
+
 	transfer_timeout = spi_imx_calculate_timeout(spi_imx, transfer->len);
 
 	/* Wait SDMA to finish the data transfer.*/
-- 
2.51.0



