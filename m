Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F331D271475;
	Tue, 26 Aug 2025 11:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208825; cv=none; b=g1Kd48y7BtvhyBPCoGp3WsrcYGIHR54EdiGv59zvWFZz2lUS5iierzGkLvFRAPDaqgdUJfksu5MAxPKpA1P0tlSBuzdgas5kmZoVK5gzRdNtsaCXd4dmJ3mae+Ko2zF7Vw2cDVL1nXKjEefDn4tayfRxtZomlMDPDgUwomfgnVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208825; c=relaxed/simple;
	bh=gdaRiH7jYy2S2ZfDrglTWkJ7Yotw2MBm9dwj5W9Qi5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2GTyclfEhTosXX1FjkZeWQa99MUVTk1072q9sJPpnt9ceyvQFaYU65Ny4S+Qg5ghRFWDLO5hSAJLKIy2uW19tlLF+13Qv0SJtfJMhpLHp2MYCw3fDt3o3DJchOXhbHoZv+1ez8Pr0eGgvbPBzRCuubXbBEqX3P4qBIgcahP5/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKKUzVTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKKUzVTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D87DC4CEF1;
	Tue, 26 Aug 2025 11:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208824;
	bh=gdaRiH7jYy2S2ZfDrglTWkJ7Yotw2MBm9dwj5W9Qi5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKKUzVTLM+pOjz2ImO8QgeJHV192bBw+si/FdWCUQLPTAwTAWw1mz+FzfxCU3dIcI
	 LWWEeNunPc3+F1Jgge86AfVXJnAaO6NtSIOWmEwMSchIL9zcK5dMVxbvQ7ge4nwDox
	 ee8kq0yw2xn8e0DyW9Aq3gp4FlSaGlQLxRYkFsP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 259/322] drm/format-helper: Move helpers for pixel conversion to header file
Date: Tue, 26 Aug 2025 13:11:14 +0200
Message-ID: <20250826110922.330294999@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit c46d18f98261d99711003517c444417a303c7fae ]

The DRM draw helpers contain format-conversion helpers that operate
on individual pixels. Move them into an internal header file and adopt
them as individual API. Update the draw code accordingly. The pixel
helpers will also be useful for other format conversion helpers.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20250328141709.217283-2-tzimmermann@suse.de
Stable-dep-of: 05663d88fd0b ("drm/tests: Fix drm_test_fb_xrgb8888_to_xrgb2101010() on big-endian")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_draw.c            | 100 +++-------------------
 drivers/gpu/drm/drm_format_internal.h | 119 ++++++++++++++++++++++++++
 2 files changed, 130 insertions(+), 89 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_format_internal.h

diff --git a/drivers/gpu/drm/drm_draw.c b/drivers/gpu/drm/drm_draw.c
index cb2ad12bce57..d41f8ae1c148 100644
--- a/drivers/gpu/drm/drm_draw.c
+++ b/drivers/gpu/drm/drm_draw.c
@@ -11,85 +11,7 @@
 #include <drm/drm_fourcc.h>
 
 #include "drm_draw_internal.h"
