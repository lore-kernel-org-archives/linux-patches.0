Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1F65326C5;
	Wed, 23 Sep 2026 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174478; cv=none; b=VbkF9K431uEgSxeUzFRZN+6fLT9ZZSDH4bA595A6l2NZBX4TO+5U3cQwJE8yIHZveHwnuy/OHjsIaL6h+JigGwnUGq3ZSjKPULxc10ZplSeYC9DMSZC2xeDKN90Kw9n0CP+TEmO5KdNly5AlbwGteBvWhoi+LFY5G5fogXMW/88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174478; c=relaxed/simple;
	bh=Tfio64mTRzQWjv+OIyo8BYqdyJg8iGjg6P8hJvFqX3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0v9xn05/PEjCwn0QKvmgEiKWT9PZIFDf53wPdZN9JI4q/ng0IFEv3w65PikoGBVMJnXK3QlXZ9qywpkH2YJQuolVU1bl6kjT6Jgh8f7z9yHktb2y0PdW72+0d1dKBO1s6WK0e9DVSzGX2B714dZFsmbr5zeBadODyYMkHSC1cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xvxn6ivQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xvxn6ivQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349581F000FF;
	Wed, 23 Sep 2026 14:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174476;
	bh=aSGLRdzwjAUXdqwB22od3edzTT4YjvGP3Adw7B92eUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xvxn6ivQvpEHAErMscfDS5YSNZf8f1OFGGkTk6+UFjd0mdmjnwK7xrLoibZZVVpWy
	 veoAs0jhPbYZcZvLSdV0Nx3X1h0WvurMpE/K2NDmHHfBYkfbXwhqd4aPl8eOcvk9ZX
	 Z7ggw7eW3KjNFtiXzIKHXb1xDU6v/kUsybiu61xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/398] drm/msm/dsi: round the byte clock rate after reparenting to the PHY PLL
Date: Wed, 23 Sep 2026 16:03:21 +0200
Message-ID: <20260923140646.729486104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 2028280686f4fa78e2f1f6dede4b6c1fd782b9e3 ]

DSI 6G v2.9 hosts (SM8650, SM8750, Kaanapali, etc.) reparent the byte and
pixel RCGs to the DSI PHY PLL at runtime from
dsi_link_clk_set_rate_6g_v2_9(), after the PHY has been enabled. However
dsi_calc_clk_rate_6g() runs earlier, in order to compute the bit clock
request for the PHY. At that point the byte RCG still has its reset
parent (XO), so clk_round_rate() returns a bogus rate, which then ends up
in the PHY bit clock request and the PLL gets programmed to a wrong
frequency, breaking the panel.

Move the rounding to dsi_link_clk_set_rate_6g(), which is called after
the RCGs have been reparented to the PLL. Storing the rounded rate at
this point still makes later link_clk_set_rate() calls no-ops in the
CCF. Derive the byte interface clock rate from the rounded byte clock
rate, otherwise it would keep requesting the idealized rate and
retrigger the PLL on every transfer.

Reported-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Fixes: 6cd33b6f4155 ("drm/msm/dsi: round 6G byte clock rate to the PLL-achievable value")
Assisted-by: LLM
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com> # SM6115P J606F
Tested-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/750496/
Link: https://lore.kernel.org/r/20260903-fix-eliza-dsi-v1-1-3474a6c9f2e0@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 36 ++++++++++++++++--------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 5110fe05ca841..4e93f8dd39d7d 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -129,7 +129,7 @@ struct msm_dsi_host {
 	struct clk *dsi_pll_pixel_clk;
 
 	unsigned long byte_clk_rate;
-	unsigned long byte_intf_clk_rate;
+	bool byte_intf_clk_div_2;
 	unsigned long pixel_clk_rate;
 	unsigned long esc_clk_rate;
 
@@ -381,8 +381,20 @@ int msm_dsi_runtime_resume(struct device *dev)
 
 int dsi_link_clk_set_rate_6g(struct msm_dsi_host *msm_host)
 {
+	unsigned long byte_intf_clk_rate;
+	long rounded_byte_clk_rate;
 	int ret;
 
+	rounded_byte_clk_rate = clk_round_rate(msm_host->byte_clk,
+					       msm_host->byte_clk_rate);
+	if (rounded_byte_clk_rate < 0) {
+		pr_err("%s: failed to round byte clock rate, %ld\n",
+		       __func__, rounded_byte_clk_rate);
+		return rounded_byte_clk_rate;
+	}
+
+	msm_host->byte_clk_rate = rounded_byte_clk_rate;
+
 	DBG("Set clk rates: pclk=%lu, byteclk=%lu",
 	    msm_host->pixel_clk_rate, msm_host->byte_clk_rate);
 
@@ -400,7 +412,11 @@ int dsi_link_clk_set_rate_6g(struct msm_dsi_host *msm_host)
 	}
 
 	if (msm_host->byte_intf_clk) {
-		ret = clk_set_rate(msm_host->byte_intf_clk, msm_host->byte_intf_clk_rate);
+		byte_intf_clk_rate = msm_host->byte_clk_rate;
+		if (msm_host->byte_intf_clk_div_2)
+			byte_intf_clk_rate /= 2;
+
+		ret = clk_set_rate(msm_host->byte_intf_clk, byte_intf_clk_rate);
 		if (ret) {
 			pr_err("%s: Failed to set rate byte intf clk, %d\n",
 			       __func__, ret);
@@ -668,24 +684,12 @@ static void dsi_calc_pclk(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 
 int dsi_calc_clk_rate_6g(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 {
-	long rounded_byte_clk_rate;
-
 	if (!msm_host->mode) {
 		pr_err("%s: mode not set\n", __func__);
 		return -EINVAL;
 	}
 
 	dsi_calc_pclk(msm_host, is_bonded_dsi);
-
-	rounded_byte_clk_rate = clk_round_rate(msm_host->byte_clk,
-					       msm_host->byte_clk_rate);
-	if (rounded_byte_clk_rate < 0) {
-		pr_err("%s: failed to round byte clock rate, %ld\n",
-		       __func__, rounded_byte_clk_rate);
-		return rounded_byte_clk_rate;
-	}
-
-	msm_host->byte_clk_rate = rounded_byte_clk_rate;
 	msm_host->esc_clk_rate = clk_get_rate(msm_host->esc_clk);
 	return 0;
 }
@@ -2470,9 +2474,7 @@ int msm_dsi_host_power_on(struct mipi_dsi_host *host,
 		goto unlock_ret;
 	}
 
-	msm_host->byte_intf_clk_rate = msm_host->byte_clk_rate;
-	if (phy_shared_timings->byte_intf_clk_div_2)
-		msm_host->byte_intf_clk_rate /= 2;
+	msm_host->byte_intf_clk_div_2 = phy_shared_timings->byte_intf_clk_div_2;
 
 	msm_dsi_sfpb_config(msm_host, true);
 
-- 
2.53.0



