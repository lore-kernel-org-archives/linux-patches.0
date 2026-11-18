Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061372;
	b=ZFX/q28IwpGGMMyqPMJVcfTsGpvuYquajrflE16iKd9oFLt6WcC212m1/ORaPOHGMD3P
	 AUwU471+RxJU6tzEHkDKZpGVyQo7jry1rdKF6pc8hm1jJJlaZV6MfV+OA3p2pFMDlRGOy
	 FYJ5OXksDQQvjyWjkjYlfHmsshccJ+6isNbUN9D0gx7CsG3H1/5rqvLEccmjekKv9blOw
	 QC6rUoMvZcJdD3ltBJJEiRkXPjeMPrXW9NcmCpPyn/ZMkQIHBzVKk5+hJ6aIDX8pBHmBJ
	 zzX/dgRjhGgVP8s1imgBEjyyHSuhTTpI4UiUWv+eA4+hs14+gMZlCkN0sAKHPwJ24kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ncwaUsbjmORgapUBJCQCJR0tIPYLNM0pSDEoGYiIGnk=;
	b=jNQbE883+EX6GcTYoCOZmMLHXtYak9j0TV+jpSJvHWk0l8iq5s+F4vZWqXiw1kJYvGib
	 Cc+qqWVPwGbUmuJjanHxC95OtfpBWBox7kplExdiLid1fQXtFCsWii/W3iSNI1ltkLtxE
	 4DEeMerqsmkLMu+2bytx0HQxwYEvY1a2ZCrbSU+JauyKqAVF8z+44wY832LbaictGweUI
	 uQoy7CJyKD1GvmQ8171keWup+PfVTH6oyE311QiOBV30nRoW5bKTShyJIUR301TCdIDNb
	 a3RzTiCzKe5Xr+uwYYSOfT7+fRaMZm1Yac7jENoEf9E85bCI4oWZW4zOA1irIIX4rWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PBPsHXB3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B453606A326;
	Thu, 19 Nov 2026 04:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PBPsHXB3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC95C1F000C4;
	Thu, 19 Nov 2026 04:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061372;
	bh=ncwaUsbjmORgapUBJCQCJR0tIPYLNM0pSDEoGYiIGnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PBPsHXB3vLmfuMsLKIppmcgUbSdQgihpnqKfE7llS3KPNAOARiNDVWlg0YvANnNdw
	 Bu26iVyxN2RjUyCezT+7DIn4sSSCO0/BKUbSVlFi1SgT6ksmrMDNRHgqouESaYIe1K
	 qrcOSszQefzjAdl+gXdrKFE2STa3Vjk6JPkawOZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1529/1848] mt76: implement .mcu_parse_response in struct mt76_mcu_ops
Date: Wed, 18 Nov 2026 15:59:27 +0100
Message-ID: <20261118150023.403089695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit f320d812b7bbd30abb5699971051e8b494df6278 ]

