Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082C7FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB82C433EF;
	Mon, 15 May 2023 17:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170657;
	bh=arpnoXMpZudJmwoLmmaSXq81yzlVI1RFX/262ja9AsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPHNkNCAFdHSwzsuJgsWpH+LELqdsxr7hbGzfoEDQbneqcM+RgfrN+CgKddc4F0UI
	 jOOgrbU1BELl+nzSaCRpTsbLo9HHpxmOrl6cjGY5xgZOGQaEDln+8UXj8cohINe7gJ
	 bloQlbhUnqYY7nzrhWQHlwReNLyaKMhjlS3W6BB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <Jun.Lei@amd.com>,
	Brian Chang <Brian.Chang@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/239] drm/amd/display: Add Z8 allow states to z-state support list
Date: Mon, 15 May 2023 18:27:43 +0200
Message-Id: <20230515161727.732641639@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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

[ Upstream commit 80676936805e46c79c38008e5142a77a1b2f2dc7 ]

[Why]
Even if we block Z9 based on crossover threshold it's possible to
allow for Z8.

[How]
There's support for this on DCN314, so update the support types to
include a z8 only and z8_z10 only state.

Update the decide_zstate_support function to allow for specifying
these modes based on the Z8 threshold.

DCN31 has z-state disabled, but still update the legacy code to
map z8_only = disallow and z10_z8_only = z10_only to keep the support
the same.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: d893f39320e1 ("drm/amd/display: Lowering min Z8 residency time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c |  4 ++--
 .../drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c   | 12 ++++++++++--
 drivers/gpu/drm/amd/display/dc/dc.h                  |  2 ++
 drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c | 12 +++++++++---
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
index 090b2c02aee17..0827c7df28557 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
@@ -333,8 +333,8 @@ void dcn31_smu_set_zstate_support(struct clk_mgr_internal *clk_mgr, enum dcn_zst
 			(support == DCN_ZSTATE_SUPPORT_ALLOW_Z10_ONLY))
 		support = DCN_ZSTATE_SUPPORT_DISALLOW;
 
-
-	if (support == DCN_ZSTATE_SUPPORT_ALLOW_Z10_ONLY)
+	if (support == DCN_ZSTATE_SUPPORT_ALLOW_Z10_ONLY ||
+	    support == DCN_ZSTATE_SUPPORT_ALLOW_Z8_Z10_ONLY)
 		param = 1;
 	else
 		param = 0;
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c
index aa264c600408d..0765334f08259 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c
@@ -349,8 +349,6 @@ void dcn314_smu_set_zstate_support(struct clk_mgr_internal *clk_mgr, enum dcn_zs
 	if (!clk_mgr->smu_present)
 		return;
 
-	// Arg[15:0] = 8/9/0 for Z8/Z9/disallow -> existing bits
-	// Arg[16] = Disallow Z9 -> new bit
 	switch (support) {
 
 	case DCN_ZSTATE_SUPPORT_ALLOW:
@@ -369,6 +367,16 @@ void dcn314_smu_set_zstate_support(struct clk_mgr_internal *clk_mgr, enum dcn_zs
 		param = (1 << 10);
 		break;
 
+	case DCN_ZSTATE_SUPPORT_ALLOW_Z8_Z10_ONLY:
+		msg_id = VBIOSSMC_MSG_AllowZstatesEntry;
+		param = (1 << 10) | (1 << 8);
+		break;
+
+	case DCN_ZSTATE_SUPPORT_ALLOW_Z8_ONLY:
+		msg_id = VBIOSSMC_MSG_AllowZstatesEntry;
+		param = (1 << 8);
+		break;
+
 	default: //DCN_ZSTATE_SUPPORT_UNKNOWN
 		msg_id = VBIOSSMC_MSG_AllowZstatesEntry;
 		param = 0;
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 8757d7ff8ff62..6d64d3b0dc211 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -491,6 +491,8 @@ enum dcn_pwr_state {
 enum dcn_zstate_support_state {
 	DCN_ZSTATE_SUPPORT_UNKNOWN,
 	DCN_ZSTATE_SUPPORT_ALLOW,
+	DCN_ZSTATE_SUPPORT_ALLOW_Z8_ONLY,
+	DCN_ZSTATE_SUPPORT_ALLOW_Z8_Z10_ONLY,
 	DCN_ZSTATE_SUPPORT_ALLOW_Z10_ONLY,
 	DCN_ZSTATE_SUPPORT_DISALLOW,
 };
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
index 602e885ed52c4..feef0a75878f9 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
@@ -949,6 +949,7 @@ static enum dcn_zstate_support_state  decide_zstate_support(struct dc *dc, struc
 	int plane_count;
 	int i;
 	unsigned int optimized_min_dst_y_next_start_us;
+	bool allow_z8 = context->bw_ctx.dml.vba.StutterPeriod > 1000.0;
 
 	plane_count = 0;
 	optimized_min_dst_y_next_start_us = 0;
@@ -963,6 +964,8 @@ static enum dcn_zstate_support_state  decide_zstate_support(struct dc *dc, struc
 	 * 	2. single eDP, on link 0, 1 plane and stutter period > 5ms
 	 * Z10 only cases:
 	 * 	1. single eDP, on link 0, 1 plane and stutter period >= 5ms
+	 * Z8 cases:
+	 * 	1. stutter period sufficient
 	 * Zstate not allowed cases:
 	 * 	1. Everything else
 	 */
@@ -990,11 +993,14 @@ static enum dcn_zstate_support_state  decide_zstate_support(struct dc *dc, struc
 		if (context->bw_ctx.dml.vba.StutterPeriod > 5000.0 || optimized_min_dst_y_next_start_us > 5000)
 			return DCN_ZSTATE_SUPPORT_ALLOW;
 		else if (link->psr_settings.psr_version == DC_PSR_VERSION_1 && !link->panel_config.psr.disable_psr)
-			return DCN_ZSTATE_SUPPORT_ALLOW_Z10_ONLY;
+			return allow_z8 ? DCN_ZSTATE_SUPPORT_ALLOW_Z8_Z10_ONLY : DCN_ZSTATE_SUPPORT_ALLOW_Z10_ONLY;
 		else
-			return DCN_ZSTATE_SUPPORT_DISALLOW;
-	} else
+			return allow_z8 ? DCN_ZSTATE_SUPPORT_ALLOW_Z8_ONLY : DCN_ZSTATE_SUPPORT_DISALLOW;
+	} else if (allow_z8) {
+		return DCN_ZSTATE_SUPPORT_ALLOW_Z8_ONLY;
+	} else {
 		return DCN_ZSTATE_SUPPORT_DISALLOW;
+	}
 }
 
 void dcn20_calculate_dlg_params(
-- 
2.39.2



