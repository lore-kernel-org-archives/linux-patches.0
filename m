Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE473EA9A;
	Wed,  7 Aug 2024 15:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042915; cv=none; b=pDPC+vMgAnD9O8SlRzd6WSQPl2g1z9dMzM4EDZsvwLxvY1pG73DPe81KZ0rOHA+ajn2QNiA2kLlyIY6DwoifGYurJb4yiOlUPzEGM1GlHslCkj+kgPVu/1eHp4mhFNvi3+vIL8BsEmIpVCEy/+/DRgVaVcnT9+3r3Z713LC3nM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042915; c=relaxed/simple;
	bh=x3Lm5omW0jZf7Wqjoccp5XHzQMUq3xcVn89L+hodSVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nV21rLqJaU/Oth/ye2ZxhwxijQqGtCCw3KdbA9LtxdZzzEgcelSVzEtCKHDVt3fbBf2W2XvTRV3YdiEHzV6lNHMDjT5jS9k0dhtOP7fkEkxp2kiWpNsAAE3dz/iFfRCf2chTU/afmmg36vm+noOp7H7EITUfwxF6JFkiJpngmIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lY63lB8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lY63lB8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE8EC32781;
	Wed,  7 Aug 2024 15:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042915;
	bh=x3Lm5omW0jZf7Wqjoccp5XHzQMUq3xcVn89L+hodSVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lY63lB8HcuU8PygdVq7TcnUCSHl2dfYenOQL3qI3y0v0MdiSVKL1lfPaQ42K6ItE9
	 +GbfEpgsxA9gLe/T97OdxqjeawHe2aUzEtOp95vYJ0Qi8fjxlwEXgkD2Tpd+Q9sTlQ
	 Z3r03aKPhOVv8VB9sjZfMsbXj4E5vlW36vaqgTDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	dri-devel@lists.freedesktop.org,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 022/123] drm/vmwgfx: Make sure the screen surface is ref counted
Date: Wed,  7 Aug 2024 16:59:01 +0200
Message-ID: <20240807150021.538900911@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

[ Upstream commit 09f34a00272d2311f6e5d64ed8ad824ef78f7487 ]

Fix races issues in virtual crc generation by making sure the surface
the code uses for crc computation is properly ref counted.

Crc generation was trying to be too clever by allowing the surfaces
to go in and out of scope, with the hope of always having some kind
of screen present. That's not always the code, in particular during
atomic disable, so to make sure the surface, when present, is not
being actively destroyed at the same time, hold a reference to it.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Fixes: 7b0062036c3b ("drm/vmwgfx: Implement virtual crc generation")
Cc: Zack Rusin <zack.rusin@broadcom.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Reviewed-by: Martin Krastev <martin.krastev@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240722184313.181318-3-zack.rusin@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_vkms.c | 40 +++++++++++++++-------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_vkms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_vkms.c
index 7e93a45948f79..ac002048d8e5e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_vkms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_vkms.c
@@ -76,7 +76,7 @@ vmw_surface_sync(struct vmw_private *vmw,
 	return ret;
 }
 
-static int
+static void
 compute_crc(struct drm_crtc *crtc,
 	    struct vmw_surface *surf,
 	    u32 *crc)
@@ -102,8 +102,6 @@ compute_crc(struct drm_crtc *crtc,
 	}
 
 	vmw_bo_unmap(bo);
-
-	return 0;
 }
 
 static void
@@ -117,7 +115,6 @@ crc_generate_worker(struct work_struct *work)
 	u64 frame_start, frame_end;
 	u32 crc32 = 0;
 	struct vmw_surface *surf = 0;
-	int ret;
 
 	spin_lock_irq(&du->vkms.crc_state_lock);
 	crc_pending = du->vkms.crc_pending;
@@ -131,22 +128,24 @@ crc_generate_worker(struct work_struct *work)
 		return;
 
 	spin_lock_irq(&du->vkms.crc_state_lock);
-	surf = du->vkms.surface;
+	surf = vmw_surface_reference(du->vkms.surface);
 	spin_unlock_irq(&du->vkms.crc_state_lock);
 
-	if (vmw_surface_sync(vmw, surf)) {
-		drm_warn(crtc->dev, "CRC worker wasn't able to sync the crc surface!\n");
-		return;
-	}
+	if (surf) {
+		if (vmw_surface_sync(vmw, surf)) {
+			drm_warn(
+				crtc->dev,
+				"CRC worker wasn't able to sync the crc surface!\n");
+			return;
+		}
 
-	ret = compute_crc(crtc, surf, &crc32);
-	if (ret)
-		return;
+		compute_crc(crtc, surf, &crc32);
+		vmw_surface_unreference(&surf);
+	}
 
 	spin_lock_irq(&du->vkms.crc_state_lock);
 	frame_start = du->vkms.frame_start;
 	frame_end = du->vkms.frame_end;
-	crc_pending = du->vkms.crc_pending;
 	du->vkms.frame_start = 0;
 	du->vkms.frame_end = 0;
 	du->vkms.crc_pending = false;
@@ -165,7 +164,7 @@ vmw_vkms_vblank_simulate(struct hrtimer *timer)
 	struct vmw_display_unit *du = container_of(timer, struct vmw_display_unit, vkms.timer);
 	struct drm_crtc *crtc = &du->crtc;
 	struct vmw_private *vmw = vmw_priv(crtc->dev);
-	struct vmw_surface *surf = NULL;
+	bool has_surface = false;
 	u64 ret_overrun;
 	bool locked, ret;
 
@@ -180,10 +179,10 @@ vmw_vkms_vblank_simulate(struct hrtimer *timer)
 	WARN_ON(!ret);
 	if (!locked)
 		return HRTIMER_RESTART;
-	surf = du->vkms.surface;
+	has_surface = du->vkms.surface != NULL;
 	vmw_vkms_unlock(crtc);
 
-	if (du->vkms.crc_enabled && surf) {
+	if (du->vkms.crc_enabled && has_surface) {
 		u64 frame = drm_crtc_accurate_vblank_count(crtc);
 
 		spin_lock(&du->vkms.crc_state_lock);
@@ -337,6 +336,8 @@ vmw_vkms_crtc_cleanup(struct drm_crtc *crtc)
 {
 	struct vmw_display_unit *du = vmw_crtc_to_du(crtc);
 
+	if (du->vkms.surface)
+		vmw_surface_unreference(&du->vkms.surface);
 	WARN_ON(work_pending(&du->vkms.crc_generator_work));
 	hrtimer_cancel(&du->vkms.timer);
 }
@@ -498,9 +499,12 @@ vmw_vkms_set_crc_surface(struct drm_crtc *crtc,
 	struct vmw_display_unit *du = vmw_crtc_to_du(crtc);
 	struct vmw_private *vmw = vmw_priv(crtc->dev);
 
-	if (vmw->vkms_enabled) {
+	if (vmw->vkms_enabled && du->vkms.surface != surf) {
 		WARN_ON(atomic_read(&du->vkms.atomic_lock) != VMW_VKMS_LOCK_MODESET);
-		du->vkms.surface = surf;
+		if (du->vkms.surface)
+			vmw_surface_unreference(&du->vkms.surface);
+		if (surf)
+			du->vkms.surface = vmw_surface_reference(surf);
 	}
 }
 
-- 
2.43.0



