Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C88E374A0E;
	Thu, 17 Sep 2026 18:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670738; cv=none; b=MX27dHEoNs+xwtkn8VD5TCBDDgEnJwirsAB2zcHUGadKgeu/qp1LMATPIgd9uSYt8epEK5GC5X76tLNsmAFapeRg3kUt8zGsijOV9LoM6qxRjCBmCx3wnFR6mGk63D4SjGESVPO8g3RRR3TtN6yEeg1H0vSQrr4xuyIF0xkzygM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670738; c=relaxed/simple;
	bh=eog8MNB496mLfeLqI3g/c/bude+wz6AjGR1Cydo723U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DS9WN9Yjgvsr48LL7gOkeLkit5WJnV7jM9tM7XlohqrilavR3XphZbqXjARcAfzUJRxR5Hw8L6TVWE7fTE3jKl/qCBbP7hAzPvUl9Ok64lOuJHXoNz1DBC+tyPRmueKCXuOks2lC6YPWYjn0iYnvfvMlAJHpsvHD6UP0tyQaw8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COI4TGKp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COI4TGKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291DC1F000FF;
	Thu, 17 Sep 2026 18:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670736;
	bh=lPiDmWwH1ODqzMwp4SHQlxZxSCG090sWF+PDZQwh7rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COI4TGKpUKVxJ7WrzbJQCqRBU00yT316RZ6rKP8cODbazGTu3HqZ6x7uqa8acuAKf
	 rf6NlHkYYrVDbvYdODJeeHPVIZ8765MTLITZzB3aXTOxrb4RkHxXCTqOdvtVceUAea
	 dj9HeuHVMtO3cjgMT/ExZxMyJVgUpasf284KFhjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0753/1102] watchdog: msc313e: Sync timeout value if WDT was running at boot
Date: Thu, 17 Sep 2026 16:11:36 +0100
Message-ID: <20260917151559.328973019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



