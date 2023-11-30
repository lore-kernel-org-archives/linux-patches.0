Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035D754FBF;
	Thu, 30 Nov 2023 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1If5j8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395C9C433C8;
	Thu, 30 Nov 2023 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361905;
	bh=31xIXyZc/NlyjtpbvORBFARyCcqy6qiJ1xVRaePsV0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1If5j8lWMKfaeprvuRt75N3E9i04Ds+WFva7menWzRZwGgE+Is4LwpLJ24lQeHPD
	 ISS6aIW3E4sYtUNO6P9wXxqsRNmtp5b1w76bJgv51Tl/e127CgO704S9KrtHrrKCwF
	 27Hy5VsaCbyTlsmj0ECPX4aPLfqmGV6vrEUGbb/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Diederik de Haas <didi.debian@cknow.org>,
	Christopher Obbard <chris.obbard@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/69] drm/rockchip: vop: Fix color for RGB888/BGR888 format on VOP full
Date: Thu, 30 Nov 2023 16:22:07 +0000
Message-ID: <20231130162133.417222719@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit bb0a05acd6121ff0e810b44fdc24dbdfaa46b642 ]

Use of DRM_FORMAT_RGB888 and DRM_FORMAT_BGR888 on e.g. RK3288, RK3328
and RK3399 result in wrong colors being displayed.

The issue can be observed using modetest:

  modetest -s <connector_id>@<crtc_id>:1920x1080-60@RG24
  modetest -s <connector_id>@<crtc_id>:1920x1080-60@BG24

Vendor 4.4 kernel apply an inverted rb swap for these formats on VOP
full framework (IP version 3.x) compared to VOP little framework (2.x).

Fix colors by applying different rb swap for VOP full framework (3.x)
and VOP little framework (2.x) similar to vendor 4.4 kernel.

Fixes: 85a359f25388 ("drm/rockchip: Add BGR formats to VOP")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Tested-by: Diederik de Haas <didi.debian@cknow.org>
Reviewed-by: Christopher Obbard <chris.obbard@collabora.com>
Tested-by: Christopher Obbard <chris.obbard@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20231026191500.2994225-1-jonas@kwiboo.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index e53b1ecbd7bc0..c7106f1165466 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -249,14 +249,22 @@ static inline void vop_cfg_done(struct vop *vop)
 	VOP_REG_SET(vop, common, cfg_done, 1);
 }
 
-static bool has_rb_swapped(uint32_t format)
+static bool has_rb_swapped(uint32_t version, uint32_t format)
 {
 	switch (format) {
 	case DRM_FORMAT_XBGR8888:
 	case DRM_FORMAT_ABGR8888:
-	case DRM_FORMAT_BGR888:
 	case DRM_FORMAT_BGR565:
 		return true;
+	/*
+	 * full framework (IP version 3.x) only need rb swapped for RGB888 and
+	 * little framework (IP version 2.x) only need rb swapped for BGR888,
+	 * check for 3.x to also only rb swap BGR888 for unknown vop version
+	 */
+	case DRM_FORMAT_RGB888:
+		return VOP_MAJOR(version) == 3;
+	case DRM_FORMAT_BGR888:
+		return VOP_MAJOR(version) != 3;
 	default:
 		return false;
 	}
@@ -998,7 +1006,7 @@ static void vop_plane_atomic_update(struct drm_plane *plane,
 	VOP_WIN_SET(vop, win, dsp_info, dsp_info);
 	VOP_WIN_SET(vop, win, dsp_st, dsp_st);
 
-	rb_swap = has_rb_swapped(fb->format->format);
+	rb_swap = has_rb_swapped(vop->data->version, fb->format->format);
 	VOP_WIN_SET(vop, win, rb_swap, rb_swap);
 
 	/*
-- 
2.42.0



