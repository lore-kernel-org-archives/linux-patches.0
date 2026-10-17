Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5C33D994;
	Sat, 17 Oct 2026 16:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253152; cv=none; b=MiRGRxT5F+3O0wgH6T9/9aA3BaXuOwOsDZThg4mj+6r0ogLeRDlWU0BWOddoTvjRXvjD7hPSWzdfH5uhwCbzlJDXErrFSJgzVDoFmfQ7s7/uFXUONA/aUR5cNcdvRNBVzeVq6toHg8ZPeXkAZy1k0V/YuAXdoVZsnYXohknqymg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253152; c=relaxed/simple;
	bh=YQfKBc6QA8P0d5H21lU49exbFoL7clU9oF9V+NyUL9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDEkDvRShv9zQswYRJUOtKo7c8e3RU49Wy5iw0uKHilg05s8u90xatrhRCEBEYBYHlpuTI8XwYN75LVBqMWFhUBaCfJmfPsfcKA7ZqnaKbmHPnLcJ+PpeoFPLbYrWhMlTX0kV8xWf79DKz1gHPK1nsSiK5h6cv5tGIuFGeFqMaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2VwXKKD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2VwXKKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594261F000C5;
	Sat, 17 Oct 2026 16:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253150;
	bh=hi6xJvZva7w3naJqIcZLwj6w+oWSNl66DeR79ocSRyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2VwXKKDyUgAT9FdXiqlwUKUIfp3cPneqf2YgI86oEoOlK06LMSWmu//2nWBWP11H
	 4ZeAEuxgnyWTa9Q/x+BWCvUIEqBopCCsZowOpivMmCbveRaNJDVOaGAOD0SxZEah+t
	 Og3OKGBa5Nj6wQU703AC+GpiO1ve70kqZxwzs89A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/869] wifi: mt76: connac: tolerate inactive BSS deactivation
Date: Sat, 17 Oct 2026 17:47:40 +0200
Message-ID: <20261017160037.501443006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f60fe27ab3f9d..800d1073df27d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1220,6 +1220,9 @@ int mt76_connac_mcu_uni_add_dev(struct mt76_phy *phy,
 	len = enable ? sizeof(dev_req) : sizeof(basic_req);
 
 	err = mt76_mcu_send_msg(dev, cmd, data, len, true);
+	if (err && cmd == MCU_UNI_CMD(BSS_INFO_UPDATE))
+		err = mt76_connac_mcu_bss_deact_err(dev, err, enable);
+
 	if (err < 0)
 		return err;
 
@@ -1227,7 +1230,11 @@ int mt76_connac_mcu_uni_add_dev(struct mt76_phy *phy,
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
index 6901971f5da6b..051523090ea7c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1876,6 +1876,29 @@ mt76_connac_mcu_get_wlan_idx(struct mt76_dev *dev, struct mt76_wcid *wcid,
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
 __mt76_connac_mcu_alloc_sta_req(struct mt76_dev *dev, struct mt76_vif *mvif,
 				struct mt76_wcid *wcid, int len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 789acc53d8a8b..d6437a0fff6a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2788,6 +2788,7 @@ int mt7925_mcu_add_bss_info(struct mt792x_phy *phy,
 	struct mt792x_dev *dev = phy->dev;
 	struct mt792x_link_sta *mlink_bc;
 	struct sk_buff *skb;
+	int err;
 
 	skb = __mt7925_mcu_alloc_bss_req(&dev->mt76, &mconf->mt76,
 					 MT7925_BSS_UPDATE_MAX_SIZE);
@@ -2813,8 +2814,9 @@ int mt7925_mcu_add_bss_info(struct mt792x_phy *phy,
 	if (enable)
 		mt7925_mcu_bss_rlm_tlv(skb, phy->mt76, link_conf, ctx);
 
-	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
-				     MCU_UNI_CMD(BSS_INFO_UPDATE), true);
+	err = mt76_mcu_skb_send_msg(&dev->mt76, skb,
+				    MCU_UNI_CMD(BSS_INFO_UPDATE), true);
+	return mt76_connac_mcu_bss_deact_err(&dev->mt76, err, enable);
 }
 
 int mt7925_mcu_set_dbdc(struct mt76_phy *phy, bool enable)
-- 
2.53.0



