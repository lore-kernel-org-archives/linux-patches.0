Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838F48F5E;
	Tue,  8 Jul 2025 16:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993941; cv=none; b=FHRBkkkEdyMzX8F1Mfbl4Wf3VPA/gAsHKD3YTf3CZd9ODZxyS23ZJIalahiDdRaDwAKX63Pol47HbM9vZEfyFzHmH/RgFsPWuMzmyGf6qADPwBU5Ok6FsUJPkwi6ZhB4JVnUwWz5urKbqWXayY9bykKHwugn9l7/yBLuxuI0ELA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993941; c=relaxed/simple;
	bh=xaQfsa1ZMNdTJleymj/beL6UQQe29nqZRhutiN2U604=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPgpCy0F2kM/IdOLrYUzuxIKNaWSd46OHnAyowmGhYWYJcmImAlioZtkVCgVmYKyHvp7HBXeiQw71niQn90jkCcLEaLvwJUw7pXxtHEyBTU2C9IWPUw+L8BVkRM9CQivnOx/an5gy9Wlu2S8UUdalMLGmlAW0UlcWn/tEFOgmy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdJ9iEnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdJ9iEnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D4AC4CEED;
	Tue,  8 Jul 2025 16:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993941;
	bh=xaQfsa1ZMNdTJleymj/beL6UQQe29nqZRhutiN2U604=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdJ9iEnplqoPvvbE5Xp3inMQ5ac4/mLvmk6rtsl+2iJJEvig9Ex2Acsh5XhvLABbb
	 7nlE01EJ/EStTMi4TLK+60Vlj5uM3gDccreBELuNlXbHQ00XQH3Yd6+x9g3rA2SzgH
	 qKm6lxq4mFcmx4jT0pHK4R4CXcpVdShZDVKdAMnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	kernel test robot <lkp@intel.com>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Claudio Suarez <cssk@net-c.es>,
	Du Cheng <ducheng2@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5.15 041/160] fbcon: move more common code into fb_open()
Date: Tue,  8 Jul 2025 18:21:18 +0200
Message-ID: <20250708162232.673638061@linuxfoundation.org>
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

[ Upstream commit d443d93864726ad68c0a741d1e7b03934a9af143 ]

No idea why con2fb_acquire_newinfo() initializes much less than
fbcon_startup(), but so be it. From a quick look most of the
un-initialized stuff should be fairly harmless, but who knows.

Note that the error handling for the con2fb_acquire_newinfo() failure
case was very strange: Callers updated con2fb_map to the new value
before calling this function, but upon error con2fb_acquire_newinfo
reset it to the old value. Since I removed the call to fbcon_release
anyway that strange error path was sticking out like a sore thumb,
hence I removed it. Which also allows us to remove the oldidx
parameter from that function.

v2: Explain what's going on with oldidx and error paths (Sam)

v3: Drop unused variable (0day)

v4: Rebased over bisect fix in previous patch, unchagend end result.

Acked-by: Sam Ravnborg <sam@ravnborg.org> (v2)
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Claudio Suarez <cssk@net-c.es>
Cc: Du Cheng <ducheng2@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220405210335.3434130-12-daniel.vetter@ffwll.ch
Stable-dep-of: 17186f1f90d3 ("fbdev: Fix do_register_framebuffer to prevent null-ptr-deref in fb_videomode_to_var")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 75 +++++++++++++-------------------
 1 file changed, 30 insertions(+), 45 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 2a230a6335a81..734b8f3f81b24 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -691,8 +691,18 @@ static int fbcon_invalid_charcount(struct fb_info *info, unsigned charcount)
 
 #endif /* CONFIG_MISC_TILEBLITTING */
 
+static void fbcon_release(struct fb_info *info)
+{
+	if (info->fbops->fb_release)
+		info->fbops->fb_release(info, 0);
+
+	module_put(info->fbops->owner);
+}
+
 static int fbcon_open(struct fb_info *info)
 {
+	struct fbcon_ops *ops;
+
 	if (!try_module_get(info->fbops->owner))
 		return -ENODEV;
 
@@ -702,48 +712,31 @@ static int fbcon_open(struct fb_info *info)
 		return -ENODEV;
 	}
 
-	return 0;
-}
+	ops = kzalloc(sizeof(struct fbcon_ops), GFP_KERNEL);
+	if (!ops) {
+		fbcon_release(info);
+		return -ENOMEM;
+	}
 
-static void fbcon_release(struct fb_info *info)
-{
-	if (info->fbops->fb_release)
-		info->fbops->fb_release(info, 0);
+	INIT_DELAYED_WORK(&ops->cursor_work, fb_flashcursor);
+	ops->info = info;
+	info->fbcon_par = ops;
+	ops->cur_blink_jiffies = HZ / 5;
 
-	module_put(info->fbops->owner);
+	return 0;
 }
 
 static int con2fb_acquire_newinfo(struct vc_data *vc, struct fb_info *info,
-				  int unit, int oldidx)
+				  int unit)
 {
-	struct fbcon_ops *ops = NULL;
 	int err;
 
 	err = fbcon_open(info);
 	if (err)
 		return err;
 
-	if (!err) {
-		ops = kzalloc(sizeof(struct fbcon_ops), GFP_KERNEL);
-		if (!ops)
-			err = -ENOMEM;
-	}
-
-	if (!err) {
-		INIT_DELAYED_WORK(&ops->cursor_work, fb_flashcursor);
-
-		ops->cur_blink_jiffies = HZ / 5;
-		ops->info = info;
-		info->fbcon_par = ops;
-
-		if (vc)
-			set_blitting_type(vc, info);
-	}
-
-	if (err) {
-		con2fb_map[unit] = oldidx;
-		fbcon_release(info);
-	}
+	if (vc)
+		set_blitting_type(vc, info);
 
 	return err;
 }
@@ -854,9 +847,11 @@ static int set_con2fb_map(int unit, int newidx, int user)
 
 	found = search_fb_in_map(newidx);
 
-	con2fb_map[unit] = newidx;
-	if (!err && !found)
-		err = con2fb_acquire_newinfo(vc, info, unit, oldidx);
+	if (!err && !found) {
+		err = con2fb_acquire_newinfo(vc, info, unit);
+		if (!err)
+			con2fb_map[unit] = newidx;
+	}
 
 	/*
 	 * If old fb is not mapped to any of the consoles,
@@ -956,20 +951,10 @@ static const char *fbcon_startup(void)
 	if (fbcon_open(info))
 		return NULL;
 
-	ops = kzalloc(sizeof(struct fbcon_ops), GFP_KERNEL);
-	if (!ops) {
-		fbcon_release(info);
-		return NULL;
-	}
-
-	INIT_DELAYED_WORK(&ops->cursor_work, fb_flashcursor);
-
+	ops = info->fbcon_par;
 	ops->currcon = -1;
 	ops->graphics = 1;
 	ops->cur_rotate = -1;
-	ops->cur_blink_jiffies = HZ / 5;
-	ops->info = info;
-	info->fbcon_par = ops;
 
 	p->con_rotate = initial_rotation;
 	if (p->con_rotate == -1)
@@ -1037,7 +1022,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 		return;
 
 	if (!info->fbcon_par)
-		con2fb_acquire_newinfo(vc, info, vc->vc_num, -1);
+		con2fb_acquire_newinfo(vc, info, vc->vc_num);
 
 	/* If we are not the first console on this
 	   fb, copy the font from that console */
-- 
2.39.5



