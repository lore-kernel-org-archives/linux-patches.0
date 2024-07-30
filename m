Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7382D189905;
	Tue, 30 Jul 2024 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357848; cv=none; b=hth/OCvXVizedQMgjye5Hk5HguC/29qHVGQpGVjHHrpQLDYVoFvvAGkvIdYoHy7DqUa0hGlqDkm6cMpFkCRklMyHqGXKnbwvI6OkxV6q5T9GzkdJ5f8kK052MYsJOVeOpYS3iz2ODT4BZrRpx3pLDCMo17Cvg/w013f1dBChAEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357848; c=relaxed/simple;
	bh=UHirgUxdaxF+3DOMl54AKD2U+3d0fDVjOicHHBY2osI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKHix6y//ldbTmIIeZK1u7ANKAOe9nVVpueiTLAM0YV7Yec5bi19Lntc6Jhd5dsuPTQ8bfr9PcW25WmlxoiXjwSnH1utlL/HmwuuUpKw96G3T2J+bD0C6Tro3NYXQ7r1P+jithni13BH9kHiCraFOvnvS92ZcKFvnyVj24ry1cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyntujTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyntujTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D955BC4AF0C;
	Tue, 30 Jul 2024 16:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357848;
	bh=UHirgUxdaxF+3DOMl54AKD2U+3d0fDVjOicHHBY2osI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyntujTyLZeriHDPBRaoOJeC3q2PQQMWqzjjUjJE0Y+wlWhslzOT9mkd5C+cYxz6Y
	 kEmsnyD93g0xhp5luZnDGZM0tAPXaT6Tqcak2MXwppiVmz+M8DcATrSwVM7OHTBEZ/
	 04KhJT2yZpz5L9zEpXlmMwJnFY7YQVdRjiu7Rj24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 286/809] drm/amd/display: Move struct scaler_data off stack
Date: Tue, 30 Jul 2024 17:42:42 +0200
Message-ID: <20240730151735.890911730@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit f8718c482572181ca364ffca3c27365cc83cfe9e ]

The scaler_data structure is implicitly copied onto the stack twice by
being returned from a function. This is usually a bad idea, but it
was not flagged by the compiler until a recent addition that pushed
it over the 1024 byte function stack limit:

drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml2_translation_helper.c: In function 'populate_dml_plane_cfg_from_plane_state':
drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml2_translation_helper.c:1075:1: error: the frame size of 1032 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Use an explicit kzalloc() and memcpy() instead here to keep it off the
stack.

Fixes: 00c391102abc ("drm/amd/display: Add misc DC changes for DCN401")
Fixes: 7966f319c66d ("drm/amd/display: Introduce DML2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/dml2/dml2_translation_helper.c | 56 ++++++++++---------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
index 8ecc972dbffde..edff6b447680c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -804,7 +804,7 @@ static void populate_dml_surface_cfg_from_plane_state(enum dml_project_id dml2_p
 	}
 }
 
-static struct scaler_data get_scaler_data_for_plane(const struct dc_plane_state *in, struct dc_state *context)
+static void get_scaler_data_for_plane(const struct dc_plane_state *in, struct dc_state *context, struct scaler_data *out)
 {
 	int i;
 	struct pipe_ctx *temp_pipe = &context->res_ctx.temp_pipe;
@@ -825,7 +825,7 @@ static struct scaler_data get_scaler_data_for_plane(const struct dc_plane_state
 	}
 
 	ASSERT(i < MAX_PIPES);
-	return temp_pipe->plane_res.scl_data;
+	memcpy(out, &temp_pipe->plane_res.scl_data, sizeof(*out));
 }
 
 static void populate_dummy_dml_plane_cfg(struct dml_plane_cfg_st *out, unsigned int location, const struct dc_stream_state *in)
