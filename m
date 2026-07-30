Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5235C43E9F9;
	Thu, 30 Jul 2026 15:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424237; cv=none; b=OLQhoGa2OmZFHljClcivOIWNYick20jaesA16voc26V9jH+OlFbmG3DaOYRnBE4XU8KY+LPD8JYZPi682tW1nOL8nixGERmaK0GzDvnrmhyI121OstASuqIQ3Sjjs8t2piAWK/ga11mnk+bwpidZXi6mPA4YISwZLMpraJPgsX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424237; c=relaxed/simple;
	bh=15OiwwliHBwS7MzLZ6m4x+nt7NKfrOTnF/IuZH1n/2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glFZUDcoKUOoBwo7SDyeazdAd66AsEDpwsSycIPPtqVJS5189zJ4Wl/NVmYUMWqMnjr4MFPRiha1i0ZB3Z9ikvXN3WLUWkFvkP++BW4aT1r1e2xdcGsoTk1f5HYaltA+hqQqPrrOXVvsGbwGovI/7CD7+rulRX1B82dW8LxAXl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BK/XQVOw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BK/XQVOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A529F1F000E9;
	Thu, 30 Jul 2026 15:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424236;
	bh=//wNIhCVET6fjU5w5mp4atkiinGEHTTvvo4H7Ili7GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BK/XQVOw+pIC2HpstkkoLHegygEV7CS4qQSknGfahGYXi8RO6Jg5drZJ/tBGVkwkq
	 kRke/ZcKRkAgCPTx93KZ7u9CY22HdOw7jzxlr+9UzueSMDXPvolzEQmKhoXVZnalV/
	 zA0D7L3GwS9Xmfpu506ezeGQhH4Oef2m1Ur+5qDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Vitor Soares <vitor.soares@toradex.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.18 324/675] drm/bridge: cdns-dsi: Replace deprecated UNIVERSAL_DEV_PM_OPS()
Date: Thu, 30 Jul 2026 16:10:54 +0200
Message-ID: <20260730141452.011685079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Vitor Soares <vitor.soares@toradex.com>

commit 2d8b08844c0ecc6f2002fa68711e779aa18c8585 upstream.

The deprecated UNIVERSAL_DEV_PM_OPS() macro uses the provided callbacks
for both runtime PM and system sleep. This causes the DSI clocks to be
disabled twice: once during runtime suspend and again during system
suspend, resulting in a WARN message from the clock framework when
attempting to disable already-disabled clocks.

[   84.384540] clk:231:5 already disabled
[   84.388314] WARNING: CPU: 2 PID: 531 at /drivers/clk/clk.c:1181 clk_core_disable+0xa4/0xac
...
[   84.579183] Call trace:
[   84.581624]  clk_core_disable+0xa4/0xac
[   84.585457]  clk_disable+0x30/0x4c
[   84.588857]  cdns_dsi_suspend+0x20/0x58 [cdns_dsi]
[   84.593651]  pm_generic_suspend+0x2c/0x44
[   84.597661]  ti_sci_pd_suspend+0xbc/0x15c
[   84.601670]  dpm_run_callback+0x8c/0x14c
[   84.605588]  __device_suspend+0x1a0/0x56c
[   84.609594]  dpm_suspend+0x17c/0x21c
[   84.613165]  dpm_suspend_start+0xa0/0xa8
[   84.617083]  suspend_devices_and_enter+0x12c/0x634
[   84.621872]  pm_suspend+0x1fc/0x368

To address this issue, replace UNIVERSAL_DEV_PM_OPS() with
RUNTIME_PM_OPS(). Bridge and panel drivers should only deal with runtime
PM, as the DRM framework manages system-wide power transitions through
the bridge enable() and disable() hooks.

Link: https://lore.kernel.org/all/fbde0659-78f3-46e4-98cf-d832f765a18b@ideasonboard.com/
Cc: stable@vger.kernel.org # 6.1.x
Fixes: e19233955d9e ("drm/bridge: Add Cadence DSI driver")
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260505134705.188661-2-ivitro@gmail.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
@@ -1230,7 +1230,7 @@ static const struct mipi_dsi_host_ops cd
 	.transfer = cdns_dsi_transfer,
 };
 
-static int __maybe_unused cdns_dsi_resume(struct device *dev)
+static int cdns_dsi_resume(struct device *dev)
 {
 	struct cdns_dsi *dsi = dev_get_drvdata(dev);
 
@@ -1241,7 +1241,7 @@ static int __maybe_unused cdns_dsi_resum
 	return 0;
 }
 
-static int __maybe_unused cdns_dsi_suspend(struct device *dev)
+static int cdns_dsi_suspend(struct device *dev)
 {
 	struct cdns_dsi *dsi = dev_get_drvdata(dev);
 
@@ -1251,8 +1251,9 @@ static int __maybe_unused cdns_dsi_suspe
 	return 0;
 }
 
-static UNIVERSAL_DEV_PM_OPS(cdns_dsi_pm_ops, cdns_dsi_suspend, cdns_dsi_resume,
-			    NULL);
+static const struct dev_pm_ops cdns_dsi_pm_ops = {
+	RUNTIME_PM_OPS(cdns_dsi_suspend, cdns_dsi_resume, NULL)
+};
 
 static int cdns_dsi_drm_probe(struct platform_device *pdev)
 {
@@ -1399,7 +1400,7 @@ static struct platform_driver cdns_dsi_p
 	.driver = {
 		.name   = "cdns-dsi",
 		.of_match_table = cdns_dsi_of_match,
-		.pm = &cdns_dsi_pm_ops,
+		.pm = pm_ptr(&cdns_dsi_pm_ops),
 	},
 };
 module_platform_driver(cdns_dsi_platform_driver);


