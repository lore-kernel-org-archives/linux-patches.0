Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6111051AFC6;
	Wed, 23 Sep 2026 14:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172849; cv=none; b=b3LlKIDAFwss+MtxQIb6CsvICOifzViEKbx1yo5edSzkV9AlXWNiyFzr7YUFfpNN8dXJ7xA5PG+BjK9b5aKmAsEBrLwXcbJFZzr5fN9DBfWg1ItdF/E3OTcAkz347jqpkqGXCEkk1bTxA70nJRCvjxqUvPsoVuWxhp6EhXRwZkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172849; c=relaxed/simple;
	bh=V4lNSSdckW9dhPKiZ5X/DWnqc/VlLuV0AcEKN1nFu4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tE6zRX/6UTiP+u/FZFjTahPU0eqaxOdgLKMMs3M3erRXItnd2zoQ4EWw2pBo4DzO0btTgNxsRdH0YoDjjIrOE0q1Kf8ZXT/lhkgk/IfqxCfHQ695142qIqWVtoaZab1TgxbjELQRGBvuIRI2LRcAVGzYa+cSVunwsiqku5SMCGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W73dnxSV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W73dnxSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B703B1F000FF;
	Wed, 23 Sep 2026 14:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172848;
	bh=W5wwqitPjDoEMPxXpwMUrMDegDpdUKqaqKE/kJxzBYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W73dnxSVsaFt4WbrEK55D3j6D5qUViJW37D4X0TMyBiLfSQA8ErrHyivOoYv4QM3M
	 /RsNaoaNez7rL1nbBxGMU+yhFDkO5oZXVMhHE1mbw96f82PhcI/sgHrKVwcrZ50rQX
	 DEsqDFd5FGiyWIwrixWohs8kSGbNpGZBEys6aVpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a59b5291776979816910@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 076/438] wifi: mac80211: only operate on TDLS peers in the TDLS code
Date: Wed, 23 Sep 2026 16:01:37 +0200
Message-ID: <20260923140646.753669571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6f0a100df8539ce90f37c14e1945f396ca2410bc ]

ieee80211_tdls_oper() can operate on the AP station, which then
yields various warnings when the AP station is removed then or
at a later point in time after being confused for a TDLS peer.

Always check that the station is a TDLS peer.

Assisted-by: LLM
Fixes: dfe018bf9953 ("mac80211: handle TDLS high-level commands and frames")
Fixes: 17e6a59a365a ("mac80211: cleanup TDLS state during failed setup")
Reported-by: syzbot+a59b5291776979816910@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a59b5291776979816910
Link: https://patch.msgid.link/20260904165722.3bad8b79679b.I99618745e83cbe9b9804179387be15fcd3505ae3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tdls.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index ffd575a8d188f..5f2f89795dc99 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1142,6 +1142,7 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	enum ieee80211_smps_mode smps_mode =
 		sdata->deflink.u.mgd.driver_smps_mode;
+	struct sta_info *sta;
 	int ret;
 
 	/* don't support setup with forced SMPS mode that's not off */
@@ -1168,14 +1169,10 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 	 * Allow error packets to be sent - sometimes we don't even add a STA
 	 * before failing the setup.
 	 */
-	if (status_code == 0) {
-		rcu_read_lock();
-		if (!sta_info_get(sdata, peer)) {
-			rcu_read_unlock();
-			ret = -ENOLINK;
-			goto out_unlock;
-		}
-		rcu_read_unlock();
+	sta = sta_info_get(sdata, peer);
+	if ((status_code == 0 && !sta) || (sta && !sta->sta.tdls)) {
+		ret = -ENOLINK;
+		goto out_unlock;
 	}
 
 	ieee80211_flush_queues(local, sdata, false);
@@ -1442,6 +1439,10 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	tdls_dbg(sdata, "TDLS oper %d peer %pM\n", oper, peer);
 
+	sta = sta_info_get(sdata, peer);
+	if (!sta || !sta->sta.tdls)
+		return -ENOLINK;
+
 	switch (oper) {
 	case NL80211_TDLS_ENABLE_LINK:
 		if (sdata->vif.bss_conf.csa_active) {
@@ -1449,10 +1450,6 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			return -EBUSY;
 		}
 
-		sta = sta_info_get(sdata, peer);
-		if (!sta || !sta->sta.tdls)
-			return -ENOLINK;
-
 		iee80211_tdls_recalc_chanctx(sdata, sta);
 		iee80211_tdls_recalc_ht_protection(sdata, sta);
 
-- 
2.53.0



