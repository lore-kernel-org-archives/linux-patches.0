Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FA754705B;
	Thu, 17 Sep 2026 17:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667427; cv=none; b=hDjVy1/hD1eDxnYM15g6L9AM3pWoc6zcs784ThLZwfehOEIhzpGLb79YfSgcEhfB8HNTlnVd6Re+usyLQPb2TFDIlCoMsFBxVsuYdkcTd5MwxN40X2b0HmfErzRmpcfzwZkzJCQ7N5hw/SlxTmOCgx14WI2HE0EEH2FlEUzQygc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667427; c=relaxed/simple;
	bh=CH6AkhKNoxgg/SvERMgw2IMrzW8fcuC435SnNE920vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyabHEBV2cEWd60gaRinJtFTqV1yAt6mKLeIcxFvcHNG/OgGMs6OqOASNCkN8rHe5AWkyugL9+kryZYEZN4PZbTbpminD1IB/LKixBtGDVg7vPVgscVefEcmeYDyYh7XUsgx03KJFV3x8jaAXzjUJE2m5m1W5x44OlxNQ96vXoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgyL0eal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgyL0eal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91E21F000FF;
	Thu, 17 Sep 2026 17:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667426;
	bh=WtEapc66e4SkkLqkWZos4jfISl0jWPNtijCr8MXIFXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgyL0eal4n3vw2chEE2rvJnYQk9D/QfwdSQSF46dSpf3PWfA2JHs5Q/r4STqYdhyw
	 r5DbGK1eyz1jn0ssGRz0Iaf7Ij/KdHnpQTZVI3GmzZkLLmnK9Df8es50iIidcjWDQP
	 eqGSJHLgS4I+9Iiw4LvKpiQSrbXLoY6dE5pMeN1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0051/1102] wifi: mac80211: explicitly disable FTM responder on AP stop
Date: Thu, 17 Sep 2026 15:59:54 +0100
Message-ID: <20260917151540.730118584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 89e367a90c1a877ca9c5d75d3848582d80fd0e60 ]

When stopping the AP, explicitly disable FTM responder while
disabling beaconing.

Link: https://patch.msgid.link/20260505151241.f213196d7d6a.I95d65c030e986c5f7d63ecbd79596da890b9fc84@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index cfd02f4893545..f6c5de994898c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1600,6 +1600,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_link_data *link =
 		sdata_dereference(sdata->link[link_id], sdata);
 	struct ieee80211_bss_conf *link_conf = link->conf;
+	u64 changes = BSS_CHANGED_BEACON_ENABLED;
 	LIST_HEAD(keys);
 
 	lockdep_assert_wiphy(local->hw.wiphy);
@@ -1644,6 +1645,11 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (old_unsol_bcast_probe_resp)
 		kfree_rcu(old_unsol_bcast_probe_resp, rcu_head);
 
+	if (link_conf->ftm_responder) {
+		link_conf->ftm_responder = false;
+		changes |= BSS_CHANGED_FTM_RESPONDER;
+	}
+
 	kfree(link_conf->ftmr_params);
 	link_conf->ftmr_params = NULL;
 
@@ -1665,8 +1671,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->beacon_rate_set = false;
 	sdata->vif.cfg.ssid_len = 0;
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
-	ieee80211_link_info_change_notify(sdata, link,
-					  BSS_CHANGED_BEACON_ENABLED);
+	ieee80211_link_info_change_notify(sdata, link, changes);
 
 	if (sdata->wdev.links[link_id].cac_started) {
 		chandef = link_conf->chanreq.oper;
-- 
2.53.0



