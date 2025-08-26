Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6A318DF9D;
	Tue, 26 Aug 2025 11:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208827; cv=none; b=UIdymeZL8k/0RhMz8mDJ3eGWG8L344CCc4V+YW2JIX5t8YXFOMD6MZAYMdNRG9EJGDQ40pgoyTATz/FVUbTV7ArBMPF9L8byXC1n2YXgUwowU5/NdmlSeRLb3dKehAVOMObIEAi5N82nkFSqtBO49PUbsXJeyIA8gOSHR82zh6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208827; c=relaxed/simple;
	bh=1HmAIAUTCqmVMA9+5XhmgCMZitkOxKVOJ7KricUFylE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5Osi6t6u1Wz0R+qEl3afD85QwhPt0dyGUXWMDQem1SmGmj9G1PyFROdO/XpoaPr5fWB7lPUuOBvB+F5oaFO4rLRMnW2kiMAKFmOBAT/n10jQPasiNnOMmSt7GUq1AZSpuQm2GCYHdTe+QSqP89OC2Xnl2PiNglfrpIRL7fAqyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJkPoms1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJkPoms1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F068C4CEF4;
	Tue, 26 Aug 2025 11:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208827;
	bh=1HmAIAUTCqmVMA9+5XhmgCMZitkOxKVOJ7KricUFylE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJkPoms1vyGyeQxIbz8yMTjyQWZ56fHSSKE5c7ELfYo+4HQ1F/x+4zhu7i75N4jtC
	 B74jq09HRXeLnRZrijRVuIaO3hESMw7+wd7hLDv1MHN0Eb98DAq+czETjfxPqbsvGu
	 sibhOwGmoi9r0o9IO6d7oSyKhE+Fo+AJrtsUmGW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/322] drm/format-helper: Add generic conversion to 32-bit formats
Date: Tue, 26 Aug 2025 13:11:15 +0200
Message-ID: <20250826110922.353873434@linuxfoundation.org>
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

[ Upstream commit d55d0b066f4eedf030c9c1a67a2a0abffece3abc ]

Add drm_fb_xfrm_line_32to32() to implement conversion from 32-bit
pixels to 32-bit pixels. The pixel-conversion is specified by the
given callback parameter. Mark the helper as always_inline to avoid
overhead from function calls.

Then implement all existing line-conversion functions with the new
generic call and the respective pixel-conversion helper.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20250328141709.217283-3-tzimmermann@suse.de
Stable-dep-of: 05663d88fd0b ("drm/tests: Fix drm_test_fb_xrgb8888_to_xrgb2101010() on big-endian")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_format_helper.c | 84 +++++++----------------------
 1 file changed, 19 insertions(+), 65 deletions(-)

diff --git a/drivers/gpu/drm/drm_format_helper.c b/drivers/gpu/drm/drm_format_helper.c
index 4f60c8d8f63e..4dcb78895581 100644
--- a/drivers/gpu/drm/drm_format_helper.c
+++ b/drivers/gpu/drm/drm_format_helper.c
@@ -20,6 +20,8 @@
 #include <drm/drm_print.h>
 #include <drm/drm_rect.h>
 
