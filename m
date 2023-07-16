Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CFE8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262C3C433C9;
	Sun, 16 Jul 2023 20:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539184;
	bh=alFtR+6aEbb2djhHe411X3Ay2T4YWKYKBtS+7naObS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHHsRuxZjbk3DQEDs/Prs72/yb6hZ65ny5OjAeBUbiWCjxuKH+UQ8N/e/tQVE2wY9
	 i7jBXx2GOedLlJB78DKOgpNbnNma3PgbZ3JawIq9IeEDEgQ04Cn6/rE9W+1VLg8pRN
	 oxtTSczQo24RE+nA7QWBhRYkVfe+9TT+639Rs050=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Daniel Miess <daniel.miess@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 717/800] Revert "drm/amd/display: Move DCN314 DOMAIN power control to DMCUB"
Date: Sun, 16 Jul 2023 21:49:30 +0200
Message-ID: <20230716195005.771408267@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Miess <daniel.miess@amd.com>

[ Upstream commit bf0097c5c9aec528da75e2b5fcede472165322bb ]

This reverts commit e383b12709e32d6494c948422070c2464b637e44.

Controling hubp power gating using the DMCUB isn't stable so we
are reverting this change to move control back into the driver.

Cc: stable@vger.kernel.org # 6.3+
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Daniel Miess <daniel.miess@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn314/dcn314_hwseq.c  | 23 -------------------
 .../drm/amd/display/dc/dcn314/dcn314_hwseq.h  |  2 --
 .../drm/amd/display/dc/dcn314/dcn314_init.c   |  2 +-
 3 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
index cc3fe9cac5b53..c309933112e5e 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
@@ -400,29 +400,6 @@ void dcn314_dpp_root_clock_control(struct dce_hwseq *hws, unsigned int dpp_inst,
 			hws->ctx->dc->res_pool->dccg, dpp_inst, clock_on);
 }
 
-void dcn314_hubp_pg_control(struct dce_hwseq *hws, unsigned int hubp_inst, bool power_on)
-{
-	struct dc_context *ctx = hws->ctx;
-	union dmub_rb_cmd cmd;
-
-	if (hws->ctx->dc->debug.disable_hubp_power_gate)
-		return;
-
-	PERF_TRACE();
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.domain_control.header.type = DMUB_CMD__VBIOS;
-	cmd.domain_control.header.sub_type = DMUB_CMD__VBIOS_DOMAIN_CONTROL;
-	cmd.domain_control.header.payload_bytes = sizeof(cmd.domain_control.data);
-	cmd.domain_control.data.inst = hubp_inst;
-	cmd.domain_control.data.power_gate = !power_on;
-
-	dc_dmub_srv_cmd_queue(ctx->dmub_srv, &cmd);
-	dc_dmub_srv_cmd_execute(ctx->dmub_srv);
-	dc_dmub_srv_wait_idle(ctx->dmub_srv);
-
-	PERF_TRACE();
-}
 static void apply_symclk_on_tx_off_wa(struct dc_link *link)
 {
 	/* There are use cases where SYMCLK is referenced by OTG. For instance
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h
index 6d0b62503caa6..54b1379914ce5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h
@@ -41,8 +41,6 @@ unsigned int dcn314_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsig
 
 void dcn314_set_pixels_per_cycle(struct pipe_ctx *pipe_ctx);
 
-void dcn314_hubp_pg_control(struct dce_hwseq *hws, unsigned int hubp_inst, bool power_on);
-
 void dcn314_dpp_root_clock_control(struct dce_hwseq *hws, unsigned int dpp_inst, bool clock_on);
 
 void dcn314_disable_link_output(struct dc_link *link, const struct link_resource *link_res, enum signal_type signal);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c
index a588f46b166f4..d9d2576f3e842 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c
@@ -138,7 +138,7 @@ static const struct hwseq_private_funcs dcn314_private_funcs = {
 	.plane_atomic_power_down = dcn10_plane_atomic_power_down,
 	.enable_power_gating_plane = dcn314_enable_power_gating_plane,
 	.dpp_root_clock_control = dcn314_dpp_root_clock_control,
-	.hubp_pg_control = dcn314_hubp_pg_control,
+	.hubp_pg_control = dcn31_hubp_pg_control,
 	.program_all_writeback_pipes_in_tree = dcn30_program_all_writeback_pipes_in_tree,
 	.update_odm = dcn314_update_odm,
 	.dsc_pg_control = dcn314_dsc_pg_control,
-- 
2.39.2



