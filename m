Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA8C1F91F6;
	Tue, 13 Oct 2026 12:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894446; cv=none; b=Mb8oRHCbAobn5CeR+1Xof0ebBvGPfj65v5gQOWDaaWRTwIbk+q2XX1IFjKQom0AIacY1tVUD1PbrbkC/IF4zRBXWpdDaha4ccT4nkfDD/ROn2RU6SJcop6AIZ9vJKu+3K9WIKtr7iY4Oi++78I3Iueyw9jnXv5viHFqYvNhd4uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894446; c=relaxed/simple;
	bh=txtn02da1Ud0LMNLCebk+E6JLLqxnPqMtDD9Kcr05xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBjW/GDk0VW0fb6HpTUspb43p7251Rw4SRKe+GyNCgfoIJfo5UQjaS19IsfajEdpBaCx3KTr+8Gjc/xCJxwOrgE/297okiDyIUy12cV2pYDcm9bAwQBtJyNIZ76EZVyI82MVigNUDwG8i3Z5Ij5bUrle7QDUuws+CeZZb8OpTHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGpBxKXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGpBxKXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE111F000FF;
	Tue, 13 Oct 2026 12:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894445;
	bh=82AA6ExFeIrc7yEavYQ9OHh4/qZy9JuuYWNFJ4rxsiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGpBxKXNsubayVIRMWkAlq85Xvk9liZfkKICpbci2Wk22KQdk78jst/Suk6qIYWus
	 Wv1YbBesZAYobh4QsAOS+rZNnJ4HpPE1Ig81ZL6fXj/TuOjnfTT2SJ2vfY6XjNMxtK
	 QXwy9V4T1O2+7wEYDed+s1uQlXGdMtYh/7UIs5R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 562/621] wifi: mac80211: add ieee80211_txq_aql_pending()
Date: Tue, 13 Oct 2026 13:39:17 +0200
Message-ID: <20261013112934.145422315@linuxfoundation.org>
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
index 22d5b2eb21b49..f8fa1f55694b6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6607,6 +6607,17 @@ void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
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
index 171682a16f4cf..63867702ab08a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4233,6 +4233,24 @@ bool ieee80211_txq_airtime_check(struct ieee80211_hw *hw,
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



