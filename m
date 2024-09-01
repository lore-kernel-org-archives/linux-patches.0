Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED35D184540;
	Sun,  1 Sep 2024 16:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209102; cv=none; b=rvdQ6WNlBtDpQAUV6Erlelz9+SBIMH/z8qxT6OeHQUUzQaoOuhqkukFa7CfzR4qFxbkWnYHx7sTo1/wDz4Q8VXCurIneJvVJRjGrgcghLI21Vx87lpLk7fQzBoVzuJEWi6vSXA/3rXAiXiBE6/mV5lklwRUODhzE3Mg9/E7F4Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209102; c=relaxed/simple;
	bh=x1PTB/SrImpbQlDeJ4bGdU+Ks1+cFGMDZ5glfTcXwHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHJCiN0z8GnG96Bk+HwmSv3OLdfaesP/l/Fu7b0iCb+iFEHDu4flcpOwzppjajMNa3hekbrcKd8Q6NwkSCcXWBm3ly6FpMRpfu/nrpFjNaYfFrn3XRCLK0Hs2HWSCz1uiFrNQwCbTvu04mDepCZTNsDuztJwZFqX/jaboPxHrhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TN7BwooD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TN7BwooD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DE4C4CEC3;
	Sun,  1 Sep 2024 16:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209101;
	bh=x1PTB/SrImpbQlDeJ4bGdU+Ks1+cFGMDZ5glfTcXwHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TN7BwooDYIVOTKwxevc58lkApxqRAXiwfaQ4yxIAckly0NU6ql3orJXDFPsTvDGMu
	 mx90XZtAtWJSJIhY1GYguqJenonucQ0XRxdnL4bQATVwmrQQVLl4gpk9SUnL23hP2p
	 5CcUjtR+i8+u/qGgdSBAXhNRznI6+BsTitLTL+1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	David Miller <davem@davemloft.net>,
	Lars Poeschel <poeschel@lemonage.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/134] nfc: pn533: Add autopoll capability
Date: Sun,  1 Sep 2024 18:17:49 +0200
Message-ID: <20240901160814.708801033@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

From: Lars Poeschel <poeschel@lemonage.de>

[ Upstream commit c64b875fe1e1f6b30e3a15cb74d623349c571001 ]

pn532 devices support an autopoll command, that lets the chip
automatically poll for selected nfc technologies instead of manually
looping through every single nfc technology the user is interested in.
This is faster and less cpu and bus intensive than manually polling.
This adds this autopoll capability to the pn533 driver.

Cc: Johan Hovold <johan@kernel.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: febccb39255f ("nfc: pn533: Add poll mod list filling check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/pn533.c | 193 +++++++++++++++++++++++++++++++++++++-
 drivers/nfc/pn533/pn533.h |  10 +-
 2 files changed, 197 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index c36cd68b47eb5..1c3da3675d7df 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -185,6 +185,32 @@ struct pn533_cmd_jump_dep_response {
 	u8 gt[];
 } __packed;
 
+struct pn532_autopoll_resp {
+	u8 type;
+	u8 ln;
+	u8 tg;
+	u8 tgdata[];
+};
+
+/* PN532_CMD_IN_AUTOPOLL */
+#define PN532_AUTOPOLL_POLLNR_INFINITE	0xff
+#define PN532_AUTOPOLL_PERIOD		0x03 /* in units of 150 ms */
+
+#define PN532_AUTOPOLL_TYPE_GENERIC_106		0x00
+#define PN532_AUTOPOLL_TYPE_GENERIC_212		0x01
+#define PN532_AUTOPOLL_TYPE_GENERIC_424		0x02
+#define PN532_AUTOPOLL_TYPE_JEWEL		0x04
+#define PN532_AUTOPOLL_TYPE_MIFARE		0x10
+#define PN532_AUTOPOLL_TYPE_FELICA212		0x11
+#define PN532_AUTOPOLL_TYPE_FELICA424		0x12
+#define PN532_AUTOPOLL_TYPE_ISOA		0x20
+#define PN532_AUTOPOLL_TYPE_ISOB		0x23
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_106	0x40
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_212	0x41
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_424	0x42
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_106	0x80
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_212	0x81
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_424	0x82
 
 /* PN533_TG_INIT_AS_TARGET */
 #define PN533_INIT_TARGET_PASSIVE 0x1
@@ -1394,6 +1420,101 @@ static int pn533_poll_dep(struct nfc_dev *nfc_dev)
 	return rc;
 }
 
