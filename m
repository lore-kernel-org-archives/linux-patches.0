Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6032E49A8;
	Tue,  8 Jul 2025 16:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993947; cv=none; b=XhQLMOHnMNlT0L8FJ8z7hCKu7dDihEO8AzDR8J4I5PExHh4KG2PFBPoaI08VuOztrQ6Vm/8voeEhv/OGgQDv7tX3KBBl/MHrHEQkTV+QltY9heQE9/X/VztEeSCI7YWZvO6p5f6wFvblaS1lxycZOemAukL14Pl4iqtKQlXQHEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993947; c=relaxed/simple;
	bh=a+3Jvg/TyOGvoStqcLwGJPiuHAx6L7hoKQKDdbXlKF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDrKF0SwilM0FD1wWo+7JErUr1R6XK0TrEknG7lCFoqxPJSo3ef6LLckmPgza9B7vkSvjRZUepY1v3Vb58gk1oz3NjXu2cUDKbLIQHb5xRHwt+yjth7hfW2D4Rvoma3UHmAHPo3Lh8kRQKd+vcizeqchUjxDM+x+zzHXTdl9Xhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1tenqwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1tenqwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59722C4CEED;
	Tue,  8 Jul 2025 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993946;
	bh=a+3Jvg/TyOGvoStqcLwGJPiuHAx6L7hoKQKDdbXlKF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1tenqwfXwVHavGnsDF5w8MylfYO6cb0x/pRmMtp+jnSwHcCfzxFiVbOGuodU9e/p
	 S+bVqvVsgI9cgDh8YUFFGkTqQtmJfOcec8tgf8xlLb8xt9XgGpbF4+sD4A+Q0h+d8P
	 9D/w9WacXWDeWBffLewM8A4NW0ME0OoKg7hAbNm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Du Cheng <ducheng2@gmail.com>,
	Claudio Suarez <cssk@net-c.es>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Matthew Wilcox <willy@infradead.org>,
	Zheyu Ma <zheyuma97@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Alex Deucher <alexander.deucher@amd.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Xiyu Yang <xiyuyang19@fudan.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/160] fbcon: Move console_lock for register/unlink/unregister
Date: Tue,  8 Jul 2025 18:21:20 +0200
Message-ID: <20250708162232.732361864@linuxfoundation.org>
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

[ Upstream commit 6e7da3af008b72520f5318507f455f344b27f022 ]

Ideally console_lock becomes an implementation detail of fbcon.c and
doesn't show up anywhere in fbmem.c. We're still pretty far from that,
but at least the register/unregister code is there now.

With this the do_fb_ioctl() handler is the only code in fbmem.c still
calling console_lock().

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Du Cheng <ducheng2@gmail.com>
Cc: Claudio Suarez <cssk@net-c.es>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Zheyu Ma <zheyuma97@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Link: https://patchwork.freedesktop.org/patch/msgid/20220405210335.3434130-15-daniel.vetter@ffwll.ch
Stable-dep-of: 17186f1f90d3 ("fbdev: Fix do_register_framebuffer to prevent null-ptr-deref in fb_videomode_to_var")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 33 ++++++++++++++++++++++++++------
 drivers/video/fbdev/core/fbmem.c | 23 ++--------------------
 2 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 072a264ae380b..a67f982fe2ec0 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2823,10 +2823,12 @@ void fbcon_fb_unbind(struct fb_info *info)
 	int i, new_idx = -1, ret = 0;
 	int idx = info->node;
 
-	WARN_CONSOLE_UNLOCKED();
+	console_lock();
 
-	if (!fbcon_has_console_bind)
+	if (!fbcon_has_console_bind) {
+		console_unlock();
 		return;
+	}
 
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
 		if (con2fb_map[i] != idx &&
@@ -2866,6 +2868,8 @@ void fbcon_fb_unbind(struct fb_info *info)
 		}
 		fbcon_unbind();
 	}
+
+	console_unlock();
 }
 
 /* called with console_lock held */
