Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD554570EC;
	Sat, 12 Sep 2026 10:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210033; cv=none; b=N002rEgPBPVzpiprNsX1YPpC1XPgpugtGFrnrKUHg6hzSP8rRMuslORmtSJXJQkyg5mbOe43cWa2stMSQvL8BzAhPUthF04vowlzIGWn/RNRu2H0lZnTz5Tup2CxgmwayL/77eof6OXqkaQLPruuAIl8NHSoQn9GzpfUjWkQges=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210033; c=relaxed/simple;
	bh=SAWdpvqNniw1+dq1q8OMvdmCWu/SN4cWPtFPd99L780=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1rOwvbUB9cZ2wV/MkHtmg1jLpvzcjveTvLR44GNjU0rbLhKUn0lNGEuO9pSTdaavRm+283yFONK9mS/7U0x6wL/e/GSFmpaJ/otcuDjTR/mAsez7DYvCSnwHcbMy0LaN/BXl74SnrCjFgvyY57W+Lsiksi13Ix/L9hVIm/cAsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wq+g6eQf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wq+g6eQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6687B1F000FF;
	Sat, 12 Sep 2026 10:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210030;
	bh=6ell62kywtVc/lgjE/ZUwTkAUC/kzwTZHXwKaS82IG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wq+g6eQfMLPqMd/IeR7vWZMfb4rl8CV8ViCfBrw9jqGSfZbokN7QQKF1In0CFWbWS
	 znn2yjCuxVsCPubTGtmSIMaTYB2jgEBHJQSZCdesR2ChcFD1JImKYZDPJ0km6G+kDM
	 zEe5rYXY7ugsrFwDuJzewRXPld2ncccJDfDxsfg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0943/1518] phy: renesas: rcar-gen3-usb2: Factor out VBUS control logic
Date: Sat, 12 Sep 2026 08:51:52 +0200
Message-ID: <20260912065644.784814075@linuxfoundation.org>
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

From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>

[ Upstream commit d6db3b3af74a26b65d1ec1e86f9738c784e7ae29 ]

Refactor the VBUS control logic into a new helper function to improve
code clarity and reduce duplication. This makes it easier to handle
different VBUS control register cases and aids future maintenance.

Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/2d94c9876b965bdf7cd74cdbbc0c54689e122798.1766405010.git.tommaso.merciai.xr@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 49c9b71b4508 ("phy: renesas: phy-rcar-gen3-usb2: Fix devm action registration for disabled VBUS regulator")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 34 +++++++++++++++---------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index a38ead7c8055d..d4588a936f92d 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -203,28 +203,38 @@ static void rcar_gen3_set_linectrl(struct rcar_gen3_chan *ch, int dp, int dm)
 	writel(val, usb2_base + USB2_LINECTRL1);
 }
 
-static void rcar_gen3_enable_vbus_ctrl(struct rcar_gen3_chan *ch, int vbus)
+static void rcar_gen3_phy_usb2_set_vbus(struct rcar_gen3_chan *ch,
+					u32 vbus_ctrl_reg,
+					u32 vbus_ctrl_val,
+					bool enable)
 {
 	void __iomem *usb2_base = ch->base;
-	u32 vbus_ctrl_reg = USB2_ADPCTRL;
-	u32 vbus_ctrl_val = USB2_ADPCTRL_DRVVBUS;
 	u32 val;
 
+	val = readl(usb2_base + vbus_ctrl_reg);
+	if (enable)
+		val |= vbus_ctrl_val;
+	else
+		val &= ~vbus_ctrl_val;
+	writel(val, usb2_base + vbus_ctrl_reg);
+
+	dev_vdbg(ch->dev, "%s: reg=0x%08x, val=%08x, enable=%d\n",
+		 __func__, vbus_ctrl_reg, val, enable);
+}
+
+static void rcar_gen3_enable_vbus_ctrl(struct rcar_gen3_chan *ch, int vbus)
+{
 	if (ch->phy_data->no_adp_ctrl || ch->phy_data->vblvl_ctrl) {
 		if (ch->vbus)
 			regulator_hardware_enable(ch->vbus, vbus);
 
-		vbus_ctrl_reg = USB2_VBCTRL;
-		vbus_ctrl_val = USB2_VBCTRL_VBOUT;
+		rcar_gen3_phy_usb2_set_vbus(ch, USB2_VBCTRL,
+					    USB2_VBCTRL_VBOUT, vbus);
+		return;
 	}
 
-	val = readl(usb2_base + vbus_ctrl_reg);
-	if (vbus)
-		val |= vbus_ctrl_val;
-	else
-		val &= ~vbus_ctrl_val;
-	dev_vdbg(ch->dev, "%s: %08x, %d\n", __func__, val, vbus);
-	writel(val, usb2_base + vbus_ctrl_reg);
+	rcar_gen3_phy_usb2_set_vbus(ch, USB2_ADPCTRL,
+				    USB2_ADPCTRL_DRVVBUS, vbus);
 }
 
 static void rcar_gen3_control_otg_irq(struct rcar_gen3_chan *ch, int enable)
-- 
2.53.0



