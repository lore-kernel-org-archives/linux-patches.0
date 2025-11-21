Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247EC347FF8;
	Fri, 21 Nov 2025 13:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732097; cv=none; b=FF9QTUUoZeDw8jr4dejS38Td6LRCSvHm/uiGxHyFrDoMX4DcOf92xL8Gi1gYAsPm46hXIejCgI/3jOJfDt8DucL5LBXsO9sQ0zMAgb8PPVU7tjf5iNkeFeqRDA0A3VSmiirpKVnbL15c7dIYatLHWCiRrQcIabxNUbJNzdbSwso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732097; c=relaxed/simple;
	bh=Nu90l/Xvknv2cAdw24KctsDztaG6/vGGSS4JZXV6boE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g08SQ8efhha7s/aKyyoMYvmv6qbo60VEuJq+lSZfkZFCVEIIVWRhiiIFiD6uabia/YTbxClTSCLHGtctfcTxkFjzyuqSDnsI8H2n2PQ5e3UFm8hpurFhxPIE+r3PuDhNIPiLeImkSpO1XfKzzqDhbgeZLzTCdXktFwvwU822nSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2G2SIBtS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2G2SIBtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D0BC4CEF1;
	Fri, 21 Nov 2025 13:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732097;
	bh=Nu90l/Xvknv2cAdw24KctsDztaG6/vGGSS4JZXV6boE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2G2SIBtSxZo1H7TMCHnP5A5ZQlF1SwSj2kGWevu6vVn3PrvV+ZU6THDMKWOuOQ3ay
	 ZAGSZYdBo9y1uaDdSx4YmMKnDSkVFXSh7TFpoQQmUXcz+hdMvLyr4SnsL9X+4IzW/5
	 ny/zW6Xj4iIecdKb1/lhIC8iUdeQtgtHPpZE1G/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/185] wifi: mac80211: use wiphy_hrtimer_work for csa.switch_work
Date: Fri, 21 Nov 2025 14:13:08 +0100
Message-ID: <20251121130149.685452846@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit fbc1cc6973099f45e4c30b86f12b4435c7cb7d24 ]

The work item may be scheduled relatively far in the future. As the
event happens at a specific point in time, the normal timer accuracy is
not sufficient in that case.

Switch to use wiphy_hrtimer_work so that the accuracy is sufficient. To
make this work, use the same clock to store the timestamp.

CC: stable@vger.kernel.org
Fixes: ec3252bff7b6 ("wifi: mac80211: use wiphy work for channel switch")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251028125710.68258c7e4ac4.I4ff2b2cdffbbf858bf5f08baccc7a88c4f9efe6f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/chan.c        |    2 +-
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/link.c        |    4 ++--
 net/mac80211/mlme.c        |   18 +++++++++---------
 4 files changed, 14 insertions(+), 14 deletions(-)

--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1246,7 +1246,7 @@ ieee80211_link_chanctx_reservation_compl
 				 &link->csa.finalize_work);
 		break;
 	case NL80211_IFTYPE_STATION:
-		wiphy_delayed_work_queue(sdata->local->hw.wiphy,
+		wiphy_hrtimer_work_queue(sdata->local->hw.wiphy,
 					 &link->u.mgd.csa.switch_work, 0);
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -981,10 +981,10 @@ struct ieee80211_link_data_managed {
 	bool operating_11g_mode;
 
 	struct {
-		struct wiphy_delayed_work switch_work;
+		struct wiphy_hrtimer_work switch_work;
 		struct cfg80211_chan_def ap_chandef;
 		struct ieee80211_parsed_tpe tpe;
-		unsigned long time;
+		ktime_t time;
 		bool waiting_bcn;
 		bool ignored_same_chan;
 		bool blocked_tx;
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -469,10 +469,10 @@ static int _ieee80211_set_active_links(s
 		 * from there.
 		 */
 		if (link->conf->csa_active)
-			wiphy_delayed_work_queue(local->hw.wiphy,
+			wiphy_hrtimer_work_queue(local->hw.wiphy,
 						 &link->u.mgd.csa.switch_work,
 						 link->u.mgd.csa.time -
-						 jiffies);
+						 ktime_get_boottime());
 	}
 
 	list_for_each_entry(sta, &local->sta_list, list) {
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2225,7 +2225,7 @@ void ieee80211_chswitch_done(struct ieee
 			return;
 		}
 
-		wiphy_delayed_work_queue(sdata->local->hw.wiphy,
+		wiphy_hrtimer_work_queue(sdata->local->hw.wiphy,
 					 &link->u.mgd.csa.switch_work, 0);
 	}
 
@@ -2384,7 +2384,8 @@ ieee80211_sta_process_chanswitch(struct
 		.timestamp = timestamp,
 		.device_timestamp = device_timestamp,
 	};
-	unsigned long now;
+	u32 csa_time_tu;
+	ktime_t now;
 	int res;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
@@ -2614,10 +2615,9 @@ ieee80211_sta_process_chanswitch(struct
 					  csa_ie.mode);
 
 	/* we may have to handle timeout for deactivated link in software */
-	now = jiffies;
-	link->u.mgd.csa.time = now +
-			       TU_TO_JIFFIES((max_t(int, csa_ie.count, 1) - 1) *
-					     link->conf->beacon_int);
+	now = ktime_get_boottime();
+	csa_time_tu = (max_t(int, csa_ie.count, 1) - 1) * link->conf->beacon_int;
+	link->u.mgd.csa.time = now + ns_to_ktime(ieee80211_tu_to_usec(csa_time_tu) * NSEC_PER_USEC);
 
 	if (ieee80211_vif_link_active(&sdata->vif, link->link_id) &&
 	    local->ops->channel_switch) {
@@ -2632,7 +2632,7 @@ ieee80211_sta_process_chanswitch(struct
 	}
 
 	/* channel switch handled in software */
-	wiphy_delayed_work_queue(local->hw.wiphy,
+	wiphy_hrtimer_work_queue(local->hw.wiphy,
 				 &link->u.mgd.csa.switch_work,
 				 link->u.mgd.csa.time - now);
 	return;
@@ -8137,7 +8137,7 @@ void ieee80211_mgd_setup_link(struct iee
 	else
 		link->u.mgd.req_smps = IEEE80211_SMPS_OFF;
 
-	wiphy_delayed_work_init(&link->u.mgd.csa.switch_work,
+	wiphy_hrtimer_work_init(&link->u.mgd.csa.switch_work,
 				ieee80211_csa_switch_work);
 
 	ieee80211_clear_tpe(&link->conf->tpe);
@@ -9267,7 +9267,7 @@ void ieee80211_mgd_stop_link(struct ieee
 			  &link->u.mgd.request_smps_work);
 	wiphy_work_cancel(link->sdata->local->hw.wiphy,
 			  &link->u.mgd.recalc_smps);
-	wiphy_delayed_work_cancel(link->sdata->local->hw.wiphy,
+	wiphy_hrtimer_work_cancel(link->sdata->local->hw.wiphy,
 				  &link->u.mgd.csa.switch_work);
 }
 


