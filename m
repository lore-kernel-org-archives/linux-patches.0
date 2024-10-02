Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03BB18DF60;
	Wed,  2 Oct 2024 13:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876983; cv=none; b=sgUnikrprpnO/DGt0b3gZkLCvDSHohfabxzKvvxf3T2ZvHdgDBBAaN00Fd66cd6XNqwl9a32fGIb9r/Vk+Q/OBR5hKTmIvKEMpxCzvbtV2Vlw9SEIN3A9XUTtUf7jovOPwyG73RngWjpkD+cTSRcAavFCgeRJe/0jNrtW4caoAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876983; c=relaxed/simple;
	bh=K/nDvZmruRQ5DMsMHozCBXmsuZWGMsAKyyN78SqpRmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwdG8zvQNmQqkmKKFJvWxcm/WkXplc6nf9rqiqHATIThtcvQgDBeNisDMpmsGIGYbdxXF5UrR5WurWwhesD9GmveDg2et2DwA+RVlonlBuXo9MN0mBhZCD6+TIVQIujNLrCwqLDhgEfD5r0PXXWNVeVEHZjjptcpqiTYjmgR+jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtHuJ2St; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtHuJ2St"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0516C4CEC2;
	Wed,  2 Oct 2024 13:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876983;
	bh=K/nDvZmruRQ5DMsMHozCBXmsuZWGMsAKyyN78SqpRmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtHuJ2Stf6FFWalkDlQpmxTDc0tq/GjXUfTEdK1GCUisrP9by28H+qWWOS2lS13WP
	 Wh/k1Tg2rj9p1pYSl2SHKPm7uplW6TpSpmJtccN8wla6UBkh7AN901aWSVZIcZXz9H
	 yjU8xXVUHH74D0LgLHPg1hAXngpnRZXjb8k+QiPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.11 623/695] wifi: mt76: mt7925: fix a potential association failure upon resuming
Date: Wed,  2 Oct 2024 15:00:21 +0200
Message-ID: <20241002125847.380313935@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Lo <michael.lo@mediatek.com>

commit 45064d19fd3af6aeb0887b35b5564927980cf150 upstream.

In multi-channel scenarios, the granted channel must be aborted before
suspending. Otherwise, the firmware will be put into a wrong state,
resulting in an association failure after resuming.

With this patch, the granted channel will be aborted before suspending
if necessary.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Michael Lo <michael.lo@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20240902090054.15806-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   15 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |    1 +
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c    |    2 ++
 3 files changed, 18 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -439,6 +439,19 @@ static void mt7925_roc_iter(void *priv,
 	mt7925_mcu_abort_roc(phy, &mvif->bss_conf, phy->roc_token_id);
 }
 
+void mt7925_roc_abort_sync(struct mt792x_dev *dev)
+{
+	struct mt792x_phy *phy = &dev->phy;
+
+	del_timer_sync(&phy->roc_timer);
+	cancel_work_sync(&phy->roc_work);
+	if (test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state))
+		ieee80211_iterate_interfaces(mt76_hw(dev),
+					     IEEE80211_IFACE_ITER_RESUME_ALL,
+					     mt7925_roc_iter, (void *)phy);
+}
+EXPORT_SYMBOL_GPL(mt7925_roc_abort_sync);
+
 void mt7925_roc_work(struct work_struct *work)
 {
 	struct mt792x_phy *phy;
@@ -1109,6 +1122,8 @@ static void mt7925_mac_link_sta_remove(s
 	msta = (struct mt792x_sta *)link_sta->sta->drv_priv;
 	mlink = mt792x_sta_to_link(msta, link_id);
 
+	mt7925_roc_abort_sync(dev);
+
 	mt76_connac_free_pending_tx_skbs(&dev->pm, &mlink->wcid);
 	mt76_connac_pm_wake(&dev->mphy, &dev->pm);
 
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -307,6 +307,7 @@ int mt7925_mcu_set_roc(struct mt792x_phy
 		       enum mt7925_roc_req type, u8 token_id);
 int mt7925_mcu_abort_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
 			 u8 token_id);
+void mt7925_roc_abort_sync(struct mt792x_dev *dev);
 int mt7925_mcu_fill_message(struct mt76_dev *mdev, struct sk_buff *skb,
 			    int cmd, int *wait_seq);
 int mt7925_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -449,6 +449,8 @@ static int mt7925_pci_suspend(struct dev
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
 
+	mt7925_roc_abort_sync(dev);
+
 	err = mt792x_mcu_drv_pmctrl(dev);
 	if (err < 0)
 		goto restore_suspend;


