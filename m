Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52311078F;
	Tue, 30 Jul 2024 16:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358274; cv=none; b=Vr1VZ73tfmz83QBmKxFvXrUBEsztY7HCDFdQ40n2wv/apO8ahuMvk52cUpMVUhBKHdolXcVBhL6JVhCTzNxFYbVcoBMAHkMyRf+kgFNd0lKuvFRBIInCC671AWXluKpS3rm7jHj5VN9MPICiWrwsV4T4GnADgRJ0HzlN+5AifvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358274; c=relaxed/simple;
	bh=VW/VWwgCrod1FlH8KWolMTUxO3Su0ghpAGjjW2+QSms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fk3XFHCyD2WSSmOLR03UsScd2d7IQZSocHyR9hAVoFFL3gV1S97tglf3mAAsKLwujr1bNUx+fToqi5m8dk+7S+0hq/TiSX6wk0c1RPTn8aIhh4jKAUZho71D6sGf0hlMHuZoByWt5eEAMdUKKOUy8ixUwAix4AcCIdrxbXhHalw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1cRNVIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1cRNVIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28489C32782;
	Tue, 30 Jul 2024 16:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358274;
	bh=VW/VWwgCrod1FlH8KWolMTUxO3Su0ghpAGjjW2+QSms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1cRNVIEsLXlkHtjYjd4dhMQv8fc5JORANCFWYDSKPMZsQcSBCHvP31d6m4HVShkl
	 J/8axRanKz3a7dyR2TXbPums3fVoiUt4E8nbrr4/e7T7HGSyYfYZbBG9/o8azvraLk
	 dBAn/4I4Zzvw2Zq9XAh9RpVAs5AohDOvhm0PyfjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 341/809] drm/panic: only draw the foreground color in drm_panic_blit()
Date: Tue, 30 Jul 2024 17:43:37 +0200
Message-ID: <20240730151738.104261454@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jocelyn Falempe <jfalempe@redhat.com>

[ Upstream commit eef5a55af31792fc7a2082dbebac68a7df4d7643 ]

The whole framebuffer is cleared, so it's useless to rewrite the
background colored pixels. It allows to simplify the drawing
functions, and prepare the work for the set_pixel() callback.

v2:
 * keep fg16/fg24/fg32 as variable name for the blit function.
 * add drm_panic_is_pixel_fg() to avoid code duplication.
 both suggested by Javier Martinez Canillas

Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240603095343.39588-2-jfalempe@redhat.com
Stable-dep-of: 94ff11d3bd32 ("drm/panic: Fix off-by-one logo size checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 67 +++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index 7ece67086cecb..056494ae1edef 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -194,40 +194,42 @@ static u32 convert_from_xrgb8888(u32 color, u32 format)
 /*
  * Blit & Fill
  */
+/* check if the pixel at coord x,y is 1 (foreground) or 0 (background) */
+static bool drm_panic_is_pixel_fg(const u8 *sbuf8, unsigned int spitch, int x, int y)
+{
+	return (sbuf8[(y * spitch) + x / 8] & (0x80 >> (x % 8))) != 0;
+}
+
 static void drm_panic_blit16(struct iosys_map *dmap, unsigned int dpitch,
 			     const u8 *sbuf8, unsigned int spitch,
 			     unsigned int height, unsigned int width,
-			     u16 fg16, u16 bg16)
+			     u16 fg16)
 {
 	unsigned int y, x;
-	u16 val16;
 
-	for (y = 0; y < height; y++) {
-		for (x = 0; x < width; x++) {
-			val16 = (sbuf8[(y * spitch) + x / 8] & (0x80 >> (x % 8))) ? fg16 : bg16;
-			iosys_map_wr(dmap, y * dpitch + x * sizeof(u16), u16, val16);
-		}
-	}
+	for (y = 0; y < height; y++)
+		for (x = 0; x < width; x++)
+			if (drm_panic_is_pixel_fg(sbuf8, spitch, x, y))
+				iosys_map_wr(dmap, y * dpitch + x * sizeof(u16), u16, fg16);
 }
 
 static void drm_panic_blit24(struct iosys_map *dmap, unsigned int dpitch,
 			     const u8 *sbuf8, unsigned int spitch,
 			     unsigned int height, unsigned int width,
-			     u32 fg32, u32 bg32)
+			     u32 fg32)
 {
 	unsigned int y, x;
-	u32 val32;
 
 	for (y = 0; y < height; y++) {
 		for (x = 0; x < width; x++) {
 			u32 off = y * dpitch + x * 3;
 
-			val32 = (sbuf8[(y * spitch) + x / 8] & (0x80 >> (x % 8))) ? fg32 : bg32;
-
-			/* write blue-green-red to output in little endianness */
-			iosys_map_wr(dmap, off, u8, (val32 & 0x000000FF) >> 0);
-			iosys_map_wr(dmap, off + 1, u8, (val32 & 0x0000FF00) >> 8);
-			iosys_map_wr(dmap, off + 2, u8, (val32 & 0x00FF0000) >> 16);
+			if (drm_panic_is_pixel_fg(sbuf8, spitch, x, y)) {
+				/* write blue-green-red to output in little endianness */
+				iosys_map_wr(dmap, off, u8, (fg32 & 0x000000FF) >> 0);
+				iosys_map_wr(dmap, off + 1, u8, (fg32 & 0x0000FF00) >> 8);
+				iosys_map_wr(dmap, off + 2, u8, (fg32 & 0x00FF0000) >> 16);
+			}
 		}
 	}
 }
