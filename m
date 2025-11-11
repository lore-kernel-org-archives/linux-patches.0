Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B449342C8B;
	Tue, 11 Nov 2025 01:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825111; cv=none; b=fXLsRDqkgiIwWfaL396AgmS441x5AcUjwEd+Rllq9segVZw+B3vH5gRva49nnRewkLaR/qNU9gthaLoDSuF13ULN3yzAkRPV8+1xXbMGJqGhKGFSvLNUqncc43owcvn6MseCkbk3sQdFrBDllomaCAY0c2oYX8n74hdkIo9K5Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825111; c=relaxed/simple;
	bh=DriF6BeU1wnPZX7YdSIf9fFXd5ulcXUzzFRvNbKHSUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBf+fo0BrT5lcFy8jqyqSb8daVD3pguKZ5Q8hJk/iv9REWBNWbTYl/aszR7MmBiMMnxFCnYAB437ZuprbCvM8ajLIuKKxdtLjafHlWgXBbUIJ6YGBrOtXf1TvklpOyiMUuWTVIxmx/hizl4kiVutufxgk6tA4DZz2gAcKmDZ+Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMr7HbOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMr7HbOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B30AC19422;
	Tue, 11 Nov 2025 01:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825110;
	bh=DriF6BeU1wnPZX7YdSIf9fFXd5ulcXUzzFRvNbKHSUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMr7HbOCdJvYmj8eN7IDR+RF2Rir6AtjSvrOx19stm0MROByUnkxhktcrIyLwlBCp
	 zhY6t4Jn4lEl3jdu8Sc1kJXRQtvK9XESNR9ST/wyS3Bt/yv7BJ6vR53i6/5WJ8vqDp
	 cixNrHcWAgM52HUdeuKtgFYWqBdwh1rMDZ5ZVF1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 622/849] drm/amd/display: Add missing post flip calls
Date: Tue, 11 Nov 2025 09:43:12 +0900
Message-ID: <20251111004551.467528440@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit 54980f3c63ed3e5cca3d251416581193c90eae76 ]

[WHY&HOW]
dc_post_update_surfaces_to_stream needs to be called after a full update
completes in order to optimize clocks and watermarks for power. Add
missing calls before idle entry is requested to ensure optimal power.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c      | 3 +--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c | 8 ++++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 57b46572fba27..d66c9609efd8d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -427,8 +427,7 @@ static inline bool update_planes_and_stream_adapter(struct dc *dc,
 	/*
 	 * Previous frame finished and HW is ready for optimization.
 	 */
-	if (update_type == UPDATE_TYPE_FAST)
-		dc_post_update_surfaces_to_stream(dc);
+	dc_post_update_surfaces_to_stream(dc);
 
 	return dc_update_planes_and_stream(dc,
 					   array_of_surface_update,
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 2047ac51f1b66..2e7ee77c010e1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -218,8 +218,10 @@ static void amdgpu_dm_idle_worker(struct work_struct *work)
 			break;
 		}
 
-		if (idle_work->enable)
+		if (idle_work->enable) {
+			dc_post_update_surfaces_to_stream(idle_work->dm->dc);
 			dc_allow_idle_optimizations(idle_work->dm->dc, true);
+		}
 		mutex_unlock(&idle_work->dm->dc_lock);
 	}
 	idle_work->dm->idle_workqueue->running = false;
@@ -273,8 +275,10 @@ static void amdgpu_dm_crtc_vblank_control_worker(struct work_struct *work)
 			vblank_work->acrtc->dm_irq_params.allow_sr_entry);
 	}
 
-	if (dm->active_vblank_irq_count == 0)
+	if (dm->active_vblank_irq_count == 0) {
+		dc_post_update_surfaces_to_stream(dm->dc);
 		dc_allow_idle_optimizations(dm->dc, true);
+	}
 
 	mutex_unlock(&dm->dc_lock);
 
-- 
2.51.0



