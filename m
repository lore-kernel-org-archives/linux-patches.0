Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB248522A;
	Wed,  5 Feb 2025 14:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765658; cv=none; b=Y5WgPJVtc6Q3yjmIS8x7p1dYzj8JJUnFSQfrI8C0ZPvmBo6v4tMsGtoToHzHUk5OGXEna7khGzGMNq6tav8DDJL4dXceVUqBmyFkyuC+m5b7KPqrA2hk4jsZ3j2fl0qNhbaNUJa8dkf+4ClU+Y0rpvA9hsQOyxq71i+2J352xx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765658; c=relaxed/simple;
	bh=2jCzVO7bMhII8/xEoambgwKtCPu1oAVuuNpoK8/i/LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuCrrSMv7aQ+Y46u8r9QVHdL27UmQQLP4nPD9EhHFbW8olRmNR17PyhHU/gop9LhmSSiot1X4/Ll7Gw+LX3esTYF9AE/+aVlrLt2PsvT3DwxOctFAQK/HSdOxxuLM/EdC/XBVRNvPGDFltbly1eNacsa8WyA8a9KsJy338p9wz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7RORkcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7RORkcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3751FC4CED1;
	Wed,  5 Feb 2025 14:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765658;
	bh=2jCzVO7bMhII8/xEoambgwKtCPu1oAVuuNpoK8/i/LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7RORkccyRXwt+gH9fmP78EO+H6HJNcbVvrY5F7oWb5su75nSEJXpRsWBAOJNXTNI
	 N96dbZovEfj93urletZo7fvNGadnHJWszQT4LQtRyoX0C9xDSCiZwBdQaSAGH8Q56H
	 /VldLQVvm5FOgqmDiiIreV/TNY4SmqGxwvxx43Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 202/623] wifi: mt76: mt7925: Properly handle responses for commands with events
Date: Wed,  5 Feb 2025 14:39:04 +0100
Message-ID: <20250205134503.958517758@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 349460913a4d029cc37c9e3817b1903233b4a627 ]

Properly retrieve the response for commands with events. Ensure accurate
handling of event-driven commands.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-17-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c |  1 -
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c  | 10 +++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 116b6980c7335..ddc67423efe2c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1244,7 +1244,6 @@ void mt7925_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		memcpy(dev_req.tlv.omac_addr, vif->addr, ETH_ALEN);
 		mt76_mcu_send_msg(mdev, MCU_UNI_CMD(DEV_INFO_UPDATE),
 				  &dev_req, sizeof(dev_req), true);
-
 	}
 
 	if (vif->type == NL80211_IFTYPE_STATION) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index c7dd263446c9e..ce3d8197b026a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1252,7 +1252,7 @@ int mt7925_mcu_set_mlo_roc(struct mt792x_bss_conf *mconf, u16 sel_links,
 	}
 
 	return mt76_mcu_send_msg(&mvif->phy->dev->mt76, MCU_UNI_CMD(ROC),
-				 &req, sizeof(req), false);
+				 &req, sizeof(req), true);
 }
 
 int mt7925_mcu_set_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
@@ -1301,7 +1301,7 @@ int mt7925_mcu_set_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
 	}
 
 	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(ROC),
-				 &req, sizeof(req), false);
+				 &req, sizeof(req), true);
 }
 
 int mt7925_mcu_abort_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
@@ -1331,7 +1331,7 @@ int mt7925_mcu_abort_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
 	};
 
 	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(ROC),
-				 &req, sizeof(req), false);
+				 &req, sizeof(req), true);
 }
 
 int mt7925_mcu_set_eeprom(struct mt792x_dev *dev)
@@ -1484,12 +1484,12 @@ mt7925_mcu_set_bss_pm(struct mt792x_dev *dev,
 	int err;
 
 	err = mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(BSS_INFO_UPDATE),
-				&req1, sizeof(req1), false);
+				&req1, sizeof(req1), true);
 	if (err < 0 || !enable)
 		return err;
 
 	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(BSS_INFO_UPDATE),
-				 &req, sizeof(req), false);
+				 &req, sizeof(req), true);
 }
 
 static void
-- 
2.39.5



