Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4262F7467;
	Tue, 11 Nov 2025 01:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823809; cv=none; b=m4mbDnA0SMJtMdbdCOf9VoJQEsrsds66LPI23jaaQTvswcjKSd90VLhXGmXtCGRaJ2omuciozsH4uZe4OXyG7Sih3RjMZJgauTJoDJl/AfB5e4v5fRpTvFIkrNeVSYFLLNqymVpJX+3i2vUQu7N9k2rbLDmXBOofRAkyyRmj5Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823809; c=relaxed/simple;
	bh=R9I53E/MGPTGSua8N/QAJa2SByOKXx+YCybVAZQsbv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp2JyFFdvGRuQ03+5Q/Nt40TKPpO26M1GpeJLEf9UDkgIyYL5r2wNTuADjgkjcPwvHLvqaH4U/SNy4pz1S/mTZo5gZxy/IjAx35NkIWiHdnlmSKrZtkhGvZkg6mwkwzeKC2cBswjDAMisc1zR5iCaLrXHR/ZQYzpZb44CGLwpBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adXYhwOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adXYhwOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97FBC4CEF5;
	Tue, 11 Nov 2025 01:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823809;
	bh=R9I53E/MGPTGSua8N/QAJa2SByOKXx+YCybVAZQsbv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adXYhwOIT+gGwPseTVLAMQbXq70hJhcMknLO+xMUrU2R/z8ANuUtAQXu5j+syjKUO
	 0CNs3YsMF61Rx2+G+cUiacpApc/0F2Mz+gWlpfhhllAy3OJDfs6GJuhH6zfo3M8ywP
	 6IGZoMMtFv8qW6YFhj9dY0g+Bl1LgNcJVQ75pK0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Yihan Zhu <Yihan.Zhu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 376/849] drm/amd/display: wait for otg update pending latch before clock optimization
Date: Tue, 11 Nov 2025 09:39:06 +0900
Message-ID: <20251111004545.524318307@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihan Zhu <Yihan.Zhu@amd.com>

[ Upstream commit f382e2d0faad0e0d73f626dbd71f2a4fce03975b ]

[WHY & HOW]
OTG pending update unlatched will cause system fail, wait OTG fully disabled to
avoid this error.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/core/dc_hw_sequencer.c  |  2 ++
 .../amd/display/dc/inc/hw/timing_generator.h   |  1 +
 .../drm/amd/display/dc/optc/dcn32/dcn32_optc.h |  1 +
 .../drm/amd/display/dc/optc/dcn35/dcn35_optc.c | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index ec4e80e5b6eb2..d82b1cb467f4b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -1177,6 +1177,8 @@ void hwss_wait_for_odm_update_pending_complete(struct dc *dc, struct dc_state *c
 		tg = otg_master->stream_res.tg;
 		if (tg->funcs->wait_odm_doublebuffer_pending_clear)
 			tg->funcs->wait_odm_doublebuffer_pending_clear(tg);
+		if (tg->funcs->wait_otg_disable)
+			tg->funcs->wait_otg_disable(tg);
 	}
 
 	/* ODM update may require to reprogram blank pattern for each OPP */
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h b/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
index 267ace4eef8a3..f2de2cf23859e 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
@@ -374,6 +374,7 @@ struct timing_generator_funcs {
 	void (*wait_drr_doublebuffer_pending_clear)(struct timing_generator *tg);
 	void (*set_long_vtotal)(struct timing_generator *optc, const struct long_vtotal_params *params);
 	void (*wait_odm_doublebuffer_pending_clear)(struct timing_generator *tg);
+	void (*wait_otg_disable)(struct timing_generator *optc);
 	bool (*get_optc_double_buffer_pending)(struct timing_generator *tg);
 	bool (*get_otg_double_buffer_pending)(struct timing_generator *tg);
 	bool (*get_pipe_update_pending)(struct timing_generator *tg);
diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h b/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h
index d159e3ed3bb3c..ead92ad78a234 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h
@@ -62,6 +62,7 @@
 	SF(OTG0_OTG_CONTROL, OTG_DISABLE_POINT_CNTL, mask_sh),\
 	SF(OTG0_OTG_CONTROL, OTG_FIELD_NUMBER_CNTL, mask_sh),\
 	SF(OTG0_OTG_CONTROL, OTG_OUT_MUX, mask_sh),\
+	SF(OTG0_OTG_CONTROL, OTG_CURRENT_MASTER_EN_STATE, mask_sh),\
 	SF(OTG0_OTG_STEREO_CONTROL, OTG_STEREO_EN, mask_sh),\
 	SF(OTG0_OTG_STEREO_CONTROL, OTG_STEREO_SYNC_OUTPUT_LINE_NUM, mask_sh),\
 	SF(OTG0_OTG_STEREO_CONTROL, OTG_STEREO_SYNC_OUTPUT_POLARITY, mask_sh),\
diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c b/drivers/gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c
index 72bff94cb57da..52d5ea98c86b1 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c
@@ -162,6 +162,8 @@ static bool optc35_disable_crtc(struct timing_generator *optc)
 	REG_WAIT(OTG_CLOCK_CONTROL,
 			OTG_BUSY, 0,
 			1, 100000);
+	REG_WAIT(OTG_CONTROL, OTG_CURRENT_MASTER_EN_STATE, 0, 1, 100000);
+
 	optc1_clear_optc_underflow(optc);
 
 	return true;
@@ -428,6 +430,21 @@ static void optc35_set_long_vtotal(
 	}
 }
 
+static void optc35_wait_otg_disable(struct timing_generator *optc)
+{
+	struct optc *optc1;
+	uint32_t is_master_en;
+
+	if (!optc || !optc->ctx)
+		return;
+
+	optc1 = DCN10TG_FROM_TG(optc);
+
+	REG_GET(OTG_CONTROL, OTG_MASTER_EN, &is_master_en);
+	if (!is_master_en)
+		REG_WAIT(OTG_CLOCK_CONTROL, OTG_CURRENT_MASTER_EN_STATE, 0, 1, 100000);
+}
+
 static const struct timing_generator_funcs dcn35_tg_funcs = {
 		.validate_timing = optc1_validate_timing,
 		.program_timing = optc1_program_timing,
@@ -479,6 +496,7 @@ static const struct timing_generator_funcs dcn35_tg_funcs = {
 		.set_odm_bypass = optc32_set_odm_bypass,
 		.set_odm_combine = optc35_set_odm_combine,
 		.get_optc_source = optc2_get_optc_source,
+		.wait_otg_disable = optc35_wait_otg_disable,
 		.set_h_timing_div_manual_mode = optc32_set_h_timing_div_manual_mode,
 		.set_out_mux = optc3_set_out_mux,
 		.set_drr_trigger_window = optc3_set_drr_trigger_window,
-- 
2.51.0



