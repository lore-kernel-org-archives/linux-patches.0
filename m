Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ACB4F7CD5;
	Tue, 13 Oct 2026 12:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894454; cv=none; b=qv5+v4c1KGam2/qypWf6jYtJKwvtpEVVBlZwsecYxf9hJdRJ17/0cpzlemR7/3jV1aZkrY/GbHU29S3hSHr2POKS3oFmQCK27h+7TNg+zNE9la3tGLrWszdQZ0ZOODIKIM6wWeXnmxSNmyZI7hdBKr9PnXrFEpODdKn2I24OgxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894454; c=relaxed/simple;
	bh=Vg9JwXhkh8yG1e3GLGK66NkCXMgGPdKb8J/db7gQQls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tg/0R4tN2zNlSOEcSqJp/CiRhsD78MLBdUDwClo1+E7xkapC92nE9NL7/3nlszXzDjdXhBjkgaYF9bUnxxZLZ561pt2a+RBHhzhbKTeMhq0x915f9Z0VfNpcD6htXs7BAhHzrU8KHCoKfnzm4GSI8/4ZNGOfrUlYxFOyLsI0Zgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juRLMNHu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juRLMNHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CF51F000FF;
	Tue, 13 Oct 2026 12:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894451;
	bh=BZATk9iSFpbNynWqGrWqMOq2pmq9i5iz1sC9Seb9krw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juRLMNHuo8+J87JARHanskCz31G+xeYA/G2z9xw+dJ1hq73kVAHbYdcO28CkKyOvU
	 mLXMyNb1jn6hJEfy/PjS+NrCIjzkAX80CiEohWZMNxDhevYWB6uEm3GIpUzD10H1fz
	 kRf2njCpN599YwroT1ulfLdFtnfPGP4KR0V5mVUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 564/621] wifi: mt76: account non-AQL frames per peer rather than per link
Date: Tue, 13 Oct 2026 13:39:19 +0200
Message-ID: <20261013112934.192562025@linuxfoundation.org>
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
index 93d35aa2158a3..6ca5f3b2c6ba8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1403,6 +1403,13 @@ mtxq_to_txq(struct mt76_txq *mtxq)
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
index 7745ddd255192..8ed0ea3ea03d9 100644
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



