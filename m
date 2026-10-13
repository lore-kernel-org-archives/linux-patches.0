Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363EC4F052F;
	Tue, 13 Oct 2026 11:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892613; cv=none; b=jgziyyJXoOnZS0LgQhgqGQGToMB2jmWYy0he1oAPNoW7ZgCSU/CdwK/xj2GeB23X52kwJ23SO2gE0ga7hmmH+BTMuWchnNE1zOd2Wbj7aDksrvgElllazf9HHvFno/cYIyja8IqTARDrfCq7Y12wjLhYoaG5EtEK7A520doHaCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892613; c=relaxed/simple;
	bh=TcZwcS8CZ/D0Zty1u1a4+480vsm3DrowPbJ3V10605Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNB+RZNEFQNie7U0asZnnsWsIKrrIW94aAoo0eO+DuYZ5Gjn/FCk9+7OVte9/iq8dG+hcC4N6OnufrU9hk7w5+7bBRcuokp/XvIYsI6Zmjnu5f0Gq1VY8QLewwbNzaJV6EeiZk541PBeWh9JHSJjMIScRW73SijBFuPCtyPrvBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNB4Y30i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNB4Y30i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6D71F00893;
	Tue, 13 Oct 2026 11:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892612;
	bh=iorMrP6HQYofKGazz17vmqjftsIVXJhOQlB2F8PFXcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNB4Y30iVe/p/FkEE87P8QvLyDYos0AtjLKRkstpJr/8Pyn+RMFaNOYQTQOotw8K+
	 ubSOJHcrEu9MBM7bNMsb3lvPFmFyk5bWLBHPDohs/hvOWuK8KU3a3nrLIoCjkX4ZFy
	 h+htKGa+U5qxynQB/4aEMwB0LKFZsIo98Wx5L2vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 232/281] wifi: mt76: account non-AQL frames per peer rather than per link
Date: Tue, 13 Oct 2026 13:39:08 +0200
Message-ID: <20261013112900.781636297@linuxfoundation.org>
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

[ Upstream commit 752770d7a58c821c17909c3ca67f9f14ab146a40 ]

The driver increments wcid->non_aql_packets when a frame goes to the
hardware queue. The completion path decrements the counter again.

For an MLO peer, the hardware reports the completion on the link that it
used for the transmission. This link can differ from the link that the
driver queued the frame on. In that case, the increment and the
decrement go to different link wcids, and the count drifts upwards until
it blocks the station.

Keep the count on the wcid of the primary link, like the other peer-wide
state.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Link: https://patch.msgid.link/20260818125825.395538-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  7 +++++++
 drivers/net/wireless/mediatek/mt76/tx.c   | 11 ++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 61ef1b80feb85..9188a27e78652 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1425,6 +1425,13 @@ mtxq_to_txq(struct mt76_txq *mtxq)
 	return container_of(ptr, struct ieee80211_txq, drv_priv);
 }
 
+/* peer-wide state uses the wcid of the primary link */
+static inline struct mt76_wcid *
+mt76_wcid_primary(struct mt76_wcid *wcid)
+{
+	return wcid->def_wcid ? wcid->def_wcid : wcid;
+}
+
 static inline struct ieee80211_sta *
 wcid_to_sta(struct mt76_wcid *wcid)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 12c615b1294b4..c6245b10abb0c 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -234,6 +234,8 @@ mt76_tx_check_non_aql(struct mt76_dev *dev, struct mt76_wcid *wcid,
 	if (!wcid || info->tx_time_est)
 		return;
 
+	wcid = mt76_wcid_primary(wcid);
+
 	pending = atomic_dec_return(&wcid->non_aql_packets);
 	if (pending < 0)
 		atomic_cmpxchg(&wcid->non_aql_packets, pending, 0);
@@ -344,7 +346,8 @@ __mt76_tx_queue_skb(struct mt76_phy *phy, int qid, struct sk_buff *skb,
 	if (!non_aql)
 		return idx;
 
-	pending = atomic_inc_return(&wcid->non_aql_packets);
+	/* the hardware can report the completion on a different link */
+	pending = atomic_inc_return(&mt76_wcid_primary(wcid)->non_aql_packets);
 	if (stop && pending >= MT_MAX_NON_AQL_PKT)
 		*stop = true;
 
@@ -498,7 +501,8 @@ mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_queue *q,
 			return 0;
 	}
 
-	if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
+	if (atomic_read(&mt76_wcid_primary(wcid)->non_aql_packets) >=
+	    MT_MAX_NON_AQL_PKT)
 		return 0;
 
 	skb = mt76_txq_dequeue(phy, mtxq);
@@ -595,7 +599,8 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 			continue;
 		}
 
-		if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
+		if (atomic_read(&mt76_wcid_primary(wcid)->non_aql_packets) >=
+		    MT_MAX_NON_AQL_PKT)
 			continue;
 		if (dev->queue_ops->tx_cleanup &&
 		    q->queued + 2 * MT_TXQ_FREE_THR >= q->ndesc) {
-- 
2.53.0



