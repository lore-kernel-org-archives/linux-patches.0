Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2568628C2C6;
	Sun,  1 Jun 2025 23:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820655; cv=none; b=pGLcaZ/+LjWd0FWeYjh1LHd6PyRmImyQ8LCClwHcgNK4q2ECDZVBapDq6hLMdfA30ZhomIrLgPuuHWwjFFRMZYDy7FXp/HG0KbkhEbWmavbMOKEJgSRaxs5Tbdlmkkuo1SeJ+Yy9Kg+K/vLZ4bY+NvwOExK2yioZOLhTvQOfgko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820655; c=relaxed/simple;
	bh=9og2VsVFLO1WyGW2P38xeU+fq8zDJRoN5UfjuKK17NI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PuCXYHxBCyhIUXmvyFa5ZgnSccFXeyYbSgQAUGSU9bOT8RsfgliBFNK6GzDHjBOrOBT9jjFJEefh0rjm847aaJowLKfnfdz8qYTZCHnIuSfUmEp3P8yswH5kxSu/hhDQJ2fIfJ9vnnd+E643R6QKbMIN6gsUeFPVS0v7tpBjO98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOTwwJb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOTwwJb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6B8C4CEF2;
	Sun,  1 Jun 2025 23:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820654;
	bh=9og2VsVFLO1WyGW2P38xeU+fq8zDJRoN5UfjuKK17NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOTwwJb2NsvIiUx/vWj8XOiV1c5j0u5ZS15OGNMN6szTUrLrtpUC5Lo4tonY+23PQ
	 eCwdjEl5RCzO/X6rsZLjMOjC3hro/qlhKEDCTx/x+4vrNpyiYVzgdySiCuwX5zxOIA
	 I967ALr62iKqmKwDCAFcGVi2T9XokPuOKuwnf5pK5cyAqGeUGJZaTxySc1EvAFZEAY
	 QrVzy0PJbL5GHJlrfk/mFNt3LEdxG68RSBE70hVxns8CNlb7Su3iBWN3f8iUDgOooa
	 mGvzwd4iojDoZFMMwnUwWcDWOW/zAmZf7Qb3cqaOIS1NjNh491YeBCIAN/3eXmWXJu
	 s8ahBsa2lpIVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	mario.limonciello@amd.com,
	Wayne.Lin@amd.com,
	dominik.kaszewski@amd.com,
	mwen@igalia.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 029/102] drm/amd/display: Add NULL pointer checks in dm_force_atomic_commit()
Date: Sun,  1 Jun 2025 19:28:21 -0400
Message-Id: <20250601232937.3510379-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 3f397cd203f247879c2f1a061e90d4c8d23655de ]

This commit updates the dm_force_atomic_commit function to replace the
usage of PTR_ERR_OR_ZERO with IS_ERR for checking error states after
retrieving the Connector (drm_atomic_get_connector_state), CRTC
(drm_atomic_get_crtc_state), and Plane (drm_atomic_get_plane_state)
states.

The function utilized PTR_ERR_OR_ZERO for error checking. However, this
approach is inappropriate in this context because the respective
functions do not return NULL; they return pointers that encode errors.

This change ensures that error pointers are properly checked using
IS_ERR before attempting to dereference.

Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis, here's my assessment: **YES** This commit should
be backported to stable kernel trees. Here's my detailed analysis: ##
Commit Analysis **1. Bug Fix Nature:** This commit fixes a clear
programming error where `PTR_ERR_OR_ZERO()` was incorrectly used to
check error pointers returned by `drm_atomic_get_connector_state()`,
`drm_atomic_get_crtc_state()`, and `drm_atomic_get_plane_state()`. The
commit message clearly states these functions "do not return NULL; they
return pointers that encode errors." **2. Specific Code Issues Fixed:**
- **Before:** Used `PTR_ERR_OR_ZERO(conn_state)` which is inappropriate
since these functions never return NULL - **After:** Uses
`IS_ERR(conn_state)` followed by `PTR_ERR(conn_state)` which is the
correct pattern for error pointer checking **3. Comparison with Similar
Commits:** Looking at the provided examples, this commit closely matches
**Similar Commit #4 (Status: YES)** which also: - Adds null pointer
checks for proper error handling - Fixes potential crashes from
dereferencing error pointers - Is a small, contained bug fix - Addresses
static analysis findings (Coverity-style issues) **4. Risk Assessment:**
- **Low Risk:** The change is minimal and only affects error handling
paths - **No Architectural Changes:** This is purely a bug fix with no
feature additions - **Contained Impact:** Only affects the
`dm_force_atomic_commit()` function in AMD display driver - **Improves
Stability:** Prevents potential kernel crashes from dereferencing error
pointers **5. Stable Tree Criteria Met:** - ✅ Fixes an important bug
(potential crash) - ✅ Small and contained change - ✅ No new features
introduced - ✅ Minimal regression risk - ✅ Clear fix for incorrect API
usage **6. Critical System Impact:** The DRM subsystem is critical for
display functionality, and improper error handling in atomic commits
could lead to: - Kernel oops/crashes during display mode changes -
System instability during hotplug events - Potential security
implications from dereferencing invalid pointers The fix ensures proper
error propagation in the display driver's atomic commit path, which is
essential for system stability.

 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 1a7bfc548d702..2cd7adea178d5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10382,16 +10382,20 @@ static int dm_force_atomic_commit(struct drm_connector *connector)
 	 */
 	conn_state = drm_atomic_get_connector_state(state, connector);
 
-	ret = PTR_ERR_OR_ZERO(conn_state);
-	if (ret)
+	/* Check for error in getting connector state */
+	if (IS_ERR(conn_state)) {
+		ret = PTR_ERR(conn_state);
 		goto out;
+	}
 
 	/* Attach crtc to drm_atomic_state*/
 	crtc_state = drm_atomic_get_crtc_state(state, &disconnected_acrtc->base);
 
-	ret = PTR_ERR_OR_ZERO(crtc_state);
-	if (ret)
+	/* Check for error in getting crtc state */
+	if (IS_ERR(crtc_state)) {
+		ret = PTR_ERR(crtc_state);
 		goto out;
+	}
 
 	/* force a restore */
 	crtc_state->mode_changed = true;
@@ -10399,9 +10403,11 @@ static int dm_force_atomic_commit(struct drm_connector *connector)
 	/* Attach plane to drm_atomic_state */
 	plane_state = drm_atomic_get_plane_state(state, plane);
 
-	ret = PTR_ERR_OR_ZERO(plane_state);
-	if (ret)
+	/* Check for error in getting plane state */
+	if (IS_ERR(plane_state)) {
+		ret = PTR_ERR(plane_state);
 		goto out;
+	}
 
 	/* Call commit internally with the state we just constructed */
 	ret = drm_atomic_commit(state);
-- 
2.39.5

