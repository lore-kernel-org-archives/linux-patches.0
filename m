Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215497;
	b=WR8agH+dgGUz0IdCA+tAImy36AGy8E9Nv64UKrCVf6XAvpj185ux2MNNQBfpoVu+n7l6
	 GcIGgOxbZdACus4Xhkc0enWo1/8IsXbKyyRkgXVsD2C2ZoBFJTp7UzsbxynbqQzt/FbJc
	 lIi2Y6jd770Owpz5PrUCLHsDtvwl6pU18KhcCGf3RcOa0QIrHuzR2qa9Svak5hzCYeMaV
	 PHLrnNJ7+GLrnP7GX3x1iXbRCm0xEJ/sZMwm2q0BnmZATNWLH5aWexcrZnp6PwrawbuBo
	 yCypRZZk86k/2qJZYbZlli+DcGwN7yvuz2MRCIve8s7j33yqmVN3RTwu2AMhZqEBP4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AArskoDhPGAulSFXqpTmlujgoB1wl5cJ2aAZ/I40IOY=;
	b=tHCYXiprNFyddcubKiPkg4WZvBRJSoJXYU/leP+TznNgg3AF2aTuF7dT1UXRU/7aDxCK
	 5PhGd/AYJP2PM/wxZZgQ+YmCYgI1RqwzZo0nZlIdoygEqQrob9AyESjP5RqPf14hRqGUf
	 pRWfjb/bNGl8BcT+97GOzYbyGpupynG08fJtQBiHWatq3zmtvZH4W4vZaPf6hjFWmIFfg
	 zw7XV/N1dOEuhgKOUPyffVZ9yM3u3Cmvpc68N2Z5nk7jffxmDNlH9PdeSxRpIgjJ8d3Ud
	 V8PrfCDhJq8rlCQW2Z+ciyYhGnq1rUHBS41N0eXd9krFnkgyZaWYPmoygPJMAc/wDag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dwzyoz0b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39583606A31D;
	Wed, 28 Oct 2026 19:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dwzyoz0b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABFC1F01825;
	Wed, 28 Oct 2026 19:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215497;
	bh=AArskoDhPGAulSFXqpTmlujgoB1wl5cJ2aAZ/I40IOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dwzyoz0b0N0cbdch7VbfSS5HBq9c1Hvs9K6c1NHtEZ8SA7qiIMswcQ1/tKKsS09Yd
	 ITI0PjNknkR8IvQHMdDaFLrszBLWnZS26D6I3OhQh0uL3if2qWbtPDWcQG5YScaSha
	 rpDGC9iVLFteyN6XvTZQqvkf4uN+gNbN84Lb4xH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1188/1887] wifi: mac80211: refactor populating mesh related fields in sinfo
Date: Wed, 28 Oct 2026 17:54:44 +0100
Message-ID: <20261028170526.440012271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ffa77f229c289..9b8f25a6126cd 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2498,6 +2498,39 @@ static inline u64 sta_get_stats_bytes(struct ieee80211_sta_rx_stats *rxstats)
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
@@ -2681,31 +2714,10 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
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
@@ -2761,12 +2773,6 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
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