@@ -235,17 +237,14 @@ static void drm_panic_blit24(struct iosys_map *dmap, unsigned int dpitch,
 static void drm_panic_blit32(struct iosys_map *dmap, unsigned int dpitch,
 			     const u8 *sbuf8, unsigned int spitch,
 			     unsigned int height, unsigned int width,
-			     u32 fg32, u32 bg32)
+			     u32 fg32)
 {
 	unsigned int y, x;
-	u32 val32;
 
-	for (y = 0; y < height; y++) {
-		for (x = 0; x < width; x++) {
-			val32 = (sbuf8[(y * spitch) + x / 8] & (0x80 >> (x % 8))) ? fg32 : bg32;
-			iosys_map_wr(dmap, y * dpitch + x * sizeof(u32), u32, val32);
-		}
-	}
+	for (y = 0; y < height; y++)
+		for (x = 0; x < width; x++)
+			if (drm_panic_is_pixel_fg(sbuf8, spitch, x, y))
+				iosys_map_wr(dmap, y * dpitch + x * sizeof(u32), u32, fg32);
 }
 
 /*
@@ -257,7 +256,6 @@ static void drm_panic_blit32(struct iosys_map *dmap, unsigned int dpitch,
  * @height: height of the image to copy, in pixels
  * @width: width of the image to copy, in pixels
  * @fg_color: foreground color, in destination format
- * @bg_color: background color, in destination format
  * @pixel_width: pixel width in bytes.
  *
  * This can be used to draw a font character, which is a monochrome image, to a
@@ -266,21 +264,20 @@ static void drm_panic_blit32(struct iosys_map *dmap, unsigned int dpitch,
 static void drm_panic_blit(struct iosys_map *dmap, unsigned int dpitch,
 			   const u8 *sbuf8, unsigned int spitch,
 			   unsigned int height, unsigned int width,
-			   u32 fg_color, u32 bg_color,
-			   unsigned int pixel_width)
+			   u32 fg_color, unsigned int pixel_width)
 {
 	switch (pixel_width) {
 	case 2:
 		drm_panic_blit16(dmap, dpitch, sbuf8, spitch,
-				 height, width, fg_color, bg_color);
+				 height, width, fg_color);
 	break;
 	case 3:
 		drm_panic_blit24(dmap, dpitch, sbuf8, spitch,
-				 height, width, fg_color, bg_color);
+				 height, width, fg_color);
 	break;
 	case 4:
 		drm_panic_blit32(dmap, dpitch, sbuf8, spitch,
-				 height, width, fg_color, bg_color);
+				 height, width, fg_color);
 	break;
 	default:
 		WARN_ONCE(1, "Can't blit with pixel width %d\n", pixel_width);
@@ -381,8 +378,7 @@ static void draw_txt_rectangle(struct drm_scanout_buffer *sb,
 			       unsigned int msg_lines,
 			       bool centered,
 			       struct drm_rect *clip,
-			       u32 fg_color,
-			       u32 bg_color)
+			       u32 color)
 {
 	int i, j;
 	const u8 *src;
@@ -404,8 +400,7 @@ static void draw_txt_rectangle(struct drm_scanout_buffer *sb,
 		for (j = 0; j < line_len; j++) {
 			src = get_char_bitmap(font, msg[i].txt[j], font_pitch);
 			drm_panic_blit(&dst, sb->pitch[0], src, font_pitch,
-				       font->height, font->width,
-				       fg_color, bg_color, px_width);
+				       font->height, font->width, color, px_width);
 			iosys_map_incr(&dst, font->width * px_width);
 		}
 	}
@@ -445,9 +440,9 @@ static void draw_panic_static(struct drm_scanout_buffer *sb)
 
 	if ((r_msg.x1 >= drm_rect_width(&r_logo) || r_msg.y1 >= drm_rect_height(&r_logo)) &&
 	    drm_rect_width(&r_logo) < sb->width && drm_rect_height(&r_logo) < sb->height) {
-		draw_txt_rectangle(sb, font, logo, logo_lines, false, &r_logo, fg_color, bg_color);
+		draw_txt_rectangle(sb, font, logo, logo_lines, false, &r_logo, fg_color);
 	}
-	draw_txt_rectangle(sb, font, panic_msg, msg_lines, true, &r_msg, fg_color, bg_color);
+	draw_txt_rectangle(sb, font, panic_msg, msg_lines, true, &r_msg, fg_color);
 }
 
 /*
-- 
2.43.0



