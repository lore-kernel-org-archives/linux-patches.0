Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCAF4CE681;
	Wed, 30 Sep 2026 16:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785328; cv=none; b=Z1z1hvkf2O46PCmENzxacm1WgpDe0Oito8SIjfbxfhm0f/Hyr9/et8P6ZSKPL1ElcZUlCLne+yBle8Gqe/bzw1Jq4LVyNfhnpqphfMEoCzSwJSSQvcLZSQW8vU+bfkjOY8S/B+WEu1Y6/DKgaQ9/63NaVCgqUQMqFoGgr9TIs50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785328; c=relaxed/simple;
	bh=ZYyOBwpS3UPN/ln38eXsQ1tokYQ2bf3ncCu7KHWI7V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdHCM4LF8gP4c9r6FAMxZat2MBIVbA1DhfiXdNIlVreenaBXrWu3SPQhTJ16PgwXx3tMGgtBiqffhUpnxQVbSyG05XILei8za0JeBXPb6wzlYbXV2zL5zQPunvxe+bhsSE824MzfuCkKUx+OzqdYCWVsUHBOPPqSSGocKCxOi4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcUIP64k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcUIP64k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43C81F00898;
	Wed, 30 Sep 2026 16:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785319;
	bh=gHE/omMi5yydyafVgKTBjknw0+A35dNDWc+rQtoyxjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcUIP64kDH7mYh1U1vtX4KAAgmrASLOxKEprUBVrmE1f/MYHdtJ1L02GqdyVWBfrU
	 AOOYpV6zQqKGSNKMxArlqJakkFtkT8ieIOrDBLytYSKoAdnFAqhPEIGS0g2Rddya+1
	 UysrzpLoyAXiNENat+BClIxe9svkRq/4NyG/42Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 467/982] watchdog: msc313e: Sync timeout value if WDT was running at boot
Date: Wed, 30 Sep 2026 17:20:03 +0200
Message-ID: <20260930152426.817316529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 01504d14e47b34779911250dd308a03f6ef681c2 ]

If WDT was running at boot, the hardware timeout might be set to values
other than the final software timeout.

To be consistent, set the hardware timeout to match the final software
timeout (i.e., after watchdog_init_timeout()) if WDT was running.

Fixes: ffd264bd152c ("watchdog: msc313e: Check if the WDT was running at boot")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260828161348.13212-8-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/msc313e_wdt.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/watchdog/msc313e_wdt.c b/drivers/watchdog/msc313e_wdt.c
index 72620adec641a..eea26c6c95d84 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -145,12 +145,21 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 	priv->wdev.max_timeout = U32_MAX / rate;
 	priv->wdev.timeout = MSC313E_WDT_DEFAULT_TIMEOUT;
 
+	watchdog_set_drvdata(&priv->wdev, priv);
+	platform_set_drvdata(pdev, priv);
+
+	watchdog_init_timeout(&priv->wdev, timeout, dev);
+	watchdog_stop_on_reboot(&priv->wdev);
+	watchdog_stop_on_unregister(&priv->wdev);
+	watchdog_stop_ping_on_suspend(&priv->wdev);
+
 	ret = clk_prepare_enable(priv->clk);
 	if (ret)
 		return ret;
 
 	/* If the period is non-zero the WDT is running */
 	if (msc313e_wdt_get_hw_timeout(priv)) {
+		msc313e_wdt_set_hw_timeout(priv, priv->wdev.timeout);
 		set_bit(WDOG_HW_RUNNING, &priv->wdev.status);
 		/*
 		 * Keep the clock enabled. The watchdog core will skip the next
@@ -161,14 +170,6 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 		clk_disable_unprepare(priv->clk);
 	}
 
-	watchdog_set_drvdata(&priv->wdev, priv);
-	platform_set_drvdata(pdev, priv);
-
-	watchdog_init_timeout(&priv->wdev, timeout, dev);
-	watchdog_stop_on_reboot(&priv->wdev);
-	watchdog_stop_on_unregister(&priv->wdev);
-	watchdog_stop_ping_on_suspend(&priv->wdev);
-
 	ret = devm_watchdog_register_device(dev, &priv->wdev);
 
 	/* If the WDT is running and anything goes wrong, disable the clock. */
-- 
2.53.0



