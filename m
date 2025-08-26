Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF11312803;
	Tue, 26 Aug 2025 13:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215244; cv=none; b=cpv0nMgMxz9CCBrzjvkN4XZzMaFzS8yneMvGTSmH6NEAzY7HR9Z8mBk+V7+swSafRJorS1/glMki+maMSK4/yifRV4bLGaYj3XIxyZ12mCHQOE6TwbupCX8I503uJEV3VZBbAL20V7LFpZHw70NOY9+EcLgnLMH3F5Q07hZFzaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215244; c=relaxed/simple;
	bh=OFtOf+GYLqm4WuxI5F9XGaZ6mtkNLDz9th/3P66nQwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r5cmnzDx/c/KbOcpWlgqAx3Z5azCH+Tu0DkC2nHJo4/kuxP1NdiiH1lI/Cu0W6h5JmUVzAJIg1kWsPjUcD84p0gcG01qpL6Xj6TU0Ns8hjd98+TjY7X7bBH1hy0dE+i30LDw0rY3vyyDVhG25isLvs6BPliUYEQLr1pOGYbGxi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+imhIqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+imhIqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B0AC4CEF1;
	Tue, 26 Aug 2025 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215244;
	bh=OFtOf+GYLqm4WuxI5F9XGaZ6mtkNLDz9th/3P66nQwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+imhIqp8apaRMLLT/yjWaDBIngC8TA2c9K1FjJOJAnqoqDmX2lVTe4tM9IvgK/Mg
	 kPu7G7CKhxJZZ8ALOJyvEF9xkDb5Ow8V9voffc4cTG3lC2+YqVbgiMhPNFr2VaklDW
	 oFg90o+e2J84UhtB3j9EZmpEkklOmjpa9jI6RvyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 441/482] drm/amd/display: Dont overclock DCE 6 by 15%
Date: Tue, 26 Aug 2025 13:11:34 +0200
Message-ID: <20250826110941.726091443@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit cb7b7ae53b557d168b4af5cd8549f3eff920bfb5 ]

The extra 15% clock was added as a workaround for a Polaris issue
which uses DCE 11, and should not have been used on DCE 6 which
is already hardcoded to the highest possible display clock.
Unfortunately, the extra 15% was mistakenly copied and kept
even on code paths which don't affect Polaris.

This commit fixes that and also adds a check to make sure
not to exceed the maximum DCE 6 display clock.

Fixes: 8cd61c313d8b ("drm/amd/display: Raise dispclk value for Polaris")
Fixes: dc88b4a684d2 ("drm/amd/display: make clk mgr soc specific")
Fixes: 3ecb3b794e2c ("drm/amd/display: dc/clk_mgr: add support for SI parts (v2)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 427980c1cbd22bb256b9385f5ce73c0937562408)
Cc: stable@vger.kernel.org
[ `MIN` => `min` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c
@@ -112,11 +112,9 @@ static void dce60_update_clocks(struct c
 {
 	struct clk_mgr_internal *clk_mgr_dce = TO_CLK_MGR_INTERNAL(clk_mgr_base);
 	struct dm_pp_power_level_change_request level_change_req;
-	int patched_disp_clk = context->bw_ctx.bw.dce.dispclk_khz;
-
-	/*TODO: W/A for dal3 linux, investigate why this works */
-	if (!clk_mgr_dce->dfs_bypass_active)
-		patched_disp_clk = patched_disp_clk * 115 / 100;
+	const int max_disp_clk =
+		clk_mgr_dce->max_clks_by_state[DM_PP_CLOCKS_STATE_PERFORMANCE].display_clk_khz;
+	int patched_disp_clk = min(max_disp_clk, context->bw_ctx.bw.dce.dispclk_khz);
 
 	level_change_req.power_level = dce_get_required_clocks_state(clk_mgr_base, context);
 	/* get max clock state from PPLIB */


