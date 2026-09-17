Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C2A4E3234;
	Thu, 17 Sep 2026 18:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668358; cv=none; b=qj7/5qTkO6FFCW8MBEE7JlRzzWGOSw+5rqtmxt62cHq0Sboj7M+O7o3uvdcxxifwX8z9UP/NR4jf7UaGyvx0TuVNmyUzm9nGSnfNmLeYKncixB3mKyW3HLt8eJ3IA8ReskTEWy1kau8VHB0u73WMtFgznkMJ2u9wwaUdno6Uigc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668358; c=relaxed/simple;
	bh=4TTvVxHXDlwBolOV+7bDqaLI1anZRomwAw8JPTkYUy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPrA5GQ32mSaj/mMHcNYHHAGlG0Y9/yTKgxqrY+eYJFud7VhOAbyNL9a/LEdHaLaMNeE79ZOKgauvFzNWkRxyAGgDXUarbYqrRu7+Ikz4RSiyGutbzR/5sUbaQIXzCryHJ6m/fkqD91ZhYGJ2XGlh/Qq8v/YnqrVqGPC1rJyLsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNby2XzU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNby2XzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5261F000FF;
	Thu, 17 Sep 2026 18:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668356;
	bh=tyKiyaIQ/vWp46j5Xk/zCfGmzC6asF6vTzlZP+pgD2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNby2XzUrG3sUAG6eZOVhhdZ5Jay/S9DBDRV3DlqIFJIV/rX/6xNy86IJaDWe5JeV
	 QQRcapqC8yxh0lyTp7MB8wh1yPxf61OxYsFHou59HfMCeeJ6nJ8zbtjIIKcDIyBgiq
	 /i4/cwHbuQl5e+3QwuZT4/YNE8t3XmodJNZ/0QUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0397/1102] wifi: mac80211: ibss: wait for in-flight TX on disconnect
Date: Thu, 17 Sep 2026 16:05:40 +0100
Message-ID: <20260917151549.626438418@linuxfoundation.org>
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
index 3f74bbceeca5e..ce22d4e98efaa 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -682,7 +682,9 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 
 	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
 
-	sta_info_flush(sdata, -1);
+	netif_carrier_off(sdata->dev);
+	if (!sta_info_flush(sdata, -1))
+		synchronize_net();
 
 	spin_lock_bh(&ifibss->incomplete_lock);
 	while (!list_empty(&ifibss->incomplete_stations)) {
@@ -696,8 +698,6 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
 
-	netif_carrier_off(sdata->dev);
-
 	sdata->vif.cfg.ibss_joined = false;
 	sdata->vif.cfg.ibss_creator = false;
 	sdata->vif.bss_conf.enable_beacon = false;
@@ -724,7 +724,6 @@ static void ieee80211_csa_connection_drop_work(struct wiphy *wiphy,
 			     u.ibss.csa_connection_drop_work);
 
 	ieee80211_ibss_disconnect(sdata);
-	synchronize_rcu();
 	skb_queue_purge(&sdata->skb_queue);
 
 	/* trigger a scan to find another IBSS network to join */
@@ -1838,8 +1837,6 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	memset(&ifibss->ht_capa, 0, sizeof(ifibss->ht_capa));
 	memset(&ifibss->ht_capa_mask, 0, sizeof(ifibss->ht_capa_mask));
 
-	synchronize_rcu();
-
 	skb_queue_purge(&sdata->skb_queue);
 
 	del_timer_sync(&sdata->u.ibss.timer);
-- 
2.53.0



