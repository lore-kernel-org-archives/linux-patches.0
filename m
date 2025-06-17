Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747A1285041;
	Tue, 17 Jun 2025 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177400; cv=none; b=axx/UKr8XSKy05GjOfedcJjPfSlRrU0KxsghdZzOIvGhtbxfpSVj2Fb4hjl6u7+yEJNb7WmVfRnb6YeaP20OLy6F0cjiBIugmH6wGwn9d/usmCyH330DLqM4vcNxqwbrtpot7CU4bZKxWfN7l8pMNbZ594XXje0SDmJea4+J4yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177400; c=relaxed/simple;
	bh=VkOpgOSOMTs5FPZUBAD94mNmHXamHUQwI/tL8mcll6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDgw6VRo6qi5n8/oeE2Mx2upNnz/bCByzOSpq8PjdliCAW1PZwLJqjMJv9r9jB44Y+yrgnV7imE5exw4XoiXLDv+vDCKM2I57c0hWaliAZtrbUMXaZ2T8dJ28T67+MpjOTLxff2re7lU7uWVkPU2zzKnTOeW6CtUtoqdSH4+P4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lg9t/mZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lg9t/mZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85549C4CEE3;
	Tue, 17 Jun 2025 16:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177399;
	bh=VkOpgOSOMTs5FPZUBAD94mNmHXamHUQwI/tL8mcll6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lg9t/mZmtsTet+hvqy5uxi4jvFRBuKk/jycLM/X69KWx9hiztSYNfkO5T7OJ93KF3
	 5KWsdGAfQrC7u7OG6fQOtOXuT63krnYJPl1C8p3lrNXGnAicU/C/H1JGoAtGL42K7c
	 VSOqiMvlSKaNopRoYlI3bumBYDYYLeUNpOtr91F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 300/780] wifi: mt76: mt7925: ensure all MCU commands wait for response
Date: Tue, 17 Jun 2025 17:20:08 +0200
Message-ID: <20250617152503.682223495@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Lo <michael.lo@mediatek.com>

[ Upstream commit aa97ff5782cf01cf2163593e1f57bbde63a06047 ]

Modify MCU command sending functions to wait for a response,
ensuring consistent behavior across all commands and improves
reliability by confirming that each command is processed
successfully.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Michael Lo <michael.lo@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250414013954.1151774-3-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 2bd9fc38a27f4..dea5b9bcb3fdf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -783,7 +783,7 @@ int mt7925_mcu_fw_log_2_host(struct mt792x_dev *dev, u8 ctrl)
 	int ret;
 
 	ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_UNI_CMD(WSYS_CONFIG),
-					&req, sizeof(req), false, NULL);
+					&req, sizeof(req), true, NULL);
 	return ret;
 }
 
@@ -1424,7 +1424,7 @@ int mt7925_mcu_set_eeprom(struct mt792x_dev *dev)
 	};
 
 	return mt76_mcu_send_and_get_msg(&dev->mt76, MCU_UNI_CMD(EFUSE_CTRL),
-					 &req, sizeof(req), false, NULL);
+					 &req, sizeof(req), true, NULL);
 }
 EXPORT_SYMBOL_GPL(mt7925_mcu_set_eeprom);
 
@@ -2762,7 +2762,7 @@ int mt7925_mcu_set_dbdc(struct mt76_phy *phy, bool enable)
 	conf->band = 0; /* unused */
 
 	err = mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SET_DBDC_PARMS),
-				    false);
+				    true);
 
 	return err;
 }
@@ -2870,7 +2870,7 @@ int mt7925_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	}
 
 	err = mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SCAN_REQ),
-				    false);
+				    true);
 	if (err < 0)
 		clear_bit(MT76_HW_SCANNING, &phy->state);
 
@@ -2976,7 +2976,7 @@ int mt7925_mcu_sched_scan_req(struct mt76_phy *phy,
 	}
 
 	return mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SCAN_REQ),
-				     false);
+				     true);
 }
 EXPORT_SYMBOL_GPL(mt7925_mcu_sched_scan_req);
 
@@ -3012,7 +3012,7 @@ mt7925_mcu_sched_scan_enable(struct mt76_phy *phy,
 		clear_bit(MT76_HW_SCHED_SCANNING, &phy->state);
 
 	return mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SCAN_REQ),
-				     false);
+				     true);
 }
 
 int mt7925_mcu_cancel_hw_scan(struct mt76_phy *phy,
@@ -3051,7 +3051,7 @@ int mt7925_mcu_cancel_hw_scan(struct mt76_phy *phy,
 	}
 
 	return mt76_mcu_send_msg(phy->dev, MCU_UNI_CMD(SCAN_REQ),
-				 &req, sizeof(req), false);
+				 &req, sizeof(req), true);
 }
 EXPORT_SYMBOL_GPL(mt7925_mcu_cancel_hw_scan);
 
@@ -3156,7 +3156,7 @@ int mt7925_mcu_set_channel_domain(struct mt76_phy *phy)
 	memcpy(__skb_push(skb, sizeof(req)), &req, sizeof(req));
 
 	return mt76_mcu_skb_send_msg(dev, skb, MCU_UNI_CMD(SET_DOMAIN_INFO),
-				     false);
+				     true);
 }
 EXPORT_SYMBOL_GPL(mt7925_mcu_set_channel_domain);
 
-- 
2.39.5



