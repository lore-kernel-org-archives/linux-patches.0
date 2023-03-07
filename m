Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A63BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D949C4339B;
	Tue,  7 Mar 2023 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212708;
	bh=ixEwJp9WTAMQNd18J15BF1Jy9Qoxvt+YxPUGOkeBAGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4E14U3BW97TwMpCmK7XFJ5G+x80Qpt9cNl97PRg1bIKnq5byaITrxzDgHzHiM7B3
	 Orow7cOQHpmij34E6yJwBVaslQWkASUxgTO5NKgTuqGhYdruoX45KVilW8IX2iAOwf
	 z7TPmXN8ydNuKHW2YLVnLII9fnbkQcpVPTTS4TDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 244/885] wifi: mac80211: pass sta to ieee80211_rx_data_set_sta()
Date: Tue,  7 Mar 2023 17:52:58 +0100
Message-Id: <20230307170012.609527113@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0d846bdc11101ac0ba4d89c2be359af08cb9379b ]

There's at least one case in ieee80211_rx_for_interface()
where we might pass &((struct sta_info *)NULL)->sta to it
only to then do container_of(), and then checking the
result for NULL, but checking the result of container_of()
for NULL looks really odd.

Fix this by just passing the struct sta_info * instead.

Fixes: e66b7920aa5a ("wifi: mac80211: fix initialization of rx->link and rx->link_sta")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 08e01bddc9fb2..44e407e1a14c7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4094,13 +4094,8 @@ static bool ieee80211_rx_data_set_link(struct ieee80211_rx_data *rx,
 }
 
 static bool ieee80211_rx_data_set_sta(struct ieee80211_rx_data *rx,
-				      struct ieee80211_sta *pubsta,
-				      int link_id)
+				      struct sta_info *sta, int link_id)
 {
-	struct sta_info *sta;
-
-	sta = container_of(pubsta, struct sta_info, sta);
-
 	rx->link_id = link_id;
 	rx->sta = sta;
 
@@ -4138,7 +4133,7 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 	if (sta->sta.valid_links)
 		link_id = ffs(sta->sta.valid_links) - 1;
 
-	if (!ieee80211_rx_data_set_sta(&rx, &sta->sta, link_id))
+	if (!ieee80211_rx_data_set_sta(&rx, sta, link_id))
 		return;
 
 	tid_agg_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
@@ -4184,7 +4179,7 @@ void ieee80211_mark_rx_ba_filtered_frames(struct ieee80211_sta *pubsta, u8 tid,
 
 	sta = container_of(pubsta, struct sta_info, sta);
 
-	if (!ieee80211_rx_data_set_sta(&rx, pubsta, -1))
+	if (!ieee80211_rx_data_set_sta(&rx, sta, -1))
 		return;
 
 	rcu_read_lock();
@@ -4892,6 +4887,7 @@ static void __ieee80211_rx_handle_8023(struct ieee80211_hw *hw,
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_fast_rx *fast_rx;
 	struct ieee80211_rx_data rx;
+	struct sta_info *sta;
 	int link_id = -1;
 
 	memset(&rx, 0, sizeof(rx));
@@ -4919,7 +4915,8 @@ static void __ieee80211_rx_handle_8023(struct ieee80211_hw *hw,
 	 * link_id is used only for stats purpose and updating the stats on
 	 * the deflink is fine?
 	 */
-	if (!ieee80211_rx_data_set_sta(&rx, pubsta, link_id))
+	sta = container_of(pubsta, struct sta_info, sta);
+	if (!ieee80211_rx_data_set_sta(&rx, sta, link_id))
 		goto drop;
 
 	fast_rx = rcu_dereference(rx.sta->fast_rx);
@@ -4959,7 +4956,7 @@ static bool ieee80211_rx_for_interface(struct ieee80211_rx_data *rx,
 			link_id = status->link_id;
 	}
 
-	if (!ieee80211_rx_data_set_sta(rx, &sta->sta, link_id))
+	if (!ieee80211_rx_data_set_sta(rx, sta, link_id))
 		return false;
 
 	return ieee80211_prepare_and_rx_handle(rx, skb, consume);
@@ -5026,7 +5023,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			link_id = status->link_id;
 
 		if (pubsta) {
-			if (!ieee80211_rx_data_set_sta(&rx, pubsta, link_id))
+			sta = container_of(pubsta, struct sta_info, sta);
+			if (!ieee80211_rx_data_set_sta(&rx, sta, link_id))
 				goto out;
 
 			/*
@@ -5063,8 +5061,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			}
 
 			rx.sdata = prev_sta->sdata;
-			if (!ieee80211_rx_data_set_sta(&rx, &prev_sta->sta,
-						       link_id))
+			if (!ieee80211_rx_data_set_sta(&rx, prev_sta, link_id))
 				goto out;
 
 			if (!status->link_valid && prev_sta->sta.mlo)
@@ -5077,8 +5074,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 
 		if (prev_sta) {
 			rx.sdata = prev_sta->sdata;
-			if (!ieee80211_rx_data_set_sta(&rx, &prev_sta->sta,
-						       link_id))
+			if (!ieee80211_rx_data_set_sta(&rx, prev_sta, link_id))
 				goto out;
 
 			if (!status->link_valid && prev_sta->sta.mlo)
-- 
2.39.2



