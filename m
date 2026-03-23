Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8627D383C7C;
	Mon, 23 Mar 2026 14:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277884; cv=none; b=CDwUPI22nAJhg+ecPTjdSUYPqszEsYJBHqb4p3Okud9dbP894OFcKRLodNu97YljU9lgSWkQtQ51Kt33nZoF8i6JB3FtLswqlFBI7fhHZZcjL01xPeqQj8QOhTCjvOdS86xtAN/WFISXtdWVXFgIWiQNh2mbLRlBah/Bm7qp+VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277884; c=relaxed/simple;
	bh=Eg6Qo57yXPCj1aYPwUuV6G17if18pUbgaxZHVZB90t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohVbtn+hNCv5qgjuD+/0aztX7n19ftlPjX37PUbTgK7futE1ObfC/6+6MTYDaRbYZlzUYBchUQ5PZz37sikPsWTCIzgT2NVRpenO/ozF//MW9svLJm1QoWLVR0gGoRuygKn/aL0fIZ4qPmDwWHaqXKOIOuvW0Fh0zCsez9CxLi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvao9Z5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvao9Z5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A73C4CEF7;
	Mon, 23 Mar 2026 14:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277884;
	bh=Eg6Qo57yXPCj1aYPwUuV6G17if18pUbgaxZHVZB90t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvao9Z5+RzlnKubPTHdlEfvck9mCvVlf3Hihi3j0RPAQUlLyCuZjmYluZms4QtiIH
	 eT2CKkBHoUVla2Qn3rk/wJJAmI6hw7hxe84WH4wcPJ46fPMEhLOJhd1V/Bo7xHvWc6
	 B8nuIeQoHBGq8RXtKcQD327G5uKThF68nQTELhaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/567] drm/ssd130x: Replace .page_height field in device info with a constant
Date: Mon, 23 Mar 2026 14:40:52 +0100
Message-ID: <20260323134537.074174677@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit ec5dceb8180f0cb110dc7029d55d6a83d0583015 ]

This deemed useful to avoid hardcoding a page height and allow to support
other Solomon controller families, but dividing the screen in pages seems
to be something that is specific to the SSD130x chip family.

For example, SSD132x chip family divides the screen in segments (columns)
and common outputs (rows), so the concept of screen pages does not exist
for the SSD132x family.

