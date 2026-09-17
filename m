Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292C251B177;
	Thu, 17 Sep 2026 17:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667344; cv=none; b=SDJ9gukS/lEqYb8x4fDEC+Y+pdC6b+AxRVhAbxkQjOEi5iRYwt7HGrBqRtwGJ0VkmZ/aWbdSWDbBvaVIeZ5nzVXpXIBv4NWlZ3YQltX23NJkAb8X1HtF2ObdivawN2zkTxNk6/KAp1fqEklziHV9viHBmtyUQ0gHmCB4EQzepbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667344; c=relaxed/simple;
	bh=S8AMuKDJBW+StVebc8XukIQ3pMkwRO2UiPdasVJKjSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oH0RmuGeU3UboaEWdfBBGpbGrS5BhhVdFSY5bcFt75gP3uf3rJ4/w5FBdW/elq3OZrWyOdBfNFjlqehBaut8hub8opN51h0iQV+I+Ox9Urr+MB87wQXZ218qR12Y+E8O3j08ZIe61W+UmQ0VXxqHHeyNSlQfKu2Zvrfwn2Gxeyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9wH+Fzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9wH+Fzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE581F000FF;
	Thu, 17 Sep 2026 17:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667343;
	bh=EkwUiMzr0lHTreenSVO1YDrm73aQEm6ez5dZIYoKbSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U9wH+FzlEbTwp0p0lu+Fy6atbvgM4ZacGokKK1tfAssIsHvbjhVPGWjCTSmkN0l+A
	 F9qWaq0b6iSsxZ+QMNoLLOsLHW+FpI3hvlsRK73RFzHhmVjpse85LWNWSTLIbKxGBl
	 y1McYUnKuNuAqbtI0FBV4HnPLccc0MomWs2UIcfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0062/1102] watchdog: imx7ulp_wdt: Keep WDOG running until A55 enters WFI on i.MX94
Date: Thu, 17 Sep 2026 16:00:05 +0100
Message-ID: <20260917151541.013889664@linuxfoundation.org>
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

From: Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>

[ Upstream commit 1f5b29add64e7c1500530079bbbe359cad28cb63 ]

On i.MX94, watchdog sources clock from bus clock that will be always on
during the lifecycle of Linux. There is a Low Power Clock Gating(LPCG)
between the bus clock and watchdog, but the LPCG is not exported for
software to control, it is hardware automatically controlled. When
Cortex-A55 executes WFI during suspend flow, the LPCG will automatically
gate off the clock to stop watchdog and resume clock when Cortex-A55 is
woke up.

So watchdog could always be alive to protect Linux, except Cortex-A
platform WFI is executed in Linux suspend flow.

Introduce a new hardware feature flag to indicate CPU low-power-mode
auto clock gating support, and use it to avoid stopping the watchdog
during suspend when LPCG can safely keep it running.

Add i.MX94-specific watchdog hardware data and DT compatible entry to
enable this behavior.

Signed-off-by: Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>
[peng.fan@nxp.com: rewrite commit log for clarity]
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20260206-imx94-wdog-v2-1-4dd725faec1f@nxp.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/imx7ulp_wdt.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/imx7ulp_wdt.c b/drivers/watchdog/imx7ulp_wdt.c
index 03479110453ce..855dc9d5083a5 100644
--- a/drivers/watchdog/imx7ulp_wdt.c
+++ b/drivers/watchdog/imx7ulp_wdt.c
@@ -56,6 +56,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 struct imx_wdt_hw_feature {
 	bool prescaler_enable;
 	bool post_rcs_wait;
+	bool cpu_lpm_auto_cg;
 	u32 wdog_clock_rate;
 };
 
@@ -360,7 +361,7 @@ static int __maybe_unused imx7ulp_wdt_suspend_noirq(struct device *dev)
 {
 	struct imx7ulp_wdt_device *imx7ulp_wdt = dev_get_drvdata(dev);
 
-	if (watchdog_active(&imx7ulp_wdt->wdd))
+	if (watchdog_active(&imx7ulp_wdt->wdd) && !imx7ulp_wdt->hw->cpu_lpm_auto_cg)
 		imx7ulp_wdt_stop(&imx7ulp_wdt->wdd);
 
 	clk_disable_unprepare(imx7ulp_wdt->clk);
@@ -408,10 +409,17 @@ static const struct imx_wdt_hw_feature imx93_wdt_hw = {
 	.wdog_clock_rate = 125,
 };
 
+static const struct imx_wdt_hw_feature imx94_wdt_hw = {
+	.prescaler_enable = true,
+	.wdog_clock_rate = 125,
+	.cpu_lpm_auto_cg = true,
+};
+
 static const struct of_device_id imx7ulp_wdt_dt_ids[] = {
 	{ .compatible = "fsl,imx7ulp-wdt", .data = &imx7ulp_wdt_hw, },
 	{ .compatible = "fsl,imx8ulp-wdt", .data = &imx8ulp_wdt_hw, },
 	{ .compatible = "fsl,imx93-wdt", .data = &imx93_wdt_hw, },
+	{ .compatible = "fsl,imx94-wdt", .data = &imx94_wdt_hw, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, imx7ulp_wdt_dt_ids);
-- 
2.53.0



