Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2182349CF0;
	Tue, 16 Jun 2026 19:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636534; cv=none; b=Q+RTARtsUSirMiEV2V0/UpnngZ9/zemI9guJXiHfMWc5Zdm+ObvPJqswdljbNkIrMc/AkB/c8vlxMofafTOhdOgrGYvH3ibQ4Kna4zCT9bSfML+KKhdUbdUmI9DszzCgpqsqyfu1g6CutRU7qLUnLT2dwOyMofGZykmJswPGqco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636534; c=relaxed/simple;
	bh=qGHCzmyMuTfZWX35oHh6h3j1YPUMVsH0NIVX7KhgvVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtOFqKYEzKQXUCIPr/fFIE8e19MbwsHFxERRmpYp9BvJkDl9L0LKequJkRVeYS4YuFRJxLMaaCkEiBS2Y8cJ129TOQk6Ir253C60rgDlSPlnDPYQTCCP73NCi6PAEzS4u8BzjQO5yORDadzi5H5U4XoyF0Zj23IKOA/GMHrczLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUTxXo1d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUTxXo1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61D01F000E9;
	Tue, 16 Jun 2026 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636533;
	bh=4PzeCREHDQkywYT0Kyz/pnKaNObBWzK2YKLqG2QdiQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUTxXo1dNV2ovk9FjR+vyaZbuBujNQ6UZ6aA3eouCSADPzP9Pyw8etcUv4Lv+J3xJ
	 cm6DEqEcEdR3EZfkT4XPh9Mr7VXRdObBMVTZv/WbegrkCT7P4NmncQu6ppiUqbc/Xp
	 MEbtJ7DU/NqwF05rKsHW1FYRAgVIrySv+mQTxBx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/342] spi: ti-qspi: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:14 +0530
Message-ID: <20260616145100.273115285@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 0c18a1bacbb1d8b8aa34d3d004a2cb8226c8b1ea ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Note that the controller is suspended before disabling and releasing
resources since commit 3ac066e2227c ("spi: spi-ti-qspi: Suspend the
queue before removing the device") which avoids issues like unclocked
accesses but prevents SPI device drivers from doing I/O during
deregistration.

Fixes: 3b3a80019ff1 ("spi: ti-qspi: one only one interrupt handler")
Cc: stable@vger.kernel.org	# 3.13
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-24-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ renamed spi_controller_*/host APIs to spi_master_*/master and kept remove() returning int ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-ti-qspi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -895,7 +895,7 @@ no_dma:
 	qspi->mmap_enabled = false;
 	qspi->current_cs = -1;
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (!ret)
 		return 0;
 
@@ -910,17 +910,18 @@ free_master:
 static int ti_qspi_remove(struct platform_device *pdev)
 {
 	struct ti_qspi *qspi = platform_get_drvdata(pdev);
-	int rc;
 
-	rc = spi_master_suspend(qspi->master);
-	if (rc)
-		return rc;
+	spi_master_get(qspi->master);
+
+	spi_unregister_master(qspi->master);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	ti_qspi_dma_cleanup(qspi);
 
+	spi_master_put(qspi->master);
+
 	return 0;
 }
 


