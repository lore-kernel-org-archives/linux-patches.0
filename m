Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24DC389E1A;
	Thu, 17 Sep 2026 18:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670729; cv=none; b=X42T2Gf7+dOCbjpJ5/1SBMQlQxf2GMNMBw807t0QX6dC59YO4nICNo2nlnFZE4/WEW2MvkTlZ4Ia/1LfM9Pcer3bsYc9kF2OkGYcpT6LAyaCUSGjAaG5sLOjNcWhDjsWczVXtmnomf7h4LmwtVOiAtgA7Mvh+0cd6ZOAGQkwpz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670729; c=relaxed/simple;
	bh=7/dpSgYfaQnFzCFb1UFS1I6Kkt28ONQ8YwKmstm9KBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YamW3vVGhy/bfnS/xf9vu1v0Seuv/SHPxdFZ1g71aueUYpyRP93NounWzo8L9wh2ppw2N3wokdxRKlQ5yE2soosVqwPhFKWyIe1Gdj7l0dLpjumWMJ442FOYXXoUrS7NDwsolEFgNmprabRTgdhetyZnvcD1av7RXj32LkHpxvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wq07v6pl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wq07v6pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C251F000FF;
	Thu, 17 Sep 2026 18:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670727;
	bh=wSjCuMnLMbLymKnwyOY8+UVWMRMvXeeYT0eBvW6sbCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wq07v6plA2Ffum2F4LCpKU1JbYW65nwAyWqprG2mlqtpLSYrktngU/XmQOpglgEc6
	 6Bh+wAr4MKwBRCGgTjy90xyhsoMMXZrBM9ldtCO0AUF9DWkvQNKruzzMqfn8Zf/YGP
	 OegFKaLx+lTGSWGX1EWPxWfXYLu/7hrjinZjK+JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0750/1102] watchdog: msc313e: Enable clock before accessing hardware registers
Date: Thu, 17 Sep 2026 16:11:33 +0100
Message-ID: <20260917151559.248540442@linuxfoundation.org>
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

[ Upstream commit 3db2df24e7f11fb117718f6abe326628d91bc500 ]

msc313e_wdt_probe() reads from hardware registers without ensuring the
required clock is enabled.  Furthermore, if the bootloader leaves the
watchdog running, msc313e_wdt_probe() sets WDOG_HW_RUNNING without
increasing the clock's reference count.

While the clock is currently supplied as a fixed clock by the device
tree (`xtal_div2` in arch/arm/boot/dts/sigmastar/mstar-v7.dtsi) which
masks the physical issue, this still violates the API usage.

Call clk_prepare_enable() before reading WDT registers.  If the WDT is
running, leave the clock enabled so the CCF reference counter is
balanced.

Fixes: ffd264bd152c ("watchdog: msc313e: Check if the WDT was running at boot")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260828161348.13212-5-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/msc313e_wdt.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/msc313e_wdt.c b/drivers/watchdog/msc313e_wdt.c
index 5dc5e3ab7001e..86e72aea96855 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -109,6 +109,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct msc313e_wdt_priv *priv;
 	unsigned long rate;
+	int ret;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -134,9 +135,21 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 	priv->wdev.max_timeout = U32_MAX / rate;
 	priv->wdev.timeout = MSC313E_WDT_DEFAULT_TIMEOUT;
 
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
 	/* If the period is non-zero the WDT is running */
-	if (readw(priv->base + REG_WDT_MAX_PRD_L) | (readw(priv->base + REG_WDT_MAX_PRD_H) << 16))
+	if (readw(priv->base + REG_WDT_MAX_PRD_L) | (readw(priv->base + REG_WDT_MAX_PRD_H) << 16)) {
 		set_bit(WDOG_HW_RUNNING, &priv->wdev.status);
+		/*
+		 * Keep the clock enabled. The watchdog core will skip the next
+		 * start() and a future stop() will balance the CCF reference
+		 * count.
+		 */
+	} else {
+		clk_disable_unprepare(priv->clk);
+	}
 
 	watchdog_set_drvdata(&priv->wdev, priv);
 	platform_set_drvdata(pdev, priv);
@@ -145,7 +158,13 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 	watchdog_stop_on_reboot(&priv->wdev);
 	watchdog_stop_on_unregister(&priv->wdev);
 
-	return devm_watchdog_register_device(dev, &priv->wdev);
+	ret = devm_watchdog_register_device(dev, &priv->wdev);
+
+	/* If the WDT is running and anything goes wrong, disable the clock. */
+	if (ret && test_bit(WDOG_HW_RUNNING, &priv->wdev.status))
+		clk_disable_unprepare(priv->clk);
+
+	return ret;
 }
 
 static int __maybe_unused msc313e_wdt_suspend(struct device *dev)
-- 
2.53.0



