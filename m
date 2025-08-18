Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D98A346A10;
	Mon, 18 Aug 2025 13:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525469; cv=none; b=J71RzoYiErvSXPepA3m5bDNgp7BUuHF2P4hjXWurRlKHvcpccBpBfwt07LUAzqTFMQqjOLFpdW4h23fRzXWPipqitHfAzp8+FDZR8e3dJn9b+ypbaWIVWXScMlUQ3L4ro+vMEjPPQQhSNkU7z9ppAzYm5Wp4AbYilFwfwV12oxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525469; c=relaxed/simple;
	bh=TeG7PFwNcuvBpKF2KOUQ4mEk/yvWJCpaMrwu39PTcUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVocgkNJyJV9t3KkrMk/VSaElqVi7pHT3TsYwGlrkhiLYeU9nwp3hmX9GbtqcI47OuCAiGGyMew/4M8M6Y1f7j/S/oNrQmP7Uyps6aN4MFdAMBCnemDpcL2pVkb9XMxnknW35KxAq5SDOVwZsTsaLrNJwAwyf3ihDMDEoY3EYu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UT3rAmqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UT3rAmqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AF5C4CEEB;
	Mon, 18 Aug 2025 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525469;
	bh=TeG7PFwNcuvBpKF2KOUQ4mEk/yvWJCpaMrwu39PTcUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UT3rAmqmsE5u3WgMQvWY5q6SeqQ42gZR8YlIrFvpCtd4Yis7CATACls0a4NycQgTo
	 6QGc1prO99Mn8Mli49WXn434meXsTWuZLIJK6ufemttD00pafMOGm0FDxngSEnJQDC
	 bwvUOmE1HS+5vsgyfXhvEej0lQgGqfHv38IZc42E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 241/570] wifi: mac80211: handle WLAN_HT_ACTION_NOTIFY_CHANWIDTH async
Date: Mon, 18 Aug 2025 14:43:48 +0200
Message-ID: <20250818124515.103707882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 93370f2d37f50757a810da409efc0223c342527e ]

If this action frame, with the value of IEEE80211_HT_CHANWIDTH_ANY,
arrives right after a beacon that changed the operational bandwidth from
20 MHz to 40 MHz, then updating the rate control bandwidth to 40 can
race with updating the chanctx width (that happens in the beacon
proccesing) back to 40 MHz:

cpu0					cpu1

ieee80211_rx_mgmt_beacon
ieee80211_config_bw
ieee80211_link_change_chanreq
(*)ieee80211_link_update_chanreq
					ieee80211_rx_h_action
					(**)ieee80211_sta_cur_vht_bw
(***) ieee80211_recalc_chanctx_chantype

in (**), the maximum between the capability width and the bss width is
returned. But the bss width was just updated to 40 in (*),
so the action frame handling code will increase the width of the rate
control before the chanctx was increased (in ***), leading to a FW error
(at least in iwlwifi driver. But this is wrong regardless).

Fix this by simply handling the action frame async, so it won't race
with the beacon proccessing.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218632
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709233537.bb9dc6f36c35.I39782d6077424e075974c3bee4277761494a1527@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ht.c          | 40 +++++++++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |  6 ++++++
 net/mac80211/iface.c       | 29 +++++++++++++++++++++++++++
 net/mac80211/rx.c          | 35 ++++++---------------------------
 4 files changed, 80 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 32390d8a9d75..1c82a28b03de 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -9,7 +9,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
  * Copyright 2017	Intel Deutschland GmbH
- * Copyright(c) 2020-2024 Intel Corporation
+ * Copyright(c) 2020-2025 Intel Corporation
  */
 
 #include <linux/ieee80211.h>
@@ -603,3 +603,41 @@ void ieee80211_request_smps(struct ieee80211_vif *vif, unsigned int link_id,
 }
 /* this might change ... don't want non-open drivers using it */
 EXPORT_SYMBOL_GPL(ieee80211_request_smps);
+
+void ieee80211_ht_handle_chanwidth_notif(struct ieee80211_local *local,
+					 struct ieee80211_sub_if_data *sdata,
+					 struct sta_info *sta,
+					 struct link_sta_info *link_sta,
+					 u8 chanwidth, enum nl80211_band band)
+{
+	enum ieee80211_sta_rx_bandwidth max_bw, new_bw;
+	struct ieee80211_supported_band *sband;
+	struct sta_opmode_info sta_opmode = {};
+
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	if (chanwidth == IEEE80211_HT_CHANWIDTH_20MHZ)
+		max_bw = IEEE80211_STA_RX_BW_20;
+	else
+		max_bw = ieee80211_sta_cap_rx_bw(link_sta);
+
+	/* set cur_max_bandwidth and recalc sta bw */
+	link_sta->cur_max_bandwidth = max_bw;
+	new_bw = ieee80211_sta_cur_vht_bw(link_sta);
+
+	if (link_sta->pub->bandwidth == new_bw)
+		return;
+
+	link_sta->pub->bandwidth = new_bw;
+	sband = local->hw.wiphy->bands[band];
+	sta_opmode.bw =
+		ieee80211_sta_rx_bw_to_chan_width(link_sta);
+	sta_opmode.changed = STA_OPMODE_MAX_BW_CHANGED;
+
+	rate_control_rate_update(local, sband, link_sta,
+				 IEEE80211_RC_BW_CHANGED);
+	cfg80211_sta_opmode_change_notify(sdata->dev,
+					  sta->addr,
+					  &sta_opmode,
+					  GFP_KERNEL);
+}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f71d9eeb8abc..61439e6efdb7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2220,6 +2220,12 @@ u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs);
 enum nl80211_smps_mode
 ieee80211_smps_mode_to_smps_mode(enum ieee80211_smps_mode smps);
 
