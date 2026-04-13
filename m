Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD80A3346A5;
	Mon, 13 Apr 2026 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099658; cv=none; b=O1gOi09pzkAYwok87L5Jc9FpH+9udRrpKcjjR/Q/4Z6Dn1QnqMJ8MVV5GHHbGVeKnmtejBK/+1iyVvm7wf/YVQjJUQzwBee8Pnwrf1V1QNj3XloG3bsDoa2bwMeQKHlVqnv3FbYokIeo/6lh+Gev0OHcyjswpyo2E0FIT6s8bM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099658; c=relaxed/simple;
	bh=zKP6fp/Cxl/co1xF1par2nyYxL0OXDOKs4Zb6+P0WW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMzZVJpUWT37yvoserDQ9MyGfbg7SiDA+VB0uydTokwklikOlAnqekuhAQRAPbF55hfX0CatCd2i6YPvRXskOl0BI3Jcl9h457bqrROjsNaR/AAK2w+aTdeXj52G+5Vhr2UE87U6Nq79p5v0HvnzmEY2N1+93qpgebd03IhPjHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tljI3Ofk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tljI3Ofk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427CBC2BCB3;
	Mon, 13 Apr 2026 17:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099658;
	bh=zKP6fp/Cxl/co1xF1par2nyYxL0OXDOKs4Zb6+P0WW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tljI3OfkJ3vWVCVRWFburOcgXSvVr+mFOUOzSbr6TwmiiIszkjP3PuYBVj6a5TCTy
	 /gt5c4Ejb9e7kXZw0DSeasnSf8gMQOXUu8XjdDlgdYvzRJTHH/3B+B00qtFOALiwpo
	 OyR4thRru30JeuxsXKBnLGWHz1nFpij1gHVuf4Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 392/491] phy: renesas: rcar-gen3-usb2: Move IRQ request in probe
Date: Mon, 13 Apr 2026 18:00:37 +0200
Message-ID: <20260413155833.710544554@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit de76809f60cc938d3580bbbd5b04b7d12af6ce3a upstream.

Commit 08b0ad375ca6 ("phy: renesas: rcar-gen3-usb2: move IRQ registration
to init") moved the IRQ request operation from probe to
struct phy_ops::phy_init API to avoid triggering interrupts (which lead to
register accesses) while the PHY clocks (enabled through runtime PM APIs)
are not active. If this happens, it results in a synchronous abort.

One way to reproduce this issue is by enabling CONFIG_DEBUG_SHIRQ, which
calls free_irq() on driver removal.

Move the IRQ request and free operations back to probe, and take the
runtime PM state into account in IRQ handler. This commit is preparatory
for the subsequent fixes in this series.

[claudiu.beznea: fixed conflicts by:
 - dropping irq and obint_enable_bits members of rcar_gen3_chan
 - using USB2_OBINT_BITS marco in rcar_gen3_phy_usb2_irq()
 - keeping irq local variable in rcar_gen3_phy_usb2_probe()
 - dropping channel->irq and channel->obint_enable_bits asssignement from
   probe
 - keeping platform_set_drvdata() and channel->dev assignment in probe]

Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250507125032.565017-3-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 46 +++++++++++++-----------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 646a5140b30e1..f66e0daa23648 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -110,7 +110,6 @@ struct rcar_gen3_chan {
 	struct work_struct work;
 	struct mutex lock;	/* protects rphys[...].powered */
 	enum usb_dr_mode dr_mode;
-	int irq;
 	bool extcon_host;
 	bool is_otg_channel;
 	bool uses_otg_pins;
@@ -396,16 +395,25 @@ static irqreturn_t rcar_gen3_phy_usb2_irq(int irq, void *_ch)
 {
 	struct rcar_gen3_chan *ch = _ch;
 	void __iomem *usb2_base = ch->base;
-	u32 status = readl(usb2_base + USB2_OBINTSTA);
+	struct device *dev = ch->dev;
 	irqreturn_t ret = IRQ_NONE;
+	u32 status;
 
+	pm_runtime_get_noresume(dev);
+
+	if (pm_runtime_suspended(dev))
+		goto rpm_put;
+
+	status = readl(usb2_base + USB2_OBINTSTA);
 	if (status & USB2_OBINT_BITS) {
-		dev_vdbg(ch->dev, "%s: %08x\n", __func__, status);
+		dev_vdbg(dev, "%s: %08x\n", __func__, status);
 		writel(USB2_OBINT_BITS, usb2_base + USB2_OBINTSTA);
 		rcar_gen3_device_recognition(ch);
 		ret = IRQ_HANDLED;
 	}
 
+rpm_put:
+	pm_runtime_put_noidle(dev);
 	return ret;
 }
 
@@ -415,17 +423,6 @@ static int rcar_gen3_phy_usb2_init(struct phy *p)
 	struct rcar_gen3_chan *channel = rphy->ch;
 	void __iomem *usb2_base = channel->base;
 	u32 val;
-	int ret;
-
-	if (!rcar_gen3_is_any_rphy_initialized(channel) && channel->irq >= 0) {
-		INIT_WORK(&channel->work, rcar_gen3_phy_usb2_work);
-		ret = request_irq(channel->irq, rcar_gen3_phy_usb2_irq,
-				  IRQF_SHARED, dev_name(channel->dev), channel);
-		if (ret < 0) {
-			dev_err(channel->dev, "No irq handler (%d)\n", channel->irq);
-			return ret;
-		}
-	}
 
 	/* Initialize USB2 part */
 	val = readl(usb2_base + USB2_INT_ENABLE);
@@ -461,9 +458,6 @@ static int rcar_gen3_phy_usb2_exit(struct phy *p)
 		val &= ~USB2_INT_ENABLE_UCOM_INTEN;
 	writel(val, usb2_base + USB2_INT_ENABLE);
 
-	if (channel->irq >= 0 && !rcar_gen3_is_any_rphy_initialized(channel))
-		free_irq(channel->irq, channel);
-
 	return 0;
 }
 
@@ -612,7 +606,7 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 	struct phy_provider *provider;
 	struct resource *res;
 	const struct phy_ops *phy_usb2_ops;
-	int ret = 0, i;
+	int ret = 0, i, irq;
 
 	if (!dev->of_node) {
 		dev_err(dev, "This driver needs device tree\n");
@@ -628,8 +622,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 	if (IS_ERR(channel->base))
 		return PTR_ERR(channel->base);
 
-	/* get irq number here and request_irq for OTG in phy_init */
-	channel->irq = platform_get_irq_optional(pdev, 0);
 	channel->dr_mode = rcar_gen3_get_dr_mode(dev->of_node);
 	if (channel->dr_mode != USB_DR_MODE_UNKNOWN) {
 		channel->is_otg_channel = true;
@@ -683,6 +675,20 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, channel);
 	channel->dev = dev;
+
+	irq = platform_get_irq_optional(pdev, 0);
+	if (irq < 0 && irq != -ENXIO) {
+		ret = irq;
+		goto error;
+	} else if (irq > 0) {
+		INIT_WORK(&channel->work, rcar_gen3_phy_usb2_work);
+		ret = devm_request_irq(dev, irq, rcar_gen3_phy_usb2_irq,
+				       IRQF_SHARED, dev_name(dev), channel);
+		if (ret < 0) {
+			dev_err(dev, "Failed to request irq (%d)\n", irq);
+			goto error;
+		}
+	}
 
 	provider = devm_of_phy_provider_register(dev, rcar_gen3_phy_usb2_xlate);
 	if (IS_ERR(provider)) {
-- 
2.53.0



