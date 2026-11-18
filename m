Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036774;
	b=uYi+KmxvXkftxt8JXvPonxKHDBwq4qmGzqn5sAJ3KPTiLlQ5l+sYxpNp5MwlBgLiRTPj
	 Pq0TdDd0BtnlRyY2VRfWhuikUFbCMHa2v4RPlUpw3M70M20nG8vlbfHGmJaitbuWdFVgQ
	 SjvAgL2Qtfa6/XMOIrPJnaHly2aLjQjRLgUAK9kiNYmwiNYumbt47QEKX28/f7xx981ZO
	 J/xLGgQp89vXK4C0C1RRsrH2QAxrrk8RFRpAa6Pi19uZScISo0Zj2ALOenDUqAILia6c3
	 qncLMbXqxvkaVhyYcpvUVSzLAiSke+NzZrZX2PTxtrxw0OqEAMoQ6O+1u/S4NkI9ipw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=250iuLY58ba3F6/10cXlYF7CDCyq1AuLex7Kw1fGJ9c=;
	b=PTGybJEdjlPWyJ7eESQHsDxKssBKLku6VPsvMy/U0Xx4a/JdhkB7E0kbc261AqExkHCa
	 PnorT6rWCDqa7tU93oMhtQoUMFJDLT72qo5yE6suz/PHGn7GVW5zHoQU280Fv6qC+U8n8
	 2y3MTNe6fol/ixmmX3UhPK06451IsZFnXnV7PWVN6o1luV/H5A904TbN3r/skQ49mWE+5
	 y+e331ZjEKFEdg71hSgQbNR1szFhlKTZv/Ez48gscGPiS8cOYRSPlp35AjQHt0r5jHuIk
	 2uU6qj5eGWSUKIYopke+Es4ZZA2tOAozzn35bi2Qs0gn8NZipR/ajZh70kze5ME8K7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xW3dxkHJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B775606A320;
	Wed, 18 Nov 2026 21:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xW3dxkHJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA71D1F000C4;
	Wed, 18 Nov 2026 21:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036774;
	bh=250iuLY58ba3F6/10cXlYF7CDCyq1AuLex7Kw1fGJ9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xW3dxkHJVdYxHfo0q0JwDQgsZiRcAX/BBy9fDujXwGsU4J2n8o66SKpsXhMNymZmj
	 qklIQ1AQ/UyHoW88HsVPRKrSgZFfFE+ZHQ6ciy36cg940Yeg3rRH5pusBOymXnQ8fA
	 5HbpH/SEHtIEUcBE+H9rQafRhRjk+EZBC6+H67TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tingjie Zhong <catme0w@live.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1179/3318] fbdev: bitblit: Fix glyph clipping when fbcon pans
Date: Wed, 18 Nov 2026 15:30:01 +0100
Message-ID: <20261118150355.510699116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



