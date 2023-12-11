Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF8DFC06;
	Mon, 11 Dec 2023 18:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOUkshMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4222CC433C8;
	Mon, 11 Dec 2023 18:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320146;
	bh=CHptDNJnT72ytpcfiuHdI+rFq6jV+PoM82h/UCNsaR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOUkshMG1pQ+p5RHStIa2CEIzfoxpcaDZ0+MfekdrG0gTTdhm2iabedXv/uGNrRhx
	 ScE4kx54ychZqdj8K1zlBb/K6BTiIf88p8zlp98+m5RJjUqSElQ9BNGVMUlLKHgD/M
	 Wm5IZZsLsAbPKQWh2dLNE4og0yN/yB6jBXR1pT/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Reichinger <thomas.reichinger@sohard.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/67] arcnet: restoring support for multiple Sohard Arcnet cards
Date: Mon, 11 Dec 2023 19:22:05 +0100
Message-ID: <20231211182015.997982038@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
References: <20231211182015.049134368@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Reichinger <thomas.reichinger@sohard.de>

[ Upstream commit 6b17a597fc2f13aaaa0a2780eb7edb9ae7ac9aea ]

Probe of Sohard Arcnet cards fails,
if 2 or more cards are installed in a system.
See kernel log:
[    2.759203] arcnet: arcnet loaded
[    2.763648] arcnet:com20020: COM20020 chipset support (by David Woodhouse et al.)
[    2.770585] arcnet:com20020_pci: COM20020 PCI support
[    2.772295] com20020 0000:02:00.0: enabling device (0000 -> 0003)
[    2.772354] (unnamed net_device) (uninitialized): PLX-PCI Controls
...
[    3.071301] com20020 0000:02:00.0 arc0-0 (uninitialized): PCI COM20020: station FFh found at F080h, IRQ 101.
[    3.071305] com20020 0000:02:00.0 arc0-0 (uninitialized): Using CKP 64 - data rate 2.5 Mb/s
[    3.071534] com20020 0000:07:00.0: enabling device (0000 -> 0003)
[    3.071581] (unnamed net_device) (uninitialized): PLX-PCI Controls
...
[    3.369501] com20020 0000:07:00.0: Led pci:green:tx:0-0 renamed to pci:green:tx:0-0_1 due to name collision
[    3.369535] com20020 0000:07:00.0: Led pci:red:recon:0-0 renamed to pci:red:recon:0-0_1 due to name collision
[    3.370586] com20020 0000:07:00.0 arc0-0 (uninitialized): PCI COM20020: station E1h found at C000h, IRQ 35.
[    3.370589] com20020 0000:07:00.0 arc0-0 (uninitialized): Using CKP 64 - data rate 2.5 Mb/s
[    3.370608] com20020: probe of 0000:07:00.0 failed with error -5

commit 5ef216c1f848 ("arcnet: com20020-pci: add rotary index support")
changes the device name of all COM20020 based PCI cards,
even if only some cards support this:
	snprintf(dev->name, sizeof(dev->name), "arc%d-%d", dev->dev_id, i);

The error happens because all Sohard Arcnet cards would be called arc0-0,
since the Sohard Arcnet cards don't have a PLX rotary coder.
I.e. EAE Arcnet cards have a PLX rotary coder,
which sets the first decimal, ensuring unique devices names.

This patch adds two new card feature flags to indicate
which cards support LEDs and the PLX rotary coder.
For EAE based cards the names still depend on the PLX rotary coder
(untested, since missing EAE hardware).
For Sohard based cards, this patch will result in devices
being called arc0, arc1, ... (tested).

Signed-off-by: Thomas Reichinger <thomas.reichinger@sohard.de>
Fixes: 5ef216c1f848 ("arcnet: com20020-pci: add rotary index support")
Link: https://lore.kernel.org/r/20231130113503.6812-1-thomas.reichinger@sohard.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/arcnet/arcdevice.h    |  2 +
 drivers/net/arcnet/com20020-pci.c | 89 ++++++++++++++++---------------
 2 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/drivers/net/arcnet/arcdevice.h b/drivers/net/arcnet/arcdevice.h
