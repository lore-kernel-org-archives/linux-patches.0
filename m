Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B8F3B3BF2;
	Wed, 30 Sep 2026 19:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795601; cv=none; b=H8vBDYC8x9gVPs2VE9O05yzk0v+nb3sQQL3BlbRX+yFJOhQvTYu+2h8JKwB3WgQ/WZ1FLVTHgYmHfIMereaaiFJ7BhVeDz4tH+PdwXPca8yFJCZUxWmLKA/wUNj0kDdwRWMfyOwSD+U6CtSSLUMe6KVSbZ3OOcon2xiWwhpLMWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795601; c=relaxed/simple;
	bh=7lgu3PckuIFTeXH1ZprRNiuvRzhep62HONH8iSYyRhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmR23aAZjywh0oWabSXsmaCLvoiPBsi4zxdmEIG834M0IoemHZiv1cFe+x4G7F87WrIqXA3+urJUf1dB1Z9yfOveYscUS3XW+NjpFNRlehRWXx5IZ8dV4mkV4LN/omwrKVBaME9R9k8ZqT0XGeLg+/JMryRtBdewJSKTMVwCIxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTrctSfs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTrctSfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5521F000FF;
	Wed, 30 Sep 2026 19:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795600;
	bh=9ts2YiCl18I1rmRG0J8KcAZWdcmHkypSsIi4zydqd70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTrctSfs+xTZN7qvLS+eTijsaHpJJWmQd3/QkYvVHpmtoO9hcjZ7i7gWpAPt3NF3a
	 bO6R1tPqqheDoj1de5hhgLK1TL5cTQEwglI38bSNX/DeBmvdM8a3vSAImRGoF4sYqq
	 3v2Df54nImDG5LldL698SgSrQZEZLYGkxYU7PIEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0563/1193] watchdog: msc313e: Sync timeout value if WDT was running at boot
Date: Wed, 30 Sep 2026 17:20:47 +0200
Message-ID: <20260930152446.748322790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



