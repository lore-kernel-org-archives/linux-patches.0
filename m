Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B2E47CC81;
	Sat, 12 Sep 2026 17:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232424; cv=none; b=UKLs0kEREH519A8iuXX/LjV6Go+MbQp3CwfkuDxMYRGL7MaL9mKEucA2aKxMNpl68x6MlLiaYiJX5vb5qV1cQeRsY/T/h/lA3Uh2yTl6hsFJfSHii7qL5/1w7bUGXbXfT2BubKOXKAXaObwN8juW8hDRf9NotA2/d0cHk95WA48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232424; c=relaxed/simple;
	bh=fNvFq0GrYKqLNx78E+/8YStCEHBfPLIdlf4bONlVJqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KFdz0LP5G/s2oJzbV4/PlQ2ABvt7Rm3KUk0zicjVJolq55O0AlMykZSz3H6EH/xSviIaAj4FMHVlLrWcAfqPc00UsC4Yyp4gZ7Fr5oRtetdQXNyu2Heki2Wzc2tIREaYCL0tVSbK+ndezR0TlxOKP35B2x7CDcH5QarlC2SoUBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18LHNCYM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18LHNCYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91601F000FF;
	Sat, 12 Sep 2026 17:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232422;
	bh=5CYG2DSw/bCvh7rfPEg9w544CRrDqTiB6W56I0afkQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18LHNCYMdXfiBExX2lYvT+NW8ATXFcIEecQA2g0ZXLQepX9Aa+kLEiyzoWy48TwnX
	 vMUxfGhZS9bwunjE6bBMJVsch5rDFDjmdyn7zCjG1xNYQOK+9ANSzRihqRq8YftyaD
	 llpNynPFI2oeL0QH0GeOZ+509A/9AShay/0Cb3LE=
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
Subject: [PATCH 6.1 1148/1191] pinctrl: mediatek: common-v1: Fix EINT breakage on older controllers
Date: Sat, 12 Sep 2026 09:04:36 +0200
Message-ID: <20260912065613.933487703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ee00575ec3365..055911941180c 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1012,7 +1012,13 @@ static int mtk_eint_init(struct mtk_pinctrl *pctl, struct platform_device *pdev)
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



