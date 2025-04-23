Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09293280A32;
	Wed, 23 Apr 2025 14:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419874; cv=none; b=UZ3ONE0IXZBM2A7qLO0acB7xS1TdKVwjQIr7MH32IABAgh0HsOq7fIctoh6FUCny17vk8rH2I1cXvHuw2Y1nY+Ova3QLe7sKfcLrFHWHkmrz8Q+PZAooyGf/0NP0hrRM3KJXUU6P/OTcGfw3sY7+JR5H0esCHwXUccrizLWZyPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419874; c=relaxed/simple;
	bh=svr9Gup1SEt9osdtExRXH4U8L8HilPU3OjjUxGJzn2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Axdcjw8WK7JPNx9cFsTVg8hiq/FH3Dk1AeVuR0azUFhcUT87+rUDTCHFHAB8h826E8yP2ekR2WN1HC731G8XQsScZovrHbGISevRXOIfCeJeyqJ3h08e/5r/sTNZub0go6a0dIiYeoyLStditxDYP+tuCPgH8Y38kPCqrPOzvZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tU3zztQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tU3zztQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89560C4CEE2;
	Wed, 23 Apr 2025 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419873;
	bh=svr9Gup1SEt9osdtExRXH4U8L8HilPU3OjjUxGJzn2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tU3zztQl1BXLI3lCe5mjfMKPWwMEiG2zn8kx0Yy6XrXq0nUVGnx5cI6pNCfryIUQP
	 XmH1e+9SkH7Ffias+lqoIHyb/HYdr7tA4mAXHiSlh3haqNH2hCoTbbKjCBZXzlx5y8
	 CeChIYOk1ubK9+NfWqDUYDU9LiDCq6oNVImWgsyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo-Cun Chen <bc-bocun.chen@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/223] net: ethernet: mtk_eth_soc: revise QDMA packet scheduler settings
Date: Wed, 23 Apr 2025 16:42:26 +0200
Message-ID: <20250423142620.141422362@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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
index 941c7c380870b..d408dcda76d79 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -762,8 +762,8 @@ static void mtk_set_queue_speed(struct mtk_eth *eth, unsigned int idx,
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
@@ -3274,7 +3274,7 @@ static int mtk_start_dma(struct mtk_eth *eth)
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



