Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7591C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 14:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA7CC433D2;
	Mon, 20 Mar 2023 14:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324364;
	bh=ATEnrQL5w3FWRq9chTFV0ZbIetkRdvanc1fVU8ygjNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G70AGPVzENljkskAw1LiQ+V315NIZLgtZ0VhXy2COK1jjHIhCgO9e0pKoDfvIG7ob
	 3CjEhBVxdsaltn1Zw1DODtenXAFo12mHVC23peG/3TXGHJCOxytgpbxpGHcSguIx9w
	 cDRMF4IbannCAGIZmqcmr+NJGLIuM22+nAYuHszQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 31/36] fbdev: stifb: Provide valid pixelclock and add fb_check_var() checks
Date: Mon, 20 Mar 2023 15:54:57 +0100
Message-Id: <20230320145425.395937538@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 203873a535d627c668f293be0cb73e26c30f9cc7 upstream.

Find a valid modeline depending on the machine graphic card
configuration and add the fb_check_var() function to validate
Xorg provided graphics settings.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/stifb.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -922,6 +922,28 @@ SETUP_HCRX(struct stifb_info *fb)
 /* ------------------- driver specific functions --------------------------- */
 
 static int
+stifb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	struct stifb_info *fb = container_of(info, struct stifb_info, info);
+
+	if (var->xres != fb->info.var.xres ||
+	    var->yres != fb->info.var.yres ||
+	    var->bits_per_pixel != fb->info.var.bits_per_pixel)
+		return -EINVAL;
+
+	var->xres_virtual = var->xres;
+	var->yres_virtual = var->yres;
+	var->xoffset = 0;
+	var->yoffset = 0;
+	var->grayscale = fb->info.var.grayscale;
+	var->red.length = fb->info.var.red.length;
+	var->green.length = fb->info.var.green.length;
+	var->blue.length = fb->info.var.blue.length;
+
+	return 0;
+}
+
+static int
 stifb_setcolreg(u_int regno, u_int red, u_int green,
 	      u_int blue, u_int transp, struct fb_info *info)
 {
@@ -1103,6 +1125,7 @@ stifb_init_display(struct stifb_info *fb
 
 static struct fb_ops stifb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_check_var	= stifb_check_var,
 	.fb_setcolreg	= stifb_setcolreg,
 	.fb_blank	= stifb_blank,
 	.fb_fillrect	= cfb_fillrect,
@@ -1122,6 +1145,7 @@ static int __init stifb_init_fb(struct s
 	struct stifb_info *fb;
 	struct fb_info *info;
 	unsigned long sti_rom_address;
+	char modestr[32];
 	char *dev_name;
 	int bpp, xres, yres;
 
@@ -1300,6 +1324,9 @@ static int __init stifb_init_fb(struct s
 	info->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_COPYAREA;
 	info->pseudo_palette = &fb->pseudo_palette;
 
+	scnprintf(modestr, sizeof(modestr), "%dx%d-%d", xres, yres, bpp);
+	fb_find_mode(&info->var, info, modestr, NULL, 0, NULL, bpp);
+
 	/* This has to be done !!! */
 	if (fb_alloc_cmap(&info->cmap, NR_PALETTE, 0))
 		goto out_err1;


