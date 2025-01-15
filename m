Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BF21E9917;
	Wed, 15 Jan 2025 10:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938139; cv=none; b=b8NuCGZdbveUo5HA4tI2Te21uxJjv4xfLq6Mrjzv3KPnLAAwiBEd3HAJlYo5A0AmGTCdg9MeztbUZN9o9/W8RuF/EBT6PbEdLLvj6nKuqZeqN6AeIdnQxHHhWiBPoaln1E60YQ1Hf2hGwQp3t40xi8qSzFRZ0yYN34XtjLe8HJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938139; c=relaxed/simple;
	bh=fEVdkf6VKAIzXbSZa7fuLzpcGsYTKOYZiqF6m//OcxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHqs4k46R6p6j/mOhvo46zBgrr2wQWVVg70ZjlCXNuzAjd3LYzZ42aSz87SclY3tiHZzHW+Elvcz80tDQjyf9VCSkaH4H4A0WGMUYg0tzS1UcvBjbcri8xRVole92H7vhL+fYNtrjzrgcJQNwl8bQ7cbXMj3hRrGF8gJ1TCN5qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnY7/hpa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnY7/hpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD17C4CEE2;
	Wed, 15 Jan 2025 10:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938138;
	bh=fEVdkf6VKAIzXbSZa7fuLzpcGsYTKOYZiqF6m//OcxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnY7/hpaZNqdEO6tlLCkhKtlOrvYLkW3leqHDjDqIK5Rdw9gXO/jjFlgEoC4FQchg
	 oAucsu5GMr+HGI5pte9i0a3ak1GuUnqHy0zIjdPdqq6iKLhOimwUjb7d5z8ryHMxOa
	 k7lGxN6/TV4h8IgUZcmcPrMLjiip3xpWuC9lLyqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liankun Yang <liankun.yang@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/189] drm/mediatek: Fix YCbCr422 color format issue for DP
Date: Wed, 15 Jan 2025 11:36:00 +0100
Message-ID: <20250115103608.906127530@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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
index f2bee617f063..bcc4d3fc77d8 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -543,18 +543,16 @@ static int mtk_dp_set_color_format(struct mtk_dp *mtk_dp,
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
@@ -562,6 +560,11 @@ static int mtk_dp_set_color_format(struct mtk_dp *mtk_dp,
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



