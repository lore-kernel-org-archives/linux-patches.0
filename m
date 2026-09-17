Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B39B4ACC73;
	Thu, 17 Sep 2026 16:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661076; cv=none; b=MuklleAc0kxG6pMjZagV+GKTHENE4AjYJwF2N4/ITW6TucseKFx/dZ/phs9BNztgZgvLRivBVhlsOccQBO6ZjaEO1po5puzG96c0Hid6P0eyab88P1ODRsPbY1E4MXRrAEDuTPsgL7nRLDhHma0BhTbHDBNvOUytjOllW8GMce0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661076; c=relaxed/simple;
	bh=FOkxOIMg1CXOdLhAVzaJCRMUlmSPDOfreGyVrcBaD14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRxDNlM8YJChSHS3HUjqYxdBk0od9tN/N37CSuY8nzCfI7cN75N1IYOIzOp7QrTckfzrsZ9Ywrb9nv5Irr2E9XXr7P5yuY5SlvU5PInAQ67THLQO+5KsCcdSzTWKeydymR6s9a9aT12sWa89gZDu85xR0Cqzw7H1q281TStOaf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unsuehpj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unsuehpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180721F000FF;
	Thu, 17 Sep 2026 16:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661074;
	bh=RC28ZzNHC6WwUR3e7mLqA6w5SXJZvWIcUPxKCjwZwx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=unsuehpjwAnhOuiWfYNGDJsPqt/Om3N5TOknoJwCT4RGfUAKKNWcw3ApS+dEqtkxS
	 RF6uMna8KAICo2cIkk9bgy96I6HFitqto9NZBGf7Was/0yjfGSkJjnNLU9dLMTqTag
	 d/H+fJwqszIeHbaxetaPrfMmkEUOscamLvYOpJho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0072/1250] wifi: mac80211: explicitly disable FTM responder on AP stop
Date: Thu, 17 Sep 2026 15:57:47 +0100
Message-ID: <20260917151553.899871432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f6232948bc0f4..72c9d5aceae58 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1811,6 +1811,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_link_data *link =
 		sdata_dereference(sdata->link[link_id], sdata);
 	struct ieee80211_bss_conf *link_conf = link->conf;
+	u64 changes = BSS_CHANGED_BEACON_ENABLED;
 	LIST_HEAD(keys);
 
 	lockdep_assert_wiphy(local->hw.wiphy);
@@ -1860,6 +1861,11 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (old_s1g_short_beacon)
 		kfree_rcu(old_s1g_short_beacon, rcu_head);
 
+	if (link_conf->ftm_responder) {
+		link_conf->ftm_responder = false;
+		changes |= BSS_CHANGED_FTM_RESPONDER;
+	}
+
 	kfree(link_conf->ftmr_params);
 	link_conf->ftmr_params = NULL;
 
@@ -1881,8 +1887,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->vif.cfg.ssid_len = 0;
 	sdata->vif.cfg.s1g = false;
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
-	ieee80211_link_info_change_notify(sdata, link,
-					  BSS_CHANGED_BEACON_ENABLED);
+	ieee80211_link_info_change_notify(sdata, link, changes);
 
 	ieee80211_remove_link_keys(link, &keys);
 	if (!list_empty(&keys)) {
-- 
2.53.0