Let's drop this field from the device info struct and just use a constant
SSD130X_PAGE_HEIGHT macro to define the page height. While being there,
replace hardcoded 8 values in places where it is used as the page height.

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20231014071520.1342189-2-javierm@redhat.com
Stable-dep-of: 36d9579fed6c ("drm/solomon: Fix page start when updating rectangle in page addressing mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 37 +++++++++++++++----------------
 drivers/gpu/drm/solomon/ssd130x.h |  1 -
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index ef3e3832add90..81c85e67fa070 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -42,6 +42,8 @@
 #define DRIVER_MAJOR	1
 #define DRIVER_MINOR	0
 
+#define SSD130X_PAGE_HEIGHT 8
+
 #define SSD130X_PAGE_COL_START_LOW		0x00
 #define SSD130X_PAGE_COL_START_HIGH		0x10
 #define SSD130X_SET_ADDRESS_MODE		0x20
@@ -102,7 +104,6 @@ const struct ssd130x_deviceinfo ssd130x_variants[] = {
 		.default_width = 132,
 		.default_height = 64,
 		.page_mode_only = 1,
-		.page_height = 8,
 	},
 	[SSD1305_ID] = {
 		.default_vcomh = 0x34,
@@ -110,7 +111,6 @@ const struct ssd130x_deviceinfo ssd130x_variants[] = {
 		.default_dclk_frq = 7,
 		.default_width = 132,
 		.default_height = 64,
-		.page_height = 8,
 	},
 	[SSD1306_ID] = {
 		.default_vcomh = 0x20,
@@ -119,7 +119,6 @@ const struct ssd130x_deviceinfo ssd130x_variants[] = {
 		.need_chargepump = 1,
 		.default_width = 128,
 		.default_height = 64,
-		.page_height = 8,
 	},
 	[SSD1307_ID] = {
 		.default_vcomh = 0x20,
@@ -128,7 +127,6 @@ const struct ssd130x_deviceinfo ssd130x_variants[] = {
 		.need_pwm = 1,
 		.default_width = 128,
 		.default_height = 39,
-		.page_height = 8,
 	},
 	[SSD1309_ID] = {
 		.default_vcomh = 0x34,
@@ -136,7 +134,6 @@ const struct ssd130x_deviceinfo ssd130x_variants[] = {
 		.default_dclk_frq = 10,
 		.default_width = 128,
 		.default_height = 64,
-		.page_height = 8,
 	}
 };
 EXPORT_SYMBOL_NS_GPL(ssd130x_variants, DRM_SSD130X);
@@ -465,13 +462,13 @@ static int ssd130x_update_rect(struct ssd130x_device *ssd130x,
 	unsigned int width = drm_rect_width(rect);
 	unsigned int height = drm_rect_height(rect);
 	unsigned int line_length = DIV_ROUND_UP(width, 8);
-	unsigned int page_height = ssd130x->device_info->page_height;
+	unsigned int page_height = SSD130X_PAGE_HEIGHT;
 	unsigned int pages = DIV_ROUND_UP(height, page_height);
 	struct drm_device *drm = &ssd130x->drm;
 	u32 array_idx = 0;
 	int ret, i, j, k;
 
-	drm_WARN_ONCE(drm, y % 8 != 0, "y must be aligned to screen page\n");
+	drm_WARN_ONCE(drm, y % page_height != 0, "y must be aligned to screen page\n");
 
 	/*
 	 * The screen is divided in pages, each having a height of 8
@@ -503,27 +500,32 @@ static int ssd130x_update_rect(struct ssd130x_device *ssd130x,
 	 */
 
 	if (!ssd130x->page_address_mode) {
+		u8 page_start;
+
 		/* Set address range for horizontal addressing mode */
 		ret = ssd130x_set_col_range(ssd130x, ssd130x->col_offset + x, width);
 		if (ret < 0)
 			return ret;
 
-		ret = ssd130x_set_page_range(ssd130x, ssd130x->page_offset + y / 8, pages);
+		page_start = ssd130x->page_offset + y / page_height;
+		ret = ssd130x_set_page_range(ssd130x, page_start, pages);
 		if (ret < 0)
 			return ret;
 	}
 
 	for (i = 0; i < pages; i++) {
-		int m = 8;
+		int m = page_height;
 
 		/* Last page may be partial */
-		if (8 * (y / 8 + i + 1) > ssd130x->height)
-			m = ssd130x->height % 8;
+		if (page_height * (y / page_height + i + 1) > ssd130x->height)
+			m = ssd130x->height % page_height;
+
 		for (j = 0; j < width; j++) {
 			u8 data = 0;
 
 			for (k = 0; k < m; k++) {
-				u8 byte = buf[(8 * i + k) * line_length + j / 8];
+				u32 idx = (page_height * i + k) * line_length + j / 8;
+				u8 byte = buf[idx];
 				u8 bit = (byte >> (j % 8)) & 1;
 
 				data |= bit << k;
@@ -559,8 +561,7 @@ static int ssd130x_update_rect(struct ssd130x_device *ssd130x,
 
 static void ssd130x_clear_screen(struct ssd130x_device *ssd130x, u8 *data_array)
 {
-	unsigned int page_height = ssd130x->device_info->page_height;
-	unsigned int pages = DIV_ROUND_UP(ssd130x->height, page_height);
+	unsigned int pages = DIV_ROUND_UP(ssd130x->height, SSD130X_PAGE_HEIGHT);
 	unsigned int width = ssd130x->width;
 	int ret, i;
 
@@ -605,14 +606,13 @@ static int ssd130x_fb_blit_rect(struct drm_framebuffer *fb,
 				u8 *buf, u8 *data_array)
 {
 	struct ssd130x_device *ssd130x = drm_to_ssd130x(fb->dev);
-	unsigned int page_height = ssd130x->device_info->page_height;
 	struct iosys_map dst;
 	unsigned int dst_pitch;
 	int ret = 0;
 
 	/* Align y to display page boundaries */
-	rect->y1 = round_down(rect->y1, page_height);
-	rect->y2 = min_t(unsigned int, round_up(rect->y2, page_height), ssd130x->height);
+	rect->y1 = round_down(rect->y1, SSD130X_PAGE_HEIGHT);
+	rect->y2 = min_t(unsigned int, round_up(rect->y2, SSD130X_PAGE_HEIGHT), ssd130x->height);
 
 	dst_pitch = DIV_ROUND_UP(drm_rect_width(rect), 8);
 
@@ -814,8 +814,7 @@ static int ssd130x_crtc_helper_atomic_check(struct drm_crtc *crtc,
 	struct ssd130x_device *ssd130x = drm_to_ssd130x(drm);
 	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state, crtc);
 	struct ssd130x_crtc_state *ssd130x_state = to_ssd130x_crtc_state(crtc_state);
-	unsigned int page_height = ssd130x->device_info->page_height;
-	unsigned int pages = DIV_ROUND_UP(ssd130x->height, page_height);
+	unsigned int pages = DIV_ROUND_UP(ssd130x->height, SSD130X_PAGE_HEIGHT);
 	int ret;
 
 	ret = drm_crtc_helper_atomic_check(crtc, state);
diff --git a/drivers/gpu/drm/solomon/ssd130x.h b/drivers/gpu/drm/solomon/ssd130x.h
index aa39b13615ebe..bbe374453605b 100644
--- a/drivers/gpu/drm/solomon/ssd130x.h
+++ b/drivers/gpu/drm/solomon/ssd130x.h
@@ -39,7 +39,6 @@ struct ssd130x_deviceinfo {
 	u32 default_dclk_frq;
 	u32 default_width;
 	u32 default_height;
-	u32 page_height;
 	bool need_pwm;
 	bool need_chargepump;
 	bool page_mode_only;
-- 
2.51.0



