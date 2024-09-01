Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C940F44C93;
	Sun,  1 Sep 2024 16:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209524; cv=none; b=hb/nHPeLHpvXfXJOZEE/fJY7/q3edtk96Uc29W7tF0N22gW54R0Q4ajRDZiM6zBRAZo78+eyTaNYLMu+nFU5v8NfcFcuI/SXk9CBoqmhKYSDbDeaZsvauJVek6HKlY3opiW6+EA56xnnNtUSE5ivBtAnjVkXiUM1DYGkAxKv7xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209524; c=relaxed/simple;
	bh=hxupyxXBWGMuJfLaNd3Mfxi5ZpoSRkEw0rrc/Eixwzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQH5J3d2EJTZl7aHoqWxwJxzSZIHCm3tOo6PRGxvCXT3QLPkKts2kIxgFXagpi5f9N1wk4hP0YlZ/bKP8H0rTLZxYJwYDa4nv/AvUsUlowcvlcJLeLMr7/DIrsc7EbMrQ5hEIXlWptSw/wyT3TY5Jkn1PFLjVnGtdIRJH2rs0AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChmRgqsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChmRgqsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E636C4CEC3;
	Sun,  1 Sep 2024 16:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209524;
	bh=hxupyxXBWGMuJfLaNd3Mfxi5ZpoSRkEw0rrc/Eixwzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChmRgqsJcLyEsXyQ5ydLFD6yFl53lb0HKCHn1uhKbpHhrCU4HAQ2yQVSYSQ5Wfnwz
	 AWoF3m2fnOC0Gx9FJmifQv0A7KYYyiJslES+QWLrEurwrTqBt0UR7uM7jiG5CNJKEX
	 rCigXNRrd4yi/Qxq/yloOUROkg74KgLi1VDtwYqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/151] wifi: mac80211: fix BA session teardown race
Date: Sun,  1 Sep 2024 18:16:32 +0200
Message-ID: <20240901160815.309089706@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 92e5812daf892..4b4ab1961068f 100644
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
index f7637176d719d..3bb7a3314788e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1064,6 +1064,20 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
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



