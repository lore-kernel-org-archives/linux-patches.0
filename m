Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2B017C21E;
	Tue,  8 Jul 2025 16:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993938; cv=none; b=pg8x7l1G+39QXMd3BFZaWFnam0DjBEh77koZK9tKnT5DSa9+50vXdj41mG5JBFAj6iKUsoZxnuyeOIhJZiSUIVhEytMTFa8yLf5hYGHBuBFz7V4Yl9Jd71u6S0bxln61l02+C4Ld7V83tPRXx5p/nwwH/X009OpFxb3lo8gRunM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993938; c=relaxed/simple;
	bh=ydLyymsysqWd2blfraIDh4JgRxRo/Um3AwcPMerAlWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrhttlRAtn9GWUockx3pN9eLSmR2h8k6mN4Wb5dHG6C2d0Qp3cZ0i2mEYZK0bYF3sDzJYd1oR0CHlRwDcr7rvovLeJJ+Kwn/cwIDfX+0JklQCMAAyoCkppGSN519Ck6IKVB9Ochr+sG92gCFm92rEIMNthuoNJQsKz8ZNqiX6VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oY0qZDTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oY0qZDTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F39C4CEED;
	Tue,  8 Jul 2025 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993938;
	bh=ydLyymsysqWd2blfraIDh4JgRxRo/Um3AwcPMerAlWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oY0qZDTzOVVpljK8Cy01OuLC2TYR2yyAvZh1nEvqYF2k39PeJNKbucJ/UOHdrmoL/
	 pa9ie7r+fKPVFB5vV+VeSjJSZzKAOoFJQm0LAAIsdy4sC3Go1zUiugehgNd2IP/T5A
	 94oady9cQ8q0nvB4MDHoq75c3fSOmiRkomzuS0WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Claudio Suarez <cssk@net-c.es>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Du Cheng <ducheng2@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/160] fbcon: Extract fbcon_open/release helpers
Date: Tue,  8 Jul 2025 18:21:17 +0200
Message-ID: <20250708162232.645779492@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit bd6026a8c4e6b7edf4bafcb71da885b284b8f4fd ]

There's two minor behaviour changes in here:
- in error paths we now consistently call fb_ops->fb_release
- fb_release really can't fail (fbmem.c ignores it too) and there's no
  reasonable cleanup we can do anyway.

Note that everything in fbcon.c is protected by the big console_lock()
lock (especially all the global variables), so the minor changes in
ordering of setup/cleanup do not matter.

v2: Explain a bit better why this is all correct (Sam)

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Claudio Suarez <cssk@net-c.es>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Du Cheng <ducheng2@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220405210335.3434130-10-daniel.vetter@ffwll.ch
Stable-dep-of: 17186f1f90d3 ("fbdev: Fix do_register_framebuffer to prevent null-ptr-deref in fb_videomode_to_var")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 107 +++++++++++++++----------------
 1 file changed, 53 insertions(+), 54 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index abea89d101626..2a230a6335a81 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -691,19 +691,37 @@ static int fbcon_invalid_charcount(struct fb_info *info, unsigned charcount)
 
 #endif /* CONFIG_MISC_TILEBLITTING */
 
