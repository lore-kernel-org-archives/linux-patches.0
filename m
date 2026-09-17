Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E746484898;
	Thu, 17 Sep 2026 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659860; cv=none; b=WB8o+xD7LeUDoQq09lT4L2ZzozKtEAfGZQjKPaWiivMETDLEx/8TMjDklHlUgZaoa1b53CnFPEeCmRR+p8v6vhZgFnN3CAsK3Fad436WdWCNOIlpok5xZJRQGYxylKiK5T2r9VF/vfxipEUIa16DlN5Tm394FcUP5VHusSB3yok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659860; c=relaxed/simple;
	bh=0ypeEjMGueuaA9Kbz0APnnwcOhu0lu5GLLpf0PsBukM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dn2rWQzoWXg5QRUE952gT+cNvC3DEEg/04xbMTskS38JBNYv3PWR4GIydbTiARVgFRIC51SLLVryQu2ioiasJ3QevyNgvkKduTYwWL6DtV6TR6dNqF9ENC7AViHKY6ko0vBFfpLEOCzmuCHqKT58IBDNwEvkKLP7zeMwzWcEHHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdJQdq8D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdJQdq8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256D61F00899;
	Thu, 17 Sep 2026 15:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659853;
	bh=oxZFqWivUSwhqqhcPcY7iboodkDF7y2B/YJB8vCGDLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdJQdq8DW0lH9fyC+WVmvFnrk4Y+CnInQ6gawrjZMOn/As0ox/kpRkmNX+ncm6cVD
	 HrOCbk2jZfP/jg428T2BqiRH4F4ZJm9bX6qdwe1lPvHLLbifb9HIhDW9Ss7nREneTD
	 WxZfjlzyE0UIfPoe8LLtFGfrh2hIGE4IZBQcQlBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 396/733] watchdog: msc313e: Sync timeout value if WDT was running at boot
Date: Thu, 17 Sep 2026 16:11:44 +0100
Message-ID: <20260917151401.590762619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e28261c7a8d4c..4a5cce2a16b18 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -144,12 +144,21 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
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
@@ -160,14 +169,6 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
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



