Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DAF33DEF9;
	Wed, 30 Sep 2026 18:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792187; cv=none; b=J86pMwy9f1SLFo6Uf81Fn3XcPjrmN+fQ6ZQJNuv2mApynLXIQfxDZdvHca9ubBxuUmMsNfzLLow/ZDHxycI+OCS57xslzfKV4R89U68E6ZCfsLSgRo/kPAKjp6/dIwE/daDDjUHCYsgdA6I2w9uJMS7UI4L0MTvMnn/A6GZuQVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792187; c=relaxed/simple;
	bh=tWqZaZe+hs64JTV/VPD3fpoGwqvtWR2FOgLQyhb5hqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAj3qhq+PNJQ3qWH5x7CbajbNVKftPsBPZ0yuRgH+1h3dSZ2fK8n4P9Asn63kTjHNiTAw9bpu6gJB1XjtgiRibKyq/6/lrBQileRBzH1fNnRq93PRAl9lWKfz2SiOzN7wE1HZnBOSJXt2EsJb2Jr2xB4MPaFDjBHZGEIWOehkL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyFRfzX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyFRfzX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959F01F000FF;
	Wed, 30 Sep 2026 18:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792186;
	bh=Bnc1sNg8U27WMGjt1fg3ZdL4PzhjCQU8ATDCooRy+ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyFRfzX3dT8vEwiN0gslrFTRXsuioaaWvpOZRZTY6W/qr9g0H3OMFBwcMsE5PIlBh
	 wfAQYqEcseXchO1s2qmMHUMtsvvMpOGH23NDi9oxJWkAim0yOTpYcXPX3R+gTxwY9m
	 otg3wi09K0eld3Qx+YXFK6yWRZoliD2cgRVCoXag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 567/752] watchdog: digicolor: Avoid division by zero
Date: Wed, 30 Sep 2026 17:27:17 +0200
Message-ID: <20260930152410.506236310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


