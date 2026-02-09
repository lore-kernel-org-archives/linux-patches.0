Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9DE23B604;
	Mon,  9 Feb 2026 14:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647480; cv=none; b=JsxIs5ZjCy09bkaDXEx9PQUZ0vaKvuDXzzB9DOvrUhdqKcwZZiQqwq0RZCXE+H9Vc95H/qj9i1dtR4tquIMr9n3HmbW7LlDyknAd5I+9cqbpjzLoSWR/dGcmr5bjsqHJT7xLNMHmTliPZYPzOyYNKEcCF6tQG47z1xayjL2tfds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647480; c=relaxed/simple;
	bh=EZJJf7r5XVRdQmY7XJ+Pml4i7SVQ6yqCHNTpiWzTlHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7kpgIofXNiy1GPuTjAWH2JIFZS78ItAhDXfOO3geTvi7/1X+WycMc9BgXKxfVXWdi1ksRnBey695vYZHfcefW9rGmKNcpJK6r40d1Xocg9uHp5+ckHj1GmKIOJPfxFLrU2U22XHuNMfAt3lrYapCDLQW8IwKzb9WmzvAo2t2AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqPwf1HZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqPwf1HZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37516C116C6;
	Mon,  9 Feb 2026 14:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647480;
	bh=EZJJf7r5XVRdQmY7XJ+Pml4i7SVQ6yqCHNTpiWzTlHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqPwf1HZd/8JEz4rJnEQg/QLr5+75cxOBwTR7eD74EVCjTfHJQaxsAsHNMHlVyTyc
	 fTJlz1UjjFf79cN971sGkWUKsS91dq3egAmGenvh6rgAri6ZUrBmWBFtvATxXmh2XA
	 2x4j3ISZ6AEhiUro4FxHMnuNB0x+dz2FgHxNKCfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/175] Revert "drm/amd/display: pause the workload setting in dm"
Date: Mon,  9 Feb 2026 15:23:05 +0100
Message-ID: <20260209142324.445892323@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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



