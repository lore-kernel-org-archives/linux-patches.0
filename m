Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E47A3A641D;
	Sat, 17 Oct 2026 15:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252538; cv=none; b=DZGHUHXXvDaDh4oa/ClXkrL+q4XTavnNe0BQQwR74dDd1j3G3RxS24WJs2a+aYWQsoQV0AogpzWQiucQ4O4sOZD/ftw88HjWYyHdnF/p4einc3bB3DHBh06T/mEmdhPLUX8TgHzD/1BijOSihFbtG/Hdpg4/hspeTHfLM3PMd4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252538; c=relaxed/simple;
	bh=kNCwSQaOfINXa3fAqeohnfi5ER21E/vEaQi4Fu+LDlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlQeLZLX5defq71W9IrTXQtB2LpKUJwzDWhVYJqSRAowfzrAWkT+n/BFcY+r2ou+cuvYqvelYSgVVand9G1RSidVlCRAUHRQPujJVFxDrpUchnh4u6JlrbPD45kRJhAcWSaQtbm6gW94DAr6yCmH674NHkYSR/5zrQKKNmlp//4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVBM+gn3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVBM+gn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FD31F000C5;
	Sat, 17 Oct 2026 15:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252535;
	bh=uIJ2UyirBPVR5mKId8bZe8XGsGRKOZ3SHK5+BRnvUKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVBM+gn3H6qS0EmLeOqkC4V1TLzpCUdSMJVwjyAvs/StIxlFiDMnFO5AA2GziXAP9
	 RVRrT1V+VGcDABfqSljX/RZk95l8tGcLiL+NmVl8/CeaYdsdxPbTfxyopCzr1g5AC3
	 qQGqNGAeIhtVdMRr+yzvOs/Qdf9pi4fEoH0NjVXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 13/52] wifi: mt76: connac: tolerate inactive BSS deactivation
Date: Sat, 17 Oct 2026 17:54:14 +0200
Message-ID: <20261017155105.288136612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 04222f980301561edd77917edac570b1393ec45d ]

Firmware may return wlan_failure when deactivating a BSS that is already
inactive. This is a valid teardown case and should not fail the remove
path.

Keep activation failures unchanged since they still indicate that firmware
failed to create or activate the BSS state.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20260425195011.790265-13-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  |  9 +++++++-
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  | 23 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |  6 +++--
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 46e337307c3d8..569b94b48926e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1226,6 +1226,9 @@ int mt76_connac_mcu_uni_add_dev(struct mt76_phy *phy,
 	len = enable ? sizeof(dev_req) : sizeof(basic_req);
 
 	err = mt76_mcu_send_msg(dev, cmd, data, len, true);
+	if (err && cmd == MCU_UNI_CMD(BSS_INFO_UPDATE))
+		err = mt76_connac_mcu_bss_deact_err(dev, err, enable);
+
 	if (err < 0)
 		return err;
 
@@ -1233,7 +1236,11 @@ int mt76_connac_mcu_uni_add_dev(struct mt76_phy *phy,
 	data = enable ? (void *)&basic_req : (void *)&dev_req;
 	len = enable ? sizeof(basic_req) : sizeof(dev_req);
 
-	return mt76_mcu_send_msg(dev, cmd, data, len, true);
+	err = mt76_mcu_send_msg(dev, cmd, data, len, true);
+	if (err && cmd == MCU_UNI_CMD(BSS_INFO_UPDATE))
+		err = mt76_connac_mcu_bss_deact_err(dev, err, enable);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(mt76_connac_mcu_uni_add_dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 5ed2fffbe1074..a24979698a8d1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1894,6 +1894,29 @@ mt76_connac_mcu_get_wlan_idx(struct mt76_dev *dev, struct mt76_wcid *wcid,
 	}
 }
 
+#define MT76_CONNAC_MCU_STATUS_WLAN_FAILURE	0xc0000001
+
+static inline int
+mt76_connac_mcu_bss_deact_err(struct mt76_dev *mdev, int err, bool enable)
+{
+	if (err != (int)MT76_CONNAC_MCU_STATUS_WLAN_FAILURE)
+		return err;
+
+	/* Ignore wlan_failure state false alarm when deactivating an
+	 * inactive network. It does not harm the firmware state.
+	 */
+	if (!enable) {
+		dev_dbg(mdev->dev,
+			"ignore wlan_failure when bss is deactivated\n");
+		return 0;
+	}
+
+	dev_warn(mdev->dev,
+		 "wlan_failure when bss is activated\n");
+
+	return err;
+}
+
 struct sk_buff *
 __mt76_connac_mcu_alloc_sta_req(struct mt76_dev *dev, struct mt76_vif_link *mvif,
 				struct mt76_wcid *wcid, int len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 8b1e1d2ed2546..75f105d224ed5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2848,6 +2848,7 @@ int mt7925_mcu_add_bss_info(struct mt792x_phy *phy,
 	struct mt792x_dev *dev = phy->dev;
 	struct mt792x_link_sta *mlink_bc;
 	struct sk_buff *skb;
+	int err;
 
 	skb = __mt7925_mcu_alloc_bss_req(&dev->mt76, &mconf->mt76,
 					 MT7925_BSS_UPDATE_MAX_SIZE);
@@ -2875,8 +2876,9 @@ int mt7925_mcu_add_bss_info(struct mt792x_phy *phy,
 		mt7925_mcu_bss_mbssid_tlv(skb, link_conf, enable);
 	}
 
-	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
-				     MCU_UNI_CMD(BSS_INFO_UPDATE), true);
+	err = mt76_mcu_skb_send_msg(&dev->mt76, skb,
+				    MCU_UNI_CMD(BSS_INFO_UPDATE), true);
+	return mt76_connac_mcu_bss_deact_err(&dev->mt76, err, enable);
 }
 
 int mt7925_mcu_set_dbdc(struct mt76_phy *phy, bool enable)
-- 
2.53.0



