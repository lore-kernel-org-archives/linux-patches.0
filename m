Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4812FFFA4;
	Mon, 13 Apr 2026 16:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097182; cv=none; b=L1pN5wjKrtVgX6mhkmuqEgyXKetyS6FAV6+gotMA0bOhngHrjYpJelgHL3E2/L652oFbxFfzRauEzLphf99qhEQqEVZ0AcocTOBD5Q+3FPp0YIHrSmx9G7AbbNy9l8WvwsPeG8DWHNalrCZdwV9d1t9bz0+uyynG8RXXBhJtCvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097182; c=relaxed/simple;
	bh=VzJUJAJwVTj1RDS4SywQZ0ULZL9ijkO7XUDhOLsDkgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQ+oZihVu+KvDsFs9os0jxfYTz4IrfU+InxvRep/zBogansTs4HiB5kLdAxsWUX9Y+kLbRZXA7koSMz/znjXIxRJX1B83U0QAyVshs+nxRMPmnTPt395i0fuGlxu3HzOAZEpv4ZbHcr1WQapMj1qgVQWt99vzKYy5AeiriSfPrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQ5wb27g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQ5wb27g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01327C2BCB0;
	Mon, 13 Apr 2026 16:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097182;
	bh=VzJUJAJwVTj1RDS4SywQZ0ULZL9ijkO7XUDhOLsDkgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQ5wb27gwF/mAOafUaM8EG949JtGgjKeCUlqW/OfuzZZGnGdHW56j3EgMOQ0wO7o9
	 CovfnbSXPf5v45J5+ea2HSKQlCw53aoC05iRSHYTx0+aGQWLBxK/AmSjt5FFoO9Vyi
	 iJ+DCgH0PA7xa2IDOb+QbHxVLuxzA0DA0DdGAfWc=
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
Subject: [PATCH 5.15 037/570] fbcon: move more common code into fb_open()
Date: Mon, 13 Apr 2026 17:52:48 +0200
Message-ID: <20260413155831.814084846@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
Stable-dep-of: 011a0502801c ("fbcon: check return value of con2fb_acquire_newinfo()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 75 +++++++++++++-------------------
 1 file changed, 30 insertions(+), 45 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 7131af71a01ca..0039441f3769b 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -676,8 +676,18 @@ static int fbcon_invalid_charcount(struct fb_info *info, unsigned charcount)
 
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
 
@@ -687,48 +697,31 @@ static int fbcon_open(struct fb_info *info)
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
@@ -840,9 +833,11 @@ static int set_con2fb_map(int unit, int newidx, int user)
 
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
@@ -942,20 +937,10 @@ static const char *fbcon_startup(void)
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
@@ -1023,7 +1008,7 @@ static void fbcon_init(struct vc_data *vc, bool init)
 		return;
 
 	if (!info->fbcon_par)
-		con2fb_acquire_newinfo(vc, info, vc->vc_num, -1);
+		con2fb_acquire_newinfo(vc, info, vc->vc_num);
 
 	/* If we are not the first console on this
 	   fb, copy the font from that console */
-- 
2.51.0