-
-/*
- * Conversions from xrgb8888
- */
-
-static u16 convert_xrgb8888_to_rgb565(u32 pix)
-{
-	return ((pix & 0x00F80000) >> 8) |
-	       ((pix & 0x0000FC00) >> 5) |
-	       ((pix & 0x000000F8) >> 3);
-}
-
-static u16 convert_xrgb8888_to_rgba5551(u32 pix)
-{
-	return ((pix & 0x00f80000) >> 8) |
-	       ((pix & 0x0000f800) >> 5) |
-	       ((pix & 0x000000f8) >> 2) |
-	       BIT(0); /* set alpha bit */
-}
-
-static u16 convert_xrgb8888_to_xrgb1555(u32 pix)
-{
-	return ((pix & 0x00f80000) >> 9) |
-	       ((pix & 0x0000f800) >> 6) |
-	       ((pix & 0x000000f8) >> 3);
-}
-
-static u16 convert_xrgb8888_to_argb1555(u32 pix)
-{
-	return BIT(15) | /* set alpha bit */
-	       ((pix & 0x00f80000) >> 9) |
-	       ((pix & 0x0000f800) >> 6) |
-	       ((pix & 0x000000f8) >> 3);
-}
-
-static u32 convert_xrgb8888_to_argb8888(u32 pix)
-{
-	return pix | GENMASK(31, 24); /* fill alpha bits */
-}
-
-static u32 convert_xrgb8888_to_xbgr8888(u32 pix)
-{
-	return ((pix & 0x00ff0000) >> 16) <<  0 |
-	       ((pix & 0x0000ff00) >>  8) <<  8 |
-	       ((pix & 0x000000ff) >>  0) << 16 |
-	       ((pix & 0xff000000) >> 24) << 24;
-}
-
-static u32 convert_xrgb8888_to_abgr8888(u32 pix)
-{
-	return ((pix & 0x00ff0000) >> 16) <<  0 |
-	       ((pix & 0x0000ff00) >>  8) <<  8 |
-	       ((pix & 0x000000ff) >>  0) << 16 |
-	       GENMASK(31, 24); /* fill alpha bits */
-}
-
-static u32 convert_xrgb8888_to_xrgb2101010(u32 pix)
-{
-	pix = ((pix & 0x000000FF) << 2) |
-	      ((pix & 0x0000FF00) << 4) |
-	      ((pix & 0x00FF0000) << 6);
-	return pix | ((pix >> 8) & 0x00300C03);
-}
-
-static u32 convert_xrgb8888_to_argb2101010(u32 pix)
-{
-	pix = ((pix & 0x000000FF) << 2) |
-	      ((pix & 0x0000FF00) << 4) |
-	      ((pix & 0x00FF0000) << 6);
-	return GENMASK(31, 30) /* set alpha bits */ | pix | ((pix >> 8) & 0x00300C03);
-}
-
-static u32 convert_xrgb8888_to_abgr2101010(u32 pix)
-{
-	pix = ((pix & 0x00FF0000) >> 14) |
-	      ((pix & 0x0000FF00) << 4) |
-	      ((pix & 0x000000FF) << 22);
-	return GENMASK(31, 30) /* set alpha bits */ | pix | ((pix >> 8) & 0x00300C03);
-}
+#include "drm_format_internal.h"
 
 /**
  * drm_draw_color_from_xrgb8888 - convert one pixel from xrgb8888 to the desired format
@@ -104,28 +26,28 @@ u32 drm_draw_color_from_xrgb8888(u32 color, u32 format)
 {
 	switch (format) {
 	case DRM_FORMAT_RGB565:
-		return convert_xrgb8888_to_rgb565(color);
+		return drm_pixel_xrgb8888_to_rgb565(color);
 	case DRM_FORMAT_RGBA5551:
-		return convert_xrgb8888_to_rgba5551(color);
+		return drm_pixel_xrgb8888_to_rgba5551(color);
 	case DRM_FORMAT_XRGB1555:
-		return convert_xrgb8888_to_xrgb1555(color);
+		return drm_pixel_xrgb8888_to_xrgb1555(color);
 	case DRM_FORMAT_ARGB1555:
-		return convert_xrgb8888_to_argb1555(color);
+		return drm_pixel_xrgb8888_to_argb1555(color);
 	case DRM_FORMAT_RGB888:
 	case DRM_FORMAT_XRGB8888:
 		return color;
 	case DRM_FORMAT_ARGB8888:
-		return convert_xrgb8888_to_argb8888(color);
+		return drm_pixel_xrgb8888_to_argb8888(color);
 	case DRM_FORMAT_XBGR8888:
-		return convert_xrgb8888_to_xbgr8888(color);
+		return drm_pixel_xrgb8888_to_xbgr8888(color);
 	case DRM_FORMAT_ABGR8888:
-		return convert_xrgb8888_to_abgr8888(color);
+		return drm_pixel_xrgb8888_to_abgr8888(color);
 	case DRM_FORMAT_XRGB2101010:
-		return convert_xrgb8888_to_xrgb2101010(color);
+		return drm_pixel_xrgb8888_to_xrgb2101010(color);
 	case DRM_FORMAT_ARGB2101010:
-		return convert_xrgb8888_to_argb2101010(color);
+		return drm_pixel_xrgb8888_to_argb2101010(color);
 	case DRM_FORMAT_ABGR2101010:
-		return convert_xrgb8888_to_abgr2101010(color);
+		return drm_pixel_xrgb8888_to_abgr2101010(color);
 	default:
 		WARN_ONCE(1, "Can't convert to %p4cc\n", &format);
 		return 0;
diff --git a/drivers/gpu/drm/drm_format_internal.h b/drivers/gpu/drm/drm_format_internal.h
new file mode 100644
index 000000000000..5f82f0b9c8e8
--- /dev/null
+++ b/drivers/gpu/drm/drm_format_internal.h
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: GPL-2.0 or MIT */
+
+#ifndef DRM_FORMAT_INTERNAL_H
+#define DRM_FORMAT_INTERNAL_H
+
+#include <linux/bits.h>
+#include <linux/types.h>
+
+/*
+ * Each pixel-format conversion helper takes a raw pixel in a
+ * specific input format and returns a raw pixel in a specific
+ * output format. All pixels are in little-endian byte order.
+ *
+ * Function names are
+ *
+ *   drm_pixel_<input>_to_<output>_<algorithm>()
+ *
+ * where <input> and <output> refer to pixel formats. The
+ * <algorithm> is optional and hints to the method used for the
+ * conversion. Helpers with no algorithm given apply pixel-bit
+ * shifting.
+ *
+ * The argument type is u32. We expect this to be wide enough to
+ * hold all conversion input from 32-bit RGB to any output format.
+ * The Linux kernel should avoid format conversion for anything
+ * but XRGB8888 input data. Converting from other format can still
+ * be acceptable in some cases.
+ *
+ * The return type is u32. It is wide enough to hold all conversion
+ * output from XRGB8888. For output formats wider than 32 bit, a
+ * return type of u64 would be acceptable.
+ */
+
+/*
+ * Conversions from XRGB8888
+ */
+
+static inline u32 drm_pixel_xrgb8888_to_rgb565(u32 pix)
+{
+	return ((pix & 0x00f80000) >> 8) |
+	       ((pix & 0x0000fc00) >> 5) |
+	       ((pix & 0x000000f8) >> 3);
+}
+
+static inline u32 drm_pixel_xrgb8888_to_rgbx5551(u32 pix)
+{
+	return ((pix & 0x00f80000) >> 8) |
+	       ((pix & 0x0000f800) >> 5) |
+	       ((pix & 0x000000f8) >> 2);
+}
+
+static inline u32 drm_pixel_xrgb8888_to_rgba5551(u32 pix)
+{
+	return drm_pixel_xrgb8888_to_rgbx5551(pix) |
+	       BIT(0); /* set alpha bit */
+}
+
+static inline u32 drm_pixel_xrgb8888_to_xrgb1555(u32 pix)
+{
+	return ((pix & 0x00f80000) >> 9) |
+	       ((pix & 0x0000f800) >> 6) |
+	       ((pix & 0x000000f8) >> 3);
+}
+
+static inline u32 drm_pixel_xrgb8888_to_argb1555(u32 pix)
+{
+	return BIT(15) | /* set alpha bit */
+	       drm_pixel_xrgb8888_to_xrgb1555(pix);
+}
+
+static inline u32 drm_pixel_xrgb8888_to_argb8888(u32 pix)
+{
+	return GENMASK(31, 24) | /* fill alpha bits */
+	       pix;
+}
+
+static inline u32 drm_pixel_xrgb8888_to_xbgr8888(u32 pix)
+{
+	return ((pix & 0xff000000)) | /* also copy filler bits */
+	       ((pix & 0x00ff0000) >> 16) |
+	       ((pix & 0x0000ff00)) |
+	       ((pix & 0x000000ff) << 16);
+}
+
+static inline u32 drm_pixel_xrgb8888_to_abgr8888(u32 pix)
+{
+	return GENMASK(31, 24) | /* fill alpha bits */
+	       drm_pixel_xrgb8888_to_xbgr8888(pix);
+}
+
+static inline u32 drm_pixel_xrgb8888_to_xrgb2101010(u32 pix)
+{
+	pix = ((pix & 0x000000ff) << 2) |
+	      ((pix & 0x0000ff00) << 4) |
+	      ((pix & 0x00ff0000) << 6);
+	return pix | ((pix >> 8) & 0x00300c03);
+}
+
+static inline u32 drm_pixel_xrgb8888_to_argb2101010(u32 pix)
+{
+	return GENMASK(31, 30) | /* set alpha bits */
+	       drm_pixel_xrgb8888_to_xrgb2101010(pix);
+}
+
+static inline u32 drm_pixel_xrgb8888_to_xbgr2101010(u32 pix)
+{
+	pix = ((pix & 0x00ff0000) >> 14) |
+	      ((pix & 0x0000ff00) << 4) |
+	      ((pix & 0x000000ff) << 22);
+	return pix | ((pix >> 8) & 0x00300c03);
+}
+
+static inline u32 drm_pixel_xrgb8888_to_abgr2101010(u32 pix)
+{
+	return GENMASK(31, 30) | /* set alpha bits */
+	       drm_pixel_xrgb8888_to_xbgr2101010(pix);
+}
+
+#endif
-- 
2.50.1