+#include "drm_format_internal.h"
+
 /**
  * drm_format_conv_state_init - Initialize format-conversion state
  * @state: The state to initialize
@@ -244,6 +246,18 @@ static int drm_fb_xfrm(struct iosys_map *dst,
 				     xfrm_line);
 }
 
+static __always_inline void drm_fb_xfrm_line_32to32(void *dbuf, const void *sbuf,
+						    unsigned int pixels,
+						    u32 (*xfrm_pixel)(u32))
+{
+	__le32 *dbuf32 = dbuf;
+	const __le32 *sbuf32 = sbuf;
+	const __le32 *send32 = sbuf32 + pixels;
+
+	while (sbuf32 < send32)
+		*dbuf32++ = cpu_to_le32(xfrm_pixel(le32_to_cpup(sbuf32++)));
+}
+
 /**
  * drm_fb_memcpy - Copy clip buffer
  * @dst: Array of destination buffers
@@ -755,16 +769,7 @@ EXPORT_SYMBOL(drm_fb_xrgb8888_to_bgr888);
 
 static void drm_fb_xrgb8888_to_argb8888_line(void *dbuf, const void *sbuf, unsigned int pixels)
 {
-	__le32 *dbuf32 = dbuf;
-	const __le32 *sbuf32 = sbuf;
-	unsigned int x;
-	u32 pix;
-
-	for (x = 0; x < pixels; x++) {
-		pix = le32_to_cpu(sbuf32[x]);
-		pix |= GENMASK(31, 24); /* fill alpha bits */
-		dbuf32[x] = cpu_to_le32(pix);
-	}
+	drm_fb_xfrm_line_32to32(dbuf, sbuf, pixels, drm_pixel_xrgb8888_to_argb8888);
 }
 
 /**
@@ -804,19 +809,7 @@ EXPORT_SYMBOL(drm_fb_xrgb8888_to_argb8888);
 
 static void drm_fb_xrgb8888_to_abgr8888_line(void *dbuf, const void *sbuf, unsigned int pixels)
 {
-	__le32 *dbuf32 = dbuf;
-	const __le32 *sbuf32 = sbuf;
-	unsigned int x;
-	u32 pix;
-
-	for (x = 0; x < pixels; x++) {
-		pix = le32_to_cpu(sbuf32[x]);
-		pix = ((pix & 0x00ff0000) >> 16) <<  0 |
-		      ((pix & 0x0000ff00) >>  8) <<  8 |
-		      ((pix & 0x000000ff) >>  0) << 16 |
-		      GENMASK(31, 24); /* fill alpha bits */
-		*dbuf32++ = cpu_to_le32(pix);
-	}
+	drm_fb_xfrm_line_32to32(dbuf, sbuf, pixels, drm_pixel_xrgb8888_to_abgr8888);
 }
 
 static void drm_fb_xrgb8888_to_abgr8888(struct iosys_map *dst, const unsigned int *dst_pitch,
@@ -835,19 +828,7 @@ static void drm_fb_xrgb8888_to_abgr8888(struct iosys_map *dst, const unsigned in
 
 static void drm_fb_xrgb8888_to_xbgr8888_line(void *dbuf, const void *sbuf, unsigned int pixels)
 {
-	__le32 *dbuf32 = dbuf;
-	const __le32 *sbuf32 = sbuf;
-	unsigned int x;
-	u32 pix;
-
-	for (x = 0; x < pixels; x++) {
-		pix = le32_to_cpu(sbuf32[x]);
-		pix = ((pix & 0x00ff0000) >> 16) <<  0 |
-		      ((pix & 0x0000ff00) >>  8) <<  8 |
-		      ((pix & 0x000000ff) >>  0) << 16 |
-		      ((pix & 0xff000000) >> 24) << 24;
-		*dbuf32++ = cpu_to_le32(pix);
-	}
+	drm_fb_xfrm_line_32to32(dbuf, sbuf, pixels, drm_pixel_xrgb8888_to_xbgr8888);
 }
 
 static void drm_fb_xrgb8888_to_xbgr8888(struct iosys_map *dst, const unsigned int *dst_pitch,
@@ -866,20 +847,7 @@ static void drm_fb_xrgb8888_to_xbgr8888(struct iosys_map *dst, const unsigned in
 
 static void drm_fb_xrgb8888_to_xrgb2101010_line(void *dbuf, const void *sbuf, unsigned int pixels)
 {
-	__le32 *dbuf32 = dbuf;
-	const __le32 *sbuf32 = sbuf;
-	unsigned int x;
-	u32 val32;
-	u32 pix;
-
-	for (x = 0; x < pixels; x++) {
-		pix = le32_to_cpu(sbuf32[x]);
-		val32 = ((pix & 0x000000FF) << 2) |
-			((pix & 0x0000FF00) << 4) |
-			((pix & 0x00FF0000) << 6);
-		pix = val32 | ((val32 >> 8) & 0x00300C03);
-		*dbuf32++ = cpu_to_le32(pix);
-	}
+	drm_fb_xfrm_line_32to32(dbuf, sbuf, pixels, drm_pixel_xrgb8888_to_xrgb2101010);
 }
 
 /**
@@ -920,21 +888,7 @@ EXPORT_SYMBOL(drm_fb_xrgb8888_to_xrgb2101010);
 
 static void drm_fb_xrgb8888_to_argb2101010_line(void *dbuf, const void *sbuf, unsigned int pixels)
 {
-	__le32 *dbuf32 = dbuf;
-	const __le32 *sbuf32 = sbuf;
-	unsigned int x;
-	u32 val32;
-	u32 pix;
-
-	for (x = 0; x < pixels; x++) {
-		pix = le32_to_cpu(sbuf32[x]);
-		val32 = ((pix & 0x000000ff) << 2) |
-			((pix & 0x0000ff00) << 4) |
-			((pix & 0x00ff0000) << 6);
-		pix = GENMASK(31, 30) | /* set alpha bits */
-		      val32 | ((val32 >> 8) & 0x00300c03);
-		*dbuf32++ = cpu_to_le32(pix);
-	}
+	drm_fb_xfrm_line_32to32(dbuf, sbuf, pixels, drm_pixel_xrgb8888_to_argb2101010);
 }
 
 /**
-- 
2.50.1



