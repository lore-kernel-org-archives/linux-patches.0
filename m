Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5CF53B352;
	Wed, 23 Sep 2026 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175267; cv=none; b=aPmtpETPBQR6U1BMTOdVpMzise4TBOHFh5/VpxmFH+F/v6DuhfBbkI+luEfpYYhxuHpXZLWtImlVHrQxOAivdaVqM3mAG8ib1geAQ9KNnCDVgoxx2SXsLkUlrmdovtJWWqZOLQD0ZjnqN+NRpyDT4n/9RuCMfpYYh4ltGfZAq2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175267; c=relaxed/simple;
	bh=KaTYgao4ZZpHieFvveLgqaL9Gsf3pwH0QDsdCIJHo+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+LM7iy6TgSRvJ/WZW67kPXovYAWEek+56nBzGAr8bEHjatUTRN5O8mJbxDMGmVLX5MJM5d7QcH9PwSj4nNqWRJQ8UzolKbrTBnfzkLQQB63K6vRGbHiWMgbuqnymfaKfQFjTZmUXqgIdJ1SKgv5BjrWOA3MWuWs1acRmWfMtq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVGjYrNM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVGjYrNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDD31F00898;
	Wed, 23 Sep 2026 14:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175265;
	bh=6FXymT+/d3OfNWhkUaoDLm0IM7HFAPJzhTQHZHDglEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVGjYrNMdl3QOjOiRtbGimuLnezlEYUhcTHrKDoULiTYae/314crlwp/yJWSgK9Ka
	 MQOoXj7H1eZcMuR7RdTmo8qet4GSIuFJLQ1JtptZU8nDgj3LZOlmHBiTeDCtYLimMW
	 coTRPBahc5VgUxwC6KSzEtkXoVPHMhn5Dt86l5G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 373/398] wifi: mac80211: track MU-MIMO configuration on disabled interfaces
Date: Wed, 23 Sep 2026 16:07:27 +0200
Message-ID: <20260923140653.116725677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit a5aa46f1ac4f53e03b9b75cbf55634131f2f8cac ]

For monitoring, userspace will try to configure the VIF sdata, while the
driver may see the monitor_sdata that is created when only monitor
interfaces are up. This causes the odd situation that it may not be
possible to store the MU-MIMO configuration on monitor_sdata.

Fix this by storing that information on the VIF sdata and updating the
monitor_sdata when available and the interface is up. Also, adjust the
code that adds monitor_sdata so that it will configure MU-MIMO based on
the newly added interface or one of the existing ones.

This should give a mostly consistent behaviour when configuring MU-MIMO
on sniffer interfaces. Should the user configure MU-MIMO on multiple
sniffer interfaces, then mac80211 will simply select one of the
configurations. This behaviour should be good enough and avoids breaking
user expectations in the common scenarios.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251110141514.677915f8f6bb.If4e04a57052f9ca763562a67248b06fd80d0c2c1@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 2b04d6556964 ("wifi: mac80211: refuse to make a monitor active when it has no queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c         |   47 ++++++++++++++++++++++++++++++---------------
 net/mac80211/ieee80211_i.h |    3 +-
 net/mac80211/iface.c       |   46 ++++++++++++++++++++++++++++++++++++++------
 net/mac80211/util.c        |    3 +-
 4 files changed, 76 insertions(+), 23 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -63,12 +63,14 @@ static void ieee80211_set_mu_mimo_follow
 		memcpy(sdata->vif.bss_conf.mu_group.position,
 		       params->vht_mumimo_groups + WLAN_MEMBERSHIP_LEN,
 		       WLAN_USER_POSITION_LEN);
-		ieee80211_link_info_change_notify(sdata, &sdata->deflink,
-						  BSS_CHANGED_MU_GROUPS);
+
 		/* don't care about endianness - just check for 0 */
 		memcpy(&membership, params->vht_mumimo_groups,
 		       WLAN_MEMBERSHIP_LEN);
 		mu_mimo_groups = membership != 0;
+
+		/* Unset following if configured explicitly */
+		eth_broadcast_addr(sdata->u.mntr.mu_follow_addr);
 	}
 
 	if (params->vht_mumimo_follow_addr) {
@@ -76,16 +78,26 @@ static void ieee80211_set_mu_mimo_follow
 			is_valid_ether_addr(params->vht_mumimo_follow_addr);
 		ether_addr_copy(sdata->u.mntr.mu_follow_addr,
 				params->vht_mumimo_follow_addr);
+
+		/* Unset current membership until a management frame is RXed */
+		memset(sdata->vif.bss_conf.mu_group.membership, 0,
+		       WLAN_MEMBERSHIP_LEN);
 	}
 
 	sdata->vif.bss_conf.mu_mimo_owner = mu_mimo_groups || mu_mimo_follow;
+
+	/* Notify only after setting mu_mimo_owner */
+	if (sdata->vif.bss_conf.mu_mimo_owner &&
+	    sdata->flags & IEEE80211_SDATA_IN_DRIVER)
+		ieee80211_link_info_change_notify(sdata, &sdata->deflink,
+						  BSS_CHANGED_MU_GROUPS);
 }
 
 static int ieee80211_set_mon_options(struct ieee80211_sub_if_data *sdata,
 				     struct vif_params *params)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sub_if_data *monitor_sdata;
+	struct ieee80211_sub_if_data *monitor_sdata = NULL;
 
 	/* check flags first */
 	if (params->flags && ieee80211_sdata_running(sdata)) {
@@ -103,23 +115,28 @@ static int ieee80211_set_mon_options(str
 			return -EBUSY;
 	}
 
-	/* also validate MU-MIMO change */
-	if (ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR))
-		monitor_sdata = sdata;
-	else
-		monitor_sdata = wiphy_dereference(local->hw.wiphy,
-						  local->monitor_sdata);
-
-	if (!monitor_sdata &&
+	/* validate whether MU-MIMO can be configured */
+	if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF) &&
+	    !ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR) &&
 	    (params->vht_mumimo_groups || params->vht_mumimo_follow_addr))
 		return -EOPNOTSUPP;
 
