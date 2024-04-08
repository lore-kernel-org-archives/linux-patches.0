Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB717FBCF;
	Mon,  8 Apr 2024 14:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585098; cv=none; b=kfiIkrDK5ccBFDM3fZ8m6C8GfltdZMtM+3NQ3RgO9NsjxoSwyxVjor61bH1QANfXoBJcNzT1oN+14NDkNmx7KZ/HH5eAUL6z6RbR52kv0o+XlFef16dJTS8njZ7hgOC1erqPc1OLlTbvQM8aXU7yYjUAoctwyYcouD+4DVVSuhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585098; c=relaxed/simple;
	bh=3jXSzifJVP+K+RBnKIH3foUtxQRXWNpKGXf+FJMf/qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIC7uK1do80UUOxaiC/NSUneRaUgrMCEW995fpUf3iOqjP7GD2DMH8Hd3vkc2WU9LQA3kgGAU3KgYa/CFvSS0+gUvKiqwUFYcjjvQLZ8rfheoFVsT2rcHCTKMlYaTjU9EP4SeSXYD3WY21lJ/9DtAsEYmFyAEw/51QuWpPUqbwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUQ7bnse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUQ7bnse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7C9C433C7;
	Mon,  8 Apr 2024 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585098;
	bh=3jXSzifJVP+K+RBnKIH3foUtxQRXWNpKGXf+FJMf/qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUQ7bnseF8V5eUCyMXzUmQfD9tutt7TFRO/3wLDcm2uxv5N7IEZ8hIitnNMBAFpxk
	 TNgz/+EU+raq7C4Mexb5FF8ebJQo6QOPm6IExrpwXu5BimG+v1p8JWpmT93/P1iwhr
	 1SHYfp1OSt70B3ePZQW0auqhFwN1ko9ETn0mjiQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 663/690] net: usb: asix: suspend embedded PHY if external is used
Date: Mon,  8 Apr 2024 14:58:49 +0200
Message-ID: <20240408125423.706756039@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 4d17d43de9d186150b3289ce99d7a79fcff202f9 ]

In case external PHY is used, we need to take care of embedded PHY.
Since there are no methods to disable this PHY from the MAC side and
keeping RMII reference clock, we need to suspend it.

This patch will reduce electrical noise (PHY is continuing to send FLPs)
and power consumption by 0,22W.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cbc17e7802f5 ("net: fec: Set mac_managed_pm during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix.h         |  3 +++
 drivers/net/usb/asix_devices.c | 18 +++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index c126df1c13ee7..9da88e132d516 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -157,6 +157,8 @@
 #define AX_EEPROM_MAGIC		0xdeadbeef
 #define AX_EEPROM_LEN		0x200
 
+#define AX_EMBD_PHY_ADDR	0x10
+
 /* This structure cannot exceed sizeof(unsigned long [5]) AKA 20 bytes */
 struct asix_data {
 	u8 multi_filter[AX_MCAST_FILTER_SIZE];
@@ -181,6 +183,7 @@ struct asix_common_private {
 	struct asix_rx_fixup_info rx_fixup_info;
 	struct mii_bus *mdio;
 	struct phy_device *phydev;
+	struct phy_device *phydev_int;
 	u16 phy_addr;
 	char phy_name[20];
 	bool embd_phy;
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 396505396a2e4..254637c2b1830 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -698,6 +698,22 @@ static int ax88772_init_phy(struct usbnet *dev)
 
 	phy_attached_info(priv->phydev);
 
+	if (priv->embd_phy)
+		return 0;
+
+	/* In case main PHY is not the embedded PHY and MAC is RMII clock
+	 * provider, we need to suspend embedded PHY by keeping PLL enabled
+	 * (AX_SWRESET_IPPD == 0).
+	 */
+	priv->phydev_int = mdiobus_get_phy(priv->mdio, AX_EMBD_PHY_ADDR);
+	if (!priv->phydev_int) {
+		netdev_err(dev->net, "Could not find internal PHY\n");
+		return -ENODEV;
+	}
+
+	priv->phydev_int->mac_managed_pm = 1;
+	phy_suspend(priv->phydev_int);
+
 	return 0;
 }
 
@@ -753,7 +769,7 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 		return ret;
 
 	priv->phy_addr = ret;
-	priv->embd_phy = ((priv->phy_addr & 0x1f) == 0x10);
+	priv->embd_phy = ((priv->phy_addr & 0x1f) == AX_EMBD_PHY_ADDR);
 
 	ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
 	if (ret < 0) {
-- 
2.43.0



