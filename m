Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045675;
	b=iWrFyPV24toTEklYkc+Im1d9FW/BnbAz1FCL6cMjo/QGYYFAO/xAir9ZOFKz1JIxstbm
	 zw51/pEdJzucsIySbQP2vc4YLwdFnyZOzjOADCKVH93K0PYddXx6Lw4gw40zX9lEVZHc1
	 6taYgHQ5nfIBGWd1ZDu8k19mht3sV4Pz9VE00j9h7rGLTU0kk5saKIgvGDWIHhuDJ1P44
	 HqLBYgdUZea2+8hLLhvh1srwRDxkV7hTx3+8BgHWcQj6BMt7FSMgUyCh6QnL1KpWpORCZ
	 j+1hQm49mOoo3K4557ukY9bt7ZygFOphoWOghVxGgVD8foGv0Pp5r1fgKginlX8vhsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uJFc7zNIE7se9lMFGlcF37EOQc5zpEJ+DiauIzwVb/Q=;
	b=BPNATIMqXQn+Hhm5wGFwRcb444dKc43kfFA2y+t6vr71zn99rdzMLuFtfcrALdeDVUUW
	 z19SNvhqQUQ9dfNTyrcqG1aSYTWrOYCtiVTi4uWJ591hH0ByLB6yGemy06M6IUZ94N98A
	 KrIrsA8IfMaVAdulQF3j/bVbEBMaGn87mCS3V2+ABKu2ZzGuA5vuddHvw4pfKd5Pid0Jv
	 yFPds+2qluytYcNi6ZdnmpqGhssdBzfntQggLsoESHBd4Yi/4z6IPHfRZAiinsZBadJnk
	 N+Z88eE/dpX61nX+FQLgqTIk4W++9h2K+0pgVSux0c5ZoLQGVs5r5NsAVkwC3kGsTow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QDd5cnL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06AE606A325;
	Wed, 18 Nov 2026 23:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QDd5cnL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE28B1F000C4;
	Wed, 18 Nov 2026 23:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045675;
	bh=uJFc7zNIE7se9lMFGlcF37EOQc5zpEJ+DiauIzwVb/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QDd5cnLe9xyNqdr6T0sVOpgmMocxwQmGwyjvWUH6iuLuj8OCcPUY6krqUcr4yy7C
	 3AMRPsytUSPHiBOBO5Gdm54e9HGTVgypwnFR7/RbJCEmquPxijDzmAGem7BVKKqw/o
	 SG6agV6kqRoF6C6+7hP5/XHCPbWmueSDkZjbT69A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tingjie Zhong <catme0w@live.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1008/2857] fbdev: bitblit: Fix glyph clipping when fbcon pans
Date: Wed, 18 Nov 2026 15:34:02 +0100
Message-ID: <20261118150237.889268228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8b58f94ce44c5..3d748916d2e9a 100644
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



