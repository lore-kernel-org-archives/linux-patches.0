Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A1348EC6C;
	Wed, 23 Sep 2026 14:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173031; cv=none; b=dSGGpIk1O6RUi6MmTFkfOXOrZ9SqUNbVdUAMWntdDNjTwZlXu7IjDfH+zLPwzz+ANi+F+DwGSlMpoCif4mD6H8dyw7cXvBBDFpTpzEs+T8NGJ+SDQJvU60M9vynnH3vKetsXnNlSVTgcCC2vBmF/Zn/XsKfcZ793OhOCldxGQ1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173031; c=relaxed/simple;
	bh=6ZSNWLm1nzCuvCXlcbXH74jP4CUptpooVRureiZggRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mshcisCcXAKlsXKI2SjlusfZKYqQlgGxuJPxtiAI0+FK6fov9tWyiWmiZLZLwLxHsQZJ2SLOhfluCiM+Hhd+lygbCWsbjl/GVb7B7Py9uv8WmbGfVZqkhwZfOTdHYrUTyBCN13ta3gfA5ZKc0tjDAFed2oTzYlZlov4335lUNp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwSsZsE7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwSsZsE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF551F000FF;
	Wed, 23 Sep 2026 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173029;
	bh=fcV21FrfaKl8zf1GtAbjxAed/hfiC9sURpcn2nHw3n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwSsZsE7AzW/qZAIr9eP9XUyhs3FYiCrzXjRqiAIBgOH1LoCqq8GQvn4MHuGWQmiu
	 /6pXHq9IYSrxf6uJtPHt/6OmMtZoIi4cg1R3uw6xoWeRhL3jQis66hn3CRSc38iqF5
	 n0lKWVM8HPeqhoKTuhapuowvrMvc5htBWSqmMnxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bright <william.bright@imd-tec.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 130/438] drm/msm/dp: fix link bandwidth check when wide bus is enabled
Date: Wed, 23 Sep 2026 16:02:31 +0200
Message-ID: <20260923140648.149974757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index a2f799cf50f63..22eade11c6150 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -698,6 +698,7 @@ enum drm_mode_status msm_dp_bridge_mode_valid(struct drm_bridge *bridge,
 	u32 mode_rate_khz = 0, supported_rate_khz = 0, mode_bpp = 0;
 	struct msm_dp *dp;
 	int mode_pclk_khz = mode->clock;
+	int link_pclk_khz;
 	bool is_yuv_420;
 
 	dp = to_dp_bridge(bridge)->msm_dp_display;
@@ -719,6 +720,8 @@ enum drm_mode_status msm_dp_bridge_mode_valid(struct drm_bridge *bridge,
 	if (is_yuv_420 && !msm_dp_display->panel->vsc_sdp_supported)
 		return MODE_NO_420;
 
+	link_pclk_khz = is_yuv_420 ? mode_pclk_khz / 2 : mode_pclk_khz;
+
 	if (is_yuv_420 || msm_dp_display->wide_bus_supported)
 		mode_pclk_khz /= 2;
 
@@ -730,9 +733,9 @@ enum drm_mode_status msm_dp_bridge_mode_valid(struct drm_bridge *bridge,
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



