Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EDC19B3FF;
	Tue, 15 Oct 2024 11:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992939; cv=none; b=cBiYNkQDKwlIALJU2iHxLNUJL/k31CHRqF4KOjOfDIUY5osH+zoduiDHTDjmIn/nZeHxas5M3N8GzFVg0IDM2c7n9Uy/RrykiekCw71jpFW4VRELYROC6TwO0wTotMxEM7MvzPpc1d9ClR8EoEtUNc9WUXBUb+zw4BYLWNMRD5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992939; c=relaxed/simple;
	bh=2RN34Rt68iv3qzxRmiX9VAxxRQ6/XGZWXYVxi4baksY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzGQCOeSBISKuoA2I1ZsYZmHDBEfADwZ/ZEIm5X+8M0nmo3L5pvZ+HCIB1fw4sTex/AHgem3tx3ryGaRjwGRYPA4rBz3TJeza2HNHGOg5jDW0ecQFuiptZeH++gmiMymuRcr9AEgxLwoHr9jRuj2u6A/3W99rnGi6/yXjp7Szwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFmHK5hQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFmHK5hQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA638C4CECE;
	Tue, 15 Oct 2024 11:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992939;
	bh=2RN34Rt68iv3qzxRmiX9VAxxRQ6/XGZWXYVxi4baksY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFmHK5hQT0PcnrzSoVTb/vkvUG2tXIbqybF1t+UaRDTNLBAEVNm5dB7qoU7W7jqXk
	 Q+VG3Qd2uHQ3P65T34xI/jy4dAN0U+sA5ScjOYR94P4sdu70ClzTHILcalmlh12eCy
	 rGoxYUI/U5JivKqone9Qwt4ddCDzUEE02jw0Inkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Blixt <jonas.blixt@actia.se>,
	Anson Huang <anson.huang@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 246/691] watchdog: imx_sc_wdt: Dont disable WDT in suspend
Date: Tue, 15 Oct 2024 13:23:14 +0200
Message-ID: <20241015112450.117686493@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



