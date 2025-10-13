Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E595D30ACFF;
	Mon, 13 Oct 2025 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368681; cv=none; b=HElH+8K1BMonJGZ5w9TFrAPkDq11maXQ5sZykeJIDi2BKQ5C+hp//blbt+gMkugYtm4+gQRIbo1oHTE1UEuKZMKnn4dOtrUf2p0nNaQIyESaVXt9jOOQcjTVSymUopLKY8bqsnCqw69HvxRrdr7RD1KV0kGNsbhZyhuRYOQpHVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368681; c=relaxed/simple;
	bh=Uwt1n9daUZkQWYdvzqd+g7xEcUqnvutGycEsCAtT+gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoURfU6eehadTTsiDyA3V7fTvYX5Jon54y1IAAjX2IwifvREg++BgVCNlsgQcs2hOkNhd4YT4/4eOENE1nN+wOOD84kwgYS91/sSRhn/B9Xlmauba4NJAOdIPti2MieN6rQQkEm1Puinx9itwjDBgT3GH3QIJX5RIVIQk8fRXvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAC97F6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAC97F6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF05C16AAE;
	Mon, 13 Oct 2025 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368680;
	bh=Uwt1n9daUZkQWYdvzqd+g7xEcUqnvutGycEsCAtT+gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAC97F6LLT8T0pctE+wrWjwA815+rm4Mj5sqCnr96MdmkT1Eccqtc5BRgBwi+5p8/
	 2dJVPCVQoC3IUjrcwDWD/YqIRIFPjY+jYXmVPWVE2yDcVtMcc1v1TK/GpRyZm2PCj0
	 M/4nesGL7SMc2PcmcQCPDIUIOzYfpklXDDqJW+kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Huhardeaux <tech@tootai.net>,
	Janne Grunau <j@jannau.net>,
	Hans de Goede <hansg@kernel.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 244/262] fbdev: simplefb: Fix use after free in simplefb_detach_genpds()
Date: Mon, 13 Oct 2025 16:46:26 +0200
Message-ID: <20251013144335.024290927@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Janne Grunau <j@jannau.net>

commit da1bb9135213744e7ec398826c8f2e843de4fb94 upstream.

The pm_domain cleanup can not be devres managed as it uses struct
simplefb_par which is allocated within struct fb_info by
framebuffer_alloc(). This allocation is explicitly freed by
unregister_framebuffer() in simplefb_remove().
Devres managed cleanup runs after the device remove call and thus can no
longer access struct simplefb_par.
Call simplefb_detach_genpds() explicitly from simplefb_destroy() like
the cleanup functions for clocks and regulators.

Fixes an use after free on M2 Mac mini during
aperture_remove_conflicting_devices() using the downstream asahi kernel
with Debian's kernel config. For unknown reasons this started to
consistently dereference an invalid pointer in v6.16.3 based kernels.

[    6.736134] BUG: KASAN: slab-use-after-free in simplefb_detach_genpds+0x58/0x220
[    6.743545] Read of size 4 at addr ffff8000304743f0 by task (udev-worker)/227
[    6.750697]
[    6.752182] CPU: 6 UID: 0 PID: 227 Comm: (udev-worker) Tainted: G S                  6.16.3-asahi+ #16 PREEMPTLAZY
[    6.752186] Tainted: [S]=CPU_OUT_OF_SPEC
[    6.752187] Hardware name: Apple Mac mini (M2, 2023) (DT)
[    6.752189] Call trace:
[    6.752190]  show_stack+0x34/0x98 (C)
[    6.752194]  dump_stack_lvl+0x60/0x80
[    6.752197]  print_report+0x17c/0x4d8
[    6.752201]  kasan_report+0xb4/0x100
[    6.752206]  __asan_report_load4_noabort+0x20/0x30
[    6.752209]  simplefb_detach_genpds+0x58/0x220
[    6.752213]  devm_action_release+0x50/0x98
[    6.752216]  release_nodes+0xd0/0x2c8
[    6.752219]  devres_release_all+0xfc/0x178
[    6.752221]  device_unbind_cleanup+0x28/0x168
[    6.752224]  device_release_driver_internal+0x34c/0x470
[    6.752228]  device_release_driver+0x20/0x38
[    6.752231]  bus_remove_device+0x1b0/0x380
[    6.752234]  device_del+0x314/0x820
[    6.752238]  platform_device_del+0x3c/0x1e8
[    6.752242]  platform_device_unregister+0x20/0x50
[    6.752246]  aperture_detach_platform_device+0x1c/0x30
[    6.752250]  aperture_detach_devices+0x16c/0x290
[    6.752253]  aperture_remove_conflicting_devices+0x34/0x50
...
[    6.752343]
[    6.967409] Allocated by task 62:
[    6.970724]  kasan_save_stack+0x3c/0x70
[    6.974560]  kasan_save_track+0x20/0x40
[    6.978397]  kasan_save_alloc_info+0x40/0x58
[    6.982670]  __kasan_kmalloc+0xd4/0xd8
[    6.986420]  __kmalloc_noprof+0x194/0x540
[    6.990432]  framebuffer_alloc+0xc8/0x130
[    6.994444]  simplefb_probe+0x258/0x2378
...
[    7.054356]
[    7.055838] Freed by task 227:
[    7.058891]  kasan_save_stack+0x3c/0x70
[    7.062727]  kasan_save_track+0x20/0x40
[    7.066565]  kasan_save_free_info+0x4c/0x80
[    7.070751]  __kasan_slab_free+0x6c/0xa0
[    7.074675]  kfree+0x10c/0x380
[    7.077727]  framebuffer_release+0x5c/0x90
[    7.081826]  simplefb_destroy+0x1b4/0x2c0
[    7.085837]  put_fb_info+0x98/0x100
[    7.089326]  unregister_framebuffer+0x178/0x320
[    7.093861]  simplefb_remove+0x3c/0x60
[    7.097611]  platform_remove+0x60/0x98
[    7.101361]  device_remove+0xb8/0x160
[    7.105024]  device_release_driver_internal+0x2fc/0x470
[    7.110256]  device_release_driver+0x20/0x38
[    7.114529]  bus_remove_device+0x1b0/0x380
[    7.118628]  device_del+0x314/0x820
[    7.122116]  platform_device_del+0x3c/0x1e8
[    7.126302]  platform_device_unregister+0x20/0x50
[    7.131012]  aperture_detach_platform_device+0x1c/0x30
[    7.136157]  aperture_detach_devices+0x16c/0x290
[    7.140779]  aperture_remove_conflicting_devices+0x34/0x50
...