Do not free skb inside that function
Preparation for further cleanup

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 40217d8e6cba ("wifi: mt76: mt7615: read MT7663 temperature from the correct offset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 ++
 .../net/wireless/mediatek/mt76/mt7603/mcu.c   | 24 ++++++++++++-------
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 18 +++++++-------
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  2 ++
 .../wireless/mediatek/mt76/mt7615/sdio_mcu.c  |  1 +
 .../wireless/mediatek/mt76/mt7615/usb_mcu.c   |  1 +
 .../wireless/mediatek/mt76/mt76x0/pci_mcu.c   |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_mcu.c  | 23 +++++++++++-------
 .../net/wireless/mediatek/mt76/mt76x02_mcu.h  |  2 ++
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |  1 +
 .../wireless/mediatek/mt76/mt76x2/pci_mcu.c   |  1 +
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 15 ++++++------
 12 files changed, 55 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 16e65020a242d..ca8c2b25e63fa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -148,6 +148,8 @@ struct mt76_mcu_ops {
 			    int len, bool wait_resp);
 	int (*mcu_skb_send_msg)(struct mt76_dev *dev, struct sk_buff *skb,
 				int cmd, bool wait_resp);
+	int (*mcu_parse_response)(struct mt76_dev *dev, int cmd,
+				  struct sk_buff *skb, int seq);
 	u32 (*mcu_rr)(struct mt76_dev *dev, u32 offset);
 	void (*mcu_wr)(struct mt76_dev *dev, u32 offset, u32 val);
 	int (*mcu_wr_rp)(struct mt76_dev *dev, u32 base,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index a47a3a644ecc0..e69748dad1e1d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -13,6 +13,18 @@ struct mt7603_fw_trailer {
 	__le32 dl_len;
 } __packed;
 
+static int
+mt7603_mcu_parse_response(struct mt76_dev *mdev, int cmd,
+			  struct sk_buff *skb, int seq)
+{
+	struct mt7603_mcu_rxd *rxd = (struct mt7603_mcu_rxd *)skb->data;
+
+	if (seq != rxd->seq)
+		return -EAGAIN;
+
+	return 0;
+}
+
 static int
 __mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb,
 		      int cmd, int *wait_seq)
@@ -58,7 +70,6 @@ mt7603_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 {
 	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
 	unsigned long expires = jiffies + 3 * HZ;
-	struct mt7603_mcu_rxd *rxd;
 	struct sk_buff *skb;
 	int ret, seq;
 
@@ -73,8 +84,6 @@ mt7603_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 		goto out;
 
 	while (wait_resp) {
-		bool check_seq = false;
-
 		skb = mt76_mcu_get_response(&dev->mt76, expires);
 		if (!skb) {
 			dev_err(mdev->dev,
@@ -85,13 +94,9 @@ mt7603_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 			break;
 		}
 
-		rxd = (struct mt7603_mcu_rxd *)skb->data;
-		if (seq == rxd->seq)
-			check_seq = true;
-
+		ret = mt7603_mcu_parse_response(mdev, cmd, skb, seq);
 		dev_kfree_skb(skb);
-
-		if (check_seq)
+		if (ret != -EAGAIN)
 			break;
 	}
 
@@ -267,6 +272,7 @@ int mt7603_mcu_init(struct mt7603_dev *dev)
 	static const struct mt76_mcu_ops mt7603_mcu_ops = {
 		.headroom = sizeof(struct mt7603_mcu_txd),
 		.mcu_send_msg = mt7603_mcu_msg_send,
+		.mcu_parse_response = mt7603_mcu_parse_response,
 		.mcu_restart = mt7603_mcu_restart,
 	};
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 62a971660da73..88e8157f6c960 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -179,17 +179,14 @@ static int __mt7615_mcu_msg_send(struct mt7615_dev *dev, struct sk_buff *skb,
 	return mt76_tx_queue_skb_raw(dev, qid, skb, 0);
 }
 
-static int
-mt7615_mcu_parse_response(struct mt7615_dev *dev, int cmd,
-			  struct sk_buff *skb, int seq)
+int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
+			      struct sk_buff *skb, int seq)
 {
 	struct mt7615_mcu_rxd *rxd = (struct mt7615_mcu_rxd *)skb->data;
 	int ret = 0;
 
-	if (seq != rxd->seq) {
-		ret = -EAGAIN;
-		goto out;
-	}
+	if (seq != rxd->seq)
+		return -EAGAIN;
 
 	switch (cmd) {
 	case MCU_CMD_PATCH_SEM_CONTROL:
@@ -228,11 +225,10 @@ mt7615_mcu_parse_response(struct mt7615_dev *dev, int cmd,
 	default:
 		break;
 	}
-out:
-	dev_kfree_skb(skb);
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mt7615_mcu_parse_response);
 
 int mt7615_mcu_wait_response(struct mt7615_dev *dev, int cmd, int seq)
 {
@@ -248,7 +244,8 @@ int mt7615_mcu_wait_response(struct mt7615_dev *dev, int cmd, int seq)
 			return -ETIMEDOUT;
 		}
 
-		ret = mt7615_mcu_parse_response(dev, cmd, skb, seq);
+		ret = mt7615_mcu_parse_response(&dev->mt76, cmd, skb, seq);
+		dev_kfree_skb(skb);
 		if (ret != -EAGAIN)
 			break;
 	}
@@ -2476,6 +2473,7 @@ int mt7615_mcu_init(struct mt7615_dev *dev)
 		.headroom = sizeof(struct mt7615_mcu_txd),
 		.mcu_skb_send_msg = mt7615_mcu_send_message,
 		.mcu_send_msg = mt7615_mcu_msg_send,
+		.mcu_parse_response = mt7615_mcu_parse_response,
 		.mcu_restart = mt7615_mcu_restart,
 	};
 	int ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index 4cee76691786e..7238ab8ed84f0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -590,6 +590,8 @@ u32 mt7615_mac_get_sta_tid_sn(struct mt7615_dev *dev, int wcid, u8 tid);
 int mt7615_mcu_wait_response(struct mt7615_dev *dev, int cmd, int seq);
 int mt7615_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 			int len, bool wait_resp);
