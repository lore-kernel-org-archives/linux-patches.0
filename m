Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9D04F405E;
	Wed, 30 Sep 2026 18:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793743; cv=none; b=baU6XkzllES7tAuthLXsNX/cLbKrRSuc27Y6V31GfvP8v4BOmRN6a4faGjpbMH+XC238lSySVfb0vAnRmx/hf2lKdk8nNlSJSD+5MI8pn9MGSDUgeFF4H5b1DhKkSpSqPoIA6jj4VQVZvcxxp2dHrjjOluscRIhmcAKqe3YmPRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793743; c=relaxed/simple;
	bh=AtX72uYWLtgK0awfbHB3fY6m57uR415Gzwaw14+V3r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llRVtY9PBxKdY5rQGAYRdQWNgHGw/c3COU1Ih5eln46AvzithhP4FZMzY1z57FmTg0ekhQnK1t0csTbZX/3ZeAAHKr4oOcX/NMvySFOe40PSbvAkMU7NURXbZAA7xc4gtuFKXxCOkaulP4+AHFjZCedZArPkyig8bEAb96UN36g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1UcRZEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1UcRZEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC521F000FF;
	Wed, 30 Sep 2026 18:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793741;
	bh=GUMCue3jhDhl4jJPJBQq8S9i3rPNHkWuY+1UaI+EldE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1UcRZEQwxdkoRXbhSmWPZGlJS+bW8xHzzNmmvGKu4qeRQFOhuOF+Ol9ATwC5A5NJ
	 Ft/MYGVLpCD9zsyNVqkb8mF4XXNdx7XM9ACxuipW7PHKIVy7Tf2juEuWTNjKe0l6JF
	 5bD97K2alsMwtIiTRiZD6/47cxmbsEURfVxCYyP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 360/395] drm/client: Pass force parameter to client restore
Date: Wed, 30 Sep 2026 17:30:22 +0200
Message-ID: <20260930152348.496529044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 943240d342f148896733eb6c7b223a08aa1f520a ]

Add force parameter to client restore and pass value through the
layers. The only currently used value is false.

If force is true, the client should restore its display even if it
does not hold the DRM master lock. This is be required for emergency
output, such as sysrq.

While at it, inline drm_fb_helper_lastclose(), which is a trivial
wrapper around drm_fb_helper_restore_fbdev_mode_unlocked().

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patch.msgid.link/20251110154616.539328-2-tzimmermann@suse.de
Stable-dep-of: 1fca688e9443 ("drm/client: fix restore of partially initialized client")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/clients/drm_fbdev_client.c |    6 ++++--
 drivers/gpu/drm/drm_client_event.c         |    4 ++--
 drivers/gpu/drm/drm_fb_helper.c            |   24 ++++++------------------
 drivers/gpu/drm/drm_file.c                 |    2 +-
 include/drm/drm_client.h                   |    8 +++++---
 include/drm/drm_client_event.h             |    4 ++--
 include/drm/drm_fb_helper.h                |    8 ++------
 7 files changed, 22 insertions(+), 34 deletions(-)

--- a/drivers/gpu/drm/clients/drm_fbdev_client.c
+++ b/drivers/gpu/drm/clients/drm_fbdev_client.c
@@ -26,9 +26,11 @@ static void drm_fbdev_client_unregister(
 	}
 }
 
-static int drm_fbdev_client_restore(struct drm_client_dev *client)
+static int drm_fbdev_client_restore(struct drm_client_dev *client, bool force)
 {
-	drm_fb_helper_lastclose(client->dev);
+	struct drm_fb_helper *fb_helper = drm_fb_helper_from_client(client);
+
+	drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, force);
 
 	return 0;
 }
--- a/drivers/gpu/drm/drm_client_event.c
+++ b/drivers/gpu/drm/drm_client_event.c
@@ -101,7 +101,7 @@ void drm_client_dev_hotplug(struct drm_d
 }
 EXPORT_SYMBOL(drm_client_dev_hotplug);
 
-void drm_client_dev_restore(struct drm_device *dev)
+void drm_client_dev_restore(struct drm_device *dev, bool force)
 {
 	struct drm_client_dev *client;
 	int ret;
@@ -114,7 +114,7 @@ void drm_client_dev_restore(struct drm_d
 		if (!client->funcs || !client->funcs->restore)
 			continue;
 
-		ret = client->funcs->restore(client);
+		ret = client->funcs->restore(client, force);
 		drm_dbg_kms(dev, "%s: ret=%d\n", client->name, ret);
 		if (!ret) /* The first one to return zero gets the privilege to restore */
 			break;
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -253,6 +253,7 @@ __drm_fb_helper_restore_fbdev_mode_unloc
 /**
  * drm_fb_helper_restore_fbdev_mode_unlocked - restore fbdev configuration
  * @fb_helper: driver-allocated fbdev helper, can be NULL
+ * @force: ignore present DRM master
  *
  * This helper should be called from fbdev emulation's &drm_client_funcs.restore
  * callback. It ensures that the user isn't greeted with a black screen when the
@@ -261,9 +262,9 @@ __drm_fb_helper_restore_fbdev_mode_unloc
  * Returns:
  * 0 on success, or a negative errno code otherwise.
  */
-int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_helper)
+int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_helper, bool force)
 {
-	return __drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, false);
+	return __drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, force);
 }
 EXPORT_SYMBOL(drm_fb_helper_restore_fbdev_mode_unlocked);
 
