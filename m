Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA62E8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072B7C433C7;
	Sun, 16 Jul 2023 20:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540090;
	bh=/z0e6RnTQ8pO/7M5QlMCBWMHlCU2JTqhNZlH91hmfCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkDvLo2UQ/cwLU47QQuG+TArkWsfxBZwbWrlnbsDPZZKnG5d5J0PmKpKP3KZu1kgh
	 jcjoP3hxDBLurSayp5QF4Qhu6hPwyFiMO2wrToJ4kUI5ddh9TQYdGM4cZ2lgq7GEvI
	 kfHzMXclBbzrJ5Pwkyp5tZoFQmi9oQEOrnwLKrK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 240/591] drm/amd/display: Fix artifacting on eDP panels when engaging freesync video mode
Date: Sun, 16 Jul 2023 21:46:19 +0200
Message-ID: <20230716194930.077357106@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit b18f05a0666aecd5cb19c26a8305bcfa4e9d6502 ]

[Why]
When freesync video mode is enabled, switching resolution from native
mode to one of the freesync video compatible modes can trigger continous
artifacts on some eDP panels when running under KDE. The articating can be seen in the
attached bug report.

[How]
Fix this by restricting updates that require full commit by using the same checks
for stream and scaling changes in the the enable pass of dm_update_crtc_state()
along with the check for compatible timings for freesync vide mode.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2162
Fixes: da5e14909776 ("drm/amd/display: Fix hang when skipping modeset")
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 91c308cf27eb2..b854eec2787e2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8873,6 +8873,8 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 
 		/* Now check if we should set freesync video mode */
 		if (amdgpu_freesync_vid_mode && dm_new_crtc_state->stream &&
+		    dc_is_stream_unchanged(new_stream, dm_old_crtc_state->stream) &&
+		    dc_is_stream_scaling_unchanged(new_stream, dm_old_crtc_state->stream) &&
 		    is_timing_unchanged_for_freesync(new_crtc_state,
 						     old_crtc_state)) {
 			new_crtc_state->mode_changed = false;
-- 
2.39.2



