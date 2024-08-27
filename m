Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE991CDFC4;
	Tue, 27 Aug 2024 15:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772587; cv=none; b=CMgxl7U3xIh1RRBGeMfWXs6MZtEy3fFWaz4BTmv+kTB/Y3Fdmw6d+mimKyq2F7RzrIpJawxPnMbPobbkcFiv9cO18/gQeeNC7J5GPDaOSsQ2GCBnel9aQs98SEvfvri4u9zZKXNFJFBD5U++B38WnwQwXM2RcPbWgx+jQr6+stc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772587; c=relaxed/simple;
	bh=RRE5QbrnHDUEJV76sOGYmXDjf/4qWePpL1KxHhDhHhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsHVuueGKNVG36ESnF91LOqRG5Pzmo+aPHsxaazIAkYpmWUtCCmpazjnPeYz+Vx6kdBmSzSQ1bFkQ0xzyoGVnRi7qaS5oSn8xZI53lqSBUBk5aL0DBkYCA0ao7sF0hkLDJm80Bz+nPczfgKlhV66Y/WiwtHJZsHbRazppGHrvsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhCY/v4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhCY/v4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4906C6107E;
	Tue, 27 Aug 2024 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772587;
	bh=RRE5QbrnHDUEJV76sOGYmXDjf/4qWePpL1KxHhDhHhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhCY/v4DQFJ9bmhyXl+TS2fXu7V1uMZCBU+Zqf7iRaClsnfu7/7tJHvtKUPbfnrwk
	 dFBYFUIewWKMD8DPF9CnjJ3hkOJZVgMCLdUYcVUGeEao95hPZc5FetfMFUO+jL4YtG
	 AFUfA+HYD87N8Iuc5OozU+fbuCElOCUcInWOzY3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 259/321] drm/msm/dp: fix the max supported bpp logic
Date: Tue, 27 Aug 2024 16:39:27 +0200
Message-ID: <20240827143848.104300672@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit d19d5b8d8f6dab942ce5ddbcf34bf7275e778250 ]

Fix the dp_panel_get_supported_bpp() API to return the minimum
supported bpp correctly for relevant cases and use this API
to correct the behavior of DP driver which hard-codes the max supported
bpp to 30.

This is incorrect because the number of lanes and max data rate
supported by the lanes need to be taken into account.

Replace the hardcoded limit with the appropriate math which accounts
for the accurate number of lanes and max data rate.

changes in v2:
	- Fix the dp_panel_get_supported_bpp() and use it
	- Drop the max_t usage as dp_panel_get_supported_bpp() already
	  returns the min_bpp correctly now

changes in v3:
	- replace min_t with just min as all params are u32

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/43
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> # SM8350-HDK
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/607073/
Link: https://lore.kernel.org/r/20240805202009.1120981-1-quic_abhinavk@quicinc.com
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_panel.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index d38086650fcf7..f2cc0cc0b66b7 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -113,22 +113,22 @@ static int dp_panel_read_dpcd(struct dp_panel *dp_panel)
 static u32 dp_panel_get_supported_bpp(struct dp_panel *dp_panel,
 		u32 mode_edid_bpp, u32 mode_pclk_khz)
 {
-	struct dp_link_info *link_info;
+	const struct dp_link_info *link_info;
 	const u32 max_supported_bpp = 30, min_supported_bpp = 18;
-	u32 bpp = 0, data_rate_khz = 0;
+	u32 bpp, data_rate_khz;
 
-	bpp = min_t(u32, mode_edid_bpp, max_supported_bpp);
+	bpp = min(mode_edid_bpp, max_supported_bpp);
 
 	link_info = &dp_panel->link_info;
 	data_rate_khz = link_info->num_lanes * link_info->rate * 8;
 
-	while (bpp > min_supported_bpp) {
+	do {
 		if (mode_pclk_khz * bpp <= data_rate_khz)
-			break;
+			return bpp;
 		bpp -= 6;
-	}
+	} while (bpp > min_supported_bpp);
 
-	return bpp;
+	return min_supported_bpp;
 }
 
 static int dp_panel_update_modes(struct drm_connector *connector,
@@ -421,8 +421,9 @@ int dp_panel_init_panel_info(struct dp_panel *dp_panel)
 				drm_mode->clock);
 	drm_dbg_dp(panel->drm_dev, "bpp = %d\n", dp_panel->dp_mode.bpp);
 
-	dp_panel->dp_mode.bpp = max_t(u32, 18,
-				min_t(u32, dp_panel->dp_mode.bpp, 30));
+	dp_panel->dp_mode.bpp = dp_panel_get_mode_bpp(dp_panel, dp_panel->dp_mode.bpp,
+						      dp_panel->dp_mode.drm_mode.clock);
+
 	drm_dbg_dp(panel->drm_dev, "updated bpp = %d\n",
 				dp_panel->dp_mode.bpp);
 
-- 
2.43.0



