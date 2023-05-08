Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDA8168CD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA7AC433EF;
	Mon,  8 May 2023 11:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544835;
	bh=FmaZI6oxj+HAtRZUH/LG3Gigghas7VGMEt3YkJwI28U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQxBhqDm84OY1QNAUGQYEA7fdxT5ayc1KTJbHkNdoN7hnPrs1Bd8f6WeGyWTdDM5n
	 BDsM3/1DRO2CWPowBB+RZrD/tIpd4XKoN/dxyzdizbQXrIGzn3RFrS3T9xJl2HqGLh
	 dK89mEkdiyX0d05GXUOcI/dWgFysyOLo4lyCwPvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 538/694] spi: cadence-quadspi: fix suspend-resume implementations
Date: Mon,  8 May 2023 11:46:13 +0200
Message-Id: <20230508094451.890296526@linuxfoundation.org>
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

From: Dhruva Gole <d-gole@ti.com>

[ Upstream commit 2087e85bb66ee3652dafe732bb9b9b896229eafc ]

The cadence QSPI driver misbehaves after performing a full system suspend
resume:
...
spi-nor spi0.0: resume() failed
...
This results in a flash connected via OSPI interface after system suspend-
resume to be unusable.
fix these suspend and resume functions.

Fixes: 140623410536 ("mtd: spi-nor: Add driver for Cadence Quad SPI Flash Controller")
Signed-off-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/r/20230417091027.966146-3-d-gole@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1806,17 +1806,30 @@ static int cqspi_remove(struct platform_
 static int cqspi_suspend(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
+	struct spi_master *master = dev_get_drvdata(dev);
+	int ret;
 
+	ret = spi_master_suspend(master);
 	cqspi_controller_enable(cqspi, 0);
-	return 0;
+
+	clk_disable_unprepare(cqspi->clk);
+
+	return ret;
 }
 
 static int cqspi_resume(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
+	struct spi_master *master = dev_get_drvdata(dev);
+
+	clk_prepare_enable(cqspi->clk);
+	cqspi_wait_idle(cqspi);
+	cqspi_controller_init(cqspi);
+
+	cqspi->current_cs = -1;
+	cqspi->sclk = 0;
 
-	cqspi_controller_enable(cqspi, 1);
-	return 0;
+	return spi_master_resume(master);
 }
 
 static const struct dev_pm_ops cqspi__dev_pm_ops = {


