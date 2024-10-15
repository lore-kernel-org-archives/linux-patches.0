Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B1C1C07DB;
	Tue, 15 Oct 2024 13:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997515; cv=none; b=lsvu9u7/Pnxz37ErHH+mhu2QpW07C8dvYFopiVxtox/V1G2Mey2KMPVEpLx1RAwtGHIB+AvI6qUsOo0q0IpEhG2IH6i7LrScrvrTLY+BVaj0+pbYUfYHkfBekeaaS0LWqrHdW8AhASxxjujsU3u6byVPt5ff2Zf/10LUbdxpGRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997515; c=relaxed/simple;
	bh=c9twD0EJ5lJm0JJ7N1OHAo865pxow5ugQ8tUy1tdpNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQoY+j20bWCbT+v2Hjf3SWz3/f1AJBYOXhROvB7yuDwzspntFkzkK7cLDqqVkC6kJhA/8aCenE9JMKTJE794nK8b40Si9eQ9+1nxmgcLAcl41nw02dy6SYQND+KiHzEqfsqC5PF4PHcImj0cb0dlOLRMBAWha6NCektjfw4Kix8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogFwq2lq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogFwq2lq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DA1C4CEC6;
	Tue, 15 Oct 2024 13:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997515;
	bh=c9twD0EJ5lJm0JJ7N1OHAo865pxow5ugQ8tUy1tdpNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogFwq2lqs3OdIgOiPLiY0GFJpL+WOcXjXGPSac9Ayq8nkUHcg9rdVetu6Zg7SpiLH
	 fMObFRM14YrUa8bx1TZ8M6Xsb+ZRnh2GGsEJyl6jABIuRsJ2pQxGQua3hhB9aeJ7JM
	 TnoGUHu1ySPtOU69qqajIsofgdGa/hEmkggMXd8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Blixt <jonas.blixt@actia.se>,
	Anson Huang <anson.huang@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/518] watchdog: imx_sc_wdt: Dont disable WDT in suspend
Date: Tue, 15 Oct 2024 14:41:18 +0200
Message-ID: <20241015123923.706259052@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



