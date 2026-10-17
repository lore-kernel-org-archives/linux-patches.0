Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06B2384CED;
	Sat, 17 Oct 2026 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254308; cv=none; b=rb9aSY7DWpZHBug9b8s6A0NxIVTSM+zqRynmLXcIGrCulj0c05kl+lUsRpJ6Za48gXQ/Omdw40jh/lqmbde+9xMVuIwFpwPk8R1U+Qh65+B3WbcASXoAgU97KjVNMdjX1ei8eaGQtI4PqZEQ1Il3feawpsQV5bsTJ+YIsFeWFMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254308; c=relaxed/simple;
	bh=0XXspl1kTe9VjwGetjJSma+tiThfGhgm5EWYLWehMXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcgW6bIMYBcIBCGzPRQjLkgMdq12nzolKmUPu9yuPt7/7sNhWGcpES7lqEyUvwc1bs/+St/Hc7HXFQWeM9dNuxNswzjI+mwT9WBqh7Mc5bI/DUe9UC8mM5yJx1UI7OvJfuDCSHdKycl6JJj84hA58Jo/CWXp1ojZySWm4uFCcd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8+PxpKv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8+PxpKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082C21F000C4;
	Sat, 17 Oct 2026 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254307;
	bh=k7qh0ORA7z/a539t45l/GhrBaUK1C6R254cFSl6rzyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8+PxpKvBVBhRH2/GF/0mzGrZ7yWfOjqNwwc61dIXUkg2CPaHtuy1OyNdZ4CEegNX
	 gV6dB8vWXdhHDHNtc4AlQJkQ4uVxLKUsd8qJmERwWV79EJkR4CaDQP3jPRDVs93Sp/
	 jUWtROOq53+F4WRPI7xXgWBDdGq/OWvO2zcvG+3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 404/869] wifi: mac80211: refactor populating mesh related fields in sinfo
Date: Sat, 17 Oct 2026 17:54:05 +0200
Message-ID: <20261017160047.493354593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Sarika Sharma <quic_sarishar@quicinc.com>

[ Upstream commit e5328c14590d034dc586e56aaab88e966d06efa7 ]

Introduce the sta_set_mesh_sinfo() to populate mesh related
fields in sinfo structure for station statistics.
This will allow for the simplified population of other fields in the
sinfo structure for link level in a subsequent patch to add support
for MLO station statistics.
No functionality changes added.

Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Link: https://patch.msgid.link/20250213171632.1646538-3-quic_sarishar@quicinc.com
[reword since it's just an internal thing]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: aa2eb6252518 ("wifi: mac80211: defer link RX stats percpu free to RCU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 64 ++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 122697fbd84b1..e5781b8355d5e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2573,6 +2573,39 @@ static inline u64 sta_get_stats_bytes(struct ieee80211_sta_rx_stats *rxstats)
 	return value;
 }
 
+#ifdef CONFIG_MAC80211_MESH
+static void sta_set_mesh_sinfo(struct sta_info *sta,
+			       struct station_info *sinfo)
+{
+	struct ieee80211_local *local = sta->sdata->local;
+
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_LLID) |
+			 BIT_ULL(NL80211_STA_INFO_PLID) |
+			 BIT_ULL(NL80211_STA_INFO_PLINK_STATE) |
+			 BIT_ULL(NL80211_STA_INFO_LOCAL_PM) |
+			 BIT_ULL(NL80211_STA_INFO_PEER_PM) |
+			 BIT_ULL(NL80211_STA_INFO_NONPEER_PM) |
+			 BIT_ULL(NL80211_STA_INFO_CONNECTED_TO_GATE) |
+			 BIT_ULL(NL80211_STA_INFO_CONNECTED_TO_AS);
+
+	sinfo->llid = sta->mesh->llid;
+	sinfo->plid = sta->mesh->plid;
+	sinfo->plink_state = sta->mesh->plink_state;
+	if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_T_OFFSET);
+		sinfo->t_offset = sta->mesh->t_offset;
+	}
+	sinfo->local_pm = sta->mesh->local_pm;
+	sinfo->peer_pm = sta->mesh->peer_pm;
+	sinfo->nonpeer_pm = sta->mesh->nonpeer_pm;
+	sinfo->connected_to_gate = sta->mesh->connected_to_gate;
+	sinfo->connected_to_as = sta->mesh->connected_to_as;
+
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_AIRTIME_LINK_METRIC);
+	sinfo->airtime_link_metric = airtime_link_metric_get(local, sta);
+}
+#endif
+
 void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		   bool tidstats)
 {
@@ -2757,31 +2790,10 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 			sta_set_tidstats(sta, &sinfo->pertid[i], i);
 	}
 
-	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
-		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_LLID) |
-				 BIT_ULL(NL80211_STA_INFO_PLID) |
-				 BIT_ULL(NL80211_STA_INFO_PLINK_STATE) |
-				 BIT_ULL(NL80211_STA_INFO_LOCAL_PM) |
-				 BIT_ULL(NL80211_STA_INFO_PEER_PM) |
-				 BIT_ULL(NL80211_STA_INFO_NONPEER_PM) |
-				 BIT_ULL(NL80211_STA_INFO_CONNECTED_TO_GATE) |
-				 BIT_ULL(NL80211_STA_INFO_CONNECTED_TO_AS);
-
-		sinfo->llid = sta->mesh->llid;
-		sinfo->plid = sta->mesh->plid;
-		sinfo->plink_state = sta->mesh->plink_state;
-		if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
-			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_T_OFFSET);
-			sinfo->t_offset = sta->mesh->t_offset;
-		}
-		sinfo->local_pm = sta->mesh->local_pm;
-		sinfo->peer_pm = sta->mesh->peer_pm;
-		sinfo->nonpeer_pm = sta->mesh->nonpeer_pm;
-		sinfo->connected_to_gate = sta->mesh->connected_to_gate;
-		sinfo->connected_to_as = sta->mesh->connected_to_as;
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		sta_set_mesh_sinfo(sta, sinfo);
 #endif
-	}
 
 	sinfo->bss_param.flags = 0;
 	if (sdata->vif.bss_conf.use_cts_prot)
@@ -2837,12 +2849,6 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sinfo->filled |=
 			BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG);
 	}
-
-	if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_AIRTIME_LINK_METRIC);
-		sinfo->airtime_link_metric =
-			airtime_link_metric_get(local, sta);
-	}
 }
 
 u32 sta_get_expected_throughput(struct sta_info *sta)
-- 
2.53.0



