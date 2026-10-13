Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9D71F91F6;
	Tue, 13 Oct 2026 12:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894441; cv=none; b=b5LAR+j0+DwlJ8pkSNDfyrNRHdqq7pQNEZdKC7tHnCQdgTOiYBh6TY+uefbhky1PWI9PDYM23b2xoHsvE4dyyoxDzashzzxCr+CT3juxZd0FGu3tyJsZ0wqNLVRyBAEDSa2UuYNI3+QhCi1JyvyJ79l6R61s85JxjEn7WpxCgQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894441; c=relaxed/simple;
	bh=U/HVByCd6XgJigr/2E9UJJp0KsZdfj4z74H5CDSXD7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=db/jMuiNiGUuYWapKpXEivhocslBkrLbkl+TjtwnfRIWMcK5xE4sPT3HDzJDuGDOL6ZKs8sVQHHwhNtWOsYhIo69JrOAcqPAThDYIezizZOmxkf4r1QZXpz3oS8wUodRwmTrlP5rWCeWy/REgBK+wV0NEWhW/xoncse4YeaBfo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nin5wdnO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nin5wdnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3508A1F000FF;
	Tue, 13 Oct 2026 12:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894439;
	bh=p2etOMLSsmbEFRf/ZAL0cx4bgaWR0lbdda4SdD0Njio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nin5wdnOl0WthRfndXO75YwuTrwKzz8uO11LQPl+LET3UPF3bmpwYVy7IasFjfPNx
	 Ow1KgeSYVen7RYBNUNgZam16AirWW3TMs3mvj8ykALzj528Izxlgfa9O0hwVIVTdhI
	 q4jV266Te9JqCDPXXKQ69zo+DLhPcvDFadKsQA7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 560/621] wifi: mt76: dont return TXQ when exceeding max non-AQL packets
Date: Tue, 13 Oct 2026 13:39:15 +0200
Message-ID: <20261013112934.098970126@linuxfoundation.org>
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

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 964f870e090e9c88a41e2890333421204cc0bdf4 ]

mt76_txq_send_burst does check if the number of non-AQL frames exceeds
the maximum. In this case the queue is returned to ieee80211_return_txq
when iterating over the scheduled TXQs in mt76_txq_schedule_list.

This has the effect of inserting said TXQ at the head of the list. This
means the loop will get the same TXQ again, which will terminate the
scheduling round. TXQs following in the list thus never get scheduled
for transmission.

This can manifest in high latency low throughput or broken connections
for said STAs.

Check if the non-AQL packet count exceeds the limit and not return the
TXQ in this case.
Schedule all TXQs for the STA in case the non-AQL limit can be satisfied
again.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://patch.msgid.link/20260129232321.276575-1-mail@david-bauer.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 752770d7a58c ("wifi: mt76: account non-AQL frames per peer rather than per link")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 28630d75bdb21..5278289a17580 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -227,7 +227,9 @@ mt76_tx_check_non_aql(struct mt76_dev *dev, struct mt76_wcid *wcid,
 		      struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sta *sta;
 	int pending;
+	int i;
 
 	if (!wcid || info->tx_time_est)
 		return;
@@ -235,6 +237,17 @@ mt76_tx_check_non_aql(struct mt76_dev *dev, struct mt76_wcid *wcid,
 	pending = atomic_dec_return(&wcid->non_aql_packets);
 	if (pending < 0)
 		atomic_cmpxchg(&wcid->non_aql_packets, pending, 0);
+
+	sta = wcid_to_sta(wcid);
+	if (!sta || pending != MT_MAX_NON_AQL_PKT - 1)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
+		if (!sta->txq[i])
+			continue;
+
+		ieee80211_schedule_txq(dev->hw, sta->txq[i]);
+	}
 }
 
 void __mt76_tx_complete_skb(struct mt76_dev *dev, u16 wcid_idx, struct sk_buff *skb,
@@ -538,6 +551,9 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 		if (!wcid || test_bit(MT_WCID_FLAG_PS, &wcid->flags))
 			continue;
 
+		if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
+			continue;
+
 		phy = mt76_dev_phy(dev, wcid->phy_idx);
 		if (test_bit(MT76_RESET, &phy->state) || phy->offchannel)
 			continue;
-- 
2.53.0



