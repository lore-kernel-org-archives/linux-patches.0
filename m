Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DE8168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58554C4339B;
	Mon,  8 May 2023 10:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540726;
	bh=OLOYr65srJFH0QTw3uy8KZh3kxGIMBEdNNQZAZyLhDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scihfTzYsvvawk+78aXCclLy43QkbMK5WbiDDqwV+BURFxLnjIW7S6tWPGZoMXjPA
	 0DBVmDbuA2NNpYKfSFp0AWamKOJZ8i7p3wt73+a3kdDT+u6tPj4TeEq5EVZ/+GrgV7
	 bd6/nVZAziP31uwftcRLuBmy6KU6wSXyvYK+pEIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 474/611] clk: mediatek: mt2712: Add error handling to clk_mt2712_apmixed_probe()
Date: Mon,  8 May 2023 11:45:16 +0200
Message-Id: <20230508094437.506406882@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 20cace1b9d7e33f68f0ee17196bf0df618dbacbe ]

This function was completely missing error handling: add it.

Fixes: e2f744a82d72 ("clk: mediatek: Add MT2712 clock support")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20230306140543.1813621-8-angelogioacchino.delregno@collabora.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt2712.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mt2712.c b/drivers/clk/mediatek/clk-mt2712.c
index 56980dd6c2eaf..7309b5813da96 100644
--- a/drivers/clk/mediatek/clk-mt2712.c
+++ b/drivers/clk/mediatek/clk-mt2712.c
@@ -1283,15 +1283,25 @@ static int clk_mt2712_apmixed_probe(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 
 	clk_data = mtk_alloc_clk_data(CLK_APMIXED_NR_CLK);
+	if (!clk_data)
+		return -ENOMEM;
 
-	mtk_clk_register_plls(node, plls, ARRAY_SIZE(plls), clk_data);
+	r = mtk_clk_register_plls(node, plls, ARRAY_SIZE(plls), clk_data);
+	if (r)
+		goto free_clk_data;
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
+	if (r) {
+		dev_err(&pdev->dev, "Cannot register clock provider: %d\n", r);
+		goto unregister_plls;
+	}
 
-	if (r != 0)
-		pr_err("%s(): could not register clock provider: %d\n",
-			__func__, r);
+	return 0;
 
+unregister_plls:
+	mtk_clk_unregister_plls(plls, ARRAY_SIZE(plls), clk_data);
+free_clk_data:
+	mtk_free_clk_data(clk_data);
 	return r;
 }
 
-- 
2.39.2



