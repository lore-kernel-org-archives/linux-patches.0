Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3019C4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCB2C433D7;
	Mon, 14 Nov 2022 13:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430924;
	bh=d3D0aiJTptEhMm3hYwsH5xqmEXxlwVIYyrFu0G3+w5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12ycGao4CjD/pn0MZsUM0KSQYr9aLY5HFC+4l7tHo82u8UopKK1gioQQfPZs4rB+/
	 DkvuqOzhPOwvW+Ei27yR2SBicjbJdzGzg4mASnacMxSFz6Abz/cBftTiAwT5x890Tm
	 OLftrNBmvUUqX/paYtEr5galSZNa0xdDdxgt4Wfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Jun Lei <jun.lei@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 009/190] drm/amd/display: Limit dcn32 to 1950Mhz display clock
Date: Mon, 14 Nov 2022 13:43:53 +0100
Message-Id: <20221114124459.191839576@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jun Lei <jun.lei@amd.com>

[ Upstream commit e59843c4cdd68a369591630088171eeacce9859f ]

[why]
Hardware team recommends we limit dispclock to 1950Mhz for all DCN3.2.x

[how]
Limit to 1950 when initializing clocks.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Jun Lei <jun.lei@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c  | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index f4c7bbd9961a..f3090ead9af5 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -157,6 +157,7 @@ void dcn32_init_clocks(struct clk_mgr *clk_mgr_base)
 	struct clk_mgr_internal *clk_mgr = TO_CLK_MGR_INTERNAL(clk_mgr_base);
 	unsigned int num_levels;
 	struct clk_limit_num_entries *num_entries_per_clk = &clk_mgr_base->bw_params->clk_table.num_entries_per_clk;
+	unsigned int i;
 
 	memset(&(clk_mgr_base->clks), 0, sizeof(struct dc_clocks));
 	clk_mgr_base->clks.p_state_change_support = true;
@@ -205,18 +206,17 @@ void dcn32_init_clocks(struct clk_mgr *clk_mgr_base)
 		clk_mgr->dpm_present = true;
 
 	if (clk_mgr_base->ctx->dc->debug.min_disp_clk_khz) {
-		unsigned int i;
-
 		for (i = 0; i < num_levels; i++)
 			if (clk_mgr_base->bw_params->clk_table.entries[i].dispclk_mhz
 					< khz_to_mhz_ceil(clk_mgr_base->ctx->dc->debug.min_disp_clk_khz))
 				clk_mgr_base->bw_params->clk_table.entries[i].dispclk_mhz
 					= khz_to_mhz_ceil(clk_mgr_base->ctx->dc->debug.min_disp_clk_khz);
 	}
+	for (i = 0; i < num_levels; i++)
+		if (clk_mgr_base->bw_params->clk_table.entries[i].dispclk_mhz > 1950)
+			clk_mgr_base->bw_params->clk_table.entries[i].dispclk_mhz = 1950;
 
 	if (clk_mgr_base->ctx->dc->debug.min_dpp_clk_khz) {
-		unsigned int i;
-
 		for (i = 0; i < num_levels; i++)
 			if (clk_mgr_base->bw_params->clk_table.entries[i].dppclk_mhz
 					< khz_to_mhz_ceil(clk_mgr_base->ctx->dc->debug.min_dpp_clk_khz))
-- 
2.35.1



