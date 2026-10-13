Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EF34F402E;
	Tue, 13 Oct 2026 11:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892617; cv=none; b=pBdH5Y3heiWhLoLNosFi1BFRnczLfHNqSM0KBbDEtyLGvqRC6seFfhLUreozukN/AAJRdwFbLYzd2sRAwha5NL4Ws8lx9aMlvysnyHcXwkcVoES7/O5FNBZl8I3sR/m1DYok74oy+EomHuYM8RUNyemX4vykiHXpHkywhir/OJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892617; c=relaxed/simple;
	bh=dlOrgO24NgNXKO1eADWucv2Cy7g+WtVnJQ0tFT8Af40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qf41uuCpEAGdYck2P6bW1PzaCz+2boJYmFD0VkWCgnG7rbjsMhQSjCeUXOCuDZ3Wh2tzhL91ezMqHdg0nipVg3iRRMqw7ZIiztd0XUlebO5s0Sehd5ndWze2V2GQh7MfuL/dE6oJKl9GFRlBefsbXcjWZd+D5r5CvDas8Rti/5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzIzTSTp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzIzTSTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16A51F000FF;
	Tue, 13 Oct 2026 11:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892615;
	bh=B9rwEWFEaFl3af7D8ZZELLCCpEKCAPsuVMNJEDE0t/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzIzTSTp635wp8KELrfjiPe2Y20sFbaeMfBqfK2isZH2AoIjzgF9RkKISXBHzO5Z3
	 NXbN9gWPTkxvnY69btKsGmKXVktS6OxZ8RdGFXf/sa0YuYvukJJteE8HAFFsQwkuBR
	 ZTVR2v98Nh/03PvEgvWNh+g1LUoo8oN/N0JAciMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 233/281] wifi: mt76: use ALTX queue for packets to disassociated stations
Date: Tue, 13 Oct 2026 13:39:09 +0200
Message-ID: <20261013112900.804405321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 7c2e6b43c3082c2242ecfa5875b2b4b2cd06140f ]

Running these packets through regular buffering queues could cause them
to hang, especially when the packets were for stations that in disassoc
state.

Fixes: dedf2ec30fe4 ("wifi: mt76: fix queue assignment for deauth packets")
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260901092232.461379-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 1 +
 drivers/net/wireless/mediatek/mt76/tx.c          | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 4783e5f52d229..1830398ff719f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -805,6 +805,7 @@ __mt7915_drop_sta(void *ptr, u8 *mac, struct ieee80211_vif *vif)
 
 	msta = (struct mt7915_sta *)sta->drv_priv;
 	mt7915_mcu_add_sta(data->dev, vif, sta, CONN_STATE_DISCONNECT, false);
+	msta->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
 	msta->wcid.sta_disabled = 1;
 	msta->wcid.sta = 0;
 }
@@ -871,6 +872,7 @@ int mt7915_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		mutex_unlock(&dev->mt76.mutex);
 
 		mt7915_mcu_add_sta(dev, vif, sta, CONN_STATE_DISCONNECT, false);
+		msta->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
 		msta->wcid.sta_disabled = 1;
 		msta->wcid.sta = 0;
 		return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 484fe880232b4..ae006f29091ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1429,6 +1429,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			else if (sta->mlo && links == BIT(link_id)) /* last link */
 				mt7996_mcu_teardown_mld_sta(dev, link,
 							    msta_link);
+			msta_link->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
 			msta_link->wcid.sta_disabled = 1;
 			msta_link->wcid.sta = 0;
 			links = links & ~BIT(link_id);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index c6245b10abb0c..65703dbb185c9 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -672,7 +672,8 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 		if ((dev->drv->drv_flags & MT_DRV_HW_MGMT_TXQ) &&
 		    !(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) &&
 		    !ieee80211_is_data_present(hdr->frame_control) &&
-		    (!ieee80211_is_bufferable_mmpdu(skb) ||
+		    (!(wcid->tx_info & MT_WCID_TX_INFO_SET) ||
+		     !ieee80211_is_bufferable_mmpdu(skb) ||
 		     ieee80211_is_deauth(hdr->frame_control) ||
 		     ieee80211_is_disassoc(hdr->frame_control) ||
 		     head == &wcid->tx_offchannel))
-- 
2.53.0



