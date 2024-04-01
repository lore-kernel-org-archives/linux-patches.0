Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36D443AD6;
	Mon,  1 Apr 2024 16:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987967; cv=none; b=mbQvWx70/woJUN7nma33xtRn42+YUQLAgSIAcrzLtCwCd10OUvuSwlWJB6GLudLHtVXWaAA5626Z4D0VVxM8jEt5B7G4q41Em4SO9CdUIVaXU36u6Jy+i2H8a5fUb7nDxsYGd45UKk2gJA9UNnPCV3eEAPcT6UfpgKOapWgp5Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987967; c=relaxed/simple;
	bh=1wih+29Ej8RdF2yM5BSn/zc2GlGKrh82486hNqJs8Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dv+aBjVpuVr5ovpnc58JotrwHAz2M/LepFfY44GIGyruOgCvIFkHs6f1YhUEkbHADLyHv5J8Ev8Nddo1AB95x9gSmB9zQ0uj5/dGrM7YHZaiM7E+/1VzEe/bq5kZ+LoEuFWgHG2b8zY6PcwQDZEjnFE1qb+9iWdZ4QCgbGzSn2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGQO7oQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGQO7oQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DA7C433C7;
	Mon,  1 Apr 2024 16:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987966;
	bh=1wih+29Ej8RdF2yM5BSn/zc2GlGKrh82486hNqJs8Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGQO7oQpeXlPDt4d5AOc+VNW97cVftTd5QesA1HPZlfCCystY0Et8lPEzZ673hI81
	 SGK8rGESWQwufadkjMTeLu0wtRDc5KgdiaZZYgdb33lMfhZGhy2JLQoOZd8j3ymKfi
	 yMHjwuUdqmw7RMH/qMjS+r5UBKCFTGekYwxlZCNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 016/432] drm/vmwgfx: Fix the lifetime of the bo cursor memory
Date: Mon,  1 Apr 2024 17:40:03 +0200
Message-ID: <20240401152553.611128430@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

[ Upstream commit 9a9e8a7159ca09af9b1a300a6c8e8b6ff7501c76 ]

The cleanup can be dispatched while the atomic update is still active,
which means that the memory acquired in the atomic update needs to
not be invalidated by the cleanup. The buffer objects in vmw_plane_state
instead of using the builtin map_and_cache were trying to handle
the lifetime of the mapped memory themselves, leading to crashes.

Use the map_and_cache instead of trying to manage the lifetime of the
buffer objects held by the vmw_plane_state.

Fixes kernel oops'es in IGT's kms_cursor_legacy forked-bo.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Fixes: bb6780aa5a1d ("drm/vmwgfx: Diff cursors when using cmds")
Cc: <stable@vger.kernel.org> # v6.2+
Reviewed-by: Martin Krastev <martin.krastev@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240126200804.732454-6-zack.rusin@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 496ff2a6144c1..5681a1b42aa24 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -184,13 +184,12 @@ static u32 vmw_du_cursor_mob_size(u32 w, u32 h)
  */
 static u32 *vmw_du_cursor_plane_acquire_image(struct vmw_plane_state *vps)
 {
-	bool is_iomem;
 	if (vps->surf) {
 		if (vps->surf_mapped)
 			return vmw_bo_map_and_cache(vps->surf->res.guest_memory_bo);
 		return vps->surf->snooper.image;
 	} else if (vps->bo)
-		return ttm_kmap_obj_virtual(&vps->bo->map, &is_iomem);
+		return vmw_bo_map_and_cache(vps->bo);
 	return NULL;
 }
 
@@ -652,22 +651,12 @@ vmw_du_cursor_plane_cleanup_fb(struct drm_plane *plane,
 {
 	struct vmw_cursor_plane *vcp = vmw_plane_to_vcp(plane);
 	struct vmw_plane_state *vps = vmw_plane_state_to_vps(old_state);
-	bool is_iomem;
 
 	if (vps->surf_mapped) {
 		vmw_bo_unmap(vps->surf->res.guest_memory_bo);
 		vps->surf_mapped = false;
 	}
 
-	if (vps->bo && ttm_kmap_obj_virtual(&vps->bo->map, &is_iomem)) {
-		const int ret = ttm_bo_reserve(&vps->bo->tbo, true, false, NULL);
-
-		if (likely(ret == 0)) {
-			ttm_bo_kunmap(&vps->bo->map);
-			ttm_bo_unreserve(&vps->bo->tbo);
-		}
-	}
-
 	vmw_du_cursor_plane_unmap_cm(vps);
 	vmw_du_put_cursor_mob(vcp, vps);
 
-- 
2.43.0



