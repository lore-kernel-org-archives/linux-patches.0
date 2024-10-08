Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465EE1D26F2;
	Tue,  8 Oct 2024 12:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390083; cv=none; b=bXMuK5xtlpfZnfIR6K6glpvrJrYs/wMIeri9QYooDx27w/KTo83AcwwZNJLF9HXW6H+l1/268R2mFCOq1GyObPaOTFj5DsaUozhmaR5hUL5VqYY28nwl/igIFh2JGBeWPfCjOrLJR64F0rtzBNYStL6YysMP21Z94+wzOtnK2Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390083; c=relaxed/simple;
	bh=zOKuV6A58S0ZoIPqc71wySToAzckcGY2J1Mx8l6dp4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tU9IzSaNnufwWmNWrdQCNcAeo2ThM+uFKkVo++kJV6xleDFDswfk52OyDSMU7whC9wbV7d2C8fEis4mmM62VhIP+k2ZotYoF3y+CdjQRMz6Q2p/7LzRfSozvyX/W2cfkHs0ByNfgtzX9KMuALihOfvsURRTo89dIfrUakN9cqt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKDj1qc2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKDj1qc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAA5C4CEC7;
	Tue,  8 Oct 2024 12:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390082;
	bh=zOKuV6A58S0ZoIPqc71wySToAzckcGY2J1Mx8l6dp4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKDj1qc2Px/fTNguSsbFXoMoyHstc61zhiHB/je2yfY0EtiEVN8Ugi+Tph8My3V6Y
	 8QBuMaeDLRKHwxrwswI+gd4+RXnUIPy6x64oFO2WqjnGMmJypP+ynyxN6rxFsN+arF
	 agq5pPTEPhqXbWfee7yVW38qimoCTn4XPBWoPbTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Jun Lei <jun.lei@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 184/482] drm/amd/display: Use gpuvm_min_page_size_kbytes for DML2 surfaces
Date: Tue,  8 Oct 2024 14:04:07 +0200
Message-ID: <20241008115655.545014912@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 31663521ede2edb622ee1b397ae3ac666d6351c5 ]

[Why]
It's currently hard coded to 256 when it should be using the SOC
provided values. This can result in corruption with linear surfaces
where we prefetch more PTE than the buffer can hold.

[How]
Update the min page size correctly for the plane.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Jun Lei <jun.lei@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/dml2/dml2_translation_helper.c | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
index edff6b447680c..d5dbfb33f93dc 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -828,7 +828,9 @@ static void get_scaler_data_for_plane(const struct dc_plane_state *in, struct dc
 	memcpy(out, &temp_pipe->plane_res.scl_data, sizeof(*out));
 }
 
-static void populate_dummy_dml_plane_cfg(struct dml_plane_cfg_st *out, unsigned int location, const struct dc_stream_state *in)
+static void populate_dummy_dml_plane_cfg(struct dml_plane_cfg_st *out, unsigned int location,
+					 const struct dc_stream_state *in,
+					 const struct soc_bounding_box_st *soc)
 {
 	dml_uint_t width, height;
 
@@ -845,7 +847,7 @@ static void populate_dummy_dml_plane_cfg(struct dml_plane_cfg_st *out, unsigned
 	out->CursorBPP[location] = dml_cur_32bit;
 	out->CursorWidth[location] = 256;
 
-	out->GPUVMMinPageSizeKBytes[location] = 256;
+	out->GPUVMMinPageSizeKBytes[location] = soc->gpuvm_min_page_size_kbytes;
 
 	out->ViewportWidth[location] = width;
 	out->ViewportHeight[location] = height;
@@ -882,7 +884,9 @@ static void populate_dummy_dml_plane_cfg(struct dml_plane_cfg_st *out, unsigned
 	out->ScalerEnabled[location] = false;
 }
 
-static void populate_dml_plane_cfg_from_plane_state(struct dml_plane_cfg_st *out, unsigned int location, const struct dc_plane_state *in, struct dc_state *context)
+static void populate_dml_plane_cfg_from_plane_state(struct dml_plane_cfg_st *out, unsigned int location,
+						    const struct dc_plane_state *in, struct dc_state *context,
+						    const struct soc_bounding_box_st *soc)
 {
 	struct scaler_data *scaler_data = kzalloc(sizeof(*scaler_data), GFP_KERNEL);
 	if (!scaler_data)
@@ -893,7 +897,7 @@ static void populate_dml_plane_cfg_from_plane_state(struct dml_plane_cfg_st *out
 	out->CursorBPP[location] = dml_cur_32bit;
 	out->CursorWidth[location] = 256;
 
-	out->GPUVMMinPageSizeKBytes[location] = 256;
+	out->GPUVMMinPageSizeKBytes[location] = soc->gpuvm_min_page_size_kbytes;
 
 	out->ViewportWidth[location] = scaler_data->viewport.width;
 	out->ViewportHeight[location] = scaler_data->viewport.height;
@@ -1174,7 +1178,8 @@ void map_dc_state_into_dml_display_cfg(struct dml2_context *dml2, struct dc_stat
 			disp_cfg_plane_location = dml_dispcfg->num_surfaces++;
 
 			populate_dummy_dml_surface_cfg(&dml_dispcfg->surface, disp_cfg_plane_location, context->streams[i]);
-			populate_dummy_dml_plane_cfg(&dml_dispcfg->plane, disp_cfg_plane_location, context->streams[i]);
+			populate_dummy_dml_plane_cfg(&dml_dispcfg->plane, disp_cfg_plane_location,
+						     context->streams[i], &dml2->v20.dml_core_ctx.soc);
 
 			dml_dispcfg->plane.BlendingAndTiming[disp_cfg_plane_location] = disp_cfg_stream_location;
 
@@ -1190,7 +1195,10 @@ void map_dc_state_into_dml_display_cfg(struct dml2_context *dml2, struct dc_stat
 				ASSERT(disp_cfg_plane_location >= 0 && disp_cfg_plane_location <= __DML2_WRAPPER_MAX_STREAMS_PLANES__);
 
 				populate_dml_surface_cfg_from_plane_state(dml2->v20.dml_core_ctx.project, &dml_dispcfg->surface, disp_cfg_plane_location, context->stream_status[i].plane_states[j]);
-				populate_dml_plane_cfg_from_plane_state(&dml_dispcfg->plane, disp_cfg_plane_location, context->stream_status[i].plane_states[j], context);
+				populate_dml_plane_cfg_from_plane_state(
+					&dml_dispcfg->plane, disp_cfg_plane_location,
+					context->stream_status[i].plane_states[j], context,
+					&dml2->v20.dml_core_ctx.soc);
 
 				if (stream_mall_type == SUBVP_MAIN) {
 					dml_dispcfg->plane.UseMALLForPStateChange[disp_cfg_plane_location] = dml_use_mall_pstate_change_sub_viewport;
-- 
2.43.0



