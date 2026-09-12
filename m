Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0EC3859E6;
	Sat, 12 Sep 2026 07:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199816; cv=none; b=OzBpkXNJCf9P7N1hNAgxNjHvx1e3G6pMUfnL77t6tv3MAjYYth7WNnbp+W5beuQRQoY2DEPQReYEds5lg3w8KSwXzWOj6mc70mTCJ0jvlMjei59CqbI0x/u3OOmBMGX8WPTwNDZAGNCyQy1mhA8tnqLluOhTV2BQCdvSqKmAhk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199816; c=relaxed/simple;
	bh=br4USXZeAi8iHTCPK/7AtOffngARWgcbpOBIKg9bn1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQCJwJvaBkrbz7VV0wAQKQkcega+rwj40+oM2zh9cL1TweOVHpu6ZGAkkJZe0K3cUd5knHvepPwcyjLhLE1PRnjnDipaeXBB5jSwpu47YZ8WBn0CtQ3x/0pAxthCdRCfN4yfgUtV3yEqqdX8YH9dIADi9DpPXp6pQJWBZPsgw08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLGWSNKR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLGWSNKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E9B1F000FF;
	Sat, 12 Sep 2026 07:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199814;
	bh=gyFkVU3HcJPfZxm0ri4ElnlNfc+/7W0J4Rq3v7moQXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLGWSNKRZTMZdOHNWjT0uqlnl5MOhWvxX0aHgvMrxV9uTRAuW3hIXMV65fJz4LP1x
	 ANOPZgjmiyOWsBWnaeyYUmANx3KYP/c0zwJloi8afO8GNnQ3vxw1qUmIRC3EcBplKX
	 gODTXKiNqQ0TpjyNgmjLwxB8I2n/A3zgegqyW6yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Yeh <justin.yeh@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0662/1815] pinctrl: mediatek: free EINT resources on unbind
Date: Sat, 12 Sep 2026 08:40:12 +0200
Message-ID: <20260912065704.423047608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 47ac92ea98c2c..8b022545a3e9f 100644
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
@@ -509,6 +511,27 @@ int mtk_eint_find_irq(struct mtk_eint *eint, unsigned long eint_n)
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
@@ -601,7 +624,7 @@ int mtk_eint_do_init(struct mtk_eint *eint, struct mtk_eint_pin *eint_pin)
 	irq_set_chained_handler_and_data(eint->irq, mtk_eint_irq_handler,
 					 eint);
 
-	return 0;
+	return devm_add_action_or_reset(eint->dev, mtk_eint_teardown, eint);
 
 err_eint:
 	for (i = 0; i < eint->nbase; i++) {
-- 
2.53.0



