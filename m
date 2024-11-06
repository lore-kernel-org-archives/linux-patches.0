Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7449D1DED5C;
	Wed,  6 Nov 2024 12:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895474; cv=none; b=RQRuO0kAplHOA08q/dq/ML6q7gsDNEFE18XjL8DO10od1T92heFNzf33nd5rQ2awjNhsi+Z98bPKwwxcjh3YLozl3Lj39xWYqXxPEx/AaBbZvn8q+D94seCwbq4BV8aJ8QTW/kF+5RFC5H5fDJDGiKbe5vGzWsJYoVn09ycEm/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895474; c=relaxed/simple;
	bh=p3r2UhGLVAPBAoPHuwOvsDg6alY1U0xChfViQT5OqPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7Kyo+3GNf5OLER8lZmA7uQ6dQCcmxxQ/gyEn+hK+AAAEyr5aA2u3EQOF5NJwK7Fex20Zkhth2uFryT8F1x5SGw/aBarGZysZJDTGPpXi+Y1TYa1CHQ7COVuMJCeFjwqPw3rCcIL/rjz/gM5OYYXeL+WObyapkEiCU+i7BJLeHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dw4gelhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dw4gelhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED068C4CED2;
	Wed,  6 Nov 2024 12:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895474;
	bh=p3r2UhGLVAPBAoPHuwOvsDg6alY1U0xChfViQT5OqPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dw4gelhNu51I7bPDIWZocvl90BBju3dIXrb9/qAp+RG7/EMd8885uX1CPgMQIkJRK
	 a4/b+3MWEiCH3MOnOLJiTOl2zG4ZQ5iwcYUUyFqMdaXRKnKy+EOAaZjSoG8qZthu9E
	 wdRZmb8sg1a9dwFcO4QTrdr5LsYGjDB9rJ9lQIok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel@ffwll.ch>,
	Sean Paul <seanpaul@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 230/350] drm: Move drm_mode_setcrtc() local re-init to failure path
Date: Wed,  6 Nov 2024 13:02:38 +0100
Message-ID: <20241106120326.659697923@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Paul <seanpaul@chromium.org>

[ Upstream commit c232e9f41b136c141df9938024e521191a7b910d ]

Instead of always re-initializing the variables we need to clean up on
out, move the re-initialization into the branch that goes back to retry
label.

This is a lateral move right now, but will allow us to pull out the
modeset locking into common code. I kept this change separate to make
things easier to review.

Changes in v2:
- None

Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20181129150423.239081-2-sean@poorly.run
Stable-dep-of: b6802b61a9d0 ("drm/crtc: fix uninitialized variable use even harder")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_crtc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 22eba10af165d..82ad38ee3fea7 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -567,9 +567,9 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	struct drm_mode_crtc *crtc_req = data;
 	struct drm_crtc *crtc;
 	struct drm_plane *plane;
-	struct drm_connector **connector_set, *connector;
-	struct drm_framebuffer *fb;
-	struct drm_display_mode *mode;
+	struct drm_connector **connector_set = NULL, *connector;
+	struct drm_framebuffer *fb = NULL;
+	struct drm_display_mode *mode = NULL;
 	struct drm_mode_set set;
 	uint32_t __user *set_connectors_ptr;
 	struct drm_modeset_acquire_ctx ctx;
@@ -601,10 +601,6 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	mutex_lock(&crtc->dev->mode_config.mutex);
 	drm_modeset_acquire_init(&ctx, DRM_MODESET_ACQUIRE_INTERRUPTIBLE);
 retry:
-	connector_set = NULL;
-	fb = NULL;
-	mode = NULL;
-
 	ret = drm_modeset_lock_all_ctx(crtc->dev, &ctx);
 	if (ret)
 		goto out;
@@ -767,6 +763,12 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	}
 	kfree(connector_set);
 	drm_mode_destroy(dev, mode);
+
+	/* In case we need to retry... */
+	connector_set = NULL;
+	fb = NULL;
+	mode = NULL;
+
 	if (ret == -EDEADLK) {
 		ret = drm_modeset_backoff(&ctx);
 		if (!ret)
-- 
2.43.0



