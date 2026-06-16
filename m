Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FD744CAF9;
	Tue, 16 Jun 2026 15:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625388; cv=none; b=IPW/ZJIu6ak8CQYWJ7xgNu0nMTat1VvfwT1gGl+xpbWRMtmjGZe2rctHykjD9ugzSlI2WxPgpsOTbHeW3+X6WFFA6GgMhJnafl7GNTJ3/obcqyToqAu3FNkVs/zDrpevxIILHh4N7OhyYwUrblrCFu5ghdrbmHBqoWIa8noLXvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625388; c=relaxed/simple;
	bh=clAr/0Xl5MGQGm7VSLdShiUcjUEQ3Pay5iGyt+pMjLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTwlUWtc6LBT34B096yVOfmlWzqOjc6DFlxTeGrEkb+jJovQkrG4lsHILIavZmJpYfj6lO23WT1ugD+NVEePJcvT8jSk5KXVXskUi0Z1RCaHlDOjy7+NFXVnHN4gdqW9ntA/yF/nUSqHmZGe4AnOan37LcIeicnpb5X6adju000=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uGbj2id; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uGbj2id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74D51F000E9;
	Tue, 16 Jun 2026 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625387;
	bh=RinjpnmoG/jSfhwNFHsUlxm3Sx+L0fSM98RlbEwuL7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uGbj2id5AOMKE9orEXr5/zU2KbCfX7k+Kj/7h4yL+UfeOj6H/YM8e8v3VNaYs/dk
	 +kA45YDAJu+foRhnGICBFiMbRosaJ6lYc1zhsIwwHiXKOGqbVmLd+6/M8j7NAHEd4R
	 c1lxgVsyE+4OUqyMOOu3TBvEcKKqQyuXpW3N8qBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/325] net: txgbe: optimize the flow to setup PHY for AML devices
Date: Tue, 16 Jun 2026 20:28:49 +0530
Message-ID: <20260616145104.358541016@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 1f863ce5c71276710a7689c88bf4003fa5173998 ]

To adapt to new firmware for AML devices, the driver should send the
"SET_LINK_CMD" to the firmware only once when switching PHY interface
mode, and no longer needs to re-trigger PHY configuration based on the
RX signal interrupt (TXGBE_GPIOBIT_3).

In previous firmware versions, the PHY was configured only after receiving
"SET_LINK_CMD", and might remain incomplete if the RX signal was lost.
To handle this case, the driver used TXGBE_GPIOBIT_3 interrupt to resend
the command. This workaround is no longer necessary with the new firmware.

