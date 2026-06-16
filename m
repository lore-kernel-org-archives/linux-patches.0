Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2A838C437;
	Tue, 16 Jun 2026 18:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634698; cv=none; b=ZiOxfRbMA2rLqulKnxInnk87Yw8sq6WMU4zI2iATilyJy60PjyxHBy9itcxqijPiwZ/AW26z5g8V1GM3cEouw2FChgHRGaLu4rhXc35dlxObnN5uTm8VMGD7KYcpmuvnBbMsOH2kmzfwW7y8qSdwkDNnn3HuqJjqe7oUn4pMDdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634698; c=relaxed/simple;
	bh=UwN4BcaZljsgP5O1S5J4PPZttH9YVZVmtHhcxwRglMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsj2uVPlQuhSN72m/Kndx0zfFjjvdhVHXHJBMLoQ/oYd83/GMYkdG1KFrdxREvwdeoHwrK9afLbSsOeKPRdadwNfFDDFR7HO5qwUu7dEWh+T/l0htTx/TJ3ohS1YaArKsbARltLsm7VUH4Issh7YlsJq9Guv/D4WKz0DLHDFbwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVgU2R1R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVgU2R1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FD21F000E9;
	Tue, 16 Jun 2026 18:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634696;
	bh=P3eV1OZFduSYBhs0x4ONE3YqfdrFa26OWzVguDfXSBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVgU2R1RvydFMcHc4rga7t2iaie5wXKi+VaigVj8jVX1y3NjCrrzLwJwkWVvoeadu
	 j1SA7x2qe6B55NtmWZoWsVSrY/IOIh6K5/ZVC+2pWa7KkdnzvoGP8SYwVO/ELGEIxP
	 UYHGTCO/uGMt26R92ydlPGsYNJ4utTz1eExLY+WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 314/411] spi: ti-qspi: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:12 +0530
Message-ID: <20260616145117.830218630@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ renamed spi_controller_* API calls to legacy spi_master_* equivalents and qspi->host to qspi->master ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-ti-qspi.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -895,7 +895,7 @@ no_dma:
 	qspi->mmap_enabled = false;
 	qspi->current_cs = -1;
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (!ret)
 		return 0;
 
@@ -910,19 +910,17 @@ free_master:
 static void ti_qspi_remove(struct platform_device *pdev)
 {
 	struct ti_qspi *qspi = platform_get_drvdata(pdev);
-	int rc;
 
-	rc = spi_master_suspend(qspi->master);
-	if (rc) {
-		dev_alert(&pdev->dev, "spi_master_suspend() failed (%pe)\n",
-			  ERR_PTR(rc));
-		return;
-	}
+	spi_master_get(qspi->master);
+
+	spi_unregister_master(qspi->master);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	ti_qspi_dma_cleanup(qspi);
+
+	spi_master_put(qspi->master);
 }
 
 static const struct dev_pm_ops ti_qspi_pm_ops = {


