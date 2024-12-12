Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9677B2135C1;
	Thu, 12 Dec 2024 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017461; cv=none; b=lqoNZNTefmuR+XGMXtGhZQfIh9RZGATvbLyLUJ/nIo5+V082BwJbm1LcfEribtIBHu1TciBYhWJllP+9E1pLbd/Ishcgq/forzQ4+t6kLzhZ5yNcAwJLan/TfNEzKq48fxT3PIg7i5PLSrBST2JU/9eU+FKE9UjOY2lkVvrkF48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017461; c=relaxed/simple;
	bh=OxN0g+00PXgLXsFKJFoAb7K6q93jH+EO2WG+IFzxwDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxMb3oiCD3ZNklLpn2SPXy5OD+1xOVZCfw/B98ctCHDPKeunZd9OgkEjAnwzJJ3vCcjQKx4hAch1PqidNSRTY3Cselyd6JdNzJlV8Ohaieyv+5kzrjrpujc1Z0rfEqfCFm+J9kAJAuig5oUtjIQMBW43FE+l9tp6oNYpus45fVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pd/wsQfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pd/wsQfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D6EC4CECE;
	Thu, 12 Dec 2024 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017461;
	bh=OxN0g+00PXgLXsFKJFoAb7K6q93jH+EO2WG+IFzxwDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pd/wsQfPNSyHqhOwb2qLzdujdrq5EuZnnmgALTY5Ej/QzDAn76aSubqNgpfcppR8x
	 gMkqARsawZAO0NIA2wZdcoISGxy3xSd06kiBX6TMXnhjuDy7+CKvOXd8GvFDNr8Wyc
	 M6UrYLM2TjFwcaFk6R+5/EkZP59PVgs53CZCcHko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/356] watchdog: xilinx_wwdt: Calculate max_hw_heartbeat_ms using clock frequency
Date: Thu, 12 Dec 2024 15:55:21 +0100
Message-ID: <20241212144244.708989034@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Harini T <harini.t@amd.com>

[ Upstream commit 006778844c2c132c28cfa90e3570560351e01b9a ]

In the current implementation, the value of max_hw_heartbeat_ms is set
to the timeout period expressed in milliseconds and fails to verify if
the close window percentage exceeds the maximum value that the hardware
supports.

1. Calculate max_hw_heartbeat_ms based on input clock frequency.
2. Update frequency check to require a minimum frequency of 1Mhz.
3. Limit the close and open window percent to hardware supported value
to avoid truncation.
4. If the user input timeout exceeds the maximum timeout supported, use
only open window and the framework supports the higher timeouts.

Fixes: 12984cea1b8c ("watchdog: xilinx_wwdt: Add Versal window watchdog support")
Signed-off-by: Harini T <harini.t@amd.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240913113230.1939373-1-harini.t@amd.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/xilinx_wwdt.c | 75 ++++++++++++++++++++++++++++------
 1 file changed, 63 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/xilinx_wwdt.c b/drivers/watchdog/xilinx_wwdt.c
index d271e2e8d6e27..3d2a156f71800 100644
--- a/drivers/watchdog/xilinx_wwdt.c
+++ b/drivers/watchdog/xilinx_wwdt.c
@@ -2,7 +2,7 @@
 /*
  * Window watchdog device driver for Xilinx Versal WWDT
  *
- * Copyright (C) 2022 - 2023, Advanced Micro Devices, Inc.
+ * Copyright (C) 2022 - 2024, Advanced Micro Devices, Inc.
  */
 
 #include <linux/clk.h>
@@ -36,6 +36,12 @@
 
 #define XWWDT_CLOSE_WINDOW_PERCENT	50
 
+/* Maximum count value of each 32 bit window */
+#define XWWDT_MAX_COUNT_WINDOW		GENMASK(31, 0)
+
+/* Maximum count value of closed and open window combined */
+#define XWWDT_MAX_COUNT_WINDOW_COMBINED	GENMASK_ULL(32, 1)
+
 static int wwdt_timeout;
 static int closed_window_percent;
 
