Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75463FE2D;
	Mon,  1 Apr 2024 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986559; cv=none; b=qx+jkk2OZQrgZrhMG4QfMMlsUPa9Lrt1paomguAeW0vskjb/nmf9mo7G3E9KmXwBBSWmSZPDNoyz/ytA+ylpqUo+8BPathksgERtQL8+1wuvYWx85s2kYhE3EIysrj4XSIhqvNVW6ibgOu5JZTlPGX7GXvrhzFHEmLPUEkja6jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986559; c=relaxed/simple;
	bh=Am+1TrsJCj73WfdbAjld1xzJJsP88J+vwTPkpOYJ0Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRd/USNj94Y05L5lvUSy5a4Yxp7Xypj7yEC0hJsSefDJk6Uu/CNyaOthfEpEE4euaVpT/K0sh+geLrV6n4BdnDiLdCsfNC0lvabSoO3ObPcJHmTDoMSxvKyIfMb/9Pbj5HHH1KfeXx7Z+BiLZaxsaIocZjY0TIdVecoYfrq2cOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwvlTtF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwvlTtF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E21C433C7;
	Mon,  1 Apr 2024 15:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986559;
	bh=Am+1TrsJCj73WfdbAjld1xzJJsP88J+vwTPkpOYJ0Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwvlTtF9CXQfLgG2nE5BUoKRPDfGscySCwAUWhFAajSXz26i7U67h6MLgRknxcnC3
	 IeNVUwtqzmmyvkqwLO04UVXfMDJx01F2GT4nbccQmQXrrN9D4ghacTMlx0G64OIrnV
	 S0mYX+1ofJqb7IIgjxZmM6rcKJmfPtT9Vt+uHGp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 014/399] drm/vmwgfx: Fix the lifetime of the bo cursor memory
Date: Mon,  1 Apr 2024 17:39:40 +0200
Message-ID: <20240401152549.574572409@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index c6f7946889d00..65be9e4a8992a 100644
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



