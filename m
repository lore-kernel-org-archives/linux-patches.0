Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D0242902A;
	Sat, 12 Sep 2026 10:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208239; cv=none; b=n1x99piv515KuVoYWvq8lOV+0bcghwPCwpRPlrzv8trmSg2n0h0rjUBATrWwBOCOviGxMIrrJgXv/sxULa/VqEqiNORluT5OpF3xdWggmQPp1BL1gBM4N0EQu32CLf3Uc5QXaCrBCYeTZc7H+pngH9yStjDJ7IokDJuEW4b5NQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208239; c=relaxed/simple;
	bh=fpgD9TLJg8SpxjaEsIeAWSMMMPtoxlZeCD6HQWGrAjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMQvjXCfCyEFow9KEvgshyAH7WaI+AsNyRCUZVDXlBQWWzJYybXBViwjyuAXRT38TcM6oDrk5mrxzSQrx65agIZ6U10i+onh2ERQW+jvWfAGl3Zy8bFNWeHWl/OiWg41ZaPGKZtewD5FXnjVg2yVBlSDgcyXlZSneq8CxKJfViM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqsASHtd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqsASHtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDAD1F00898;
	Sat, 12 Sep 2026 10:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208231;
	bh=9DjYrlGuw6J30X47Bpo7PjulSfVu8mAvHUkazo6QzVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqsASHtdcXSIXMePd0ugWtuzjVVDC1vfmRya6ti9bFf4Q50KOIOLZJPuju4N4PG//
	 G6Y3d2YvNbBwSaP496TQMf8krsVlt+/qFgQsAkv0LgOW1Rjh6XJFPOFuvMsmPBTAE1
	 R7wNNcTdg9TmvG3N/rRsRblwthh0SBitm6L/Y3Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Yeh <justin.yeh@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0576/1518] pinctrl: mediatek: free EINT resources on unbind
Date: Sat, 12 Sep 2026 08:45:45 +0200
Message-ID: <20260912065636.459035610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 5f12af59a91b5..df99401c0b7d7 100644
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
@@ -596,7 +619,7 @@ int mtk_eint_do_init(struct mtk_eint *eint, struct mtk_eint_pin *eint_pin)
 	irq_set_chained_handler_and_data(eint->irq, mtk_eint_irq_handler,
 					 eint);
 
-	return 0;
+	return devm_add_action_or_reset(eint->dev, mtk_eint_teardown, eint);
 
 err_eint:
 	for (i = 0; i < eint->nbase; i++) {
-- 
2.53.0



