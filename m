Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BBE44C93;
	Sun,  1 Sep 2024 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209957; cv=none; b=lS/lkY0IPIYoFSoCc8mjla/yNB5v1hSMUjbVyZ2PQ8CKJv4roocDs9z1oPL71GFobn7RbclFqmHnL2jTRNO+c8SVkQfqCMUEzUW0qk+xIlYazcNIWanIXDtmzXYBFZi96KJ1Dfg9lbCay0W2Lz3fl2stkTXA74etiQ9YwMwYmsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209957; c=relaxed/simple;
	bh=XQYxFLuai91vNy+43f7keGRDyK+QL8GvTKj4s5jI8oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BL/uP/APryDdGF/uwQ715xCPcX2vkKZbRT9XP63TANUZ4mfG1LLfRj+vUI32FwkN5t2yDo1i4rCqzn+XA5iZeO49limw0Ykm7J0Dh02tFtdzMZx2+zqCNKlsRLIovqdWTPVMkoyUffokWqw1dF/cADrwF9U3/WzpH3+jyjRNq9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qCdU08R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qCdU08R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B03C4CEC3;
	Sun,  1 Sep 2024 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209957;
	bh=XQYxFLuai91vNy+43f7keGRDyK+QL8GvTKj4s5jI8oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qCdU08RiXUa14w6loKvSSmvCotvp54nJztSrOnSIfCcNZE8j4vNsAfnqxG8mpGhy
	 fKpcquxmMDX/7vDVfrIDPH1fdfKH0MfTWksPFZqdNd98VVWXCWg7ac8yAOkYNERLQL
	 JWLuOEDKLIo4W93cd5+A6RL7A8O6vhlxeU9Pac34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/215] wifi: mac80211: fix BA session teardown race
Date: Sun,  1 Sep 2024 18:15:57 +0200
Message-ID: <20240901160825.052765002@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a4d3fa14f76b7..1deb3d874a4b9 100644
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
@@ -521,7 +521,6 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	 */
 	synchronize_net();
 
-	sdata = sta->sdata;
 	params.ssn = sta->tid_seq[tid] >> 4;
 	ret = drv_ampdu_action(local, sdata, &params);
 	tid_tx->ssn = params.ssn;
@@ -535,9 +534,6 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
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
index 120bd9cdf7dfa..48322e45e7ddb 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -331,9 +331,6 @@ int drv_ampdu_action(struct ieee80211_local *local,
 
 	might_sleep();
 
-	if (!sdata)
-		return -EIO;
-
 	sdata = get_bss_sdata(sdata);
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6d2b42cb3ad58..d1460b870ed5a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1060,6 +1060,20 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
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