@@ -884,27 +884,31 @@ static void populate_dummy_dml_plane_cfg(struct dml_plane_cfg_st *out, unsigned
 
 static void populate_dml_plane_cfg_from_plane_state(struct dml_plane_cfg_st *out, unsigned int location, const struct dc_plane_state *in, struct dc_state *context)
 {
-	const struct scaler_data scaler_data = get_scaler_data_for_plane(in, context);
+	struct scaler_data *scaler_data = kzalloc(sizeof(*scaler_data), GFP_KERNEL);
+	if (!scaler_data)
+		return;
+
+	get_scaler_data_for_plane(in, context, scaler_data);
 
 	out->CursorBPP[location] = dml_cur_32bit;
 	out->CursorWidth[location] = 256;
 
 	out->GPUVMMinPageSizeKBytes[location] = 256;
 
-	out->ViewportWidth[location] = scaler_data.viewport.width;
-	out->ViewportHeight[location] = scaler_data.viewport.height;
-	out->ViewportWidthChroma[location] = scaler_data.viewport_c.width;
-	out->ViewportHeightChroma[location] = scaler_data.viewport_c.height;
-	out->ViewportXStart[location] = scaler_data.viewport.x;
-	out->ViewportYStart[location] = scaler_data.viewport.y;
-	out->ViewportXStartC[location] = scaler_data.viewport_c.x;
-	out->ViewportYStartC[location] = scaler_data.viewport_c.y;
+	out->ViewportWidth[location] = scaler_data->viewport.width;
+	out->ViewportHeight[location] = scaler_data->viewport.height;
+	out->ViewportWidthChroma[location] = scaler_data->viewport_c.width;
+	out->ViewportHeightChroma[location] = scaler_data->viewport_c.height;
+	out->ViewportXStart[location] = scaler_data->viewport.x;
+	out->ViewportYStart[location] = scaler_data->viewport.y;
+	out->ViewportXStartC[location] = scaler_data->viewport_c.x;
+	out->ViewportYStartC[location] = scaler_data->viewport_c.y;
 	out->ViewportStationary[location] = false;
 
-	out->ScalerEnabled[location] = scaler_data.ratios.horz.value != dc_fixpt_one.value ||
-				scaler_data.ratios.horz_c.value != dc_fixpt_one.value ||
-				scaler_data.ratios.vert.value != dc_fixpt_one.value ||
-				scaler_data.ratios.vert_c.value != dc_fixpt_one.value;
+	out->ScalerEnabled[location] = scaler_data->ratios.horz.value != dc_fixpt_one.value ||
+				scaler_data->ratios.horz_c.value != dc_fixpt_one.value ||
+				scaler_data->ratios.vert.value != dc_fixpt_one.value ||
+				scaler_data->ratios.vert_c.value != dc_fixpt_one.value;
 
 	/* Current driver code base uses LBBitPerPixel as 57. There is a discrepancy
 	 * from the HW/DML teams about this value. Initialize LBBitPerPixel with the
@@ -920,25 +924,25 @@ static void populate_dml_plane_cfg_from_plane_state(struct dml_plane_cfg_st *out
 		out->VRatioChroma[location] = 1;
 	} else {
 		/* Follow the original dml_wrapper.c code direction to fix scaling issues */
-		out->HRatio[location] = (dml_float_t)scaler_data.ratios.horz.value / (1ULL << 32);
-		out->HRatioChroma[location] = (dml_float_t)scaler_data.ratios.horz_c.value / (1ULL << 32);
-		out->VRatio[location] = (dml_float_t)scaler_data.ratios.vert.value / (1ULL << 32);
-		out->VRatioChroma[location] = (dml_float_t)scaler_data.ratios.vert_c.value / (1ULL << 32);
+		out->HRatio[location] = (dml_float_t)scaler_data->ratios.horz.value / (1ULL << 32);
+		out->HRatioChroma[location] = (dml_float_t)scaler_data->ratios.horz_c.value / (1ULL << 32);
+		out->VRatio[location] = (dml_float_t)scaler_data->ratios.vert.value / (1ULL << 32);
+		out->VRatioChroma[location] = (dml_float_t)scaler_data->ratios.vert_c.value / (1ULL << 32);
 	}
 
-	if (!scaler_data.taps.h_taps) {
+	if (!scaler_data->taps.h_taps) {
 		out->HTaps[location] = 1;
 		out->HTapsChroma[location] = 1;
 	} else {
-		out->HTaps[location] = scaler_data.taps.h_taps;
-		out->HTapsChroma[location] = scaler_data.taps.h_taps_c;
+		out->HTaps[location] = scaler_data->taps.h_taps;
+		out->HTapsChroma[location] = scaler_data->taps.h_taps_c;
 	}
-	if (!scaler_data.taps.v_taps) {
+	if (!scaler_data->taps.v_taps) {
 		out->VTaps[location] = 1;
 		out->VTapsChroma[location] = 1;
 	} else {
-		out->VTaps[location] = scaler_data.taps.v_taps;
-		out->VTapsChroma[location] = scaler_data.taps.v_taps_c;
+		out->VTaps[location] = scaler_data->taps.v_taps;
+		out->VTapsChroma[location] = scaler_data->taps.v_taps_c;
 	}
 
 	out->SourceScan[location] = (enum dml_rotation_angle)in->rotation;
@@ -949,6 +953,8 @@ static void populate_dml_plane_cfg_from_plane_state(struct dml_plane_cfg_st *out
 	out->DynamicMetadataTransmittedBytes[location] = 0;
 
 	out->NumberOfCursors[location] = 1;
+
+	kfree(scaler_data);
 }
 
 static unsigned int map_stream_to_dml_display_cfg(const struct dml2_context *dml2,
-- 
2.43.0