+	/* Also update dependent monitor_sdata if required */
+	if (test_bit(SDATA_STATE_RUNNING, &sdata->state) &&
+	    !ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR))
+		monitor_sdata = wiphy_dereference(local->hw.wiphy,
+						  local->monitor_sdata);
+
 	/* apply all changes now - no failures allowed */
 
-	if (monitor_sdata &&
-		(ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF) ||
-		 ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR)))
-		ieee80211_set_mu_mimo_follow(monitor_sdata, params);
+	if (ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF) ||
+	    ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR)) {
+		/* This is copied in when the VIF is activated */
+		ieee80211_set_mu_mimo_follow(sdata, params);
+
+		if (monitor_sdata)
+			ieee80211_set_mu_mimo_follow(monitor_sdata, params);
+	}
 
 	if (params->flags) {
 		if (ieee80211_sdata_running(sdata)) {
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2114,7 +2114,8 @@ void ieee80211_adjust_monitor_flags(stru
 				    const int offset);
 int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up);
 void ieee80211_sdata_stop(struct ieee80211_sub_if_data *sdata);
-int ieee80211_add_virtual_monitor(struct ieee80211_local *local);
+int ieee80211_add_virtual_monitor(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *creator_sdata);
 void ieee80211_del_virtual_monitor(struct ieee80211_local *local);
 
 bool __ieee80211_recalc_txpower(struct ieee80211_link_data *link);
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -753,8 +753,9 @@ static void ieee80211_do_stop(struct iee
 	ieee80211_configure_filter(local);
 	ieee80211_hw_config(local, -1, hw_reconf_flags);
 
+	/* Passing NULL means an interface is picked for configuration */
 	if (local->virt_monitors == local->open_count)
-		ieee80211_add_virtual_monitor(local);
+		ieee80211_add_virtual_monitor(local, NULL);
 }
 
 void ieee80211_stop_mbssid(struct ieee80211_sub_if_data *sdata)
@@ -1215,7 +1216,8 @@ static void ieee80211_sdata_init(struct
 	ieee80211_link_init(sdata, -1, &sdata->deflink, &sdata->vif.bss_conf);
 }
 
-int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
+int ieee80211_add_virtual_monitor(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *creator_sdata)
 {
 	struct ieee80211_sub_if_data *sdata;
 	int ret;
@@ -1223,10 +1225,14 @@ int ieee80211_add_virtual_monitor(struct
 	ASSERT_RTNL();
 	lockdep_assert_wiphy(local->hw.wiphy);
 
-	if (local->monitor_sdata ||
-	    ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR))
+	if (ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR))
 		return 0;
 
+	/* Already have a monitor set up, configure it */
+	sdata = wiphy_dereference(local->hw.wiphy, local->monitor_sdata);
+	if (sdata)
+		goto configure_monitor;
+
 	sdata = kzalloc(sizeof(*sdata) + local->hw.vif_data_size, GFP_KERNEL);
 	if (!sdata)
 		return -ENOMEM;
@@ -1279,6 +1285,32 @@ int ieee80211_add_virtual_monitor(struct
 	skb_queue_head_init(&sdata->status_queue);
 	wiphy_work_init(&sdata->work, ieee80211_iface_work);
 
+configure_monitor:
+	/* Copy in the MU-MIMO configuration if set */
+	if (!creator_sdata) {
+		struct ieee80211_sub_if_data *other;
+
+		list_for_each_entry(other, &local->mon_list, list) {
+			if (!other->vif.bss_conf.mu_mimo_owner)
+				continue;
+
+			creator_sdata = other;
+			break;
+		}
+	}
+
+	if (creator_sdata && creator_sdata->vif.bss_conf.mu_mimo_owner) {
+		sdata->vif.bss_conf.mu_mimo_owner = true;
+		memcpy(&sdata->vif.bss_conf.mu_group,
+		       &creator_sdata->vif.bss_conf.mu_group,
+		       sizeof(sdata->vif.bss_conf.mu_group));
+		memcpy(&sdata->u.mntr.mu_follow_addr,
+		       creator_sdata->u.mntr.mu_follow_addr, ETH_ALEN);
+
+		ieee80211_link_info_change_notify(sdata, &sdata->deflink,
+						  BSS_CHANGED_MU_GROUPS);
+	}
+
 	return 0;
 }
 
@@ -1435,11 +1467,13 @@ int ieee80211_do_open(struct wireless_de
 			if (res)
 				goto err_stop;
 		} else {
-			if (local->virt_monitors == 0 && local->open_count == 0) {
-				res = ieee80211_add_virtual_monitor(local);
+			/* add/configure if there is no non-monitor interface */
+			if (local->virt_monitors == local->open_count) {
+				res = ieee80211_add_virtual_monitor(local, sdata);
 				if (res)
 					goto err_stop;
 			}
+
 			local->virt_monitors++;
 
 			/* must be before the call to ieee80211_configure_filter */
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2202,9 +2202,10 @@ int ieee80211_reconfig(struct ieee80211_
 		}
 	}
 
+	/* Passing NULL means an interface is picked for configuration */
 	if (local->virt_monitors > 0 &&
 	    local->virt_monitors == local->open_count)
-		ieee80211_add_virtual_monitor(local);
+		ieee80211_add_virtual_monitor(local, NULL);
 
 	if (!suspended)
 		return 0;


