Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06812168C4;
	Mon, 27 May 2024 19:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837656; cv=none; b=L+DTFJ5QSfz965xALNNri5htMSuxi5/Lkqk5awioX06fY0SzUoT00wB3UR4NhGXFkpyFQ0tPchmAp6kbz8RrzOUsEuqZWvi/fz/sjT9Ck7K0F7hSSCFbCRFkFEJzUMPN+eH8npdsvU5zMBjG01ITkC5uskvGgPWwyuskPz2kFt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837656; c=relaxed/simple;
	bh=siDFrZdx3lo81t7cqc4JJ+Rffz05/Ymq+UKXkdx5SHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKfq8bhYqjOfUAnCtlvx8+JfCF+x2BN+qDOyRnwvK6ogkVSGU+lGVfvdfxjgOnTWcjQkU1PdWl34qUU5uQNNBD2y2T1FsSWWl2xZnisNKc1hlFzJJhVRKJRKKwpOdF4RuZUGD0J+Ug2RG+lZfKnhvWEIGHKRv0iMoAb+5aGLG9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgcZu9Ds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgcZu9Ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94611C2BBFC;
	Mon, 27 May 2024 19:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837655;
	bh=siDFrZdx3lo81t7cqc4JJ+Rffz05/Ymq+UKXkdx5SHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgcZu9Ds9TU1yIv0MQGEK405lZ0CHAda8ABxDLZOnDhj5XcGzO1Kqxw91Z4i8Lv0t
	 QYIcUevRuUhg4/VpzArqHKc7/poBQ6V4hbjKSMgesF2yARtVNd1icMnFPtlZd6Ai7M
	 gtnYRen08OJF5i6PTLSBxGdhlxSENJOskc787VNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Swapnil Patel <swapnil.patel@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 094/493] drm/amd/display: Add dtbclk access to dcn315
Date: Mon, 27 May 2024 20:51:36 +0200
Message-ID: <20240527185633.494283039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Swapnil Patel <swapnil.patel@amd.com>

[ Upstream commit a01b64f31d65bdc917d1afb4cec9915beb6931be ]

[Why & How]

Currently DCN315 clk manager is missing code to enable/disable dtbclk.
Because of this, "optimized_required" flag is constantly set
and this prevents FreeSync from engaging for certain high bandwidth
display Modes which require DTBCLK.

Reviewed-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Swapnil Patel <swapnil.patel@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c    | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
index 644da46373209..5506cf9b3672f 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
@@ -145,6 +145,10 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
 	 */
 	clk_mgr_base->clks.zstate_support = new_clocks->zstate_support;
 	if (safe_to_lower) {
+		if (clk_mgr_base->clks.dtbclk_en && !new_clocks->dtbclk_en) {
+			dcn315_smu_set_dtbclk(clk_mgr, false);
+			clk_mgr_base->clks.dtbclk_en = new_clocks->dtbclk_en;
+		}
 		/* check that we're not already in lower */
 		if (clk_mgr_base->clks.pwr_state != DCN_PWR_STATE_LOW_POWER) {
 			display_count = dcn315_get_active_display_cnt_wa(dc, context);
@@ -160,6 +164,10 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
 			}
 		}
 	} else {
+		if (!clk_mgr_base->clks.dtbclk_en && new_clocks->dtbclk_en) {
+			dcn315_smu_set_dtbclk(clk_mgr, true);
+			clk_mgr_base->clks.dtbclk_en = new_clocks->dtbclk_en;
+		}
 		/* check that we're not already in D0 */
 		if (clk_mgr_base->clks.pwr_state != DCN_PWR_STATE_MISSION_MODE) {
 			union display_idle_optimization_u idle_info = { 0 };
-- 
2.43.0



