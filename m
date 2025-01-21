Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827E71F7089;
	Tue, 21 Jan 2025 18:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482402; cv=none; b=DXcoQnrRyaWgTQHjlHgcTUtFb22fvSuJZ40MTBkerBhARO0OjuVYYQ8pr+SC5ZXV48+lExq/wsWUBAEHO9NNjPzI+iheGQdLgcy3RvADhCEhTwmZbTPat5uYiQBD2FiOuJhQSgscMx+yuSr+xDLt5ujPdshf5+iGNQ2DrLaaW7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482402; c=relaxed/simple;
	bh=17KwfBAAGY0Hyu4tia3ehFG8CSJ7UP58JLcCRmoXXPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSmsevGxL3H9DIzH+WryPZjX6NM1X8+RL4e2eNpo2vQkY1KgEEMkjTT6lkPn+sKOca8O/29aF/TBs01TnFDh8g+qLok1dmA533aD7+J6R/UR4CA8e8/NskenUbxbN3FGr1UXW0L4b0nXHpaZoUdLcJEiaWvj9faTk7oQzMt670E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQN7pCax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQN7pCax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC690C4CEDF;
	Tue, 21 Jan 2025 18:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482402;
	bh=17KwfBAAGY0Hyu4tia3ehFG8CSJ7UP58JLcCRmoXXPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQN7pCaxYoTNgNOFgTlRyQaWMorVJtZAFQNQaOmTysZpS0E1i36lcJRuwdzJJkV2Q
	 F594M/+Bg4XBK6gDEoXghRfD9hCIm2gyOCefQlLMGD/CGN3kHt3yPkzDa6EyzOX/Z/
	 nQaoR1unxVnjJq7pMF3KxzU+d82Uq5dRDlhIqjQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/122] drm/vmwgfx: Unreserve BO on error
Date: Tue, 21 Jan 2025 18:51:22 +0100
Message-ID: <20250121174534.301704853@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit cb343ded122e0bf41e4b2a9f89386296451be109 ]

Unlock BOs in reverse order.
Add an acquire context so that lockdep doesn't complain.

Fixes: d6667f0ddf46 ("drm/vmwgfx: Fix handling of dumb buffers")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241210195535.2074918-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 10d596cb4b402..5f99f7437ae61 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -750,6 +750,7 @@ vmw_du_cursor_plane_atomic_update(struct drm_plane *plane,
 	struct vmw_plane_state *old_vps = vmw_plane_state_to_vps(old_state);
 	struct vmw_bo *old_bo = NULL;
 	struct vmw_bo *new_bo = NULL;
+	struct ww_acquire_ctx ctx;
 	s32 hotspot_x, hotspot_y;
 	int ret;
 
@@ -769,9 +770,11 @@ vmw_du_cursor_plane_atomic_update(struct drm_plane *plane,
 	if (du->cursor_surface)
 		du->cursor_age = du->cursor_surface->snooper.age;
 
+	ww_acquire_init(&ctx, &reservation_ww_class);
+
 	if (!vmw_user_object_is_null(&old_vps->uo)) {
 		old_bo = vmw_user_object_buffer(&old_vps->uo);
-		ret = ttm_bo_reserve(&old_bo->tbo, false, false, NULL);
+		ret = ttm_bo_reserve(&old_bo->tbo, false, false, &ctx);
 		if (ret != 0)
 			return;
 	}
@@ -779,9 +782,14 @@ vmw_du_cursor_plane_atomic_update(struct drm_plane *plane,
 	if (!vmw_user_object_is_null(&vps->uo)) {
 		new_bo = vmw_user_object_buffer(&vps->uo);
 		if (old_bo != new_bo) {
-			ret = ttm_bo_reserve(&new_bo->tbo, false, false, NULL);
-			if (ret != 0)
+			ret = ttm_bo_reserve(&new_bo->tbo, false, false, &ctx);
+			if (ret != 0) {
+				if (old_bo) {
+					ttm_bo_unreserve(&old_bo->tbo);
+					ww_acquire_fini(&ctx);
+				}
 				return;
+			}
 		} else {
 			new_bo = NULL;
 		}
@@ -803,10 +811,12 @@ vmw_du_cursor_plane_atomic_update(struct drm_plane *plane,
 						hotspot_x, hotspot_y);
 	}
 
-	if (old_bo)
-		ttm_bo_unreserve(&old_bo->tbo);
 	if (new_bo)
 		ttm_bo_unreserve(&new_bo->tbo);
+	if (old_bo)
+		ttm_bo_unreserve(&old_bo->tbo);
+
+	ww_acquire_fini(&ctx);
 
 	du->cursor_x = new_state->crtc_x + du->set_gui_x;
 	du->cursor_y = new_state->crtc_y + du->set_gui_y;
-- 
2.39.5



