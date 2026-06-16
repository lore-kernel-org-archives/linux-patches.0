Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7462332E13B;
	Tue, 16 Jun 2026 18:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634686; cv=none; b=b2alg3AYQuWIgD7f1sqo/B6SjF/aWL4hy2o9EzSm81xAhqX0yVJIsYQB+H5UAKOON4evIEFQxaT7buvRvRESJkYsGb5O8Q4BNMu/aiGo4rI26O/ASQplc755WSw4EKX2JCLpJDWELbdgMtVjI1Ter8SP+vnYuv0klYx6sPwYXMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634686; c=relaxed/simple;
	bh=AOT5sp9wvX/4KDCPClWOvdBgTDf5o2BOYmSZ8EwpiC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lm+WD++CuAJr/2VS2U2iVcqMiduIXe6icTADFGrgRasvXV9UDamrzEtXw7tlxtUqocWEYQoRtzhONvtDgcQT1FXjcwi9rGFbYd3PhR18jShoIID/J66VVPhfcz5jX/q8Vu6LQuZWOlrGmSDIkJUzfHWB6h8Q+sCtTEgZjKyLCn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gpx3ppD5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gpx3ppD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CBF1F000E9;
	Tue, 16 Jun 2026 18:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634685;
	bh=Vs2OwZ5NswVlkEFma5DTAdXCgHIaNyRZsg/KycOcWME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gpx3ppD5El9g9FmlSaRinyp3p1YI/I4z1oKX3WJ08j2LWh/MM12l3y7fHJr+TsCJH
	 h6O5W9ja80pClVEoiBG50grlwPP8/0QY7eVRwJ+QhoDMQiyD8YSIQ/xY+IDNfbX2+j
	 bUS2DjXW3zU8Z8fqvVEO7TxKWIfVnx3wXwaDeq/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 312/411] spi: sun4i: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:10 +0530
Message-ID: <20260616145117.728830186@linuxfoundation.org>
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

[ Upstream commit 42108a2f03e0fdeabe9d02d085bdb058baa1189f ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: b5f6517948cc ("spi: sunxi: Add Allwinner A10 SPI controller driver")
Cc: stable@vger.kernel.org	# 3.15
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-19-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ renamed `host`/`spi_controller` to `master`/`spi_master` and kept `int` return type with `return 0` in remove ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sun4i.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -503,7 +503,7 @@ static int sun4i_spi_probe(struct platfo
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_idle(&pdev->dev);
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register SPI master\n");
 		goto err_pm_disable;
@@ -521,8 +521,16 @@ err_free_master:
 
 static int sun4i_spi_remove(struct platform_device *pdev)
 {
+	struct spi_master *master = platform_get_drvdata(pdev);
+
+	spi_master_get(master);
+
+	spi_unregister_master(master);
+
 	pm_runtime_force_suspend(&pdev->dev);
 
+	spi_master_put(master);
+
 	return 0;
 }
 