And the unknown link speed is permitted in the mailbox buffer.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20251014061726.36660-3-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 0487cfca4651 ("net: txgbe: initialize module info buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  2 -
 .../net/ethernet/wangxun/txgbe/txgbe_aml.c    | 50 ++++++-------------
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  1 +
 3 files changed, 15 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 2f8319e031820c..d367644debef36 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -1271,8 +1271,6 @@ struct wx {
 
 	/* PHY stuff */
 	bool notify_down;
-	int adv_speed;
-	int adv_duplex;
 	unsigned int link;
 	int speed;
 	int duplex;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
index 08b9b426f64846..80413504e4bc86 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
@@ -19,8 +19,8 @@ void txgbe_gpio_init_aml(struct wx *wx)
 {
 	u32 status;
 
-	wr32(wx, WX_GPIO_INTTYPE_LEVEL, TXGBE_GPIOBIT_2 | TXGBE_GPIOBIT_3);
-	wr32(wx, WX_GPIO_INTEN, TXGBE_GPIOBIT_2 | TXGBE_GPIOBIT_3);
+	wr32(wx, WX_GPIO_INTTYPE_LEVEL, TXGBE_GPIOBIT_2);
+	wr32(wx, WX_GPIO_INTEN, TXGBE_GPIOBIT_2);
 
 	status = rd32(wx, WX_GPIO_INTSTATUS);
 	for (int i = 0; i < 6; i++) {
@@ -42,11 +42,6 @@ irqreturn_t txgbe_gpio_irq_handler_aml(int irq, void *data)
 		wr32(wx, WX_GPIO_EOI, TXGBE_GPIOBIT_2);
 		wx_service_event_schedule(wx);
 	}
-	if (status & TXGBE_GPIOBIT_3) {
-		set_bit(WX_FLAG_NEED_LINK_CONFIG, wx->flags);
-		wx_service_event_schedule(wx);
-		wr32(wx, WX_GPIO_EOI, TXGBE_GPIOBIT_3);
-	}
 
 	wr32(wx, WX_GPIO_INTMASK, 0);
 	return IRQ_HANDLED;
@@ -96,6 +91,9 @@ static int txgbe_set_phy_link_hostif(struct wx *wx, int speed, int autoneg, int
 	case SPEED_10000:
 		buffer.speed = TXGBE_LINK_SPEED_10GB_FULL;
 		break;
+	default:
+		buffer.speed = TXGBE_LINK_SPEED_UNKNOWN;
+		break;
 	}
 
 	buffer.fec_mode = TXGBE_PHY_FEC_AUTO;
@@ -106,19 +104,18 @@ static int txgbe_set_phy_link_hostif(struct wx *wx, int speed, int autoneg, int
 					 WX_HI_COMMAND_TIMEOUT, false);
 }
 
-static void txgbe_get_link_capabilities(struct wx *wx)
+static void txgbe_get_link_capabilities(struct wx *wx, int *speed, int *duplex)
 {
 	struct txgbe *txgbe = wx->priv;
 
 	if (test_bit(PHY_INTERFACE_MODE_25GBASER, txgbe->sfp_interfaces))
-		wx->adv_speed = SPEED_25000;
+		*speed = SPEED_25000;
 	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, txgbe->sfp_interfaces))
-		wx->adv_speed = SPEED_10000;
+		*speed = SPEED_10000;
 	else
-		wx->adv_speed = SPEED_UNKNOWN;
+		*speed = SPEED_UNKNOWN;
 
-	wx->adv_duplex = wx->adv_speed == SPEED_UNKNOWN ?
-			 DUPLEX_HALF : DUPLEX_FULL;
+	*duplex = *speed == SPEED_UNKNOWN ? DUPLEX_HALF : DUPLEX_FULL;
 }
 
 static void txgbe_get_phy_link(struct wx *wx, int *speed)
@@ -138,23 +135,11 @@ static void txgbe_get_phy_link(struct wx *wx, int *speed)
 
 int txgbe_set_phy_link(struct wx *wx)
 {
-	int speed, err;
-	u32 gpio;
+	int speed, duplex, err;
 
-	/* Check RX signal */
-	gpio = rd32(wx, WX_GPIO_EXT);
-	if (gpio & TXGBE_GPIOBIT_3)
-		return -ENODEV;
+	txgbe_get_link_capabilities(wx, &speed, &duplex);
 
-	txgbe_get_link_capabilities(wx);
-	if (wx->adv_speed == SPEED_UNKNOWN)
-		return -ENODEV;
-
-	txgbe_get_phy_link(wx, &speed);
-	if (speed == wx->adv_speed)
-		return 0;
-
-	err = txgbe_set_phy_link_hostif(wx, wx->adv_speed, 0, wx->adv_duplex);
+	err = txgbe_set_phy_link_hostif(wx, speed, 0, duplex);
 	if (err) {
 		wx_err(wx, "Failed to setup link\n");
 		return err;
@@ -230,14 +215,7 @@ int txgbe_identify_sfp(struct wx *wx)
 		return -ENODEV;
 	}
 
-	err = txgbe_sfp_to_linkmodes(wx, id);
-	if (err)
-		return err;
-
-	if (gpio & TXGBE_GPIOBIT_3)
-		set_bit(WX_FLAG_NEED_LINK_CONFIG, wx->flags);
-
-	return 0;
+	return txgbe_sfp_to_linkmodes(wx, id);
 }
 
 void txgbe_setup_link(struct wx *wx)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index be78f8f61a7950..34920b49d0c09b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -314,6 +314,7 @@ void txgbe_up(struct wx *wx);
 int txgbe_setup_tc(struct net_device *dev, u8 tc);
 void txgbe_do_reset(struct net_device *netdev);
 
+#define TXGBE_LINK_SPEED_UNKNOWN        0
 #define TXGBE_LINK_SPEED_10GB_FULL      4
 #define TXGBE_LINK_SPEED_25GB_FULL      0x10
 
-- 
2.53.0



