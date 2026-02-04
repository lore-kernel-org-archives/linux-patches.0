Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31057285404;
	Wed,  4 Feb 2026 15:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217313; cv=none; b=g8taZfV2pqk5c8Wohmwm37AexKPHENbQZnITpy6p2H8BU+MZbT0WtPL3vUuGMhi+lDnKOhY8evCrBYCS/It6AT8iZyipb7p8NyOcfeyoksCw1B+TuGdIYkEI/c7e5Tcy8toi/GrsVYEnh5paTUj2daG198xY1M0KVgK/O58KPJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217313; c=relaxed/simple;
	bh=PLSbMKjn28tGQRp2C+Pkl3ylSDbIrCyxC+sdkvUplVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDUnUmVpUGUZuG2onvuAcuYJPkNRvUSLN0LXPeNHX93XZIaUNUa+JtpxHZlnJGTubJiQDiiwXb8Td2iyDGwgv5DEIkyCkE9Q0Xm3XNqrijEpw8W6PwsK1nIZ8SdO3Mgy8toLbo9YhEZlGgI6/Qe24TQADrt5qEVn/o6KFetYTN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3kCM8pZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3kCM8pZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920A9C4CEF7;
	Wed,  4 Feb 2026 15:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217313;
	bh=PLSbMKjn28tGQRp2C+Pkl3ylSDbIrCyxC+sdkvUplVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3kCM8pZZdcuO3MWn6foF4XR130zftyaHvKIhb1nIuoUbCCutxb+icIEXRUFwoBQ5
	 3URaYxAx42DlR4aX8jOVCjstAVdFRKTJQOAGpyXqo/DpYLcnC1rFZOFtZkA9mecF37
	 SFexb90/gw9EKffAvD/ylYjrj8wHXb/PDhQJ9+Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?Hanne-Lotta=20M=C3=A4enp=C3=A4=C3=A4?= <hannelotta@gmail.com>
Subject: [PATCH 5.15 186/206] wifi: mac80211: use wiphy work for sdata->work
Date: Wed,  4 Feb 2026 15:40:17 +0100
Message-ID: <20260204143904.920886209@linuxfoundation.org>
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

[ Upstream commit 16114496d684a3df4ce09f7c6b7557a8b2922795 ]

We'll need this later to convert other works that might
be cancelled from here, so convert this one first.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Hanne-Lotta Mäenpää <hannelotta@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ibss.c        |    8 ++++----
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/iface.c       |   10 +++++-----
 net/mac80211/mesh.c        |   10 +++++-----
 net/mac80211/mesh_hwmp.c   |    6 +++---
 net/mac80211/mlme.c        |    6 +++---
 net/mac80211/ocb.c         |    6 +++---
 net/mac80211/rx.c          |    2 +-
 net/mac80211/scan.c        |    2 +-
 net/mac80211/status.c      |    5 +++--
 net/mac80211/util.c        |    2 +-
 11 files changed, 30 insertions(+), 29 deletions(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -746,7 +746,7 @@ static void ieee80211_csa_connection_dro
 	skb_queue_purge(&sdata->skb_queue);
 
 	/* trigger a scan to find another IBSS network to join */
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 
 	sdata_unlock(sdata);
 }
@@ -1245,7 +1245,7 @@ void ieee80211_ibss_rx_no_sta(struct iee
 	spin_lock(&ifibss->incomplete_lock);
 	list_add(&sta->list, &ifibss->incomplete_stations);
 	spin_unlock(&ifibss->incomplete_lock);
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	wiphy_work_queue(local->hw.wiphy, &sdata->work);
 }
 
 static void ieee80211_ibss_sta_expire(struct ieee80211_sub_if_data *sdata)
