Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7216F1DE3A4;
	Wed, 28 Jan 2026 22:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769639632; cv=none; b=svVbxuiZpNUD/gYsbKi2UN/jds8UU/tWdDG+awJk6PkZW2BurSzEGLDK7uiQlwEj4XrWLzMxnqCRMoRp+G76MszgqntaFZ0OjDYI+G6qhClg12lc4pfB1iOfIyLUEuhtutZgS0dKoiVUGoOjkDAsT7EJth/M0URlGTu/aBBW5II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769639632; c=relaxed/simple;
	bh=k40IEU644kLZU/sIndEn35hpFX2wp97WCMlLMkFUa0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jree1Sj/6uGJ12ink2Vk41VtBqR54Cd2ol+cvgoL4Mket5Wddoc59o/QLFLxXUb9D77qRwZirtIaueGX3gjymrt9Nm/s+7mdQasjU+LMEHXRkoESTalIo781/y808i1aVam4BqHtFNSRdHpCPjwYS3/EBGqbMC/U8mRR0Lf6AmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f69XNJQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f69XNJQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD819C4CEF1;
	Wed, 28 Jan 2026 22:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769639632;
	bh=k40IEU644kLZU/sIndEn35hpFX2wp97WCMlLMkFUa0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f69XNJQF4QUL7byJcJgxB2ckhTXVet84tginlGubIb9cWK7JpHHL9lFj2elG1KnR8
	 h5chtauDC5LQZBBGur4K/ZtGypSU+d5JflLRnvq3EAe33YfSszYKJ3v79ZaFnPD7fP
	 s1dNNxRESbnM/RXG2s42nzt67zjTm3Q6luoXxwbqmBQl0a36Xse1wlSO1xLKd9umCo
	 6sQsfdiSOv82tQTRQthFCxY7+G81s065myGdsAtrTZnOcoXyCV7iCpO4D9jfJ0Xn8l
	 BYktKkoH5ao4QTTu2eOfigdOlqeZ3JoOD6MRK9t9FFVVj9nEnByllopStiEaRUCKAv
	 k7YgNiR6zHBsw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	ivan.lipski@amd.com,
	alex.hung@amd.com,
	chiahsuan.chung@amd.com,
	mwen@igalia.com,
	mdaenzer@redhat.com,
	Jerry.Zuo@amd.com,
	timur.kristof@gmail.com
Subject: [PATCH AUTOSEL 6.18] Revert "drm/amd/display: pause the workload setting in dm"
Date: Wed, 28 Jan 2026 17:33:07 -0500
Message-ID: <20260128223332.2806589-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260128223332.2806589-1-sashal@kernel.org>
References: <20260128223332.2806589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.7
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit f377ea0561c9576cdb7e3890bcf6b8168d455464 ]

This reverts commit bc6d54ac7e7436721a19443265f971f890c13cc5.

The workload profile needs to be in the default state when
the dc idle optimizaion state is entered.  However, when
jobs come in for video or GFX or compute, the profile may
be set to a non-default profile resulting in the dc idle
optimizations not taking affect and resulting in higher
power usage.  As such we need to pause the workload profile
changes during this transition.  When this patch was originally
committed, it caused a regression with a Dell U3224KB display,
but no other problems were reported at the time.  When it
was reapplied (this patch) to address increased power usage, it
seems to have caused additional regressions.  This change seems
to have a number of side affects (audio issues, stuttering,
etc.).  I suspect the pause should only happen when all displays
are off or in static screen mode, but I think this call site
gets called more often than that which results in idle state
entry more often than intended.  For now revert.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4894
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4717
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4725
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4517
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4806
Cc: Yang Wang <kevinyang.wang@amd.com>
Cc: Kenneth Feng <kenneth.feng@amd.com>
Cc: Roman Li <Roman.Li@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1412482b714358ffa30d38fd3dd0b05795163648)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me analyze this commit for
backporting.

## Analysis Summary

