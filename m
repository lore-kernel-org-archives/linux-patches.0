Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D78A168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67C5C433D2;
	Mon,  8 May 2023 10:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540558;
	bh=OtCNLc/mngL2CXfMA9VKZ6YNErKcZjp7hBoFcXf+/mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3q/e4w7d0GMttXOzF2mb4O4oWmYtCmpDc3dAbVbGYpgC2eutbWRk5UGWbqbTsqkf
	 v9qdip0gabgzzoyrgsJ7whwiTMr2ImyNuQCud4a6x1h7I1oy+pSDTW6lYHk9gUg64K
	 3U5hiviC6HFKsEe6BN9VJe7Lgq7tTR2E0JKOULvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 409/611] spi: atmel-quadspi: Free resources even if runtime resume failed in .remove()
Date: Mon,  8 May 2023 11:44:11 +0200
Message-Id: <20230508094435.544529929@linuxfoundation.org>
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

[ Upstream commit 9448bc1dee65f86c0fe64d9dea8b410af0586886 ]

An early error exit in atmel_qspi_remove() doesn't prevent the device
unbind. So this results in an spi controller with an unbound parent
and unmapped register space (because devm_ioremap_resource() is undone).
So using the remaining spi controller probably results in an oops.

Instead unregister the controller unconditionally and only skip hardware
access and clk disable.

Also add a warning about resume failing and return zero unconditionally.
The latter has the only effect to suppress a less helpful error message by
the spi core.

Fixes: 4a2f83b7f780 ("spi: atmel-quadspi: add runtime pm support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/20230317084232.142257-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index f480c7ae93fab..7e05b48dbd71c 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -672,18 +672,28 @@ static int atmel_qspi_remove(struct platform_device *pdev)
 	struct atmel_qspi *aq = spi_controller_get_devdata(ctrl);
 	int ret;
 
-	ret = pm_runtime_resume_and_get(&pdev->dev);
-	if (ret < 0)
-		return ret;
-
 	spi_unregister_controller(ctrl);
-	atmel_qspi_write(QSPI_CR_QSPIDIS, aq, QSPI_CR);
+
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret >= 0) {
+		atmel_qspi_write(QSPI_CR_QSPIDIS, aq, QSPI_CR);
+		clk_disable(aq->qspick);
+		clk_disable(aq->pclk);
+	} else {
+		/*
+		 * atmel_qspi_runtime_{suspend,resume} just disable and enable
+		 * the two clks respectively. So after resume failed these are
+		 * off, and we skip hardware access and disabling these clks again.
+		 */
+		dev_warn(&pdev->dev, "Failed to resume device on remove\n");
+	}
+
+	clk_unprepare(aq->qspick);
+	clk_unprepare(aq->pclk);
 
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 
-	clk_disable_unprepare(aq->qspick);
-	clk_disable_unprepare(aq->pclk);
 	return 0;
 }
 
-- 
2.39.2



