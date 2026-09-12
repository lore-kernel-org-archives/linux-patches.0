Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8462D23A6;
	Sat, 12 Sep 2026 13:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219529; cv=none; b=hvVVUHMPe81MgrJcKF5UCY2W7aV3l+IXRJgCw1QgwUiD8B6QbzWfs3+5PAePeupXXjoG+apWGSu6vvNFfvBexlGYzX+y3RYy9tOSqbv3GSxa8niN8dAP//vysVh+2dXuxuObktyqPhLXzC7vHNtyySew5C3mXVA+yfXafEcqWMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219529; c=relaxed/simple;
	bh=IV1eiVBXIuWKU0AjGBe84lm8ymWhdc8lo5aZPTE5cy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AL1xCemQs1ysTJq1GajfbzaWtf65aCsS27UkqPWHg0p9N21Y6cXhcvM6l0a9glZsD9tUCDQ/2+gVSSwHgDSK4sQKRiRbbOIqu7rkmoHz6WZLRWfJ7YX1qeL/JSDh/TJMmwJlhpU84jseuujtHys8GG9WhI671FMzhykV0x/T8i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bewm3m4X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bewm3m4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7288E1F000FF;
	Sat, 12 Sep 2026 13:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219528;
	bh=M9xQTLogeNdCvbDRookDgz5bCJBcpn5EkdDFqAewm/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bewm3m4X3QhHinZ0m2yW3rhxmDMweX+EoeKXZn11U6UH7gtf29u087PL1nZ8WBvFs
	 Uy8yq58rnBDJLQrtgIH7CYtzgk3PJFjGV0HsuQUWKH1NAMksOoNZgrVLZ4+4lu4QUh
	 8RK+EXmynizmBjiT/QD1uGmbYachceK2+6+/Vax4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Hao Chang <ot_chhao.chang@mediatek.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1342/1376] pinctrl: mediatek: common-v1: Fix EINT breakage on older controllers
Date: Sat, 12 Sep 2026 09:02:48 +0200
Message-ID: <20260912065637.441551199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit fe412e3a6c97cfe49ecf4564a278122f7d78e3f0 ]

When EINT support for multiple addresses was introduced, the driver
library for the older generations (pinctrl-mtk-common) was not fixed
together. This resulted in invalid pointer accesses.

Fix up the filled in |struct mtk_eint| in pinctrl-mtk-common to match
what is now expected by the mtk-eint library.

Reported-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Tested-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Closes: https://lore.kernel.org/all/43nd5jxpk7b7fv46frqlfjnqfh5jlpqsemeoakqzd4wdi3df6y@w7ycd3k5ezvn/
Fixes: 3ef9f710efcb ("pinctrl: mediatek: Add EINT support for multiple addresses")
Cc: Hao Chang <ot_chhao.chang@mediatek.com>
Cc: Qingliang Li <qingliang.li@mediatek.com>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/20250415112339.2385454-1-wenst@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
index dd3222a0b8e5f..59efa435151cf 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1015,7 +1015,13 @@ static int mtk_eint_init(struct mtk_pinctrl *pctl, struct platform_device *pdev)
 	if (!pctl->eint)
 		return -ENOMEM;
 
-	pctl->eint->base = devm_platform_ioremap_resource(pdev, 0);
+	pctl->eint->nbase = 1;
+	/* mtk-eint expects an array */
+	pctl->eint->base = devm_kzalloc(pctl->dev, sizeof(pctl->eint->base), GFP_KERNEL);
+	if (IS_ERR(pctl->eint->base))
+		return -ENOMEM;
+
+	pctl->eint->base[0] = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pctl->eint->base))
 		return PTR_ERR(pctl->eint->base);
 
-- 
2.53.0



