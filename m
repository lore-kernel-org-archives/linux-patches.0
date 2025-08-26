Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0B31E7C08;
	Tue, 26 Aug 2025 13:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216365; cv=none; b=oLf8ThElc+xrycBiQEwdwvxcuhogYCwGvDaOGReqXhWBCW7IFtGQkqRl5UIx1ty5mme/icA0qjMTzdDcbS54/v2MLH2TEME6TJMtClB9Or+r8pJQv6o3V6nspF1dp2RGgsnfMeat30wJCNGjYzJ1k+eNMgSIUlFKGd2hrgtAo14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216365; c=relaxed/simple;
	bh=5mz5K6c/uUbufbHtI6Tr4cHW5ixFEjl2Y4JiM76tqrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKtqX0qvqNvj5mbF+CHLGzzBKo3y+zlEC3J6IzEYueqQ9OZcGvDwq/GK7j7nOROU6tL/VHGuRTP+tKgX52w+TwrrD474a2IzhQ5/JspPsbpsvpJwqCT4HdfBgrMB3GcwLjQvq6BhiBexlSWrYpu6iYjYRZc4AVHdJr3yTB8Xws8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7+re4hR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7+re4hR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17989C4CEF1;
	Tue, 26 Aug 2025 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216365;
	bh=5mz5K6c/uUbufbHtI6Tr4cHW5ixFEjl2Y4JiM76tqrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7+re4hRUL18VXVBv6yq59pTowpPGSpUy+KP17GyPRhSU1HcCe9wZBaQcUEZfSMK+
	 bq/5IGbllMM1wlkYKXatNapV1/7m0C4fNHG+IEUmtAdGvdToZaRMXTTjRsTAwOiXws
	 cekRfGd5FoOaZ/deAZ+wFwDbkRzW8rMZOwSeTz4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Plattner <aplattner@nvidia.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 383/644] watchdog: sbsa: Adjust keepalive timeout to avoid MediaTek WS0 race condition
Date: Tue, 26 Aug 2025 13:07:54 +0200
Message-ID: <20250826110955.934905743@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Aaron Plattner <aplattner@nvidia.com>

[ Upstream commit 48defdf6b083f74a44e1f742db284960d3444aec ]

The MediaTek implementation of the sbsa_gwdt watchdog has a race
condition where a write to SBSA_GWDT_WRR is ignored if it occurs while
the hardware is processing a timeout refresh that asserts WS0.

Detect this based on the hardware implementer and adjust
wdd->min_hw_heartbeat_ms to avoid the race by forcing the keepalive ping
to be one second later.

Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Acked-by: Timur Tabi <ttabi@nvidia.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250721230640.2244915-1-aplattner@nvidia.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sbsa_gwdt.c | 50 +++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/sbsa_gwdt.c b/drivers/watchdog/sbsa_gwdt.c
index 7bf28545b47a..f07ffc7b8312 100644
--- a/drivers/watchdog/sbsa_gwdt.c
+++ b/drivers/watchdog/sbsa_gwdt.c
@@ -76,11 +76,17 @@
 #define SBSA_GWDT_VERSION_MASK  0xF
 #define SBSA_GWDT_VERSION_SHIFT 16
 
+#define SBSA_GWDT_IMPL_MASK	0x7FF
+#define SBSA_GWDT_IMPL_SHIFT	0
+#define SBSA_GWDT_IMPL_MEDIATEK	0x426
+
 /**
  * struct sbsa_gwdt - Internal representation of the SBSA GWDT
  * @wdd:		kernel watchdog_device structure
  * @clk:		store the System Counter clock frequency, in Hz.
  * @version:            store the architecture version
+ * @need_ws0_race_workaround:
+ *			indicate whether to adjust wdd->timeout to avoid a race with WS0
  * @refresh_base:	Virtual address of the watchdog refresh frame
  * @control_base:	Virtual address of the watchdog control frame
  */
@@ -88,6 +94,7 @@ struct sbsa_gwdt {
 	struct watchdog_device	wdd;
 	u32			clk;
 	int			version;
+	bool			need_ws0_race_workaround;
 	void __iomem		*refresh_base;
 	void __iomem		*control_base;
 };
@@ -162,6 +169,31 @@ static int sbsa_gwdt_set_timeout(struct watchdog_device *wdd,
 		 */
 		sbsa_gwdt_reg_write(((u64)gwdt->clk / 2) * timeout, gwdt);
 
+	/*
+	 * Some watchdog hardware has a race condition where it will ignore
+	 * sbsa_gwdt_keepalive() if it is called at the exact moment that a
+	 * timeout occurs and WS0 is being asserted. Unfortunately, the default
+	 * behavior of the watchdog core is very likely to trigger this race
+	 * when action=0 because it programs WOR to be half of the desired
+	 * timeout, and watchdog_next_keepalive() chooses the exact same time to
+	 * send keepalive pings.
+	 *
+	 * This triggers a race where sbsa_gwdt_keepalive() can be called right
+	 * as WS0 is being asserted, and affected hardware will ignore that
+	 * write and continue to assert WS0. After another (timeout / 2)
+	 * seconds, the same race happens again. If the driver wins then the
+	 * explicit refresh will reset WS0 to false but if the hardware wins,
+	 * then WS1 is asserted and the system resets.
+	 *
+	 * Avoid the problem by scheduling keepalive heartbeats one second later
+	 * than the WOR timeout.
+	 *
+	 * This workaround might not be needed in a future revision of the
+	 * hardware.
+	 */
+	if (gwdt->need_ws0_race_workaround)
+		wdd->min_hw_heartbeat_ms = timeout * 500 + 1000;
+
 	return 0;
 }
 
@@ -203,12 +235,15 @@ static int sbsa_gwdt_keepalive(struct watchdog_device *wdd)
 static void sbsa_gwdt_get_version(struct watchdog_device *wdd)
 {
 	struct sbsa_gwdt *gwdt = watchdog_get_drvdata(wdd);
-	int ver;
+	int iidr, ver, impl;
 
-	ver = readl(gwdt->control_base + SBSA_GWDT_W_IIDR);
-	ver = (ver >> SBSA_GWDT_VERSION_SHIFT) & SBSA_GWDT_VERSION_MASK;
+	iidr = readl(gwdt->control_base + SBSA_GWDT_W_IIDR);
+	ver = (iidr >> SBSA_GWDT_VERSION_SHIFT) & SBSA_GWDT_VERSION_MASK;
+	impl = (iidr >> SBSA_GWDT_IMPL_SHIFT) & SBSA_GWDT_IMPL_MASK;
 
 	gwdt->version = ver;
+	gwdt->need_ws0_race_workaround =
+		!action && (impl == SBSA_GWDT_IMPL_MEDIATEK);
 }
 
 static int sbsa_gwdt_start(struct watchdog_device *wdd)
@@ -300,6 +335,15 @@ static int sbsa_gwdt_probe(struct platform_device *pdev)
 	else
 		wdd->max_hw_heartbeat_ms = GENMASK_ULL(47, 0) / gwdt->clk * 1000;
 
+	if (gwdt->need_ws0_race_workaround) {
+		/*
+		 * A timeout of 3 seconds means that WOR will be set to 1.5
+		 * seconds and the heartbeat will be scheduled every 2.5
+		 * seconds.
+		 */
+		wdd->min_timeout = 3;
+	}
+
 	status = readl(cf_base + SBSA_GWDT_WCS);
 	if (status & SBSA_GWDT_WCS_WS1) {
 		dev_warn(dev, "System reset by WDT.\n");
-- 
2.39.5



