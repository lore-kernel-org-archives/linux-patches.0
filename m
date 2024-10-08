Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174061DE4CC;
	Tue,  8 Oct 2024 12:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392016; cv=none; b=Gm9QdQak7h8RAIgs7xhcmKl5wCZ/Et1GeRYvoxxjiKr583JbjwYMgn44PDLknYiVAQ6nGg12Cw5CRftbm8ouGPtHTeJUBdAYr7FmNxeuZ4/ujaythEz40RYAq9y+Yia8Uv3eSL4+3l7XT1sNq9eywm0fMRHPp0/I37HO/G7CMkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392016; c=relaxed/simple;
	bh=uM5CMr1IHKmPo8knN82NJfRpBOZglU2iZqxcqYR9MUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSGpJHlQy2Q40TMmM8KnOHOKPrGzSMklSAe8TbF3Va8qeqBKemMxubzFS+06y8bQ2pL5PVzfsi6XVDR25a2OyZNHpQuFLzKKpOps0+jxtUqQd0NUrncny4Q+AWF4QUnr5jBhqnl4OtZt/JuWT0d/Eke8SwcAQ69oOqNITip765k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8MvgZr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8MvgZr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0FCC4CEC7;
	Tue,  8 Oct 2024 12:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392015;
	bh=uM5CMr1IHKmPo8knN82NJfRpBOZglU2iZqxcqYR9MUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8MvgZr7VuPCl3up2OBs3HOsYDNAyTM9cEXN3XXCvmD+w5oah+zmeXEq3uuO7rSkM
	 /yqBJX8y5wP5aZn0FZQw3QOkTV79FD1H9Igwa2DtXMM+7EN9u38DVb6rskIxoo1WWK
	 ccjEJ9hy2HW+K6SVeSSsEW+2zMfeg0w7UepKEc4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 274/558] drm/amd/display: Force enable 3DLUT DMA check for dcn401 in DML
Date: Tue,  8 Oct 2024 14:05:04 +0200
Message-ID: <20241008115713.112529964@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <dillon.varone@amd.com>

[ Upstream commit b8dc6ca028d9a39196a3a066b9ef2d4a5eca475d ]

[WHY]
Currently TR0 (trip 0) is not properly budgeting for urgent latency in
DML2.1. This results in overly aggressive prefetch schedules that are
vulnerable to request return jitter, resulting in severe underflow at
the start of the frame.

[HOW]
Forcing 3DLUT DMA check to enable causes urgent latency to be budgeted
properly into the prefetch schedule, avoiding the vulnerability.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dml2/dml21/dml21_translation_helper.c    | 6 ++++--
 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h          | 1 +
 .../drm/amd/display/dc/resource/dcn401/dcn401_resource.c    | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
index 2baaf602815ec..ef0150a258b12 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
@@ -827,6 +827,7 @@ static void populate_dml21_plane_config_from_plane_state(struct dml2_context *dm
 
 	if (plane_state->mcm_luts.lut3d_data.lut3d_src == DC_CM2_TRANSFER_FUNC_SOURCE_VIDMEM) {
 		plane->tdlut.setup_for_tdlut = true;
+
 		switch (plane_state->mcm_luts.lut3d_data.gpu_mem_params.layout) {
 		case DC_CM2_GPU_MEM_LAYOUT_3D_SWIZZLE_LINEAR_RGB:
 		case DC_CM2_GPU_MEM_LAYOUT_3D_SWIZZLE_LINEAR_BGR:
@@ -836,6 +837,7 @@ static void populate_dml21_plane_config_from_plane_state(struct dml2_context *dm
 			plane->tdlut.tdlut_addressing_mode = dml2_tdlut_simple_linear;
 			break;
 		}
+
 		switch (plane_state->mcm_luts.lut3d_data.gpu_mem_params.size) {
 		case DC_CM2_GPU_MEM_SIZE_171717:
 			plane->tdlut.tdlut_width_mode = dml2_tdlut_width_17_cube;
@@ -844,8 +846,8 @@ static void populate_dml21_plane_config_from_plane_state(struct dml2_context *dm
 			//plane->tdlut.tdlut_width_mode = dml2_tdlut_width_flatten; // dml2_tdlut_width_flatten undefined
 			break;
 		}
-	} else
-		plane->tdlut.setup_for_tdlut = false;
+	}
+	plane->tdlut.setup_for_tdlut |= dml_ctx->config.force_tdlut_enable;
 
 	plane->dynamic_meta_data.enable = false;
 	plane->dynamic_meta_data.lines_before_active_required = 0;
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
index 023325e8f6e22..0f944fcfd5a5b 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
@@ -236,6 +236,7 @@ struct dml2_configuration_options {
 
 	bool use_clock_dc_limits;
 	bool gpuvm_enable;
+	bool force_tdlut_enable;
 	struct dml2_soc_bb *bb_from_dmub;
 };
 
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn401/dcn401_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn401/dcn401_resource.c
index 3e76732ac0dca..ec676d269d33f 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn401/dcn401_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn401/dcn401_resource.c
@@ -2099,6 +2099,7 @@ static bool dcn401_resource_construct(
 	dc->dml2_options.use_native_soc_bb_construction = true;
 	dc->dml2_options.minimize_dispclk_using_odm = true;
 	dc->dml2_options.map_dc_pipes_with_callbacks = true;
+	dc->dml2_options.force_tdlut_enable = true;
 
 	resource_init_common_dml2_callbacks(dc, &dc->dml2_options);
 	dc->dml2_options.callbacks.can_support_mclk_switch_using_fw_based_vblank_stretch = &dcn30_can_support_mclk_switch_using_fw_based_vblank_stretch;
-- 
2.43.0



