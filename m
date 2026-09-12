Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306A130C60F;
	Sat, 12 Sep 2026 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230073; cv=none; b=TqmOxbNQRHroFzvb7Em2GWWab+HGqLsH6+MeR7sPF1s6H0zMShrn+df5/e2YNR0C7QqOvYjDa2rUpAgMU/QOZrrfWGnPycUMtgGX7VFPP+7Atc8UyThcn8KN2bqf+FWfbV/CT6HIFf5lYy3GzoxJKlympxFTnYqvSqUI/ctK0lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230073; c=relaxed/simple;
	bh=4XJE1TZTvSASTbgdxWowjmDblESzWptlxpoiuMFmf84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlIJwxHSHkLUh75IU3oegnNLR0rWzsk0pWUqLfmjVAzyXnrR7+KTRYUNHIKdHIxHAaqIUE3bSd7q8dg2CTuhp5WY76Yx+ipbESXtt95CQ8v+rrSoZtl5Ee1NQbex5xaDs6G9OC466Csg2grJhoDEX5ZrryC7jIfT+mL1xypBRDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7RambU5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7RambU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7C81F000FF;
	Sat, 12 Sep 2026 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230071;
	bh=txwfKJ/7TcZj4Cbezb8rGldS5GPIWLCiKehtxRjs0XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7RambU5/hno1XRHnctDS8F0UITeCro7/uzOpqiUoyAeD2QxIr4Bcsd0dIgZ0nhFC
	 +j6D4gpn6KcIdqLgryHKFFsKrV5pgErHBGK7pc0XVEDapVfe9UPhNDerzhV8BAv2zw
	 7DAKzxCvUKMLVs9tzHO5Z+4+XwiwP+lMOky2WtIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Yeh <justin.yeh@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0719/1191] pinctrl: mediatek: free EINT resources on unbind
Date: Sat, 12 Sep 2026 08:57:27 +0200
Message-ID: <20260912065604.428713732@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Yeh <justin.yeh@mediatek.com>

[ Upstream commit 88292b7103d260e3e606eb3bb2794060a5fde48e ]

mtk_eint_do_init() creates an IRQ domain, populates it with a mapping for
every EINT line and installs a chained handler on the parent interrupt,
but none of these are ever released. This was harmless while the drivers
were built-in, but now that they can be built as modules and
unbound/rmmod'd it leaves behind a dangling IRQ domain, interrupt mappings
whose chip data points at freed memory, and a chained handler that keeps
firing into that freed data.

The plain allocations in mtk_eint_do_init() already use the device-managed
devm_*() helpers, so tear the remaining resources down the same way:
register a devm action that detaches the chained handler, waits for any
in-flight handler to finish, disposes of the per-line mappings and removes
the IRQ domain. This mirrors the device-managed lifecycle adopted for the
GPIO chip and keeps the whole EINT setup self-cleaning on unbind.

Fixes: e46df235b4e6 ("pinctrl: mediatek: refactor EINT related code for all MediaTek pinctrl can fit")
Signed-off-by: Justin Yeh <justin.yeh@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/mtk-eint.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index c2e452c699cfa..6787596167b92 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -12,8 +12,10 @@
  */
 
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <linux/err.h>
 #include <linux/gpio/driver.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqdomain.h>
@@ -504,6 +506,27 @@ int mtk_eint_find_irq(struct mtk_eint *eint, unsigned long eint_n)
 }
 EXPORT_SYMBOL_GPL(mtk_eint_find_irq);
 
+static void mtk_eint_teardown(void *data)
+{
+	struct mtk_eint *eint = data;
+	unsigned int i, virq;
+
+	/* Detach the demux handler so it can no longer reference freed data. */
+	irq_set_chained_handler_and_data(eint->irq, NULL, NULL);
+
+	/* Wait for any in-flight handler to finish before tearing down. */
+	synchronize_irq(eint->irq);
+
+	/* Dispose of all child mappings before the domain is removed. */
+	for (i = 0; i < eint->hw->ap_num; i++) {
+		virq = irq_find_mapping(eint->domain, i);
+		if (virq)
+			irq_dispose_mapping(virq);
+	}
+
+	irq_domain_remove(eint->domain);
+}
+
 int mtk_eint_do_init(struct mtk_eint *eint, struct mtk_eint_pin *eint_pin)
 {
 	unsigned int size, i, port, virq, inst = 0;
@@ -589,7 +612,7 @@ int mtk_eint_do_init(struct mtk_eint *eint, struct mtk_eint_pin *eint_pin)
 	irq_set_chained_handler_and_data(eint->irq, mtk_eint_irq_handler,
 					 eint);
 
-	return 0;
+	return devm_add_action_or_reset(eint->dev, mtk_eint_teardown, eint);
 
 err_eint:
 	for (i = 0; i < eint->nbase; i++) {
-- 
2.53.0



