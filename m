Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD2D4F4049;
	Thu, 17 Sep 2026 17:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666041; cv=none; b=SbpWNPZO/99YEWeDQa130J5fYtP6q31FZrPZpa3VnqBNd6tHBuENu8VPgQGtHW7ny8+IypMHbv9MNATjuRIL18pdaHYGJx614AyEDVP89FYuh723hlT0Lin8A5kIFFT51OA+Bq/7carFlOPqeI1BnC0UpINfcGcQN/cJzOpMIqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666041; c=relaxed/simple;
	bh=1PLxZhFugN9pDq9ZUz52AkYuPi9z+JK7If5R9lcHMN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okjwcHwPVU7a0enKvqTQBlbA+2apKFXQbzBZuJiggCXHz6n9x99P1JUeVpSTWtMiT8xpw4orAXWVV7YF3oaoqqeOh39UhFM+jAEAq555wN5f2iXv1xgxxoTY2XVOuPfz7jt87tHiZtVD3VmQYEkZSecd6gtpx33D9/7eGWT0lJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMc8jAAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMc8jAAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A2A1F000FF;
	Thu, 17 Sep 2026 17:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666040;
	bh=3bKBUyXynaH8/laT9p/4uXlJ9g3/EJiKJjkmRfjlpA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMc8jAAAM2IOV+o4u8t0XGE9pWG0JAvds84Pd9PVDsJyJOjPI41KeMks3Cxjsc1zV
	 eROwvsR3b/Sk26iqlc4ESNhAoX8vv4UHaeqfNuBMJtpo/R2r6XE7dg+OCY9WRfYidX
	 cM58npPwVe8o8KG5DZpwPxz/70GpSVTWy2pTVitw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0897/1250] watchdog: msc313e: Sync timeout value if WDT was running at boot
Date: Thu, 17 Sep 2026 16:11:32 +0100
Message-ID: <20260917151616.301586038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



