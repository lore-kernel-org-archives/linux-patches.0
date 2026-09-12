Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BEB2F28FC;
	Sat, 12 Sep 2026 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226435; cv=none; b=rQpWel7yKWjUwyK+UbgVJBabzBFxf25iHt5HzcuiAXkbR2k4dxivijPPx1Gbk9VGvBWZmoFrNLdX/0IBjQ/JSTRE7W0K0qgF2P5oFPWlcT6YnzCOul24sc5NS7OhmrNrRhz1LplhH7tIqZiwLcveotOVn5TZ5IsuByxThiG9HZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226435; c=relaxed/simple;
	bh=NGYDL6yPB5znRwl+KvZbzoqcElLv5hc4qWoC4vIboZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qI0ez58PRdN8mxM9aC5iaRek7lX79ndP2F43svCo8V1XJR4CTEHN+PJf7b+DDDArilzLC6jYxLiBV2RgD+uafRn5RgR+jjfUAsDhNjHjbT9hZ2azLBZDqf0o2nF9siQiUK5Cira9Fdaf3SxhCXKPKP+d7VlWyDV+2r8VXDyhZRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03x8jVlx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03x8jVlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59161F000FF;
	Sat, 12 Sep 2026 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226434;
	bh=AQkBybmdY3NUMeO0UqPQUVmV2hA6R6wBgVf31p24Dno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03x8jVlxLJ1oD/N6xviL2o/GJ4IWQYMFx4YwXnyj6YGIRs/mTRCRkqLIOv2lkxply
	 6x96XRIZ6Ymy6NoAK4TAELzaA/MfDnuHRIgPNB5DJ1lH427vklDoBw13xZyPLvS6yi
	 1n9YxR5nis6Rtbahc3REoBrEEbrEuP0XRsDDRNl4=
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
Subject: [PATCH 6.6 1400/1424] pinctrl: mediatek: common-v1: Fix EINT breakage on older controllers
Date: Sat, 12 Sep 2026 09:03:52 +0200
Message-ID: <20260912065638.613910126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 31cd27ddceafb..1659a44139e7a 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1024,7 +1024,13 @@ static int mtk_eint_init(struct mtk_pinctrl *pctl, struct platform_device *pdev)
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



