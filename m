Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532C81FA82E;
	Tue, 12 Nov 2024 10:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407922; cv=none; b=JrSK+tctvgNxAn2ebBZA37+MGijit9I8W0N7ywXjfC+rG0e3JzjJOxCVakO2bUC/ckXk7jkJ1LIm9pBCRm11WXxkgu62cxtnjqPAid2MbpQd7TRshV7KA4M5WKx5G75hxXA8J4StgoQf9ybc2M1pi4JixKV0YCd7oHpTM2X7C3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407922; c=relaxed/simple;
	bh=FXud2FAT/XCFtPhKxPvffYzoBYGI/jS24rBrqQZIRHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY8nrZrAdj2C6D3jy8IC0Oaa7jsNoHlBDfrdm5/EC59zUSB6hP4p1IaPHOzo60vvr2ac+Ves73lNE3tanwXuYkL2rkVWy4ctsUO6WPno2rUeMau5vOMFZ7uTPjVbB3ww7I9kueVDy8EwtSKOOeLOmuDm5+XpOFKDOU9eZA4Z5/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQcQuz5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQcQuz5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AF5C4CECD;
	Tue, 12 Nov 2024 10:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407922;
	bh=FXud2FAT/XCFtPhKxPvffYzoBYGI/jS24rBrqQZIRHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQcQuz5E4uz4Z7OG+N4aC96PlYxbL2SB/i5XfOcEma/EIeMV2uR1Rnw4KM5pFZCB3
	 wW9WOjBHA9VV1E1hNxJbuKgb1Dq98dSZlI0syOe4q+DOqIPUpVjMevWeuwARCHX5or
	 NaYH/LERmCKAp228M603vrliE1TKxQ4Y58DEr5+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.6 099/119] Revert "wifi: mac80211: fix RCU list iterations"
Date: Tue, 12 Nov 2024 11:21:47 +0100
Message-ID: <20241112101852.504933955@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f37319609335d3eb2f7edfec4bad7996668a4d29 which is
commit ac35180032fbc5d80b29af00ba4881815ceefcb6 upstream.

It should not have been backported here due to lack of other rcu
changes in the stable branches.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/chan.c |    4 +---
 net/mac80211/mlme.c |    2 +-
 net/mac80211/scan.c |    2 +-
 net/mac80211/util.c |    4 +---
 4 files changed, 4 insertions(+), 8 deletions(-)

--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -245,9 +245,7 @@ ieee80211_get_max_required_bw(struct iee
 	enum nl80211_chan_width max_bw = NL80211_CHAN_WIDTH_20_NOHT;
 	struct sta_info *sta;
 
-	lockdep_assert_wiphy(sdata->local->hw.wiphy);
-
-	list_for_each_entry(sta, &sdata->local->sta_list, list) {
+	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
 		if (sdata != sta->sdata &&
 		    !(sta->sdata->bss && sta->sdata->bss == sdata->bss))
 			continue;
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -732,7 +732,7 @@ static bool ieee80211_add_vht_ie(struct
 		bool disable_mu_mimo = false;
 		struct ieee80211_sub_if_data *other;
 
-		list_for_each_entry(other, &local->interfaces, list) {
+		list_for_each_entry_rcu(other, &local->interfaces, list) {
 			if (other->vif.bss_conf.mu_mimo_owner) {
 				disable_mu_mimo = true;
 				break;
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -490,7 +490,7 @@ static void __ieee80211_scan_completed(s
 	 * the scan was in progress; if there was none this will
 	 * just be a no-op for the particular interface.
 	 */
-	list_for_each_entry(sdata, &local->interfaces, list) {
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (ieee80211_sdata_running(sdata))
 			wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 	}
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -745,9 +745,7 @@ static void __iterate_interfaces(struct
 	struct ieee80211_sub_if_data *sdata;
 	bool active_only = iter_flags & IEEE80211_IFACE_ITER_ACTIVE;
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list,
-				lockdep_is_held(&local->iflist_mtx) ||
-				lockdep_is_held(&local->hw.wiphy->mtx)) {
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_MONITOR:
 			if (!(sdata->u.mntr.flags & MONITOR_FLAG_ACTIVE))


