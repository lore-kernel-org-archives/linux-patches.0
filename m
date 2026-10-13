Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11559155C87;
	Tue, 13 Oct 2026 11:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892607; cv=none; b=RsSAFamz5UOpe5mKPx3/+0hxyfcbhyE6VO0ojElzapJpai4+Az4Gmt1NrZ3oOwyvDNv3PoUfObvlRCQiy0OOJ3/9sHbfVb0/hyO0m/MNWPC6sAaWnBsiCutA7U7iBCjvHYh1hQl+W4rGJ/k6fV4U2ran0JQIbl6EN5WXK6cQX0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892607; c=relaxed/simple;
	bh=ZGH6rda/crdNXj61h1ZVYOqeZJJQDcjz5EkYDOb5MmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnhVGEH8JBMVl71T4yr8e9bWwLMWCzX0znNmnB/2n4P2JLukzeLVPVUOxvDHNY2YXwEYnC66H+YgvbJiTxtr2OhUeNK6VRzZTBQzxqdl6q4zzQ+80+Qxbycj/0Cp+CuLugHPnBSkDNoQAxehh4tqVoiTarU73XeL0m4uoIAXs0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bOzgzDi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bOzgzDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5931B1F000FF;
	Tue, 13 Oct 2026 11:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892606;
	bh=dC5E1wRNYHhIi09508rNsTsbqLDgAbKmtz7BWbMSgUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bOzgzDiXRDDoJyf8EuVwKKfrlHuM/LbxpqibKRPDxHeJrG3n7MwxiyThcRQrvTtW
	 VpCz4BqHWSjxhdD8XtkgBeph6+juWT6qurv4h+d/yWsUGexcoFkPuZG7YVcdhWi6kg
	 CAXIDdhlKv75TFTJS2xkZ8Q+6XCzjK7zfgMHIe3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 230/281] wifi: mac80211: add ieee80211_txq_aql_pending()
Date: Tue, 13 Oct 2026 13:39:06 +0200
Message-ID: <20261013112900.733846231@linuxfoundation.org>
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

[ Upstream commit 9a197e71eb7b45860e37a9f3bdf61a843781ae12 ]

Add a function to allow drivers to query the pending AQL airtime
for a given txq, for both unicast and broadcast.
This will be used for mt76 to limit buffering in AP mode for power-save
stations.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20260724115429.3921457-4-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 752770d7a58c ("wifi: mt76: account non-AQL frames per peer rather than per link")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h | 11 +++++++++++
 net/mac80211/tx.c      | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8007d3e5a8483..7b610dfee2867 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6877,6 +6877,17 @@ void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
 bool
 ieee80211_txq_airtime_check(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
 
+/**
+ * ieee80211_txq_aql_pending - get pending AQL airtime for a txq
+ *
+ * @hw: pointer obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ *
+ * Return: pending airtime (in usec) for the given txq.
+ */
+u32 ieee80211_txq_aql_pending(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq);
+
 /**
  * ieee80211_iter_keys - iterate keys programmed into the device
  * @hw: pointer obtained from ieee80211_alloc_hw()
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 546646aabb41c..3e5b1c05f4a3e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4281,6 +4281,24 @@ bool ieee80211_txq_airtime_check(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_txq_airtime_check);
 
+u32 ieee80211_txq_aql_pending(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct sta_info *sta;
+
+	if (unlikely(txq->tid == IEEE80211_NUM_TIDS))
+		return 0;
+
+	if (!txq->sta)
+		return atomic_read(&local->aql_mc_pending_airtime);
+
+	sta = container_of(txq->sta, struct sta_info, sta);
+
+	return atomic_read(&sta->airtime[txq->ac].aql_tx_pending);
+}
+EXPORT_SYMBOL(ieee80211_txq_aql_pending);
+
 static bool
 ieee80211_txq_schedule_airtime_check(struct ieee80211_local *local, u8 ac)
 {
-- 
2.53.0



