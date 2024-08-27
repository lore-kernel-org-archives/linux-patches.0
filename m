Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34CF17C96;
	Tue, 27 Aug 2024 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772099; cv=none; b=CjnbIPQSXzD1hQS0LZrr3ZR+R43KjdSxai3mpzX/64q43bZw7px8wY/QtlCdQNgqRpVg3h1oHYgGravxtT45D6yaScv/IC8S4AKnhAYpu1YsFqvSItqq/IKhdwIyfVVX+8Hzp1iNPyDIPBDbB2wQH6k7awydCuL1oeN3MgmAwE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772099; c=relaxed/simple;
	bh=vZsfaJgcDImUxgkTURYwtKL9urcI2VvRF7+swmZKW30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzqyC+WZpAnvMgPoAkNJ3ONAtkNFBbqPOUkE46CYxUOE3x27HMmmITJmKEwQorFQmUuX+Mtchu0E3MJvjaHQCV8WcBHmQNs/u6i/qzga4BuWMptIiyXDFa0NHramnn5q7ZzSOSAj+GVeWZNJvXhCaDGBmrnHvgr8Gcj5LK84Wek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x56nXLw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x56nXLw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376F8C4FE09;
	Tue, 27 Aug 2024 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772099;
	bh=vZsfaJgcDImUxgkTURYwtKL9urcI2VvRF7+swmZKW30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x56nXLw9synZItD20Uu/QKEeGB3n/TYKk76SCwVQole0u2g7AC7FCwBdxmIBOT6EE
	 RIvgy54VAPTyjNSiTPb71c1fm4INfkiEiEc9ZpuTulsBnRSmu+K5XEQgeXzQbMyqC/
	 qjEaIkNJTqtLu57zsq24xTBiIFEud0PVy1ZflUKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/321] wifi: mac80211: fix BA session teardown race
Date: Tue, 27 Aug 2024 16:37:02 +0200
Message-ID: <20240827143842.584333698@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

[ Upstream commit 05f136220d17839eb7c155f015ace9152f603225 ]

As previously reported by Alexander, whose commit 69403bad97aa
("wifi: mac80211: sdata can be NULL during AMPDU start") I'm
reverting as part of this commit, there's a race between station
destruction and aggregation setup, where the aggregation setup
can happen while the station is being removed and queue the work
after ieee80211_sta_tear_down_BA_sessions() has already run in
__sta_info_destroy_part1(), and thus the worker will run with a
now freed station. In his case, this manifested in a NULL sdata
pointer, but really there's no guarantee whatsoever.

The real issue seems to be that it's possible at all to have a
situation where this occurs - we want to stop the BA sessions
when doing _part1, but we cannot be sure, and WLAN_STA_BLOCK_BA
isn't necessarily effective since we don't know that the setup
isn't concurrently running and already got past the check.

Simply call ieee80211_sta_tear_down_BA_sessions() again in the
second part of station destruction, since at that point really
nothing else can hold a reference to the station any more.

Also revert the sdata checks since those are just misleading at
this point.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-tx.c     |  6 +-----
 net/mac80211/driver-ops.c |  3 ---
 net/mac80211/sta_info.c   | 14 ++++++++++++++
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 85d2b9e4b51ce..e26a72f3a1042 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -491,7 +491,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_ampdu_params params = {
 		.sta = &sta->sta,
 		.action = IEEE80211_AMPDU_TX_START,
@@ -519,7 +519,6 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	 */
 	synchronize_net();
 
-	sdata = sta->sdata;
 	params.ssn = sta->tid_seq[tid] >> 4;
 	ret = drv_ampdu_action(local, sdata, &params);
 	tid_tx->ssn = params.ssn;
@@ -533,9 +532,6 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		 */
 		set_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state);
 	} else if (ret) {
-		if (!sdata)
-			return;
-
 		ht_dbg(sdata,
 		       "BA request denied - HW unavailable for %pM tid %d\n",
 		       sta->sta.addr, tid);
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index c08d3c9a4a177..5392ffa182704 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -391,9 +391,6 @@ int drv_ampdu_action(struct ieee80211_local *local,
 
 	might_sleep();
 
-	if (!sdata)
-		return -EIO;
-
 	sdata = get_bss_sdata(sdata);
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 91768abf2d75b..dd1864f6549f2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1272,6 +1272,20 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 	 *	 after _part1 and before _part2!
 	 */
 
+	/*
+	 * There's a potential race in _part1 where we set WLAN_STA_BLOCK_BA
+	 * but someone might have just gotten past a check, and not yet into
+	 * queuing the work/creating the data/etc.
+	 *
+	 * Do another round of destruction so that the worker is certainly
+	 * canceled before we later free the station.
+	 *
+	 * Since this is after synchronize_rcu()/synchronize_net() we're now
+	 * certain that nobody can actually hold a reference to the STA and
+	 * be calling e.g. ieee80211_start_tx_ba_session().
+	 */
+	ieee80211_sta_tear_down_BA_sessions(sta, AGG_STOP_DESTROY_STA);
+
 	might_sleep();
 	lockdep_assert_held(&local->sta_mtx);
 
-- 
2.43.0



