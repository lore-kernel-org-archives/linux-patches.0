Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22F4446C9;
	Tue, 20 Feb 2024 21:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464790; cv=none; b=QI0NRpnbbHYKhbqxi7Dg8D3vK8/lCXVpyNQXix9WEZHpcC+c/NqTZMqlDt8k51tBlkwtKdX9HbuBEkPM6wV2dic9/EXDVf7NhnI/62tp6XVvyq4T/GlonaGKzHG6HCgOTfhI4S1ZnPc+dL5EB5maWXtTl9G8rhNDAfK/saOHFnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464790; c=relaxed/simple;
	bh=BDN50w5vj4HVCgcF/yjLIPODWo0ILq4JLriI5nl6rHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQ2qGz1sYtTPw7gH7TdpUHOYbGqfOXfGMElj3+OjYV4Zw7vBe7ESPjWq67kJhQbKna3eKBeeLc9kgR1wqcxd08fKNQxb5uTrcFCqLzGBo8EJraOKuwk2RkuSbnBv8KSF3lP/Ui4k/3hoD9lNLTbR5Emd9XaWCd4U2odEji7tohQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXVI8+yS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXVI8+yS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1FAC433C7;
	Tue, 20 Feb 2024 21:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464789;
	bh=BDN50w5vj4HVCgcF/yjLIPODWo0ILq4JLriI5nl6rHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXVI8+yS+cFX/Nm2gLZ5ofjTsRF6XifLwG0i8mH5gRXA9VfswgpE/Eq5+O1M7Ib/+
	 gpFubZ5p1qCu0pHFXgcvUJwR9x9Qsg2Icw877tekGTddP4cEAiz9ENhauVfs1ee0P8
	 bVqGg92dVmXK5vZDSy5CEXNIqzKna0Ish7QKwVZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.7 138/309] drm/amd/display: Fix dcn35 8k30 Underflow/Corruption Issue
Date: Tue, 20 Feb 2024 21:54:57 +0100
Message-ID: <20240220205637.459670873@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <jerry.zuo@amd.com>

commit faf51b201bc42adf500945732abb6220c707d6f3 upstream.

[why]
odm calculation is missing for pipe split policy determination
and cause Underflow/Corruption issue.

[how]
Add the odm calculation.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c |   27 +++-------
 drivers/gpu/drm/amd/display/dc/inc/core_types.h               |    2 
 2 files changed, 12 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -791,35 +791,28 @@ static void populate_dml_surface_cfg_fro
 	}
 }
 
-/*TODO no support for mpc combine, need rework - should calculate scaling params based on plane+stream*/
-static struct scaler_data get_scaler_data_for_plane(const struct dc_plane_state *in, const struct dc_state *context)
+static struct scaler_data get_scaler_data_for_plane(const struct dc_plane_state *in, struct dc_state *context)
 {
 	int i;
-	struct scaler_data data = { 0 };
+	struct pipe_ctx *temp_pipe = &context->res_ctx.temp_pipe;
+
+	memset(temp_pipe, 0, sizeof(struct pipe_ctx));
 
 	for (i = 0; i < MAX_PIPES; i++)	{
 		const struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
 
 		if (pipe->plane_state == in && !pipe->prev_odm_pipe) {
-			const struct pipe_ctx *next_pipe = pipe->next_odm_pipe;
+			temp_pipe->stream = pipe->stream;
+			temp_pipe->plane_state = pipe->plane_state;
+			temp_pipe->plane_res.scl_data.taps = pipe->plane_res.scl_data.taps;
 
-			data = context->res_ctx.pipe_ctx[i].plane_res.scl_data;
-			while (next_pipe) {
-				data.h_active += next_pipe->plane_res.scl_data.h_active;
-				data.recout.width += next_pipe->plane_res.scl_data.recout.width;
-				if (in->rotation == ROTATION_ANGLE_0 || in->rotation == ROTATION_ANGLE_180) {
-					data.viewport.width += next_pipe->plane_res.scl_data.viewport.width;
-				} else {
-					data.viewport.height += next_pipe->plane_res.scl_data.viewport.height;
-				}
-				next_pipe = next_pipe->next_odm_pipe;
-			}
+			resource_build_scaling_params(temp_pipe);
 			break;
 		}
 	}
 
 	ASSERT(i < MAX_PIPES);
-	return data;
+	return temp_pipe->plane_res.scl_data;
 }
 
 static void populate_dummy_dml_plane_cfg(struct dml_plane_cfg_st *out, unsigned int location, const struct dc_stream_state *in)
@@ -864,7 +857,7 @@ static void populate_dummy_dml_plane_cfg
 	out->ScalerEnabled[location] = false;
 }
 
-static void populate_dml_plane_cfg_from_plane_state(struct dml_plane_cfg_st *out, unsigned int location, const struct dc_plane_state *in, const struct dc_state *context)
+static void populate_dml_plane_cfg_from_plane_state(struct dml_plane_cfg_st *out, unsigned int location, const struct dc_plane_state *in, struct dc_state *context)
 {
 	const struct scaler_data scaler_data = get_scaler_data_for_plane(in, context);
 
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -462,6 +462,8 @@ struct resource_context {
 	unsigned int hpo_dp_link_enc_to_link_idx[MAX_HPO_DP2_LINK_ENCODERS];
 	int hpo_dp_link_enc_ref_cnts[MAX_HPO_DP2_LINK_ENCODERS];
 	bool is_mpc_3dlut_acquired[MAX_PIPES];
+	/* solely used for build scalar data in dml2 */
+	struct pipe_ctx temp_pipe;
 };
 
 struct dce_bw_output {


