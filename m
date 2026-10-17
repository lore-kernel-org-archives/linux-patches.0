Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A11737268A;
	Sat, 17 Oct 2026 17:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259251; cv=none; b=VvlQMnPRXaJXfyECjkSx9Ty7qAy9kw3fmpyt9ifvCMx7zEqoLLhst0B150GytoDBLf6fR27svTzWxa0oZSPXiAuHM2AeGk0H1ubNKlHpNX0nJdxPvvhmLrjV2u80o0HVCeTJc20PXhc7CpwBlSNeL1wXKHfFiZtfNQO/WXjHIMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259251; c=relaxed/simple;
	bh=l/h0CYcvZSG3mNNTuJm6qFe36HeXmTr/jyujAYKG+xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUc4S0a6QHpxj9oEtZa36pTfvaPXk43M+CCjBpswWObdKCCOhQRw8ewHzsRSADligp0jIg4P+HHRdRyIOC6B5Ea7uAgOImc6xfqVMmsKUahHnKTQDCd8//3JfUi34iwTU5qpybQpt4F/vf4d09iYxanuMAqsTu5tlBRNRhAgI2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpO4FdTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpO4FdTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DAD1F000C4;
	Sat, 17 Oct 2026 17:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259250;
	bh=Vl4r59Q3LlpLtln4FnQwZfvbEE4UtdmZKEmm4aQ0m4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpO4FdTmPYP2xypFsgAoxwikjQ+WBDVZjWgNnU4AA7SwhEGgbWsgH/KmVtYAdH+sD
	 y2Gl7oOz2vJf73hTglnPcN/gDlbdQawoRpdklC2k27W4fTOSTUO5OXV7sDoxyQiP2G
	 +BuYmzzPV30/hh74MHLqgbEQLiktZZBE6F9bTFEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1102/1674] wifi: mac80211: refactor populating mesh related fields in sinfo
Date: Sat, 17 Oct 2026 17:56:14 +0200
Message-ID: <20261017160459.416345640@linuxfoundation.org>
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
index de8a33c1e4f25..94ba60e9addbc 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2589,6 +2589,39 @@ static inline u64 sta_get_stats_bytes(struct ieee80211_sta_rx_stats *rxstats)
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
@@ -2772,31 +2805,10 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
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
@@ -2852,12 +2864,6 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
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