Reported-by: Daniel Huhardeaux <tech@tootai.net>
Cc: stable@vger.kernel.org
Fixes: 92a511a568e44 ("fbdev/simplefb: Add support for generic power-domains")
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/simplefb.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/video/fbdev/simplefb.c
+++ b/drivers/video/fbdev/simplefb.c
@@ -93,6 +93,7 @@ struct simplefb_par {
 
 static void simplefb_clocks_destroy(struct simplefb_par *par);
 static void simplefb_regulators_destroy(struct simplefb_par *par);
+static void simplefb_detach_genpds(void *res);
 
 /*
  * fb_ops.fb_destroy is called by the last put_fb_info() call at the end
@@ -105,6 +106,7 @@ static void simplefb_destroy(struct fb_i
 
 	simplefb_regulators_destroy(info->par);
 	simplefb_clocks_destroy(info->par);
+	simplefb_detach_genpds(info->par);
 	if (info->screen_base)
 		iounmap(info->screen_base);
 
@@ -454,13 +456,14 @@ static void simplefb_detach_genpds(void
 		if (!IS_ERR_OR_NULL(par->genpds[i]))
 			dev_pm_domain_detach(par->genpds[i], true);
 	}
+	par->num_genpds = 0;
 }
 
 static int simplefb_attach_genpds(struct simplefb_par *par,
 				  struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	unsigned int i;
+	unsigned int i, num_genpds;
 	int err;
 
 	err = of_count_phandle_with_args(dev->of_node, "power-domains",
@@ -474,26 +477,35 @@ static int simplefb_attach_genpds(struct
 		return err;
 	}
 
-	par->num_genpds = err;
+	num_genpds = err;
 
 	/*
 	 * Single power-domain devices are handled by the driver core, so
 	 * nothing to do here.
 	 */
-	if (par->num_genpds <= 1)
+	if (num_genpds <= 1) {
+		par->num_genpds = num_genpds;
 		return 0;
+	}
 
-	par->genpds = devm_kcalloc(dev, par->num_genpds, sizeof(*par->genpds),
+	par->genpds = devm_kcalloc(dev, num_genpds, sizeof(*par->genpds),
 				   GFP_KERNEL);
 	if (!par->genpds)
 		return -ENOMEM;
 
-	par->genpd_links = devm_kcalloc(dev, par->num_genpds,
+	par->genpd_links = devm_kcalloc(dev, num_genpds,
 					sizeof(*par->genpd_links),
 					GFP_KERNEL);
 	if (!par->genpd_links)
 		return -ENOMEM;
 
+	/*
+	 * Set par->num_genpds only after genpds and genpd_links are allocated
+	 * to exit early from simplefb_detach_genpds() without full
+	 * initialisation.
+	 */
+	par->num_genpds = num_genpds;
+
 	for (i = 0; i < par->num_genpds; i++) {
 		par->genpds[i] = dev_pm_domain_attach_by_id(dev, i);
 		if (IS_ERR(par->genpds[i])) {
@@ -515,9 +527,10 @@ static int simplefb_attach_genpds(struct
 			dev_warn(dev, "failed to link power-domain %u\n", i);
 	}
 
-	return devm_add_action_or_reset(dev, simplefb_detach_genpds, par);
+	return 0;
 }
 #else
+static void simplefb_detach_genpds(void *res) { }
 static int simplefb_attach_genpds(struct simplefb_par *par,
 				  struct platform_device *pdev)
 {
@@ -631,18 +644,20 @@ static int simplefb_probe(struct platfor
 	ret = devm_aperture_acquire_for_platform_device(pdev, par->base, par->size);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to acquire aperture: %d\n", ret);
-		goto error_regulators;
+		goto error_genpds;
 	}
 	ret = register_framebuffer(info);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unable to register simplefb: %d\n", ret);
-		goto error_regulators;
+		goto error_genpds;
 	}
 
 	dev_info(&pdev->dev, "fb%d: simplefb registered!\n", info->node);
 
 	return 0;
 
+error_genpds:
+	simplefb_detach_genpds(par);
 error_regulators:
 	simplefb_regulators_destroy(par);
 error_clocks:


