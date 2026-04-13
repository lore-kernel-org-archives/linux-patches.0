Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC232EBB8C;
	Mon, 13 Apr 2026 16:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097177; cv=none; b=Jutup6mRQDCX44Xxm/5GQUXjRRm6dHmiIzKV21pd7ZXN/m5GoBolplVj/gdZVOhCwyQzAqWj7tQKG48zpEsSTs68+5Qg+CfnliTOTPOsRlsc2KerOqHPfd0QaePOnVIuHEUJttx84HuyOGyQCp6m5/i24dSxTTvMCYVZdYdx5bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097177; c=relaxed/simple;
	bh=R7uyiYlQYHIssgzk5/LwZ55YWXzO60sgNS0gmAKQcZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptjikfXvDY8ktNkg612d48I26Ahk7eNA9+YI5PCaPEh4JUBFIjVzaItn4PUTqpva1DdFVRvzTZJz/tAJYEncaafavWzqmJ17FgY5JrKjETrYz/2wNnMcTFO3CEKT24PIa/kUDtCg/Fiej4q1DbPmQYEGbWkM0t9GWHrhMOTHTpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12myvS6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12myvS6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8738C2BCAF;
	Mon, 13 Apr 2026 16:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097177;
	bh=R7uyiYlQYHIssgzk5/LwZ55YWXzO60sgNS0gmAKQcZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12myvS6eMDu4sM9l1wG6eDJH8HduLrAN4vSGO8+q+Y1kOJkrFTkLGJJXypd4zg205
	 3wfIJmgT/+r7AfW+xipxemm1r5Zgkot7w72LVEp50qJYCcsL9fjWqA4qJnowtw8trn
	 FZ9krSFzU7Vs11nkjAz2Xx6PoFU68HlwYCg9lUo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Claudio Suarez <cssk@net-c.es>,
	Du Cheng <ducheng2@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/570] fbcon: Use delayed work for cursor
Date: Mon, 13 Apr 2026 17:52:46 +0200
Message-ID: <20260413155831.738349215@linuxfoundation.org>
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

[ Upstream commit 3b0fb6ab25dda03f6077bf8fce9407bb0d4db6ea ]

Allows us to delete a bunch of hand-rolled stuff using a timer plus a
separate work). Also to simplify the code we initialize the
cursor_work completely when we allocate the fbcon_ops structure,
instead of trying to cope with console re-initialization.

The motiviation here is that fbcon code stops using the fb_info.queue,
which helps with locking issues around cleanup and all that in a later
patch.

Also note that this allows us to ditch the hand-rolled work cleanup in
fbcon_exit - we already call fbcon_del_cursor_timer, which takes care
of everything. Plus this was racy anyway.

v2:
- Only INIT_DELAYED_WORK when kzalloc succeeded (Tetsuo)
- Explain that we replace both the timer and a work with the combined
  delayed_work (Javier)

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Claudio Suarez <cssk@net-c.es>
Cc: Du Cheng <ducheng2@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://patchwork.freedesktop.org/patch/msgid/20220405210335.3434130-7-daniel.vetter@ffwll.ch
Stable-dep-of: 011a0502801c ("fbcon: check return value of con2fb_acquire_newinfo()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 85 +++++++++++++-------------------
 drivers/video/fbdev/core/fbcon.h |  4 +-
 2 files changed, 35 insertions(+), 54 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 8922595cc491d..4ad8618968715 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -342,8 +342,8 @@ static int get_color(struct vc_data *vc, struct fb_info *info,
 
 static void fb_flashcursor(struct work_struct *work)
 {
-	struct fb_info *info = container_of(work, struct fb_info, queue);
-	struct fbcon_ops *ops = info->fbcon_par;
+	struct fbcon_ops *ops = container_of(work, struct fbcon_ops, cursor_work.work);
+	struct fb_info *info;
 	struct vc_data *vc = NULL;
 	int c;
 	int mode;
@@ -356,7 +356,10 @@ static void fb_flashcursor(struct work_struct *work)
 	if (ret == 0)
 		return;
 
-	if (ops && ops->currcon != -1)
+	/* protected by console_lock */
+	info = ops->info;
+
+	if (ops->currcon != -1)
 		vc = vc_cons[ops->currcon].d;
 
 	if (!vc || !con_is_visible(vc) ||
@@ -372,42 +375,25 @@ static void fb_flashcursor(struct work_struct *work)
 	ops->cursor(vc, info, mode, get_color(vc, info, c, 1),
 		    get_color(vc, info, c, 0));
 	console_unlock();
-}
 
-static void cursor_timer_handler(struct timer_list *t)
-{
-	struct fbcon_ops *ops = from_timer(ops, t, cursor_timer);
-	struct fb_info *info = ops->info;
-
-	queue_work(system_power_efficient_wq, &info->queue);
-	mod_timer(&ops->cursor_timer, jiffies + ops->cur_blink_jiffies);
+	queue_delayed_work(system_power_efficient_wq, &ops->cursor_work,
+			   ops->cur_blink_jiffies);
 }
 
-static void fbcon_add_cursor_timer(struct fb_info *info)
+static void fbcon_add_cursor_work(struct fb_info *info)
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 
-	if ((!info->queue.func || info->queue.func == fb_flashcursor) &&
-	    !(ops->flags & FBCON_FLAGS_CURSOR_TIMER) &&
-	    !fbcon_cursor_noblink) {
-		if (!info->queue.func)
-			INIT_WORK(&info->queue, fb_flashcursor);
-
-		timer_setup(&ops->cursor_timer, cursor_timer_handler, 0);
-		mod_timer(&ops->cursor_timer, jiffies + ops->cur_blink_jiffies);
-		ops->flags |= FBCON_FLAGS_CURSOR_TIMER;
-	}
+	if (!fbcon_cursor_noblink)
+		queue_delayed_work(system_power_efficient_wq, &ops->cursor_work,
+				   ops->cur_blink_jiffies);
 }
 
-static void fbcon_del_cursor_timer(struct fb_info *info)
+static void fbcon_del_cursor_work(struct fb_info *info)
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 
-	if (info->queue.func == fb_flashcursor &&
-	    ops->flags & FBCON_FLAGS_CURSOR_TIMER) {
-		del_timer_sync(&ops->cursor_timer);
-		ops->flags &= ~FBCON_FLAGS_CURSOR_TIMER;
-	}
+	cancel_delayed_work_sync(&ops->cursor_work);
 }
 
 #ifndef MODULE
@@ -711,6 +697,8 @@ static int con2fb_acquire_newinfo(struct vc_data *vc, struct fb_info *info,
 	}
 
 	if (!err) {
+		INIT_DELAYED_WORK(&ops->cursor_work, fb_flashcursor);
+
 		ops->cur_blink_jiffies = HZ / 5;
 		ops->info = info;
 		info->fbcon_par = ops;
@@ -745,7 +733,7 @@ static int con2fb_release_oldinfo(struct vc_data *vc, struct fb_info *oldinfo,
 	}
 
 	if (!err) {
-		fbcon_del_cursor_timer(oldinfo);
+		fbcon_del_cursor_work(oldinfo);
 		kfree(ops->cursor_state.mask);
 		kfree(ops->cursor_data);
 		kfree(ops->cursor_src);
@@ -862,7 +850,7 @@ static int set_con2fb_map(int unit, int newidx, int user)
 				 logo_shown != FBCON_LOGO_DONTSHOW);
 
 		if (!found)
-			fbcon_add_cursor_timer(info);
+			fbcon_add_cursor_work(info);
 		con2fb_map_boot[unit] = newidx;
 		con2fb_init_display(vc, info, unit, show_logo);
 	}
@@ -959,6 +947,8 @@ static const char *fbcon_startup(void)
 		return NULL;
 	}
 
+	INIT_DELAYED_WORK(&ops->cursor_work, fb_flashcursor);
+
 	ops->currcon = -1;
 	ops->graphics = 1;
 	ops->cur_rotate = -1;
@@ -999,7 +989,7 @@ static const char *fbcon_startup(void)
 		 info->var.yres,
 		 info->var.bits_per_pixel);
 
-	fbcon_add_cursor_timer(info);
+	fbcon_add_cursor_work(info);
 	return display_desc;
 }
 
@@ -1185,7 +1175,7 @@ static void fbcon_deinit(struct vc_data *vc)
 		goto finished;
 
 	if (con_is_visible(vc))
-		fbcon_del_cursor_timer(info);
+		fbcon_del_cursor_work(info);
 
 	ops->flags &= ~FBCON_FLAGS_INIT;
 finished:
@@ -1318,9 +1308,9 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
 		return;
 
 	if (vc->vc_cursor_type & CUR_SW)
-		fbcon_del_cursor_timer(info);
+		fbcon_del_cursor_work(info);
 	else
-		fbcon_add_cursor_timer(info);
+		fbcon_add_cursor_work(info);
 
 	ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;
 
@@ -2126,14 +2116,14 @@ static bool fbcon_switch(struct vc_data *vc)
 		}
 
 		if (old_info != info)
-			fbcon_del_cursor_timer(old_info);
+			fbcon_del_cursor_work(old_info);
 	}
 
 	if (fbcon_is_inactive(vc, info) ||
 	    ops->blank_state != FB_BLANK_UNBLANK)
-		fbcon_del_cursor_timer(info);
+		fbcon_del_cursor_work(info);
 	else
-		fbcon_add_cursor_timer(info);
+		fbcon_add_cursor_work(info);
 
 	set_blitting_type(vc, info);
 	ops->cursor_reset = 1;
@@ -2241,9 +2231,9 @@ static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
 
 	if (mode_switch || fbcon_is_inactive(vc, info) ||
 	    ops->blank_state != FB_BLANK_UNBLANK)
-		fbcon_del_cursor_timer(info);
+		fbcon_del_cursor_work(info);
 	else
-		fbcon_add_cursor_timer(info);
+		fbcon_add_cursor_work(info);
 
 	return 0;
 }
@@ -3240,7 +3230,7 @@ static ssize_t show_cursor_blink(struct device *device,
 	if (!ops)
 		goto err;
 
-	blink = (ops->flags & FBCON_FLAGS_CURSOR_TIMER) ? 1 : 0;
+	blink = delayed_work_pending(&ops->cursor_work);
 err:
 	console_unlock();
 	return snprintf(buf, PAGE_SIZE, "%d\n", blink);
@@ -3269,10 +3259,10 @@ static ssize_t store_cursor_blink(struct device *device,
 
 	if (blink) {
 		fbcon_cursor_noblink = 0;
-		fbcon_add_cursor_timer(info);
+		fbcon_add_cursor_work(info);
 	} else {
 		fbcon_cursor_noblink = 1;
-		fbcon_del_cursor_timer(info);
+		fbcon_del_cursor_work(info);
 	}
 
 err:
@@ -3385,15 +3375,9 @@ static void fbcon_exit(void)
 #endif
 
 	for_each_registered_fb(i) {
-		int pending = 0;
-
 		mapped = 0;
 		info = registered_fb[i];
 
-		if (info->queue.func)
-			pending = cancel_work_sync(&info->queue);
-		pr_debug("fbcon: %s pending work\n", (pending ? "canceled" : "no"));
-
 		for (j = first_fb_vc; j <= last_fb_vc; j++) {
 			if (con2fb_map[j] == i) {
 				mapped = 1;
@@ -3409,15 +3393,12 @@ static void fbcon_exit(void)
 			if (info->fbcon_par) {
 				struct fbcon_ops *ops = info->fbcon_par;
 
-				fbcon_del_cursor_timer(info);
+				fbcon_del_cursor_work(info);
 				kfree(ops->cursor_src);
 				kfree(ops->cursor_state.mask);
 				kfree(info->fbcon_par);
 				info->fbcon_par = NULL;
 			}
-
-			if (info->queue.func == fb_flashcursor)
-				info->queue.func = NULL;
 		}
 	}
 }
diff --git a/drivers/video/fbdev/core/fbcon.h b/drivers/video/fbdev/core/fbcon.h
index 3e1ec454b8aa3..a709e5796ef7e 100644
--- a/drivers/video/fbdev/core/fbcon.h
+++ b/drivers/video/fbdev/core/fbcon.h
@@ -14,11 +14,11 @@
 #include <linux/types.h>
 #include <linux/vt_buffer.h>
 #include <linux/vt_kern.h>
+#include <linux/workqueue.h>
 
 #include <asm/io.h>
 
 #define FBCON_FLAGS_INIT         1
-#define FBCON_FLAGS_CURSOR_TIMER 2
 
    /*
     *    This is the interface between the low-level console driver and the
@@ -68,7 +68,7 @@ struct fbcon_ops {
 	int  (*update_start)(struct fb_info *info);
 	int  (*rotate_font)(struct fb_info *info, struct vc_data *vc);
 	struct fb_var_screeninfo var;  /* copy of the current fb_var_screeninfo */
-	struct timer_list cursor_timer; /* Cursor timer */
+	struct delayed_work cursor_work; /* Cursor timer */
 	struct fb_cursor cursor_state;
 	struct fbcon_display *p;
 	struct fb_info *info;
-- 
2.51.0



