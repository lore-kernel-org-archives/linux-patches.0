Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFCA3AE707;
	Sat, 17 Oct 2026 16:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255192; cv=none; b=HAGz20NSatyIk11POSxiGhe1ayIUUVHFzN2j6+est4VtKMIKfhwEi9e50LPOAcfUwO57nND8xQF/0rjeA57tsKpO125ctlVHOc/W5emvSwa2gxHLOZNWCBqIwK/i3CskPVrccREoN+fKJuWGCEmiL3z60iSSHwnS8GVH5NAmFE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255192; c=relaxed/simple;
	bh=NhgKbrFF9VIPSW4F3afK9ThDhjmXa+/8y0G2d0YbXVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pT++llnfxC9QbwTPnFuTLEaWGCjeapj48zi6WCpL9fdE2gpWIYOM2e/3nelU2CgT7itrRVaPV7L6CHD7jlYYDnC//Pc6wNiVeSweAhUeqgenq38zAZTTVsQq9mFahJhdTAafFgg4l4CSTMPTogxQaQoYZTST4SXMhjzdBGwS/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcBfqQht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcBfqQht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6AA1F000C5;
	Sat, 17 Oct 2026 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255191;
	bh=+rHzb6v+6wyFWpOH6SEpvbpmwuOo0UuXFqJfuGD8hW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KcBfqQhtSkK8nIUDXGtTzxttx5BVGdSiugVWzDLI85PgOFX3/5jep1nmzISwtI+DQ
	 mpxivUQ+Tikabaugf6Ro4ssKj3r6uUZZuTngcUwrZtTymnTPjh5CGRfshiOpCTLBdj
	 v7xd0A5PSXFk8ZLH6j+3bW7VCQGDkcRxtLaFMfy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Yeh <justin.yeh@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 693/869] pinctrl: mediatek: use devm_gpiochip_add_data() for GPIO chip
Date: Sat, 17 Oct 2026 17:58:54 +0200
Message-ID: <20261017160054.740389810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Justin Yeh <justin.yeh@mediatek.com>

[ Upstream commit 9c650317ba553d297f3fc5f0ae40ec53d86f9dab ]

The gpio_chip is allocated with device-managed memory but registered with
the non-managed gpiochip_add_data(). This was harmless while the drivers
were built-in, but once they can be built as modules and unbound/rmmod'd,
devm frees the gpio_chip's memory while it is still registered, causing a
use-after-free.

Register it with devm_gpiochip_add_data() so it shares the same
device-managed lifecycle, which also lets the manual gpiochip_remove()
error paths go away.

Fixes: a6df410d420a ("pinctrl: mediatek: Add Pinctrl/GPIO driver for mt8135.")
Fixes: 805250982bb5 ("pinctrl: mediatek: add pinctrl-paris that implements the vendor dt-bindings")
Fixes: e78d57b2f87c ("pinctrl: mediatek: add pinctrl-moore that implements the generic pinctrl dt-bindings")
Signed-off-by: Justin Yeh <justin.yeh@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-moore.c      |  6 ++----
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c | 14 ++++----------
 drivers/pinctrl/mediatek/pinctrl-paris.c      |  2 +-
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.c b/drivers/pinctrl/mediatek/pinctrl-moore.c
index aad4891223d3e..f24df94c49185 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.c
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.c
@@ -573,7 +573,7 @@ static int mtk_build_gpiochip(struct mtk_pinctrl *hw)
 	chip->base		= -1;
 	chip->ngpio		= hw->soc->npins;
 
-	ret = gpiochip_add_data(chip, hw);
+	ret = devm_gpiochip_add_data(hw->dev, chip, hw);
 	if (ret < 0)
 		return ret;
 
@@ -587,10 +587,8 @@ static int mtk_build_gpiochip(struct mtk_pinctrl *hw)
 	if (!of_property_present(hw->dev->of_node, "gpio-ranges")) {
 		ret = gpiochip_add_pin_range(chip, dev_name(hw->dev), 0, 0,
 					     chip->ngpio);
-		if (ret < 0) {
-			gpiochip_remove(chip);
+		if (ret < 0)
 			return ret;
-		}
 	}
 
 	return 0;
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
index efc9b07e62658..cee2dffd57e7a 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1118,30 +1118,24 @@ int mtk_pctrl_init(struct platform_device *pdev,
 	pctl->chip->parent = &pdev->dev;
 	pctl->chip->base = -1;
 
-	ret = gpiochip_add_data(pctl->chip, pctl);
+	ret = devm_gpiochip_add_data(&pdev->dev, pctl->chip, pctl);
 	if (ret)
 		return -EINVAL;
 
 	/* Register the GPIO to pin mappings. */
 	ret = gpiochip_add_pin_range(pctl->chip, dev_name(&pdev->dev),
 			0, 0, pctl->devdata->npins);
-	if (ret) {
-		ret = -EINVAL;
-		goto chip_error;
-	}
+	if (ret)
+		return -EINVAL;
 
 	/* Only initialize EINT if we have EINT pins */
 	if (data->eint_hw.ap_num > 0) {
 		ret = mtk_eint_init(pctl, pdev);
 		if (ret)
-			goto chip_error;
+			return ret;
 	}
 
 	return 0;
-
-chip_error:
-	gpiochip_remove(pctl->chip);
-	return ret;
 }
 
 int mtk_pctrl_common_probe(struct platform_device *pdev)
diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 87e958d827bf9..363a02106d401 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -970,7 +970,7 @@ static int mtk_build_gpiochip(struct mtk_pinctrl *hw)
 	chip->base		= -1;
 	chip->ngpio		= hw->soc->npins;
 
-	ret = gpiochip_add_data(chip, hw);
+	ret = devm_gpiochip_add_data(hw->dev, chip, hw);
 	if (ret < 0)
 		return ret;
 
-- 
2.53.0



