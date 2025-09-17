Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6D931A7E9;
	Wed, 17 Sep 2025 12:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113208; cv=none; b=e/ir2QydLpUb56c2cGA2EwultW8pqw8X4ZVvHM+ZODFzIWIdWJOhD98B1WBptH8Ai7yCmCRvMtR68It17Keu3/gWoX8XKN8s6n+qrzLAf3VYa8AdrWASW4XTD54fGEL1UPKHQ7Hzxgz73WR0fxA1ihidXkGqkFBebbBq+euh5Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113208; c=relaxed/simple;
	bh=1mTEV11PdbruyZdklBkadoEqaRu2ZhDOEUmYFuDVtm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+rM7Ez4tc8iAnwdydMGPjEX8j6tQSjq3VYWo9rbPMRDVC6Zi2XTPM3vVkSMNnootBUk0LYU20woUyd/4KD3q2foxXWbGLF1NQZOtsMCARLlagVQcyNgKOp29s/WgNYmog8UMxcdvWtNLQukHGSuIKfsV8JX86iPqE4Pp0DNNYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjTU9QCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjTU9QCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7A2C4CEF0;
	Wed, 17 Sep 2025 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113208;
	bh=1mTEV11PdbruyZdklBkadoEqaRu2ZhDOEUmYFuDVtm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjTU9QCWbA9CGqh1tRHxQ6JQ//Lzkv5qlIH89zm1EQOPR0R4JQKK39LMKa3M/W2ch
	 lW2E3d+wawq8h5Mw9KBEe+oYKeSDBIjKVfvHiMZsXaqjMDOzPc8axM+16oEEsMFmlx
	 YJfrnaKuNEirn5y69lJMzr6Fx3PiJLH9spVqG938=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/140] drm/amd/display: Fix error pointers in amdgpu_dm_crtc_mem_type_changed
Date: Wed, 17 Sep 2025 14:33:08 +0200
Message-ID: <20250917123344.709273108@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit da29abe71e164f10917ea6da02f5d9c192ccdeb7 ]

The function amdgpu_dm_crtc_mem_type_changed was dereferencing pointers
returned by drm_atomic_get_plane_state without checking for errors. This
could lead to undefined behavior if the function returns an error pointer.

This commit adds checks using IS_ERR to ensure that new_plane_state and
old_plane_state are valid before dereferencing them.

Fixes the below:

drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:11486 amdgpu_dm_crtc_mem_type_changed()
error: 'new_plane_state' dereferencing possible ERR_PTR()

drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c
    11475 static bool amdgpu_dm_crtc_mem_type_changed(struct drm_device *dev,
    11476                                             struct drm_atomic_state *state,
    11477                                             struct drm_crtc_state *crtc_state)
    11478 {
    11479         struct drm_plane *plane;
    11480         struct drm_plane_state *new_plane_state, *old_plane_state;
    11481
    11482         drm_for_each_plane_mask(plane, dev, crtc_state->plane_mask) {
    11483                 new_plane_state = drm_atomic_get_plane_state(state, plane);
    11484                 old_plane_state = drm_atomic_get_plane_state(state, plane);
                                            ^^^^^^^^^^^^^^^^^^^^^^^^^^ These functions can fail.

    11485
--> 11486                 if (old_plane_state->fb && new_plane_state->fb &&
    11487                     get_mem_type(old_plane_state->fb) != get_mem_type(new_plane_state->fb))
    11488                         return true;
    11489         }
    11490
    11491         return false;
    11492 }

Fixes: 4caacd1671b7 ("drm/amd/display: Do not elevate mem_type change to full update")
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 9763752cf5cde..b585c321d3454 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -11483,6 +11483,11 @@ static bool amdgpu_dm_crtc_mem_type_changed(struct drm_device *dev,
 		new_plane_state = drm_atomic_get_plane_state(state, plane);
 		old_plane_state = drm_atomic_get_plane_state(state, plane);
 
+		if (IS_ERR(new_plane_state) || IS_ERR(old_plane_state)) {
+			DRM_ERROR("Failed to get plane state for plane %s\n", plane->name);
+			return false;
+		}
+
 		if (old_plane_state->fb && new_plane_state->fb &&
 		    get_mem_type(old_plane_state->fb) != get_mem_type(new_plane_state->fb))
 			return true;
-- 
2.51.0



