Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9982E3175F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZurbRDy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AD3C433C8;
	Wed, 15 Nov 2023 19:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077235;
	bh=luaQdVQ3+BMDsiaHUmQ4NdgAHUZbD7x5BYEtFNNVuEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZurbRDy9MdWaUxFyvhjzK4vyfJmMMvhmFJw2Ok7roqstn9c161KV7jIIsM2Jkt8OR
	 86Q9HUSkEwYq2hbQPu4F8zZFDZNi/5hgpksDH9zopcuPAyLFQZ/tEvRuvxCEMeqC8c
	 zYiC2e2lfkuYv08Yn7MBvOQHLApYHDUT03KdwZQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/603] clk: renesas: rzg2l: Fix computation formula
Date: Wed, 15 Nov 2023 14:12:04 -0500
Message-ID: <20231115191625.636996652@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit a2b23159499efd36b2d63b3c4534075d12ddc97a ]

According to the hardware manual for RZ/G2L
(r01uh0914ej0130-rzg2l-rzg2lc.pdf), the computation formula for PLL rate
is as follows:

    Fout = ((m + k/65536) * Fin) / (p * 2^s)

and k has values in the range [-32768, 32767].  Dividing k by 65536 with
integer arithmetic gives zero all the time, causing slight differences
b/w what has been set vs. what is displayed.  Thus, get rid of this and
decompose the formula before dividing k by 65536.

Fixes: ef3c613ccd68a ("clk: renesas: Add CPG core wrapper for RZ/G2L SoC")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230929053915.1530607-6-claudiu.beznea@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 53f17f3587472..3f01620e292b6 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -42,7 +42,7 @@
 #define GET_SHIFT(val)		((val >> 12) & 0xff)
 #define GET_WIDTH(val)		((val >> 8) & 0xf)
 
-#define KDIV(val)		FIELD_GET(GENMASK(31, 16), val)
+#define KDIV(val)		((s16)FIELD_GET(GENMASK(31, 16), val))
 #define MDIV(val)		FIELD_GET(GENMASK(15, 6), val)
 #define PDIV(val)		FIELD_GET(GENMASK(5, 0), val)
 #define SDIV(val)		FIELD_GET(GENMASK(2, 0), val)
@@ -695,18 +695,18 @@ static unsigned long rzg2l_cpg_pll_clk_recalc_rate(struct clk_hw *hw,
 	struct pll_clk *pll_clk = to_pll(hw);
 	struct rzg2l_cpg_priv *priv = pll_clk->priv;
 	unsigned int val1, val2;
-	unsigned int mult = 1;
-	unsigned int div = 1;
+	u64 rate;
 
 	if (pll_clk->type != CLK_TYPE_SAM_PLL)
 		return parent_rate;
 
 	val1 = readl(priv->base + GET_REG_SAMPLL_CLK1(pll_clk->conf));
 	val2 = readl(priv->base + GET_REG_SAMPLL_CLK2(pll_clk->conf));
-	mult = MDIV(val1) + KDIV(val1) / 65536;
-	div = PDIV(val1) << SDIV(val2);
 
-	return DIV_ROUND_CLOSEST_ULL((u64)parent_rate * mult, div);
+	rate = mul_u64_u32_shr(parent_rate, (MDIV(val1) << 16) + KDIV(val1),
+			       16 + SDIV(val2));
+
+	return DIV_ROUND_CLOSEST_ULL(rate, PDIV(val1));
 }
 
 static const struct clk_ops rzg2l_cpg_pll_ops = {
-- 
2.42.0