@@ -1726,7 +1726,7 @@ static void ieee80211_ibss_timer(struct
 	struct ieee80211_sub_if_data *sdata =
 		from_timer(sdata, t, u.ibss.timer);
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 }
 
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
@@ -1861,7 +1861,7 @@ int ieee80211_ibss_join(struct ieee80211
 	sdata->needed_rx_chains = local->rx_chains;
 	sdata->control_port_over_nl80211 = params->control_port_over_nl80211;
 
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	wiphy_work_queue(local->hw.wiphy, &sdata->work);
 
 	return 0;
 }
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -966,7 +966,7 @@ struct ieee80211_sub_if_data {
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
 
-	struct work_struct work;
+	struct wiphy_work work;
 	struct sk_buff_head skb_queue;
 	struct sk_buff_head status_queue;
 
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -43,7 +43,7 @@
  * by either the RTNL, the iflist_mtx or RCU.
  */
 
-static void ieee80211_iface_work(struct work_struct *work);
+static void ieee80211_iface_work(struct wiphy *wiphy, struct wiphy_work *work);
 
 bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 {
@@ -539,7 +539,7 @@ static void ieee80211_do_stop(struct iee
 		RCU_INIT_POINTER(local->p2p_sdata, NULL);
 		fallthrough;
 	default:
-		cancel_work_sync(&sdata->work);
+		wiphy_work_cancel(sdata->local->hw.wiphy, &sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
 		 * Free the remaining keys, if there are any
@@ -1005,7 +1005,7 @@ int ieee80211_add_virtual_monitor(struct
 
 	skb_queue_head_init(&sdata->skb_queue);
 	skb_queue_head_init(&sdata->status_queue);
-	INIT_WORK(&sdata->work, ieee80211_iface_work);
+	wiphy_work_init(&sdata->work, ieee80211_iface_work);
 
 	return 0;
 }
@@ -1487,7 +1487,7 @@ static void ieee80211_iface_process_stat
 	}
 }
 
-static void ieee80211_iface_work(struct work_struct *work)
+static void ieee80211_iface_work(struct wiphy *wiphy, struct wiphy_work *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data, work);
@@ -1590,7 +1590,7 @@ static void ieee80211_setup_sdata(struct
 
 	skb_queue_head_init(&sdata->skb_queue);
 	skb_queue_head_init(&sdata->status_queue);
-	INIT_WORK(&sdata->work, ieee80211_iface_work);
+	wiphy_work_init(&sdata->work, ieee80211_iface_work);
 	INIT_WORK(&sdata->recalc_smps, ieee80211_recalc_smps_work);
 	INIT_WORK(&sdata->csa_finalize_work, ieee80211_csa_finalize_work);
 	INIT_WORK(&sdata->color_change_finalize_work, ieee80211_color_change_finalize_work);
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -44,7 +44,7 @@ static void ieee80211_mesh_housekeeping_
 
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	wiphy_work_queue(local->hw.wiphy, &sdata->work);
 }
 
 /**
@@ -642,7 +642,7 @@ static void ieee80211_mesh_path_timer(st
 	struct ieee80211_sub_if_data *sdata =
 		from_timer(sdata, t, u.mesh.mesh_path_timer);
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 }
 
 static void ieee80211_mesh_path_root_timer(struct timer_list *t)
@@ -653,7 +653,7 @@ static void ieee80211_mesh_path_root_tim
 
 	set_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags);
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 }
 
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh)
@@ -1018,7 +1018,7 @@ void ieee80211_mbss_info_change_notify(s
 	for_each_set_bit(bit, &bits, sizeof(changed) * BITS_PER_BYTE)
 		set_bit(bit, &ifmsh->mbss_changed);
 	set_bit(MESH_WORK_MBSS_CHANGED, &ifmsh->wrkq_flags);
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 }
 
 int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
@@ -1043,7 +1043,7 @@ int ieee80211_start_mesh(struct ieee8021
 	ifmsh->sync_offset_clockdrift_max = 0;
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 	ieee80211_mesh_root_setup(ifmsh);
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	wiphy_work_queue(local->hw.wiphy, &sdata->work);
 	sdata->vif.bss_conf.ht_operation_mode =
 				ifmsh->mshcfg.ht_opmode;
 	sdata->vif.bss_conf.enable_beacon = true;
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (c) 2008, 2009 open80211s Ltd.
- * Copyright (C) 2019, 2021 Intel Corporation
+ * Copyright (C) 2019, 2021-2023 Intel Corporation
  * Author:     Luis Carlos Cobo <luisca@cozybit.com>
  */
 
@@ -1020,14 +1020,14 @@ static void mesh_queue_preq(struct mesh_
 	spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 
 	if (time_after(jiffies, ifmsh->last_preq + min_preq_int_jiff(sdata)))
-		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+		wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 
 	else if (time_before(jiffies, ifmsh->last_preq)) {
 		/* avoid long wait if did not send preqs for a long time
 		 * and jiffies wrapped around
 		 */
 		ifmsh->last_preq = jiffies - min_preq_int_jiff(sdata) - 1;
-		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+		wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 	} else
 		mod_timer(&ifmsh->mesh_path_timer, ifmsh->last_preq +
 						min_preq_int_jiff(sdata));
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2509,7 +2509,7 @@ void ieee80211_sta_tx_notify(struct ieee
 		sdata->u.mgd.probe_send_count = 0;
 	else
 		sdata->u.mgd.nullfunc_failed = true;
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 }
 
 static void ieee80211_mlme_send_probe_req(struct ieee80211_sub_if_data *sdata,
@@ -4415,7 +4415,7 @@ static void ieee80211_sta_timer(struct t
 	struct ieee80211_sub_if_data *sdata =
 		from_timer(sdata, t, u.mgd.timer);
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 }
 
 void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
@@ -4559,7 +4559,7 @@ void ieee80211_mgd_conn_tx_status(struct
 	sdata->u.mgd.status_acked = acked;
 	sdata->u.mgd.status_received = true;
 
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	wiphy_work_queue(local->hw.wiphy, &sdata->work);
 }
 
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -80,7 +80,7 @@ void ieee80211_ocb_rx_no_sta(struct ieee
 	spin_lock(&ifocb->incomplete_lock);
 	list_add(&sta->list, &ifocb->incomplete_stations);
 	spin_unlock(&ifocb->incomplete_lock);
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	wiphy_work_queue(local->hw.wiphy, &sdata->work);
 }
 
 static struct sta_info *ieee80211_ocb_finish_sta(struct sta_info *sta)
@@ -156,7 +156,7 @@ static void ieee80211_ocb_housekeeping_t
 
 	set_bit(OCB_WORK_HOUSEKEEPING, &ifocb->wrkq_flags);
 
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	wiphy_work_queue(local->hw.wiphy, &sdata->work);
 }
 
 void ieee80211_ocb_setup_sdata(struct ieee80211_sub_if_data *sdata)
@@ -196,7 +196,7 @@ int ieee80211_ocb_join(struct ieee80211_
 	ifocb->joined = true;
 
 	set_bit(OCB_WORK_HOUSEKEEPING, &ifocb->wrkq_flags);
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	wiphy_work_queue(local->hw.wiphy, &sdata->work);
 
 	netif_carrier_on(sdata->dev);
 	return 0;
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -219,7 +219,7 @@ static void __ieee80211_queue_skb_to_ifa
 					   struct sk_buff *skb)
 {
 	skb_queue_tail(&sdata->skb_queue, skb);
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 	if (sta)
 		sta->rx_stats.packets++;
 }
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -498,7 +498,7 @@ static void __ieee80211_scan_completed(s
 	 */
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (ieee80211_sdata_running(sdata))
-			ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+			wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 	}
 
 	if (was_scanning)
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -5,6 +5,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2008-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2021-2023  Intel Corporation
  */
 
 #include <linux/export.h>
@@ -716,8 +717,8 @@ static void ieee80211_report_used_skb(st
 					if (qskb) {
 						skb_queue_tail(&sdata->status_queue,
 							       qskb);
-						ieee80211_queue_work(&local->hw,
-								     &sdata->work);
+						wiphy_work_queue(local->hw.wiphy,
+								 &sdata->work);
 					}
 				}
 			} else {
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2679,7 +2679,7 @@ int ieee80211_reconfig(struct ieee80211_
 
 		/* Requeue all works */
 		list_for_each_entry(sdata, &local->interfaces, list)
-			ieee80211_queue_work(&local->hw, &sdata->work);
+			wiphy_work_queue(local->hw.wiphy, &sdata->work);
 	}
 
 	ieee80211_wake_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,


