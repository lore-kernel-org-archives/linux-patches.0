Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048AD79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B910C433D6;
	Wed, 30 Nov 2022 18:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834261;
	bh=n1WH1xBwztwL9BHAYtU5mqBG/ZDLwntmWbNVs8PuTKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPCSjsAHRRPbrDAiAs1mfHpqOjP7RiTlIi0vCpMRXhv4m6bH58/CD0C/TwKDZQkBM
	 0VESoM5BjPC2whKZv0hVSE5HIdmthpQXkauWNFQweqT6csLcZlKyQvw5BN84mSnOAc
	 IK4XadAjhrhFS9RmnezKdNku/aJdwdIMwi0Tk0qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Jun Lei <Jun.Lei@amd.com>,
	Pavle Kotarac <Pavle.Kotarac@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 188/289] drm/amd/display: Added debug option for forcing subvp num ways
Date: Wed, 30 Nov 2022 19:22:53 +0100
Message-Id: <20221130180548.387132156@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lee, Alvin <Alvin.Lee2@amd.com>

[ Upstream commit 5c1a431aaf52bbba8b6e2c4e9b4037a09509c0e3 ]

[Description]
Regkey option for forcing num ways for subvp for debug purposes

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 4d2852412306 ("drm/amd/display: Fix calculation for cursor CAB allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                   |  1 +
 .../drm/amd/display/dc/dcn32/dcn32_resource_helpers.c | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index dbf8158b832e..a652dec5d02f 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -746,6 +746,7 @@ struct dc_debug_options {
 	bool force_disable_subvp;
 	bool force_subvp_mclk_switch;
 	bool allow_sw_cursor_fallback;
+	unsigned int force_subvp_num_ways;
 	bool force_usr_allow;
 	/* uses value at boot and disables switch */
 	bool disable_dtb_ref_clk_switch;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
index 13cd1f2e50ca..7c37575d69c7 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
@@ -54,13 +54,14 @@ uint32_t dcn32_helper_calculate_num_ways_for_subvp(struct dc *dc, struct dc_stat
 	uint32_t num_mblks = 0;
 	uint32_t cache_lines_per_plane = 0;
 	uint32_t i = 0, j = 0;
-	uint32_t mblk_width = 0;
-	uint32_t mblk_height = 0;
+	uint16_t mblk_width = 0;
+	uint16_t mblk_height = 0;
 	uint32_t full_vp_width_blk_aligned = 0;
 	uint32_t full_vp_height_blk_aligned = 0;
 	uint32_t mall_alloc_width_blk_aligned = 0;
 	uint32_t mall_alloc_height_blk_aligned = 0;
-	uint32_t full_vp_height = 0;
+	uint16_t full_vp_height = 0;
+	bool subvp_in_use = false;
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
 		struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
@@ -70,6 +71,7 @@ uint32_t dcn32_helper_calculate_num_ways_for_subvp(struct dc *dc, struct dc_stat
 				pipe->stream->mall_stream_config.type == SUBVP_PHANTOM) {
 			struct pipe_ctx *main_pipe = NULL;
 
+			subvp_in_use = true;
 			/* Get full viewport height from main pipe (required for MBLK calculation) */
 			for (j = 0; j < dc->res_pool->pipe_count; j++) {
 				main_pipe = &context->res_ctx.pipe_ctx[j];
@@ -129,6 +131,9 @@ uint32_t dcn32_helper_calculate_num_ways_for_subvp(struct dc *dc, struct dc_stat
 	if (cache_lines_used % lines_per_way > 0)
 		num_ways++;
 
+	if (subvp_in_use && dc->debug.force_subvp_num_ways > 0)
+		num_ways = dc->debug.force_subvp_num_ways;
+
 	return num_ways;
 }
 
-- 
2.35.1



