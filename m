Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729E14EF154;
	Tue, 13 Oct 2026 12:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894458; cv=none; b=NbMKnbowLccsB6afTTh6x1kYnD4doU/tfoZAUND+aknJYcP7lAQbBGIEuDW9wVy+NjptopgFUAkcvb2F+XOxjONkQKZDrbe+TFDDMpDqJvLyQSqhMEWUWOl70xO0nMBqufckMhQnntuw5QTsDoQLhbvyCa6vEUkO/KXJ+meRuTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894458; c=relaxed/simple;
	bh=QU+9Xbq1n9BzKD/6UHuUAquXl2Ya2Re3FjcJ6XKNCAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RK29O0YxK8zxo79EJB6jxOiuQPcSHxwWNgXcPDpc+AIyB/pe4M1wSO+dC8vJmU2w1EIwSb/QPS/C4W/HlMbDjYAEm+FLA+kqBHqa4jKPAQujBSpz8GeZci+XI4Z6+dvENiXeeHraMGfbu6GeAhTqQmIvAQ0V0kRuG0QLrZm1nTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bgu8PTnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bgu8PTnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9891F000FF;
	Tue, 13 Oct 2026 12:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894457;
	bh=XI8rrM2bsk1eBp6+eXqfqgBHQoDnfAKgkfe+0Mp3K48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bgu8PTnfTyMEsX3QkNYiNpZjW/BX5IpFz0WP0v7XctYW1rm8H3mhHEyN+2PHjgbcw
	 rq11kGCpvAx6MH4JNCzfh+BPCCgbasVEY8zPhZmisPlF5jRqY0Lc5Yytt/5yToHZKj
	 AAR3wRo3TIyzQhFCNh+NlzkUiL/ciPXbryEvH3x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 566/621] wifi: mt76: use ALTX queue for packets to disassociated stations
Date: Tue, 13 Oct 2026 13:39:21 +0200
Message-ID: <20261013112934.238810559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 9d546eb8022ac..ff14085dc331e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -802,6 +802,7 @@ __mt7915_drop_sta(void *ptr, u8 *mac, struct ieee80211_vif *vif)
 
 	msta = (struct mt7915_sta *)sta->drv_priv;
 	mt7915_mcu_add_sta(data->dev, vif, sta, CONN_STATE_DISCONNECT, false);
+	msta->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
 	msta->wcid.sta_disabled = 1;
 	msta->wcid.sta = 0;
 }
@@ -866,6 +867,7 @@ int mt7915_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 			mt7915_mac_twt_teardown_flow(dev, msta, i);
 
 		mt7915_mcu_add_sta(dev, vif, sta, CONN_STATE_DISCONNECT, false);
+		msta->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
 		msta->wcid.sta_disabled = 1;
 		msta->wcid.sta = 0;
 		return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index c6d7088b15cab..7812f03b3d385 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1274,6 +1274,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			else if (sta->mlo && links == BIT(link_id)) /* last link */
 				mt7996_mcu_teardown_mld_sta(dev, link,
 							    msta_link);
+			msta_link->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
 			msta_link->wcid.sta_disabled = 1;
 			msta_link->wcid.sta = 0;
 			links = links & ~BIT(link_id);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 8af03dfd9e764..731caeda72b52 100644
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