+int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
+			      struct sk_buff *skb, int seq);
 u32 mt7615_rf_rr(struct mt7615_dev *dev, u32 wf, u32 reg);
 int mt7615_rf_wr(struct mt7615_dev *dev, u32 wf, u32 reg, u32 val);
 int mt7615_mcu_set_dbdc(struct mt7615_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/sdio_mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/sdio_mcu.c
index 38670c00380c6..263f3a65878f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio_mcu.c
@@ -128,6 +128,7 @@ int mt7663s_mcu_init(struct mt7615_dev *dev)
 		.tailroom = MT_USB_TAIL_SIZE,
 		.mcu_skb_send_msg = mt7663s_mcu_send_message,
 		.mcu_send_msg = mt7615_mcu_msg_send,
+		.mcu_parse_response = mt7615_mcu_parse_response,
 		.mcu_restart = mt7615_mcu_restart,
 		.mcu_rr = mt7615_mcu_reg_rr,
 		.mcu_wr = mt7615_mcu_reg_wr,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c
index 4d8be366af31b..4bac8fda47141 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c
@@ -57,6 +57,7 @@ int mt7663u_mcu_init(struct mt7615_dev *dev)
 		.tailroom = MT_USB_TAIL_SIZE,
 		.mcu_skb_send_msg = mt7663u_mcu_send_message,
 		.mcu_send_msg = mt7615_mcu_msg_send,
+		.mcu_parse_response = mt7615_mcu_parse_response,
 		.mcu_restart = mt7615_mcu_restart,
 	};
 	int ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
index 007c762c6db10..f0962507f72f4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
@@ -117,6 +117,7 @@ int mt76x0e_mcu_init(struct mt76x02_dev *dev)
 {
 	static const struct mt76_mcu_ops mt76x0e_mcu_ops = {
 		.mcu_send_msg = mt76x02_mcu_msg_send,
+		.mcu_parse_response = mt76x02_mcu_parse_response,
 	};
 	int err;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index 267058086a903..2b5068de6c7df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
@@ -10,6 +10,18 @@
 
 #include "mt76x02_mcu.h"
 
+int mt76x02_mcu_parse_response(struct mt76_dev *mdev, int cmd,
+			       struct sk_buff *skb, int seq)
+{
+	u32 *rxfce = (u32 *)skb->cb;
+
+	if (seq != FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, *rxfce))
+		return -EAGAIN;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_mcu_parse_response);
+
 int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 			 int len, bool wait_resp)
 {
@@ -44,9 +56,6 @@ int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 		goto out;
 
 	while (wait_resp) {
-		u32 *rxfce;
-		bool check_seq = false;
-
 		skb = mt76_mcu_get_response(&dev->mt76, expires);
 		if (!skb) {
 			dev_err(mdev->dev,
@@ -57,13 +66,9 @@ int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 			break;
 		}
 
-		rxfce = (u32 *)skb->cb;
-
-		if (seq == FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, *rxfce))
-			check_seq = true;
-
+		ret = mt76x02_mcu_parse_response(mdev, cmd, skb, seq);
 		dev_kfree_skb(skb);
-		if (check_seq)
+		if (ret != -EAGAIN)
 			break;
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
index 5fba1266c6485..e187ed52968ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
@@ -89,6 +89,8 @@ int mt76x02_mcu_cleanup(struct mt76x02_dev *dev);
 int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type, u32 param);
 int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 			 int len, bool wait_resp);
