Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BC64195C9;
	Tue, 21 Jul 2026 20:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665635; cv=none; b=i8EPABOE8WdWXRJQl1hYKGv+be6dW7ek3wSf/vDtJPYgaR8Aa2vVrblLGqGWXDFldpr78xBfjV9UroPrm/lR7KUzu5Tnw71H6LfwlZsEjjQvo7DCZbMYmRuQo+9AxoRhbK5DIuCB4/946RUbx7lzZN5AED2l9w0NrZVuMhwA77o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665635; c=relaxed/simple;
	bh=nL7OZ5/uAm8eHz5ruK2wWR/dgqE4MrrMg/TK3NHRXkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTpelXBhO/N0TbGAaCEyT2N9FMra6WMQh2Zq3XHAdy6ze9Lla8HorVEPl84fioAGKfRp291fKr0nFgYqfCk+5u5W5W8PtVOaqkpzPMaMpyqh6RxB0NnPBF3xmFo8WN1VCLAsBr+wYPvw39Tr9abcWBSy6s+n8oogaBCq0IsnjI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBXUhcaT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBXUhcaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E38D1F000E9;
	Tue, 21 Jul 2026 20:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665634;
	bh=yOXtq799S4pVAN5fuNT8drfGglMaYIRE1UaMN8U2v+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBXUhcaTXeKb7JViBxjbv+kyo7P09tyoUEvaQXUQuxw6AJbMj9VnVQOrv/P98AW5K
	 5rasL9zSOef55NImU01r4gvx2Nq54swocWF09wRQAnQD8rz77L0vP3GwILAcU7SN5N
	 1w862ITRfYxwMelEtkfOdk65rhxQ7FC8my2wHqBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Simion <andrei.simion@microchip.com>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0379/1266] watchdog: sama5d4_wdt: Fix WDDIS detection on SAM9X60 and SAMA7G5
Date: Tue, 21 Jul 2026 17:13:36 +0200
Message-ID: <20260721152450.307321299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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



