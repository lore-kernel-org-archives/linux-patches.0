Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C3815E5BB;
	Tue, 17 Mar 2026 17:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768546; cv=none; b=qH9C7BQrWpA4fooVtQfzg+2gDImOPyqz08R3BDYeaprvbtBSoktYEWpevEgjPVjYAu7eWKZlMEwaC+Tq2E/lBzoH0xfwgHFwbExgWvhtaEXO2H9Y5Rrw7skPt6CzVwB3NUoSlNE1SVPVZPTTGQWWeM9qdrhlwDrf6oPFuQ5q/MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768546; c=relaxed/simple;
	bh=sqGaTQDEDM7gti1YVe+TJnhCo1QiKw2APPLe4P/jZEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+mpQPmqJbjR+ejaKjtj6kcNZzxIoKmCmi2HU8huSgPExfEpc+C99SNdhtiyASyh+M6k8RVy5IxsPu0sk2AYjfzz7kGuWodvkiScmanaydO1eSAfOM2t2uvxofHLmA6VNKiWIBoQ+R5R6bKYoCiKTdPoEhSBURAQaO+WhNzZ3eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvbkTx1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvbkTx1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEEBC4CEF7;
	Tue, 17 Mar 2026 17:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768545;
	bh=sqGaTQDEDM7gti1YVe+TJnhCo1QiKw2APPLe4P/jZEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvbkTx1W2PHUn+CD+awEQWvovxq6dSycTd8RKe8SbUt5KpRqq7/vxHp3vsyyE2sbz
	 zMcAV1SP/cZgJ9E2GxeQnT8B3wkY4UCMA7yfyG2LZWULMzecl4NowOor9X0M5QnQwy
	 JbX/U0uGnTTqHvglrR6wbuMOjXd+WpoGw4DPQz+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Shenghao Yang <me@shenghaoyang.info>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ruben Wauters <rubenru09@aol.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 318/333] drm/gud: fix NULL crtc dereference on display disable
Date: Tue, 17 Mar 2026 17:35:47 +0100
Message-ID: <20260317163011.178417626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Shenghao Yang <me@shenghaoyang.info>

[ Upstream commit 7149be786da012afc6bae293d38f8c1fff1fb90d ]

gud_plane_atomic_update() currently handles both crtc state and
framebuffer updates - the complexity has led to a few accidental
NULL pointer dereferences.

