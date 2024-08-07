Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A663A78B4C;
	Wed,  7 Aug 2024 15:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043276; cv=none; b=lOVZCJZf/iKdH02xnawNZL5FsYe/1dS/Fykh7dWb/ZabjhIBdEX1Wwgl20UlBPDJV4Ct5GayH15yARp4PRO8SpEbEOXWGsiP1urqcHLSCWnr3gRrY9sbE5DiRkWV+PywbAur6YDNOnVQ13gJB85/OnjhlRI/sQUeuSWrOiXh5nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043276; c=relaxed/simple;
	bh=qvgl8DemB3guj68mp+LYnesDgD2rHEoY4wtW2YmoAcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyczYZaz5tHoGH+bjX+TXqNma9J0FAGDqIb2DVuViaMXuJB969oZHs3wjVmkw0zNpHQur/LstXWrbWsUMvEJT2ueaZwnWY4miV2O6hT6mbmfxLtlTh1MPZmBFrfx5mhX59+yANxFjgRSa+OHMWiJ4WgiT/IXItYPmHlnz1SS5YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDkqWeEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDkqWeEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39947C32781;
	Wed,  7 Aug 2024 15:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043276;
	bh=qvgl8DemB3guj68mp+LYnesDgD2rHEoY4wtW2YmoAcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDkqWeEEBIDy9kZlfxIj0TtNO8M/NmMJvnGOwQeOqhw7tJ02cqFLloyclYbHornJZ
	 Qa2zXYq8WW7fH6emSpGPl+gtY4E8JjqoNCOaSoXiILbSXBDH4q/VCowXIuDbZeegIU
	 +grDy95il83wvWDa7DYWQYcOxqC8gwdGSS+B3XAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/121] fbdev/vesafb: Replace references to global screen_info by local pointer
Date: Wed,  7 Aug 2024 16:59:24 +0200
Message-ID: <20240807150020.383471633@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 3218286bbb78cac3dde713514529e0480d678173 ]

