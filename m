Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EA92E7F1A;
	Thu,  3 Jul 2025 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554477; cv=none; b=nwOL9AFNWW721GeKRre3tWfD2bT5xjMSxkxpHfpMNqaFxb8Fu6yucy7szRpNO1MXAEQ0VCr04p/bLjQCW3vHUkpxKx08NV37AIag0hyzTjh31plkf8Ecov9E9ZTNAG2KCYf4YagOHQBrEbAnHMoWwQ4/kay/kPAgrGcsz2B0yjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554477; c=relaxed/simple;
	bh=qIfJr8FQNb0GOjA49MnXvwUTvvmyCn/PYab47DhAh0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biu9zeL7YLbnwpZp7SqxrolSoIFA4NqiDG4W/EDbD0BGAkQrQ/b7fQnzdSNeRj5ntaxRhR2OVsk8HX4D2DLviZ6cmuYlYKacdayfTXmrf00NUDr1lxjXsf20OaYeBElHUAJVd0oXiiyaBX/WjRi3y4Dt8SKB4b6WZgQf/FZu8BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ahGSCgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ahGSCgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A7FC4CEE3;
	Thu,  3 Jul 2025 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554475;
	bh=qIfJr8FQNb0GOjA49MnXvwUTvvmyCn/PYab47DhAh0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ahGSCgioxsSKkrfEjWalU8cfMQjUENZS+TXOJ4oXzlDRBafOyO8J5hHjhwrSEMEN
	 Kzn1AlGMj2vooTdequ8KTjXOS9J1kSM825DabLwn/zlVnujZ82TN0k6l4KrQrOTZeg
	 22kZESySsv844wColoX5QDvc/7jTI3vHyFHs6hx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dale Whinham <daleyo@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/218] drm/msm/dp: account for widebus and yuv420 during mode validation
Date: Thu,  3 Jul 2025 16:42:28 +0200
Message-ID: <20250703144004.211919421@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit df9cf852ca3099feb8fed781bdd5d3863af001c8 ]

Widebus allows the DP controller to operate in 2 pixel per clock mode.
The mode validation logic validates the mode->clock against the max
DP pixel clock. However the max DP pixel clock limit assumes widebus
is already enabled. Adjust the mode validation logic to only compare
the adjusted pixel clock which accounts for widebus against the max DP
pixel clock. Also fix the mode validation logic for YUV420 modes as in
that case as well, only half the pixel clock is needed.

Cc: stable@vger.kernel.org
Fixes: 757a2f36ab09 ("drm/msm/dp: enable widebus feature for display port")
Fixes: 6db6e5606576 ("drm/msm/dp: change clock related programming for YUV420 over DP")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dale Whinham <daleyo@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/635789/
Link: https://lore.kernel.org/r/20250206-dp-widebus-fix-v2-1-cb89a0313286@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 11 ++++++-----
 drivers/gpu/drm/msm/dp/dp_drm.c     |  5 ++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index e1228fb093ee0..a5c1534eafdb1 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -928,16 +928,17 @@ enum drm_mode_status dp_bridge_mode_valid(struct drm_bridge *bridge,
 		return -EINVAL;
 	}
 
-	if (mode->clock > DP_MAX_PIXEL_CLK_KHZ)
-		return MODE_CLOCK_HIGH;
-
 	dp_display = container_of(dp, struct dp_display_private, dp_display);
 	link_info = &dp_display->panel->link_info;
 
-	if (drm_mode_is_420_only(&dp->connector->display_info, mode) &&
-	    dp_display->panel->vsc_sdp_supported)
+	if ((drm_mode_is_420_only(&dp->connector->display_info, mode) &&
+	     dp_display->panel->vsc_sdp_supported) ||
+	     msm_dp_wide_bus_available(dp))
 		mode_pclk_khz /= 2;
 
+	if (mode_pclk_khz > DP_MAX_PIXEL_CLK_KHZ)
+		return MODE_CLOCK_HIGH;
+
 	mode_bpp = dp->connector->display_info.bpc * num_components;
 	if (!mode_bpp)
 		mode_bpp = default_bpp;
diff --git a/drivers/gpu/drm/msm/dp/dp_drm.c b/drivers/gpu/drm/msm/dp/dp_drm.c
index 1b9be5bd97f12..da0176eae3fe3 100644
--- a/drivers/gpu/drm/msm/dp/dp_drm.c
+++ b/drivers/gpu/drm/msm/dp/dp_drm.c
@@ -257,7 +257,10 @@ static enum drm_mode_status edp_bridge_mode_valid(struct drm_bridge *bridge,
 		return -EINVAL;
 	}
 
-	if (mode->clock > DP_MAX_PIXEL_CLK_KHZ)
+	if (msm_dp_wide_bus_available(dp))
+		mode_pclk_khz /= 2;
+
+	if (mode_pclk_khz > DP_MAX_PIXEL_CLK_KHZ)
 		return MODE_CLOCK_HIGH;
 
 	/*
-- 
2.39.5



