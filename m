Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A3C38399A;
	Tue, 21 Jul 2026 17:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653908; cv=none; b=tgitavRVkwpA4Kc03g9peWZPNwt0z45etPNz+KHW0Op4hDMqk59ysI2wSI0xwPV2/vwX2rH163hiBZiKjVDwp18xw1KjxdP/mR3YS+TFtveN1Sy0QL1VgdrrQ/sPqKrZCO6xninurHjcOvzQpCqZZ3X38k2oQWlB8mdbbBtWqwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653908; c=relaxed/simple;
	bh=GGkGC/XURuR6+EmleLMuDTr/Eq51jzE5KbxCyNeX0eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEj+KYL4VN0l2hfgAnsCjTY15G70LzG1HBbdSs8YGwRb0Rtld3SySx61RrhOBZA+EjGQ5s0BFEHLqXkygOV398ax92VClA3cf9jeZzukgeTb8MJM9UuH4jGPxJAyM7OpARm7h/J6cGLVKkuwGdNcxyT8tgUYu3656hyKn1yPEe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aj6nHLlI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aj6nHLlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7F81F00A3E;
	Tue, 21 Jul 2026 17:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653906;
	bh=/w2hxARZZ3+F6VigPR8P/wbi9UXYjH1bjQIYYnL4IC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aj6nHLlIBX/h7IO8FhDoVewz8zSfvhe+1VO7BxOSKpU4YU8UtHpJhviSizH23/Sdp
	 TdAmliAdYW+Z4p5VyNKSbP3HTJx/qGpDGqmhcBOQhWktmBfXTLiqae+vwkoK6peKL7
	 5ChHB+gqwUJnd0WTyDI9aDbtcT/LBC41b8HFK7Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1503/2077] drm/fb-helper: Only consider active CRTCs for vblank sync
Date: Tue, 21 Jul 2026 17:19:36 +0200
Message-ID: <20260721152628.235650564@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 06c2b8d7ea2bcb014dd974fc3bc6d128d65d7477 ]

Only synchronize fbdev output to the vblank of an active CRTC. Go over
the list of CRTCs and pick the first that matches. Fixes warnings as
the one shown below

[   77.201354] WARNING: drivers/gpu/drm/drm_vblank.c:1320 at drm_crtc_wait_one_vblank+0x194/0x1cc [drm], CPU#1: kworker/1:7/1867
[   77.201354] omapdrm omapdrm.0: [drm] vblank wait timed out on crtc 0

This currently happens if the fbdev output is not on CRTC 0.

Atomic and non-atomic drivers require distinct code paths. As for other
fbdev operations, implement both and select the correct one at runtime.

Not finding an active CRTC is not a bug. Do not wait in this case, but
flush the display update as before.

v4:
- avoid possible deadlocks with locking context (Sashiko)
v3:
- drop excessive state validation (Jani)
- acquire plane and CRTC mutices (Sashiko)
v2:
- move look-up code into separate helper
- support drivers with legacy modesetting
v1:
- see https://lore.kernel.org/dri-devel/1c9e0e24-9c4a-4259-8700-cf9e5fd60ca3@suse.de/

Co-authored-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: d8c4bddcd8bcb ("drm/fb-helper: Synchronize dirty worker with vblank")
Tested-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Tested-by: H. Nikolaus Schaller <hns@goldelico.com>
Closes: https://bugs.debian.org/1138033
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20260702145021.226932-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fb_helper.c | 92 ++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 1541fc8a9ac2d3..515f699e3ecd31 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -225,16 +225,106 @@ static void drm_fb_helper_resume_worker(struct work_struct *work)
 	console_unlock();
 }
 
+static int find_crtc_index_atomic(struct drm_fb_helper *helper)
+{
+	struct drm_device *dev = helper->dev;
+	int crtc_index = -EINVAL;
+	struct drm_modeset_acquire_ctx ctx;
+	struct drm_plane *plane;
+	int ret = 0;
+
+	drm_modeset_acquire_init(&ctx, 0);
+
+retry:
+	drm_for_each_plane(plane, dev) {
+		const struct drm_plane_state *plane_state;
+
+		if (plane->type != DRM_PLANE_TYPE_PRIMARY)
+			continue;
+
+		ret = drm_modeset_lock(&plane->mutex, &ctx);
+		if (ret)
+			goto err_drm_modeset_lock;
+		plane_state = plane->state;
+
+		if (plane_state->fb == helper->fb && plane_state->crtc) {
+			struct drm_crtc *crtc = plane_state->crtc;
+
+			ret = drm_modeset_lock(&crtc->mutex, &ctx);
+			if (ret)
+				goto err_drm_modeset_lock;
+			if (crtc->state->active)
+				crtc_index = crtc->index;
+			drm_modeset_unlock(&crtc->mutex);
+		}
+		drm_modeset_unlock(&plane->mutex);
+
+		if (crtc_index >= 0)
+			break;
+	}
+
+	drm_modeset_drop_locks(&ctx);
+	drm_modeset_acquire_fini(&ctx);
+
+	return crtc_index;
+
+err_drm_modeset_lock:
+	if (ret == -EDEADLK) {
+		drm_modeset_backoff(&ctx);
+		goto retry;
+	}
+	return ret;
+}
+
+static int find_crtc_index_legacy(struct drm_fb_helper *helper)
+{
+	struct drm_device *dev = helper->dev;
+	struct drm_crtc *crtc;
+
+	drm_for_each_crtc(crtc, dev) {
+		struct drm_plane *plane = crtc->primary;
+
+		if (!crtc->enabled)
+			continue;
+		if (!plane || plane->fb != helper->fb)
+			continue; /* CRTC doesn't display fbdev emulation */
+
+		return crtc->index;
+	}
+
+	return -EINVAL;
+}
+
+static int drm_fb_helper_find_crtc_index(struct drm_fb_helper *helper)
+{
+	struct drm_device *dev = helper->dev;
+	int crtc_index;
+
+	mutex_lock(&dev->mode_config.mutex);
+
+	if (drm_drv_uses_atomic_modeset(dev))
+		crtc_index = find_crtc_index_atomic(helper);
+	else
+		crtc_index = find_crtc_index_legacy(helper);
+
+	mutex_unlock(&dev->mode_config.mutex);
+
+	return crtc_index;
+}
+
 static void drm_fb_helper_fb_dirty(struct drm_fb_helper *helper)
 {
 	struct drm_device *dev = helper->dev;
 	struct drm_clip_rect *clip = &helper->damage_clip;
 	struct drm_clip_rect clip_copy;
+	int crtc_index;
 	unsigned long flags;
 	int ret;
 
 	mutex_lock(&helper->lock);
-	drm_client_modeset_wait_for_vblank(&helper->client, 0);
+	crtc_index = drm_fb_helper_find_crtc_index(helper);
+	if (crtc_index >= 0)
+		drm_client_modeset_wait_for_vblank(&helper->client, crtc_index);
 	mutex_unlock(&helper->lock);
 
 	if (drm_WARN_ON_ONCE(dev, !helper->funcs->fb_dirty))
-- 
2.53.0



