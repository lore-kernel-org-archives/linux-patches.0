Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9135651FCC8;
	Wed, 30 Sep 2026 17:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790085; cv=none; b=JPwz+TctLTY5lFXeGY/LElER/GfWWFuWII/61wEuJbrdSiR5AnUpbm1uQLeOw/kf6UJIMH7v1Ht/eUZ3TmOf6+tOzdxDCbMlMisHaAd6e/MAPWsqjbX8Ld1hgD8ieYbbwiUonfFgHNVaESt9sEiK4c4ynvBKOBPDMyvl7Y9OlEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790085; c=relaxed/simple;
	bh=/zXSGysrjLofVtW3rwNw4Cfh0Qr/E/9J8cnkO20QJgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYUkLBwF9WDXxhXFY74RK9hTbJDRg+XWbp6cje0labpE2n6BDmC+60t6ISU0XPmhhzhGwVvC7Me0HGeyES4QYqGqxw3L33wM09YJ8uCXQlhsKjKNCOFAlg3GqrxtVsBO11FWyodVMgmH5ls7WvUiJplp9dubNsaFe5uXWtFGCDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cm8v2Jth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cm8v2Jth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD201F000FF;
	Wed, 30 Sep 2026 17:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790084;
	bh=sqmfoDtfHuUguYlphJ7TiJlJMymXBAHINN+io6g0dIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cm8v2JthU86VqTEE5bkyo/tqMZhNpUrESfGUoHKjMyexvluofzqgw1ZP1WJ9YOjuC
	 P/kfeSb3k7GUt8Pyyj2QdiKARWHI+A9xI1yDquHKhSozmL8rupFBxhc8NKCeLB7w5k
	 DK+4k2kBIIgQKV+gNkbxYXeHnIyTVhAlgU/K4d+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 705/877] firmware: sysfb: Move bpp-depth calculation into screen_info helper
Date: Wed, 30 Sep 2026 17:26:56 +0200
Message-ID: <20260930152429.897406202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 1ce4c3aeef333be1e6290ec6d1f7891c2bfc7a1f ]

Move the calculation of the bits per pixels for screen_info into a
helper function. This will make it available to other callers besides
the firmware code.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20250401094056.32904-14-tzimmermann@suse.de
Stable-dep-of: 03f1a3545b72 ("drm/sysfb: simpledrm: Improve framebuffer-size validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/sysfb_simplefb.c   |   31 +------------------------------
 drivers/video/screen_info_generic.c |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/screen_info.h         |    2 ++
 3 files changed, 39 insertions(+), 30 deletions(-)

--- a/drivers/firmware/sysfb_simplefb.c
+++ b/drivers/firmware/sysfb_simplefb.c
@@ -35,36 +35,7 @@ __init bool sysfb_parse_mode(const struc
 	if (type != VIDEO_TYPE_VLFB && type != VIDEO_TYPE_EFI)
 		return false;
 
-	/*
-	 * The meaning of depth and bpp for direct-color formats is
-	 * inconsistent:
-	 *
-	 *  - DRM format info specifies depth as the number of color
-	 *    bits; including alpha, but not including filler bits.
-	 *  - Linux' EFI platform code computes lfb_depth from the
-	 *    individual color channels, including the reserved bits.
-	 *  - VBE 1.1 defines lfb_depth for XRGB1555 as 16, but later
-	 *    versions use 15.
-	 *  - On the kernel command line, 'bpp' of 32 is usually
-	 *    XRGB8888 including the filler bits, but 15 is XRGB1555
-	 *    not including the filler bit.
-	 *
-	 * It's not easily possible to fix this in struct screen_info,
-	 * as this could break UAPI. The best solution is to compute
-	 * bits_per_pixel from the color bits, reserved bits and
-	 * reported lfb_depth, whichever is highest.  In the loop below,
-	 * ignore simplefb formats with alpha bits, as EFI and VESA
-	 * don't specify alpha channels.
-	 */
-	if (si->lfb_depth > 8) {
-		bits_per_pixel = max(max3(si->red_size + si->red_pos,
-					  si->green_size + si->green_pos,
-					  si->blue_size + si->blue_pos),
-				     si->rsvd_size + si->rsvd_pos);
-		bits_per_pixel = max_t(u32, bits_per_pixel, si->lfb_depth);
-	} else {
-		bits_per_pixel = si->lfb_depth;
-	}
+	bits_per_pixel = __screen_info_lfb_bits_per_pixel(si);
 
 	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
 		const struct simplefb_format *f = &formats[i];
--- a/drivers/video/screen_info_generic.c
+++ b/drivers/video/screen_info_generic.c
@@ -144,3 +144,39 @@ ssize_t screen_info_resources(const stru
 	return pos - r;
 }
 EXPORT_SYMBOL(screen_info_resources);
+
+/*
+ * The meaning of depth and bpp for direct-color formats is
+ * inconsistent:
+ *
+ *  - DRM format info specifies depth as the number of color
+ *    bits; including alpha, but not including filler bits.
+ *  - Linux' EFI platform code computes lfb_depth from the
+ *    individual color channels, including the reserved bits.
+ *  - VBE 1.1 defines lfb_depth for XRGB1555 as 16, but later
+ *    versions use 15.
+ *  - On the kernel command line, 'bpp' of 32 is usually
+ *    XRGB8888 including the filler bits, but 15 is XRGB1555
+ *    not including the filler bit.
+ *
+ * It is not easily possible to fix this in struct screen_info,
+ * as this could break UAPI. The best solution is to compute
+ * bits_per_pixel from the color bits, reserved bits and
+ * reported lfb_depth, whichever is highest.
+ */
+
+u32 __screen_info_lfb_bits_per_pixel(const struct screen_info *si)
+{
+	u32 bits_per_pixel = si->lfb_depth;
+
+	if (bits_per_pixel > 8) {
+		bits_per_pixel = max(max3(si->red_size + si->red_pos,
+					  si->green_size + si->green_pos,
+					  si->blue_size + si->blue_pos),
+				     si->rsvd_size + si->rsvd_pos);
+		bits_per_pixel = max_t(u32, bits_per_pixel, si->lfb_depth);
+	}
+
+	return bits_per_pixel;
+}
+EXPORT_SYMBOL(__screen_info_lfb_bits_per_pixel);
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -128,6 +128,8 @@ static inline unsigned int screen_info_v
 
 ssize_t screen_info_resources(const struct screen_info *si, struct resource *r, size_t num);
 
+u32 __screen_info_lfb_bits_per_pixel(const struct screen_info *si);
+
 #if defined(CONFIG_PCI)
 void screen_info_apply_fixups(void);
 struct pci_dev *screen_info_pci_dev(const struct screen_info *si);


