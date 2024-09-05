Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F3D1494DB;
	Thu,  5 Sep 2024 10:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530510; cv=none; b=WRVHbLwgIbHCMdGbWjN4dbJex0ob5Avu9ytIZ9dr5ZoctwawXzDim47qjtPGL/S42/re8zxrvl6i8SVqlbvwyJOUcDTovkl+rxwVzJplHnS147+o3ssMyVmik3w6bUNJdBWnU+C3nRK//qMxXrJuU2dafEelpYlo3b2SmEONNm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530510; c=relaxed/simple;
	bh=N31LHWg1X4Jt1yLs+i/KXricmNGiDSa8OTESyzvdmSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzVHCvCRgOgm8gRDbuMi3780YQN/WCvVIvpd9rQSABe6NOMc3m3UMXxxYf9HQyWyKS9qigTBK0dUkpvzioBQ0gDkBCjacQwubf7zGQTbYzREAoVwYZRlECvjKHzcLepVIxNBlmNHMNpT+pQ+VQyMcebsfsLHzEW4mBtCRNUHkdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3unKomq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3unKomq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891D6C4CEC3;
	Thu,  5 Sep 2024 10:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530509;
	bh=N31LHWg1X4Jt1yLs+i/KXricmNGiDSa8OTESyzvdmSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3unKomqaLTh9vumQmKuzG45CbqX1Tpsbgg+Mp+0YvdAE/aWLw09GpF9PUK5XceNj
	 iFtPEya1rjLrzAyCqq6IB/eXotrK2qeLNXVu4kzyR5SgXzeamA7K4G9SLlfa+NLpyg
	 /NLa6pjkNqDRqrfszx8Ud+WwuXkr5bcdQ++m3hJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/101] drm/amd/display: Spinlock before reading event
Date: Thu,  5 Sep 2024 11:41:18 +0200
Message-ID: <20240905093717.939616053@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit ae13c8a5cff92015b9a3eb7cee65ebc75859487f ]

[WHY & HOW]
A read of acrtc_attach->base.state->event was not locked so moving it
inside the spinlock.

This fixes a LOCK_EVASION issue reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 1f8f0ce45c2a..0be1a1149a3f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8055,15 +8055,13 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 				bundle->stream_update.vrr_infopacket =
 					&acrtc_state->stream->vrr_infopacket;
 		}
-	} else if (cursor_update && acrtc_state->active_planes > 0 &&
-		   acrtc_attach->base.state->event) {
-		drm_crtc_vblank_get(pcrtc);
-
+	} else if (cursor_update && acrtc_state->active_planes > 0) {
 		spin_lock_irqsave(&pcrtc->dev->event_lock, flags);
-
-		acrtc_attach->event = acrtc_attach->base.state->event;
-		acrtc_attach->base.state->event = NULL;
-
+		if (acrtc_attach->base.state->event) {
+			drm_crtc_vblank_get(pcrtc);
+			acrtc_attach->event = acrtc_attach->base.state->event;
+			acrtc_attach->base.state->event = NULL;
+		}
 		spin_unlock_irqrestore(&pcrtc->dev->event_lock, flags);
 	}
 
-- 
2.43.0