+int mt76x02_mcu_parse_response(struct mt76_dev *mdev, int cmd,
+			       struct sk_buff *skb, int seq);
 int mt76x02_mcu_function_select(struct mt76x02_dev *dev, enum mcu_function func,
 				u32 val);
 int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index 2dad61fd451fb..c6c16fe8ee859 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -297,6 +297,7 @@ void mt76x02u_init_mcu(struct mt76_dev *dev)
 		.headroom = MT_CMD_HDR_LEN,
 		.tailroom = 8,
 		.mcu_send_msg = mt76x02u_mcu_send_msg,
+		.mcu_parse_response = mt76x02_mcu_parse_response,
 		.mcu_wr_rp = mt76x02u_mcu_wr_rp,
 		.mcu_rd_rp = mt76x02u_mcu_rd_rp,
 	};
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
index ca6f968411ac2..e5b6282d1a6c6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
@@ -179,6 +179,7 @@ int mt76x2_mcu_init(struct mt76x02_dev *dev)
 	static const struct mt76_mcu_ops mt76x2_mcu_ops = {
 		.mcu_restart = mt76pci_mcu_restart,
 		.mcu_send_msg = mt76x02_mcu_msg_send,
+		.mcu_parse_response = mt76x02_mcu_parse_response,
 	};
 	int ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index ea9e288014aa2..e0329358547bc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -306,16 +306,15 @@ mt7915_mcu_parse_eeprom(struct mt7915_dev *dev, struct sk_buff *skb)
 }
 
 static int
-mt7915_mcu_parse_response(struct mt7915_dev *dev, int cmd,
+mt7915_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 			  struct sk_buff *skb, int seq)
 {
+	struct mt7915_dev *dev = container_of(mdev, struct mt7915_dev, mt76);
 	struct mt7915_mcu_rxd *rxd = (struct mt7915_mcu_rxd *)skb->data;
 	int ret = 0;
 
-	if (seq != rxd->seq) {
-		ret = -EAGAIN;
-		goto out;
-	}
+	if (seq != rxd->seq)
+		return -EAGAIN;
 
 	switch (cmd) {
 	case -MCU_CMD_PATCH_SEM_CONTROL:
@@ -332,8 +331,6 @@ mt7915_mcu_parse_response(struct mt7915_dev *dev, int cmd,
 	default:
 		break;
 	}
-out:
-	dev_kfree_skb(skb);
 
 	return ret;
 }
@@ -353,7 +350,8 @@ mt7915_mcu_wait_response(struct mt7915_dev *dev, int cmd, int seq)
 			return -ETIMEDOUT;
 		}
 
-		ret = mt7915_mcu_parse_response(dev, cmd, skb, seq);
+		ret = mt7915_mcu_parse_response(&dev->mt76, cmd, skb, seq);
+		dev_kfree_skb(skb);
 		if (ret != -EAGAIN)
 			break;
 	}
@@ -2859,6 +2857,7 @@ int mt7915_mcu_init(struct mt7915_dev *dev)
 		.headroom = sizeof(struct mt7915_mcu_txd),
 		.mcu_skb_send_msg = mt7915_mcu_send_message,
 		.mcu_send_msg = mt7915_mcu_msg_send,
+		.mcu_parse_response = mt7915_mcu_parse_response,
 		.mcu_restart = mt7915_mcu_restart,
 	};
 	int ret;
-- 
2.53.0



