Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E3F256C84;
	Tue, 21 Jul 2026 15:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649502; cv=none; b=ducrZiiHcQHWClLTa2GfdUXZHQE5NoEyK98pqAgCi+guPRi9DyEf9IE6Ih6FouL56nHftkffb+2TQ/dgNGYki+fIWOi9RuDULbyCgIIoespLVRN511fkX4ZBOW/JReekF+6Kj9XDUn3jfy/d2odhXCVF1Ru7NtiRkgf4t/5J4vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649502; c=relaxed/simple;
	bh=IhVRPJEeizSKsq7lbpLYgAlTg7byox07nz8rbzuIWX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpupVTn6FgjulorkiOn9ofGI7j18Io5nupldTm5DUoV0HiDrJ5u59NGE0CsbI/As90h1SynD3/iCDL7+RoggHYbtlU5xQVxzNik6lDoxzaGy68yDoI6D1yMEeLQ4Lh+vVQZ9+O94asool+LgEC4S4ZnYLOtM7OzFkAJE0I47ffU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPRjhEFs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPRjhEFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388B71F000E9;
	Tue, 21 Jul 2026 15:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649500;
	bh=FgSrSrwR3PXoKkf3HmETtzbJmwl7Cyx8ItlUt96YJMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPRjhEFsPdtt+28RnIxV8QC/578kuCcI4xsCWDLPd2kL9+DcXTfZsXMxPAckidqOG
	 dFFUd3fTsxjkuNhcdnAHJ5CRpoVf5WaQ1WanUDVbF5ZY3OLNmwnPzZF3T+jh0TXawk
	 0npI7qM5AhSHfdYF/MajA3+VWsSPoNbgFitGs4tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0603/2077] fbdev: sm501fb: Fix buffer errors in OF binding code
Date: Tue, 21 Jul 2026 17:04:36 +0200
Message-ID: <20260721152607.029662603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index fee4b9f84592f7..ea5375ed4ea6f3 100644
--- a/drivers/video/fbdev/sm501fb.c
+++ b/drivers/video/fbdev/sm501fb.c
@@ -96,6 +96,7 @@ struct sm501fb_info {
 	void __iomem		*fbmem;		/* remapped framebuffer */
 	size_t			 fbmem_len;	/* length of remapped region */
 	u8 *edid_data;
+	char *fb_mode;
 };
 
 /* per-framebuffer private data */
@@ -1793,12 +1794,11 @@ static int sm501fb_init_fb(struct fb_info *fb, enum sm501_controller head,
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
@@ -1974,7 +1974,7 @@ static int sm501fb_probe(struct platform_device *pdev)
 			/* Get EDID */
 			cp = of_get_property(np, "mode", &len);
 			if (cp)
-				strcpy(fb_mode, cp);
+				info->fb_mode = kstrdup(cp, GFP_KERNEL);
 			prop = of_get_property(np, "edid", &len);
 			if (prop && len == EDID_LENGTH) {
 				info->edid_data = kmemdup(prop, EDID_LENGTH,
@@ -2031,6 +2031,12 @@ static int sm501fb_probe(struct platform_device *pdev)
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
 
@@ -2048,6 +2054,8 @@ static int sm501fb_probe(struct platform_device *pdev)
 	framebuffer_release(info->fb[HEAD_CRT]);
 
 err_alloc:
+	kfree(info->edid_data);
+	kfree(info->fb_mode);
 	kfree(info);
 
 	return ret;
-- 
2.53.0



