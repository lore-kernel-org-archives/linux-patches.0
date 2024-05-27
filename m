Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A71C17E90E;
	Mon, 27 May 2024 19:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837187; cv=none; b=IQMIU2LWgcO480wudfjfmoq/CqxZ4/c1H7DaxhA4oEDyNEVL7LvR4JEGZkvdg06qkEZowhU73WLkVm1yaqcHWfT9PQB7giwzhHYPOCYKbH+UprMQD2Mnu6jjMGET1zj/sRimMlTiBbp55EKoQHDV9cNlQbzonqZxw+E3AE9pcwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837187; c=relaxed/simple;
	bh=QzgTE8oiDVdUyPeE656PkenTupnZI1ZKbCDYhFeyrzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujtIh2Uo5SoQimQ3jPSRRIuTC0f10htzJGMZ5pvmv/hvExZP8YlWw8HVgvqboqBheECXwcTxAK3i51pPXImPFR7BhPpPno77rQYfSESgGzlqRwsm5F+vDujxgPMBcNllGBcWTr+aPtudRQT6qg31L9pCRAvEkOY+kQ+vtFxFoYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFouv/hl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFouv/hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63B7C2BBFC;
	Mon, 27 May 2024 19:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837187;
	bh=QzgTE8oiDVdUyPeE656PkenTupnZI1ZKbCDYhFeyrzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFouv/hl+mFoSodY1HpjluS6e9ox2NbCf3Gwxyq4LH64Q7QKUHJJO75o59c1aMnk3
	 IVAfOENsvLSo3/nt1EPDbYGS3VLyDPgN5lpx+bRaoUIbNlDlc14hyBXfNY75SEDSfx
	 8sWQjfFH6vDf3lg/rY/XN0X5TwSsZ5rn/I/4FdCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 343/427] drm/rockchip: vop2: Do not divide height twice for YUV
Date: Mon, 27 May 2024 20:56:30 +0200
Message-ID: <20240527185633.036014922@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index fdd768bbd487c..62ebbdb16253d 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -706,6 +706,8 @@ static void vop2_setup_scale(struct vop2 *vop2, const struct vop2_win *win,
 	const struct drm_format_info *info;
 	u16 hor_scl_mode, ver_scl_mode;
 	u16 hscl_filter_mode, vscl_filter_mode;
+	uint16_t cbcr_src_w = src_w;
+	uint16_t cbcr_src_h = src_h;
 	u8 gt2 = 0;
 	u8 gt4 = 0;
 	u32 val;
@@ -763,27 +765,27 @@ static void vop2_setup_scale(struct vop2 *vop2, const struct vop2_win *win,
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



