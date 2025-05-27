Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2A91CEAC2;
	Tue, 27 May 2025 17:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366957; cv=none; b=Ov8BJ6mgaUn0arsb+sK6rx01O6P1SS6hi7jPRzG8NAIH0wKlc77UGVaN22xbdoISiXmdlQCuP3yiFE1bhOVxrvkSIS1OCHEmjEvJNZBvlDiSX5Tf+co4a0nbDrFeELOnX/WBMBgH1ya9fK1eWjTjiz/NqFeTwAEo+URT+n5at/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366957; c=relaxed/simple;
	bh=mwoM9/9F9Bw91w52+SqGX7+Wm2qvkrFVnm5LiyzhLrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBFZ4CbkTdDgZDsBWmOnKGH6EuMlNdqiw61KwaEOntFcAd26tlRmQ3xVA/Z9YX8etTWPa7WjU0ZQiZDMlxWl9itEdDkPY6U1znAgcO3mpiFjVJ5+N5ig+LTdRfyBydbkYB7E4lXsOE/wZhp3U/EdZ6iBTwPegdAwOx7KT7Ucc44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIYqI2OY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIYqI2OY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1AEC4CEE9;
	Tue, 27 May 2025 17:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366957;
	bh=mwoM9/9F9Bw91w52+SqGX7+Wm2qvkrFVnm5LiyzhLrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIYqI2OYBoCkThIsXR+sI1yRzMLKeKbQBuuJ9ewZ9x6RjPUPbNXiV6/bzNpMq57Zr
	 bZ5y/hakiYQ04f+ET6RwMHrWct68ceP2fQnVtR4r5IwC57ktC4UhUe512nh7TOXtOs
	 SEbr3T+ePDWkgjTXXqvAhnS0Jr6b3Lr5zPG50pJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Chen <robin.chen@amd.com>,
	Leon Huang <Leon.Huang1@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 232/783] drm/amd/display: Fix incorrect DPCD configs while Replay/PSR switch
Date: Tue, 27 May 2025 18:20:29 +0200
Message-ID: <20250527162522.573284530@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Huang <Leon.Huang1@amd.com>

[ Upstream commit 0d9cabc8f591ea1cd97c071b853b75b155c13259 ]

[Why]
When switching between PSR/Replay,
the DPCD config of previous mode is not cleared,
resulting in unexpected behavior in TCON.

[How]
Initialize the DPCD in setup function

Reviewed-by: Robin Chen <robin.chen@amd.com>
Signed-off-by: Leon Huang <Leon.Huang1@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../link/protocols/link_edp_panel_control.c   | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
index e0e3bb8653595..1e4adbc764ea6 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
@@ -675,6 +675,18 @@ bool edp_setup_psr(struct dc_link *link,
 	if (!link)
 		return false;
 
+	//Clear PSR cfg
+	memset(&psr_configuration, 0, sizeof(psr_configuration));
+	dm_helpers_dp_write_dpcd(
+		link->ctx,
+		link,
+		DP_PSR_EN_CFG,
+		&psr_configuration.raw,
+		sizeof(psr_configuration.raw));
+
+	if (link->psr_settings.psr_version == DC_PSR_VERSION_UNSUPPORTED)
+		return false;
+
 	dc = link->ctx->dc;
 	dmcu = dc->res_pool->dmcu;
 	psr = dc->res_pool->psr;
@@ -685,9 +697,6 @@ bool edp_setup_psr(struct dc_link *link,
 	if (!dc_get_edp_link_panel_inst(dc, link, &panel_inst))
 		return false;
 
-
-	memset(&psr_configuration, 0, sizeof(psr_configuration));
-
 	psr_configuration.bits.ENABLE                    = 1;
 	psr_configuration.bits.CRC_VERIFICATION          = 1;
 	psr_configuration.bits.FRAME_CAPTURE_INDICATION  =
@@ -950,6 +959,16 @@ bool edp_setup_replay(struct dc_link *link, const struct dc_stream_state *stream
 	if (!link)
 		return false;
 
+	//Clear Replay config
+	dm_helpers_dp_write_dpcd(link->ctx, link,
+		DP_SINK_PR_ENABLE_AND_CONFIGURATION,
+		(uint8_t *)&(replay_config.raw), sizeof(uint8_t));
+
+	if (!(link->replay_settings.config.replay_supported))
+		return false;
+
+	link->replay_settings.config.replay_error_status.raw = 0;
+
 	dc = link->ctx->dc;
 
 	replay = dc->res_pool->replay;
-- 
2.39.5



