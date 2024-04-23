Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E76143882;
	Tue, 23 Apr 2024 21:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908453; cv=none; b=qmfKN+M/MXd0KWpNu6jcFqPkERRfKbw+dr64z+S1LwW7PhpCXOGnD/jwhTcMCG1bpOmxOPM4EqEmCjmPeb+WBnVBsl3Egc5qH7zR/sSC3lFYYBDoEPXXro0Tomr4p6A4A/bf5MdUwzb9rSmupB9MVxl20Dk9hsgc3OPOBJwKlHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908453; c=relaxed/simple;
	bh=Y0W4pkNwnjZ2kwVrAze5Hmjto2+lbQFT4qGugsCN4Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0pCjrPL6rP2S6OdUSMmNIcJd/g8yDkwKRcDUJOmCIxOVUGAzV021PEng+YZRTcNPuTHgdXrJuNfE/D+eKT6W7AY87TUMhue8SGnTFqx3wrx3MglbJjr1yRndrelbhS7GeBjMDc1ZAUOzoYrU9sGFVf0izkTRZ1CKgX9lnCJ4qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hbtBwmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hbtBwmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA9BC116B1;
	Tue, 23 Apr 2024 21:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908453;
	bh=Y0W4pkNwnjZ2kwVrAze5Hmjto2+lbQFT4qGugsCN4Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hbtBwmLJM2xmyJVhmnFoh4oK6P794dbvunWsUbRt8rqj58VRRfCcYNyIRqGUyhgn
	 4jEgCLZrxHt8P7jC10v4ZuDXFaImGv1AKIqIHIRVSidGE2Q5+afbOt0xTWahF6gmp0
	 1Qgz8wwb2Wrby1u+QIfcrv8+0BSZkA5GIhg/nKl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 011/158] r8169: fix LED-related deadlock on module removal
Date: Tue, 23 Apr 2024 14:37:13 -0700
Message-ID: <20240423213856.210984181@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 19fa4f2a85d777a8052e869c1b892a2f7556569d upstream.

Binding devm_led_classdev_register() to the netdev is problematic
because on module removal we get a RTNL-related deadlock. Fix this
by avoiding the device-managed LED functions.

Note: We can safely call led_classdev_unregister() for a LED even
if registering it failed, because led_classdev_unregister() detects
this and is a no-op in this case.

Fixes: 18764b883e15 ("r8169: add support for LED's on RTL8168/RTL8101")
Cc: stable@vger.kernel.org
Reported-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.h      |    4 +++-
 drivers/net/ethernet/realtek/r8169_leds.c |   23 +++++++++++++++++------
 drivers/net/ethernet/realtek/r8169_main.c |    6 +++++-
 3 files changed, 25 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -72,6 +72,7 @@ enum mac_version {
 };
 
 struct rtl8169_private;
+struct r8169_led_classdev;
 
 void r8169_apply_firmware(struct rtl8169_private *tp);
 u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp);
@@ -83,4 +84,5 @@ void r8169_get_led_name(struct rtl8169_p
 			char *buf, int buf_len);
 int rtl8168_get_led_mode(struct rtl8169_private *tp);
 int rtl8168_led_mod_ctrl(struct rtl8169_private *tp, u16 mask, u16 val);
-void rtl8168_init_leds(struct net_device *ndev);
+struct r8169_led_classdev *rtl8168_init_leds(struct net_device *ndev);
+void r8169_remove_leds(struct r8169_led_classdev *leds);
--- a/drivers/net/ethernet/realtek/r8169_leds.c
+++ b/drivers/net/ethernet/realtek/r8169_leds.c
@@ -138,20 +138,31 @@ static void rtl8168_setup_ldev(struct r8
 	led_cdev->hw_control_get_device = r8169_led_hw_control_get_device;
 
 	/* ignore errors */
-	devm_led_classdev_register(&ndev->dev, led_cdev);
+	led_classdev_register(&ndev->dev, led_cdev);
 }
 
-void rtl8168_init_leds(struct net_device *ndev)
+struct r8169_led_classdev *rtl8168_init_leds(struct net_device *ndev)
 {
-	/* bind resource mgmt to netdev */
-	struct device *dev = &ndev->dev;
 	struct r8169_led_classdev *leds;
 	int i;
 
-	leds = devm_kcalloc(dev, RTL8168_NUM_LEDS, sizeof(*leds), GFP_KERNEL);
+	leds = kcalloc(RTL8168_NUM_LEDS + 1, sizeof(*leds), GFP_KERNEL);
 	if (!leds)
-		return;
+		return NULL;
 
 	for (i = 0; i < RTL8168_NUM_LEDS; i++)
 		rtl8168_setup_ldev(leds + i, ndev, i);
+
+	return leds;
+}
+
+void r8169_remove_leds(struct r8169_led_classdev *leds)
+{
+	if (!leds)
+		return;
+
+	for (struct r8169_led_classdev *l = leds; l->ndev; l++)
+		led_classdev_unregister(&l->led);
+
+	kfree(leds);
 }
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -634,6 +634,8 @@ struct rtl8169_private {
 	const char *fw_name;
 	struct rtl_fw *rtl_fw;
 
+	struct r8169_led_classdev *leds;
+
 	u32 ocp_base;
 };
 
@@ -4930,6 +4932,8 @@ static void rtl_remove_one(struct pci_de
 
 	cancel_work_sync(&tp->wk.work);
 
+	r8169_remove_leds(tp->leds);
+
 	unregister_netdev(tp->dev);
 
 	if (tp->dash_type != RTL_DASH_NONE)
@@ -5391,7 +5395,7 @@ static int rtl_init_one(struct pci_dev *
 	if (IS_ENABLED(CONFIG_R8169_LEDS) &&
 	    tp->mac_version > RTL_GIGA_MAC_VER_06 &&
 	    tp->mac_version < RTL_GIGA_MAC_VER_61)
-		rtl8168_init_leds(dev);
+		tp->leds = rtl8168_init_leds(dev);
 
 	netdev_info(dev, "%s, %pM, XID %03x, IRQ %d\n",
 		    rtl_chip_infos[chipset].name, dev->dev_addr, xid, tp->irq);


