Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA6A19922D;
	Thu,  6 Jun 2024 14:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683180; cv=none; b=g04S8EddWbmjmOh2/yHju0cGScJcvlhE6abJi8NPPGqHYstlHlDc2i0i4m30KrK/3yjtyV7Lsgd7f3BLM1bRint0/UTZP5WuroYZWUVMrZQ7f/f4pjYP5vUIjrCHXMScvGbA8rvW3FMJ+qiMVgwV6Sk0PdXzU3XhHqc3u59IuyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683180; c=relaxed/simple;
	bh=POmjn2+6EgiD+B3T4YUU8TNSet+RD9WQQ2QXdrg951o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EW9Pgq7m9KDvvp8Ha58WSJysI6SKrQLO/M2j4qvYVN5qIGHMDFSZjmUYrAbwYgxp0mumvb6RaKSrnI0GI9ea0SKdJGmbW7PZ6oswqNhBc+CrfnrFl63SxDpa9RfHFTsFNWC/75c615sZzTXmjt2mNRzFnA5s4BlOKDeFuc+IV3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/f3zJas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/f3zJas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB8CC4AF0D;
	Thu,  6 Jun 2024 14:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683180;
	bh=POmjn2+6EgiD+B3T4YUU8TNSet+RD9WQQ2QXdrg951o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/f3zJasXQaJM++Ww05MwMQT0DvR5oVFw9vgFDdH1fBe9DRRiUipmmM7a/GPotxnA
	 J3c4I5wYkxebf9ZAJuFHb8n0uChI1xqm8b+my2sBG1TwpxzQWlQ3bWwxYrcH/vNT/J
	 +XGGfP/OoZYsCGvn5P5NCEm7R/u3waU2J/VA0Ldw=
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
Subject: [PATCH 6.1 055/473] drm/amd/display: Add dtbclk access to dcn315
Date: Thu,  6 Jun 2024 15:59:44 +0200
Message-ID: <20240606131701.703081851@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 28b83133db910..09eb1bc9aa030 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
@@ -131,6 +131,10 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
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
@@ -146,6 +150,10 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
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



