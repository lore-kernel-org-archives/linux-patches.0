Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6738515CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E80C433C1;
	Tue,  8 Nov 2022 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915757;
	bh=p8b2hTvH9GVMRAwvndYCtY9fxlRCRZamGuqz+oL8d9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QydUF7iRs+FfLoXFvc7OPa68nz1/ZxnX1U/D++Y+GKgBP0I9Iji0THlNxK5M6y3f+
	 3dTnGkSsoz1StcO599suXGQLc6etrmxYDkYhTaR3BIhRqhgmN8FFSMFXwi7n2bVmz2
	 U6ax1pc0UDn3Mrh64f7vYxTBwsOg/RycUJBYdFzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/118] video/fbdev/stifb: Implement the stifb_fillrect() function
Date: Tue,  8 Nov 2022 14:38:50 +0100
Message-Id: <20221108133342.968501513@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

[ Upstream commit 9c379c65241707e44072139d782bc2dfec9b4ab3 ]

The stifb driver (for Artist/HCRX graphics on PA-RISC) was missing
the fillrect function.
Tested on a 715/64 PA-RISC machine and in qemu.

Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 776d875fd4cb ("fbdev: stifb: Fall back to cfb_fillrect() on 32-bit HCRX cards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/stifb.c | 45 +++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index b0470f4f595e..7753e586e65a 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1041,6 +1041,47 @@ stifb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 	SETUP_FB(fb);
 }
 
+#define ARTIST_VRAM_SIZE			0x000804
+#define ARTIST_VRAM_SRC				0x000808
+#define ARTIST_VRAM_SIZE_TRIGGER_WINFILL	0x000a04
+#define ARTIST_VRAM_DEST_TRIGGER_BLOCKMOVE	0x000b00
+#define ARTIST_SRC_BM_ACCESS			0x018008
+#define ARTIST_FGCOLOR				0x018010
+#define ARTIST_BGCOLOR				0x018014
+#define ARTIST_BITMAP_OP			0x01801c
+
+static void
+stifb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
+{
+	struct stifb_info *fb = container_of(info, struct stifb_info, info);
+
+	if (rect->rop != ROP_COPY)
+		return cfb_fillrect(info, rect);
+
+	SETUP_HW(fb);
+
+	if (fb->info.var.bits_per_pixel == 32) {
+		WRITE_WORD(0xBBA0A000, fb, REG_10);
+
+		NGLE_REALLY_SET_IMAGE_PLANEMASK(fb, 0xffffffff);
+	} else {
+		WRITE_WORD(fb->id == S9000_ID_HCRX ? 0x13a02000 : 0x13a01000, fb, REG_10);
+
+		NGLE_REALLY_SET_IMAGE_PLANEMASK(fb, 0xff);
+	}
+
+	WRITE_WORD(0x03000300, fb, ARTIST_BITMAP_OP);
+	WRITE_WORD(0x2ea01000, fb, ARTIST_SRC_BM_ACCESS);
+	NGLE_QUICK_SET_DST_BM_ACCESS(fb, 0x2ea01000);
+	NGLE_REALLY_SET_IMAGE_FG_COLOR(fb, rect->color);
+	WRITE_WORD(0, fb, ARTIST_BGCOLOR);
+
+	NGLE_SET_DSTXY(fb, (rect->dx << 16) | (rect->dy));
+	SET_LENXY_START_RECFILL(fb, (rect->width << 16) | (rect->height));
+
+	SETUP_FB(fb);
+}
+
 static void __init
 stifb_init_display(struct stifb_info *fb)
 {
@@ -1105,7 +1146,7 @@ static const struct fb_ops stifb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_setcolreg	= stifb_setcolreg,
 	.fb_blank	= stifb_blank,
-	.fb_fillrect	= cfb_fillrect,
+	.fb_fillrect	= stifb_fillrect,
 	.fb_copyarea	= stifb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
 };
@@ -1297,7 +1338,7 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 		goto out_err0;
 	}
 	info->screen_size = fix->smem_len;
-	info->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_COPYAREA;
+	info->flags = FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT;
 	info->pseudo_palette = &fb->pseudo_palette;
 
 	/* This has to be done !!! */
-- 
2.35.1



