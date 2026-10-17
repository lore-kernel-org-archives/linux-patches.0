Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D983B71A7;
	Sat, 17 Oct 2026 18:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260370; cv=none; b=sMY+979UqiP/7rJAD5EV4zaC48ltGffv7/rt+CYqQZxOLlg1PDSEXWJ8eC7db66Si7BPd4/FB3tIPlnq4307ME7AgwuhcAkj2MZXgakkSb6EzOe2FUH/uJ5iPzPPIHJ8G1G7Tup7kWNaqP+f2A9bB6f8WbZ3mPP5bf8O32r8/sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260370; c=relaxed/simple;
	bh=kJ7AXhRht9p8Dz8qnSoRGceKVN1UfmUs/gVFzTKRDNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8PrF5RqDFbQmaO3JO1EkvDtrSOAL350AF3mrIuU3edSnLbsbtAVWe9liyYjL4LtfH7fbzUA8LWjILsl3pCnry+6kAC+Q24r7gu0sn2+eeySEtM35a0nE170RDbmQgA5GRkDo2GsnaZp2o/aeswohEDHwziuZTKyG/lBgoFCLsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOvB1AxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOvB1AxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457E21F000C4;
	Sat, 17 Oct 2026 18:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260368;
	bh=eMoAb6vKCDnnKwWlhMGYTQnsNBbmvDTDZFMMyXO9v4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOvB1AxJw8yrHlEGDJ5FApSrBfohH+b6thxgEXT0qPYWA5ZWWLTQwyOaN/IImtl2f
	 3JATP/su79xOvNxgu3xN3LGtYOrQcJN3jkp5CUGlg+WFwmUOXLxIStTk4/BI5y6tw/
	 IXATM//V59LUmQ5qfn71zAUoOGyZr8bT2g5XOQQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1522/1674] wifi: mac80211: ibss: wait for in-flight TX on disconnect
Date: Sat, 17 Oct 2026 18:03:14 +0200
Message-ID: <20261017160510.187146563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5542c93edfba0..2474feb149b3a 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -695,7 +695,9 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 
 	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
 
-	sta_info_flush(sdata);
+	netif_carrier_off(sdata->dev);
+	if (!sta_info_flush(sdata))
+		synchronize_net();
 
 	spin_lock_bh(&ifibss->incomplete_lock);
 	while (!list_empty(&ifibss->incomplete_stations)) {
@@ -709,8 +711,6 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
 
-	netif_carrier_off(sdata->dev);
-
 	sdata->vif.cfg.ibss_joined = false;
 	sdata->vif.cfg.ibss_creator = false;
 	sdata->vif.bss_conf.enable_beacon = false;
@@ -741,7 +741,6 @@ static void ieee80211_csa_connection_drop_work(struct wiphy *wiphy,
 	sdata_lock(sdata);
 
 	ieee80211_ibss_disconnect(sdata);
-	synchronize_rcu();
 	skb_queue_purge(&sdata->skb_queue);
 
 	/* trigger a scan to find another IBSS network to join */
@@ -1882,8 +1881,6 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	memset(&ifibss->ht_capa, 0, sizeof(ifibss->ht_capa));
 	memset(&ifibss->ht_capa_mask, 0, sizeof(ifibss->ht_capa_mask));
 
-	synchronize_rcu();
-
 	skb_queue_purge(&sdata->skb_queue);
 
 	del_timer_sync(&sdata->u.ibss.timer);
-- 
2.53.0



