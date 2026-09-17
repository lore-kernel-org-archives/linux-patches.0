Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A514B44A4;
	Thu, 17 Sep 2026 16:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661112; cv=none; b=lhTI8pOWD8F466bhn3wDn9qe5DsziXVYm8xIcNcZourU5VIZ61veMQAe3NRB8UcK9c0MSktMz66d2k5G4k2zqzglUTni1BjXGbVuFZmd0adLz5UFiCb5qkat3frA0f3m6K2gckf9dnrTFAHuyejqweu5ONxmYt8OZ69886sgg1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661112; c=relaxed/simple;
	bh=gM6TGsRm0U9ss0qK2jDAP+89YLTdC/c3JnewXur+fSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0zNPzcQS6uOb7cBxQ1tt2MUKo586p004lErG9XYO4hPB9kBGDjbtXP3zm34sC9oxpf67u3Rf/3ScDq46VKJoMahS1eCVpM2pJPTEmYWTTHNfjWSZorS27Hbpqii7xh8eZ0EinCpGs+1ISh7r+glZsehGlatP9yfaz+I2wdglNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNm9z3Uf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNm9z3Uf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CE01F000FF;
	Thu, 17 Sep 2026 16:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661111;
	bh=mrX0Ej7u7i+iZgGmnEw0OtiVP36KZVy5S7aLtiCF0zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNm9z3Uf4B6rdYJPzpMr6aI9dVL4mo11hIdp2jYeBC45gbvkB9Pi0715Jgofe1Z1H
	 VkGH6LeYoIw515wIovwSGtcFcittiWcwlxW2yPnIE1r/cZFL0TJXKfSgTTn4KlpsUE
	 d/pY7uhSy64Z92o/VmgSgXgYiEaJWH1Nk+LvV198=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0087/1250] watchdog: imx7ulp_wdt: Keep WDOG running until A55 enters WFI on i.MX94
Date: Thu, 17 Sep 2026 15:58:02 +0100
Message-ID: <20260917151554.340958821@linuxfoundation.org>
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



