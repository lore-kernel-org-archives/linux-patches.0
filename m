Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27446281363;
	Wed, 23 Apr 2025 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420522; cv=none; b=oS1MonTXOW/f+3WiSbgZeykn0H54NsaHD96wdSYB/sRsvnOsq9T9hUJthiRF0ec/XgsqCjfj/7P622QyEcCBCIY6f+Ep0wJYZIrs5jEUqrpzXy0PiEy1H08aoMHRb1gDC1mZuTeRVxn38pP249FvjpBrrHnsLtpb7jqxvWPam3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420522; c=relaxed/simple;
	bh=q9XziRB7+D6qlrSXJ2ao7fSo9zn4wQdaYolPfHuzzP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMB2n+HMfJzRefE18R+xuKp+VKwBulVEGvqS7iDU5562Ty5JXiEhUOYpR2qC7TSbZ/Q8fQ8bKqpE/sD4jhDrZSyWXpxjNURcDzNoQglq2rTZC0zsXWytXyXpPgNF4U44snz+kZbA0y8sKZuiiI8PTmSXaPZq+pqNxpNYMFmXhQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tO8CpY3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tO8CpY3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59451C4CEE2;
	Wed, 23 Apr 2025 15:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420521;
	bh=q9XziRB7+D6qlrSXJ2ao7fSo9zn4wQdaYolPfHuzzP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tO8CpY3kBDGxqZGLJ8T4l7p6hBXMtNoITwdVjU0AQwBGQAq5cbbKy3zgIaWefXN/J
	 yHnF653qpyvNPyEAr4QALZiOOlFF1RJjMpBjvv3vCHgckOqEPtQztqlOTM8cwsoDun
	 zRwcks6tIZVoZFYqzU0z5YYgtdVZgHHVHHTd6ynw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo-Cun Chen <bc-bocun.chen@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 084/241] net: ethernet: mtk_eth_soc: reapply mdc divider on reset
Date: Wed, 23 Apr 2025 16:42:28 +0200
Message-ID: <20250423142624.011453278@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo-Cun Chen <bc-bocun.chen@mediatek.com>

[ Upstream commit 6bc2b6c6f16d8e60de518d26da1bc6bc436cf71d ]

In the current method, the MDC divider was reset to the default setting
of 2.5MHz after the NETSYS SER. Therefore, we need to reapply the MDC
divider configuration function in mtk_hw_init() after reset.

Fixes: c0a440031d431 ("net: ethernet: mtk_eth_soc: set MDIO bus clock frequency")
Signed-off-by: Bo-Cun Chen <bc-bocun.chen@mediatek.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/8ab7381447e6cdcb317d5b5a6ddd90a1734efcb0.1744764277.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 39 +++++++++++++--------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  1 +
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 53485142938c4..7988de05e4ecd 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -823,9 +823,25 @@ static const struct phylink_mac_ops mtk_phylink_ops = {
 	.mac_link_up = mtk_mac_link_up,
 };
 
+static void mtk_mdio_config(struct mtk_eth *eth)
+{
+	u32 val;
+
+	/* Configure MDC Divider */
+	val = FIELD_PREP(PPSC_MDC_CFG, eth->mdc_divider);
+
+	/* Configure MDC Turbo Mode */
+	if (mtk_is_netsys_v3_or_greater(eth))
+		mtk_m32(eth, 0, MISC_MDC_TURBO, MTK_MAC_MISC_V3);
+	else
+		val |= PPSC_MDC_TURBO;
+
+	mtk_m32(eth, PPSC_MDC_CFG, val, MTK_PPSC);
+}
+
 static int mtk_mdio_init(struct mtk_eth *eth)
 {
-	unsigned int max_clk = 2500000, divider;
+	unsigned int max_clk = 2500000;
 	struct device_node *mii_np;
 	int ret;
 	u32 val;
@@ -865,20 +881,9 @@ static int mtk_mdio_init(struct mtk_eth *eth)
 		}
 		max_clk = val;
 	}
-	divider = min_t(unsigned int, DIV_ROUND_UP(MDC_MAX_FREQ, max_clk), 63);
-
-	/* Configure MDC Turbo Mode */
-	if (mtk_is_netsys_v3_or_greater(eth))
-		mtk_m32(eth, 0, MISC_MDC_TURBO, MTK_MAC_MISC_V3);
-
-	/* Configure MDC Divider */
-	val = FIELD_PREP(PPSC_MDC_CFG, divider);
-	if (!mtk_is_netsys_v3_or_greater(eth))
-		val |= PPSC_MDC_TURBO;
-	mtk_m32(eth, PPSC_MDC_CFG, val, MTK_PPSC);
-
-	dev_dbg(eth->dev, "MDC is running on %d Hz\n", MDC_MAX_FREQ / divider);
-
+	eth->mdc_divider = min_t(unsigned int, DIV_ROUND_UP(MDC_MAX_FREQ, max_clk), 63);
+	mtk_mdio_config(eth);
+	dev_dbg(eth->dev, "MDC is running on %d Hz\n", MDC_MAX_FREQ / eth->mdc_divider);
 	ret = of_mdiobus_register(eth->mii_bus, mii_np);
 
 err_put_node:
@@ -3928,6 +3933,10 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	else
 		mtk_hw_reset(eth);
 
+	/* No MT7628/88 support yet */
+	if (reset && !MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
+		mtk_mdio_config(eth);
+
 	if (mtk_is_netsys_v3_or_greater(eth)) {
 		/* Set FE to PDMAv2 if necessary */
 		val = mtk_r32(eth, MTK_FE_GLO_MISC);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 0d5225f1d3eef..8d7b6818d8601 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1260,6 +1260,7 @@ struct mtk_eth {
 	struct clk			*clks[MTK_CLK_MAX];
 
 	struct mii_bus			*mii_bus;
+	unsigned int			mdc_divider;
 	struct work_struct		pending_work;
 	unsigned long			state;
 
-- 
2.39.5



