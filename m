Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3528252F29E;
	Thu, 17 Sep 2026 17:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666288; cv=none; b=gD0f7yUK3QBUzh5xdo2740LZqIRDuZ67yKVBvQv4vT1KFuV5OniuhhxTFfKMpqXK5Q/gfI4qbD26Ebo3XatK6bUuUDRBSfW5B99xBwLbtEHZb62lJJNVYpv83Xq4UFFjM78CQI5MqXChWdBxawiJ/1tlEVbvNYsK0a6Kxn0VsYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666288; c=relaxed/simple;
	bh=ogziZGBIweYml83XMTOoPZ33QjHhyc1xl4Pw0IGCs3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfMyjIIz36AklDfIRPF8vosKXvyI7vHnHlxVEKO7kkH8ftSZO/rCtlv+6Q+FPwYmA53eslVf1/IGjEEGAPTzW0TNX1BiUttzITS8unoPlTcjA8JkMOijt3jXDCUw8lnq1QM6p0NpfREA5FR63sV3XFRXKeT/KSl6C+DrvdY8MGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvUzF7u0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvUzF7u0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893FF1F000FF;
	Thu, 17 Sep 2026 17:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666287;
	bh=1K6i/qudXP0XzY9rLBJwp/ua8NsT7Jz2E5ZOuVt81eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BvUzF7u0sxQVbdFnD/CC3j/sDcEozBPfbOLJsOFbobqB9Qea0mBaBvuGinHFcNrov
	 ofstkgaDdK+e8gtRcn7KkdSKvNbn6sVnHzFj5UvjQ3+UdYs2SVRSMp+YItb1FgdFkx
	 YVRex9XoQGkHhdWbTFLE823MIK95mbbWyPCcKO/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 0980/1250] watchdog: sunxi_wdt: preserve boot-enabled watchdog
Date: Thu, 17 Sep 2026 16:12:55 +0100
Message-ID: <20260917151618.581280403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -128,6 +128,38 @@ static int sunxi_wdt_ping(struct watchdo
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
@@ -259,6 +291,7 @@ static int sunxi_wdt_probe(struct platfo
 {
 	struct device *dev = &pdev->dev;
 	struct sunxi_wdt_dev *sunxi_wdt;
+	unsigned int running_timeout;
 	int err;
 
 	sunxi_wdt = devm_kzalloc(dev, sizeof(*sunxi_wdt), GFP_KERNEL);
@@ -286,7 +319,17 @@ static int sunxi_wdt_probe(struct platfo
 
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


