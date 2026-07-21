Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78A924A078;
	Tue, 21 Jul 2026 20:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664687; cv=none; b=BSslbaV1BX4UQ93U/8R0cyvbTRbj7bG3+Z9QCOOtwoB96Sk1uPW899AZTH0+O3kgmU1Yx8A2oS44q3Nt8EHy6auYcJuqCpsJD7bFF39UulDFAzUbwKnfDGOOCvwALKABULuCe052Wgxv+2G3kqS5FUuy6HL95icOaVHFx0HZa6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664687; c=relaxed/simple;
	bh=5h3y8/1sjUjx76OD+eCb9VSpQBleAPqrlc07dwvFOEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2stKj6MzuDaX6xpzQw2NuUSgYRBR1Vr+kEJHC6MW5Q/zlPHPRJpMrEkD1BJ3O/TxjkfN0QB5Uq91QhPCIZoQcztiGBGV6VrCU0JWUFg/+q7tWtfTyTt5+ehfP35SN6mGtJTQ5Z8OMB+Q/ZTBu2YL8zWPu8npDjuGsNLFijw9AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5yJy8dV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5yJy8dV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287EF1F000E9;
	Tue, 21 Jul 2026 20:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664685;
	bh=Y4imSENeeq9XAF68yX4Uc2dP9oZLcYTECBdjnvhbCok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5yJy8dVFCIuL0sqGoP41nGiBwfOKzH40O6j8R+nUhgFWJZbtUSGgVVT5bQte7L6V
	 EuRUj/nK+fw1d/Xcdno6zFw6TQi68YPSJDnucCEHBk+SfnjwLsWjpZ7KxBULEXWlJm
	 2eSSxdm2LKYyA6aCQPnsTWGEFJFysBIacidp7fwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ron Economos <re@w6rz.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0021/1266] drm/amd: Fix set but not used warnings
Date: Tue, 21 Jul 2026 17:07:38 +0200
Message-ID: <20260721152442.261105901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 46791d147d3ab3262298478106ef2a52fc7192e2 ]

There are many set but not used warnings under drivers/gpu/drm/amd when
compiling with the latest upstream mainline GCC:

  drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c:305:18: warning: variable ‘p’ set but not used [-Wunused-but-set-variable=]
  drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h:103:26: warning: variable ‘internal_reg_offset’ set but not used [-Wunused-but-set-variable=]
  ...
  drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h:164:26: warning: variable ‘internal_reg_offset’ set but not used [-Wunused-but-set-variable=]
  ...
  drivers/gpu/drm/amd/amdgpu/../display/dc/dc_dmub_srv.c:445:13: warning: variable ‘pipe_idx’ set but not used [-Wunused-but-set-variable=]
  drivers/gpu/drm/amd/amdgpu/../display/dc/dc_dmub_srv.c:875:21: warning: variable ‘pipe_idx’ set but not used [-Wunused-but-set-variable=]

Remove the variables actually not used or add __maybe_unused attribute for
the variables actually used to fix them, compile tested only.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ron Economos <re@w6rz.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c     |  4 +---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h      |  3 ++-
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c | 11 ++++-------
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
index ea75c2b2bbb148..055aa0418a737e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
@@ -299,7 +299,6 @@ void amdgpu_gart_unbind(struct amdgpu_device *adev, uint64_t offset,
 			int pages)
 {
 	unsigned t;
-	unsigned p;
 	int i, j;
 	u64 page_base;
 	/* Starting from VEGA10, system bit must be 0 to mean invalid. */
@@ -313,8 +312,7 @@ void amdgpu_gart_unbind(struct amdgpu_device *adev, uint64_t offset,
 		return;
 
 	t = offset / AMDGPU_GPU_PAGE_SIZE;
-	p = t / AMDGPU_GPU_PAGES_IN_CPU_PAGE;
-	for (i = 0; i < pages; i++, p++) {
+	for (i = 0; i < pages; i++) {
 		page_base = adev->dummy_page_addr;
 		if (!adev->gart.ptr)
 			continue;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
index 3dc2cffdae4fca..ba45e85b23f1b7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -101,7 +101,8 @@
 
 #define SOC15_DPG_MODE_OFFSET(ip, inst_idx, reg) 						\
 	({											\
-		uint32_t internal_reg_offset, addr;						\
+		/* To avoid a -Wunused-but-set-variable warning. */				\
+		uint32_t internal_reg_offset __maybe_unused, addr;				\
 		bool video_range, video1_range, aon_range, aon1_range;				\
 												\
 		addr = (adev->reg_offset[ip##_HWIP][inst_idx][reg##_BASE_IDX] + reg);		\
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 4c5ef3ef8dbdd7..30a79dffbd37ab 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -322,7 +322,6 @@ bool dc_dmub_srv_p_state_delegate(struct dc *dc, bool should_manage_pstate, stru
 	int i = 0, k = 0;
 	int ramp_up_num_steps = 1; // TODO: Ramp is currently disabled. Reenable it.
 	uint8_t visual_confirm_enabled;
-	int pipe_idx = 0;
 
 	if (dc == NULL)
 		return false;
@@ -336,7 +335,7 @@ bool dc_dmub_srv_p_state_delegate(struct dc *dc, bool should_manage_pstate, stru
 	cmd.fw_assisted_mclk_switch.config_data.visual_confirm_enabled = visual_confirm_enabled;
 
 	if (should_manage_pstate) {
-		for (i = 0, pipe_idx = 0; i < dc->res_pool->pipe_count; i++) {
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
 			struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
 
 			if (!pipe->stream)
@@ -350,7 +349,6 @@ bool dc_dmub_srv_p_state_delegate(struct dc *dc, bool should_manage_pstate, stru
 				cmd.fw_assisted_mclk_switch.config_data.vactive_stretch_margin_us = dc->debug.fpo_vactive_margin_us;
 				break;
 			}
-			pipe_idx++;
 		}
 	}
 
@@ -714,7 +712,7 @@ void dc_dmub_setup_subvp_dmub_command(struct dc *dc,
 		bool enable)
 {
 	uint8_t cmd_pipe_index = 0;
-	uint32_t i, pipe_idx;
+	uint32_t i;
 	uint8_t subvp_count = 0;
 	union dmub_rb_cmd cmd;
 	struct pipe_ctx *subvp_pipes[2];
@@ -740,7 +738,7 @@ void dc_dmub_setup_subvp_dmub_command(struct dc *dc,
 
 	if (enable) {
 		// For each pipe that is a "main" SUBVP pipe, fill in pipe data for DMUB SUBVP cmd
-		for (i = 0, pipe_idx = 0; i < dc->res_pool->pipe_count; i++) {
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
 			struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
 
 			if (!pipe->stream)
@@ -763,7 +761,6 @@ void dc_dmub_setup_subvp_dmub_command(struct dc *dc,
 				populate_subvp_cmd_vblank_pipe_info(dc, context, &cmd, pipe, cmd_pipe_index++);
 
 			}
-			pipe_idx++;
 		}
 		if (subvp_count == 2) {
 			update_subvp_prefetch_end_to_mall_start(dc, context, &cmd, subvp_pipes);
@@ -1054,4 +1051,4 @@ void dc_dmub_srv_enable_dpia_trace(const struct dc *dc)
 	}
 
 	DC_LOG_DEBUG("Enabled DPIA trace\n");
-}
\ No newline at end of file
+}
-- 
2.53.0



