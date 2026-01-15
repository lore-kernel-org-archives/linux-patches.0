Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C693E396B7D;
	Thu, 15 Jan 2026 16:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496040; cv=none; b=ZR7BPAoH+oRKfqen6X3XapV+gx/9H05CfbX5/35Rv8wDw90vq5tip09RfyC7T1CswRkwFm070za3Roq8Trr6ahxxD8+lg/HI1Cn9+TSpm5/4hW+7E2jEeL1NxLb+4WYDXdTjY51Ytdl5X8CkcL1eqYQYJuTnTr929TsEd42l+nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496040; c=relaxed/simple;
	bh=3r7LxnwRQWQEowv/DcUq6AXoOhy0krfdZKHbvtMZesg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1QQ0zsX3mDmHkAuF80O2wbm0W1Vdd5Vbi5kubcPfomT0W0UN2sT6nFg++ljmC0Cx4XJnPFI1DXj2EseP2aMJGvSEGLbGSs2JCg0RTLXt+uIwpLs0qudRrX4BaCld1xa8BcQCUSaX+jPcSQamJrWRPWGgRcuoJSVIJGbytPmTQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeQSam9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeQSam9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44816C16AAE;
	Thu, 15 Jan 2026 16:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496040;
	bh=3r7LxnwRQWQEowv/DcUq6AXoOhy0krfdZKHbvtMZesg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GeQSam9cd3qAqX6U4W3Uk6spkvuNJIkk7KgfPRGitaX5+hpsritSB9oGl14cuJs/0
	 iSXzFGrTt0hlSEyCf+ejmEZXf+foe6gMSYowl168f9GxoJ7VKv6n2EVVEsH/pw1E9w
	 B/33ZDrEVvy2bE20sQALeY+p4wgzjW23YsGrWY+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/181] drm/amd/display: shrink struct members
Date: Thu, 15 Jan 2026 17:46:33 +0100
Message-ID: <20260115164204.350394456@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 7329417fc9ac128729c3a092b006c8f1fd0d04a6 ]

On a 32-bit ARM system, the audio_decoder struct ends up being too large
for dp_retrain_link_dp_test.

link_dp_cts.c:157:1: error: the frame size of 1328 bytes is larger than
1280 bytes [-Werror=frame-larger-than=]

This is mitigated by shrinking the members of the struct and avoids
having to deal with dynamic allocation.

feed_back_divider is assigned but otherwise unused. Remove both.

pixel_repetition looks like it should be a bool since it's only ever
assigned to 1. But there are checks for 2 and 4. Reduce to uint8_t.

Remove ss_percentage_divider. Unused.

Shrink refresh_rate as it gets assigned to at most a 3 digit integer
value.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3849efdc7888d537f09c3dcfaea4b3cd377a102e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c    |  3 ---
 drivers/gpu/drm/amd/display/include/audio_types.h    | 12 +++++-------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index ebc220b29d142..b94fec8347400 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1458,9 +1458,6 @@ void build_audio_output(
 						state->clk_mgr);
 	}
 
-	audio_output->pll_info.feed_back_divider =
-			pipe_ctx->pll_settings.feedback_divider;
-
 	audio_output->pll_info.dto_source =
 		translate_to_dto_source(
 			pipe_ctx->stream_res.tg->inst + 1);
diff --git a/drivers/gpu/drm/amd/display/include/audio_types.h b/drivers/gpu/drm/amd/display/include/audio_types.h
index e4a26143f14c9..6699ad4fa825e 100644
--- a/drivers/gpu/drm/amd/display/include/audio_types.h
+++ b/drivers/gpu/drm/amd/display/include/audio_types.h
@@ -47,15 +47,15 @@ struct audio_crtc_info {
 	uint32_t h_total;
 	uint32_t h_active;
 	uint32_t v_active;
-	uint32_t pixel_repetition;
 	uint32_t requested_pixel_clock_100Hz; /* in 100Hz */
 	uint32_t calculated_pixel_clock_100Hz; /* in 100Hz */
-	uint32_t refresh_rate;
+	uint32_t dsc_bits_per_pixel;
+	uint32_t dsc_num_slices;
 	enum dc_color_depth color_depth;
 	enum dc_pixel_encoding pixel_encoding;
+	uint16_t refresh_rate;
+	uint8_t pixel_repetition;
 	bool interlaced;
-	uint32_t dsc_bits_per_pixel;
-	uint32_t dsc_num_slices;
 };
 struct azalia_clock_info {
 	uint32_t pixel_clock_in_10khz;
@@ -78,11 +78,9 @@ enum audio_dto_source {
 
 struct audio_pll_info {
 	uint32_t audio_dto_source_clock_in_khz;
-	uint32_t feed_back_divider;
+	uint32_t ss_percentage;
 	enum audio_dto_source dto_source;
 	bool ss_enabled;
-	uint32_t ss_percentage;
-	uint32_t ss_percentage_divider;
 };
 
 struct audio_channel_associate_info {
-- 
2.51.0



