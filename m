Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973002918F9;
	Wed, 23 Apr 2025 15:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422191; cv=none; b=WXBNbb7LBOmfe9edxf9vnKKnjRgzRnCVCZXdkKpzhAHvhgdJXMEBOfeI6zQlneDsnksqIJ+v9Ndv+GbhBcUU2x8TClrencqEXRQxq++mz7evaaxxe8D1Hk6onWo4ccHUxMUgJaAPCo4ruZPtxTxI+AplaMqeuXFLwNjJK24qisw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422191; c=relaxed/simple;
	bh=a7drLuCAYxOUvqjdiLW2Ke5kxMuCKhQyM/VbVNM38Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZ+hIhODsbjScbkpOkLvpQwGQiiUGGn+UtrgS112mpk9VI0afU8EXN/s2bUfuWZdh3E48qmDeJ/A+TlBFZPWir3If9wKpURmgmxxzN5fFLaQixxzpqGbYvJadMe9mUr31j77OoD+17nr6dh9hnT5Qmze9XbQRRvulK14z+BwEWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u71xtVWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u71xtVWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD512C4CEEB;
	Wed, 23 Apr 2025 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422191;
	bh=a7drLuCAYxOUvqjdiLW2Ke5kxMuCKhQyM/VbVNM38Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u71xtVWiM/TBHU6DRO59vpcOwAf4ddOxq54mt9z7hDM5WG7y3Oo9/BR4L9asaQ0wI
	 A+I/Gjf4wIKT946VemFl+ymw/UWf1eN2bLVq6BJl1Gr3d1cz5qjUSDN1nXx8YKvvzD
	 HircxfbZQHjoi/TvslwJa3M2UYRV1iJI+EJX7HME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo-Cun Chen <bc-bocun.chen@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 294/393] net: ethernet: mtk_eth_soc: revise QDMA packet scheduler settings
Date: Wed, 23 Apr 2025 16:43:10 +0200
Message-ID: <20250423142655.483596037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Bo-Cun Chen <bc-bocun.chen@mediatek.com>

[ Upstream commit 1b66124135f5f8640bd540fadda4b20cdd23114b ]

The QDMA packet scheduler suffers from a performance issue.
Fix this by picking up changes from MediaTek's SDK which change to use
Token Bucket instead of Leaky Bucket and fix the SPEED_1000 configuration.

Fixes: 160d3a9b1929 ("net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support")
Signed-off-by: Bo-Cun Chen <bc-bocun.chen@mediatek.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/18040f60f9e2f5855036b75b28c4332a2d2ebdd8.1744764277.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a22a5bdc7ce62..c201ea20e4047 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -752,8 +752,8 @@ static void mtk_set_queue_speed(struct mtk_eth *eth, unsigned int idx,
 			break;
 		case SPEED_1000:
 			val |= MTK_QTX_SCH_MAX_RATE_EN |
-			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 10) |
-			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 5) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 1) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 6) |
 			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 10);
 			break;
 		default:
@@ -3244,7 +3244,7 @@ static int mtk_start_dma(struct mtk_eth *eth)
 		if (mtk_is_netsys_v2_or_greater(eth))
 			val |= MTK_MUTLI_CNT | MTK_RESV_BUF |
 			       MTK_WCOMP_EN | MTK_DMAD_WR_WDONE |
-			       MTK_CHK_DDONE_EN | MTK_LEAKY_BUCKET_EN;
+			       MTK_CHK_DDONE_EN;
 		else
 			val |= MTK_RX_BT_32DWORDS;
 		mtk_w32(eth, val, reg_map->qdma.glo_cfg);
-- 
2.39.5



