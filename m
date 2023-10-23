Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4861E15EA5
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTkFLpd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B370CC433C7;
	Mon, 23 Oct 2023 11:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061382;
	bh=Kmktf8a95zWsFQBZlH+ubMGadE9eZwO3839XqvOyfqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTkFLpd9zWI9mmwq8fddNEQHcxiE8jswEtNlKck6f9qJhX8OOlhAHlah/A48MhNVw
	 MyLKckh0bX6CtJ11G6uBngYScN+NsjYE9TU547Scyc5IvYLIgP8ab6fI9a1Z8cfB2W
	 IdOTYCmgszt7UXKMSVJ3CZEuzvcYTW9efdAauSS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/202] Revert "spi: spi-zynqmp-gqspi: Fix runtime PM imbalance in zynqmp_qspi_probe"
Date: Mon, 23 Oct 2023 12:55:35 +0200
Message-ID: <20231023104827.426892974@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

This reverts commit 2cdec9c13f81313dd9f41f09c7cdecbfa4bea91d.

Reported issues with the backport, revert for now.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index ed68e237314fb..3d3ac48243ebd 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1147,16 +1147,11 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
-
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to pm_runtime_get_sync: %d\n", ret);
-		goto clk_dis_all;
-	}
-
 	/* QSPI controller initializations */
 	zynqmp_qspi_init_hw(xqspi);
 
+	pm_runtime_mark_last_busy(&pdev->dev);
+	pm_runtime_put_autosuspend(&pdev->dev);
 	xqspi->irq = platform_get_irq(pdev, 0);
 	if (xqspi->irq <= 0) {
 		ret = -ENXIO;
@@ -1183,7 +1178,6 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	ctlr->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL | SPI_RX_QUAD |
 			    SPI_TX_DUAL | SPI_TX_QUAD;
 	ctlr->dev.of_node = np;
-	ctlr->auto_runtime_pm = true;
 
 	ret = devm_spi_register_controller(&pdev->dev, ctlr);
 	if (ret) {
@@ -1191,13 +1185,9 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 		goto clk_dis_all;
 	}
 
-	pm_runtime_mark_last_busy(&pdev->dev);
-	pm_runtime_put_autosuspend(&pdev->dev);
-
 	return 0;
 
 clk_dis_all:
-	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	clk_disable_unprepare(xqspi->refclk);
-- 
2.40.1



