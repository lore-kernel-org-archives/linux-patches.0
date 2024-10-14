Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284791B4F13;
	Mon, 14 Oct 2024 15:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918877; cv=none; b=V5oNplHni7dPN3d0v9Z+CRski27uQxGqzz9+pVqorOTTHYy7/5bXHYPo9iPryYjgLpNdmfi+w924WyKtXL80Vp4f+RDyOg/VGQ52JjhT5bPs7oN49PkVeHnhYx9MjYkxzl0PdlrpPxNEITttWs3oqWD883aISYHWFmPwqDdCzgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918877; c=relaxed/simple;
	bh=3ck/PWUkg/xlMbfxQlkO+7NWJ5W/jVs1kjsw3UGwLz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqCb+vXC8+bLjkjftrZiE03NCJZI4mR5IjY2/Lcb7T4mBJbLuMyQOIB8t+5D2GRsOI0buBsfiMBKNE6uZ93f2Esq8gAWFa0/xeqqjrqCbcx446GzPESUnBxijo0200iKhaRVXqpBeKYFWkKZVL+wKh5yIjQWr4SvBdkTO6eSZkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sigKFxvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sigKFxvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1A9C4CEC3;
	Mon, 14 Oct 2024 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918877;
	bh=3ck/PWUkg/xlMbfxQlkO+7NWJ5W/jVs1kjsw3UGwLz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sigKFxvkcGhcr2GGEkGIXKtFatOBGJ6hgce1s/lHfivLZthFNW9IIUthx5+WZzNiE
	 8iPM0OkwM5IXcLrfhiajAPzJOJspFq3UZ7d3v4viIRIvzNJitkrp7wS0sNU1XER1Ca
	 Uk6SILerJ75S0fw68k+O1n8mKWcWhP2HX/HkKW2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 448/798] wifi: mac80211: fix RCU list iterations
Date: Mon, 14 Oct 2024 16:16:42 +0200
Message-ID: <20241014141235.571438457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

[ Upstream commit ac35180032fbc5d80b29af00ba4881815ceefcb6 ]

There are a number of places where RCU list iteration is
used, but that aren't (always) called with RCU held. Use
just list_for_each_entry() in most, and annotate iface
iteration with the required locks.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240827094939.ed8ac0b2f897.I8443c9c3c0f8051841353491dae758021b53115e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 4 +++-
 net/mac80211/mlme.c | 2 +-
 net/mac80211/scan.c | 2 +-
 net/mac80211/util.c | 4 +++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f07e34bed8f3a..807bea1a7d3c1 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -245,7 +245,9 @@ ieee80211_get_max_required_bw(struct ieee80211_sub_if_data *sdata,
 	enum nl80211_chan_width max_bw = NL80211_CHAN_WIDTH_20_NOHT;
 	struct sta_info *sta;
 
-	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
+	lockdep_assert_wiphy(sdata->local->hw.wiphy);
+
+	list_for_each_entry(sta, &sdata->local->sta_list, list) {
 		if (sdata != sta->sdata &&
 		    !(sta->sdata->bss && sta->sdata->bss == sdata->bss))
 			continue;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9a5530ca2f6b2..ee9ec74b9553f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -660,7 +660,7 @@ static bool ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 		bool disable_mu_mimo = false;
 		struct ieee80211_sub_if_data *other;
 
-		list_for_each_entry_rcu(other, &local->interfaces, list) {
+		list_for_each_entry(other, &local->interfaces, list) {
 			if (other->vif.bss_conf.mu_mimo_owner) {
 				disable_mu_mimo = true;
 				break;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 6432dd3ec2a7e..0a6e40bd42f62 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -500,7 +500,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	 * the scan was in progress; if there was none this will
 	 * just be a no-op for the particular interface.
 	 */
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 738f1f139a90e..3fe15089b24f5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -767,7 +767,9 @@ static void __iterate_interfaces(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
 	bool active_only = iter_flags & IEEE80211_IFACE_ITER_ACTIVE;
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	list_for_each_entry_rcu(sdata, &local->interfaces, list,
+				lockdep_is_held(&local->iflist_mtx) ||
+				lockdep_is_held(&local->hw.wiphy->mtx)) {
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_MONITOR:
 			if (!(sdata->u.mntr.flags & MONITOR_FLAG_ACTIVE))
-- 
2.43.0



