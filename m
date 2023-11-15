Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB5F3A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u63nDa1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAC0C433C8;
	Wed, 15 Nov 2023 19:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077959;
	bh=PL/J7RSROtrWY0qlTih4sXKPa99r9pi+qzc7b2yOy7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u63nDa1Do6Y07NRIwnHfMgkWQzSCCGB+g82ovJ8djWqQlUHO/SqmeaTmP6hUQS8kP
	 78Y4ihdxpvqlsoeQrMBL0mUS0ZK4UDnn6zbEr95EyH0ePafBWVjT9UqkNhCeSOkHOd
	 3rvHxdSA6MESw6HHWptz+v48tr5GNWPuDKSXmUI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/379] wifi: mac80211: move scan work to wiphy work
Date: Wed, 15 Nov 2023 14:21:37 -0500
Message-ID: <20231115192646.470037424@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 201712512cbbda360f62c222a4bab260350462a0 ]

Move the scan work to wiphy work, which also simplifies
the way we handle the work vs. the scan configuration.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: eadfb54756ae ("wifi: mac80211: move sched-scan stop work to wiphy work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/iface.c       |  2 +-
 net/mac80211/main.c        |  4 +---
 net/mac80211/scan.c        | 29 ++++++++++++-----------------
 net/mac80211/util.c        |  4 ++--
 5 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3960f40c9da99..ab759b3b2e88e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1445,7 +1445,7 @@ struct ieee80211_local {
 
 	unsigned long leave_oper_channel_time;
 	enum mac80211_scan_state next_scan_state;
-	struct delayed_work scan_work;
+	struct wiphy_delayed_work scan_work;
 	struct ieee80211_sub_if_data __rcu *scan_sdata;
 	/* For backward compatibility only -- do not use */
 	struct cfg80211_chan_def _oper_chandef;
@@ -1862,7 +1862,7 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata);
 
 /* scan/BSS handling */
-void ieee80211_scan_work(struct work_struct *work);
+void ieee80211_scan_work(struct wiphy *wiphy, struct wiphy_work *work);
 int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 				const u8 *ssid, u8 ssid_len,
 				struct ieee80211_channel **channels,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8dd3c10a99e0b..e00e1bf0f754a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -697,7 +697,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 	ieee80211_recalc_ps(local);
 
 	if (cancel_scan)
-		flush_delayed_work(&local->scan_work);
+		wiphy_delayed_work_flush(local->hw.wiphy, &local->scan_work);
 
 	if (local->open_count == 0) {
 		ieee80211_stop_device(local);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 444a0d6021f35..5422476eb1a1c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -334,9 +334,7 @@ static void ieee80211_restart_work(struct work_struct *work)
 	struct ieee80211_sub_if_data *sdata;
 	int ret;
 
-	/* wait for scan work complete */
 	flush_workqueue(local->workqueue);
-	flush_work(&local->sched_scan_stopped_work);
 
 	rtnl_lock();
 	/* we might do interface manipulations, so need both */
@@ -806,7 +804,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
 
-	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
+	wiphy_delayed_work_init(&local->scan_work, ieee80211_scan_work);
 
 	INIT_WORK(&local->restart_work, ieee80211_restart_work);
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index dc3cdee51e660..445b789e0e9bf 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -291,8 +291,8 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 		 * the beacon/proberesp rx gives us an opportunity to upgrade
 		 * to active scan
 		 */
-		 set_bit(SCAN_BEACON_DONE, &local->scanning);
-		 ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
+		set_bit(SCAN_BEACON_DONE, &local->scanning);
+		wiphy_delayed_work_queue(local->hw.wiphy, &local->scan_work, 0);
 	}
 
 	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
@@ -522,7 +522,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw,
 
 	memcpy(&local->scan_info, info, sizeof(*info));
 
-	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
+	wiphy_delayed_work_queue(local->hw.wiphy, &local->scan_work, 0);
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
@@ -562,8 +562,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local,
 	/* We need to set power level at maximum rate for scanning. */
 	ieee80211_hw_config(local, 0);
 
-	ieee80211_queue_delayed_work(&local->hw,
-				     &local->scan_work, 0);
+	wiphy_delayed_work_queue(local->hw.wiphy, &local->scan_work, 0);
 
 	return 0;
 }
@@ -620,8 +619,8 @@ void ieee80211_run_deferred_scan(struct ieee80211_local *local)
 					lockdep_is_held(&local->mtx))))
 		return;
 
-	ieee80211_queue_delayed_work(&local->hw, &local->scan_work,
-				     round_jiffies_relative(0));
+	wiphy_delayed_work_queue(local->hw.wiphy, &local->scan_work,
+				 round_jiffies_relative(0));
 }
 
 static void ieee80211_send_scan_probe_req(struct ieee80211_sub_if_data *sdata,
@@ -812,8 +811,8 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		}
 
 		/* Now, just wait a bit and we are all done! */
-		ieee80211_queue_delayed_work(&local->hw, &local->scan_work,
-					     next_delay);
+		wiphy_delayed_work_queue(local->hw.wiphy, &local->scan_work,
+					 next_delay);
 		return 0;
 	} else {
 		/* Do normal software scan */
@@ -1060,7 +1059,7 @@ static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 	local->next_scan_state = SCAN_SET_CHANNEL;
 }
 
-void ieee80211_scan_work(struct work_struct *work)
+void ieee80211_scan_work(struct wiphy *wiphy, struct wiphy_work *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, scan_work.work);
@@ -1154,7 +1153,8 @@ void ieee80211_scan_work(struct work_struct *work)
 		}
 	} while (next_delay == 0);
 
-	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, next_delay);
+	wiphy_delayed_work_queue(local->hw.wiphy, &local->scan_work,
+				 next_delay);
 	goto out;
 
 out_complete:
@@ -1297,12 +1297,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 		goto out;
 	}
 
-	/*
-	 * If the work is currently running, it must be blocked on
-	 * the mutex, but we'll set scan_sdata = NULL and it'll
-	 * simply exit once it acquires the mutex.
-	 */
-	cancel_delayed_work(&local->scan_work);
+	wiphy_delayed_work_cancel(local->hw.wiphy, &local->scan_work);
 	/* and clean up */
 	memset(&local->scan_info, 0, sizeof(local->scan_info));
 	__ieee80211_scan_completed(&local->hw, true);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 114956ef17fc3..1088d90e355ba 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2234,8 +2234,8 @@ static void ieee80211_flush_completed_scan(struct ieee80211_local *local,
 		 */
 		if (aborted)
 			set_bit(SCAN_ABORTED, &local->scanning);
-		ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
-		flush_delayed_work(&local->scan_work);
+		wiphy_delayed_work_queue(local->hw.wiphy, &local->scan_work, 0);
+		wiphy_delayed_work_flush(local->hw.wiphy, &local->scan_work);
 	}
 }
 
-- 
2.42.0



