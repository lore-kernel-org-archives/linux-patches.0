Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063604;
	b=WDMnGyxMtuCYgNT69d91bpkmHRHkjnh1jgbIstYCNLnSyK9R9IaH+rn9OWBWsX0+cS0j
	 nJnf3mWbGXEQpxlm+ZMIhOaQ4/ExPbF94jQSyBWBHc7JDRW5c3Zix5R4HNiUuF94JNDKQ
	 Ds0i29i9JYYlMim7yC8MxLij8tpb+YB8cXTKGukvckZK+DK8Z11ffLjzGCeXDYIYk482Y
	 XkHBXof/jlHYUaXrjHqrOqI2FP1+zWrWyMUVGsNPknWjQNHcao0hyDZ60bIbMh/i9HMZW
	 eiVgEF4oLXO2S2HhBN5JkPoW/m7bJWa6SttzDyMXEB5jzjOsF02/lSdV8d7aAsc22ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AbAKcyfCa3U0l9c9iWNZ1U6Jo6XLk7kcZWHP6V4Fqfo=;
	b=MVz7mjzKzHH+bxyIighSo18B6KwxeR+bMsaUbWgk5U9TFFOSpCacnKdWep2lXVqGoApb
	 zrQ0nxHF1ixAihpkA9YwqyVgj2GlK3gu+E51lGIBkgeaN3JCIi74f9HiHn+YRnjGqZ+Nc
	 NVchA73VRiKGkHCxMz26ayhLwgYqFozldBcALg2+oJbM20BkBPACRjzSBwJuehfIcixaE
	 86lyXBX3krLJME5LYDyWwjrqin7ajf27G3A3wJu1+XOv0+ZTnZRwqv7tX5B95rYo9zUja
	 3HHmMVI+OxUHfKVt7S634dZnExZ6myBP213cmfYVnXDHdwRA7ssuCjPz6DUIZvh4RwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAMp6ila;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F676082BDC;
	Sat,  7 Nov 2026 15:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAMp6ila
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC341F0089F;
	Sat,  7 Nov 2026 15:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063604;
	bh=AbAKcyfCa3U0l9c9iWNZ1U6Jo6XLk7kcZWHP6V4Fqfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAMp6ilaNdhvwxN5KhAqmSLcXDVPtUlFAJnnb24AUWCWdxSS44k684wUCUzetfc1v
	 GIHeahQCyhstHSnSauSx0vWKTZwGfwUV8khIA/q92C6dno+9mwaG7xq9ptzMVbfcaG
	 fARC3N+NidpbB+PPLJbIv5vp+SmwJH2QTcKg3poA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tingjie Zhong <catme0w@live.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 689/869] fbdev: bitblit: Fix glyph clipping when fbcon pans
Date: Sat,  7 Nov 2026 08:56:11 -0500
Message-ID: <20261107134916.383976306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



