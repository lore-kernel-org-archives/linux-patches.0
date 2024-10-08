Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C351D54D1;
	Tue,  8 Oct 2024 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391789; cv=none; b=oKPcdnZWE8FnjDakkiQJ1Itx9UE2Y7OPwm7xjvYV32LARw3QrbA1JmRQ8GQq6cQYqJBdjy3BBu5UkAucOGXoTtB/o0PeZFszOM7IZcH7+gKEzG2ztjQ6EVOEVLe5TV7Fa10VcIRBGRJ1tnIS1o2Jlp3VNBFy/2yQkbO4VMUef9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391789; c=relaxed/simple;
	bh=Uw4d390+iAt4qhyXRzMaQzFhAECru512aKxyOcT0KZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ta6IHwLDxGthXj/0Ne9HHq2VjumhSrnn35f8g4agVHtgCxwP7B7QuS5UcI7N8S0b11HRF8R9OFDrqmVTT+YWZByfbMPyctTWapeFOXaGab1G7K8nDfM6yPFrbvu/gVb0ixQUcJmXKekng1ujMBNt3WO5BcB9WBWQlPuTTnsJwmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msFGaNDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msFGaNDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC32C4CEC7;
	Tue,  8 Oct 2024 12:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391788;
	bh=Uw4d390+iAt4qhyXRzMaQzFhAECru512aKxyOcT0KZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msFGaNDy0U3pcKdQpyZv/jDrsO6t1n5hgp+wokzBOAK9VmJUi8EYV3O88bHM2pDpO
	 tZd5PgFnQ6+ssFZ/vAzjoq0VAgCwNikRt0r9LMJufvtXoyuP1B1MRolQIFWxCG+3Ts
	 VKKZWifcSXisXYbLaq5OFlBZ7UoHzhgvcnf6T228=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Sa <Daniel.Sa@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 223/558] drm/amd/display: Underflow Seen on DCN401 eGPU
Date: Tue,  8 Oct 2024 14:04:13 +0200
Message-ID: <20241008115711.118074377@linuxfoundation.org>
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

From: Daniel Sa <Daniel.Sa@amd.com>

[ Upstream commit ca0fb243c3bb53dbbd71d16c76f319bf923ee3d4 ]

[WHY]
In dcn401 we read clock values before FW is loaded. These incorrect
values cause the driver to believe that we are running higher clocks
than what we actually have. This then causes corruption/underflow for
the eGPU.

[HOW]
When new values are read from HW, update internal structures to
propagate the new/correct value. Fixes issue

Signed-off-by: Daniel Sa <Daniel.Sa@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 324e77ceaf1cf..537a24ec74c85 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -221,6 +221,7 @@ void dcn401_init_hw(struct dc *dc)
 	int edp_num;
 	uint32_t backlight = MAX_BACKLIGHT_LEVEL;
 	uint32_t user_level = MAX_BACKLIGHT_LEVEL;
+	int current_dchub_ref_freq = 0;
 
 	if (dc->clk_mgr && dc->clk_mgr->funcs && dc->clk_mgr->funcs->init_clocks) {
 		dc->clk_mgr->funcs->init_clocks(dc->clk_mgr);
@@ -264,6 +265,8 @@ void dcn401_init_hw(struct dc *dc)
 					dc->ctx->dc_bios->fw_info.pll_info.crystal_frequency,
 					&res_pool->ref_clocks.dccg_ref_clock_inKhz);
 
+			current_dchub_ref_freq = res_pool->ref_clocks.dchub_ref_clock_inKhz / 1000;
+
 			(res_pool->hubbub->funcs->get_dchub_ref_freq)(res_pool->hubbub,
 					res_pool->ref_clocks.dccg_ref_clock_inKhz,
 					&res_pool->ref_clocks.dchub_ref_clock_inKhz);
@@ -436,8 +439,9 @@ void dcn401_init_hw(struct dc *dc)
 		dc->caps.dmub_caps.mclk_sw = dc->ctx->dmub_srv->dmub->feature_caps.fw_assisted_mclk_switch_ver > 0;
 		dc->caps.dmub_caps.fams_ver = dc->ctx->dmub_srv->dmub->feature_caps.fw_assisted_mclk_switch_ver;
 		dc->debug.fams2_config.bits.enable &= dc->ctx->dmub_srv->dmub->feature_caps.fw_assisted_mclk_switch_ver == 2;
-		if (!dc->debug.fams2_config.bits.enable && dc->res_pool->funcs->update_bw_bounding_box) {
-			/* update bounding box if FAMS2 disabled */
+		if ((!dc->debug.fams2_config.bits.enable && dc->res_pool->funcs->update_bw_bounding_box)
+			|| res_pool->ref_clocks.dchub_ref_clock_inKhz / 1000 != current_dchub_ref_freq) {
+			/* update bounding box if FAMS2 disabled, or if dchub clk has changed */
 			if (dc->clk_mgr)
 				dc->res_pool->funcs->update_bw_bounding_box(dc,
 									    dc->clk_mgr->bw_params);
-- 
2.43.0



