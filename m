Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3F53546E1;
	Sat, 12 Sep 2026 10:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209183; cv=none; b=jbkl76uFs8u3RIr9NAgeFQDPNi444V4cl0IV35Il42YwhwzlyO5KSQewfntZfutFKJAAfwveJDrkYaMUjvsIxRJLBeU8Gg8Tgnf0c1xDUX+t1wK7lwiYLfhSi5kCQDs/2I9utV0dy9xk9gkLxHOzF3QD4o13Z9vCsZCNJb6fyoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209183; c=relaxed/simple;
	bh=lf7pZNLC/0XZj+N8CZ15rX5ujeImNIqs+NUMEepNXzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mzd9kGtTXpgxOcAvaddmjkKrgVp8roiVH4jCLgIkSWzHWesQsLTO2ghUmeL4OA5xU2Xi3UEYZSyYN325ZcGiiHPhvnWV8vy5g8ml75qTCqf6UqLrJ8CfC6FiEr/idjmUwRpLaCneBgF0KyVAWGK7OdlYqvLgDtMsg825uc2jS0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qx7Kp5zj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qx7Kp5zj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DC91F00893;
	Sat, 12 Sep 2026 10:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209182;
	bh=LJi/FuXEFBQgNSKNB2hoK+ZwXoFzEiMknjqOSsAA4Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qx7Kp5zjZ9LGDH37ym1X+ekYKMNnpiEqrwOfVz6FVVrTTia2AcubynQB2RmOOrr9p
	 IWTn2fGdvPIydKWDTDgLR7ljAK9UMVbxkFfSQnuG+5JnByNVr9drwDazJkkapF4Sxq
	 vRuCUqFLli6oqvMXi1KOltCPhtwutTpfdaHIvnfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0768/1518] drm/msm/dp: do not reject wide-bus modes while a YUV420 mode is active
Date: Sat, 12 Sep 2026 08:48:57 +0200
Message-ID: <20260912065640.807434739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit bd926e62d355879133452bc3889447f8e89757f2 ]

msm_dp_bridge_mode_valid() halves the candidate mode's pixel clock when
the sink either uses YUV 420 output or drives the wide bus, so that modes
relying on those to stay under DP_MAX_PIXEL_CLK_KHZ are accepted. The
wide bus part is queried through msm_dp_wide_bus_available(), which
returns false whenever the currently committed mode uses YUV 420 output:
it inspects the stored msm_dp_mode.out_fmt_is_yuv_420 of the active mode,
not the mode being validated.

Consequently, while a YUV 420 mode is active, an RGB mode that needs the
wide bus to fit under DP_MAX_PIXEL_CLK_KHZ has its pixel clock left
un-halved and is wrongly rejected as MODE_CLOCK_HIGH.

The candidate mode's YUV 420 status is already evaluated as is_yuv_420,
and the wide bus is disabled precisely for YUV 420 output, so halving the
pixel clock for either case is equivalent to halving it when the
candidate is YUV 420 or the controller supports the wide bus. Test
wide_bus_supported directly, so the decision no longer depends on the
format of the active mode.

Fixes: df9cf852ca30 ("drm/msm/dp: account for widebus and yuv420 during mode validation")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/741740/
Link: https://lore.kernel.org/r/20260722-drm-msm-display-interface-v1-15-368c10fe62fd@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 5b630dbb16952..68043dbe72bfa 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -951,7 +951,7 @@ enum drm_mode_status msm_dp_bridge_mode_valid(struct drm_bridge *bridge,
 	if (is_yuv_420 && !msm_dp_display->panel->vsc_sdp_supported)
 		return MODE_NO_420;
 
-	if (is_yuv_420 || msm_dp_wide_bus_available(dp))
+	if (is_yuv_420 || msm_dp_display->wide_bus_supported)
 		mode_pclk_khz /= 2;
 
 	if (mode_pclk_khz > DP_MAX_PIXEL_CLK_KHZ)
-- 
2.53.0



