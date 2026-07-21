Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D623B1034;
	Tue, 21 Jul 2026 20:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666030; cv=none; b=HPQTDJJvx+4xfrVYIU4decXeUGSDZgAY1gMtocHMeAvnSVAfrJ4teimG/yb+pejJouy1CsjFS5iViTydKsgaNChy0XpLHGIB0tpDFOoIrLZv7efW/IxniSAZ5YEo/9uOoEqk8QlnXyb/GR3RWKEBuAX9F7acg9MRezaO/mNFi7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666030; c=relaxed/simple;
	bh=e8Y+3LXeLTkSZKU8L9aXao69iuO5ucCfURZ0TS6uFyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9rOjx9wUi7KVPShCefYeokPG0IJLRr5ozR0osTQZoSJmjV3KyUtuRyJwwJvpFlH+AUS/xJNm8xU/M1fgTJsqLpgoCX9GrpmzHiZisyWVzl4VG0midYV7JfFk+NQZQtZEyg2LeA/KDVqbtfof7lnHgWobcgdvFLeS9BZgxHdBXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyErt8ee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyErt8ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194C61F000E9;
	Tue, 21 Jul 2026 20:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666029;
	bh=V7qtrOCsNKMmxpkySlT5IwOyJwLUcboV9746n8JkQuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RyErt8ee1JNVOlznq7CZWxYDnKxDcuHDG7tDOLLX3FOg4q66wjFqR5cQ0f2a1ef6P
	 /LgufOf+zE9l/+NrhQ2bffmN/2YW0pKO03p5fhPqkFwAAU+W2w2LKH998ZBqYZ0xcc
	 F3NcKOPGR4TOh6krIaaw3OEXMAtgZdxRpfl/6Zks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0528/1266] fbdev: sm501fb: Fix buffer errors in OF binding code
Date: Tue, 21 Jul 2026 17:16:05 +0200
Message-ID: <20260721152453.671043737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit d8421e09382cfe0bd2a044c8b0a822f64855dd4e ]

The code that gets the frame buffer mode from OF has 'use after free',
'buffer overrun' and memory leaks.

info->edid_data isn't free if the probe functions fail or if
pd->def_mode is set.

If both the CRT and PANEL are enabled info->edid_data is used after
being freed and is freed twice.

The string returned by of_get_property(np, "mode", &len) is just
written over either the static "640x480-16@60" or the module parameter
string without any regard for the length (which is most likely longer).

Use kstrump() for the OF mode and free everything before freeing 'info.

Fixes: 4295f9bf74a88 ("video, sm501: add OF binding to support SM501")
Signed-off-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sm501fb.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/sm501fb.c b/drivers/video/fbdev/sm501fb.c
index b9d72f368c6c69..6223f966ea928c 100644
--- a/drivers/video/fbdev/sm501fb.c
+++ b/drivers/video/fbdev/sm501fb.c
@@ -95,6 +95,7 @@ struct sm501fb_info {
 	void __iomem		*fbmem;		/* remapped framebuffer */
 	size_t			 fbmem_len;	/* length of remapped region */
 	u8 *edid_data;
+	char *fb_mode;
 };
 
 /* per-framebuffer private data */
@@ -1788,12 +1789,11 @@ static int sm501fb_init_fb(struct fb_info *fb, enum sm501_controller head,
 			fb->var.yres_virtual = fb->var.yres;
 		} else {
 			if (info->edid_data) {
-				ret = fb_find_mode(&fb->var, fb, fb_mode,
+				ret = fb_find_mode(&fb->var, fb,
+					info->fb_mode ?: fb_mode,
 					fb->monspecs.modedb,
 					fb->monspecs.modedb_len,
 					&sm501_default_mode, default_bpp);
-				/* edid_data is no longer needed, free it */
-				kfree(info->edid_data);
 			} else {
 				ret = fb_find_mode(&fb->var, fb,
 					   NULL, NULL, 0, NULL, 8);
@@ -1969,7 +1969,7 @@ static int sm501fb_probe(struct platform_device *pdev)
 			/* Get EDID */
 			cp = of_get_property(np, "mode", &len);
 			if (cp)
-				strcpy(fb_mode, cp);
+				info->fb_mode = kstrdup(cp, GFP_KERNEL);
 			prop = of_get_property(np, "edid", &len);
 			if (prop && len == EDID_LENGTH) {
 				info->edid_data = kmemdup(prop, EDID_LENGTH,
@@ -2026,6 +2026,12 @@ static int sm501fb_probe(struct platform_device *pdev)
 		goto err_started_crt;
 	}
 
+	/* These aren't needed any more */
+	kfree(info->edid_data);
+	kfree(info->fb_mode);
+	info->edid_data = NULL;
+	info->fb_mode = NULL;
+
 	/* we registered, return ok */
 	return 0;
 
@@ -2043,6 +2049,8 @@ static int sm501fb_probe(struct platform_device *pdev)
 	framebuffer_release(info->fb[HEAD_CRT]);
 
 err_alloc:
+	kfree(info->edid_data);
+	kfree(info->fb_mode);
 	kfree(info);
 
 	return ret;
-- 
2.53.0



