Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFB51F427B;
	Tue, 21 Jan 2025 18:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482577; cv=none; b=bnU5iSbhG+3RhBukUmZYbSouu3BGPr4dG6ytoCCk4vQSoYHN4h0D/exGswvgFmskRZU8cQqkrJxWmc9RBBc8OV+CDsjjasKZ+tS4ke4e+/f0GROkoO8KCvg+a6w1JjUZ23Ps5cCzfDGqE4xk0P5cBc5RdXMnz58e1BL0M7nc/NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482577; c=relaxed/simple;
	bh=UOLplJFC3swR62M89obnrYZ7Gf4j76yaXMi4j1loCZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dw4fCICkxn9uhihTeJige1k+AeAfsFsjv0xc87a5LihGNUh3aJGXNsjUYwQG13qkWqhVBcb+lNGHr4A0VOYAADX61DMygG5EMAW58C4YEppkAHTCnqs2NviVaoUb+4bpYHzPyjyRHntsk34vDRrwWAeeH76jk7TGpwxAljUhyig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGfifD1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGfifD1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EC9C4CEDF;
	Tue, 21 Jan 2025 18:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482577;
	bh=UOLplJFC3swR62M89obnrYZ7Gf4j76yaXMi4j1loCZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGfifD1xH7hELX+hqVHFo+jHoP/cl+eRxz+3feFJ4c96ppelFOcIk8eZFVApX/bAA
	 xoxea+Ro2w+TofhrduvJDeD4xk1zr2MMu0TBLxRnGUObsHi/ayjtqYiOVOk5lmllYu
	 1OVxAU37dY+5eSC9yoGL82M03OpSg4YYDBlOIjfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 099/122] drm/amd/display: Do not elevate mem_type change to full update
Date: Tue, 21 Jan 2025 18:52:27 +0100
Message-ID: <20250121174536.847849603@linuxfoundation.org>
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

From: Leo Li <sunpeng.li@amd.com>

commit 35ca53b7b0f0ffd16c6675fd76abac9409cf83e0 upstream.

[Why]

There should not be any need to revalidate bandwidth on memory placement
change, since the fb is expected to be pinned to DCN-accessable memory
before scanout. For APU it's DRAM, and DGPU, it's VRAM. However, async
flips + memory type change needs to be rejected.

[How]

Do not set lock_and_validation_needed on mem_type change. Instead,
reject an async_flip request if the crtc's buffer(s) changed mem_type.

This may fix stuttering/corruption experienced with PSR SU and PSR1
panels, if the compositor allocates fbs in both VRAM carveout and GTT
and flips between them.

Fixes: a7c0cad0dc06 ("drm/amd/display: ensure async flips are only accepted for fast updates")
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4caacd1671b7a013ad04cd8b6398f002540bdd4d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   29 +++++++++++++++++-----
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -11370,6 +11370,25 @@ static int dm_crtc_get_cursor_mode(struc
 	return 0;
 }
 
+static bool amdgpu_dm_crtc_mem_type_changed(struct drm_device *dev,
+					    struct drm_atomic_state *state,
+					    struct drm_crtc_state *crtc_state)
+{
+	struct drm_plane *plane;
+	struct drm_plane_state *new_plane_state, *old_plane_state;
+
+	drm_for_each_plane_mask(plane, dev, crtc_state->plane_mask) {
+		new_plane_state = drm_atomic_get_plane_state(state, plane);
+		old_plane_state = drm_atomic_get_plane_state(state, plane);
+
+		if (old_plane_state->fb && new_plane_state->fb &&
+		    get_mem_type(old_plane_state->fb) != get_mem_type(new_plane_state->fb))
+			return true;
+	}
+
+	return false;
+}
+
 /**
  * amdgpu_dm_atomic_check() - Atomic check implementation for AMDgpu DM.
  *
@@ -11567,10 +11586,6 @@ static int amdgpu_dm_atomic_check(struct
 
 	/* Remove exiting planes if they are modified */
 	for_each_oldnew_plane_in_descending_zpos(state, plane, old_plane_state, new_plane_state) {
-		if (old_plane_state->fb && new_plane_state->fb &&
-		    get_mem_type(old_plane_state->fb) !=
-		    get_mem_type(new_plane_state->fb))
-			lock_and_validation_needed = true;
 
 		ret = dm_update_plane_state(dc, state, plane,
 					    old_plane_state,
@@ -11865,9 +11880,11 @@ static int amdgpu_dm_atomic_check(struct
 
 		/*
 		 * Only allow async flips for fast updates that don't change
-		 * the FB pitch, the DCC state, rotation, etc.
+		 * the FB pitch, the DCC state, rotation, mem_type, etc.
 		 */
-		if (new_crtc_state->async_flip && lock_and_validation_needed) {
+		if (new_crtc_state->async_flip &&
+		    (lock_and_validation_needed ||
+		     amdgpu_dm_crtc_mem_type_changed(dev, state, new_crtc_state))) {
 			drm_dbg_atomic(crtc->dev,
 				       "[CRTC:%d:%s] async flips are only supported for fast updates\n",
 				       crtc->base.id, crtc->name);