+static int fbcon_open(struct fb_info *info)
+{
+	if (!try_module_get(info->fbops->owner))
+		return -ENODEV;
+
+	if (info->fbops->fb_open &&
+	    info->fbops->fb_open(info, 0)) {
+		module_put(info->fbops->owner);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void fbcon_release(struct fb_info *info)
+{
+	if (info->fbops->fb_release)
+		info->fbops->fb_release(info, 0);
+
+	module_put(info->fbops->owner);
+}
 
 static int con2fb_acquire_newinfo(struct vc_data *vc, struct fb_info *info,
 				  int unit, int oldidx)
 {
 	struct fbcon_ops *ops = NULL;
-	int err = 0;
-
-	if (!try_module_get(info->fbops->owner))
-		err = -ENODEV;
+	int err;
 
-	if (!err && info->fbops->fb_open &&
-	    info->fbops->fb_open(info, 0))
-		err = -ENODEV;
+	err = fbcon_open(info);
+	if (err)
+		return err;
 
 	if (!err) {
 		ops = kzalloc(sizeof(struct fbcon_ops), GFP_KERNEL);
@@ -724,7 +742,7 @@ static int con2fb_acquire_newinfo(struct vc_data *vc, struct fb_info *info,
 
 	if (err) {
 		con2fb_map[unit] = oldidx;
-		module_put(info->fbops->owner);
+		fbcon_release(info);
 	}
 
 	return err;
@@ -735,45 +753,34 @@ static int con2fb_release_oldinfo(struct vc_data *vc, struct fb_info *oldinfo,
 				  int oldidx, int found)
 {
 	struct fbcon_ops *ops = oldinfo->fbcon_par;
-	int err = 0, ret;
+	int ret;
 
-	if (oldinfo->fbops->fb_release &&
-	    oldinfo->fbops->fb_release(oldinfo, 0)) {
-		con2fb_map[unit] = oldidx;
-		if (!found && newinfo->fbops->fb_release)
-			newinfo->fbops->fb_release(newinfo, 0);
-		if (!found)
-			module_put(newinfo->fbops->owner);
-		err = -ENODEV;
-	}
+	fbcon_release(oldinfo);
 
-	if (!err) {
-		fbcon_del_cursor_work(oldinfo);
-		kfree(ops->cursor_state.mask);
-		kfree(ops->cursor_data);
-		kfree(ops->cursor_src);
-		kfree(ops->fontbuffer);
-		kfree(oldinfo->fbcon_par);
-		oldinfo->fbcon_par = NULL;
-		module_put(oldinfo->fbops->owner);
-		/*
-		  If oldinfo and newinfo are driving the same hardware,
-		  the fb_release() method of oldinfo may attempt to
-		  restore the hardware state.  This will leave the
-		  newinfo in an undefined state. Thus, a call to
-		  fb_set_par() may be needed for the newinfo.
-		*/
-		if (newinfo && newinfo->fbops->fb_set_par) {
-			ret = newinfo->fbops->fb_set_par(newinfo);
+	fbcon_del_cursor_work(oldinfo);
+	kfree(ops->cursor_state.mask);
+	kfree(ops->cursor_data);
+	kfree(ops->cursor_src);
+	kfree(ops->fontbuffer);
+	kfree(oldinfo->fbcon_par);
+	oldinfo->fbcon_par = NULL;
+	/*
+	  If oldinfo and newinfo are driving the same hardware,
+	  the fb_release() method of oldinfo may attempt to
+	  restore the hardware state.  This will leave the
+	  newinfo in an undefined state. Thus, a call to
+	  fb_set_par() may be needed for the newinfo.
+	*/
+	if (newinfo && newinfo->fbops->fb_set_par) {
+		ret = newinfo->fbops->fb_set_par(newinfo);
 
-			if (ret)
-				printk(KERN_ERR "con2fb_release_oldinfo: "
-					"detected unhandled fb_set_par error, "
-					"error code %d\n", ret);
-		}
+		if (ret)
+			printk(KERN_ERR "con2fb_release_oldinfo: "
+				"detected unhandled fb_set_par error, "
+				"error code %d\n", ret);
 	}
 
-	return err;
+	return 0;
 }
 
 static void con2fb_init_display(struct vc_data *vc, struct fb_info *info,
@@ -928,7 +935,6 @@ static const char *fbcon_startup(void)
 	struct fbcon_display *p = &fb_display[fg_console];
 	struct vc_data *vc = vc_cons[fg_console].d;
 	const struct font_desc *font = NULL;
-	struct module *owner;
 	struct fb_info *info = NULL;
 	struct fbcon_ops *ops;
 	int rows, cols;
@@ -947,17 +953,12 @@ static const char *fbcon_startup(void)
 	if (!info)
 		return NULL;
 	
-	owner = info->fbops->owner;
-	if (!try_module_get(owner))
+	if (fbcon_open(info))
 		return NULL;
-	if (info->fbops->fb_open && info->fbops->fb_open(info, 0)) {
-		module_put(owner);
-		return NULL;
-	}
 
 	ops = kzalloc(sizeof(struct fbcon_ops), GFP_KERNEL);
 	if (!ops) {
-		module_put(owner);
+		fbcon_release(info);
 		return NULL;
 	}
 
@@ -3387,10 +3388,6 @@ static void fbcon_exit(void)
 		}
 
 		if (mapped) {
-			if (info->fbops->fb_release)
-				info->fbops->fb_release(info, 0);
-			module_put(info->fbops->owner);
-
 			if (info->fbcon_par) {
 				struct fbcon_ops *ops = info->fbcon_par;
 
@@ -3400,6 +3397,8 @@ static void fbcon_exit(void)
 				kfree(info->fbcon_par);
 				info->fbcon_par = NULL;
 			}
+
+			fbcon_release(info);
 		}
 	}
 }
-- 
2.39.5



