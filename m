Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626DE4D6C2E;
	Wed, 30 Sep 2026 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791977; cv=none; b=ZK1+QogwOKnNYIsC8otaloRa+yGv/q2JykUJRJZev3Hch8K/g4/1llNfwleVCik4rrsBFyyDHLXS0AgRNxJubvC2Sh5MNh7XSnPQBgCvae+IIUZ49vjvUzY8Om92e7LyYboIGTnzkk88S9sWC0K6+K5ifCTYAHGTWQY/zKeS4U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791977; c=relaxed/simple;
	bh=CYZipjzFW4aCRDWXNrKVB9oYRtQ8UEk+6IDIMi1Qx9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUNb8MoRz6rO1w4Q/tPvG4diD9w4MtNx4P3BpR6YDuaA0ZpxObSJGVUkql6S1PLiyapki9j4l0bu1aT1nXCWHFhFOQ/n68O3UI/4zbfeMP9SZcM4V5Tk1R88lvgRD4Z9QLPqzk5Fxxv1bapkCAKN93Am9h2n0S/ZGVHDsEq6jEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2E4AHAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2E4AHAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE921F000FF;
	Wed, 30 Sep 2026 18:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791976;
	bh=2w9ipaupr9VUQltuPtk0Sj/8XKCLeIV+uLSO/dMokAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2E4AHAq/GiAgiM4qZ3VWrpbzpY9xYEPLyxqU1VImSljkG2BwqSxhKDe50BP03TEv
	 vx9umzFd+yWvB06EJWfi2HBlsJw/zcqI/Yc7oWPM0M5cyXusnsDl/nS5PZrLP9NZoR
	 3gImNV/wzalTStgTjb9gYVYHftfDmRkIQ/ssI00g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 491/752] drm/msm/dsi: correct byte intf clock rate for 14nm DSI PHY
Date: Wed, 30 Sep 2026 17:26:01 +0200
Message-ID: <20260930152408.890842048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1d5e01dfa3410bc94476e3050485852d6bba3fe0 ]

According to the vendor kernel, byte intf clock rate should be a half of
the byte clock only when DSI PHY version is above 2.0 (in other words,
10nm PHYs and later) and only if PHY is used in D-PHY mode. Currently
MSM DSI code handles only the second part of the clause (C-PHY vs
D-PHY), skipping DSI PHY version check, which causes issues on some of
14nm DSI PHY platforms (e.g. qcm2290).

Move divisor selection to DSI PHY code, pass selected divisor through
shared timings and set byte intf clock rate accordingly.

Cc: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Konrad Dybcio <konrad.dybcio@linaro.org> # SM6115P J606F
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/519006/
Link: https://lore.kernel.org/r/20230118130027.2345719-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: 2028280686f4 ("drm/msm/dsi: round the byte clock rate after reparenting to the PHY PLL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi.h         |  1 +
 drivers/gpu/drm/msm/dsi/dsi_host.c    | 14 ++++++--------
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c |  4 ++++
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi.h b/drivers/gpu/drm/msm/dsi/dsi.h
index a63666e59d19e..36a17039f2a4f 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.h
+++ b/drivers/gpu/drm/msm/dsi/dsi.h
@@ -157,6 +157,7 @@ struct msm_dsi_phy_shared_timings {
 	u32 clk_post;
 	u32 clk_pre;
 	bool clk_pre_inc_by_2;
+	bool byte_intf_clk_div_2;
 };
 
 struct msm_dsi_phy_clk_request {
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index dcee10eaa70ed..a617b18ae5f6c 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -116,6 +116,7 @@ struct msm_dsi_host {
 	struct clk *byte_intf_clk;
 
 	unsigned long byte_clk_rate;
+	unsigned long byte_intf_clk_rate;
 	unsigned long pixel_clk_rate;
 	unsigned long esc_clk_rate;
 
@@ -498,7 +499,6 @@ int msm_dsi_runtime_resume(struct device *dev)
 
 int dsi_link_clk_set_rate_6g(struct msm_dsi_host *msm_host)
 {
-	unsigned long byte_intf_rate;
 	int ret;
 
 	DBG("Set clk rates: pclk=%lu, byteclk=%lu",
@@ -518,13 +518,7 @@ int dsi_link_clk_set_rate_6g(struct msm_dsi_host *msm_host)
 	}
 
 	if (msm_host->byte_intf_clk) {
-		/* For CPHY, byte_intf_clk is same as byte_clk */
-		if (msm_host->cphy_mode)
-			byte_intf_rate = msm_host->byte_clk_rate;
-		else
-			byte_intf_rate = msm_host->byte_clk_rate / 2;
-
-		ret = clk_set_rate(msm_host->byte_intf_clk, byte_intf_rate);
+		ret = clk_set_rate(msm_host->byte_intf_clk, msm_host->byte_intf_clk_rate);
 		if (ret) {
 			pr_err("%s: Failed to set rate byte intf clk, %d\n",
 			       __func__, ret);
@@ -2426,6 +2420,10 @@ int msm_dsi_host_power_on(struct mipi_dsi_host *host,
 		goto unlock_ret;
 	}
 
+	msm_host->byte_intf_clk_rate = msm_host->byte_clk_rate;
+	if (phy_shared_timings->byte_intf_clk_div_2)
+		msm_host->byte_intf_clk_rate /= 2;
+
 	msm_dsi_sfpb_config(msm_host, true);
 
 	ret = dsi_host_regulator_enable(msm_host);
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
index 6b9a9e56df372..05f6f499f17d8 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -350,6 +350,8 @@ int msm_dsi_dphy_timing_calc_v3(struct msm_dsi_dphy_timing *timing,
 		timing->shared_timings.clk_pre_inc_by_2 = 0;
 	}
 
+	timing->shared_timings.byte_intf_clk_div_2 = true;
+
 	timing->ta_go = 3;
 	timing->ta_sure = 0;
 	timing->ta_get = 4;
@@ -454,6 +456,8 @@ int msm_dsi_dphy_timing_calc_v4(struct msm_dsi_dphy_timing *timing,
 	tmax = 255;
 	timing->shared_timings.clk_pre = DIV_ROUND_UP((tmax - tmin) * 125, 10000) + tmin;
 
+	timing->shared_timings.byte_intf_clk_div_2 = true;
+
 	DBG("%d, %d, %d, %d, %d, %d, %d, %d, %d, %d",
 		timing->shared_timings.clk_pre, timing->shared_timings.clk_post,
 		timing->clk_zero, timing->clk_trail, timing->clk_prepare, timing->hs_exit,
-- 
2.53.0



