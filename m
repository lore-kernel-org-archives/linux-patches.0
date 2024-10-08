Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7418190663;
	Tue,  8 Oct 2024 12:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391618; cv=none; b=c4XgXkO+tBJZUC+XhGJYRe1m54mFN1FKYlO6dl2QzGsGmRePEZrQxgDTXUY1+Gi/iaH10BbJEzhouzCVZzmG3QPZMvdsontZhGYV2vJadgy3xYH8mEQyjgCK137rzMuc54hqWeoZVKIvlvLNqyibDUXcuYC68ztU8w4hBNlO3Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391618; c=relaxed/simple;
	bh=voFCx4y818NJHMs846tmZyabcGIuJH9O7VPqNA+5f7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlOUE2UhpvZ/6rBL9tvkMl9gMjNzs8Qt9qcG3fDjpXozKVFL9ccuj01ukF/nqIsFAe4FSArxsk/6IxMlK/3bO2CQ8UOBSbwvZR/nc1i7KFzmgVCKU/3ZJOGu0Bh8LXnnKTeFMi2X4tZGMRwOQyoJOQY60ixX57btN82tiCtNTN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0Hw8cg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0Hw8cg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F570C4CEC7;
	Tue,  8 Oct 2024 12:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391618;
	bh=voFCx4y818NJHMs846tmZyabcGIuJH9O7VPqNA+5f7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0Hw8cg/ekzvBQ9Rv5/SJvZ5qBnef/jpsl2WzbAseuCgw/L/bqfe0e7X/7v+7jl+P
	 M8+ZVQGcaipDBLvBnJu3yjBDXYiUMhPuEzLt/ftlUGOXINVLGgQQ8BYSjGpc6q7eMr
	 F/pKpary10pPo4/SJEuLx6AIDKlKlci8Z++ZZOeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 141/558] wifi: mac80211: fix RCU list iterations
Date: Tue,  8 Oct 2024 14:02:51 +0200
Message-ID: <20241008115707.913400658@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index e8567723e94d5..b72e4036526bf 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -286,7 +286,9 @@ ieee80211_get_max_required_bw(struct ieee80211_link_data *link)
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
index 9e3d2ed9cf678..746f51ac03068 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1231,7 +1231,7 @@ static bool ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 		bool disable_mu_mimo = false;
 		struct ieee80211_sub_if_data *other;
 
-		list_for_each_entry_rcu(other, &local->interfaces, list) {
+		list_for_each_entry(other, &local->interfaces, list) {
 			if (other->vif.bss_conf.mu_mimo_owner) {
 				disable_mu_mimo = true;
 				break;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 1c5d99975ad04..3b2bde6360bcb 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -504,7 +504,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	 * the scan was in progress; if there was none this will
 	 * just be a no-op for the particular interface.
 	 */
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (ieee80211_sdata_running(sdata))
 			wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c7ad9bc5973a0..aed72794d9fe3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -751,7 +751,9 @@ static void __iterate_interfaces(struct ieee80211_local *local,
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