### 1. COMMIT MESSAGE ANALYSIS
- This is a **revert commit** that undoes a problematic patch
- The commit message is detailed and explains the technical reasoning
- **Five bug reports** are closed by this revert (issues #4894, #4717,
  #4725, #4517, #4806)
- The message acknowledges the original intent was good (power savings
  during idle) but the implementation causes regressions
- Symptoms include: audio issues, stuttering, display corruption (Dell
  U3224KB)
- Cherry-picked from mainline commit
  `1412482b714358ffa30d38fd3dd0b05795163648`
- **Has Reviewed-by tag**: Yang Wang reviewed this

### 2. CODE CHANGE ANALYSIS
The revert removes 11 lines of code that:
- Added calls to `amdgpu_dpm_pause_power_profile(adev, true/false)`
  around `dc_allow_idle_optimizations()`
- These calls were meant to pause power profile changes during idle
  optimization entry
- The problem: The call site `amdgpu_dm_crtc_vblank_control_worker` gets
  called more frequently than intended (not just when displays are
  off/static screen)
- This causes idle state entry to happen too often, leading to various
  side effects

The diff is simple and surgical:
- **Only removes code**: No new code added
- **Removes 2 variable declarations** (`adev`, `r`)
- **Removes 9 lines of power profile pause/resume logic**
- Single file changed, clean and contained

### 3. CLASSIFICATION
- **This is a regression fix** - it reverts code that was introduced and
  caused user-visible bugs
- The original commit `bc6d54ac7e7436721a19443265f971f890c13cc5` was
  added in March 2025
- It was reverted once in May 2025 (`988b1d2164a1c`) for Dell display
  corruption
- Then it was **re-applied** (`5d7b36d1bffce`) - and now the new
  regressions appeared
- This is a follow-up revert to fix the additional regressions

### 4. SCOPE AND RISK ASSESSMENT
- **Very small scope**: 11 lines removed in a single file
- **Low risk**: Removing problematic code reverts to previously working
  state
- **AMD GPU display driver** - affects many users with AMD graphics
  cards
- The code being removed was relatively new (March 2025) so reverting
  returns to well-tested state

### 5. USER IMPACT
- **HIGH impact** for affected users - audio issues, stuttering, and
  display corruption are severe
- The bug reports indicate real users are hitting these issues
- AMD GPU users are a significant portion of Linux desktop users
- The regressions affect usability (audio skipping, video stuttering,
  display problems)

### 6. STABILITY INDICATORS
- **Reviewed-by: Yang Wang**
- **Tested in mainline first**: Cherry-picked from mainline commit
- The revert was done by AMD's primary maintainer (Alex Deucher)
- AMD developers clearly understand the root cause and explicitly chose
  to revert

### 7. DEPENDENCY CHECK
- **No dependencies**: This is a pure revert of code that was previously
  added
- The affected code **definitely exists in 6.18.y stable** - I confirmed
  the problematic commit `5d7b36d1bffce` is in 6.18.y
- The code should also exist in 6.17.y stable based on the grep results

### 8. SPECIAL CONSIDERATIONS FOR THIS COMMIT
This is the classic case for stable backporting:
- A commit was added that seemed good but caused regressions
- The revert is small, simple, and returns the code to its previously
  working state
- Multiple bug reports confirm real users are affected
- The fix (revert) is obviously correct - it removes code that shouldn't
  have been added in its current form

The commit message even indicates the maintainer understands what a
proper fix would be ("pause should only happen when all displays are off
or in static screen mode") but correctly chose to revert first for
stability.

### CONCLUSION

This is an **excellent candidate for stable backporting**:

1. **Fixes real user-visible bugs**: Audio issues, stuttering, display
   corruption
2. **Small and surgical**: Just removes 11 lines of problematic code
3. **No risk of new regressions**: Returns to previously working state
4. **Already tested**: Cherry-picked from mainline, reviewed by AMD
   developers
5. **Multiple bug reports closed**: Shows widespread impact
6. **Code exists in stable**: The problematic code is confirmed in
   6.18.y (and likely 6.17.y)
7. **Classic revert pattern**: The safest type of stable fix

The only potential issue is ensuring the code being reverted actually
exists in the target stable tree. For 6.18.y, I confirmed it does
(commit `5d7b36d1bffce`).

**YES**

 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c    | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 38f9ea313dcbb..2e7ee77c010e1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -248,8 +248,6 @@ static void amdgpu_dm_crtc_vblank_control_worker(struct work_struct *work)
 	struct vblank_control_work *vblank_work =
 		container_of(work, struct vblank_control_work, work);
 	struct amdgpu_display_manager *dm = vblank_work->dm;
-	struct amdgpu_device *adev = drm_to_adev(dm->ddev);
-	int r;
 
 	mutex_lock(&dm->dc_lock);
 
@@ -279,16 +277,7 @@ static void amdgpu_dm_crtc_vblank_control_worker(struct work_struct *work)
 
 	if (dm->active_vblank_irq_count == 0) {
 		dc_post_update_surfaces_to_stream(dm->dc);
-
-		r = amdgpu_dpm_pause_power_profile(adev, true);
-		if (r)
-			dev_warn(adev->dev, "failed to set default power profile mode\n");
-
 		dc_allow_idle_optimizations(dm->dc, true);
-
-		r = amdgpu_dpm_pause_power_profile(adev, false);
-		if (r)
-			dev_warn(adev->dev, "failed to restore the power profile mode\n");
 	}
 
 	mutex_unlock(&dm->dc_lock);
-- 
2.51.0

