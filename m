Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC9D168DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834D1C433EF;
	Mon,  8 May 2023 11:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545502;
	bh=r0wL48zvDtf5QIzw55uR0etoZpaTculg5cMMvEgp1gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gey8SvPaFB3QrNSJXqYnVAla5KCCa3ysGPfu5oE7vzpXnrJ0pKMEZC5DVMUQUPbyr
	 KEsgU6uysGnsv0FVD45Cj8Gy/YM6aeVZkRNYkC27p0izAQUlx7G5NKJ81Rkv7bz5sa
	 TxJCEnvkKfNDpt25Wpd/V02t5O9OIhHNeHEvkyLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Coverstone <brian@mainsequence.net>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.15 033/371] wifi: mt76: add missing locking to protect against concurrent rx/status calls
Date: Mon,  8 May 2023 11:43:54 +0200
Message-Id: <20230508094813.423507528@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

commit 5b8ccdfb943f6a03c676d2ea816dd38c149e920b upstream.

According to the documentation, ieee80211_rx_list must not run concurrently
with ieee80211_tx_status (or its variants).

Cc: stable@vger.kernel.org
Fixes: 88046b2c9f6d ("mt76: add support for reporting tx status with skb")
Reported-by: Brian Coverstone <brian@mainsequence.net>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c         |    2 ++
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c  |    5 ++++-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c  |    5 ++++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c |    5 ++++-
 drivers/net/wireless/mediatek/mt76/tx.c          |    4 ++++
 5 files changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -434,7 +434,9 @@ free:
 free_skb:
 	status.skb = tx_info.skb;
 	hw = mt76_tx_status_get_hw(dev, tx_info.skb);
+	spin_lock_bh(&dev->rx_lock);
 	ieee80211_tx_status_ext(hw, &status);
+	spin_unlock_bh(&dev->rx_lock);
 
 	return ret;
 }
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1284,8 +1284,11 @@ void mt7603_mac_add_txs(struct mt7603_de
 	if (wcidx >= MT7603_WTBL_STA || !sta)
 		goto out;
 
-	if (mt7603_fill_txs(dev, msta, &info, txs_data))
+	if (mt7603_fill_txs(dev, msta, &info, txs_data)) {
+		spin_lock_bh(&dev->mt76.rx_lock);
 		ieee80211_tx_status_noskb(mt76_hw(dev), sta, &info);
+		spin_unlock_bh(&dev->mt76.rx_lock);
+	}
 
 out:
 	rcu_read_unlock();
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1496,8 +1496,11 @@ static void mt7615_mac_add_txs(struct mt
 	if (wcid->ext_phy && dev->mt76.phy2)
 		mphy = dev->mt76.phy2;
 
-	if (mt7615_fill_txs(dev, msta, &info, txs_data))
+	if (mt7615_fill_txs(dev, msta, &info, txs_data)) {
+		spin_lock_bh(&dev->mt76.rx_lock);
 		ieee80211_tx_status_noskb(mphy->hw, sta, &info);
+		spin_unlock_bh(&dev->mt76.rx_lock);
+	}
 
 out:
 	rcu_read_unlock();
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -631,8 +631,11 @@ void mt76x02_send_tx_status(struct mt76x
 
 	mt76_tx_status_unlock(mdev, &list);
 
-	if (!status.skb)
+	if (!status.skb) {
+		spin_lock_bh(&dev->mt76.rx_lock);
 		ieee80211_tx_status_ext(mt76_hw(dev), &status);
+		spin_unlock_bh(&dev->mt76.rx_lock);
+	}
 
 	if (!len)
 		goto out;
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -68,7 +68,9 @@ mt76_tx_status_unlock(struct mt76_dev *d
 			status.sta = wcid_to_sta(wcid);
 
 		hw = mt76_tx_status_get_hw(dev, skb);
+		spin_lock_bh(&dev->rx_lock);
 		ieee80211_tx_status_ext(hw, &status);
+		spin_unlock_bh(&dev->rx_lock);
 	}
 	rcu_read_unlock();
 }
@@ -229,7 +231,9 @@ void __mt76_tx_complete_skb(struct mt76_
 	if (!skb->prev) {
 		hw = mt76_tx_status_get_hw(dev, skb);
 		status.sta = wcid_to_sta(wcid);
+		spin_lock_bh(&dev->rx_lock);
 		ieee80211_tx_status_ext(hw, &status);
+		spin_unlock_bh(&dev->rx_lock);
 		goto out;
 	}
 