index 7178f5349fa8f..7b783ee918346 100644
--- a/drivers/net/arcnet/arcdevice.h
+++ b/drivers/net/arcnet/arcdevice.h
@@ -186,6 +186,8 @@ do {									\
 #define ARC_IS_5MBIT    1   /* card default speed is 5MBit */
 #define ARC_CAN_10MBIT  2   /* card uses COM20022, supporting 10MBit,
 				 but default is 2.5MBit. */
+#define ARC_HAS_LED     4   /* card has software controlled LEDs */
+#define ARC_HAS_ROTARY  8   /* card has rotary encoder */
 
 /* information needed to define an encapsulation driver */
 struct ArcProto {
diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 28dccbc0e8d8f..9d9e4200064f9 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -213,12 +213,13 @@ static int com20020pci_probe(struct pci_dev *pdev,
 		if (!strncmp(ci->name, "EAE PLX-PCI FB2", 15))
 			lp->backplane = 1;
 
-		/* Get the dev_id from the PLX rotary coder */
-		if (!strncmp(ci->name, "EAE PLX-PCI MA1", 15))
-			dev_id_mask = 0x3;
-		dev->dev_id = (inb(priv->misc + ci->rotary) >> 4) & dev_id_mask;
-
-		snprintf(dev->name, sizeof(dev->name), "arc%d-%d", dev->dev_id, i);
+		if (ci->flags & ARC_HAS_ROTARY) {
+			/* Get the dev_id from the PLX rotary coder */
+			if (!strncmp(ci->name, "EAE PLX-PCI MA1", 15))
+				dev_id_mask = 0x3;
+			dev->dev_id = (inb(priv->misc + ci->rotary) >> 4) & dev_id_mask;
+			snprintf(dev->name, sizeof(dev->name), "arc%d-%d", dev->dev_id, i);
+		}
 
 		if (arcnet_inb(ioaddr, COM20020_REG_R_STATUS) == 0xFF) {
 			pr_err("IO address %Xh is empty!\n", ioaddr);
@@ -230,6 +231,10 @@ static int com20020pci_probe(struct pci_dev *pdev,
 			goto err_free_arcdev;
 		}
 
+		ret = com20020_found(dev, IRQF_SHARED);
+		if (ret)
+			goto err_free_arcdev;
+
 		card = devm_kzalloc(&pdev->dev, sizeof(struct com20020_dev),
 				    GFP_KERNEL);
 		if (!card) {
@@ -239,41 +244,39 @@ static int com20020pci_probe(struct pci_dev *pdev,
 
 		card->index = i;
 		card->pci_priv = priv;
-		card->tx_led.brightness_set = led_tx_set;
-		card->tx_led.default_trigger = devm_kasprintf(&pdev->dev,
-						GFP_KERNEL, "arc%d-%d-tx",
-						dev->dev_id, i);
-		card->tx_led.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
-						"pci:green:tx:%d-%d",
-						dev->dev_id, i);
-
-		card->tx_led.dev = &dev->dev;
-		card->recon_led.brightness_set = led_recon_set;
-		card->recon_led.default_trigger = devm_kasprintf(&pdev->dev,
-						GFP_KERNEL, "arc%d-%d-recon",
-						dev->dev_id, i);
-		card->recon_led.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
-						"pci:red:recon:%d-%d",
-						dev->dev_id, i);
-		card->recon_led.dev = &dev->dev;
-		card->dev = dev;
-
-		ret = devm_led_classdev_register(&pdev->dev, &card->tx_led);
-		if (ret)
-			goto err_free_arcdev;
 
-		ret = devm_led_classdev_register(&pdev->dev, &card->recon_led);
-		if (ret)
-			goto err_free_arcdev;
-
-		dev_set_drvdata(&dev->dev, card);
-
-		ret = com20020_found(dev, IRQF_SHARED);
-		if (ret)
-			goto err_free_arcdev;
-
-		devm_arcnet_led_init(dev, dev->dev_id, i);
+		if (ci->flags & ARC_HAS_LED) {
+			card->tx_led.brightness_set = led_tx_set;
+			card->tx_led.default_trigger = devm_kasprintf(&pdev->dev,
+							GFP_KERNEL, "arc%d-%d-tx",
+							dev->dev_id, i);
+			card->tx_led.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
+							"pci:green:tx:%d-%d",
+							dev->dev_id, i);
+
+			card->tx_led.dev = &dev->dev;
+			card->recon_led.brightness_set = led_recon_set;
+			card->recon_led.default_trigger = devm_kasprintf(&pdev->dev,
+							GFP_KERNEL, "arc%d-%d-recon",
+							dev->dev_id, i);
+			card->recon_led.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
+							"pci:red:recon:%d-%d",
+							dev->dev_id, i);
+			card->recon_led.dev = &dev->dev;
+
+			ret = devm_led_classdev_register(&pdev->dev, &card->tx_led);
+			if (ret)
+				goto err_free_arcdev;
+
+			ret = devm_led_classdev_register(&pdev->dev, &card->recon_led);
+			if (ret)
+				goto err_free_arcdev;
+
+			dev_set_drvdata(&dev->dev, card);
+			devm_arcnet_led_init(dev, dev->dev_id, i);
+		}
 
+		card->dev = dev;
 		list_add(&card->list, &priv->list_dev);
 		continue;
 
@@ -329,7 +332,7 @@ static struct com20020_pci_card_info card_info_5mbit = {
 };
 
 static struct com20020_pci_card_info card_info_sohard = {
-	.name = "PLX-PCI",
+	.name = "SOHARD SH ARC-PCI",
 	.devcount = 1,
 	/* SOHARD needs PCI base addr 4 */
 	.chan_map_tbl = {
@@ -364,7 +367,7 @@ static struct com20020_pci_card_info card_info_eae_arc1 = {
 		},
 	},
 	.rotary = 0x0,
-	.flags = ARC_CAN_10MBIT,
+	.flags = ARC_HAS_ROTARY | ARC_HAS_LED | ARC_CAN_10MBIT,
 };
 
 static struct com20020_pci_card_info card_info_eae_ma1 = {
@@ -396,7 +399,7 @@ static struct com20020_pci_card_info card_info_eae_ma1 = {
 		},
 	},
 	.rotary = 0x0,
-	.flags = ARC_CAN_10MBIT,
+	.flags = ARC_HAS_ROTARY | ARC_HAS_LED | ARC_CAN_10MBIT,
 };
 
 static struct com20020_pci_card_info card_info_eae_fb2 = {
@@ -421,7 +424,7 @@ static struct com20020_pci_card_info card_info_eae_fb2 = {
 		},
 	},
 	.rotary = 0x0,
-	.flags = ARC_CAN_10MBIT,
+	.flags = ARC_HAS_ROTARY | ARC_HAS_LED | ARC_CAN_10MBIT,
 };
 
 static const struct pci_device_id com20020pci_id_table[] = {
-- 
2.42.0



