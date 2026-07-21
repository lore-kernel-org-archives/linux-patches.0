Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CDC408039;
	Tue, 21 Jul 2026 19:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662028; cv=none; b=WziiBMF62yc9DG03WveLxpEYs0m8OJNiTVzlZrqGSFy6DwF0Us3VI8TpL2Ld67sPN5FhqgvjZOnW8FEGNBAeu6LoSNRyta+Ge4TJyPoTtpnWYqDlAF3zdA367KIrnr089jOBeNuVqE6gqOLB9NVNTmMB7yfT3KdS3UQDRtgL25s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662028; c=relaxed/simple;
	bh=ptOf3Kzz+4JRqG0n6vlurL2+URMZXld03mhuthN4IiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wsmf3JM+otKDkFlyaXUuI7LggVogQXV47EF5wmRQMFVKNP0JzFzufln68BToMhkhY8QIs2EOquetHW1JWIKXfz5qeJ2B5yJNX2+q73ptLsuGa4CPbeW1Ra3OtOl+n4YArkrXEbEj8hBxua2w9OJ66t/OrmMtDbEzBEe/A7d8pvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TqB0+uUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqB0+uUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B901F000E9;
	Tue, 21 Jul 2026 19:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662027;
	bh=hKESCMf8o0x8VtBQ6JoNET9DWvDQgCstMUUwqJAuiL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TqB0+uUIa41p5sARK31FG4ZrcpbOsZUO3nKQHwblD7oAa6MatE+K7QapXyQYbxQlJ
	 2sOvInEtvJj+TPw0IlSKFu4PpgHmne/UnD+1NY/qWWNmFv0nfNH2b5iRgeWMZ8C95B
	 FbzU+fYtf/4G2rF0wojJD0i/aWTMkyVGa/DeZ+qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0290/1276] fbdev: sm501fb: Fix buffer errors in OF binding code
Date: Tue, 21 Jul 2026 17:12:13 +0200
Message-ID: <20260721152452.574735162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2eb27ebf822e80..571530bacbd913 100644
--- a/drivers/video/fbdev/sm501fb.c
+++ b/drivers/video/fbdev/sm501fb.c
@@ -95,6 +95,7 @@ struct sm501fb_info {
 	void __iomem		*fbmem;		/* remapped framebuffer */
 	size_t			 fbmem_len;	/* length of remapped region */
 	u8 *edid_data;
+	char *fb_mode;
 };
 
 /* per-framebuffer private data */
@@ -1792,12 +1793,11 @@ static int sm501fb_init_fb(struct fb_info *fb, enum sm501_controller head,
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
@@ -1973,7 +1973,7 @@ static int sm501fb_probe(struct platform_device *pdev)
 			/* Get EDID */
 			cp = of_get_property(np, "mode", &len);
 			if (cp)
-				strcpy(fb_mode, cp);
+				info->fb_mode = kstrdup(cp, GFP_KERNEL);
 			prop = of_get_property(np, "edid", &len);
 			if (prop && len == EDID_LENGTH) {
 				info->edid_data = kmemdup(prop, EDID_LENGTH,
@@ -2030,6 +2030,12 @@ static int sm501fb_probe(struct platform_device *pdev)
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
 
@@ -2047,6 +2053,8 @@ static int sm501fb_probe(struct platform_device *pdev)
 	framebuffer_release(info->fb[HEAD_CRT]);
 
 err_alloc:
+	kfree(info->edid_data);
+	kfree(info->fb_mode);
 	kfree(info);
 
 	return ret;
-- 
2.53.0