@@ -2873,10 +2877,12 @@ void fbcon_fb_unregistered(struct fb_info *info)
 {
 	int i, idx;
 
-	WARN_CONSOLE_UNLOCKED();
+	console_lock();
 
-	if (deferred_takeover)
+	if (deferred_takeover) {
+		console_unlock();
 		return;
+	}
 
 	idx = info->node;
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
@@ -2905,6 +2911,7 @@ void fbcon_fb_unregistered(struct fb_info *info)
 
 	if (!num_registered_fb)
 		do_unregister_con_driver(&fb_con);
+	console_unlock();
 }
 
 void fbcon_remap_all(struct fb_info *info)
@@ -2962,19 +2969,27 @@ static inline void fbcon_select_primary(struct fb_info *info)
 }
 #endif /* CONFIG_FRAMEBUFFER_DETECT_PRIMARY */
 
+static bool lockless_register_fb;
+module_param_named_unsafe(lockless_register_fb, lockless_register_fb, bool, 0400);
+MODULE_PARM_DESC(lockless_register_fb,
+	"Lockless framebuffer registration for debugging [default=off]");
+
 /* called with console_lock held */
 int fbcon_fb_registered(struct fb_info *info)
 {
 	int ret = 0, i, idx;
 
-	WARN_CONSOLE_UNLOCKED();
+	if (!lockless_register_fb)
+		console_lock();
+	else
+		atomic_inc(&ignore_console_lock_warning);
 
 	idx = info->node;
 	fbcon_select_primary(info);
 
 	if (deferred_takeover) {
 		pr_info("fbcon: Deferring console take-over\n");
-		return 0;
+		goto out;
 	}
 
 	if (info_idx == -1) {
@@ -2994,6 +3009,12 @@ int fbcon_fb_registered(struct fb_info *info)
 		}
 	}
 
+out:
+	if (!lockless_register_fb)
+		console_unlock();
+	else
+		atomic_dec(&ignore_console_lock_warning);
+
 	return ret;
 }
 
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index f4253ec8a6409..5e8ee360f6ba2 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1620,14 +1620,9 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
 	}
 }
 
-static bool lockless_register_fb;
-module_param_named_unsafe(lockless_register_fb, lockless_register_fb, bool, 0400);
-MODULE_PARM_DESC(lockless_register_fb,
-	"Lockless framebuffer registration for debugging [default=off]");
-
 static int do_register_framebuffer(struct fb_info *fb_info)
 {
-	int i, ret;
+	int i;
 	struct fb_videomode mode;
 
 	if (fb_check_foreignness(fb_info))
@@ -1696,17 +1691,7 @@ static int do_register_framebuffer(struct fb_info *fb_info)
 	}
 #endif
 
-	if (!lockless_register_fb)
-		console_lock();
-	else
-		atomic_inc(&ignore_console_lock_warning);
-	ret = fbcon_fb_registered(fb_info);
-
-	if (!lockless_register_fb)
-		console_unlock();
-	else
-		atomic_dec(&ignore_console_lock_warning);
-	return ret;
+	return fbcon_fb_registered(fb_info);
 }
 
 static void unbind_console(struct fb_info *fb_info)
@@ -1716,9 +1701,7 @@ static void unbind_console(struct fb_info *fb_info)
 	if (WARN_ON(i < 0 || i >= FB_MAX || registered_fb[i] != fb_info))
 		return;
 
-	console_lock();
 	fbcon_fb_unbind(fb_info);
-	console_unlock();
 }
 
 static void unlink_framebuffer(struct fb_info *fb_info)
@@ -1758,9 +1741,7 @@ static void do_unregister_framebuffer(struct fb_info *fb_info)
 		fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
 	}
 #endif
-	console_lock();
 	fbcon_fb_unregistered(fb_info);
-	console_unlock();
 
 	/* this may free fb info */
 	put_fb_info(fb_info);
-- 
2.39.5



