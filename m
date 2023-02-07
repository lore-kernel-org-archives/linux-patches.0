Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFAB2F39
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208B8C433D2;
	Tue,  7 Feb 2023 13:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775501;
	bh=sbc51eWCfVAvYT4r4aykzlAu8vyQR8aAxQQxGtTtmuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrG+izwtpsefRhcj1xsXWVdxi27CaAyP/VR7359q3rwDmWxAc7zN3nYUqXpkQqehM
	 UD7IwLr7c5ih3KThY16qQiinjZxeI0IYBL1paEbbkgu67PJ1DJRWU+V9QCQTycm5Ho
	 tiT4wp6K2ADLdpTvMOUlOdtHmnshIYNkGnh0s7LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Alan Liu <HaoPing.Liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/120] drm/amd/display: Fix timing not changning when freesync video is enabled
Date: Tue,  7 Feb 2023 13:57:12 +0100
Message-Id: <20230207125621.362367506@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 4b069553246f993c4221e382d0d0ae34f5ba730e ]

[Why&How]
Switching between certain modes that are freesync video modes and those
are not freesync video modes result in timing not changing as seen by
the monitor due to incorrect timing being driven.

The issue is fixed by ensuring that when a non freesync video mode is
set, we reset the freesync status on the crtc.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a2d9e0af0654..e9797439bb0e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10136,6 +10136,13 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 		if (!dm_old_crtc_state->stream)
 			goto skip_modeset;
 
+		/* Unset freesync video if it was active before */
+		if (dm_old_crtc_state->freesync_config.state == VRR_STATE_ACTIVE_FIXED) {
+			dm_new_crtc_state->freesync_config.state = VRR_STATE_INACTIVE;
+			dm_new_crtc_state->freesync_config.fixed_refresh_in_uhz = 0;
+		}
+
+		/* Now check if we should set freesync video mode */
 		if (amdgpu_freesync_vid_mode && dm_new_crtc_state->stream &&
 		    is_timing_unchanged_for_freesync(new_crtc_state,
 						     old_crtc_state)) {
-- 
2.39.0



