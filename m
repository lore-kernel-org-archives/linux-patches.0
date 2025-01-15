Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10846248BA0;
	Wed, 15 Jan 2025 10:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937714; cv=none; b=UQM3uNePUoFDDK+mL1iNu/Ud1cELuvdPVRMIiZlti58WA5zKofR/273A41z3JLUtk8Ro/JJL8lkgROxK4RzrcsA/7h0T+V9N3uj5btamZqqVNNEplYx1LbjmOLs7NZaVw45M+3apzvoMpvyBV/t3Ji7mwU44MXXCwlRaeikTYRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937714; c=relaxed/simple;
	bh=2SoNho78Xcp+2iGUokUPe3V9RQfHfNOYDTqXelMEvGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lr/MEAEPlxYVnCv1BVzZrpFl7r5tdBuQaX+wUEff1toJA3kZEY0nYl1Mtc5uxvrD6BRb3BAXxbgRRGuMdlUnlLmd64JoizrXVu+/HLrf5L8uoiYVwJuI7xp3AwWat5JEKrhbXYZrEIJt6+bFdOcQTD4vbbslHIFLGw83eDqJeP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcJIz5rT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcJIz5rT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA2EC4CEE2;
	Wed, 15 Jan 2025 10:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937713;
	bh=2SoNho78Xcp+2iGUokUPe3V9RQfHfNOYDTqXelMEvGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcJIz5rTDjDYQWTOnZQCT+ODD4AHRV29ZvhgXZxWKAqIAmM103r7huRui8hfvscLY
	 Ht2mKbnbklOuq8ZuUb1SWP7jo3vyAn8cXTSHomEhKTLvh+g3KEi5Ml8bk5YS/VRZ0l
	 o+nElx+GrlpEr7d8/ZxBlSeR8UUbKqOwtHDVLpW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liankun Yang <liankun.yang@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/92] drm/mediatek: Fix YCbCr422 color format issue for DP
Date: Wed, 15 Jan 2025 11:36:47 +0100
Message-ID: <20250115103548.690721455@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liankun Yang <liankun.yang@mediatek.com>

[ Upstream commit ef24fbd8f12015ff827973fffefed3902ffd61cc ]

Setting up misc0 for Pixel Encoding Format.

According to the definition of YCbCr in spec 1.2a Table 2-96,
0x1 << 1 should be written to the register.

Use switch case to distinguish RGB, YCbCr422,
and unsupported color formats.

Fixes: f70ac097a2cf ("drm/mediatek: Add MT8195 Embedded DisplayPort driver")
Signed-off-by: Liankun Yang <liankun.yang@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241025083036.8829-2-liankun.yang@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dp.c b/drivers/gpu/drm/mediatek/mtk_dp.c
index c24eeb7ffde7..04e3f72fa232 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -457,18 +457,16 @@ static int mtk_dp_set_color_format(struct mtk_dp *mtk_dp,
 				   enum dp_pixelformat color_format)
 {
 	u32 val;
-
-	/* update MISC0 */
-	mtk_dp_update_bits(mtk_dp, MTK_DP_ENC0_P0_3034,
-			   color_format << DP_TEST_COLOR_FORMAT_SHIFT,
-			   DP_TEST_COLOR_FORMAT_MASK);
+	u32 misc0_color;
 
 	switch (color_format) {
 	case DP_PIXELFORMAT_YUV422:
 		val = PIXEL_ENCODE_FORMAT_DP_ENC0_P0_YCBCR422;
+		misc0_color = DP_COLOR_FORMAT_YCbCr422;
 		break;
 	case DP_PIXELFORMAT_RGB:
 		val = PIXEL_ENCODE_FORMAT_DP_ENC0_P0_RGB;
+		misc0_color = DP_COLOR_FORMAT_RGB;
 		break;
 	default:
 		drm_warn(mtk_dp->drm_dev, "Unsupported color format: %d\n",
@@ -476,6 +474,11 @@ static int mtk_dp_set_color_format(struct mtk_dp *mtk_dp,
 		return -EINVAL;
 	}
 
+	/* update MISC0 */
+	mtk_dp_update_bits(mtk_dp, MTK_DP_ENC0_P0_3034,
+			   misc0_color,
+			   DP_TEST_COLOR_FORMAT_MASK);
+
 	mtk_dp_update_bits(mtk_dp, MTK_DP_ENC0_P0_303C,
 			   val, PIXEL_ENCODE_FORMAT_DP_ENC0_P0_MASK);
 	return 0;
-- 
2.39.5



