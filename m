Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4291F3191BA;
	Tue, 16 Jun 2026 19:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636545; cv=none; b=Q0hj8y/0PbbzFneM246Bl25vcrTxxmvhN+AkPsSPlc54M5fagLgILNnZyZSB/3OA49lP7Xc3QQpEaPA8sGzP/GR7Fpwe4+ODVBhbTM9xgerL/woom89zDNbl32a7iZvJhZm3qvIyg6z0xVMYUu6MCiAUDwJbr7rm9To3r01VfwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636545; c=relaxed/simple;
	bh=uCNW4JHRJR4vLAOxuNTsCn6N6JSDHtRxbTuOnkZdRYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDtoVxfaPVEShtcdWCSzk8xBqgXNBZdpLnocWx/o0aVNtAryGnGajGyRx21lTjoPsI4Jz+mdpvdJXFmJiMn5Wz6zNrdtlbLtR9XPOX1HaNjJ4StsYpaovSM6s2OW7OcCn4hDoboFkwAwvqOzeUlJGa40Q544dni0wiV5pwHH8ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E13nemZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E13nemZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CA71F000E9;
	Tue, 16 Jun 2026 19:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636544;
	bh=ExHVKNZdoHMolJMMpfr2p0gdHbDalAVG6/HuShlJjQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E13nemZjUlpfoRZFjQRPbx91C6Kf/JD9tLc8K5TbeQgxj6kasHNSXjauRarA6I0uD
	 HAFHn270KLJ9d5V+JNEdwZW4w7YPdUQnlUr9U1LJid4v0zzixJwECxq/WcnR+B12nx
	 ncbkYqc2P52gBe1XEdoz1cLEZfBcEDJYsgK9zSq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 260/342] spi: sun6i: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:16 +0530
Message-ID: <20260616145100.367512897@linuxfoundation.org>
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

[ Upstream commit d874a1c33aee0d88fb4ba2f8aeadaa9f1965209a ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 3558fe900e8a ("spi: sunxi: Add Allwinner A31 SPI controller driver")
Cc: stable@vger.kernel.org	# 3.15
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-20-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ renamed spi_controller/host APIs to spi_master APIs, dropped non-existent DMA cleanup, and kept int return type ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sun6i.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sun6i.c
+++ b/drivers/spi/spi-sun6i.c
@@ -512,7 +512,7 @@ static int sun6i_spi_probe(struct platfo
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_idle(&pdev->dev);
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register SPI master\n");
 		goto err_pm_disable;
@@ -530,8 +530,16 @@ err_free_master:
 
 static int sun6i_spi_remove(struct platform_device *pdev)
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
 


