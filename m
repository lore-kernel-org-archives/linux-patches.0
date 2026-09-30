Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DCB4F472F;
	Wed, 30 Sep 2026 15:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783612; cv=none; b=s66rFeXCOig0JdU9iVxxAYAyd9owMV6xhA3QrojM4+GwLyuJ5YuSZX7bcwuiUssx3CSFYDLZBr0lTgXJIqiydGmCFNjIYm3z9m3pYQ8+6pJIdZsZwKQNzqp1q6PPBUQXl4JtG7WjjhV5NE5aaAQI+FsLj6R6/vXxm/sD08VK90o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783612; c=relaxed/simple;
	bh=vDeCzp2OOsWb4ansTB8Tub2JTGH5IFj0HWPzUzfIGvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpNSW5rkoedSl8P22dSNJWN5iwTTM4P718ZX5B6qOC/ksUYELWHayfMqMDcLsE6SjkvEnw7oXYfeFi0q5f5/MclS0vQXNdQc0qvlRhk+EwiEy3loNXFrf6CUGiE+Y+6bVQ0g5sYWRRuqv1j457W3C4RUttiqLS0fdyF3nsAUlRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4ojcHas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4ojcHas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B701F000FF;
	Wed, 30 Sep 2026 15:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783605;
	bh=gWrjFfY9MpOR3t51zwEDIb161JEmEPBMP/LpEdxhydE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4ojcHasQNor3w1YeRlSXsdqCPUi5Qm3QoEHhzprRLjLbRPS8PDSmMc5MTLukhy2n
	 MAPBeajAWp8mdSi5vDqU/+GCpdGB3CuxJyN/jeFgAizMVghlr0ukaPMoSt34Oo07zz
	 ss4hXiw5YBnvxTK2m3MXveab3iutiplAIe2dPOGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 459/595] watchdog: digicolor: Avoid division by zero
Date: Wed, 30 Sep 2026 17:25:52 +0200
Message-ID: <20260930152357.554787468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 400cb663ca019bae6eb878f06f1094ddf7c0b0df upstream.

clk_get_rate() could return 0.  Avoid a division by zero panic.

Since get_timeleft() cannot propagate errors, check the clock rate early
in probe() and cache the rate in the driver data as it is unlikely to
change at runtime.

Fixes: 336694a01dae ("watchdog: digicolor: driver for Conexant Digicolor CX92755 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Link: https://patch.msgid.link/20260913064851.8239-2-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/digicolor_wdt.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/watchdog/digicolor_wdt.c
+++ b/drivers/watchdog/digicolor_wdt.c
@@ -25,6 +25,7 @@ struct dc_wdt {
 	void __iomem		*base;
 	struct clk		*clk;
 	spinlock_t		lock;
+	unsigned long		rate;
 };
 
 static unsigned timeout;
@@ -61,7 +62,7 @@ static int dc_wdt_start(struct watchdog_
 {
 	struct dc_wdt *wdt = watchdog_get_drvdata(wdog);
 
-	dc_wdt_set(wdt, wdog->timeout * clk_get_rate(wdt->clk));
+	dc_wdt_set(wdt, wdog->timeout * wdt->rate);
 
 	return 0;
 }
@@ -79,7 +80,7 @@ static int dc_wdt_set_timeout(struct wat
 {
 	struct dc_wdt *wdt = watchdog_get_drvdata(wdog);
 
-	dc_wdt_set(wdt, t * clk_get_rate(wdt->clk));
+	dc_wdt_set(wdt, t * wdt->rate);
 	wdog->timeout = t;
 
 	return 0;
@@ -90,7 +91,7 @@ static unsigned int dc_wdt_get_timeleft(
 	struct dc_wdt *wdt = watchdog_get_drvdata(wdog);
 	uint32_t count = readl_relaxed(wdt->base + TIMER_A_COUNT);
 
-	return count / clk_get_rate(wdt->clk);
+	return count / wdt->rate;
 }
 
 static const struct watchdog_ops dc_wdt_ops = {
@@ -130,7 +131,11 @@ static int dc_wdt_probe(struct platform_
 	wdt->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(wdt->clk))
 		return PTR_ERR(wdt->clk);
-	dc_wdt_wdd.max_timeout = U32_MAX / clk_get_rate(wdt->clk);
+
+	wdt->rate = clk_get_rate(wdt->clk);
+	if (!wdt->rate)
+		return -EINVAL;
+	dc_wdt_wdd.max_timeout = U32_MAX / wdt->rate;
 	dc_wdt_wdd.timeout = dc_wdt_wdd.max_timeout;
 	dc_wdt_wdd.parent = dev;
 


