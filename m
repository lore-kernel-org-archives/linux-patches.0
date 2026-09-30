Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B09F4E06FC;
	Wed, 30 Sep 2026 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785422; cv=none; b=drq6FMFcK3j2A0TX2YNg3YNN19TPGbxnFuIch1JNJ12lCkWlIcZ62HZ92dsVQlt6s87QfjEV51n5TEh3NDZLlr0qXVz+02uPNS7L8TC9A/P6rl59WriW00ePfEPYPmgeDtOp/g3tSNiBIxNBStqZy6ieMaOZXp+aWKR6EbRrh44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785422; c=relaxed/simple;
	bh=7MM3dZ/pQEYzZxL0ASnagD8iBGVa7Ys5c4M6yHeZCHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyBRB5eLNvdY/X99y/ZYkQmgdx35qTloTGAtrEvKRt+VnaENYrJFbO5WefDblYx14AwZgQHpSyAkuItHslWBrjRSFHgryxz051pYUALu/6YWFce5a44Gh3IrP2cg5aCJKW1GlT8JVVPXFXwQSM84u01Ob3egGX5o05RyxWq/3dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+HKMNB7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+HKMNB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DF61F000FF;
	Wed, 30 Sep 2026 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785415;
	bh=uTVA2+Q0/W27lqcpudu27Z78VGlE1r8hYWs7jS9G1Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+HKMNB7/WReeP7dwsVK2vg1uZeDx8Y4WLJq1LEmn2PIGx2YtqXx+FMaOUzQT4Z7X
	 Nhsy/7pGkU4nDWuo66dPOz4J2DEPp+C/XcCKAwKgnqr2jUc/iBrrBoDm4xi49+6mms
	 cAndyMJP9zcZ7tLag4FmOCgEhvyTU+ANREFySqQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 502/982] watchdog: sunxi_wdt: preserve boot-enabled watchdog
Date: Wed, 30 Sep 2026 17:20:38 +0200
Message-ID: <20260930152427.563099851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hilliard <james.hilliard1@gmail.com>

commit aab55360fa11a2c054798a484ac67ad606f563e4 upstream.

sunxi_wdt_probe() unconditionally stops the watchdog even when firmware
left it running. This opens an unprotected interval during boot and
prevents CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED from taking over the active
watchdog.

Detect an enabled watchdog and decode its programmed interval. Preserve
representable timeouts, and round the 0.5-second interval up to the
minimum representable one-second timeout. Use the configured timeout for
reserved interval encodings. Set the Linux reset mode and ping the
watchdog without clearing its enable bit, then mark it hardware-running
before registration so the watchdog core services it until userspace
takes control. Leave disabled watchdogs untouched.

Fixes: d00680ed0026 ("watchdog: sunxi: New watchdog driver for Allwinner A10/A13")
Cc: stable@vger.kernel.org
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20260827-submit-sunxi-wdt-boot-enabled-v1-v2-1-610d37dccc97@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/sunxi_wdt.c |   45 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/sunxi_wdt.c
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -129,6 +129,38 @@ static int sunxi_wdt_ping(struct watchdo
 	return 0;
 }
 
+static bool sunxi_wdt_is_running(struct watchdog_device *wdt_dev)
+{
+	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
+	const struct sunxi_wdt_reg *regs = sunxi_wdt->wdt_regs;
+
+	return readl(sunxi_wdt->wdt_base + regs->wdt_mode) & WDT_MODE_EN;
+}
+
+static unsigned int sunxi_wdt_get_timeout(struct watchdog_device *wdt_dev)
+{
+	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
+	const struct sunxi_wdt_reg *regs = sunxi_wdt->wdt_regs;
+	unsigned int timeout;
+	u32 interval;
+
+	interval = readl(sunxi_wdt->wdt_base + regs->wdt_mode);
+	interval >>= regs->wdt_timeout_shift;
+	interval &= WDT_TIMEOUT_MASK;
+	/* Round the 0.5-second interval up to the minimum representable timeout. */
+	if (!interval)
+		return WDT_MIN_TIMEOUT;
+
+	for (timeout = WDT_MIN_TIMEOUT;
+	     timeout < ARRAY_SIZE(wdt_timeout_map); timeout++) {
+		if (wdt_timeout_map[timeout] == interval)
+			return timeout;
+	}
+
+	/* Reserved interval encoding. */
+	return 0;
+}
+
 static int sunxi_wdt_set_timeout(struct watchdog_device *wdt_dev,
 		unsigned int timeout)
 {
@@ -249,6 +281,7 @@ static int sunxi_wdt_probe(struct platfo
 {
 	struct device *dev = &pdev->dev;
 	struct sunxi_wdt_dev *sunxi_wdt;
+	unsigned int running_timeout;
 	int err;
 
 	sunxi_wdt = devm_kzalloc(dev, sizeof(*sunxi_wdt), GFP_KERNEL);
@@ -276,7 +309,17 @@ static int sunxi_wdt_probe(struct platfo
 
 	watchdog_set_drvdata(&sunxi_wdt->wdt_dev, sunxi_wdt);
 
-	sunxi_wdt_stop(&sunxi_wdt->wdt_dev);
+	if (sunxi_wdt_is_running(&sunxi_wdt->wdt_dev)) {
+		running_timeout = sunxi_wdt_get_timeout(&sunxi_wdt->wdt_dev);
+		if (running_timeout)
+			sunxi_wdt->wdt_dev.timeout = running_timeout;
+
+		err = sunxi_wdt_start(&sunxi_wdt->wdt_dev);
+		if (err)
+			return err;
+
+		set_bit(WDOG_HW_RUNNING, &sunxi_wdt->wdt_dev.status);
+	}
 
 	watchdog_stop_on_reboot(&sunxi_wdt->wdt_dev);
 	err = devm_watchdog_register_device(dev, &sunxi_wdt->wdt_dev);


