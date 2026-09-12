Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A3D32A3DA;
	Sat, 12 Sep 2026 14:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223890; cv=none; b=fKrd9SWJMSbKsQP6BEm6xdnnwayBjxmaNeNMYXKDTZFDDSy5lZw9CbtFkr/AyOpGVzaCdfmHP1t/w+K1ldNTkzHVpyNAr7xGlFtp94KiMKXSyNcakc6y6oDKrPTMFrqPDOWRWAZxT2bDyzlcoCkUMCn3EnQlvbeV2iRC0OwDLdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223890; c=relaxed/simple;
	bh=EeAGq7JZO+uRQdGOU+pY4XF5IPkOecn3tVQDZUYyvdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dUNhpeS6KdJgFDnRwLFRVWjsp/Xz1wgBGqNpDSl7tCPDykWgyiW6zSYj2sC3408OcP8BWo5T4JzULKrAcZFLOWdK3wjPM+qKDCg0CSuVkjb73HW2Ocwt03ZFQAhwO2vuU0Vd3zjS/1N7zcuLvilNFjUAGu7ThIlA7TxzSLxXUWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8WYbtWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8WYbtWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98A31F000FF;
	Sat, 12 Sep 2026 14:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223888;
	bh=X0ujVzWZRqoLZdv9XJJV31aojJAiXejwMCwbwI6LCys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8WYbtWgxLC6hfduMcp3qSYdwYijKLRzmilyEVSfjYQ4b95BxZ0A3VvhX5r4bKyel
	 E6AXwvwK+KDkU+sCnUZvVwc67ZH7qFYp+DwRv0VBSBT+jFOhrBZEbyjI5XfQs+pfri
	 uj7QYqhv2nn8RKtKCJyD9WQ5ML0vU3Z+E+5nFUoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0881/1424] pinctrl: mediatek: eint: Fix invalid pointer dereference for v1 platforms
Date: Sat, 12 Sep 2026 08:55:13 +0200
Message-ID: <20260912065627.050634040@linuxfoundation.org>
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

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 1c9977b263475373b31bbf86af94a5c9ae2be42c ]

