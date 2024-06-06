Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EDB198A35;
	Thu,  6 Jun 2024 14:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683391; cv=none; b=kQhoJGXXyd9KrUBE3zCPIxjJImb5kfswMnhBd8OLBiiy0AVxnn/4brApEuZENU0KYsC8Zap071eSDMdT60halmfBHyNtSEa5ePODn6kysjuFD25iuXZ8MlmedqDl35jCV+GaGCbpJ0qA1ypQnwE/UnMD5R2LYXxOpbCSAPYLHTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683391; c=relaxed/simple;
	bh=ehnc0Hv74C3a1vzgJVeKlGnQpX0Ivk3Gsi2XLHj3bzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTN6KwipeL+bcpbVZMn+i8BZ29Ug14GNOCDSKTY1XTAO2SQm6Syn5xySegHJeHkVH9f3uUgyLVitZDuNEOquH0RcSGS/1O5gYoIC8IeVkz26jXCBbywE9eLRkAfoYr7DXkJHQjJZyGtIFmYArRUSoxNKZOX9YXY3gccnj/zqH6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrirLuPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrirLuPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624D5C2BD10;
	Thu,  6 Jun 2024 14:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683391;
	bh=ehnc0Hv74C3a1vzgJVeKlGnQpX0Ivk3Gsi2XLHj3bzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrirLuPWpWdWLAWNm7t9wHLty8ckGu3TsvK5IExnaEceRx+byMLvZbTH8A27BDQMb
	 cl//dbpbFOxrQZrvzRSdKBzrydK+U8wMM4dlWKeBCBqCrf4mmbuYhvuB41how1zAmi
	 NflvivRWDUkwo3jvmMVXzODTsFID6ebPZ+S7V3eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 331/744] drm/rockchip: vop2: Do not divide height twice for YUV
Date: Thu,  6 Jun 2024 16:00:03 +0200
Message-ID: <20240606131743.057470888@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Detlev Casanova <detlev.casanova@collabora.com>

[ Upstream commit e80c219f52861e756181d7f88b0d341116daac2b ]

For the cbcr format, gt2 and gt4 are computed again after src_h has been
divided by vsub.

As src_h as already been divided by 2 before, introduce cbcr_src_h and
cbcr_src_w to keep a copy of those values to be used for cbcr gt2 and
gt4 computation.

This fixes yuv planes being unaligned vertically when down scaling to
1080 pixels from 2160.

Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Acked-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240414182706.655270-1-detlev.casanova@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 22 +++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index c306806aa3dea..c5ec4169616de 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -609,6 +609,8 @@ static void vop2_setup_scale(struct vop2 *vop2, const struct vop2_win *win,
 	const struct drm_format_info *info;
 	u16 hor_scl_mode, ver_scl_mode;
 	u16 hscl_filter_mode, vscl_filter_mode;
+	uint16_t cbcr_src_w = src_w;
+	uint16_t cbcr_src_h = src_h;
 	u8 gt2 = 0;
 	u8 gt4 = 0;
 	u32 val;
@@ -666,27 +668,27 @@ static void vop2_setup_scale(struct vop2 *vop2, const struct vop2_win *win,
 	vop2_win_write(win, VOP2_WIN_YRGB_VSCL_FILTER_MODE, vscl_filter_mode);
 
 	if (info->is_yuv) {
-		src_w /= info->hsub;
-		src_h /= info->vsub;
+		cbcr_src_w /= info->hsub;
+		cbcr_src_h /= info->vsub;
 
 		gt4 = 0;
 		gt2 = 0;
 
-		if (src_h >= (4 * dst_h)) {
+		if (cbcr_src_h >= (4 * dst_h)) {
 			gt4 = 1;
-			src_h >>= 2;
-		} else if (src_h >= (2 * dst_h)) {
+			cbcr_src_h >>= 2;
+		} else if (cbcr_src_h >= (2 * dst_h)) {
 			gt2 = 1;
-			src_h >>= 1;
+			cbcr_src_h >>= 1;
 		}
 
-		hor_scl_mode = scl_get_scl_mode(src_w, dst_w);
-		ver_scl_mode = scl_get_scl_mode(src_h, dst_h);
+		hor_scl_mode = scl_get_scl_mode(cbcr_src_w, dst_w);
+		ver_scl_mode = scl_get_scl_mode(cbcr_src_h, dst_h);
 
-		val = vop2_scale_factor(src_w, dst_w);
+		val = vop2_scale_factor(cbcr_src_w, dst_w);
 		vop2_win_write(win, VOP2_WIN_SCALE_CBCR_X, val);
 
-		val = vop2_scale_factor(src_h, dst_h);
+		val = vop2_scale_factor(cbcr_src_h, dst_h);
 		vop2_win_write(win, VOP2_WIN_SCALE_CBCR_Y, val);
 
 		vop2_win_write(win, VOP2_WIN_VSD_CBCR_GT4, gt4);
-- 
2.43.0



