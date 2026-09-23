Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C9C4CCDC0;
	Wed, 23 Sep 2026 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174524; cv=none; b=bbiDzPvBGq7Eg0XgYxE6xmZWJ4dnr9XK61+PHihTBvQZ9W5ES6kSqTWkrQHRLR389xLfY4paogsDlleMzdCn5Nyq7FPrhSRj1HGFrgjKEIt+8MIJKUUgLZLrbUdd7KttOymgZPNi/pY2tVYA4L5fzai5nPvryP/9DKdsNX1fXUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174524; c=relaxed/simple;
	bh=9Nzz6ZgG0AWRN6E6YrNDtRT/8ekgkCulniKPoQnnR6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ph9N3On/VEHhD+C3NNzTqX4d6I2S4nX0G4+2Xbjg9Ktgj8nXSIIYjbYycYmMzjBg7D69OmR5S0vO9q3J4qnwm5oau574pI5FPKcxM3d38FTQlDQmrN281l1al6o8pyilyvOg65lHY8+hfOJscP3kAppiCUmm6urxRc6+CjZmyB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oO4LM7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oO4LM7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57A21F000FF;
	Wed, 23 Sep 2026 14:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174522;
	bh=BBPdaSzG4aVhBlyEf0S5kWRIDeSlpaipAplL5i6b914=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0oO4LM7oif4EXa8gfe8za03ihxuRUhpokLP0m/eC8XWgvtc0KCKFeS4cOqV0ArVit
	 7jUyjtgioqLbTVPP4WHZOi6akatSroNtA55kR/yv8M22ofdS5T0lBlM9uX5zOB7uOt
	 ugWR/z5EDd4jB3OZI7nI/0FNmGPG21fJlldbJJ9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bright <william.bright@imd-tec.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/398] drm/msm/dp: fix link bandwidth check when wide bus is enabled
Date: Wed, 23 Sep 2026 16:03:03 +0200
Message-ID: <20260923140646.266917777@linuxfoundation.org>
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

From: William Bright <william.bright@imd-tec.com>

[ Upstream commit 58995b11dfb7dda095d23f22fa4dc79b923b5adf ]

msm_dp_display_mode_valid() halves the pixel clock when either YUV420 or
wide bus is in use, then uses that halved value both for the controller
pixel clock limit and for the DP link bandwidth check.

Only YUV420 halves the data crossing the link. Wide bus widens the
internal DPU to DP interface to two pixels per clock, halving the
controller clock. Every pixel is still transmitted, so the link
bandwidth requirement remains.

As a result, modes needing up to twice the available link bandwidth pass
validation. On the IMDT QCS8550 SBC (rev5 with CYPD6125), where DP runs
over USB-C alt mode where only two lanes are available, 3840x2160@60 was
accepted despite needing 9.6 Gbps against the 8.64 Gbps the link can
carry.

Use a separate link pixel clock that is only halved for YUV420 for the
bandwidth calculation, leaving the wide bus halving to apply solely to
the controller pixel clock limit. With this, 4k@60 is correctly rejected
and 4k@30 selected instead.

Fixes: df9cf852ca30 ("drm/msm/dp: account for widebus and yuv420 during mode validation")
Assisted-by: Claude:claude-opus-5
Signed-off-by: William Bright <william.bright@imd-tec.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/746145/
Link: https://lore.kernel.org/r/20260812-msm-dp-link-bw-v1-1-b0e3ce1190be@imd-tec.com
[DB: dropped useless comment]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 0f6e4a1072a8f..131753ba57b5e 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -930,6 +930,7 @@ enum drm_mode_status msm_dp_bridge_mode_valid(struct drm_bridge *bridge,
 	u32 mode_rate_khz = 0, supported_rate_khz = 0, mode_bpp = 0;
 	struct msm_dp *dp;
 	int mode_pclk_khz = mode->clock;
+	int link_pclk_khz;
 	bool is_yuv_420;
 
 	dp = to_dp_bridge(bridge)->msm_dp_display;
@@ -951,6 +952,8 @@ enum drm_mode_status msm_dp_bridge_mode_valid(struct drm_bridge *bridge,
 	if (is_yuv_420 && !msm_dp_display->panel->vsc_sdp_supported)
 		return MODE_NO_420;
 
+	link_pclk_khz = is_yuv_420 ? mode_pclk_khz / 2 : mode_pclk_khz;
+
 	if (is_yuv_420 || msm_dp_display->wide_bus_supported)
 		mode_pclk_khz /= 2;
 
@@ -962,9 +965,9 @@ enum drm_mode_status msm_dp_bridge_mode_valid(struct drm_bridge *bridge,
 		mode_bpp = default_bpp;
 
 	mode_bpp = msm_dp_panel_get_mode_bpp(msm_dp_display->panel,
-			mode_bpp, mode_pclk_khz);
+			mode_bpp, link_pclk_khz);
 
-	mode_rate_khz = mode_pclk_khz * mode_bpp;
+	mode_rate_khz = link_pclk_khz * mode_bpp;
 	supported_rate_khz = link_info->num_lanes * link_info->rate * 8;
 
 	if (mode_rate_khz > supported_rate_khz)
-- 
2.53.0



