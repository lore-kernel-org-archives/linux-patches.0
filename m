Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA067611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470C0C433C7;
	Mon, 28 Aug 2023 10:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219262;
	bh=IXr44UkxhDmR1f3qeHvDM7Wd7Ho1HFhngtIJPy815UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phm4Ue+wZopNsK5/RgSgsovZPBg33uQqJ1zimt0SU8bC0w1kzggVLesL5iRnpSGeb
	 OLAKC/AHvJnbDbGoNws2UIWIQsezSNDWOiSmK/UZk8ket+YcZvD90CaLXvCANDAp8k
	 ZBJGWG+VHlD1XpxJg9Qy9fJqjI1LbGDha/Z8EzM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/158] fbdev: Improve performance of sys_imageblit()
Date: Mon, 28 Aug 2023 12:13:21 +0200
Message-ID: <20230828101200.820283902@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 6f29e04938bf509fccfad490a74284cf158891ce ]

Improve the performance of sys_imageblit() by manually unrolling
the inner blitting loop and moving some invariants out. The compiler
failed to do this automatically. The resulting binary code was even
slower than the cfb_imageblit() helper, which uses the same algorithm,
but operates on I/O memory.

A microbenchmark measures the average number of CPU cycles
for sys_imageblit() after a stabilizing period of a few minutes
(i7-4790, FullHD, simpledrm, kernel with debugging). The value
for CFB is given as a reference.

  sys_imageblit(), new: 25934 cycles
  sys_imageblit(), old: 35944 cycles
  cfb_imageblit():      30566 cycles

In the optimized case, sys_imageblit() is now ~30% faster than before
and ~20% faster than cfb_imageblit().

v2:
	* move switch out of inner loop (Gerd)
	* remove test for alignment of dst1 (Sam)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220223193804.18636-3-tzimmermann@suse.de
Stable-dep-of: c2d22806aecb ("fbdev: fix potential OOB read in fast_imageblit()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/sysimgblt.c | 49 +++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/video/fbdev/core/sysimgblt.c b/drivers/video/fbdev/core/sysimgblt.c
index a4d05b1b17d7d..722c327a381bd 100644
--- a/drivers/video/fbdev/core/sysimgblt.c
+++ b/drivers/video/fbdev/core/sysimgblt.c
@@ -188,23 +188,29 @@ static void fast_imageblit(const struct fb_image *image, struct fb_info *p,
 {
 	u32 fgx = fgcolor, bgx = bgcolor, bpp = p->var.bits_per_pixel;
 	u32 ppw = 32/bpp, spitch = (image->width + 7)/8;
-	u32 bit_mask, end_mask, eorx, shift;
+	u32 bit_mask, eorx;
 	const char *s = image->data, *src;
 	u32 *dst;
-	const u32 *tab = NULL;
+	const u32 *tab;
+	size_t tablen;
+	u32 colortab[16];
 	int i, j, k;
 
 	switch (bpp) {
 	case 8:
 		tab = fb_be_math(p) ? cfb_tab8_be : cfb_tab8_le;
+		tablen = 16;
 		break;
 	case 16:
 		tab = fb_be_math(p) ? cfb_tab16_be : cfb_tab16_le;
+		tablen = 4;
 		break;
 	case 32:
-	default:
 		tab = cfb_tab32;
+		tablen = 2;
 		break;
+	default:
+		return;
 	}
 
 	for (i = ppw-1; i--; ) {
@@ -218,19 +224,40 @@ static void fast_imageblit(const struct fb_image *image, struct fb_info *p,
 	eorx = fgx ^ bgx;
 	k = image->width/ppw;
 
+	for (i = 0; i < tablen; ++i)
+		colortab[i] = (tab[i] & eorx) ^ bgx;
+
 	for (i = image->height; i--; ) {
 		dst = dst1;
-		shift = 8;
 		src = s;
 
-		for (j = k; j--; ) {
-			shift -= ppw;
-			end_mask = tab[(*src >> shift) & bit_mask];
-			*dst++ = (end_mask & eorx) ^ bgx;
-			if (!shift) {
-				shift = 8;
-				src++;
+		switch (ppw) {
+		case 4: /* 8 bpp */
+			for (j = k; j; j -= 2, ++src) {
+				*dst++ = colortab[(*src >> 4) & bit_mask];
+				*dst++ = colortab[(*src >> 0) & bit_mask];
+			}
+			break;
+		case 2: /* 16 bpp */
+			for (j = k; j; j -= 4, ++src) {
+				*dst++ = colortab[(*src >> 6) & bit_mask];
+				*dst++ = colortab[(*src >> 4) & bit_mask];
+				*dst++ = colortab[(*src >> 2) & bit_mask];
+				*dst++ = colortab[(*src >> 0) & bit_mask];
+			}
+			break;
+		case 1: /* 32 bpp */
+			for (j = k; j; j -= 8, ++src) {
+				*dst++ = colortab[(*src >> 7) & bit_mask];
+				*dst++ = colortab[(*src >> 6) & bit_mask];
+				*dst++ = colortab[(*src >> 5) & bit_mask];
+				*dst++ = colortab[(*src >> 4) & bit_mask];
+				*dst++ = colortab[(*src >> 3) & bit_mask];
+				*dst++ = colortab[(*src >> 2) & bit_mask];
+				*dst++ = colortab[(*src >> 1) & bit_mask];
+				*dst++ = colortab[(*src >> 0) & bit_mask];
 			}
+			break;
 		}
 		dst1 += p->fix.line_length;
 		s += spitch;
-- 
2.40.1



