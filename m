Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6F38F58;
	Mon,  4 Mar 2024 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588219; cv=none; b=dWJgwa4BTe95FskDOYOnAikP1am7JivJaH16/9DxK5QTX18P83QwusY5gsihnAdYRrnUKlXQlwP4s8wc75Tx4QLMMl03zwsAzK518PSuNs5ivA1OuUEqwZC5udk3bn2o7hz/bB1udz4ETtdrUp5gWIdUYtwujuvAu9NaMt0PEg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588219; c=relaxed/simple;
	bh=Bjh4fEj/1bfJOi5qR2dBNXQRfGivvBZnse20+TMoJ48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rDODxfY26UFpbsHjGc3U8+24f/TFnAeceAse11cOznuJ4y4yjuPYrtMi56OZtN/7x6XdI5eRheZDNJOFDyUIcxA9laLLPHFTaYRWIuaHGnW1I+nDyg/Unq4JmMt2FlNE7soNym7/rCUBswLy/co7F0mo22/D62qNYo6WLKbdxwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZ3Z1TT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZ3Z1TT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C441FC433C7;
	Mon,  4 Mar 2024 21:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588219;
	bh=Bjh4fEj/1bfJOi5qR2dBNXQRfGivvBZnse20+TMoJ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZ3Z1TT/obhmfgyDJ9B5wHMXSyhGF+cjhzqdMudCWV43Etp3sFrdFF1m7BaVTQC19
	 5Gy46RYR9mU000LvhJUfEYpBy+r6njFR0XnsLf3ldhSaOssml94TNUuET1jGrZj895
	 ZStMMoP357T2Ksl3AYNOdHghCys80WG7qe/vYuic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/143] spi: cadence-qspi: fix pointer reference in runtime PM hooks
Date: Mon,  4 Mar 2024 21:22:07 +0000
Message-ID: <20240304211550.143004007@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2064dc4ea935f..08811577d8f8b 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1904,10 +1904,9 @@ static void cqspi_remove(struct platform_device *pdev)
 static int cqspi_suspend(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
-	struct spi_controller *host = dev_get_drvdata(dev);
 	int ret;
 
-	ret = spi_controller_suspend(host);
+	ret = spi_controller_suspend(cqspi->host);
 	cqspi_controller_enable(cqspi, 0);
 
 	clk_disable_unprepare(cqspi->clk);
@@ -1918,7 +1917,6 @@ static int cqspi_suspend(struct device *dev)
 static int cqspi_resume(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
-	struct spi_controller *host = dev_get_drvdata(dev);
 
 	clk_prepare_enable(cqspi->clk);
 	cqspi_wait_idle(cqspi);
@@ -1927,7 +1925,7 @@ static int cqspi_resume(struct device *dev)
 	cqspi->current_cs = -1;
 	cqspi->sclk = 0;
 
-	return spi_controller_resume(host);
+	return spi_controller_resume(cqspi->host);
 }
 
 static DEFINE_SIMPLE_DEV_PM_OPS(cqspi_dev_pm_ops, cqspi_suspend, cqspi_resume);
-- 
2.43.0



