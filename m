Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A85274FE3;
	Thu, 15 Jan 2026 17:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498893; cv=none; b=RUyBXdipbC3+b/shSQIUrgkJTUSDd+ucDqD8pR7H4yWOZD0pui/b/Y89cM+1FyycvecoM2TyStB0b6RBDWsNCOb2qvUXsjMhNEEn9YMJiuqneFJF2JgJVQOX/rYtTFaiGPPXD/mmXUAvRE5rRuyO2yZcU1tp3303wmOEeIVodok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498893; c=relaxed/simple;
	bh=qjZ6ctmcHXQ4xEQojBzzASC187O2Dz5EN/8XwO9BOHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgTcwKMw2/o6CsE8sKGqPORu61XZrFgciaX4cENUfHGW1q4dnE+IU6cIQY3p2HYleBQUpz1WKO7FzEgptcuFcXmpYWyu6iMvkQJNOMzhxMDXY1TUl67bx0Pbr2JR/Un97A/IUQXc5YS94hBFRH+Bc7uFDGG4zI0xnzxiACOk0+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvElAqfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvElAqfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E457CC116D0;
	Thu, 15 Jan 2026 17:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498893;
	bh=qjZ6ctmcHXQ4xEQojBzzASC187O2Dz5EN/8XwO9BOHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvElAqfllW1A5h1Idkhc927R+dboWIfNzhX2iEm43MA8NcwZPCanfnyoHvVMO46ZL
	 wkNxtrTYTRZtzNlRKXlN95pQPosbjkwMQi74GxlHAX/ipQ3kD6VzCRA76YuYkMrec2
	 CR9TibxNXtMhb3rF/XQzk1wF4Rkf0+NMe30nxo3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Robin Gong <yibin.gong@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/451] spi: imx: keep dma request disabled before dma transfer setup
Date: Thu, 15 Jan 2026 17:43:39 +0100
Message-ID: <20260115164231.547162709@linuxfoundation.org>
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
index f1a0073a8700f..a4e35c2f7d6ed 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -493,9 +493,15 @@ static void mx51_ecspi_trigger(struct spi_imx_data *spi_imx)
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
 
 static void mx51_disable_dma(struct spi_imx_data *spi_imx)
@@ -650,7 +656,6 @@ static void mx51_setup_wml(struct spi_imx_data *spi_imx)
 	writel(MX51_ECSPI_DMA_RX_WML(spi_imx->wml - 1) |
 		MX51_ECSPI_DMA_TX_WML(spi_imx->wml) |
 		MX51_ECSPI_DMA_RXT_WML(spi_imx->wml) |
-		MX51_ECSPI_DMA_TEDEN | MX51_ECSPI_DMA_RXDEN |
 		MX51_ECSPI_DMA_RXTDEN, spi_imx->base + MX51_ECSPI_DMA);
 }
 
@@ -1424,6 +1429,8 @@ static int spi_imx_dma_transfer(struct spi_imx_data *spi_imx,
 	reinit_completion(&spi_imx->dma_tx_completion);
 	dma_async_issue_pending(master->dma_tx);
 
+	spi_imx->devtype_data->trigger(spi_imx);
+
 	transfer_timeout = spi_imx_calculate_timeout(spi_imx, transfer->len);
 
 	/* Wait SDMA to finish the data transfer.*/
-- 
2.51.0



