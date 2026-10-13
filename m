Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0D63B892D;
	Tue, 13 Oct 2026 12:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894176; cv=none; b=OX4w1+g2+nRHcmC+UtaGczOjVHJvq8ZXMKaoYvwZILZcev09Ps4VXMk4TBOhJ3BhBw+2aCCRFbgcCgMDiLLwP4P6jtT98JNjYLAVm5ecIVgoFnHagUs01yi2ikF/92bInZzdZ+MoH2U4OTF1OzxqYuskyxuIyMFT4v4DXP1+y0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894176; c=relaxed/simple;
	bh=pnPjfE3VQc0dSBD2A++Z7cZp+/9dYZq4zuVQaej6CHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyFKVGeUSw7bsvxeybHpgRp6BgVFYlA1vuFfsmaw+DcW7LBhr7y4hhFhQ4zqvWuQFTf7GZhhFnu9BDxnNl82wsw8J16b+DHwPLNllVKi2lxacrfIHuKqXjwCpNJAMLs5e3ZMgebg9U3E2Yej3cmj1q8M9JQ45QFNxHBM8haE8yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5tDmZpy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5tDmZpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F2C1F000FF;
	Tue, 13 Oct 2026 12:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894175;
	bh=wEQWkg4ivLZCD5cXUy+YIqaIm3Clr/shs9psbFou2Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5tDmZpy+xfRtSvv+YGOD/Te5V6HYPcIWWJn3h2K8ZWYCaGN3o6iANnMaCIS7U2/4
	 TRfrMfSfLKlQd1VL7/WSUbgMcV+2i5AiACUBxQQEW6gQ3Dhl3omxKJJOC+oe76pphp
	 UetFLmnwAhp4gqpDcazSgc69/5jYHBjSY7Sh9E2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Yeh <justin.yeh@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 471/621] pinctrl: mediatek: use devm_gpiochip_add_data() for GPIO chip
Date: Tue, 13 Oct 2026 13:37:46 +0200
Message-ID: <20261013112932.010744635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 70f608347a5f6..2cb3b4e0cca7c 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.c
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.c
@@ -575,7 +575,7 @@ static int mtk_build_gpiochip(struct mtk_pinctrl *hw)
 	chip->base		= -1;
 	chip->ngpio		= hw->soc->npins;
 
-	ret = gpiochip_add_data(chip, hw);
+	ret = devm_gpiochip_add_data(hw->dev, chip, hw);
 	if (ret < 0)
 		return ret;
 
@@ -589,10 +589,8 @@ static int mtk_build_gpiochip(struct mtk_pinctrl *hw)
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
index dd2c8aa039385..791eddd7a2c63 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1130,30 +1130,24 @@ int mtk_pctrl_init(struct platform_device *pdev,
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
index 23f04b24fd65e..09098b68f7257 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -957,7 +957,7 @@ static int mtk_build_gpiochip(struct mtk_pinctrl *hw)
 	chip->base		= -1;
 	chip->ngpio		= hw->soc->npins;
 
-	ret = gpiochip_add_data(chip, hw);
+	ret = devm_gpiochip_add_data(hw->dev, chip, hw);
 	if (ret < 0)
 		return ret;
 
-- 
2.53.0



