Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EED027F163;
	Wed,  4 Feb 2026 15:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218506; cv=none; b=DmYrm3We0mmWxtr4cY5g6IfBlAlWDu/QPFMEsih9AnBKgLVyVw2F9FfVMT5HetodMXDyYxUGOhrxJFrocS/6cjUVPmOhlsrVNmbC3htcnPSPQtK4WeU58ZWkIcEJ91MpIICQB8C09SWLhwO/Jnl3H2Pp8jeqSkt/87uCO2+NF08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218506; c=relaxed/simple;
	bh=bP4vu1D54tJTi0XBoSIH/IDbRgoudvmi53zjVO6DHxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=idRNIwAF8xr+gG+hZJS48DYj6tm6K77z3PcO/VGQ6yicv69l9iR8QaWR25+fMnrpzLXpsvEP1lTYxHl8tGOJJhK6W5J0iB+q1JM1BGQzQ8bbvb4tlaolWMbqWNMCeREN7+lIe+bAF+d7jXJC33uO7RMyMhyeH6Z4Xv5tX3/tldY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJf6c9RC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJf6c9RC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE652C4CEF7;
	Wed,  4 Feb 2026 15:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218506;
	bh=bP4vu1D54tJTi0XBoSIH/IDbRgoudvmi53zjVO6DHxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJf6c9RCGz4ltOyIcvDlxazWU373FIS9RrvgklRMbKJ8jZ2uZJ4VwBFCOaT/olOUp
	 0/sYtZvmgEvOfhVrxFv4aVTg9H8zvSGAk0fX1ZCHIwF0vB0Rxz7TgSdi4AAcDE1NUj
	 L2otwZBged9eIrSPJCyWMwScs0jNOE8qGGPLv8+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?Hanne-Lotta=20M=C3=A4enp=C3=A4=C3=A4?= <hannelotta@gmail.com>
Subject: [PATCH 6.6 51/72] wifi: mac80211: move TDLS work to wiphy work
Date: Wed,  4 Feb 2026 15:40:54 +0100
Message-ID: <20260204143847.480899530@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 777b26002b73127e81643d9286fadf3d41e0e477 ]

Again, to have the wiphy locked for it.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
(cherry picked from commit 777b26002b73127e81643d9286fadf3d41e0e477)
Signed-off-by: Hanne-Lotta Mäenpää <hannelotta@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/mlme.c        |    7 ++++---
 net/mac80211/tdls.c        |   11 ++++++-----
 3 files changed, 12 insertions(+), 10 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -530,7 +530,7 @@ struct ieee80211_if_managed {
 
 	/* TDLS support */
 	u8 tdls_peer[ETH_ALEN] __aligned(2);
-	struct delayed_work tdls_peer_del_work;
+	struct wiphy_delayed_work tdls_peer_del_work;
 	struct sk_buff *orig_teardown_skb; /* The original teardown skb */
 	struct sk_buff *teardown_skb; /* A copy to send through the AP */
 	spinlock_t teardown_lock; /* To lock changing teardown_skb */
@@ -2599,7 +2599,7 @@ int ieee80211_tdls_mgmt(struct wiphy *wi
 			const u8 *extra_ies, size_t extra_ies_len);
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper);
-void ieee80211_tdls_peer_del_work(struct work_struct *wk);
+void ieee80211_tdls_peer_del_work(struct wiphy *wiphy, struct wiphy_work *wk);
 int ieee80211_tdls_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				  const u8 *addr, u8 oper_class,
 				  struct cfg80211_chan_def *chandef);
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6866,8 +6866,8 @@ void ieee80211_sta_setup_sdata(struct ie
 			ieee80211_beacon_connection_loss_work);
 	wiphy_work_init(&ifmgd->csa_connection_drop_work,
 			ieee80211_csa_connection_drop_work);
-	INIT_DELAYED_WORK(&ifmgd->tdls_peer_del_work,
-			  ieee80211_tdls_peer_del_work);
+	wiphy_delayed_work_init(&ifmgd->tdls_peer_del_work,
+				ieee80211_tdls_peer_del_work);
 	wiphy_delayed_work_init(&ifmgd->ml_reconf_work,
 				ieee80211_ml_reconf_work);
 	timer_setup(&ifmgd->timer, ieee80211_sta_timer, 0);
@@ -7881,7 +7881,8 @@ void ieee80211_mgd_stop(struct ieee80211
 			  &ifmgd->beacon_connection_loss_work);
 	wiphy_work_cancel(sdata->local->hw.wiphy,
 			  &ifmgd->csa_connection_drop_work);
-	cancel_delayed_work_sync(&ifmgd->tdls_peer_del_work);
+	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
+				  &ifmgd->tdls_peer_del_work);
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
 				  &ifmgd->ml_reconf_work);
 
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
@@ -1224,9 +1224,9 @@ ieee80211_tdls_mgmt_setup(struct wiphy *
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
@@ -1526,7 +1526,8 @@ int ieee80211_tdls_oper(struct wiphy *wi
 	}
 
 	if (ret == 0 && ether_addr_equal(sdata->u.mgd.tdls_peer, peer)) {
-		cancel_delayed_work(&sdata->u.mgd.tdls_peer_del_work);
+		wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
+					  &sdata->u.mgd.tdls_peer_del_work);
 		eth_zero_addr(sdata->u.mgd.tdls_peer);
 	}
 