@@ -54,6 +60,8 @@ MODULE_PARM_DESC(closed_window_percent,
  * @xilinx_wwdt_wdd: watchdog device structure
  * @freq: source clock frequency of WWDT
  * @close_percent: Closed window percent
+ * @closed_timeout: Closed window timeout in ticks
+ * @open_timeout: Open window timeout in ticks
  */
 struct xwwdt_device {
 	void __iomem *base;
@@ -61,27 +69,22 @@ struct xwwdt_device {
 	struct watchdog_device xilinx_wwdt_wdd;
 	unsigned long freq;
 	u32 close_percent;
+	u64 closed_timeout;
+	u64 open_timeout;
 };
 
 static int xilinx_wwdt_start(struct watchdog_device *wdd)
 {
 	struct xwwdt_device *xdev = watchdog_get_drvdata(wdd);
 	struct watchdog_device *xilinx_wwdt_wdd = &xdev->xilinx_wwdt_wdd;
-	u64 time_out, closed_timeout, open_timeout;
 	u32 control_status_reg;
 
-	/* Calculate timeout count */
-	time_out = xdev->freq * wdd->timeout;
-	closed_timeout = div_u64(time_out * xdev->close_percent, 100);
-	open_timeout = time_out - closed_timeout;
-	wdd->min_hw_heartbeat_ms = xdev->close_percent * 10 * wdd->timeout;
-
 	spin_lock(&xdev->spinlock);
 
 	iowrite32(XWWDT_MWR_MASK, xdev->base + XWWDT_MWR_OFFSET);
 	iowrite32(~(u32)XWWDT_ESR_WEN_MASK, xdev->base + XWWDT_ESR_OFFSET);
-	iowrite32((u32)closed_timeout, xdev->base + XWWDT_FWR_OFFSET);
-	iowrite32((u32)open_timeout, xdev->base + XWWDT_SWR_OFFSET);
+	iowrite32((u32)xdev->closed_timeout, xdev->base + XWWDT_FWR_OFFSET);
+	iowrite32((u32)xdev->open_timeout, xdev->base + XWWDT_SWR_OFFSET);
 
 	/* Enable the window watchdog timer */
 	control_status_reg = ioread32(xdev->base + XWWDT_ESR_OFFSET);
@@ -133,7 +136,12 @@ static int xwwdt_probe(struct platform_device *pdev)
 	struct watchdog_device *xilinx_wwdt_wdd;
 	struct device *dev = &pdev->dev;
 	struct xwwdt_device *xdev;
+	u64 max_per_window_ms;
+	u64 min_per_window_ms;
+	u64 timeout_count;
 	struct clk *clk;
+	u32 timeout_ms;
+	u64 ms_count;
 	int ret;
 
 	xdev = devm_kzalloc(dev, sizeof(*xdev), GFP_KERNEL);
@@ -154,12 +162,13 @@ static int xwwdt_probe(struct platform_device *pdev)
 		return PTR_ERR(clk);
 
 	xdev->freq = clk_get_rate(clk);
-	if (!xdev->freq)
+	if (xdev->freq < 1000000)
 		return -EINVAL;
 
 	xilinx_wwdt_wdd->min_timeout = XWWDT_MIN_TIMEOUT;
 	xilinx_wwdt_wdd->timeout = XWWDT_DEFAULT_TIMEOUT;
-	xilinx_wwdt_wdd->max_hw_heartbeat_ms = 1000 * xilinx_wwdt_wdd->timeout;
+	xilinx_wwdt_wdd->max_hw_heartbeat_ms =
+		div64_u64(XWWDT_MAX_COUNT_WINDOW_COMBINED, xdev->freq) * 1000;
 
 	if (closed_window_percent == 0 || closed_window_percent >= 100)
 		xdev->close_percent = XWWDT_CLOSE_WINDOW_PERCENT;
@@ -167,6 +176,48 @@ static int xwwdt_probe(struct platform_device *pdev)
 		xdev->close_percent = closed_window_percent;
 
 	watchdog_init_timeout(xilinx_wwdt_wdd, wwdt_timeout, &pdev->dev);
+
+	/* Calculate ticks for 1 milli-second */
+	ms_count = div_u64(xdev->freq, 1000);
+	timeout_ms = xilinx_wwdt_wdd->timeout * 1000;
+	timeout_count = timeout_ms * ms_count;
+
+	if (timeout_ms > xilinx_wwdt_wdd->max_hw_heartbeat_ms) {
+		/*
+		 * To avoid ping restrictions until the minimum hardware heartbeat,
+		 * we will solely rely on the open window and
+		 * adjust the minimum hardware heartbeat to 0.
+		 */
+		xdev->closed_timeout = 0;
+		xdev->open_timeout = XWWDT_MAX_COUNT_WINDOW;
+		xilinx_wwdt_wdd->min_hw_heartbeat_ms = 0;
+		xilinx_wwdt_wdd->max_hw_heartbeat_ms = xilinx_wwdt_wdd->max_hw_heartbeat_ms / 2;
+	} else {
+		xdev->closed_timeout  = div64_u64(timeout_count * xdev->close_percent, 100);
+		xilinx_wwdt_wdd->min_hw_heartbeat_ms =
+			div64_u64(timeout_ms * xdev->close_percent, 100);
+
+		if (timeout_ms > xilinx_wwdt_wdd->max_hw_heartbeat_ms / 2) {
+			max_per_window_ms = xilinx_wwdt_wdd->max_hw_heartbeat_ms / 2;
+			min_per_window_ms = timeout_ms - max_per_window_ms;
+
+			if (xilinx_wwdt_wdd->min_hw_heartbeat_ms > max_per_window_ms) {
+				dev_info(xilinx_wwdt_wdd->parent,
+					 "Closed window cannot be set to %d%%. Using maximum supported value.\n",
+					xdev->close_percent);
+				xdev->closed_timeout = max_per_window_ms * ms_count;
+				xilinx_wwdt_wdd->min_hw_heartbeat_ms = max_per_window_ms;
+			} else if (xilinx_wwdt_wdd->min_hw_heartbeat_ms < min_per_window_ms) {
+				dev_info(xilinx_wwdt_wdd->parent,
+					 "Closed window cannot be set to %d%%. Using minimum supported value.\n",
+					xdev->close_percent);
+				xdev->closed_timeout = min_per_window_ms * ms_count;
+				xilinx_wwdt_wdd->min_hw_heartbeat_ms = min_per_window_ms;
+			}
+		}
+		xdev->open_timeout = timeout_count - xdev->closed_timeout;
+	}
+
 	spin_lock_init(&xdev->spinlock);
 	watchdog_set_drvdata(xilinx_wwdt_wdd, xdev);
 	watchdog_set_nowayout(xilinx_wwdt_wdd, 1);
-- 
2.43.0



