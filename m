Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F9B285404;
	Wed,  4 Feb 2026 15:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217316; cv=none; b=fctZ9g7rJ6GE980+kLmLp5oGq+wdJstXwNX2aaPXk6t3CTKYrY5Is27pMfNKk2Kb8Q9+0nVL3ALEHGx+lLPKi/KwAwd+GYk/nGkWl0GwbqT68VIpVqjAg2yYibpUPHpXLpfIqNiuJXCNeFQR6q+MEoCzo2kfT/HG1WuyNA8zg9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217316; c=relaxed/simple;
	bh=A10wiJ8PMHyBPpBRYRtBQwNNFLvwUUZ4ENtb4E2DVoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DVEmJ+0yoL+bcLCiazPQRNUpN63AeYpE61+Jlgw9P7W0CpxuJ2qpZ1xlHmtcLxLB6IKVLwk/0BlHsNf0MZMVxooSNXoQwf6b2J1hCYVrFDcxKHIx4hOgHQd0USPYR8zhDJMyQ2ZHsQGFDHc+OEpQaEbwtVUSarFBS38oaxtOqGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCni+ze3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCni+ze3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD08C4CEF7;
	Wed,  4 Feb 2026 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217316;
	bh=A10wiJ8PMHyBPpBRYRtBQwNNFLvwUUZ4ENtb4E2DVoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCni+ze3XChV9HXIqbUEqEs3JO+4bAKkLuUnBfIiCICn9mr7b3FNpOBW52H2QqB06
	 sQO4A4OWzjQCRJzNrOADouBnPc6158BWeRp2qAzpT0Vyf7K6AN28S6mgvF8Hl2BnDS
	 /knBjdw1FrAr3JzbjBip3yKeIf6oZY3NWm09JtCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?Hanne-Lotta=20M=C3=A4enp=C3=A4=C3=A4?= <hannelotta@gmail.com>
Subject: [PATCH 5.15 187/206] wifi: mac80211: move TDLS work to wiphy work
Date: Wed,  4 Feb 2026 15:40:18 +0100
Message-ID: <20260204143904.957973070@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 777b26002b73127e81643d9286fadf3d41e0e477 ]

Again, to have the wiphy locked for it.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ Summary of conflict resolutions:
  - In mlme.c, move only tdls_peer_del_work
    to wiphy work, and none the other works ]
Signed-off-by: Hanne-Lotta Mäenpää <hannelotta@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/mlme.c        |    7 ++++---
 net/mac80211/tdls.c        |   11 ++++++-----
 3 files changed, 12 insertions(+), 10 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -542,7 +542,7 @@ struct ieee80211_if_managed {
 
 	/* TDLS support */
 	u8 tdls_peer[ETH_ALEN] __aligned(2);
-	struct delayed_work tdls_peer_del_work;
+	struct wiphy_delayed_work tdls_peer_del_work;
 	struct sk_buff *orig_teardown_skb; /* The original teardown skb */
 	struct sk_buff *teardown_skb; /* A copy to send through the AP */
 	spinlock_t teardown_lock; /* To lock changing teardown_skb */
@@ -2494,7 +2494,7 @@ int ieee80211_tdls_mgmt(struct wiphy *wi
 			size_t extra_ies_len);
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper);
-void ieee80211_tdls_peer_del_work(struct work_struct *wk);
+void ieee80211_tdls_peer_del_work(struct wiphy *wiphy, struct wiphy_work *wk);
 int ieee80211_tdls_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				  const u8 *addr, u8 oper_class,
 				  struct cfg80211_chan_def *chandef);
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4890,8 +4890,8 @@ void ieee80211_sta_setup_sdata(struct ie
 	INIT_WORK(&ifmgd->csa_connection_drop_work,
 		  ieee80211_csa_connection_drop_work);
 	INIT_WORK(&ifmgd->request_smps_work, ieee80211_request_smps_mgd_work);
-	INIT_DELAYED_WORK(&ifmgd->tdls_peer_del_work,
-			  ieee80211_tdls_peer_del_work);
+	wiphy_delayed_work_init(&ifmgd->tdls_peer_del_work,
+				ieee80211_tdls_peer_del_work);
 	timer_setup(&ifmgd->timer, ieee80211_sta_timer, 0);
 	timer_setup(&ifmgd->bcn_mon_timer, ieee80211_sta_bcn_mon_timer, 0);
 	timer_setup(&ifmgd->conn_mon_timer, ieee80211_sta_conn_mon_timer, 0);
@@ -6010,7 +6010,8 @@ void ieee80211_mgd_stop(struct ieee80211
 	cancel_work_sync(&ifmgd->request_smps_work);
 	cancel_work_sync(&ifmgd->csa_connection_drop_work);
 	cancel_work_sync(&ifmgd->chswitch_work);
-	cancel_delayed_work_sync(&ifmgd->tdls_peer_del_work);
+	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
+				  &ifmgd->tdls_peer_del_work);
 
 	sdata_lock(sdata);
 	if (ifmgd->assoc_data) {
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -21,7 +21,7 @@
 /* give usermode some time for retries in setting up the TDLS session */
 #define TDLS_PEER_SETUP_TIMEOUT	(15 * HZ)
 
-void ieee80211_tdls_peer_del_work(struct work_struct *wk)
+void ieee80211_tdls_peer_del_work(struct wiphy *wiphy, struct wiphy_work *wk)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_local *local;
@@ -1126,9 +1126,9 @@ ieee80211_tdls_mgmt_setup(struct wiphy *
 		return ret;
 	}
 
-	ieee80211_queue_delayed_work(&sdata->local->hw,
-				     &sdata->u.mgd.tdls_peer_del_work,
-				     TDLS_PEER_SETUP_TIMEOUT);
+	wiphy_delayed_work_queue(sdata->local->hw.wiphy,
+				 &sdata->u.mgd.tdls_peer_del_work,
+				 TDLS_PEER_SETUP_TIMEOUT);
 	return 0;
 
 out_unlock:
@@ -1425,7 +1425,8 @@ int ieee80211_tdls_oper(struct wiphy *wi
 	}
 
 	if (ret == 0 && ether_addr_equal(sdata->u.mgd.tdls_peer, peer)) {
-		cancel_delayed_work(&sdata->u.mgd.tdls_peer_del_work);
+		wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
+					  &sdata->u.mgd.tdls_peer_del_work);
 		eth_zero_addr(sdata->u.mgd.tdls_peer);
 	}
 


