Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809BA330B31;
	Mon, 29 Dec 2025 16:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025118; cv=none; b=GoTem8DrtKbJuXecOAoWuTUXyTz53GOXs9VNVZwlQWHo9BvW7qWO2ti0U4TQ7h/x0rfOe1cmTcnIvSxV6E/8K1A6P0FupGNNDx/0IqzQhPIJFoBhr5euAtLbECOiZT9rKOWj9R97avnMTPTMpNwnhavRX8zzhplwZbgHw9xw48U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025118; c=relaxed/simple;
	bh=01IJvh2EWZWRtq0UojtQ3QBfYBvLrLcZZDoCHzKpAxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlp9YOtcj/F2cyFDu341Cb/Hsn/7Gxh1W3X0eLEaYvBNWFDOk3usKpyQVPrb60Gxe8B3Z3rmoF4VeNAfq/btCzrgffuZPY4NZuIesIpJSid+ubdY3JiO78M6XQi+82mGxK6x/oynEWohkz8sWT30upvh7vko8kflQ85aYVbQ4cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2keu2YQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2keu2YQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60CAC4CEF7;
	Mon, 29 Dec 2025 16:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025118;
	bh=01IJvh2EWZWRtq0UojtQ3QBfYBvLrLcZZDoCHzKpAxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2keu2YQYSvWvTMxWzFQaX2MU9uDDDi7QQGdzHcYWI5DRndzuO94qQcN1jo9Af+Rt4
	 FMfzmoeInko35++74HO6MFgHQXWQ8LIPhvEoQq7kRFV+f06ERsdUnMox1tQjikXMrb
	 x+2UyvBagTbTIMJ69P8laayj/i3wI/r1N19bf9io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/430] net: phy: realtek: eliminate priv->phycr2 variable
Date: Mon, 29 Dec 2025 17:07:40 +0100
Message-ID: <20251229160726.502973932@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 27033d06917758d47162581da7e9de8004049dee ]

The RTL8211F(D)(I)-VD-CG PHY also has support for disabling the CLKOUT,
and we'd like to introduce the "realtek,clkout-disable" property for
that.

But it isn't done through the PHYCR2 register, and it becomes awkward to
have the driver pretend that it is. So just replace the machine-level
"u16 phycr2" variable with a logical "bool disable_clk_out", which
scales better to the other PHY as well.

The change is a complete functional equivalent. Before, if the device
tree property was absent, priv->phycr2 would contain the RTL8211F_CLKOUT_EN
bit as read from hardware. Now, we don't save priv->phycr2, but we just
don't call phy_modify_paged() on it. Also, we can simply call
phy_modify_paged() with the "set" argument to 0.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20251117234033.345679-3-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4f0638b12451 ("net: phy: RTL8211FVD: Restore disabling of PHY-mode EEE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 38 ++++++++++++++++----------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index b26f4d1c6bbfa..1625919a47be8 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -167,8 +167,8 @@ MODULE_LICENSE("GPL");
 
 struct rtl821x_priv {
 	u16 phycr1;
-	u16 phycr2;
 	bool has_phycr2;
+	bool disable_clk_out;
 	struct clk *clk;
 	/* rtl8211f */
 	u16 iner;
@@ -239,15 +239,8 @@ static int rtl821x_probe(struct phy_device *phydev)
 		priv->phycr1 |= RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF;
 
 	priv->has_phycr2 = !(phy_id == RTL_8211FVD_PHYID);
-	if (priv->has_phycr2) {
-		ret = phy_read_paged(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR2);
-		if (ret < 0)
-			return ret;
-
-		priv->phycr2 = ret & RTL8211F_CLKOUT_EN;
-		if (of_property_read_bool(dev->of_node, "realtek,clkout-disable"))
-			priv->phycr2 &= ~RTL8211F_CLKOUT_EN;
-	}
+	priv->disable_clk_out = of_property_read_bool(dev->of_node,
+						      "realtek,clkout-disable");
 
 	phydev->priv = priv;
 
@@ -627,6 +620,23 @@ static int rtl8211f_config_rgmii_delay(struct phy_device *phydev)
 	return 0;
 }
 
+static int rtl8211f_config_clk_out(struct phy_device *phydev)
+{
+	struct rtl821x_priv *priv = phydev->priv;
+	int ret;
+
+	/* The value is preserved if the device tree property is absent */
+	if (!priv->disable_clk_out)
+		return 0;
+
+	ret = phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE,
+			       RTL8211F_PHYCR2, RTL8211F_CLKOUT_EN, 0);
+	if (ret)
+		return ret;
+
+	return genphy_soft_reset(phydev);
+}
+
 static int rtl8211f_config_init(struct phy_device *phydev)
 {
 	struct rtl821x_priv *priv = phydev->priv;
@@ -655,16 +665,14 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	ret = phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE,
-			       RTL8211F_PHYCR2, RTL8211F_CLKOUT_EN,
-			       priv->phycr2);
-	if (ret < 0) {
+	ret = rtl8211f_config_clk_out(phydev);
+	if (ret) {
 		dev_err(dev, "clkout configuration failed: %pe\n",
 			ERR_PTR(ret));
 		return ret;
 	}
 
-	return genphy_soft_reset(phydev);
+	return 0;
 }
 
 static int rtl821x_suspend(struct phy_device *phydev)
-- 
2.51.0



