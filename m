Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B2A13A244;
	Tue, 27 May 2025 16:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364289; cv=none; b=qgQWMirQaeLoz/R7lS2oKSPA1z4NbcCcsAgp3RraoJi9eyUWmfCPRcUUMLVwr4gj2VI8bWAQSrE9EAxPZI7K7X5gEMYiiM+4gRFSwAMKTKB3QMRoaGm9TSIJO6eIMW4RgKxgexdNgBvSU2ysKsa9pCFyTymzdhW8mTdL7Tn0e0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364289; c=relaxed/simple;
	bh=1Hsf/zV7LQhFqm+rIFx/qwRNnR0iP56BHoPaezBvw50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uo9KVzAGo91/wlneRKqfmB5hiE1W7zguDmItaxRT0p10VDo/YclbL9ZZrjls029K1mWFYEdleUlKwCbr1Bu/niyqewLNeRfvq5ksl6DDMT76a8kx7gPE+nYhUVG7T6xaTr7J/H3REsqHjODxPmWVtjLJMdW4lLGVxn//Izln6HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0R+rM4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0R+rM4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C207BC4CEE9;
	Tue, 27 May 2025 16:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364289;
	bh=1Hsf/zV7LQhFqm+rIFx/qwRNnR0iP56BHoPaezBvw50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0R+rM4mU6Zg3KP0Q+fkLsGcNL4q1RVzj+WK5hzgSCXCF/v/IA8UqjK17MAZCfS4i
	 prc028RL640xtKP1YnrRCk40ea53dpDyg1+W+kfSVHqahDipS0avMDzawAP+PcucBg
	 DLIdXdOPTEYpY/cirDWKlB05ioNBonZQSw0A/ceg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/626] phy: renesas: rcar-gen3-usb2: Move IRQ request in probe
Date: Tue, 27 May 2025 18:18:20 +0200
Message-ID: <20250527162445.357959247@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit de76809f60cc938d3580bbbd5b04b7d12af6ce3a ]

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

Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250507125032.565017-3-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 9ce71e85b29e ("phy: renesas: rcar-gen3-usb2: Assert PLL reset on PHY power off")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 46 +++++++++++++-----------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 513fd35dcaa95..4cd1b6e677482 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -120,7 +120,6 @@ struct rcar_gen3_chan {
 	struct work_struct work;
 	struct mutex lock;	/* protects rphys[...].powered */
 	enum usb_dr_mode dr_mode;
-	int irq;
 	u32 obint_enable_bits;
 	bool extcon_host;
 	bool is_otg_channel;
@@ -428,16 +427,25 @@ static irqreturn_t rcar_gen3_phy_usb2_irq(int irq, void *_ch)
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
 	if (status & ch->obint_enable_bits) {
-		dev_vdbg(ch->dev, "%s: %08x\n", __func__, status);
+		dev_vdbg(dev, "%s: %08x\n", __func__, status);
 		writel(ch->obint_enable_bits, usb2_base + USB2_OBINTSTA);
 		rcar_gen3_device_recognition(ch);
 		ret = IRQ_HANDLED;
 	}
 
+rpm_put:
+	pm_runtime_put_noidle(dev);
 	return ret;
 }
 
@@ -447,17 +455,6 @@ static int rcar_gen3_phy_usb2_init(struct phy *p)
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
@@ -493,9 +490,6 @@ static int rcar_gen3_phy_usb2_exit(struct phy *p)
 		val &= ~USB2_INT_ENABLE_UCOM_INTEN;
 	writel(val, usb2_base + USB2_INT_ENABLE);
 
-	if (channel->irq >= 0 && !rcar_gen3_is_any_rphy_initialized(channel))
-		free_irq(channel->irq, channel);
-
 	return 0;
 }
 
@@ -701,7 +695,7 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct rcar_gen3_chan *channel;
 	struct phy_provider *provider;
-	int ret = 0, i;
+	int ret = 0, i, irq;
 
 	if (!dev->of_node) {
 		dev_err(dev, "This driver needs device tree\n");
@@ -717,8 +711,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 		return PTR_ERR(channel->base);
 
 	channel->obint_enable_bits = USB2_OBINT_BITS;
-	/* get irq number here and request_irq for OTG in phy_init */
-	channel->irq = platform_get_irq_optional(pdev, 0);
 	channel->dr_mode = rcar_gen3_get_dr_mode(dev->of_node);
 	if (channel->dr_mode != USB_DR_MODE_UNKNOWN) {
 		channel->is_otg_channel = true;
@@ -787,6 +779,20 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 		channel->vbus = NULL;
 	}
 
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
+
 	provider = devm_of_phy_provider_register(dev, rcar_gen3_phy_usb2_xlate);
 	if (IS_ERR(provider)) {
 		dev_err(dev, "Failed to register PHY provider\n");
-- 
2.39.5



