Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA157BAE6;
	Mon,  4 Mar 2024 21:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587665; cv=none; b=R6IOJ2xDeq5M2leA8yKa5E22KlxkUJ4P7uTc1DOEKk+hi8cK9404Nh7FtEMjmW3BJfM42Dpd3W9Jt1MCGamAfYtGwJ5tGBqt2ymvq8HCNxTDEbASN9PvZfPSdLozCWGyurBBJEzqzYnH0Amjepm66aytJybZ7m9kidn8P0BZu+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587665; c=relaxed/simple;
	bh=obur7sMhlZOaBv72BMP+9u0eFnuWTQXJSRmOskCCv2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hr5Kfh4tpTPPb/j5cBMRXIyhBwSSz+qdVma9sHgXTsS7mVtTVjTLw8M105OdSWQaBeJd3szXTdz+y8NBfCnLQskVL7CRnBtPCSlmBdyge+uNuz72MVJlOnqY0NDwp+F4LC5E+N1vxFuWm+45ouYHPJ65Qbk2P0PxsVKntB/8ieo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSIwQCVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSIwQCVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C85C43390;
	Mon,  4 Mar 2024 21:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587664;
	bh=obur7sMhlZOaBv72BMP+9u0eFnuWTQXJSRmOskCCv2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSIwQCVPdI4DdBjHTCKZj/9QJMJiKpg4f0WLXHZvspr+btKhxXUJeEBv9mjWVx9+Q
	 hCVE4kl1CgRkrvScbCs0GV+kpFNPZTfQ2krQc22yxIti3xy/+5ctlXBOdqZp3u8ICx
	 kpzLk4PCCbBAS1cF9Qc9FaTngbilvk7Wwy3aTckA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 008/162] spi: cadence-qspi: fix pointer reference in runtime PM hooks
Date: Mon,  4 Mar 2024 21:21:13 +0000
Message-ID: <20240304211552.096332848@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 32ce3bb57b6b402de2aec1012511e7ac4e7449dc ]

dev_get_drvdata() gets used to acquire the pointer to cqspi and the SPI
controller. Neither embed the other; this lead to memory corruption.

On a given platform (Mobileye EyeQ5) the memory corruption is hidden
inside cqspi->f_pdata. Also, this uninitialised memory is used as a
mutex (ctlr->bus_lock_mutex) by spi_controller_suspend().

Fixes: 2087e85bb66e ("spi: cadence-quadspi: fix suspend-resume implementations")
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://msgid.link/r/20240222-cdns-qspi-pm-fix-v4-1-6b6af8bcbf59@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index f94e0d370d466..0d184d65dce76 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1930,10 +1930,9 @@ static void cqspi_remove(struct platform_device *pdev)
 static int cqspi_suspend(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
-	struct spi_controller *host = dev_get_drvdata(dev);
 	int ret;
 
-	ret = spi_controller_suspend(host);
+	ret = spi_controller_suspend(cqspi->host);
 	cqspi_controller_enable(cqspi, 0);
 
 	clk_disable_unprepare(cqspi->clk);
@@ -1944,7 +1943,6 @@ static int cqspi_suspend(struct device *dev)
 static int cqspi_resume(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
-	struct spi_controller *host = dev_get_drvdata(dev);
 
 	clk_prepare_enable(cqspi->clk);
 	cqspi_wait_idle(cqspi);
@@ -1953,7 +1951,7 @@ static int cqspi_resume(struct device *dev)
 	cqspi->current_cs = -1;
 	cqspi->sclk = 0;
 
-	return spi_controller_resume(host);
+	return spi_controller_resume(cqspi->host);
 }
 
 static DEFINE_RUNTIME_DEV_PM_OPS(cqspi_dev_pm_ops, cqspi_suspend,
-- 
2.43.0