Get the global screen_info's address once and access the data via
this pointer. Limits the use of global state.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231206135153.2599-4-tzimmermann@suse.de
Stable-dep-of: c2bc958b2b03 ("fbdev: vesafb: Detect VGA compatibility from screen info's VESA attributes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/vesafb.c | 66 +++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/video/fbdev/vesafb.c b/drivers/video/fbdev/vesafb.c
index c0edceea0a793..ea89accbec385 100644
--- a/drivers/video/fbdev/vesafb.c
+++ b/drivers/video/fbdev/vesafb.c
@@ -243,6 +243,7 @@ static int vesafb_setup(char *options)
 
 static int vesafb_probe(struct platform_device *dev)
 {
+	struct screen_info *si = &screen_info;
 	struct fb_info *info;
 	struct vesafb_par *par;
 	int i, err;
@@ -255,17 +256,17 @@ static int vesafb_probe(struct platform_device *dev)
 	fb_get_options("vesafb", &option);
 	vesafb_setup(option);
 
-	if (screen_info.orig_video_isVGA != VIDEO_TYPE_VLFB)
+	if (si->orig_video_isVGA != VIDEO_TYPE_VLFB)
 		return -ENODEV;
 
-	vga_compat = (screen_info.capabilities & 2) ? 0 : 1;
-	vesafb_fix.smem_start = screen_info.lfb_base;
-	vesafb_defined.bits_per_pixel = screen_info.lfb_depth;
+	vga_compat = (si->capabilities & 2) ? 0 : 1;
+	vesafb_fix.smem_start = si->lfb_base;
+	vesafb_defined.bits_per_pixel = si->lfb_depth;
 	if (15 == vesafb_defined.bits_per_pixel)
 		vesafb_defined.bits_per_pixel = 16;
-	vesafb_defined.xres = screen_info.lfb_width;
-	vesafb_defined.yres = screen_info.lfb_height;
-	vesafb_fix.line_length = screen_info.lfb_linelength;
+	vesafb_defined.xres = si->lfb_width;
+	vesafb_defined.yres = si->lfb_height;
+	vesafb_fix.line_length = si->lfb_linelength;
 	vesafb_fix.visual   = (vesafb_defined.bits_per_pixel == 8) ?
 		FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
 
@@ -277,7 +278,7 @@ static int vesafb_probe(struct platform_device *dev)
 	/*   size_total -- all video memory we have. Used for mtrr
 	 *                 entries, resource allocation and bounds
 	 *                 checking. */
-	size_total = screen_info.lfb_size * 65536;
+	size_total = si->lfb_size * 65536;
 	if (vram_total)
 		size_total = vram_total * 1024 * 1024;
 	if (size_total < size_vmode)
@@ -297,7 +298,7 @@ static int vesafb_probe(struct platform_device *dev)
 	vesafb_fix.smem_len = size_remap;
 
 #ifndef __i386__
-	screen_info.vesapm_seg = 0;
+	si->vesapm_seg = 0;
 #endif
 
 	if (!request_mem_region(vesafb_fix.smem_start, size_total, "vesafb")) {
@@ -317,23 +318,26 @@ static int vesafb_probe(struct platform_device *dev)
 	par = info->par;
 	info->pseudo_palette = par->pseudo_palette;
 
-	par->base = screen_info.lfb_base;
+	par->base = si->lfb_base;
 	par->size = size_total;
 
 	printk(KERN_INFO "vesafb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
-	       vesafb_defined.xres, vesafb_defined.yres, vesafb_defined.bits_per_pixel, vesafb_fix.line_length, screen_info.pages);
+	       vesafb_defined.xres, vesafb_defined.yres, vesafb_defined.bits_per_pixel,
+	       vesafb_fix.line_length, si->pages);
 
-	if (screen_info.vesapm_seg) {
+	if (si->vesapm_seg) {
 		printk(KERN_INFO "vesafb: protected mode interface info at %04x:%04x\n",
-		       screen_info.vesapm_seg,screen_info.vesapm_off);
+		       si->vesapm_seg, si->vesapm_off);
 	}
 
-	if (screen_info.vesapm_seg < 0xc000)
+	if (si->vesapm_seg < 0xc000)
 		ypan = pmi_setpal = 0; /* not available or some DOS TSR ... */
 
 	if (ypan || pmi_setpal) {
+		unsigned long pmi_phys;
 		unsigned short *pmi_base;
-		pmi_base  = (unsigned short*)phys_to_virt(((unsigned long)screen_info.vesapm_seg << 4) + screen_info.vesapm_off);
+		pmi_phys  = ((unsigned long)si->vesapm_seg << 4) + si->vesapm_off;
+		pmi_base  = (unsigned short *)phys_to_virt(pmi_phys);
 		pmi_start = (void*)((char*)pmi_base + pmi_base[1]);
 		pmi_pal   = (void*)((char*)pmi_base + pmi_base[2]);
 		printk(KERN_INFO "vesafb: pmi: set display start = %p, set palette = %p\n",pmi_start,pmi_pal);
@@ -377,14 +381,14 @@ static int vesafb_probe(struct platform_device *dev)
 	vesafb_defined.left_margin  = (vesafb_defined.xres / 8) & 0xf8;
 	vesafb_defined.hsync_len    = (vesafb_defined.xres / 8) & 0xf8;
 
-	vesafb_defined.red.offset    = screen_info.red_pos;
-	vesafb_defined.red.length    = screen_info.red_size;
-	vesafb_defined.green.offset  = screen_info.green_pos;
-	vesafb_defined.green.length  = screen_info.green_size;
-	vesafb_defined.blue.offset   = screen_info.blue_pos;
-	vesafb_defined.blue.length   = screen_info.blue_size;
-	vesafb_defined.transp.offset = screen_info.rsvd_pos;
-	vesafb_defined.transp.length = screen_info.rsvd_size;
+	vesafb_defined.red.offset    = si->red_pos;
+	vesafb_defined.red.length    = si->red_size;
+	vesafb_defined.green.offset  = si->green_pos;
+	vesafb_defined.green.length  = si->green_size;
+	vesafb_defined.blue.offset   = si->blue_pos;
+	vesafb_defined.blue.length   = si->blue_size;
+	vesafb_defined.transp.offset = si->rsvd_pos;
+	vesafb_defined.transp.length = si->rsvd_size;
 
 	if (vesafb_defined.bits_per_pixel <= 8) {
 		depth = vesafb_defined.green.length;
@@ -399,14 +403,14 @@ static int vesafb_probe(struct platform_device *dev)
 	       (vesafb_defined.bits_per_pixel > 8) ?
 	       "Truecolor" : (vga_compat || pmi_setpal) ?
 	       "Pseudocolor" : "Static Pseudocolor",
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
 
 	vesafb_fix.ypanstep  = ypan     ? 1 : 0;
 	vesafb_fix.ywrapstep = (ypan>1) ? 1 : 0;
-- 
2.43.0



