Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853103E49EF;
	Tue, 21 Jul 2026 17:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655745; cv=none; b=Tt0GMXanwi1U6tlg90JRMjCTEnYS3IMrKbj+Ic/6y1aIwWPvIlKPfz1KhOQb+olHxiBF9KFdEevP/xJBXIZcPw6QxplIvQXuGvEX4M3uOSfoxI1Py2P6leowfb3VBDbZK3tGHMgc8yglnbkpr69ZavGPl+Y0060t3WUJvk3ZrE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655745; c=relaxed/simple;
	bh=TOKhgiJbivNvIB291oJQoRJTmyZaY+5L3cwkRKaev1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgmQlQTh+ndMAA9dO0C+tg3pE3RDbIF9q36vC4m6wA0ThWHV5DCAK7kwzKWK99/jRvFtTAoaX8xLLonpU8ZfDR0qapOetDh4mclDT+7isqlUN1q1cPvjOfpKNHReswfxjzN8KqDpxdscJw6xe3aBRD4CUjLh869erEOMkF0IVSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTm5JlPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTm5JlPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB56C1F000E9;
	Tue, 21 Jul 2026 17:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655744;
	bh=2WqG9+F/v3+WGPnu83EHVGauZL7y/2KeJ3zkZuYtz1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTm5JlPGyjtVrd3JwSA39jUUAzfKWmQtV1uBGRFQMm2c0Su81XStFQaksuR//e0EA
	 R35PtBIoLIYRJcBBlMeWp+hKzoQMZ3DMQZHeAUx/7OOtLmGFaMXPaxzB5cn70RkS7F
	 3F0LCxaAEj+2UoCP6O4tSeg0peeuiVKZq/Ahilnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Simion <andrei.simion@microchip.com>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0098/1611] watchdog: sama5d4_wdt: Fix WDDIS detection on SAM9X60 and SAMA7G5
Date: Tue, 21 Jul 2026 17:03:34 +0200
Message-ID: <20260721152517.049628247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit e8bc610b14a99d24b0916635102cc52ba41def9b ]

The driver hardcoded AT91_WDT_WDDIS (bit 15) in wdt_enabled and the
probe initial state readout. SAM9X60 and SAMA7G5 use bit 12
(AT91_SAM9X60_WDDIS), causing incorrect WDDIS detection.

Introduce a per-device wddis_mask field to select the correct WDDIS
bit based on the compatible string.

