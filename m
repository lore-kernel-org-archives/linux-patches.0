Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C659B39734B;
	Fri, 15 May 2026 16:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862562; cv=none; b=nYwEQyIOFHrZl5FPK1MXdu8OiCHrvB9wn/7YrpXxqrE/PJFRRo4t61kQGB5w3t2U8HC0XnY6Y4UIaJIGVk7+xlsr4MoLF4iI8w7oahY2xhL+PMAHB9Rp21KURYwq1cSFGA3lR7PLJbAoTSZwWJKUBhVoZ59UVxLVDv2A1HEEZ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862562; c=relaxed/simple;
	bh=FlZ+iMQW+JhOmNMtoIJ9Tf+/vq97jhIcOQm0J/CmBlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etiMMC6ZBGQ0W3W6KZrVCtbcWQN46q7BR3kIaP3/ZtVSEcPriWyetUivP2e252UIW//ZgAfjn34H8zEAn1SRIjl4pikeoqfriE77p3CM1nMAxkraWPePAxvpkfrYAG49woXmX7aPaIgQJS5pC/g6X/MFGn5pscpqACxWcVRAEmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJ1DOS7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJ1DOS7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2083FC2BCB0;
	Fri, 15 May 2026 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862562;
	bh=FlZ+iMQW+JhOmNMtoIJ9Tf+/vq97jhIcOQm0J/CmBlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJ1DOS7+nT2o//bl0sHx6u0v1fwBRYGBFU0VUzTiv+dSDLbJSlANH2r7GJbIjz5FK
	 dlTsd4u39uwXJ7uHVsvDTzTdiv2PyGw2KUFwZng6Dz8cLUFbgPwr5wyxrjzh5xIW1y
	 6veJuYSWF3s0rEohIDBoZYdtoXF1uyHlT/EXrCMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven King <sfking@fdwdc.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 097/201] spi: coldfire-qspi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:35 +0200
Message-ID: <20260515154700.635249913@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e7c510e192ff2a1264d999575eea39a506424264 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks (via runtime pm) during driver unbind.

Fixes: 34b8c6617366 ("spi: Add Freescale/Motorola Coldfire QSPI driver")
Cc: stable@vger.kernel.org	# 2.6.34
Cc: Steven King <sfking@fdwdc.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-11-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-coldfire-qspi.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -410,9 +410,9 @@ static int mcfqspi_probe(struct platform
 	platform_set_drvdata(pdev, host);
 	pm_runtime_enable(&pdev->dev);
 
-	status = devm_spi_register_controller(&pdev->dev, host);
+	status = spi_register_controller(host);
 	if (status) {
-		dev_dbg(&pdev->dev, "devm_spi_register_controller failed\n");
+		dev_dbg(&pdev->dev, "failed to register controller\n");
 		goto fail1;
 	}
 
@@ -436,11 +436,17 @@ static void mcfqspi_remove(struct platfo
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct mcfqspi *mcfqspi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&pdev->dev);
 	/* disable the hardware (set the baud rate to 0) */
 	mcfqspi_wr_qmr(mcfqspi, MCFQSPI_QMR_MSTR);
 
 	mcfqspi_cs_teardown(mcfqspi);
+
+	spi_controller_put(host);
 }
 
 #ifdef CONFIG_PM_SLEEP


