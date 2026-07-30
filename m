Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB6F383983;
	Thu, 30 Jul 2026 16:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428081; cv=none; b=T50VXV37TPYFO8IZYdmgc0Zo0Hz7W+sQh9IA+HYE3UFJwPVSNb6CjhuQolTGDmc8lVaYiz9s44Z3MnSrP72PE6K/hkaYKyi0dzNPlKEPdAw8EEm9+mT52t3K4fktAxqqkeiyV0LRBO4GoUs9VpLLMdI6nU7CqHBpJ72CU27UuAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428081; c=relaxed/simple;
	bh=YHBQr5cMEonYrB8TCMcyufwavu1MgRLH7oYQz3N6REg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+Yg9KiP0M6l8GHP9VQqGe5p217o3mTXYiKq2vYzlhLejZMSl8FWChTccwj3qxrroV/KkPim2B5saJlCc/URyA46GY/wXBveHOdNxHby0AXBBqbuxLW6iKUpzfeuO5Nb3z36p74c6wM/bo15B1vdAeTNRynk9wik4lszdO2HxCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTeXGVlr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTeXGVlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90EF1F00A3A;
	Thu, 30 Jul 2026 16:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428079;
	bh=PYei/msYhIx9BF+gYjL9RRPjgbq0P9+V2iaf6Hj7qG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTeXGVlrNFpdQwS7U+6S1ayyQti8r5ab2Ov0uM2Q0U0NEKLq0SY/iQRVU4moDsgNJ
	 VDh3V8PjxrgnbbZJOA/BjmStA9Y4s60DzEHHNmG8AlXlN3jq4j2ge5jY28S48cPo6c
	 uuYcf31lEDqJ9VcsRjS/DZSkN60E4+tYzq6aCPhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 396/484] fbdev/efifb: Replace references to global screen_info by local pointer
Date: Thu, 30 Jul 2026 16:14:53 +0200
Message-ID: <20260730141432.078576795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 8505e70821ade706f98f7114a2cbcd51326f7b82 ]

Get the global screen_info's address once and access the data via
this pointer. Limits the use of global state.

v3:
	* use const screen_info in several places (Sui)
	* fix build for deferred takeover (kernel test robot)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231206135153.2599-2-tzimmermann@suse.de
