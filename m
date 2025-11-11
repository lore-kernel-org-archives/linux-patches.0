Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453ABDF76;
	Tue, 11 Nov 2025 01:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824938; cv=none; b=X9T/HPB1+bitce60j4tHr6eaWStnKAJI6J7hGQUOj/6kzbktWPqE6oMxkTCrgPQ6v3gmfVuojP86bDWR2kelPAUU7MAYdyO5xhhpqduN60TkmspfUH3pBXIkyxUr1Tyh4X0Qn1t/w7rBGsDTEx4xrhiDuBZbNG8ULtDUOHWFhNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824938; c=relaxed/simple;
	bh=jhV3iXm4ClNrX3FYViHB3stdgwTdTo+WunpHEWvfPH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDETnH2ngVt4x0gXPYfhKBcDlDpL5PTKODTiTHFb9xaLgJPVo6WUBPSBMu5oYx5tT677QTt0sJTOerYIHi7NzORVckZngDdVuCi/cgyT/U/W5J18nnp2ijZRM5U8C7nqoNS83NCrZydxbh1j+Cl3DGxU0Nrde9U8ikzvtITva0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaRx1wO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaRx1wO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3DBC16AAE;
	Tue, 11 Nov 2025 01:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824938;
	bh=jhV3iXm4ClNrX3FYViHB3stdgwTdTo+WunpHEWvfPH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaRx1wO7Nd5VemWXY3s9C3UtzsqndRMr5qrWfrm1b4KMr4h6m3E3pkX+hgaOb5yRe
	 UP3VG6pMrxmGjpX7i9UzmNJnUybaM26jbEfHkUZ63MCdhkd5S9vx3H0lfuSztcKkNl
	 fieJbxcwrLhGZjeSbAQSI3rRtNSbTsCbOAI6MOgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 601/849] wifi: mac80211: Get the correct interface for non-netdev skb status
Date: Tue, 11 Nov 2025 09:42:51 +0900
Message-ID: <20251111004550.953803617@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit c7b5355b37a59c927b2374e9f783acd004d00960 ]

The function ieee80211_sdata_from_skb() always returned the P2P Device
interface in case the skb was not associated with a netdev and didn't
consider the possibility that an NAN Device interface is also enabled.

To support configurations where both P2P Device and a NAN Device
interface are active, extend the function to match the correct
interface based on address 2 in the 802.11 MAC header.

Since the 'p2p_sdata' field in struct ieee80211_local is no longer
needed, remove it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250908140015.5252d2579a49.Id4576531c6b2ad83c9498b708dc0ade6b0214fa8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h |  2 --
 net/mac80211/iface.c       | 16 +---------------
 net/mac80211/status.c      | 21 +++++++++++++++++++--
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8afa2404eaa8e..140dc7e32d4aa 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1665,8 +1665,6 @@ struct ieee80211_local {
 	struct idr ack_status_frames;
 	spinlock_t ack_status_lock;
 
-	struct ieee80211_sub_if_data __rcu *p2p_sdata;
-
 	/* virtual monitor interface */
 	struct ieee80211_sub_if_data __rcu *monitor_sdata;
 	struct ieee80211_chan_req monitor_chanreq;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 07ba68f7cd817..abc8cca54f4e1 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -611,10 +611,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 
 		spin_unlock_bh(&sdata->u.nan.func_lock);
 		break;
-	case NL80211_IFTYPE_P2P_DEVICE:
-		/* relies on synchronize_rcu() below */
-		RCU_INIT_POINTER(local->p2p_sdata, NULL);
-		fallthrough;
 	default:
 		wiphy_work_cancel(sdata->local->hw.wiphy, &sdata->work);
 		/*
@@ -1405,6 +1401,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		ieee80211_recalc_idle(local);
 
 		netif_carrier_on(dev);
+		list_add_tail_rcu(&sdata->u.mntr.list, &local->mon_list);
 		break;
 	default:
 		if (coming_up) {
@@ -1468,17 +1465,6 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			sdata->vif.type != NL80211_IFTYPE_STATION);
 	}
 
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_P2P_DEVICE:
-		rcu_assign_pointer(local->p2p_sdata, sdata);
-		break;
-	case NL80211_IFTYPE_MONITOR:
-		list_add_tail_rcu(&sdata->u.mntr.list, &local->mon_list);
-		break;
-	default:
-		break;
-	}
-
 	/*
 	 * set_multicast_list will be invoked by the networking core
 	 * which will check whether any increments here were done in
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index a362254b310cd..4b38aa0e902a8 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2008-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright 2021-2024  Intel Corporation
+ * Copyright 2021-2025  Intel Corporation
  */
 
 #include <linux/export.h>
@@ -572,6 +572,7 @@ static struct ieee80211_sub_if_data *
 ieee80211_sdata_from_skb(struct ieee80211_local *local, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hdr *hdr = (void *)skb->data;
 
 	if (skb->dev) {
 		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
@@ -585,7 +586,23 @@ ieee80211_sdata_from_skb(struct ieee80211_local *local, struct sk_buff *skb)
 		return NULL;
 	}
 
-	return rcu_dereference(local->p2p_sdata);
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_P2P_DEVICE:
+			break;
+		case NL80211_IFTYPE_NAN:
+			if (sdata->u.nan.started)
+				break;
+			fallthrough;
+		default:
+			continue;
+		}
+
+		if (ether_addr_equal(sdata->vif.addr, hdr->addr2))
+			return sdata;
+	}
+
+	return NULL;
 }
 
 static void ieee80211_report_ack_skb(struct ieee80211_local *local,
-- 
2.51.0