+static int pn533_autopoll_complete(struct pn533 *dev, void *arg,
+			       struct sk_buff *resp)
+{
+	struct pn532_autopoll_resp *apr;
+	struct nfc_target nfc_tgt;
+	u8 nbtg;
+	int rc;
+
+	if (IS_ERR(resp)) {
+		rc = PTR_ERR(resp);
+
+		nfc_err(dev->dev, "%s  autopoll complete error %d\n",
+			__func__, rc);
+
+		if (rc == -ENOENT) {
+			if (dev->poll_mod_count != 0)
+				return rc;
+			goto stop_poll;
+		} else if (rc < 0) {
+			nfc_err(dev->dev,
+				"Error %d when running autopoll\n", rc);
+			goto stop_poll;
+		}
+	}
+
+	nbtg = resp->data[0];
+	if ((nbtg > 2) || (nbtg <= 0))
+		return -EAGAIN;
+
+	apr = (struct pn532_autopoll_resp *)&resp->data[1];
+	while (nbtg--) {
+		memset(&nfc_tgt, 0, sizeof(struct nfc_target));
+		switch (apr->type) {
+		case PN532_AUTOPOLL_TYPE_ISOA:
+			dev_dbg(dev->dev, "ISOA\n");
+			rc = pn533_target_found_type_a(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_FELICA212:
+		case PN532_AUTOPOLL_TYPE_FELICA424:
+			dev_dbg(dev->dev, "FELICA\n");
+			rc = pn533_target_found_felica(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_JEWEL:
+			dev_dbg(dev->dev, "JEWEL\n");
+			rc = pn533_target_found_jewel(&nfc_tgt, apr->tgdata,
+						      apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_ISOB:
+			dev_dbg(dev->dev, "ISOB\n");
+			rc = pn533_target_found_type_b(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_MIFARE:
+			dev_dbg(dev->dev, "Mifare\n");
+			rc = pn533_target_found_type_a(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		default:
+			nfc_err(dev->dev,
+				    "Unknown current poll modulation\n");
+			rc = -EPROTO;
+		}
+
+		if (rc)
+			goto done;
+
+		if (!(nfc_tgt.supported_protocols & dev->poll_protocols)) {
+			nfc_err(dev->dev,
+				    "The Tg found doesn't have the desired protocol\n");
+			rc = -EAGAIN;
+			goto done;
+		}
+
+		dev->tgt_available_prots = nfc_tgt.supported_protocols;
+		apr = (struct pn532_autopoll_resp *)
+			(apr->tgdata + (apr->ln - 1));
+	}
+
+	pn533_poll_reset_mod_list(dev);
+	nfc_targets_found(dev->nfc_dev, &nfc_tgt, 1);
+
+done:
+	dev_kfree_skb(resp);
+	return rc;
+
+stop_poll:
+	nfc_err(dev->dev, "autopoll operation has been stopped\n");
+
+	pn533_poll_reset_mod_list(dev);
+	dev->poll_protocols = 0;
+	return rc;
+}
+
 static int pn533_poll_complete(struct pn533 *dev, void *arg,
 			       struct sk_buff *resp)
 {
@@ -1537,6 +1658,7 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 	struct pn533_poll_modulations *cur_mod;
+	struct sk_buff *skb;
 	u8 rand_mod;
 	int rc;
 
@@ -1562,9 +1684,73 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
 			tm_protocols = 0;
 	}
 
-	pn533_poll_create_mod_list(dev, im_protocols, tm_protocols);
 	dev->poll_protocols = im_protocols;
 	dev->listen_protocols = tm_protocols;
+	if (dev->device_type == PN533_DEVICE_PN532_AUTOPOLL) {
+		skb = pn533_alloc_skb(dev, 4 + 6);
+		if (!skb)
+			return -ENOMEM;
+
+		*((u8 *)skb_put(skb, sizeof(u8))) =
+			PN532_AUTOPOLL_POLLNR_INFINITE;
+		*((u8 *)skb_put(skb, sizeof(u8))) = PN532_AUTOPOLL_PERIOD;
+
+		if ((im_protocols & NFC_PROTO_MIFARE_MASK) &&
+				(im_protocols & NFC_PROTO_ISO14443_MASK) &&
+				(im_protocols & NFC_PROTO_NFC_DEP_MASK))
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_GENERIC_106;
+		else {
+			if (im_protocols & NFC_PROTO_MIFARE_MASK)
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_MIFARE;
+
+			if (im_protocols & NFC_PROTO_ISO14443_MASK)
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_ISOA;
+
+			if (im_protocols & NFC_PROTO_NFC_DEP_MASK) {
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_DEP_PASSIVE_106;
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_DEP_PASSIVE_212;
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_DEP_PASSIVE_424;
+			}
+		}
+
+		if (im_protocols & NFC_PROTO_FELICA_MASK ||
+				im_protocols & NFC_PROTO_NFC_DEP_MASK) {
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_FELICA212;
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_FELICA424;
+		}
+
+		if (im_protocols & NFC_PROTO_JEWEL_MASK)
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_JEWEL;
+
+		if (im_protocols & NFC_PROTO_ISO14443_B_MASK)
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_ISOB;
+
+		if (tm_protocols)
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_DEP_ACTIVE_106;
+
+		rc = pn533_send_cmd_async(dev, PN533_CMD_IN_AUTOPOLL, skb,
+				pn533_autopoll_complete, NULL);
+
+		if (rc < 0)
+			dev_kfree_skb(skb);
+		else
+			dev->poll_mod_count++;
+
+		return rc;
+	}
+
+	pn533_poll_create_mod_list(dev, im_protocols, tm_protocols);
 
 	/* Do not always start polling from the same modulation */
 	get_random_bytes(&rand_mod, sizeof(rand_mod));
@@ -2468,7 +2654,8 @@ static int pn533_dev_up(struct nfc_dev *nfc_dev)
 	if (dev->phy_ops->dev_up)
 		dev->phy_ops->dev_up(dev);
 
-	if (dev->device_type == PN533_DEVICE_PN532) {
+	if ((dev->device_type == PN533_DEVICE_PN532) ||
+		(dev->device_type == PN533_DEVICE_PN532_AUTOPOLL)) {
 		int rc = pn532_sam_configuration(nfc_dev);
 
 		if (rc)
@@ -2515,6 +2702,7 @@ static int pn533_setup(struct pn533 *dev)
 	case PN533_DEVICE_PASORI:
 	case PN533_DEVICE_ACR122U:
 	case PN533_DEVICE_PN532:
+	case PN533_DEVICE_PN532_AUTOPOLL:
 		max_retries.mx_rty_atr = 0x2;
 		max_retries.mx_rty_psl = 0x1;
 		max_retries.mx_rty_passive_act =
@@ -2551,6 +2739,7 @@ static int pn533_setup(struct pn533 *dev)
 	switch (dev->device_type) {
 	case PN533_DEVICE_STD:
 	case PN533_DEVICE_PN532:
+	case PN533_DEVICE_PN532_AUTOPOLL:
 		break;
 
 	case PN533_DEVICE_PASORI:
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index 570ee0a3e832b..f9256e5485acc 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -6,10 +6,11 @@
  * Copyright (C) 2012-2013 Tieto Poland
  */
 
-#define PN533_DEVICE_STD     0x1
-#define PN533_DEVICE_PASORI  0x2
-#define PN533_DEVICE_ACR122U 0x3
-#define PN533_DEVICE_PN532   0x4
+#define PN533_DEVICE_STD		0x1
+#define PN533_DEVICE_PASORI		0x2
+#define PN533_DEVICE_ACR122U		0x3
+#define PN533_DEVICE_PN532		0x4
+#define PN533_DEVICE_PN532_AUTOPOLL	0x5
 
 #define PN533_ALL_PROTOCOLS (NFC_PROTO_JEWEL_MASK | NFC_PROTO_MIFARE_MASK |\
 			     NFC_PROTO_FELICA_MASK | NFC_PROTO_ISO14443_MASK |\
@@ -70,6 +71,7 @@
 #define PN533_CMD_IN_ATR 0x50
 #define PN533_CMD_IN_RELEASE 0x52
 #define PN533_CMD_IN_JUMP_FOR_DEP 0x56
+#define PN533_CMD_IN_AUTOPOLL 0x60
 
 #define PN533_CMD_TG_INIT_AS_TARGET 0x8c
 #define PN533_CMD_TG_GET_DATA 0x86
-- 
2.43.0



