Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A1511C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1626DC433C8;
	Mon, 28 Aug 2023 10:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219625;
	bh=Pq2i7SRGgofV2Aq/0tiSH2FNl+SybFob/ece/ns347Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoMCK3aSW0+KY4691EXL2KZRSl3SmcWR00AszkDkNZW+I/iiE/DKJiKsWPmbrj7pf
	 rTAme3poa0tFU/PFuqlHygClauapy0DgA41va9gy6l/YfAVrjlowtwykunQaQLRKyD
	 FMbJAJlchTXxLcMH6iG7ySpagI9VmRg4NOBdMp+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/84] fbdev: Fix sys_imageblit() for arbitrary image widths
Date: Mon, 28 Aug 2023 12:13:31 +0200
Message-ID: <20230828101149.684362535@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 61bfcb6a3b981e8f19e044ac8c3de6edbe6caf70 ]

Commit 6f29e04938bf ("fbdev: Improve performance of sys_imageblit()")
broke sys_imageblit() for image width that are not aligned to 8-bit
boundaries. Fix this by handling the trailing pixels on each line
separately. The performance improvements in the original commit do not
regress by this change.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 6f29e04938bf ("fbdev: Improve performance of sys_imageblit()")
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220313192952.12058-2-tzimmermann@suse.de
Stable-dep-of: c2d22806aecb ("fbdev: fix potential OOB read in fast_imageblit()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/sysimgblt.c | 29 ++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/core/sysimgblt.c b/drivers/video/fbdev/core/sysimgblt.c
index 722c327a381bd..335e92b813fc4 100644
--- a/drivers/video/fbdev/core/sysimgblt.c
+++ b/drivers/video/fbdev/core/sysimgblt.c
@@ -188,7 +188,7 @@ static void fast_imageblit(const struct fb_image *image, struct fb_info *p,
 {
 	u32 fgx = fgcolor, bgx = bgcolor, bpp = p->var.bits_per_pixel;
 	u32 ppw = 32/bpp, spitch = (image->width + 7)/8;
-	u32 bit_mask, eorx;
+	u32 bit_mask, eorx, shift;
 	const char *s = image->data, *src;
 	u32 *dst;
 	const u32 *tab;
@@ -229,17 +229,23 @@ static void fast_imageblit(const struct fb_image *image, struct fb_info *p,
 
 	for (i = image->height; i--; ) {
 		dst = dst1;
+		shift = 8;
 		src = s;
 
+		/*
+		 * Manually unroll the per-line copying loop for better
+		 * performance. This works until we processed the last
+		 * completely filled source byte (inclusive).
+		 */
 		switch (ppw) {
 		case 4: /* 8 bpp */
-			for (j = k; j; j -= 2, ++src) {
+			for (j = k; j >= 2; j -= 2, ++src) {
 				*dst++ = colortab[(*src >> 4) & bit_mask];
 				*dst++ = colortab[(*src >> 0) & bit_mask];
 			}
 			break;
 		case 2: /* 16 bpp */
-			for (j = k; j; j -= 4, ++src) {
+			for (j = k; j >= 4; j -= 4, ++src) {
 				*dst++ = colortab[(*src >> 6) & bit_mask];
 				*dst++ = colortab[(*src >> 4) & bit_mask];
 				*dst++ = colortab[(*src >> 2) & bit_mask];
@@ -247,7 +253,7 @@ static void fast_imageblit(const struct fb_image *image, struct fb_info *p,
 			}
 			break;
 		case 1: /* 32 bpp */
-			for (j = k; j; j -= 8, ++src) {
+			for (j = k; j >= 8; j -= 8, ++src) {
 				*dst++ = colortab[(*src >> 7) & bit_mask];
 				*dst++ = colortab[(*src >> 6) & bit_mask];
 				*dst++ = colortab[(*src >> 5) & bit_mask];
@@ -259,6 +265,21 @@ static void fast_imageblit(const struct fb_image *image, struct fb_info *p,
 			}
 			break;
 		}
+
+		/*
+		 * For image widths that are not a multiple of 8, there
+		 * are trailing pixels left on the current line. Print
+		 * them as well.
+		 */
+		for (; j--; ) {
+			shift -= ppw;
+			*dst++ = colortab[(*src >> shift) & bit_mask];
+			if (!shift) {
+				shift = 8;
+				++src;
+			}
+		}
+
 		dst1 += p->fix.line_length;
 		s += spitch;
 	}
-- 
2.40.1



