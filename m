Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5882343D63;
	Fri,  7 Aug 2026 15:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115739; cv=none; b=cx6hGkBXoTmxXknQO3XNxVOeEa9qTwjc4KSS6g8rU1B/ARTvJaF3pj2R0rQDZRrnKQo4azSGF4EEXMYpC7gEIC9yjsdzKFxr+ukAHKnwGQ9fihav84HzhH3aBP52NO8o06J67Afn7FRxX0wnQF88XMbpwddK3IMx3vdTAts/AHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115739; c=relaxed/simple;
	bh=qalD7jff2XXYLQfN1o715DVnYgnspWgLDAJ98b9+WcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pzy67oBLfxpSBacmS9fQRKPWfy439c5NzAAbsk5JwhDpakzsYXFDQZsueM4ilNKTpJsfB9IN2JpU47XVQqY7t3kwoWhtdSwQiZD55LZynnPFZTnUs10TRDm1tSFfqDP+jczuLFI++eOxXhT+XmzOj0PqgGuTJWUrV3pmfLk4Tgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vE4Mk7Lt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vE4Mk7Lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF1A1F000E9;
	Fri,  7 Aug 2026 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115738;
	bh=eZT+M6UqU+dqfrybZmcIbSZlTJUITrDxyovn0WCd49U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vE4Mk7Ltwtciqsxkeg5S5cVV4S9uPuviJh4uwwHckkXXUms02cjhqxmlWb1SJew20
	 8iT2SR/a+SEuIGmVcvp++V8f95250PMaECOT/JoJ/b4DQymuaMxq8rGnw//4SSz171
	 oE2ZyDpYAWXbqkB4rBmqIETRKudqQeIc5852P0LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.18 338/396] drm/vmwgfx: enforce cursor size limits for MOB cursors
Date: Fri,  7 Aug 2026 16:38:18 +0200
Message-ID: <20260807143431.576770768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

commit d5ed8749168ad13c0dbaa8300f68d854b6076966 upstream.

vmw_cursor_plane_atomic_check() bounds cursor width and height only
on the legacy update path; the SVGA_CAP2_CURSOR_MOB path -- the
default on modern hosts -- accepts any size.  When the requested size
exceeds SVGA_REG_CURSOR_MAX_DIMENSION or SVGA_REG_MOB_MAX_SIZE,
vmw_cursor_mob_get() returns -EINVAL and leaves vps->cursor.mob NULL.
Its return value is then discarded in vmw_cursor_plane_prepare_fb(),
so the subsequent vmw_cursor_update_mob() calls
vmw_bo_map_and_cache(NULL) and oopses inside
vmw_bo_map_and_cache_size() on the tbo.base.size load.

Reachable from any DRM master via DRM_IOCTL_MODE_CURSOR2 with a
sufficiently large width or height (e.g. cursor_max_dim + 1).

Reject oversized cursors in atomic_check for both MOB-backed cursor
update types.  The MOB byte-size limit only applies to the
SVGA_CAP2_CURSOR_MOB path (vmw_cursor_mob_size() returns 0 for
GB_ONLY); compute the required MOB size in 64-bit to avoid overflow
when very large dimensions are requested.

In prepare_fb only call vmw_cursor_mob_get()/_map() for
VMW_CURSOR_UPDATE_MOB -- the GB_ONLY path uses bo->map.virtual
directly and would otherwise be silently downgraded to NONE on hosts
without SVGA_CAP2_CURSOR_MOB (where vmw_cursor_mob_get() always
returns -EINVAL).  Degrade the update to NONE if vmw_cursor_mob_get()
or vmw_cursor_mob_map() fails so the update path does not run with a
NULL backing MOB.

Fixes: 965544150d1c ("drm/vmwgfx: Refactor cursor handling")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-10-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c |   49 ++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c
@@ -432,6 +432,7 @@ vmw_cursor_mob_map(struct vmw_plane_stat
 	u32 size = vmw_cursor_mob_size(vps->cursor.update_type,
 				       vps->base.crtc_w, vps->base.crtc_h);
 	struct vmw_bo *vbo = vps->cursor.mob;
+	void *map;
 
 	if (!vbo)
 		return -EINVAL;
@@ -446,11 +447,15 @@ vmw_cursor_mob_map(struct vmw_plane_stat
 	if (unlikely(ret != 0))
 		return -ENOMEM;
 
-	vmw_bo_map_and_cache(vbo);
+	map = vmw_bo_map_and_cache(vbo);
+	if (!map) {
+		vmw_bo_unmap(vbo);
+		ret = -ENOMEM;
+	}
 
 	ttm_bo_unreserve(&vbo->tbo);
 
-	return 0;
+	return ret;
 }
 
 /**
@@ -663,9 +668,15 @@ int vmw_cursor_plane_prepare_fb(struct d
 			    !vmw_cursor_buffer_changed(vps, old_vps)) {
 				vps->cursor.update_type =
 					VMW_CURSOR_UPDATE_NONE;
-			} else {
-				vmw_cursor_mob_get(vcp, vps);
-				vmw_cursor_mob_map(vps);
+			} else if (vps->cursor.update_type ==
+				   VMW_CURSOR_UPDATE_MOB &&
+				   (vmw_cursor_mob_get(vcp, vps) ||
+				    vmw_cursor_mob_map(vps))) {
+				/*
+				 * Reset the cursor to avoid crashes later.
+				 */
+				vps->cursor.update_type =
+					VMW_CURSOR_UPDATE_NONE;
 			}
 		}
 	}
@@ -732,6 +743,34 @@ int vmw_cursor_plane_atomic_check(struct
 				 "surface not suitable for cursor\n");
 			return -EINVAL;
 		}
+	} else if (update_type == VMW_CURSOR_UPDATE_GB_ONLY ||
+		   update_type == VMW_CURSOR_UPDATE_MOB) {
+		u32 cursor_max_dim =
+			vmw_read(vmw, SVGA_REG_CURSOR_MAX_DIMENSION);
+
+		if (new_state->crtc_w > cursor_max_dim ||
+		    new_state->crtc_h > cursor_max_dim) {
+			drm_warn(&vmw->drm,
+				 "Cursor dimensions (%d, %d) exceed device max %u\n",
+				 new_state->crtc_w, new_state->crtc_h,
+				 cursor_max_dim);
+			return -EINVAL;
+		}
+
+		if (update_type == VMW_CURSOR_UPDATE_MOB) {
+			u32 mob_max_size =
+				vmw_read(vmw, SVGA_REG_MOB_MAX_SIZE);
+			u64 mob_size = (u64)new_state->crtc_w *
+				       new_state->crtc_h * sizeof(u32) +
+				       sizeof(SVGAGBCursorHeader);
+
+			if (mob_size > mob_max_size) {
+				drm_warn(&vmw->drm,
+					 "Cursor MOB size %llu exceeds device max %u\n",
+					 mob_size, mob_max_size);
+				return -EINVAL;
+			}
+		}
 	}
 
 	return 0;


