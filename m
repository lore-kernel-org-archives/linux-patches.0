Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C37171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78055C433D2;
	Mon,  8 May 2023 11:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546075;
	bh=CxN+zTFvnnNQwEv4NfpY/dXxqWtK5ISm6llankyqYLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScKfZw48PEiXaJ7H0k08OxasGbLKxfTHjVWnKp3wZbYbE5w9la/SLH1Ek4HMCRKrR
	 MmHPmr1Wnsq3MsCsdKVk6I7NhVAdxPSca/rWZRgjPkkWcihbP7I6q8U99PQQDtegtf
	 6FtFZN2mzAV6CLDJ7CL0kDad9tVPx2hU6aLKdIzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/371] spi: imx: Dont skip cleanup in removes error path
Date: Mon,  8 May 2023 11:47:29 +0200
Message-Id: <20230508094821.912431726@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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
index 980cd168fe4c8..2f06f2840d616 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1769,13 +1769,11 @@ static int spi_imx_remove(struct platform_device *pdev)
 
 	spi_bitbang_stop(&spi_imx->bitbang);
 
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



