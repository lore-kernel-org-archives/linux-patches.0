Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D76BFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED4CC433EF;
	Mon, 15 May 2023 16:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168953;
	bh=p5zsU5kZrxZpViCNFvKDg1mDCLuxn649sm/xwYbrpAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noed4WteVt9m0SFZxzJxJfWgItQIdlkZD0144/o7YdEeUY6F7zaLrig8JRcSiUOfT
	 lbCgls3jO2/6Isx+QWTSvLceM/lnyjTSkw/xaKMd33lvVFeXdd+V57k/KWTX/bcJvS
	 ozl5MwsnKBeDnyRL+8xSdJZQnvtgc33s1HOnbf44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/191] spi: qup: Dont skip cleanup in removes error path
Date: Mon, 15 May 2023 18:25:24 +0200
Message-Id: <20230515161710.430919100@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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

[ Upstream commit 61f49171a43ab1f80c73c5c88c508770c461e0f2 ]

Returning early in a platform driver's remove callback is wrong. In this
case the dma resources are not released in the error path. this is never
retried later and so this is a permanent leak. To fix this, only skip
hardware disabling if waking the device fails.

Fixes: 64ff247a978f ("spi: Add Qualcomm QUP SPI controller support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230330210341.2459548-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qup.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index e8009f8c212c0..defe959884dae 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1249,18 +1249,22 @@ static int spi_qup_remove(struct platform_device *pdev)
 	struct spi_qup *controller = spi_master_get_devdata(master);
 	int ret;
 
-	ret = pm_runtime_resume_and_get(&pdev->dev);
-	if (ret < 0)
-		return ret;
+	ret = pm_runtime_get_sync(&pdev->dev);
 
-	ret = spi_qup_set_state(controller, QUP_STATE_RESET);
-	if (ret)
-		return ret;
+	if (ret >= 0) {
+		ret = spi_qup_set_state(controller, QUP_STATE_RESET);
+		if (ret)
+			dev_warn(&pdev->dev, "failed to reset controller (%pe)\n",
+				 ERR_PTR(ret));
 
-	spi_qup_release_dma(master);
+		clk_disable_unprepare(controller->cclk);
+		clk_disable_unprepare(controller->iclk);
+	} else {
+		dev_warn(&pdev->dev, "failed to resume, skip hw disable (%pe)\n",
+			 ERR_PTR(ret));
+	}
 
-	clk_disable_unprepare(controller->cclk);
-	clk_disable_unprepare(controller->iclk);
+	spi_qup_release_dma(master);
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.39.2



