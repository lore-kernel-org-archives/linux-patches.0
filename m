Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062491;
	b=Sl2ar8bRX3xARZjg9WXSGnEzVS4YiCp/HRfyzIzirKodkKH7ecuWT7rdve7E0ABHVqan
	 o69OHUkKyq9EdNwTodxRFITuEv3Qr4xfYiTYxeUvfmx/DqjPZj6aj3n9OT4ddJOZGK1o/
	 kKu63O97hxpcsxZGpyR/H9ILKXpyzqRgfNVK4Vl0ismawOFF/rzoWtGDSNJhfwipuAo28
	 Z5y4ZNsdWZ/S6gVp+2jVCc+tpYbGJl0bDnQvxi6Yr+dUz/N69C3chRw5ht92RvxhRwDUB
	 esQsqz9hCeLI7tVyxYZlT3IFVVRvMd4A2TO8qD/6vp4NvJBoHdhm6qM8ctPqPoYrQqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JSFsh426pYTQDop1jVuAfJNMF2Dl1342hF2kRs1/KwA=;
	b=gK4ItAa9meI1L6RG+dnOXEwByyreeVWvX+KpPZEpkAqOdGmR0aEWq9u6Ajy4i9W8e546
	 1NybBDkZNKSJNaz5Q32tVp6zOMA7MTaVlJF88jPUi4qXUBSvDawVxoooL13mpAP3uNqVU
	 4+4J1yQ+bFJ/kP3pthhKRXiCWf21qp8gM1BR/eCjnHGbMt0/ltnAEjpI8jn45k9s5hhAY
	 19yCUWa9n7TPR/RDvXIIWoKp5tIBh7ZjVPNuxh/Jtt5n41yfNAgNJJTstT8khRLDdws06
	 NIvFdW/CEPPcODNVRir3kmo4w+UBq3l7I0qn+4dCV7uWZaXxIZvuV47Xv79OVGOJmgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vBJ5vHgw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787EE606D82E;
	Sat,  7 Nov 2026 14:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vBJ5vHgw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279721F0089F;
	Sat,  7 Nov 2026 14:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062491;
	bh=JSFsh426pYTQDop1jVuAfJNMF2Dl1342hF2kRs1/KwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vBJ5vHgwuJgEz4ar9wtZzAJxkomFl3GXqVQyB06L7jgsUb65FwvHReUmXIzZvfmrh
	 wUjEDiLC22TZcDJCpe/mi8Dlrf8aEwp/fru2Z5c7wBA6vppMSTK60vM2Ze5AkvQ4wC
	 oNGOCktkVn0KfZuQOueoN2pk0GUgjwwicP5u6Src=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tingjie Zhong <catme0w@live.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1390/1536] fbdev: bitblit: Fix glyph clipping when fbcon pans
Date: Sat,  7 Nov 2026 08:56:46 -0500
Message-ID: <20261107135036.870014260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tingjie Zhong <catme0w@live.cn>

[ Upstream commit 06fccf840640d8f6b0e08a1756f8d2f0435b4cbe ]

Commit 3637d34b35b2 ("fbdev: Add bounds checking in bit_putcs to fix
vmalloc-out-of-bounds") made bit_putcs() clip glyphs to var.yres. When
fbcon scrolls by panning, it draws text rows up to var.yres_virtual,
so after the first pan most new text is not drawn until the next full
redraw. This affects fbdev drivers that set FBINFO_HWACCEL_YPAN or
FBINFO_HWACCEL_YWRAP, such as vesafb with the ypan option, when
CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION=y.

Clip to GETVYRES() instead, which fbcon_ud.c and fbcon_ccw.c already
use as the drawing area height. When fbcon does not pan, GETVYRES()
returns var.yres, keeping the existing bound. When fbcon pans, it
returns var.yres_virtual, which the framebuffer memory must cover
anyway for panning to work.

Fixes: 3637d34b35b2 ("fbdev: Add bounds checking in bit_putcs to fix vmalloc-out-of-bounds")
Reported-by: Thomas Zimmermann <tzimmermann@suse.de>
Closes: https://lore.kernel.org/linux-fbdev/b8b52ffd-ecec-4fba-b432-ba32135c2f99@suse.de/
Tested-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Tingjie Zhong <catme0w@live.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/bitblit.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/bitblit.c b/drivers/video/fbdev/core/bitblit.c
index 8f6a2d1736d39..86ae7a7252d21 100644
--- a/drivers/video/fbdev/core/bitblit.c
+++ b/drivers/video/fbdev/core/bitblit.c
@@ -18,6 +18,7 @@
 #include <linux/console.h>
 #include <asm/types.h>
 #include "fbcon.h"
+#include "fbcon_rotate.h"
 
 /*
  * Accelerated handlers.
@@ -151,7 +152,9 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 		      const unsigned short *s, int count, int yy, int xx,
 		      int fg, int bg)
 {
+	struct fbcon_par *par = info->fbcon_par;
 	struct fb_image image;
+	u32 vyres = GETVYRES(par->p, info);
 	u32 width = DIV_ROUND_UP(vc->vc_font.width, 8);
 	u32 cellsize = width * vc->vc_font.height;
 	u32 maxcnt = info->pixmap.size/cellsize;
@@ -168,10 +171,10 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 	image.height = vc->vc_font.height;
 	image.depth = 1;
 
-	if (image.dy >= info->var.yres)
+	if (image.dy >= vyres)
 		return;
 
-	image.height = min(image.height, info->var.yres - image.dy);
+	image.height = min(image.height, vyres - image.dy);
 
 	if (attribute) {
 		buf = kmalloc(cellsize, GFP_ATOMIC);
-- 
2.53.0



