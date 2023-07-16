Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A6A8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8765C433C7;
	Sun, 16 Jul 2023 20:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538333;
	bh=WtZMSZavogw1qLmzFJ8c7eR7mUYPIH7mNgbUM/eN0Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QglPmHH+Ae3hQv0rVa14lt6KL+fQ4GSFzTpbVx3ozA5imgJPNOEPv8YTrbq9Yzx6U
	 iKLrTQ+ogf2FRp4hxHkC2JDu9VfaFai9w0fe+JQW9ZC5X7WQXrx4Tra/1Q1iO8gW4f
	 1eBcHXEQE0ZodBNiQ55UIelo+AJ/yN+dRKEXQqHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 413/800] clk: mediatek: clk-mtk: Grab iomem pointer for divider clocks
Date: Sun, 16 Jul 2023 21:44:26 +0200
Message-ID: <20230716194958.678849899@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit 51821765e89906090753421580a61d25a4668186 ]

In the rare case in which one of the clock drivers has divider clocks
but not composite clocks, mtk_clk_simple_probe() would not io(re)map,
hence passing a NULL pointer to mtk_clk_register_dividers().

To fix this issue, extend the `if` conditional to also check if any
divider clocks are present. While at it, also make sure the iomem
pointer is NULL if no composite/divider clocks are declared, as we
are checking for that when iounmapping it in the error path.

This hasn't been seen on any MediaTek clock driver as the current ones
always declare composite clocks along with divider clocks, but this is
still an important fix for a future potential KP.

Fixes: 1fe074b1f112 ("clk: mediatek: Add divider clocks to mtk_clk_simple_{probe,remove}()")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230615122051.546985-2-angelogioacchino.delregno@collabora.com
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mtk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
index 3c50f48e93a7b..affaf52c82bd4 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -469,7 +469,7 @@ static int __mtk_clk_simple_probe(struct platform_device *pdev,
 	const struct platform_device_id *id;
 	const struct mtk_clk_desc *mcd;
 	struct clk_hw_onecell_data *clk_data;
-	void __iomem *base;
+	void __iomem *base = NULL;
 	int num_clks, r;
 
 	mcd = device_get_match_data(&pdev->dev);
@@ -483,8 +483,8 @@ static int __mtk_clk_simple_probe(struct platform_device *pdev,
 			return -EINVAL;
 	}
 
-	/* Composite clocks needs us to pass iomem pointer */
-	if (mcd->composite_clks) {
+	/* Composite and divider clocks needs us to pass iomem pointer */
+	if (mcd->composite_clks || mcd->divider_clks) {
 		if (!mcd->shared_io)
 			base = devm_platform_ioremap_resource(pdev, 0);
 		else
-- 
2.39.2



