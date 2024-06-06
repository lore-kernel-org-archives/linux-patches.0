Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B613B19FA86;
	Thu,  6 Jun 2024 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683135; cv=none; b=Uac3jRRC+kYT2yeUc1cOJQ5bsgwo7DK4D+6kT6z9cK5usTJGLeUUIraRsv+KdglVhKkZ3EIy30u+sa1mBbEUblp7I0Oly1t2jSot++SMtedphWLLXjalitR2LNezE/Fu0pRlRH4sKB2f5SM34FgZs9rezjggJE9z2IGxCNAILA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683135; c=relaxed/simple;
	bh=OMTO9yHWy5KCf4f0kv1mH/VU9Mal68hsZBIOdUbjc8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/6NaP9FBpiSXcbIQMj4LKtPxa9OTff4yHCX+09/9OSh2fiMXepMKMBRhcpOWb7m+EvWNJh6R5ESyVKfaT1qqVA/XB7DFprNvmLxd1VoBGDHxKvl4wOSdvK1X5Rn8uXsC1a5kmT7taX8jVeyBYIWOM3UcIcEH34SZPpmIod9bI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxhRm+5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxhRm+5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BFCC2BD10;
	Thu,  6 Jun 2024 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683135;
	bh=OMTO9yHWy5KCf4f0kv1mH/VU9Mal68hsZBIOdUbjc8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxhRm+5AIcuw0ITOmnrPqmWANATdhlSco932WNHYesLMHx0QkG5gnfam9IVTBEJNA
	 vFkKtFR4Nh0irfdm3CNSK7MQAi89wyblBAc0Ok2CGk1a7FQ5C6I5Ghe9R4m8Sfhk7s
	 3z/doVP8u6tAKv3GlRIm9tRDp7N6fz4TzME5HruM=
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
Subject: [PATCH 6.6 077/744] drm/amd/display: Add dtbclk access to dcn315
Date: Thu,  6 Jun 2024 15:55:49 +0200
Message-ID: <20240606131734.870863138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8776055bbeaae..d4d3f58a613f7 100644
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



