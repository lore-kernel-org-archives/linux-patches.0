Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2983A266B6C;
	Tue, 11 Nov 2025 01:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823135; cv=none; b=Z878y0aiZ6uWClunnXyPDPB2OoIlnbARASDTi2aFfTkGp0OgAvp+KMs1TwqqfpjEehbjCA8i+6nrS4lgquAzfX9YI95RiUhaOSruJab1/cqHYKJz5e1vBoXV1bw0xAubIib9QuUUXHCvFUAO7XREA1Rm3jbN7NL5Z17R+940KSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823135; c=relaxed/simple;
	bh=G1eQLFuG3nh2XzJjHt+HdLd6REmTr2JB5iYn3Hsl1k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzFW0fX/ENg6/4SSzVPQUy96O+GcegSyZ6lnC/GnSoPCXVg8iQxhUqq+7NmmvYFYaognzQvtIRE4QL22mzj6wgdibOlS5io1/p6O8H0zowawGLNlgD+wRaHRiY0SDVLJlQoLM+M//heTe2acd39s5cKcPgEr4Ym/bhK5npFvwqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arvmTgGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arvmTgGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D86C113D0;
	Tue, 11 Nov 2025 01:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823135;
	bh=G1eQLFuG3nh2XzJjHt+HdLd6REmTr2JB5iYn3Hsl1k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arvmTgGhomf4hzJ3JfVArnYGQ4O7Uc/B4cTJufAnMo4SnmBeTa4RYNyk0ioIwJHD3
	 c5wRmYgV2Aa8W98c7Oz1L1mYbapJmYHIAox2nIRCNi1GxFlCBFDly/IwAgF/6ItAKs
	 eLKWhwFJ+EcLCKeZnvaNv4eXZNu38+kpeQqdopHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ovidiu (Ovi) Bunea" <ovidiu.bunea@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 237/849] drm/amd/display: Move setup_stream_attribute
Date: Tue, 11 Nov 2025 09:36:47 +0900
Message-ID: <20251111004542.171172491@linuxfoundation.org>
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

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit 2681bf4ae8d24df950138b8c9ea9c271cd62e414 ]

[WHY]
If symclk RCO is enabled, stream encoder may not be receiving an ungated
clock by the time we attempt to set stream attributes when setting dpms
on. Since the clock is gated, register writes to the stream encoder fail.

[HOW]
Move set_stream_attribute call into enable_stream, just after the point
where symclk32_se is ungated.
Logically there is no need to set stream attributes as early as is
currently done in link_set_dpms_on, so this should have no impact beyond
the RCO fix.

Reviewed-by: Ovidiu (Ovi) Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  | 1 +
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    | 2 ++
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  | 2 ++
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c            | 3 ---
 .../drm/amd/display/dc/virtual/virtual_stream_encoder.c    | 7 +++++++
 5 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index c69194e04ff93..32fd6bdc18d73 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -671,6 +671,7 @@ void dce110_enable_stream(struct pipe_ctx *pipe_ctx)
 	uint32_t early_control = 0;
 	struct timing_generator *tg = pipe_ctx->stream_res.tg;
 
+	link_hwss->setup_stream_attribute(pipe_ctx);
 	link_hwss->setup_stream_encoder(pipe_ctx);
 
 	dc->hwss.update_info_frame(pipe_ctx);
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 5e57bd1a08e73..9d3946065620a 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -3052,6 +3052,8 @@ void dcn20_enable_stream(struct pipe_ctx *pipe_ctx)
 						      link_enc->transmitter - TRANSMITTER_UNIPHY_A);
 	}
 
+	link_hwss->setup_stream_attribute(pipe_ctx);
+
 	if (dc->res_pool->dccg->funcs->set_pixel_rate_div)
 		dc->res_pool->dccg->funcs->set_pixel_rate_div(
 			dc->res_pool->dccg,
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index b95b98cc25534..0fe7637049457 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -968,6 +968,8 @@ void dcn401_enable_stream(struct pipe_ctx *pipe_ctx)
 		}
 	}
 
+	link_hwss->setup_stream_attribute(pipe_ctx);
+
 	if (dc->res_pool->dccg->funcs->set_pixel_rate_div) {
 		dc->res_pool->dccg->funcs->set_pixel_rate_div(
 			dc->res_pool->dccg,
diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index 8c8682f743d6f..cb80b45999360 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -2458,7 +2458,6 @@ void link_set_dpms_on(
 	struct link_encoder *link_enc = pipe_ctx->link_res.dio_link_enc;
 	enum otg_out_mux_dest otg_out_dest = OUT_MUX_DIO;
 	struct vpg *vpg = pipe_ctx->stream_res.stream_enc->vpg;
-	const struct link_hwss *link_hwss = get_link_hwss(link, &pipe_ctx->link_res);
 	bool apply_edp_fast_boot_optimization =
 		pipe_ctx->stream->apply_edp_fast_boot_optimization;
 
@@ -2502,8 +2501,6 @@ void link_set_dpms_on(
 		pipe_ctx->stream_res.tg->funcs->set_out_mux(pipe_ctx->stream_res.tg, otg_out_dest);
 	}
 
-	link_hwss->setup_stream_attribute(pipe_ctx);
-
 	pipe_ctx->stream->apply_edp_fast_boot_optimization = false;
 
 	// Enable VPG before building infoframe
diff --git a/drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c
index ad088d70e1893..6ffc74fc9dcd8 100644
--- a/drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c
@@ -44,6 +44,11 @@ static void virtual_stream_encoder_dvi_set_stream_attribute(
 	struct dc_crtc_timing *crtc_timing,
 	bool is_dual_link) {}
 
+static void virtual_stream_encoder_lvds_set_stream_attribute(
+	struct stream_encoder *enc,
+	struct dc_crtc_timing *crtc_timing)
+{}
+
 static void virtual_stream_encoder_set_throttled_vcp_size(
 	struct stream_encoder *enc,
 	struct fixed31_32 avg_time_slots_per_mtp)
@@ -115,6 +120,8 @@ static const struct stream_encoder_funcs virtual_str_enc_funcs = {
 		virtual_stream_encoder_hdmi_set_stream_attribute,
 	.dvi_set_stream_attribute =
 		virtual_stream_encoder_dvi_set_stream_attribute,
+	.lvds_set_stream_attribute =
+		virtual_stream_encoder_lvds_set_stream_attribute,
 	.set_throttled_vcp_size =
 		virtual_stream_encoder_set_throttled_vcp_size,
 	.update_hdmi_info_packets =
-- 
2.51.0



