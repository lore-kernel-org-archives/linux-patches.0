Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D6719E992;
	Tue, 12 Nov 2024 10:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407519; cv=none; b=KSgb/6Tc2LHoSAQf5weskHvSmw0iGzadC9emrFrwnuBUauOeVaPw6roNo5zQNAPG5gry+qTDdR2mzGKwE8WdHr4fZCcxqStx8/uSlRnHAiIrbSVcoHDM6MlXCsBiDsYS5F3XMkkTsjNRGg4GlVePoAPGUaXoum6dH+EhTY/te+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407519; c=relaxed/simple;
	bh=edGDVbMNfyaARbh6pJlGGTkQD7hNoOL4x1CxjORzN3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urwQ/OiJJxcN6DB9JaVUfvlmqTSbEHkGSUyFoBLm5kzimnVZ3y4OoW6VQNHfM1NqlEzlpkUK+gZxsQ7YZyH7qUDjskVNGgyc5e98/qa7TxWbspOU7cb9I/iH1CrHsbIfsa3KjugyApWGUCyGmeEIZzLFFTywgBQRNAk937IaFMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEUkvOnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEUkvOnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDAAC4CED4;
	Tue, 12 Nov 2024 10:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407519;
	bh=edGDVbMNfyaARbh6pJlGGTkQD7hNoOL4x1CxjORzN3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEUkvOnlAu0p0x1vbI39NcxjpRqI1QUS4+5BhuilnJ135uzBKrtviCbOBOX8g1Daq
	 Cv18LgaOqkSdOOlfISAGaSv8h3oml9dq22X2P0V32W5iQng1JzXbAcXPGMtH8Whp/O
	 rCfQeZa+nJRucpS8OooElTcY82jSrJy6ImrFwsxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.1 77/98] Revert "wifi: mac80211: fix RCU list iterations"
Date: Tue, 12 Nov 2024 11:21:32 +0100
Message-ID: <20241112101847.188215210@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b0b2dc1eaa7ec509e07a78c9974097168ae565b7 which is
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
@@ -660,7 +660,7 @@ static bool ieee80211_add_vht_ie(struct
 		bool disable_mu_mimo = false;
 		struct ieee80211_sub_if_data *other;
 
-		list_for_each_entry(other, &local->interfaces, list) {
+		list_for_each_entry_rcu(other, &local->interfaces, list) {
 			if (other->vif.bss_conf.mu_mimo_owner) {
 				disable_mu_mimo = true;
 				break;
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -501,7 +501,7 @@ static void __ieee80211_scan_completed(s
 	 * the scan was in progress; if there was none this will
 	 * just be a no-op for the particular interface.
 	 */
-	list_for_each_entry(sdata, &local->interfaces, list) {
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 	}
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -767,9 +767,7 @@ static void __iterate_interfaces(struct
 	struct ieee80211_sub_if_data *sdata;
 	bool active_only = iter_flags & IEEE80211_IFACE_ITER_ACTIVE;
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list,
-				lockdep_is_held(&local->iflist_mtx) ||
-				lockdep_is_held(&local->hw.wiphy->mtx)) {
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_MONITOR:
 			if (!(sdata->u.mntr.flags & MONITOR_FLAG_ACTIVE))


