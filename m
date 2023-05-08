Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7863168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694E6C433EF;
	Mon,  8 May 2023 10:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540560;
	bh=+pahezfLsBF468GwlA4Oz4DSe9oFNT+ZVOBlEo5ZTO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emenuEWvhJzJaHi6dfmFi08RBvdmjfC/ItInpIh9rVHCl9rHXBW33+C8M0zFKEXeI
	 B22AM5sigBF1bZkrffMAQFHfLUFYKw23Vsq65l5Nx5QnIUosawcm0DzVx2qnqtKrkA
	 77FWIKukb/VcbHxP0kYwT975GOUuSXfd3kSO15Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 410/611] spi: imx: Dont skip cleanup in removes error path
Date: Mon,  8 May 2023 11:44:12 +0200
Message-Id: <20230508094435.573408456@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
index d209930069cf3..fbd7b354dd36b 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1864,13 +1864,11 @@ static int spi_imx_remove(struct platform_device *pdev)
 
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



