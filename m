Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED72355026;
	Tue, 16 Dec 2025 11:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885882; cv=none; b=RVr3KG78Np1UDypsk7RGxFVZUN+W39SyxamwBbtRtsQ+vmtpoK/B/YUIERCZaXP0N87/oVijZqzphJb2Bm/douj/FMiOxgqkMAuXkB+8A/AwLFenoZRKNCKv6QKQcS0t/mPvAOFwqmK3ntCkc3XTZYSOrEcs8AjKJm0vvsTvNGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885882; c=relaxed/simple;
	bh=9cVnKIMInvE4M0CGzHrKKCgx13U3fH9fj53cx+BL4oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTUVmM5vMHCwNNqg4GYrlIQCHdeY/EwPwu8APcTYHe87vIOTfF7V3jkTdsE+WBIVqp3vVPfatxHOXCLP9Fgxk0b20oFEk3MsbfATwvX8Np4x/wQQRoTOJYk8Yu1r6dPSp8TrtFldEn7LA/A04QnBHYfawgBmXh7ZTaaaFqW2AUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPjw03N5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPjw03N5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B20EC4CEF1;
	Tue, 16 Dec 2025 11:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885881;
	bh=9cVnKIMInvE4M0CGzHrKKCgx13U3fH9fj53cx+BL4oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPjw03N54Sgupjmj9scbQDjjVawydv6XeNXMI6qlvKrbSVQX3YyiBj8k+r9+nvHc2
	 b0x1DX/JJ/L2n+TAWpzsMrq1qzVdioMlfI+MU7qAxbiOPo1PpxNt3NCa4Df6Nk5ILr
	 18vZFPXWldw0UbuRTr+yiWpzGMOxO5SUzjx8apKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jay Liu <jay.liu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 271/507] drm/mediatek: Fix CCORR mtk_ctm_s31_32_to_s1_n function issue
Date: Tue, 16 Dec 2025 12:11:52 +0100
Message-ID: <20251216111355.303196775@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Liu <jay.liu@mediatek.com>

[ Upstream commit 20ac36b71c53b8c36c6903b5ca87c75226700a97 ]

if matrixbit is 11,
The range of color matrix is from 0 to (BIT(12) - 1).
Values from 0 to (BIT(11) - 1) represent positive numbers,
values from BIT(11) to (BIT(12) - 1) represent negative numbers.
For example, -1 need converted to 8191.
so convert S31.32 to HW Q2.11 format by drm_color_ctm_s31_32_to_qm_n,
and set int_bits to 2.

Fixes: 738ed4156fba ("drm/mediatek: Add matrix_bits private data for ccorr")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Jay Liu <jay.liu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250921055416.25588-2-jay.liu@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_ccorr.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ccorr.c b/drivers/gpu/drm/mediatek/mtk_disp_ccorr.c
index 10d60d2c2a568..6d7bf4afa78d3 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ccorr.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ccorr.c
@@ -80,27 +80,6 @@ void mtk_ccorr_stop(struct device *dev)
 	writel_relaxed(0x0, ccorr->regs + DISP_CCORR_EN);
 }
 
-/* Converts a DRM S31.32 value to the HW S1.n format. */
-static u16 mtk_ctm_s31_32_to_s1_n(u64 in, u32 n)
-{
-	u16 r;
-
-	/* Sign bit. */
-	r = in & BIT_ULL(63) ? BIT(n + 1) : 0;
-
-	if ((in & GENMASK_ULL(62, 33)) > 0) {
-		/* identity value 0x100000000 -> 0x400(mt8183), */
-		/* identity value 0x100000000 -> 0x800(mt8192), */
-		/* if bigger this, set it to max 0x7ff. */
-		r |= GENMASK(n, 0);
-	} else {
-		/* take the n+1 most important bits. */
-		r |= (in >> (32 - n)) & GENMASK(n, 0);
-	}
-
-	return r;
-}
-
 void mtk_ccorr_ctm_set(struct device *dev, struct drm_crtc_state *state)
 {
 	struct mtk_disp_ccorr *ccorr = dev_get_drvdata(dev);
@@ -119,7 +98,7 @@ void mtk_ccorr_ctm_set(struct device *dev, struct drm_crtc_state *state)
 	input = ctm->matrix;
 
 	for (i = 0; i < ARRAY_SIZE(coeffs); i++)
-		coeffs[i] = mtk_ctm_s31_32_to_s1_n(input[i], matrix_bits);
+		coeffs[i] = drm_color_ctm_s31_32_to_qm_n(input[i], 2, matrix_bits);
 
 	mtk_ddp_write(cmdq_pkt, coeffs[0] << 16 | coeffs[1],
 		      &ccorr->cmdq_reg, ccorr->regs, DISP_CCORR_COEF_0);
-- 
2.51.0



