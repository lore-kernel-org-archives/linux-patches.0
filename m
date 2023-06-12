Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAC3D518
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0C4C433D2;
	Mon, 12 Jun 2023 10:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567050;
	bh=R+yf2sL3KB1xPCxOBxs0E0UyHP0WZU0b1lr7OpxjYSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2s2G38fdTfe6YMM3gQPcWcgF5zXknkAL6qCWVWvw4iMN6PYCBb33EQtz8nb5/ksW
	 Dphh8juyN9qjkc8lTuFbQ6IThP8r+zbbBe3QLaPQfjd5FZ5QQS2/zCvggd6VlOSrXZ
	 qrrxakYUVLGas6QZB43Hf0+9oYpFU0r+D8/ErUkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Wu <trevor.wu@mediatek.com>,
	Douglas Anderson <dianders@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 131/160] ASoC: mediatek: mt8188: fix use-after-free in driver remove path
Date: Mon, 12 Jun 2023 12:27:43 +0200
Message-ID: <20230612101721.063418063@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trevor Wu <trevor.wu@mediatek.com>

[ Upstream commit fd67a7a1a22ce47fcbc094c4b6e164c34c652cbe ]

During mt8188_afe_init_clock(), mt8188_audsys_clk_register() was called
followed by several other devm functions. The caller of
mt8188_afe_init_clock() utilized devm_add_action_or_reset() to call
mt8188_afe_deinit_clock(). However, the order was incorrect, causing a
use-after-free issue during remove time.

At probe time, the order of calls was:
1. mt8188_audsys_clk_register
2. afe_priv->clk = devm_kcalloc
3. afe_priv->clk[i] = devm_clk_get

At remove time, the order of calls was:
1. mt8188_audsys_clk_unregister
3. free afe_priv->clk[i]
2. free afe_priv->clk

To resolve the problem, it's necessary to move devm_add_action_or_reset()
to the appropriate position so that the remove order can be 3->2->1.

Fixes: f6b026479b13 ("ASoC: mediatek: mt8188: support audio clock control")
Signed-off-by: Trevor Wu <trevor.wu@mediatek.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230601033318.10408-2-trevor.wu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-clk.c    |  7 ---
 sound/soc/mediatek/mt8188/mt8188-afe-clk.h    |  1 -
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c    |  4 --
 sound/soc/mediatek/mt8188/mt8188-audsys-clk.c | 47 ++++++++++---------
 sound/soc/mediatek/mt8188/mt8188-audsys-clk.h |  1 -
 5 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
index 743d6a162cb9a..0fb97517f82c6 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
@@ -418,13 +418,6 @@ int mt8188_afe_init_clock(struct mtk_base_afe *afe)
 	return 0;
 }
 
-void mt8188_afe_deinit_clock(void *priv)
-{
-	struct mtk_base_afe *afe = priv;
-
-	mt8188_audsys_clk_unregister(afe);
-}
-
 int mt8188_afe_enable_clk(struct mtk_base_afe *afe, struct clk *clk)
 {
 	int ret;
diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-clk.h b/sound/soc/mediatek/mt8188/mt8188-afe-clk.h
index 084fdfb1d877a..a4203a87a1e35 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-clk.h
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-clk.h
@@ -100,7 +100,6 @@ int mt8188_afe_get_mclk_source_clk_id(int sel);
 int mt8188_afe_get_mclk_source_rate(struct mtk_base_afe *afe, int apll);
 int mt8188_afe_get_default_mclk_source_by_rate(int rate);
 int mt8188_afe_init_clock(struct mtk_base_afe *afe);
-void mt8188_afe_deinit_clock(void *priv);
 int mt8188_afe_enable_clk(struct mtk_base_afe *afe, struct clk *clk);
 void mt8188_afe_disable_clk(struct mtk_base_afe *afe, struct clk *clk);
 int mt8188_afe_set_clk_rate(struct mtk_base_afe *afe, struct clk *clk,
diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
index e8e84de865422..45ab6e2829b7a 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
@@ -3185,10 +3185,6 @@ static int mt8188_afe_pcm_dev_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "init clock error");
 
-	ret = devm_add_action_or_reset(dev, mt8188_afe_deinit_clock, (void *)afe);
-	if (ret)
-		return ret;
-
 	spin_lock_init(&afe_priv->afe_ctrl_lock);
 
 	mutex_init(&afe->irq_alloc_lock);
diff --git a/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c b/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
index be1c53bf47298..c796ad8b62eea 100644
--- a/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
@@ -138,6 +138,29 @@ static const struct afe_gate aud_clks[CLK_AUD_NR_CLK] = {
 	GATE_AUD6(CLK_AUD_GASRC11, "aud_gasrc11", "top_asm_h", 11),
 };
 
+static void mt8188_audsys_clk_unregister(void *data)
+{
+	struct mtk_base_afe *afe = data;
+	struct mt8188_afe_private *afe_priv = afe->platform_priv;
+	struct clk *clk;
+	struct clk_lookup *cl;
+	int i;
+
+	if (!afe_priv)
+		return;
+
+	for (i = 0; i < CLK_AUD_NR_CLK; i++) {
+		cl = afe_priv->lookup[i];
+		if (!cl)
+			continue;
+
+		clk = cl->clk;
+		clk_unregister_gate(clk);
+
+		clkdev_drop(cl);
+	}
+}
+
 int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 {
 	struct mt8188_afe_private *afe_priv = afe->platform_priv;
@@ -179,27 +202,5 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 		afe_priv->lookup[i] = cl;
 	}
 
-	return 0;
-}
-
-void mt8188_audsys_clk_unregister(struct mtk_base_afe *afe)
-{
-	struct mt8188_afe_private *afe_priv = afe->platform_priv;
-	struct clk *clk;
-	struct clk_lookup *cl;
-	int i;
-
-	if (!afe_priv)
-		return;
-
-	for (i = 0; i < CLK_AUD_NR_CLK; i++) {
-		cl = afe_priv->lookup[i];
-		if (!cl)
-			continue;
-
-		clk = cl->clk;
-		clk_unregister_gate(clk);
-
-		clkdev_drop(cl);
-	}
+	return devm_add_action_or_reset(afe->dev, mt8188_audsys_clk_unregister, afe);
 }
diff --git a/sound/soc/mediatek/mt8188/mt8188-audsys-clk.h b/sound/soc/mediatek/mt8188/mt8188-audsys-clk.h
index 6c5f463ad7e4d..45b0948c4a06e 100644
--- a/sound/soc/mediatek/mt8188/mt8188-audsys-clk.h
+++ b/sound/soc/mediatek/mt8188/mt8188-audsys-clk.h
@@ -10,6 +10,5 @@
 #define _MT8188_AUDSYS_CLK_H_
 
 int mt8188_audsys_clk_register(struct mtk_base_afe *afe);
-void mt8188_audsys_clk_unregister(struct mtk_base_afe *afe);
 
 #endif
-- 
2.39.2