Stable-dep-of: 9b6eaf101656 ("fbdev: efifb: fix memory leak in efifb_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/efifb.c |  124 ++++++++++++++++++++++----------------------
 1 file changed, 64 insertions(+), 60 deletions(-)

--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -108,7 +108,7 @@ static int efifb_setcolreg(unsigned regn
  */
 #if defined CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER && \
     defined CONFIG_ACPI_BGRT
-static void efifb_copy_bmp(u8 *src, u32 *dst, int width, struct screen_info *si)
+static void efifb_copy_bmp(u8 *src, u32 *dst, int width, const struct screen_info *si)
 {
 	u8 r, g, b;
 
@@ -130,7 +130,7 @@ static void efifb_copy_bmp(u8 *src, u32
  * resolution still fits, it will be displayed very close to the right edge of
  * the display looking quite bad. This function checks for this.
  */
-static bool efifb_bgrt_sanity_check(struct screen_info *si, u32 bmp_width)
+static bool efifb_bgrt_sanity_check(const struct screen_info *si, u32 bmp_width)
 {
 	/*
 	 * All x86 firmwares horizontally center the image (the yoffset
@@ -141,16 +141,15 @@ static bool efifb_bgrt_sanity_check(stru
 	return bgrt_tab.image_offset_x == expected_xoffset;
 }
 #else
-static bool efifb_bgrt_sanity_check(struct screen_info *si, u32 bmp_width)
+static bool efifb_bgrt_sanity_check(const struct screen_info *si, u32 bmp_width)
 {
 	return true;
 }
 #endif
 
-static void efifb_show_boot_graphics(struct fb_info *info)
+static void efifb_show_boot_graphics(struct fb_info *info, const struct screen_info *si)
 {
 	u32 bmp_width, bmp_height, bmp_pitch, dst_x, y, src_y;
-	struct screen_info *si = &screen_info;
 	struct bmp_file_header *file_header;
 	struct bmp_dib_header *dib_header;
 	void *bgrt_image = NULL;
@@ -247,7 +246,8 @@ error:
 	pr_warn("efifb: Ignoring BGRT: unexpected or invalid BMP data\n");
 }
 #else
-static inline void efifb_show_boot_graphics(struct fb_info *info) {}
+static inline void efifb_show_boot_graphics(struct fb_info *info, const struct screen_info *si)
+{ }
 #endif
 
 /*
@@ -282,7 +282,7 @@ static const struct fb_ops efifb_ops = {
 	.fb_setcolreg	= efifb_setcolreg,
 };
 
-static int efifb_setup(char *options)
+static int efifb_setup(struct screen_info *si, char *options)
 {
 	char *this_opt;
 
@@ -290,16 +290,16 @@ static int efifb_setup(char *options)
 		while ((this_opt = strsep(&options, ",")) != NULL) {
 			if (!*this_opt) continue;
 
-			efifb_setup_from_dmi(&screen_info, this_opt);
+			efifb_setup_from_dmi(si, this_opt);
 
 			if (!strncmp(this_opt, "base:", 5))
-				screen_info.lfb_base = simple_strtoul(this_opt+5, NULL, 0);
+				si->lfb_base = simple_strtoul(this_opt+5, NULL, 0);
 			else if (!strncmp(this_opt, "stride:", 7))
-				screen_info.lfb_linelength = simple_strtoul(this_opt+7, NULL, 0) * 4;
+				si->lfb_linelength = simple_strtoul(this_opt+7, NULL, 0) * 4;
 			else if (!strncmp(this_opt, "height:", 7))
-				screen_info.lfb_height = simple_strtoul(this_opt+7, NULL, 0);
+				si->lfb_height = simple_strtoul(this_opt+7, NULL, 0);
 			else if (!strncmp(this_opt, "width:", 6))
-				screen_info.lfb_width = simple_strtoul(this_opt+6, NULL, 0);
+				si->lfb_width = simple_strtoul(this_opt+6, NULL, 0);
 			else if (!strcmp(this_opt, "nowc"))
 				mem_flags &= ~EFI_MEMORY_WC;
 			else if (!strcmp(this_opt, "nobgrt"))
@@ -310,15 +310,15 @@ static int efifb_setup(char *options)
 	return 0;
 }
 
-static inline bool fb_base_is_valid(void)
+static inline bool fb_base_is_valid(struct screen_info *si)
 {
-	if (screen_info.lfb_base)
+	if (si->lfb_base)
 		return true;
 
-	if (!(screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE))
+	if (!(si->capabilities & VIDEO_CAPABILITY_64BIT_BASE))
 		return false;
 
-	if (screen_info.ext_lfb_base)
+	if (si->ext_lfb_base)
 		return true;
 
 	return false;
@@ -329,7 +329,10 @@ static ssize_t name##_show(struct device
 			   struct device_attribute *attr,		\
 			   char *buf)					\
 {									\
-	return sprintf(buf, fmt "\n", (screen_info.lfb_##name));	\
+	struct screen_info *si = dev_get_platdata(dev);			\
+	if (!si)							\
+		return -ENODEV;						\
+	return sprintf(buf, fmt "\n", (si->lfb_##name));		\
 }									\
 static DEVICE_ATTR_RO(name)
 
@@ -356,6 +359,7 @@ static u64 bar_offset;
 
 static int efifb_probe(struct platform_device *dev)
 {
+	struct screen_info *si = &screen_info;
 	struct fb_info *info;
 	struct efifb_par *par;
 	int err, orientation;
@@ -365,48 +369,48 @@ static int efifb_probe(struct platform_d
 	char *option = NULL;
 	efi_memory_desc_t md;
 
-	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI || pci_dev_disabled)
+	if (si->orig_video_isVGA != VIDEO_TYPE_EFI || pci_dev_disabled)
 		return -ENODEV;
 
 	if (fb_get_options("efifb", &option))
 		return -ENODEV;
-	efifb_setup(option);
+	efifb_setup(si, option);
 
 	/* We don't get linelength from UGA Draw Protocol, only from
 	 * EFI Graphics Protocol.  So if it's not in DMI, and it's not
 	 * passed in from the user, we really can't use the framebuffer.
 	 */
-	if (!screen_info.lfb_linelength)
+	if (!si->lfb_linelength)
 		return -ENODEV;
 
-	if (!screen_info.lfb_depth)
-		screen_info.lfb_depth = 32;
-	if (!screen_info.pages)
-		screen_info.pages = 1;
-	if (!fb_base_is_valid()) {
+	if (!si->lfb_depth)
+		si->lfb_depth = 32;
+	if (!si->pages)
+		si->pages = 1;
+	if (!fb_base_is_valid(si)) {
 		printk(KERN_DEBUG "efifb: invalid framebuffer address\n");
 		return -ENODEV;
 	}
 	printk(KERN_INFO "efifb: probing for efifb\n");
 
 	/* just assume they're all unset if any are */
-	if (!screen_info.blue_size) {
-		screen_info.blue_size = 8;
-		screen_info.blue_pos = 0;
-		screen_info.green_size = 8;
-		screen_info.green_pos = 8;
-		screen_info.red_size = 8;
-		screen_info.red_pos = 16;
-		screen_info.rsvd_size = 8;
-		screen_info.rsvd_pos = 24;
+	if (!si->blue_size) {
+		si->blue_size = 8;
+		si->blue_pos = 0;
+		si->green_size = 8;
+		si->green_pos = 8;
+		si->red_size = 8;
+		si->red_pos = 16;
+		si->rsvd_size = 8;
+		si->rsvd_pos = 24;
 	}
 
-	efifb_fix.smem_start = screen_info.lfb_base;
+	efifb_fix.smem_start = si->lfb_base;
 
-	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE) {
+	if (si->capabilities & VIDEO_CAPABILITY_64BIT_BASE) {
 		u64 ext_lfb_base;
 
-		ext_lfb_base = (u64)(unsigned long)screen_info.ext_lfb_base << 32;
+		ext_lfb_base = (u64)(unsigned long)si->ext_lfb_base << 32;
 		efifb_fix.smem_start |= ext_lfb_base;
 	}
 
@@ -417,10 +421,10 @@ static int efifb_probe(struct platform_d
 		efifb_fix.smem_start = bar_resource->start + bar_offset;
 	}
 
-	efifb_defined.bits_per_pixel = screen_info.lfb_depth;
-	efifb_defined.xres = screen_info.lfb_width;
-	efifb_defined.yres = screen_info.lfb_height;
-	efifb_fix.line_length = screen_info.lfb_linelength;
+	efifb_defined.bits_per_pixel = si->lfb_depth;
+	efifb_defined.xres = si->lfb_width;
+	efifb_defined.yres = si->lfb_height;
+	efifb_fix.line_length = si->lfb_linelength;
 
 	/*   size_vmode -- that is the amount of memory needed for the
 	 *                 used video mode, i.e. the minimum amount of
@@ -430,7 +434,7 @@ static int efifb_probe(struct platform_d
 	/*   size_total -- all video memory we have. Used for
 	 *                 entries, ressource allocation and bounds
 	 *                 checking. */
-	size_total = screen_info.lfb_size;
+	size_total = si->lfb_size;
 	if (size_total < size_vmode)
 		size_total = size_vmode;
 
@@ -505,14 +509,14 @@ static int efifb_probe(struct platform_d
 		goto err_release_fb;
 	}
 
-	efifb_show_boot_graphics(info);
+	efifb_show_boot_graphics(info, si);
 
 	pr_info("efifb: framebuffer at 0x%lx, using %dk, total %dk\n",
 	       efifb_fix.smem_start, size_remap/1024, size_total/1024);
 	pr_info("efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
 	       efifb_defined.xres, efifb_defined.yres,
 	       efifb_defined.bits_per_pixel, efifb_fix.line_length,
-	       screen_info.pages);
+	       si->pages);
 
 	efifb_defined.xres_virtual = efifb_defined.xres;
 	efifb_defined.yres_virtual = efifb_fix.smem_len /
@@ -526,26 +530,26 @@ static int efifb_probe(struct platform_d
 	efifb_defined.left_margin  = (efifb_defined.xres / 8) & 0xf8;
 	efifb_defined.hsync_len    = (efifb_defined.xres / 8) & 0xf8;
 
-	efifb_defined.red.offset    = screen_info.red_pos;
-	efifb_defined.red.length    = screen_info.red_size;
-	efifb_defined.green.offset  = screen_info.green_pos;
-	efifb_defined.green.length  = screen_info.green_size;
-	efifb_defined.blue.offset   = screen_info.blue_pos;
-	efifb_defined.blue.length   = screen_info.blue_size;
-	efifb_defined.transp.offset = screen_info.rsvd_pos;
-	efifb_defined.transp.length = screen_info.rsvd_size;
+	efifb_defined.red.offset    = si->red_pos;
+	efifb_defined.red.length    = si->red_size;
+	efifb_defined.green.offset  = si->green_pos;
+	efifb_defined.green.length  = si->green_size;
+	efifb_defined.blue.offset   = si->blue_pos;
+	efifb_defined.blue.length   = si->blue_size;
+	efifb_defined.transp.offset = si->rsvd_pos;
+	efifb_defined.transp.length = si->rsvd_size;
 
 	pr_info("efifb: %s: "
 	       "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
 	       "Truecolor",
-	       screen_info.rsvd_size,
-	       screen_info.red_size,
-	       screen_info.green_size,
-	       screen_info.blue_size,
-	       screen_info.rsvd_pos,
-	       screen_info.red_pos,
-	       screen_info.green_pos,
-	       screen_info.blue_pos);
+	       si->rsvd_size,
+	       si->red_size,
+	       si->green_size,
+	       si->blue_size,
+	       si->rsvd_pos,
+	       si->red_pos,
+	       si->green_pos,
+	       si->blue_pos);
 
 	efifb_fix.ypanstep  = 0;
 	efifb_fix.ywrapstep = 0;


