Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB54BFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D12C433D2;
	Mon, 15 May 2023 17:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171454;
	bh=PndzXQRV4rJJ2mtSel8n2VvNLFHkLZi3sczPFZej3/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5BqEAvJ7J+lzAm5g37Yd7PsJ8hMTiKrKgHRcePP5MtIk0oeZuoEnRTdp88BeHvXq
	 JrfuAffha6IyxgQYWRJfVO7Xa+7ezu+IM6heZHabxyWh10dLfzW1b1GRD41JNOIGH2
	 W0I/qKL3iuwi8JG6L88TPp7JfFsQCw2aM/d2B8K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <Charlene.Liu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 215/242] drm/amd/display: Fix Z8 support configurations
Date: Mon, 15 May 2023 18:29:01 +0200
Message-Id: <20230515161728.376736865@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 73dd4ca4b5a01235607231839bd351bbef75a1d2 ]

[Why]
It's not supported in multi-display, but it is supported in 2nd eDP
screen only.

[How]
Remove multi display support, restrict number of planes for all
z-states support, but still allow Z8 if we're not using PWRSEQ0.

Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: d893f39320e1 ("drm/amd/display: Lowering min Z8 residency time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c   | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
index c26da3bb2892b..859dc67a1fb6b 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
@@ -949,7 +949,6 @@ static enum dcn_zstate_support_state  decide_zstate_support(struct dc *dc, struc
 	int plane_count;
 	int i;
 	unsigned int optimized_min_dst_y_next_start_us;
-	bool allow_z8 = context->bw_ctx.dml.vba.StutterPeriod > 1000.0;
 
 	plane_count = 0;
 	optimized_min_dst_y_next_start_us = 0;
@@ -974,6 +973,8 @@ static enum dcn_zstate_support_state  decide_zstate_support(struct dc *dc, struc
 	else if (context->stream_count == 1 &&  context->streams[0]->signal == SIGNAL_TYPE_EDP) {
 		struct dc_link *link = context->streams[0]->sink->link;
 		struct dc_stream_status *stream_status = &context->stream_status[0];
+		bool allow_z8 = context->bw_ctx.dml.vba.StutterPeriod > 1000.0;
+		bool is_pwrseq0 = link->link_index == 0;
 
 		if (dc_extended_blank_supported(dc)) {
 			for (i = 0; i < dc->res_pool->pipe_count; i++) {
@@ -986,18 +987,17 @@ static enum dcn_zstate_support_state  decide_zstate_support(struct dc *dc, struc
 				}
 			}
 		}
-		/* zstate only supported on PWRSEQ0  and when there's <2 planes*/
-		if (link->link_index != 0 || stream_status->plane_count > 1)
+
+		/* Don't support multi-plane configurations */
+		if (stream_status->plane_count > 1)
 			return DCN_ZSTATE_SUPPORT_DISALLOW;
 
-		if (context->bw_ctx.dml.vba.StutterPeriod > 5000.0 || optimized_min_dst_y_next_start_us > 5000)
+		if (is_pwrseq0 && (context->bw_ctx.dml.vba.StutterPeriod > 5000.0 || optimized_min_dst_y_next_start_us > 5000))
 			return DCN_ZSTATE_SUPPORT_ALLOW;
-		else if (link->psr_settings.psr_version == DC_PSR_VERSION_1 && !link->panel_config.psr.disable_psr)
+		else if (is_pwrseq0 && link->psr_settings.psr_version == DC_PSR_VERSION_1 && !link->panel_config.psr.disable_psr)
 			return allow_z8 ? DCN_ZSTATE_SUPPORT_ALLOW_Z8_Z10_ONLY : DCN_ZSTATE_SUPPORT_ALLOW_Z10_ONLY;
 		else
 			return allow_z8 ? DCN_ZSTATE_SUPPORT_ALLOW_Z8_ONLY : DCN_ZSTATE_SUPPORT_DISALLOW;
-	} else if (allow_z8) {
-		return DCN_ZSTATE_SUPPORT_ALLOW_Z8_ONLY;
 	} else {
 		return DCN_ZSTATE_SUPPORT_DISALLOW;
 	}
-- 
2.39.2



