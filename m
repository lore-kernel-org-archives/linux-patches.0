Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8702BDDC1;
	Tue, 27 Aug 2024 14:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770083; cv=none; b=sKQLGKijlbFlRmFf9w4gPo1zUwBfUHrdCOjlJRmr4OZbCuoYgdqdlHyKRICN0rC6M5IydkqV1g+iRtHEwkl02zURRyTXb2/ULnygEhquF2OUNUf2WSP3sXm2WDUzdPoXeHN85EyYq8w7/eTfuTn9BrpaUAtL7pmIwvqLiPAuCeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770083; c=relaxed/simple;
	bh=DblUwTZHduc8GMlU2FnAzJ+vw18ThkAkRj+AKztI75w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndFTmRFXe6EICvi6wtfzX8d8R9qmbGQDzDd2JmiR2++hA53SLTobGy17CiueTmQ92UlZ75rgbt37zJYmKeRiu5IwXATiPh45XUPApcsPDcHZ9nIuwyM06DAJOCFMi35F1CQKn78X+Lq/hJbtNlCHb80QEW1OJ4Rwphb1Grq9v2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMGBV6Yd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMGBV6Yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CA3C61046;
	Tue, 27 Aug 2024 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770083;
	bh=DblUwTZHduc8GMlU2FnAzJ+vw18ThkAkRj+AKztI75w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMGBV6YdyJvWNFxuhEVFrgvcYnb5v8tA9Ca9aK6TaZ56FlmJwI0wEzNlow1haQdBC
	 SrbvqaDeQAU/RamVzW92bKlrRUfvuXuTdk6pJhWCms5kMpVFozOClvjamBSsf/vv3i
	 007QUrbBuTJiJynODULGbACNOMIJB9g4uWPJmgB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/341] wifi: mac80211: fix BA session teardown race
Date: Tue, 27 Aug 2024 16:35:21 +0200
Message-ID: <20240827143846.831832636@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index b6b7726858815..0a69e47f1c55f 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -497,7 +497,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_ampdu_params params = {
 		.sta = &sta->sta,
 		.action = IEEE80211_AMPDU_TX_START,
@@ -525,7 +525,6 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	 */
 	synchronize_net();
 
-	sdata = sta->sdata;
 	params.ssn = sta->tid_seq[tid] >> 4;
 	ret = drv_ampdu_action(local, sdata, &params);
 	tid_tx->ssn = params.ssn;
@@ -539,9 +538,6 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
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
index f8af0c3d405ae..d6478fd00badf 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -393,9 +393,6 @@ int drv_ampdu_action(struct ieee80211_local *local,
 
 	might_sleep();
 
-	if (!sdata)
-		return -EIO;
-
 	sdata = get_bss_sdata(sdata);
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 984f8f67492fd..42ba51a9700f2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1402,6 +1402,20 @@ static void __sta_info_destroy_part2(struct sta_info *sta, bool recalc)
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



