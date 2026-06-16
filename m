Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF23F169AD2;
	Tue, 16 Jun 2026 18:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634983; cv=none; b=guBDE6Sq6bM1dLp1reGjEiY8KtBLnVQRY7oyJga90UtqiR0MZX+Tl0L6oef/Sy+RcaoFOUI7ztT20A4MFKJRgxLpxySlyVerLHKAKtMv1J0qv4QQEomtBP+dXwfUozMuzCp7MGQ6adh2Fc4/kDk/mT/9Of5oT4iANn4bvIJEXlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634983; c=relaxed/simple;
	bh=VTABQvrLYtRTW6/3Hbil/iUXNDGds53UXpWoUosia7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndcEGUg4RXA3f4/BQ8d6K4PKdt3r06FJKO4qVl9h+dzOUXEBRGFWUWJk3erqLExflPX10beNfHXBdscQP1x+ZrAnLyuNUDm+m6e5a2m/sG/mgcjvSjRq4ydp8Ld8JuiAHJCO6StyrNIxbiS+louT3ViPcHu1OEBbsWFUC0Gkvcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzcOFUzr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzcOFUzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DD01F000E9;
	Tue, 16 Jun 2026 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634982;
	bh=4/Fil8AjC7ylYcokLLy+Hw4v05OfhltIgBdjDXyzyhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzcOFUzr/bw+DWCWFn9/I01z5bUP7zI/9NNJ+Hsdl3pcc2CGKI5ihVDEVx4Ug5Jmk
	 HzyGjhXE6n0q/j6SjpemBWp0maPbA5zOT7tc5ZgexN67lbYl/pIIyROev0lxam34mO
	 N8YfOTFgt0H/n04uOLDKCxjipsOMJXAQwYD9vPXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 335/411] spi: st-ssc4: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:33 +0530
Message-ID: <20260616145118.973957080@linuxfoundation.org>
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