Fixes: 266da53c35fc ("watchdog: sama5d4: readout initial state")
Co-developed-by: Andrei Simion <andrei.simion@microchip.com>
Signed-off-by: Andrei Simion <andrei.simion@microchip.com>
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20260302113310.133989-2-balakrishnan.s@microchip.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sama5d4_wdt.c | 48 +++++++++++++++-------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/watchdog/sama5d4_wdt.c b/drivers/watchdog/sama5d4_wdt.c
index 13e72918338a20..704b786cc2ec63 100644
--- a/drivers/watchdog/sama5d4_wdt.c
+++ b/drivers/watchdog/sama5d4_wdt.c
@@ -30,6 +30,7 @@ struct sama5d4_wdt {
 	void __iomem		*reg_base;
 	u32			mr;
 	u32			ir;
+	u32			wddis_mask;
 	unsigned long		last_ping;
 	bool			need_irq;
 	bool			sam9x60_support;
@@ -48,7 +49,10 @@ MODULE_PARM_DESC(nowayout,
 	"Watchdog cannot be stopped once started (default="
 	__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-#define wdt_enabled (!(wdt->mr & AT91_WDT_WDDIS))
+static inline bool wdt_enabled(struct sama5d4_wdt *wdt)
+{
+	return !(wdt->mr & wdt->wddis_mask);
+}
 
 #define wdt_read(wdt, field) \
 	readl_relaxed((wdt)->reg_base + (field))
@@ -81,12 +85,9 @@ static int sama5d4_wdt_start(struct watchdog_device *wdd)
 {
 	struct sama5d4_wdt *wdt = watchdog_get_drvdata(wdd);
 
-	if (wdt->sam9x60_support) {
+	if (wdt->sam9x60_support)
 		writel_relaxed(wdt->ir, wdt->reg_base + AT91_SAM9X60_IER);
-		wdt->mr &= ~AT91_SAM9X60_WDDIS;
-	} else {
-		wdt->mr &= ~AT91_WDT_WDDIS;
-	}
+	wdt->mr &= ~wdt->wddis_mask;
 	wdt_write(wdt, AT91_WDT_MR, wdt->mr);
 
 	return 0;
@@ -96,12 +97,9 @@ static int sama5d4_wdt_stop(struct watchdog_device *wdd)
 {
 	struct sama5d4_wdt *wdt = watchdog_get_drvdata(wdd);
 
-	if (wdt->sam9x60_support) {
+	if (wdt->sam9x60_support)
 		writel_relaxed(wdt->ir, wdt->reg_base + AT91_SAM9X60_IDR);
-		wdt->mr |= AT91_SAM9X60_WDDIS;
-	} else {
-		wdt->mr |= AT91_WDT_WDDIS;
-	}
+	wdt->mr |= wdt->wddis_mask;
 	wdt_write(wdt, AT91_WDT_MR, wdt->mr);
 
 	return 0;
@@ -117,7 +115,7 @@ static int sama5d4_wdt_ping(struct watchdog_device *wdd)
 }
 
 static int sama5d4_wdt_set_timeout(struct watchdog_device *wdd,
-				 unsigned int timeout)
+				    unsigned int timeout)
 {
 	struct sama5d4_wdt *wdt = watchdog_get_drvdata(wdd);
 	u32 value = WDT_SEC2TICKS(timeout);
@@ -140,8 +138,8 @@ static int sama5d4_wdt_set_timeout(struct watchdog_device *wdd,
 	 * If the watchdog is enabled, then the timeout can be updated. Else,
 	 * wait that the user enables it.
 	 */
-	if (wdt_enabled)
-		wdt_write(wdt, AT91_WDT_MR, wdt->mr & ~AT91_WDT_WDDIS);
+	if (wdt_enabled(wdt))
+		wdt_write(wdt, AT91_WDT_MR, wdt->mr & ~wdt->wddis_mask);
 
 	wdd->timeout = timeout;
 
@@ -184,10 +182,7 @@ static int of_sama5d4_wdt_init(struct device_node *np, struct sama5d4_wdt *wdt)
 {
 	const char *tmp;
 
-	if (wdt->sam9x60_support)
-		wdt->mr = AT91_SAM9X60_WDDIS;
-	else
-		wdt->mr = AT91_WDT_WDDIS;
+	wdt->mr = wdt->wddis_mask;
 
 	if (!of_property_read_string(np, "atmel,watchdog-type", &tmp) &&
 	    !strcmp(tmp, "software"))
@@ -213,15 +208,11 @@ static int sama5d4_wdt_init(struct sama5d4_wdt *wdt)
 	 * If the watchdog is already running, we can safely update it.
 	 * Else, we have to disable it properly.
 	 */
-	if (!wdt_enabled) {
+	if (!wdt_enabled(wdt)) {
 		reg = wdt_read(wdt, AT91_WDT_MR);
-		if (wdt->sam9x60_support && (!(reg & AT91_SAM9X60_WDDIS)))
-			wdt_write_nosleep(wdt, AT91_WDT_MR,
-					  reg | AT91_SAM9X60_WDDIS);
-		else if (!wdt->sam9x60_support &&
-			 (!(reg & AT91_WDT_WDDIS)))
+		if (!(reg & wdt->wddis_mask))
 			wdt_write_nosleep(wdt, AT91_WDT_MR,
-					  reg | AT91_WDT_WDDIS);
+					  reg | wdt->wddis_mask);
 	}
 
 	if (wdt->sam9x60_support) {
@@ -273,6 +264,9 @@ static int sama5d4_wdt_probe(struct platform_device *pdev)
 	    of_device_is_compatible(dev->of_node, "microchip,sama7g5-wdt"))
 		wdt->sam9x60_support = true;
 
+	wdt->wddis_mask = wdt->sam9x60_support ? AT91_SAM9X60_WDDIS
+						: AT91_WDT_WDDIS;
+
 	watchdog_set_drvdata(wdd, wdt);
 
 	regs = devm_platform_ioremap_resource(pdev, 0);
@@ -306,8 +300,8 @@ static int sama5d4_wdt_probe(struct platform_device *pdev)
 	watchdog_init_timeout(wdd, wdt_timeout, dev);
 
 	reg = wdt_read(wdt, AT91_WDT_MR);
-	if (!(reg & AT91_WDT_WDDIS)) {
-		wdt->mr &= ~AT91_WDT_WDDIS;
+	if (!(reg & wdt->wddis_mask)) {
+		wdt->mr &= ~wdt->wddis_mask;
 		set_bit(WDOG_HW_RUNNING, &wdd->status);
 	}
 
-- 
2.53.0



