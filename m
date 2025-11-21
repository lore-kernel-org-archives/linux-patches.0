Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8096833506C;
	Fri, 21 Nov 2025 13:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731133; cv=none; b=Yi6cFhESov/rBp1oSoThTwmFT6gZHaRyBoHgYNYwQButrtX+cKOPkJU1l2H3zS0t49ELMydheuXMFIGcjJlhjJeJ4YcXR2QrvoIT9Jgp5IqxjKE0jZeEpLUBVBjLfP1pdAR4+Ekbz6AKCuzSs3nMCkMwfKQYvY0j1vaxXPsW2l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731133; c=relaxed/simple;
	bh=sJQReH/Drwb/YXb0J1EsaiBCsim5x/cmnhVLI6VBuNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsAfwsNZcwpG46yBEq94Vgk8lfzgRfoS0NqyZ+fWjXl0DoKOBO9W9iPqEbivlCwlR5dXXbk6T9sfxhen2HkEtWIjmdtYnEA5nVB7edgrPDX+Jr8w0WUufwmkeBH0etYXTmFLBI7eGqpnf/Ttrc7t0Zp3mXJnBWh9rUmte4ZsXOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkHAoVkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkHAoVkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2225C116C6;
	Fri, 21 Nov 2025 13:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731133;
	bh=sJQReH/Drwb/YXb0J1EsaiBCsim5x/cmnhVLI6VBuNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkHAoVkLSpR8csFLswmgUvyArf12YtMPz6xh5cTKsZjuzHRIkdiEgW5HL/R8HaL4h
	 90Bk2kVGyi6RPOQLAOXrnwd/at8ODas8xvz9doLa6bIBEe8Oi5ozy0IyBOJL2vCa2z
	 23lxs0jtabmK6smD9BUtkIELv/51RLMuAbg7mnJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 101/247] drm/vmwgfx: Restore Guest-Backed only cursor plane support
Date: Fri, 21 Nov 2025 14:10:48 +0100
Message-ID: <20251121130158.214343498@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit eef295a8508202e750e4f103a97447f3c9d5e3d0 ]

The referenced fixes commit broke the cursor plane for configurations
which have Guest-Backed surfaces but no cursor MOB support.

Fixes: 965544150d1c ("drm/vmwgfx: Refactor cursor handling")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/20251103201920.381503-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c | 16 +++++++++++++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.h |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c
index 718832b08d96e..c46f17ba7236d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c
@@ -100,8 +100,10 @@ vmw_cursor_update_type(struct vmw_private *vmw, struct vmw_plane_state *vps)
 	if (vmw->has_mob) {
 		if ((vmw->capabilities2 & SVGA_CAP2_CURSOR_MOB) != 0)
 			return VMW_CURSOR_UPDATE_MOB;
+		else
+			return VMW_CURSOR_UPDATE_GB_ONLY;
 	}
-
+	drm_warn_once(&vmw->drm, "Unknown Cursor Type!\n");
 	return VMW_CURSOR_UPDATE_NONE;
 }
 
@@ -139,6 +141,7 @@ static u32 vmw_cursor_mob_size(enum vmw_cursor_update_type update_type,
 {
 	switch (update_type) {
 	case VMW_CURSOR_UPDATE_LEGACY:
+	case VMW_CURSOR_UPDATE_GB_ONLY:
 	case VMW_CURSOR_UPDATE_NONE:
 		return 0;
 	case VMW_CURSOR_UPDATE_MOB:
@@ -623,6 +626,7 @@ int vmw_cursor_plane_prepare_fb(struct drm_plane *plane,
 		if (!surface || vps->cursor.legacy.id == surface->snooper.id)
 			vps->cursor.update_type = VMW_CURSOR_UPDATE_NONE;
 		break;
+	case VMW_CURSOR_UPDATE_GB_ONLY:
 	case VMW_CURSOR_UPDATE_MOB: {
 		bo = vmw_user_object_buffer(&vps->uo);
 		if (bo) {
@@ -737,6 +741,7 @@ void
 vmw_cursor_plane_atomic_update(struct drm_plane *plane,
 			       struct drm_atomic_state *state)
 {
+	struct vmw_bo *bo;
 	struct drm_plane_state *new_state =
 		drm_atomic_get_new_plane_state(state, plane);
 	struct drm_plane_state *old_state =
@@ -762,6 +767,15 @@ vmw_cursor_plane_atomic_update(struct drm_plane *plane,
 	case VMW_CURSOR_UPDATE_MOB:
 		vmw_cursor_update_mob(dev_priv, vps);
 		break;
+	case VMW_CURSOR_UPDATE_GB_ONLY:
+		bo = vmw_user_object_buffer(&vps->uo);
+		if (bo)
+			vmw_send_define_cursor_cmd(dev_priv, bo->map.virtual,
+						   vps->base.crtc_w,
+						   vps->base.crtc_h,
+						   vps->base.hotspot_x,
+						   vps->base.hotspot_y);
+		break;
 	case VMW_CURSOR_UPDATE_NONE:
 		/* do nothing */
 		break;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.h b/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.h
index 40694925a70e6..0c2cc0699b0d9 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.h
@@ -33,6 +33,7 @@ static const u32 __maybe_unused vmw_cursor_plane_formats[] = {
 enum vmw_cursor_update_type {
 	VMW_CURSOR_UPDATE_NONE = 0,
 	VMW_CURSOR_UPDATE_LEGACY,
+	VMW_CURSOR_UPDATE_GB_ONLY,
 	VMW_CURSOR_UPDATE_MOB,
 };
 
-- 
2.51.0



