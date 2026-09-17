Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DFB3B776C;
	Thu, 17 Sep 2026 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664830; cv=none; b=ky0wUhl2QVS4X4XIDU0zH5hbsz0pTtS/QG8qEP1gjW4AjjlJ0cI9d6TClpf+SaMgN9VTm3Pv/xOCi07IhzSH0CSlVM2z0WLx8wk4nASo86fcTw5KCe0SHGlOlSheu8g/6uYdeq36Z1VWv790SoWtvwe6HtL9cQ50VY4MpkhPO/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664830; c=relaxed/simple;
	bh=zxANXSHzZwXY0pTZ5LLppNzEUQjKVBppHJJLPXyUjtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8HDSUAfNR80vgVjlmerJj0KbfzimmjwbYvdMYeCKXVQJmLHHoLCPsfcA1harC4fE5eDv5RAEn47qq2Z928vdAT9jTyLLbbdQXiXfTC9lKfO58iviCMl7OMDUkjr3paBOmIvAAhQymnyixKK1CDmD1b4G07JRmKRNCAGUd+QDPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwSEmS1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwSEmS1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8943D1F00893;
	Thu, 17 Sep 2026 17:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664829;
	bh=Ig+6lHg/ww7rmszGntAyPJw8WtnRl4R739xNc3Gr92Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwSEmS1nDzGHK/mq3J2TTPGQhVKXbF+OeFPKLsx6vGvxqXeDVSLyMy3S/MlIGyYkY
	 UnoixP+jZKAhw6Vf5rq7V75j+akLgvzeo7BiAxaWQln0WkRiLd5Bm2wwbM3SNTAFDl
	 CeetTbNzUJhWR7xORKzCIPct429ufONZPcHS4Fu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0501/1250] wifi: mac80211: ibss: wait for in-flight TX on disconnect
Date: Thu, 17 Sep 2026 16:04:56 +0100
Message-ID: <20260917151605.540052981@linuxfoundation.org>
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

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit d0e69d9afa59b93c30294eba89b1f15f69e91105 ]

While leaving an IBSS in ieee80211_ibss_disconnect() mac80211 flushes
stations, turns the carrier off and immediately tells the driver to
leave as well. While there may be synchronize_net() in station flush
and in this code later, packets can still be transmitted due to
cross-CPU race conditions after carrier off is set.
Therefore, it's possible for a race to happen where a TX to the
driver occurs while or after telling it to leave the IBSS. This can
be confusing to drivers, and in the case of iwlwifi leads to an
attempt to use invalid queues.

Move netif_carrier_off() to occur before sta_info_flush() during
IBSS disconnect, and add synchronize_net() if flushing didn't,
so that the synchronize_net() always happens between turning the
carrier off and telling the driver, avoiding this race.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260706223751.da1ce439cc93.If5cf482f87ab98ce66dd48724e24c81fed236d3f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ibss.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6e36b09fe97f8..6ca2ff354e768 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -675,7 +675,9 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 
 	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
 
-	sta_info_flush(sdata, -1);
+	netif_carrier_off(sdata->dev);
+	if (!sta_info_flush(sdata, -1))
+		synchronize_net();
 
 	spin_lock_bh(&ifibss->incomplete_lock);
 	while (!list_empty(&ifibss->incomplete_stations)) {
@@ -689,8 +691,6 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
 
-	netif_carrier_off(sdata->dev);
-
 	sdata->vif.cfg.ibss_joined = false;
 	sdata->vif.cfg.ibss_creator = false;
 	sdata->vif.bss_conf.enable_beacon = false;
@@ -717,7 +717,6 @@ static void ieee80211_csa_connection_drop_work(struct wiphy *wiphy,
 			     u.ibss.csa_connection_drop_work);
 
 	ieee80211_ibss_disconnect(sdata);
-	synchronize_rcu();
 	skb_queue_purge(&sdata->skb_queue);
 
 	/* trigger a scan to find another IBSS network to join */
@@ -1823,8 +1822,6 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	memset(&ifibss->ht_capa, 0, sizeof(ifibss->ht_capa));
 	memset(&ifibss->ht_capa_mask, 0, sizeof(ifibss->ht_capa_mask));
 
-	synchronize_rcu();
-
 	skb_queue_purge(&sdata->skb_queue);
 
 	timer_delete_sync(&sdata->u.ibss.timer);
-- 
2.53.0



