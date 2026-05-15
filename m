Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3A43F9276;
	Fri, 15 May 2026 16:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861447; cv=none; b=VDvbuzrxwB7psUlH83lBIetrm2mdsioRbHxmnHuzPM0lJyl1YyNr8JomprJCXEuPX3zZyW04orXYMcO2brnwYFgE66ANp2tsg0wRSXx1g4tqFt62v1n3MgIxoWAMxw6H1WSSOKujkXANOOo5qfkxGwcWRMIo86PBtXD26dUtkBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861447; c=relaxed/simple;
	bh=5a5BUkNIen4jmEXHVBzleMoC8sFZnH2msm0+jShsLj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FeXn1FsVRoN9bKfoEpLgGcr7skQ4yDYZ9HSG+zCFvXf8VLKqL4X1fqU1T5lMZt4YnQC6Lisnb5x31SN2i+NM8/SANXh7xEF1iTHfCIb7XmOW4/Xox+JvqyAdC8kKnmGsb7RutFB/+dC6dYB9rWcnMQt/GITZYv5jgccIad0cb6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRX2BlOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRX2BlOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91681C2BCB0;
	Fri, 15 May 2026 16:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861447;
	bh=5a5BUkNIen4jmEXHVBzleMoC8sFZnH2msm0+jShsLj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRX2BlOuMsb5sdTYIqbh4+dTdRK+V3PzvW4j/8f6clr8YT9kZ7DOfiqPB9bq6BVG5
	 WEWe8se3imMO16lWgjmq/uc2gZtXYo2+CvsyyI/5QW+Pc1nCIIqFVIclTV4HOS69pA
	 dgmtj5A3I6bYhPYG9cMbxmXeVY6U+7XsH6MLdu1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven King <sfking@fdwdc.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 330/474] spi: coldfire-qspi: fix controller deregistration
Date: Fri, 15 May 2026 17:47:19 +0200
Message-ID: <20260515154722.153004127@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


