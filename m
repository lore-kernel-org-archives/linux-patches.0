Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9493A255A;
	Wed, 23 Sep 2026 14:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174014; cv=none; b=hCV5CdSP/KyiT37IuiYQAJZWSniYaV1K4i6SNF6r77f/ofZQ0ZRizeY8baSDuLKtiy7Q7HL5jZb3xqhdZu2loTc+Mv+SV0uE0ex8Op1NbEcv8P7Zm2+tv+Jnx4C514TSjP094z8fYlqr81jmVCYRE0Uzl9jRbmh2at6sgeSlMT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174014; c=relaxed/simple;
	bh=DvK4KKTUBdDRqNWpby2YR2nJENjRmIYh+gOUeAmxvFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPqFx/mPnjxwHZ3N4nWYlJp8r0X11Eq/bH36OuY5H/lcZJIvoCQi7J9pNg5fRJe0q5rN+6zSvr7W4LY9NLWd73nmmdp7B9c+IpxeA63bxVYu1dszZ1To8cfSTn4YMxd8Jcx+sHEnwb7pdZatqOtCyO7m0BL1mIRRTAXEFwqz+iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4Qj+2ZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4Qj+2ZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4D71F000FF;
	Wed, 23 Sep 2026 14:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174013;
	bh=lYOekV4BYR8/+moWa5T+KPpVtkdwjWk6xXhpJozUhtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4Qj+2ZUqdn0zRJzFx20qYlmkp1nRWa6b/QV1s5mGw/vOFfWVPGyFpamT99ZakWX8
	 w4AJc2ZPLL1GCLRQHSPD9Vy184V/woXqu5dbF1csoLklaQ9iDg0SwDJZNnm+Eal1de
	 L6ZUOiadajBEHbJV8P0omeFZdtV3ND0TtWUm3W8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 375/438] watchdog: digicolor: Avoid division by zero
Date: Wed, 23 Sep 2026 16:06:36 +0200
Message-ID: <20260923140654.583313212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
 


