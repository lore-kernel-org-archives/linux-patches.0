Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B391863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EFBC433EF;
	Wed, 28 Dec 2022 15:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242344;
	bh=DyKGi3evbYPA7Bj7x2CTKvCLQ3TQjbl82UYyKtPm4q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMPEcaxzreINAPUizfzy2okVfDWznt2AAjIie58E7q0OIQamof84S/qtd6PspNhiV
	 BpD8zHpMjw5gPCpa8i0DTd1Plf3FTVUPs8gqz9YM6OEmS1faDsmht3qKnkOzg+CcAG
	 jUOs6i22F0SHGWFEYsbCYpxDaLdR2z+DbQP2VtYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0359/1146] net: ethernet: mtk_eth_soc: fix RSTCTRL_PPE{0,1} definitions
Date: Wed, 28 Dec 2022 15:31:38 +0100
Message-Id: <20221228144339.912782001@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit ef8c373bd91df3cf70596497da0955d218961ead ]

Fix RSTCTRL_PPE0 and RSTCTRL_PPE1 register mask definitions for
MTK_NETSYS_V2.
Remove duplicated definitions.

Fixes: 160d3a9b1929 ("net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 13 +++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 10 +++-------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 1148e22001c0..864452e4426b 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3292,16 +3292,17 @@ static int mtk_hw_init(struct mtk_eth *eth)
 		return 0;
 	}
 
-	val = RSTCTRL_FE | RSTCTRL_PPE;
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN, 0);
-
-		val |= RSTCTRL_ETH;
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
-			val |= RSTCTRL_PPE1;
+		val = RSTCTRL_PPE0_V2;
+	} else {
+		val = RSTCTRL_PPE0;
 	}
 
-	ethsys_reset(eth, val);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
+		val |= RSTCTRL_PPE1;
+
+	ethsys_reset(eth, RSTCTRL_ETH | RSTCTRL_FE | val);
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index b52f3b0177ef..9eaca55a106e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -447,18 +447,14 @@
 /* ethernet reset control register */
 #define ETHSYS_RSTCTRL			0x34
 #define RSTCTRL_FE			BIT(6)
-#define RSTCTRL_PPE			BIT(31)
-#define RSTCTRL_PPE1			BIT(30)
+#define RSTCTRL_PPE0			BIT(31)
+#define RSTCTRL_PPE0_V2			BIT(30)
+#define RSTCTRL_PPE1			BIT(31)
 #define RSTCTRL_ETH			BIT(23)
 
 /* ethernet reset check idle register */
 #define ETHSYS_FE_RST_CHK_IDLE_EN	0x28
 
-/* ethernet reset control register */
-#define ETHSYS_RSTCTRL		0x34
-#define RSTCTRL_FE		BIT(6)
-#define RSTCTRL_PPE		BIT(31)
-
 /* ethernet dma channel agent map */
 #define ETHSYS_DMA_AG_MAP	0x408
 #define ETHSYS_DMA_AG_MAP_PDMA	BIT(0)
-- 
2.35.1



