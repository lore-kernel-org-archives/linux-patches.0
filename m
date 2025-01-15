Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12D81E9912;
	Wed, 15 Jan 2025 10:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938731; cv=none; b=fzb7YLCwr103jxyC7wDxOLmDtN8rjZ5hhOeZaAoVAMJ+jPAjiz9biXMle/qAE/yUeLx1cJb+RATBmVRYYHALtU1Io1KYK57V325Rwi6pqW8JqfFy/Xw0X19adRx7+iLoqYIy2cuN1Pjm7yiQeErwwlzWgzMiwnPCDA8Puj67Gjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938731; c=relaxed/simple;
	bh=srHnc64o4BLqhMG7lTwQfGzEftRFW9cKSfysN0nyF6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVxGqGiCs2SchThZ9Eq652YZXrVi+9v+/58EuBAaKbPSv+nRrZFaZKTlrEHU4aTOLb33dToxL3Q2stbZcgyYWiuXn2XNY2EEPEGfcN9M35FxKrveCqil/csaRTKLqGW60iSXsMQeBafBRYPVfm8Mcl8rIb8Es54T+bC8l1jYro8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYLL8C8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYLL8C8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBB8C4CEDF;
	Wed, 15 Jan 2025 10:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938731;
	bh=srHnc64o4BLqhMG7lTwQfGzEftRFW9cKSfysN0nyF6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYLL8C8AAg+biULstYP9x6aEwmGDZ3ScLkF7yhXJhA3FKLofUDWzSL+/121FyoIJc
	 K9Il4TogS9QHUgwNwNOl1j2k95vXyLJ9r2mAJK0nSToKSzkqTyZTMhXRtiKwnANHhU
	 I3GNG0mR8AhC91R4vhtAy1vEDoMinBbtEh1bjVAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liankun Yang <liankun.yang@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/129] drm/mediatek: Fix YCbCr422 color format issue for DP
Date: Wed, 15 Jan 2025 11:37:04 +0100
Message-ID: <20250115103556.327114657@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 48a4defbc66c..399423cb618c 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -458,18 +458,16 @@ static int mtk_dp_set_color_format(struct mtk_dp *mtk_dp,
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
@@ -477,6 +475,11 @@ static int mtk_dp_set_color_format(struct mtk_dp *mtk_dp,
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



