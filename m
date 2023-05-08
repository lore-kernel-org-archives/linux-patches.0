Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658481549A
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9FEC4339B;
	Mon,  8 May 2023 11:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544708;
	bh=PkAFS26IckiG+N7LtjU4dEnHOLPcJjweGya5lWBk5hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HR51VFqMtTRwKA4CMxRmNaUPPdMXB/TXabMtNOYMyUA8JBMFg5lmx7SpI2yvZxNKe
	 bBEhrUisdRxz387ocMMEmPGgwwFGW7apOBtNL/8sq6ey0Upeb8a9NwdAhLOCkXxhsx
	 umjLQHHYG2+mwuU7iny9mawFNQPObb+04PFOMOi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 498/694] spi: imx: Dont skip cleanup in removes error path
Date: Mon,  8 May 2023 11:45:33 +0200
Message-Id: <20230508094450.194451937@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 11951c9e3f364d7ae3b568a0e52c8335d43066b5 ]

Returning early in a platform driver's remove callback is wrong. In this
case the dma resources are not released in the error path. this is never
retried later and so this is a permanent leak. To fix this, only skip
hardware disabling if waking the device fails.

Fixes: d593574aff0a ("spi: imx: do not access registers while clocks disabled")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230306065733.2170662-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index e4ccd0c329d06..6c9c87cd14cae 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1856,13 +1856,11 @@ static int spi_imx_remove(struct platform_device *pdev)
 
 	spi_unregister_controller(controller);
 
-	ret = pm_runtime_resume_and_get(spi_imx->dev);
-	if (ret < 0) {
-		dev_err(spi_imx->dev, "failed to enable clock\n");
-		return ret;
-	}
-
-	writel(0, spi_imx->base + MXC_CSPICTRL);
+	ret = pm_runtime_get_sync(spi_imx->dev);
+	if (ret >= 0)
+		writel(0, spi_imx->base + MXC_CSPICTRL);
+	else
+		dev_warn(spi_imx->dev, "failed to enable clock, skip hw disable\n");
 
 	pm_runtime_dont_use_autosuspend(spi_imx->dev);
 	pm_runtime_put_sync(spi_imx->dev);
-- 
2.39.2