Commit 3ef9f710efcb ("pinctrl: mediatek: Add EINT support for multiple
addresses") introduced an access to the 'soc' field of struct
mtk_pinctrl in mtk_eint_do_init() and for that an include of
pinctrl-mtk-common-v2.h.

However, pinctrl drivers relying on the v1 common driver include
pinctrl-mtk-common.h instead, which provides another definition of
struct mtk_pinctrl that does not contain an 'soc' field.

Since mtk_eint_do_init() can be called both by v1 and v2 drivers, it
will now try to dereference an invalid pointer when called on v1
platforms. This has been observed on Genio 350 EVK (MT8365), which
crashes very early in boot (the kernel trace can only be seen with
earlycon).

In order to fix this, since 'struct mtk_pinctrl' was only needed to get
a 'struct mtk_eint_pin', make 'struct mtk_eint_pin' a parameter
of mtk_eint_do_init() so that callers need to supply it, removing
mtk_eint_do_init()'s dependency on any particular 'struct mtk_pinctrl'.

Fixes: 3ef9f710efcb ("pinctrl: mediatek: Add EINT support for multiple addresses")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/20250520-genio-350-eint-null-ptr-deref-fix-v2-1-6a3ca966a7ba@collabora.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 88292b7103d2 ("pinctrl: mediatek: free EINT resources on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/mtk-eint.c           | 26 ++++++++-----------
 drivers/pinctrl/mediatek/mtk-eint.h           |  5 ++--
 .../pinctrl/mediatek/pinctrl-mtk-common-v2.c  |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c |  2 +-
 4 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index 557dec75fa031..c2e452c699cfa 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -22,7 +22,6 @@
 #include <linux/platform_device.h>
 
 #include "mtk-eint.h"
-#include "pinctrl-mtk-common-v2.h"
 
 #define MTK_EINT_EDGE_SENSITIVE           0
 #define MTK_EINT_LEVEL_SENSITIVE          1
@@ -505,10 +504,9 @@ int mtk_eint_find_irq(struct mtk_eint *eint, unsigned long eint_n)
 }
 EXPORT_SYMBOL_GPL(mtk_eint_find_irq);
 
-int mtk_eint_do_init(struct mtk_eint *eint)
+int mtk_eint_do_init(struct mtk_eint *eint, struct mtk_eint_pin *eint_pin)
 {
 	unsigned int size, i, port, virq, inst = 0;
-	struct mtk_pinctrl *hw = (struct mtk_pinctrl *)eint->pctl;
 
 	/* If clients don't assign a specific regs, let's use generic one */
 	if (!eint->regs)
@@ -519,7 +517,15 @@ int mtk_eint_do_init(struct mtk_eint *eint)
 	if (!eint->base_pin_num)
 		return -ENOMEM;
 
-	if (eint->nbase == 1) {
+	if (eint_pin) {
+		eint->pins = eint_pin;
+		for (i = 0; i < eint->hw->ap_num; i++) {
+			inst = eint->pins[i].instance;
+			if (inst >= eint->nbase)
+				continue;
+			eint->base_pin_num[inst]++;
+		}
+	} else {
 		size = eint->hw->ap_num * sizeof(struct mtk_eint_pin);
 		eint->pins = devm_kmalloc(eint->dev, size, GFP_KERNEL);
 		if (!eint->pins)
@@ -533,16 +539,6 @@ int mtk_eint_do_init(struct mtk_eint *eint)
 		}
 	}
 
-	if (hw && hw->soc && hw->soc->eint_pin) {
-		eint->pins = hw->soc->eint_pin;
-		for (i = 0; i < eint->hw->ap_num; i++) {
-			inst = eint->pins[i].instance;
-			if (inst >= eint->nbase)
-				continue;
-			eint->base_pin_num[inst]++;
-		}
-	}
-
 	eint->pin_list = devm_kmalloc(eint->dev, eint->nbase * sizeof(u16 *), GFP_KERNEL);
 	if (!eint->pin_list)
 		goto err_pin_list;
@@ -610,7 +606,7 @@ int mtk_eint_do_init(struct mtk_eint *eint)
 err_wake_mask:
 	devm_kfree(eint->dev, eint->pin_list);
 err_pin_list:
-	if (eint->nbase == 1)
+	if (!eint_pin)
 		devm_kfree(eint->dev, eint->pins);
 err_pins:
 	devm_kfree(eint->dev, eint->base_pin_num);
diff --git a/drivers/pinctrl/mediatek/mtk-eint.h b/drivers/pinctrl/mediatek/mtk-eint.h
index 0c6bf7cbdc3a4..fc31a4c0c77bf 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.h
+++ b/drivers/pinctrl/mediatek/mtk-eint.h
@@ -88,7 +88,7 @@ struct mtk_eint {
 };
 
 #if IS_ENABLED(CONFIG_EINT_MTK)
-int mtk_eint_do_init(struct mtk_eint *eint);
+int mtk_eint_do_init(struct mtk_eint *eint, struct mtk_eint_pin *eint_pin);
 int mtk_eint_do_suspend(struct mtk_eint *eint);
 int mtk_eint_do_resume(struct mtk_eint *eint);
 int mtk_eint_set_debounce(struct mtk_eint *eint, unsigned long eint_n,
@@ -96,7 +96,8 @@ int mtk_eint_set_debounce(struct mtk_eint *eint, unsigned long eint_n,
 int mtk_eint_find_irq(struct mtk_eint *eint, unsigned long eint_n);
 
 #else
-static inline int mtk_eint_do_init(struct mtk_eint *eint)
+static inline int mtk_eint_do_init(struct mtk_eint *eint,
+				   struct mtk_eint_pin *eint_pin)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index 26fe53d9a53fb..882733516b45e 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -419,7 +419,7 @@ int mtk_build_eint(struct mtk_pinctrl *hw, struct platform_device *pdev)
 	hw->eint->pctl = hw;
 	hw->eint->gpio_xlate = &mtk_eint_xt;
 
-	ret = mtk_eint_do_init(hw->eint);
+	ret = mtk_eint_do_init(hw->eint, hw->soc->eint_pin);
 	if (ret)
 		goto err_free_eint;
 
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
index 167df3c7336fb..31cd27ddceafb 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1042,7 +1042,7 @@ static int mtk_eint_init(struct mtk_pinctrl *pctl, struct platform_device *pdev)
 	pctl->eint->pctl = pctl;
 	pctl->eint->gpio_xlate = &mtk_eint_xt;
 
-	return mtk_eint_do_init(pctl->eint);
+	return mtk_eint_do_init(pctl->eint, NULL);
 }
 
 /* This is used as a common probe function */
-- 
2.53.0



