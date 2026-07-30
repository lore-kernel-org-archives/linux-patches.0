Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D0D372691;
	Thu, 30 Jul 2026 15:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425967; cv=none; b=eDukeFLpZ7PyBhoNlYZD7TACetefVs7TRg2o8TGt8nbIeJSePTWlxuaigoea9rGrezTSYwUWiC7M8WaiejXO/kSrfvjG6Gvn2/0fE6jT9LZSRGVqxUHIU4ODvChV0Y2+i5DBsqvIKycSvIFBYFFWQ5cgZlfEM0/9ttxAwGldKQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425967; c=relaxed/simple;
	bh=hBrpsZJiIm+MANonQnK5nllTl/6RkQpxTQhlZt+Dpd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h60+zO7FzkW2HR5BA9DUDqCayhJ564Iba/w6RvW/zCX4AZiZ9M/GxHm7o6n3G9CfmQty9diW6p4oWA9S2MN2/R//OETnjfQuiFISaFefkrqpm/tONeULiwFqx5yHaVhSc7eI8ZvIZqHc7o6bwiNXZiDq/jXSrvNVANTEWHUbuhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zrz+FGUH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zrz+FGUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A0B1F000E9;
	Thu, 30 Jul 2026 15:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425966;
	bh=ulg1nbbh8kdsZ8GW/LNcAz6ZjGdYKbMJBfW7JIzdQ4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zrz+FGUHzdigjT3iEPeMU0APH0Slqo5kqvtyp6TAW+KJyL+Ko3ui+MixsXPunO5Wc
	 gdcp5vV1g6FgFbw1yXWT0z7lNIpNzYgpzn6XSj9kGh/VgEl4a7478TOYw9oFNvhu6s
	 BHBlJROvDBYmCMUOcskQf15bp5Uy6D6SS2n4oVQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Vitor Soares <vitor.soares@toradex.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.12 254/602] drm/bridge: cdns-dsi: Replace deprecated UNIVERSAL_DEV_PM_OPS()
Date: Thu, 30 Jul 2026 16:10:46 +0200
Message-ID: <20260730141441.307351261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -1157,7 +1157,7 @@ static const struct mipi_dsi_host_ops cd
 	.transfer = cdns_dsi_transfer,
 };
 
-static int __maybe_unused cdns_dsi_resume(struct device *dev)
+static int cdns_dsi_resume(struct device *dev)
 {
 	struct cdns_dsi *dsi = dev_get_drvdata(dev);
 
@@ -1168,7 +1168,7 @@ static int __maybe_unused cdns_dsi_resum
 	return 0;
 }
 
-static int __maybe_unused cdns_dsi_suspend(struct device *dev)
+static int cdns_dsi_suspend(struct device *dev)
 {
 	struct cdns_dsi *dsi = dev_get_drvdata(dev);
 
@@ -1178,8 +1178,9 @@ static int __maybe_unused cdns_dsi_suspe
 	return 0;
 }
 
-static UNIVERSAL_DEV_PM_OPS(cdns_dsi_pm_ops, cdns_dsi_suspend, cdns_dsi_resume,
-			    NULL);
+static const struct dev_pm_ops cdns_dsi_pm_ops = {
+	RUNTIME_PM_OPS(cdns_dsi_suspend, cdns_dsi_resume, NULL)
+};
 
 static int cdns_dsi_drm_probe(struct platform_device *pdev)
 {
@@ -1326,7 +1327,7 @@ static struct platform_driver cdns_dsi_p
 	.driver = {
 		.name   = "cdns-dsi",
 		.of_match_table = cdns_dsi_of_match,
-		.pm = &cdns_dsi_pm_ops,
+		.pm = pm_ptr(&cdns_dsi_pm_ops),
 	},
 };
 module_platform_driver(cdns_dsi_platform_driver);


