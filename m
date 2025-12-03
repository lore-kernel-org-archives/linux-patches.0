Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5599432E755;
	Wed,  3 Dec 2025 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777072; cv=none; b=k1crg+vW6coWLOXmayPL49kyOEBO9pY1O6QJcixtWLdOUPFy8Za8CEilubQIZL4H+hp/1S4D3uK1W0U/nXXIIkbUx08CwTDiguIGANYSDgkPpABFeibAWKPQBcR0EwZX+FdpjV7V9EjpIgWthn3NR1Nyh5BdRTwfld7N02sFcNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777072; c=relaxed/simple;
	bh=rYrSznrpTxNa6531TsPz8i9wggolnLqkrSTx5cSi9uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XV4gwXvpNGWM3Um5P6/QnV/wu/qQMlC0Rf6lEjdq9wO9Db+Xk8qUK2kPih+ftjIEnXvegoUyiAUhPq+O7Il95spSLvhSEnL0/m3LeZjSqKRttwVa4fc0PXZgIREw0q3G7ktlp2f8gK9pe1ETlN2tiNOetNEFrusbgOK/ZKZQD/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQLblGjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQLblGjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C955EC4CEF5;
	Wed,  3 Dec 2025 15:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777072;
	bh=rYrSznrpTxNa6531TsPz8i9wggolnLqkrSTx5cSi9uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQLblGjBHU77hd7i0QlmRdFrxekB0276fSl3QOhL0Rs5/gLfMKu+9lqjh/X3UBaAm
	 7YWw95SlMhiRdnWo9uTabhrqT57hl5VvURvBbKiMyO6613yuJRKhFr7dO3vHBinSz8
	 kPNuKnSd1+ka7X00hbhwEo9kkTguYBL8gRALXvEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 040/146] spi: spi-cadence-quadspi: Enable pm runtime earlier to avoid imbalance
Date: Wed,  3 Dec 2025 16:26:58 +0100
Message-ID: <20251203152347.942739962@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anurag Dutta <a-dutta@ti.com>

[ Upstream commit f1eb4e792bb1ee3dcdffa66f8a83a4867cda2dd3 ]

The "probe_setup_failed" label calls pm_runtime_disable(), but
pm_runtime_enable() was placed after a possible jump to this label.
When cqspi_setup_flash() fails, control jumps to the label without
pm_runtime_enable() being called, leading to unbalanced PM runtime
reference counting.

Move pm_runtime_enable() and associated calls above the first
possible branch to "probe_setup_failed" to ensure balanced
enable/disable calls across all error paths.

Fixes: 30dbc1c8d50f ("spi: cadence-qspi: defer runtime support on socfpga if reset bit is enabled")
Signed-off-by: Anurag Dutta <a-dutta@ti.com>
Link: https://patch.msgid.link/20251105161146.2019090-2-a-dutta@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index d7720931403c2..4a5a83dc8fe37 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1981,6 +1981,13 @@ static int cqspi_probe(struct platform_device *pdev)
 	cqspi->current_cs = -1;
 	cqspi->sclk = 0;
 
+	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
+		pm_runtime_enable(dev);
+		pm_runtime_set_autosuspend_delay(dev, CQSPI_AUTOSUSPEND_TIMEOUT);
+		pm_runtime_use_autosuspend(dev);
+		pm_runtime_get_noresume(dev);
+	}
+
 	ret = cqspi_setup_flash(cqspi);
 	if (ret) {
 		dev_err(dev, "failed to setup flash parameters %d\n", ret);
@@ -1998,13 +2005,6 @@ static int cqspi_probe(struct platform_device *pdev)
 			goto probe_dma_failed;
 	}
 
-	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
-		pm_runtime_enable(dev);
-		pm_runtime_set_autosuspend_delay(dev, CQSPI_AUTOSUSPEND_TIMEOUT);
-		pm_runtime_use_autosuspend(dev);
-		pm_runtime_get_noresume(dev);
-	}
-
 	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register SPI ctlr %d\n", ret);
-- 
2.51.0



