Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7E11E50A;
	Tue, 30 Apr 2024 11:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475332; cv=none; b=fJ5PZH5lJuKqPwrvzvai2yJtsfkF/UW+jr1vN2UNtWn1OTszqGe8abUdW2z9ky/EwlxnOl+9IxaKOk/HEgT8yuqDlIB0VgVD9MYMlz/iKAg0zIePYQtye34eB5PDi/ANVcN41OpOT3JbrQx8tCoK2CYgeejuZPWKZJ33jrACavM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475332; c=relaxed/simple;
	bh=/xr2OAPd0PJ7NxjcmgEAgy33vvMHsB6r1arZ4oshd1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWzleleGP37lxaGDM7zVKqUC1prejro4lxu5GlnnFT+NojkToYqtbOFn1aNVzJn5WOAXx00FEswBU6Cysux69rMMHVUfSJIDOsOTW/e+H5tnuqTmeETS9Y0PyxDwyhIppH6/AiYvhDsV79/b8RDEdhqtONMSFcmIVFCVEYnXaGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGXhEEiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGXhEEiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5511C2BBFC;
	Tue, 30 Apr 2024 11:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475332;
	bh=/xr2OAPd0PJ7NxjcmgEAgy33vvMHsB6r1arZ4oshd1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGXhEEiF9U2jJWIbrrimtHmaxQVpD7pI1qRNeM+b4LQoY5elGJOcUCPop/LwZ3fWo
	 /abjdcTYmB9isEUE4ad6MKkPB5YwmaAkAJZr1ZHk2Fqt9WNHK9Mnld172xR6SE1gXJ
	 dwPW6FILrnqTDuO0ltGCPhXol2vXHX6RrijVkrF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/186] net: phy: mediatek-ge-soc: follow netdev LED trigger semantics
Date: Tue, 30 Apr 2024 12:38:36 +0200
Message-ID: <20240430103059.896400653@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 5b5f724b05c550e10693a53a81cadca901aefd16 ]

Only blink if the link is up on a LED which is programmed to also
indicate link-status.

Otherwise, if both LEDs are in use to indicate different speeds, the
resulting blinking being inverted on LEDs which aren't switched on at
a specific speed is quite counter-intuitive.

Also make sure that state left behind by reset or the bootloader is
recognized correctly including the half-duplex and full-duplex bits as
well as the (unsupported by Linux netdev trigger semantics) link-down
bit.

Fixes: c66937b0f8db ("net: phy: mediatek-ge-soc: support PHY LEDs")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mediatek-ge-soc.c | 43 +++++++++++++++++++------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/mediatek-ge-soc.c b/drivers/net/phy/mediatek-ge-soc.c
index 0f3a1538a8b8e..f4f9412d0cd7e 100644
--- a/drivers/net/phy/mediatek-ge-soc.c
+++ b/drivers/net/phy/mediatek-ge-soc.c
@@ -216,6 +216,9 @@
 #define   MTK_PHY_LED_ON_LINK1000		BIT(0)
 #define   MTK_PHY_LED_ON_LINK100		BIT(1)
 #define   MTK_PHY_LED_ON_LINK10			BIT(2)
+#define   MTK_PHY_LED_ON_LINK			(MTK_PHY_LED_ON_LINK10 |\
+						 MTK_PHY_LED_ON_LINK100 |\
+						 MTK_PHY_LED_ON_LINK1000)
 #define   MTK_PHY_LED_ON_LINKDOWN		BIT(3)
 #define   MTK_PHY_LED_ON_FDX			BIT(4) /* Full duplex */
 #define   MTK_PHY_LED_ON_HDX			BIT(5) /* Half duplex */
@@ -231,6 +234,12 @@
 #define   MTK_PHY_LED_BLINK_100RX		BIT(3)
 #define   MTK_PHY_LED_BLINK_10TX		BIT(4)
 #define   MTK_PHY_LED_BLINK_10RX		BIT(5)
+#define   MTK_PHY_LED_BLINK_RX			(MTK_PHY_LED_BLINK_10RX |\
+						 MTK_PHY_LED_BLINK_100RX |\
+						 MTK_PHY_LED_BLINK_1000RX)
+#define   MTK_PHY_LED_BLINK_TX			(MTK_PHY_LED_BLINK_10TX |\
+						 MTK_PHY_LED_BLINK_100TX |\
+						 MTK_PHY_LED_BLINK_1000TX)
 #define   MTK_PHY_LED_BLINK_COLLISION		BIT(6)
 #define   MTK_PHY_LED_BLINK_RX_CRC_ERR		BIT(7)
 #define   MTK_PHY_LED_BLINK_RX_IDLE_ERR		BIT(8)
