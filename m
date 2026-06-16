Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F6334751B;
	Tue, 16 Jun 2026 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636635; cv=none; b=dDV/PweJFKv2tHelzcCwyib8DXc284fkjYqowE+xp6ehKTyteOVrq9wWGUSMOdLJ6wq2CfmkJEWUahgZkhRfUyTrMTPQiwBCJpDo5S518TmHwaFRZQkysEnRnbiDDgirRugQDhHjwWRWy8j0UGOhZnumzsHWlPpIGMk3U2oUKE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636635; c=relaxed/simple;
	bh=nxuMTjzTRft1bQPUcqSi1dyOoRPYuiCGcqt/1Cr42fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdOObIwiMe5vX35WcXof2Ro6tgudzmVCNHxYVf9mZ088BU+v+oFLt8+gk2JwjAgQIvfa/6jfsyyH1DyZA/SJuheuKXQMkd8W5kUvmRFXgyFHKzfofgvauJ5rfByjiMGOW3GJrzGz4BqeYrHuvB43PTT+QhejHymXvHpO5qC7pNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U51F19yY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U51F19yY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15321F000E9;
	Tue, 16 Jun 2026 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636634;
	bh=iO04L7J8X0t6ThtJXlzgEmQwHwkW01+HmFiFsNkeKd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U51F19yYBqMfyZtw1S+IBRTM32A8EpbXGPAALewxOuVaORvuz7ywgVAvE9hJSPhrM
	 GzvTn8uUVf0llx4U056IIYRRudrykQiVpD202c3sslicalIoW4X9Xq9MOmPGrfj+ke
	 1zI/WPO46Js+QueUclDSpZ7pLtoyi4EKXrO4vnZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/342] spi: st-ssc4: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:32 +0530
Message-ID: <20260616145101.231752207@linuxfoundation.org>
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

[ Upstream commit 19857374010d06ca6a2f7c2c53464122eb804df0 ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 9e862375c542 ("spi: Add new driver for STMicroelectronics' SPI Controller")
Cc: stable@vger.kernel.org	# 4.0
Cc: Lee Jones <lee@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-18-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ changed spi_controller/host API calls to spi_master/master equivalents ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-st-ssc4.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-st-ssc4.c
+++ b/drivers/spi/spi-st-ssc4.c
@@ -372,7 +372,7 @@ static int spi_st_probe(struct platform_
 
 	platform_set_drvdata(pdev, master);
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register master\n");
 		goto rpm_disable;
@@ -394,10 +394,16 @@ static int spi_st_remove(struct platform
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct spi_st *spi_st = spi_master_get_devdata(master);
 
+	spi_master_get(master);
+
+	spi_unregister_master(master);
+
 	pm_runtime_disable(&pdev->dev);
 
 	clk_disable_unprepare(spi_st->clk);
 
+	spi_master_put(master);
+
 	pinctrl_pm_select_sleep_state(&pdev->dev);
 
 	return 0;