Commit dc2d5ddb193e ("drm/gud: fix NULL fb and crtc dereferences
on USB disconnect") [1] fixed an earlier dereference but planes
can also be disabled in non-hotplug paths (e.g. display disables
via the desktop environment). The drm_dev_enter() call would not
cause an early return in those and subsequently oops on
dereferencing crtc:

BUG: kernel NULL pointer dereference, address: 00000000000005c8
CPU: 6 UID: 1000 PID: 3473 Comm: kwin_wayland Not tainted 6.18.2-200.vanilla.gud.fc42.x86_64 #1 PREEMPT(lazy)
RIP: 0010:gud_plane_atomic_update+0x148/0x470 [gud]
 <TASK>
 drm_atomic_helper_commit_planes+0x28e/0x310
 drm_atomic_helper_commit_tail+0x2a/0x70
 commit_tail+0xf1/0x150
 drm_atomic_helper_commit+0x13c/0x180
 drm_atomic_commit+0xb1/0xe0
info ? __pfx___drm_printfn_info+0x10/0x10
 drm_mode_atomic_ioctl+0x70f/0x7c0
 ? __pfx_drm_mode_atomic_ioctl+0x10/0x10
 drm_ioctl_kernel+0xae/0x100
 drm_ioctl+0x2a8/0x550
 ? __pfx_drm_mode_atomic_ioctl+0x10/0x10
 __x64_sys_ioctl+0x97/0xe0
 do_syscall_64+0x7e/0x7f0
 ? __ct_user_enter+0x56/0xd0
 ? do_syscall_64+0x158/0x7f0
 ? __ct_user_enter+0x56/0xd0
 ? do_syscall_64+0x158/0x7f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Split out crtc handling from gud_plane_atomic_update() into
atomic_enable() and atomic_disable() functions to delegate
crtc state transitioning work to the DRM helpers.

To preserve the gud state commit sequence [2], switch to
the runtime PM version of drm_atomic_helper_commit_tail() which
ensures that crtcs are enabled (hence sending the
GUD_REQ_SET_CONTROLLER_ENABLE and GUD_REQ_SET_DISPLAY_ENABLE
requests) before a framebuffer update is sent.

[1] https://lore.kernel.org/all/20251231055039.44266-1-me@shenghaoyang.info/
[2] https://github.com/notro/gud/wiki/GUD-Protocol#display-state

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202601142159.0v8ilfVs-lkp@intel.com/
Fixes: 73cfd166e045 ("drm/gud: Replace simple display pipe with DRM atomic helpers")
Cc: <stable@vger.kernel.org> # 6.19.x
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Shenghao Yang <me@shenghaoyang.info>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Ruben Wauters <rubenru09@aol.com>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260222054551.80864-1-me@shenghaoyang.info
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_drv.c      |    9 +++++-
 drivers/gpu/drm/gud/gud_internal.h |    4 ++
 drivers/gpu/drm/gud/gud_pipe.c     |   54 ++++++++++++++++++++++++-------------
 3 files changed, 48 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/gud/gud_drv.c
+++ b/drivers/gpu/drm/gud/gud_drv.c
@@ -339,7 +339,9 @@ static int gud_stats_debugfs(struct seq_
 }
 
 static const struct drm_crtc_helper_funcs gud_crtc_helper_funcs = {
-	.atomic_check = drm_crtc_helper_atomic_check
+	.atomic_check = drm_crtc_helper_atomic_check,
+	.atomic_enable = gud_crtc_atomic_enable,
+	.atomic_disable = gud_crtc_atomic_disable,
 };
 
 static const struct drm_crtc_funcs gud_crtc_funcs = {
@@ -364,6 +366,10 @@ static const struct drm_plane_funcs gud_
 	DRM_GEM_SHADOW_PLANE_FUNCS,
 };
 
+static const struct drm_mode_config_helper_funcs gud_mode_config_helpers = {
+	.atomic_commit_tail = drm_atomic_helper_commit_tail_rpm,
+};
+
 static const struct drm_mode_config_funcs gud_mode_config_funcs = {
 	.fb_create = drm_gem_fb_create_with_dirty,
 	.atomic_check = drm_atomic_helper_check,
@@ -499,6 +505,7 @@ static int gud_probe(struct usb_interfac
 	drm->mode_config.min_height = le32_to_cpu(desc.min_height);
 	drm->mode_config.max_height = le32_to_cpu(desc.max_height);
 	drm->mode_config.funcs = &gud_mode_config_funcs;
+	drm->mode_config.helper_private = &gud_mode_config_helpers;
 
 	/* Format init */
 	formats_dev = devm_kmalloc(dev, GUD_FORMATS_MAX_NUM, GFP_KERNEL);
--- a/drivers/gpu/drm/gud/gud_internal.h
+++ b/drivers/gpu/drm/gud/gud_internal.h
@@ -62,6 +62,10 @@ int gud_usb_set_u8(struct gud_device *gd
 
 void gud_clear_damage(struct gud_device *gdrm);
 void gud_flush_work(struct work_struct *work);
+void gud_crtc_atomic_enable(struct drm_crtc *crtc,
+			    struct drm_atomic_state *state);
+void gud_crtc_atomic_disable(struct drm_crtc *crtc,
+			     struct drm_atomic_state *state);
 int gud_plane_atomic_check(struct drm_plane *plane,
 			   struct drm_atomic_state *state);
 void gud_plane_atomic_update(struct drm_plane *plane,
--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -580,6 +580,39 @@ out:
 	return ret;
 }
 
+void gud_crtc_atomic_enable(struct drm_crtc *crtc,
+			    struct drm_atomic_state *state)
+{
+	struct drm_device *drm = crtc->dev;
+	struct gud_device *gdrm = to_gud_device(drm);
+	int idx;
+
+	if (!drm_dev_enter(drm, &idx))
+		return;
+
+	gud_usb_set_u8(gdrm, GUD_REQ_SET_CONTROLLER_ENABLE, 1);
+	gud_usb_set(gdrm, GUD_REQ_SET_STATE_COMMIT, 0, NULL, 0);
+	gud_usb_set_u8(gdrm, GUD_REQ_SET_DISPLAY_ENABLE, 1);
+
+	drm_dev_exit(idx);
+}
+
+void gud_crtc_atomic_disable(struct drm_crtc *crtc,
+			     struct drm_atomic_state *state)
+{
+	struct drm_device *drm = crtc->dev;
+	struct gud_device *gdrm = to_gud_device(drm);
+	int idx;
+
+	if (!drm_dev_enter(drm, &idx))
+		return;
+
+	gud_usb_set_u8(gdrm, GUD_REQ_SET_DISPLAY_ENABLE, 0);
+	gud_usb_set_u8(gdrm, GUD_REQ_SET_CONTROLLER_ENABLE, 0);
+
+	drm_dev_exit(idx);
+}
+
 void gud_plane_atomic_update(struct drm_plane *plane,
 			     struct drm_atomic_state *atomic_state)
 {
@@ -607,24 +640,12 @@ void gud_plane_atomic_update(struct drm_
 		mutex_unlock(&gdrm->damage_lock);
 	}
 
-	if (!drm_dev_enter(drm, &idx))
+	if (!crtc || !drm_dev_enter(drm, &idx))
 		return;
 
-	if (!old_state->fb)
-		gud_usb_set_u8(gdrm, GUD_REQ_SET_CONTROLLER_ENABLE, 1);
-
-	if (fb && (crtc->state->mode_changed || crtc->state->connectors_changed))
-		gud_usb_set(gdrm, GUD_REQ_SET_STATE_COMMIT, 0, NULL, 0);
-
-	if (crtc->state->active_changed)
-		gud_usb_set_u8(gdrm, GUD_REQ_SET_DISPLAY_ENABLE, crtc->state->active);
-
-	if (!fb)
-		goto ctrl_disable;
-
 	ret = drm_gem_fb_begin_cpu_access(fb, DMA_FROM_DEVICE);
 	if (ret)
-		goto ctrl_disable;
+		goto out;
 
 	drm_atomic_helper_damage_iter_init(&iter, old_state, new_state);
 	drm_atomic_for_each_plane_damage(&iter, &damage)
@@ -632,9 +653,6 @@ void gud_plane_atomic_update(struct drm_
 
 	drm_gem_fb_end_cpu_access(fb, DMA_FROM_DEVICE);
 
-ctrl_disable:
-	if (!crtc->state->enable)
-		gud_usb_set_u8(gdrm, GUD_REQ_SET_CONTROLLER_ENABLE, 0);
-
+out:
 	drm_dev_exit(idx);
 }