@@ -1316,9 +1317,9 @@ int drm_fb_helper_set_par(struct fb_info
 	 * the KDSET IOCTL with KD_TEXT, and only after that drops the master
 	 * status when exiting.
 	 *
-	 * In the past this was caught by drm_fb_helper_lastclose(), but on
-	 * modern systems where logind always keeps a drm fd open to orchestrate
-	 * the vt switching, this doesn't work.
+	 * In the past this was caught by drm_fb_helper_restore_fbdev_mode_unlocked(),
+	 * but on modern systems where logind always keeps a drm fd open to
+	 * orchestrate the vt switching, this doesn't work.
 	 *
 	 * To not break the userspace ABI we have this special case here, which
 	 * is only used for the above case. Everything else uses the normal
@@ -1946,16 +1947,3 @@ int drm_fb_helper_hotplug_event(struct d
 	return 0;
 }
 EXPORT_SYMBOL(drm_fb_helper_hotplug_event);
-
-/**
- * drm_fb_helper_lastclose - DRM driver lastclose helper for fbdev emulation
- * @dev: DRM device
- *
- * This function is obsolete. Call drm_fb_helper_restore_fbdev_mode_unlocked()
- * instead.
- */
-void drm_fb_helper_lastclose(struct drm_device *dev)
-{
-	drm_fb_helper_restore_fbdev_mode_unlocked(dev->fb_helper);
-}
-EXPORT_SYMBOL(drm_fb_helper_lastclose);
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -405,7 +405,7 @@ EXPORT_SYMBOL(drm_open);
 
 static void drm_lastclose(struct drm_device *dev)
 {
-	drm_client_dev_restore(dev);
+	drm_client_dev_restore(dev, false);
 
 	if (dev_is_pci(dev->dev))
 		vga_switcheroo_process_delayed_switch();
--- a/include/drm/drm_client.h
+++ b/include/drm/drm_client.h
@@ -47,12 +47,14 @@ struct drm_client_funcs {
 	 *
 	 * Note that the core does not guarantee exclusion against concurrent
 	 * drm_open(). Clients need to ensure this themselves, for example by
-	 * using drm_master_internal_acquire() and
-	 * drm_master_internal_release().
+	 * using drm_master_internal_acquire() and drm_master_internal_release().
+	 *
+	 * If the caller passes force, the client should ignore any present DRM
+	 * master and restore the display anyway.
 	 *
 	 * This callback is optional.
 	 */
-	int (*restore)(struct drm_client_dev *client);
+	int (*restore)(struct drm_client_dev *client, bool force);
 
 	/**
 	 * @hotplug:
--- a/include/drm/drm_client_event.h
+++ b/include/drm/drm_client_event.h
@@ -10,7 +10,7 @@ struct drm_device;
 #if defined(CONFIG_DRM_CLIENT)
 void drm_client_dev_unregister(struct drm_device *dev);
 void drm_client_dev_hotplug(struct drm_device *dev);
-void drm_client_dev_restore(struct drm_device *dev);
+void drm_client_dev_restore(struct drm_device *dev, bool force);
 void drm_client_dev_suspend(struct drm_device *dev);
 void drm_client_dev_resume(struct drm_device *dev);
 #else
@@ -18,7 +18,7 @@ static inline void drm_client_dev_unregi
 { }
 static inline void drm_client_dev_hotplug(struct drm_device *dev)
 { }
-static inline void drm_client_dev_restore(struct drm_device *dev)
+static inline void drm_client_dev_restore(struct drm_device *dev, bool force)
 { }
 static inline void drm_client_dev_suspend(struct drm_device *dev)
 { }
--- a/include/drm/drm_fb_helper.h
+++ b/include/drm/drm_fb_helper.h
@@ -254,7 +254,8 @@ int drm_fb_helper_set_par(struct fb_info
 int drm_fb_helper_check_var(struct fb_var_screeninfo *var,
 			    struct fb_info *info);
 
-int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_helper);
+int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_helper,
+					      bool force);
 
 void drm_fb_helper_unregister_info(struct drm_fb_helper *fb_helper);
 void drm_fb_helper_fill_info(struct fb_info *info,
@@ -281,7 +282,6 @@ int drm_fb_helper_hotplug_event(struct d
 int drm_fb_helper_initial_config(struct drm_fb_helper *fb_helper);
 int drm_fb_helper_debug_enter(struct fb_info *info);
 int drm_fb_helper_debug_leave(struct fb_info *info);
-void drm_fb_helper_lastclose(struct drm_device *dev);
 #else
 static inline void drm_fb_helper_prepare(struct drm_device *dev,
 					 struct drm_fb_helper *helper,
@@ -397,10 +397,6 @@ static inline int drm_fb_helper_debug_le
 {
 	return 0;
 }
-
-static inline void drm_fb_helper_lastclose(struct drm_device *dev)
-{
-}
 #endif
 
 #endif


