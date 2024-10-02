Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FD91D0414;
	Wed,  2 Oct 2024 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880012; cv=none; b=kAnE0ajn4u/QOx3GT9dniAYcAHAuIciBjXkijGK0lZu4bSGrju2qv3UgzasK46wDmOtVTbq4hqEH3fSgmDAp/LjpgoZYoZOKI8EKSyJCRIEfxX05eunrQW7OJFFWc2SpkDCc9cLduXr83+y9jY2FwhH0pBo0Hfol5j/MEkjyWrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880012; c=relaxed/simple;
	bh=9uTP9GsHn74tOxKKY1Ef9+QdbTEP4TqQg/Q1VZq7UIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MchPnT+QIIIiHUSZviC4FMyCLxC4cofqGf82Si/pnidmPsCyHPVWicMlQL7ufcik/4+Vnm5oWHkgJSPEq7GSaFTITmBj86/sjn3YtI57UlDBjnI4gCWiiil0C5QVxFyBEdJcoaHM3855v14kfi9UWJ5wuTblgzmK19q2oLgHMrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+O7lgKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+O7lgKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754C4C4CEC2;
	Wed,  2 Oct 2024 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880011;
	bh=9uTP9GsHn74tOxKKY1Ef9+QdbTEP4TqQg/Q1VZq7UIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+O7lgKItyRhCB99/F6t+1aHusdvn/V394Il1+HK0KNcNM28jKtLEzBcCkseeFEIr
	 uAE4zAjyedKcqzk8EMrGuBo9jkOzF/GkM0Dc+UcyNRJPKTPCUYXtzbyVmMEvKy2ZQ9
	 /m6/tOsSYaESDopjPZWdk6B0633v0Hvy27qHCijw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Blixt <jonas.blixt@actia.se>,
	Anson Huang <anson.huang@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 314/538] watchdog: imx_sc_wdt: Dont disable WDT in suspend
Date: Wed,  2 Oct 2024 14:59:13 +0200
Message-ID: <20241002125804.812648472@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jonas Blixt <jonas.blixt@actia.se>

[ Upstream commit 2d9d6d300fb0a4ae4431bb308027ac9385746d42 ]

Parts of the suspend and resume chain is left unprotected if we disable
the WDT here.

>From experiments we can see that the SCU disables and re-enables the WDT
when we enter and leave suspend to ram. By not touching the WDT here we
are protected by the WDT all the way to the SCU.

Signed-off-by: Jonas Blixt <jonas.blixt@actia.se>
CC: Anson Huang <anson.huang@nxp.com>
Fixes: 986857acbc9a ("watchdog: imx_sc: Add i.MX system controller watchdog support")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240801121845.1465765-1-jonas.blixt@actia.se
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/imx_sc_wdt.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/watchdog/imx_sc_wdt.c b/drivers/watchdog/imx_sc_wdt.c
index 8ac021748d160..79649b0e89e47 100644
--- a/drivers/watchdog/imx_sc_wdt.c
+++ b/drivers/watchdog/imx_sc_wdt.c
@@ -213,29 +213,6 @@ static int imx_sc_wdt_probe(struct platform_device *pdev)
 	return devm_watchdog_register_device(dev, wdog);
 }
 
-static int __maybe_unused imx_sc_wdt_suspend(struct device *dev)
-{
-	struct imx_sc_wdt_device *imx_sc_wdd = dev_get_drvdata(dev);
-
-	if (watchdog_active(&imx_sc_wdd->wdd))
-		imx_sc_wdt_stop(&imx_sc_wdd->wdd);
-
-	return 0;
-}
-
-static int __maybe_unused imx_sc_wdt_resume(struct device *dev)
-{
-	struct imx_sc_wdt_device *imx_sc_wdd = dev_get_drvdata(dev);
-
-	if (watchdog_active(&imx_sc_wdd->wdd))
-		imx_sc_wdt_start(&imx_sc_wdd->wdd);
-
-	return 0;
-}
-
-static SIMPLE_DEV_PM_OPS(imx_sc_wdt_pm_ops,
-			 imx_sc_wdt_suspend, imx_sc_wdt_resume);
-
 static const struct of_device_id imx_sc_wdt_dt_ids[] = {
 	{ .compatible = "fsl,imx-sc-wdt", },
 	{ /* sentinel */ }
@@ -247,7 +224,6 @@ static struct platform_driver imx_sc_wdt_driver = {
 	.driver		= {
 		.name	= "imx-sc-wdt",
 		.of_match_table = imx_sc_wdt_dt_ids,
-		.pm	= &imx_sc_wdt_pm_ops,
 	},
 };
 module_platform_driver(imx_sc_wdt_driver);
-- 
2.43.0



