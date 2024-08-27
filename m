Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1321F73466;
	Tue, 27 Aug 2024 14:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770604; cv=none; b=dYuqxjo8Qx7UptW3taLOtV2sQFb1tP12TGJLq+MjflZgctj7WzbzuAinPn+7omSt3F058kzQXAI7qrVakjyX0n+8SDMUgT7UKFIif7UAmw1MTokL0CXWYZMrkl1xgSbJVjt0zc6utJnDSYfpHO/BDuImYJQt/kYdUyvrfL3bZPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770604; c=relaxed/simple;
	bh=Ag3eIwgjMl+9tscpOlqFtNicUWgQXW/U0PpLC13H2bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUkQM+h57t/fNl9MccoQo+yUMHhjZ/3j4To4WFo7uLLh9wmVZe8jzNnoREN/huxsFHsLpHedLODs8Z/vJFWxGxM3kJ7TvRR/LzRIfLJ0+YfInBnCTt8lUgzGvLFlhPYetnmmXb7O/c5Y6kB8bq1Fls4DdbEmXbI3P3PdCLXRhH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhLePJVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhLePJVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2EEC4FE01;
	Tue, 27 Aug 2024 14:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770603;
	bh=Ag3eIwgjMl+9tscpOlqFtNicUWgQXW/U0PpLC13H2bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhLePJVJVj5R0vKYQSqYGQ7r7XzhQb7wiRU4OrrigObddavlfw8hnseLldtMR4W0g
	 N5NYlPbHObUpKx/3sFPtM1q6VVmZmvLMPWhFDyoxxun93qF+glqys5wi/rvLuofZ5o
	 FvbzY27a7DSQSmb8myG3EgvLBQ5HLHPqY1tsoR+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 278/341] drm/msm/dp: fix the max supported bpp logic
Date: Tue, 27 Aug 2024 16:38:29 +0200
Message-ID: <20240827143853.977229801@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index 86a8e06c7a60f..d26589eb8b218 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -136,22 +136,22 @@ static int dp_panel_read_dpcd(struct dp_panel *dp_panel)
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
@@ -444,8 +444,9 @@ int dp_panel_init_panel_info(struct dp_panel *dp_panel)
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