@@ -1247,11 +1256,9 @@ static int mt798x_phy_led_hw_control_get(struct phy_device *phydev, u8 index,
 	if (blink < 0)
 		return -EIO;
 
-	if ((on & (MTK_PHY_LED_ON_LINK1000 | MTK_PHY_LED_ON_LINK100 |
-		   MTK_PHY_LED_ON_LINK10)) ||
-	    (blink & (MTK_PHY_LED_BLINK_1000RX | MTK_PHY_LED_BLINK_100RX |
-		      MTK_PHY_LED_BLINK_10RX | MTK_PHY_LED_BLINK_1000TX |
-		      MTK_PHY_LED_BLINK_100TX | MTK_PHY_LED_BLINK_10TX)))
+	if ((on & (MTK_PHY_LED_ON_LINK | MTK_PHY_LED_ON_FDX | MTK_PHY_LED_ON_HDX |
+		   MTK_PHY_LED_ON_LINKDOWN)) ||
+	    (blink & (MTK_PHY_LED_BLINK_RX | MTK_PHY_LED_BLINK_TX)))
 		set_bit(bit_netdev, &priv->led_state);
 	else
 		clear_bit(bit_netdev, &priv->led_state);
@@ -1269,7 +1276,7 @@ static int mt798x_phy_led_hw_control_get(struct phy_device *phydev, u8 index,
 	if (!rules)
 		return 0;
 
-	if (on & (MTK_PHY_LED_ON_LINK1000 | MTK_PHY_LED_ON_LINK100 | MTK_PHY_LED_ON_LINK10))
+	if (on & MTK_PHY_LED_ON_LINK)
 		*rules |= BIT(TRIGGER_NETDEV_LINK);
 
 	if (on & MTK_PHY_LED_ON_LINK10)
@@ -1287,10 +1294,10 @@ static int mt798x_phy_led_hw_control_get(struct phy_device *phydev, u8 index,
 	if (on & MTK_PHY_LED_ON_HDX)
 		*rules |= BIT(TRIGGER_NETDEV_HALF_DUPLEX);
 
-	if (blink & (MTK_PHY_LED_BLINK_1000RX | MTK_PHY_LED_BLINK_100RX | MTK_PHY_LED_BLINK_10RX))
+	if (blink & MTK_PHY_LED_BLINK_RX)
 		*rules |= BIT(TRIGGER_NETDEV_RX);
 
-	if (blink & (MTK_PHY_LED_BLINK_1000TX | MTK_PHY_LED_BLINK_100TX | MTK_PHY_LED_BLINK_10TX))
+	if (blink & MTK_PHY_LED_BLINK_TX)
 		*rules |= BIT(TRIGGER_NETDEV_TX);
 
 	return 0;
@@ -1323,15 +1330,19 @@ static int mt798x_phy_led_hw_control_set(struct phy_device *phydev, u8 index,
 		on |= MTK_PHY_LED_ON_LINK1000;
 
 	if (rules & BIT(TRIGGER_NETDEV_RX)) {
-		blink |= MTK_PHY_LED_BLINK_10RX  |
-			 MTK_PHY_LED_BLINK_100RX |
-			 MTK_PHY_LED_BLINK_1000RX;
+		blink |= (on & MTK_PHY_LED_ON_LINK) ?
+			  (((on & MTK_PHY_LED_ON_LINK10) ? MTK_PHY_LED_BLINK_10RX : 0) |
+			   ((on & MTK_PHY_LED_ON_LINK100) ? MTK_PHY_LED_BLINK_100RX : 0) |
+			   ((on & MTK_PHY_LED_ON_LINK1000) ? MTK_PHY_LED_BLINK_1000RX : 0)) :
+			  MTK_PHY_LED_BLINK_RX;
 	}
 
 	if (rules & BIT(TRIGGER_NETDEV_TX)) {
-		blink |= MTK_PHY_LED_BLINK_10TX  |
-			 MTK_PHY_LED_BLINK_100TX |
-			 MTK_PHY_LED_BLINK_1000TX;
+		blink |= (on & MTK_PHY_LED_ON_LINK) ?
+			  (((on & MTK_PHY_LED_ON_LINK10) ? MTK_PHY_LED_BLINK_10TX : 0) |
+			   ((on & MTK_PHY_LED_ON_LINK100) ? MTK_PHY_LED_BLINK_100TX : 0) |
+			   ((on & MTK_PHY_LED_ON_LINK1000) ? MTK_PHY_LED_BLINK_1000TX : 0)) :
+			  MTK_PHY_LED_BLINK_TX;
 	}
 
 	if (blink || on)
@@ -1344,9 +1355,7 @@ static int mt798x_phy_led_hw_control_set(struct phy_device *phydev, u8 index,
 				MTK_PHY_LED0_ON_CTRL,
 			     MTK_PHY_LED_ON_FDX     |
 			     MTK_PHY_LED_ON_HDX     |
-			     MTK_PHY_LED_ON_LINK10  |
-			     MTK_PHY_LED_ON_LINK100 |
-			     MTK_PHY_LED_ON_LINK1000,
+			     MTK_PHY_LED_ON_LINK,
 			     on);
 
 	if (ret)
-- 
2.43.0