+void ieee80211_ht_handle_chanwidth_notif(struct ieee80211_local *local,
+					 struct ieee80211_sub_if_data *sdata,
+					 struct sta_info *sta,
+					 struct link_sta_info *link_sta,
+					 u8 chanwidth, enum nl80211_band band);
+
 /* VHT */
 void
 ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c01634fdba78..851d399fca13 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1556,6 +1556,35 @@ static void ieee80211_iface_process_skb(struct ieee80211_local *local,
 				break;
 			}
 		}
+	} else if (ieee80211_is_action(mgmt->frame_control) &&
+		   mgmt->u.action.category == WLAN_CATEGORY_HT) {
+		switch (mgmt->u.action.u.ht_smps.action) {
+		case WLAN_HT_ACTION_NOTIFY_CHANWIDTH: {
+			u8 chanwidth = mgmt->u.action.u.ht_notify_cw.chanwidth;
+			struct ieee80211_rx_status *status;
+			struct link_sta_info *link_sta;
+			struct sta_info *sta;
+
+			sta = sta_info_get_bss(sdata, mgmt->sa);
+			if (!sta)
+				break;
+
+			status = IEEE80211_SKB_RXCB(skb);
+			if (!status->link_valid)
+				link_sta = &sta->deflink;
+			else
+				link_sta = rcu_dereference_protected(sta->link[status->link_id],
+							lockdep_is_held(&local->hw.wiphy->mtx));
+			if (link_sta)
+				ieee80211_ht_handle_chanwidth_notif(local, sdata, sta,
+								    link_sta, chanwidth,
+								    status->band);
+			break;
+		}
+		default:
+			WARN_ON(1);
+			break;
+		}
 	} else if (ieee80211_is_action(mgmt->frame_control) &&
 		   mgmt->u.action.category == WLAN_CATEGORY_VHT) {
 		switch (mgmt->u.action.u.vht_group_notif.action_code) {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e73431549ce7..8ec06cf0a9f0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3576,41 +3576,18 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			goto handled;
 		}
 		case WLAN_HT_ACTION_NOTIFY_CHANWIDTH: {
-			struct ieee80211_supported_band *sband;
 			u8 chanwidth = mgmt->u.action.u.ht_notify_cw.chanwidth;
-			enum ieee80211_sta_rx_bandwidth max_bw, new_bw;
-			struct sta_opmode_info sta_opmode = {};
+
+			if (chanwidth != IEEE80211_HT_CHANWIDTH_20MHZ &&
+			    chanwidth != IEEE80211_HT_CHANWIDTH_ANY)
+				goto invalid;
 
 			/* If it doesn't support 40 MHz it can't change ... */
 			if (!(rx->link_sta->pub->ht_cap.cap &
-					IEEE80211_HT_CAP_SUP_WIDTH_20_40))
-				goto handled;
-
-			if (chanwidth == IEEE80211_HT_CHANWIDTH_20MHZ)
-				max_bw = IEEE80211_STA_RX_BW_20;
-			else
-				max_bw = ieee80211_sta_cap_rx_bw(rx->link_sta);
-
-			/* set cur_max_bandwidth and recalc sta bw */
-			rx->link_sta->cur_max_bandwidth = max_bw;
-			new_bw = ieee80211_sta_cur_vht_bw(rx->link_sta);
-
-			if (rx->link_sta->pub->bandwidth == new_bw)
+				IEEE80211_HT_CAP_SUP_WIDTH_20_40))
 				goto handled;
 
-			rx->link_sta->pub->bandwidth = new_bw;
-			sband = rx->local->hw.wiphy->bands[status->band];
-			sta_opmode.bw =
-				ieee80211_sta_rx_bw_to_chan_width(rx->link_sta);
-			sta_opmode.changed = STA_OPMODE_MAX_BW_CHANGED;
-
-			rate_control_rate_update(local, sband, rx->link_sta,
-						 IEEE80211_RC_BW_CHANGED);
-			cfg80211_sta_opmode_change_notify(sdata->dev,
-							  rx->sta->addr,
-							  &sta_opmode,
-							  GFP_ATOMIC);
-			goto handled;
+			goto queue;
 		}
 		default:
 			goto invalid;
-- 
2.39.5



