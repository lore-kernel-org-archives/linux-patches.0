Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473F613BC26;
	Thu, 12 Dec 2024 15:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016690; cv=none; b=ETtcCbgcc+w09oZjm2+JjgyO0/HORGeuEUwpHUWkPB2H4zgV9wl2cTfgPEaSvijqdXuhPzSYwUuW+wDnmq2d3+Qc9Cv2/x3b9MecqNsE6ewNgdFzLR6v4pV7tvuuuLKS5ebHktDsqwvurG8GDsTSkiq1eTb7AjaD1sIqXqMKS2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016690; c=relaxed/simple;
	bh=vcu3Tf4Z1kgBz1E8S0mUQlGoG8LX/zGHxQfMfDa+C0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BICGCLubhp7+0DsB87BpZSYh33rE/xx3HQMZnp5tC+djBIVLy4TXDyQdbE2c6vHyQLGsmlnjngskjzTLLOuS8nYOLwTd59zOU77hSmUDCY4ulKlTbK5OKeQHtuU0/Z8ndr/P5DVYib4EEVWs4GB9NNGSe0cAno75zaQOysSvjAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPmxUNy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPmxUNy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B66FC4CECE;
	Thu, 12 Dec 2024 15:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016689;
	bh=vcu3Tf4Z1kgBz1E8S0mUQlGoG8LX/zGHxQfMfDa+C0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPmxUNy3nJP/FQlyM0UD/BVDL0rOX+O66ED71ehy0r4Z5hdvueiFacSLHk8ytjVUX
	 uVPKGt9Y72UEG0cSxcE4i/280Ewm2XTV2aDgVORraY22JCRBa0T9cs8K0Qi1Vn8T7S
	 EhfAxLLLac3N5K5NFwUOdiK/LkEPQAplGOJPd2MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Zhongwei <Zhongwei.Zhang@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 271/466] drm/amd/display: Fix garbage or black screen when resetting otg
Date: Thu, 12 Dec 2024 15:57:20 +0100
Message-ID: <20241212144317.491865663@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongwei <Zhongwei.Zhang@amd.com>

[ Upstream commit ffa1e31f70d2e97c121709b44a8960f5d7becb10 ]

[Why]
For some EDP to MIPI panel, disabling OTG when link is alive like boot
case, the converter might output garbage or show no display because our
GPU is not sending required pixel data.
Alos Dig fifo underflow was found which might cause garbage, when
resetting otg for other types of EDP panels.

[How]
Skipping resetting OTG if the dig fifo is on. Make sure that the otg for
the pipe is the one that the dig fifo is selecting via the FE mask.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Zhongwei <Zhongwei.Zhang@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dio/dcn314/dcn314_dio_stream_encoder.c    | 10 ++++++++++
 .../amd/display/dc/hwss/dcn314/dcn314_hwseq.c    | 16 ++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dio/dcn314/dcn314_dio_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dio/dcn314/dcn314_dio_stream_encoder.c
index 5b343f745cf33..ae81451a3a725 100644
--- a/drivers/gpu/drm/amd/display/dc/dio/dcn314/dcn314_dio_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dio/dcn314/dcn314_dio_stream_encoder.c
@@ -83,6 +83,15 @@ void enc314_disable_fifo(struct stream_encoder *enc)
 	REG_UPDATE(DIG_FIFO_CTRL0, DIG_FIFO_ENABLE, 0);
 }
 
+static bool enc314_is_fifo_enabled(struct stream_encoder *enc)
+{
+	struct dcn10_stream_encoder *enc1 = DCN10STRENC_FROM_STRENC(enc);
+	uint32_t reset_val;
+
+	REG_GET(DIG_FIFO_CTRL0, DIG_FIFO_ENABLE, &reset_val);
+	return (reset_val != 0);
+}
+
 void enc314_dp_set_odm_combine(
 	struct stream_encoder *enc,
 	bool odm_combine)
@@ -468,6 +477,7 @@ static const struct stream_encoder_funcs dcn314_str_enc_funcs = {
 
 	.enable_fifo = enc314_enable_fifo,
 	.disable_fifo = enc314_disable_fifo,
+	.is_fifo_enabled = enc314_is_fifo_enabled,
 	.set_input_mode = enc314_set_dig_input_mode,
 };
 
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
index a8e04a39a19e5..efcc1a6b364c2 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
@@ -355,6 +355,20 @@ void dcn314_calculate_pix_rate_divider(
 	}
 }
 
+static bool dcn314_is_pipe_dig_fifo_on(struct pipe_ctx *pipe)
+{
+	return pipe && pipe->stream
+		// Check dig's otg instance.
+		&& pipe->stream_res.stream_enc
+		&& pipe->stream_res.stream_enc->funcs->dig_source_otg
+		&& pipe->stream_res.tg->inst == pipe->stream_res.stream_enc->funcs->dig_source_otg(pipe->stream_res.stream_enc)
+		&& pipe->stream->link && pipe->stream->link->link_enc
+		&& pipe->stream->link->link_enc->funcs->is_dig_enabled
+		&& pipe->stream->link->link_enc->funcs->is_dig_enabled(pipe->stream->link->link_enc)
+		&& pipe->stream_res.stream_enc->funcs->is_fifo_enabled
+		&& pipe->stream_res.stream_enc->funcs->is_fifo_enabled(pipe->stream_res.stream_enc);
+}
+
 void dcn314_resync_fifo_dccg_dio(struct dce_hwseq *hws, struct dc *dc, struct dc_state *context, unsigned int current_pipe_idx)
 {
 	unsigned int i;
@@ -374,6 +388,8 @@ void dcn314_resync_fifo_dccg_dio(struct dce_hwseq *hws, struct dc *dc, struct dc
 		if (pipe->stream && (pipe->stream->dpms_off || dc_is_virtual_signal(pipe->stream->signal)) &&
 			!pipe->stream->apply_seamless_boot_optimization &&
 			!pipe->stream->apply_edp_fast_boot_optimization) {
+			if (dcn314_is_pipe_dig_fifo_on(pipe))
+				continue;
 			pipe->stream_res.tg->funcs->disable_crtc(pipe->stream_res.tg);
 			reset_sync_context_for_pipe(dc, context, i);
 			otg_disabled[i] = true;
-- 
2.43.0



