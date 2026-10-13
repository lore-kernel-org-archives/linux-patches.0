Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC2F4F85C7;
	Tue, 13 Oct 2026 12:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894817; cv=none; b=eb6WSE0QCYi4Zdg5cu1ozWBM9j07nJyCQi6ghY0YBakP78sSb09GSVCnD3zAZL+Zm1uJRf8d4G+WSoCqIVh2w6Je2Lf474DrgvYZTgnvbX3v3s1KyFXlfhcxYdMY+n6CZwdXVvn0EJRmELI3mdCdMQfkqIT2uZOj6/EFLgvZcME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894817; c=relaxed/simple;
	bh=AeUqFdPF6Mb4cKoOphqE2AoOXKm8odJ4e7G4lGEwE98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDHMoH19QVts6kbK7hv70ID/hrl9kIc9sikSoqi48umMaqvKzMdHh/yBD4C8fKJLKM1vrIsEegwRP6nYR/NsxO67Jr+Aw64XX/2+PnybHnHQX9xCAQAyAXm+HpeSSGCsJAyipXLT3e2hgA2Xzh6AJwAveIA+DbHgZfHGMKSqlc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OA/qEuCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OA/qEuCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CA61F000FF;
	Tue, 13 Oct 2026 12:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894816;
	bh=dWUJ93dM2Hb3Wv6+BCbtNOsQ2x6mXjQBZMfMTMx17z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OA/qEuCn7y0L/f6bAr9jWHJ1xmSnMTz+Fcs/w6h/uRFX6UUOHHgvHj3Lm3/0VhSBp
	 VTZb63gIBOgY4e8eCe0Si4uHiVVq3V/BUG20UYXhPB644JxS73oagMDP9c8ygUzqVN
	 G7D/6cNS0Y+1UglaO+t+IJY17BqfNjWcoF9wRQTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/497] wifi: mac80211: prevent AP VLAN tx from other interfaces
Date: Tue, 13 Oct 2026 13:33:53 +0200
Message-ID: <20261013112909.452006403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 7f93ca31f7fd9b42e7d692f59514436d448ac908 ]

Since the station lookup was factored out of ieee80211_build_hdr(),
ieee80211_lookup_ra_sta() uses sta_info_get_bss() for all AP and AP VLAN
frames, not only for control port frames. A unicast frame sent on one
interface thus matches a station of a different VLAN of the same BSS and
is transmitted to it.

Only match stations of the interface the frame is sent on, except for
control port frames, since those may be sent for VLAN stations directly
on the BSS interface.

Fixes: 97ffe75791b3 ("mac80211: factor out station lookup from ieee80211_build_hdr()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20260916094833.164219-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/tx.c          | 24 +++++++++++++++---------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3486f3d55c42e..c0e7db6fbec38 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2325,7 +2325,7 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 /* sta_out needs to be checked for ERR_PTR() before using */
 int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb,
-			    struct sta_info **sta_out);
+			    struct sta_info **sta_out, bool bss);
 
 static inline void
 ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9fa30980a3802..e07bf5ba9b7a7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2501,7 +2501,7 @@ static inline bool ieee80211_is_tdls_setup(struct sk_buff *skb)
 
 int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb,
-			    struct sta_info **sta_out)
+			    struct sta_info **sta_out, bool bss)
 {
 	struct sta_info *sta;
 
@@ -2522,7 +2522,10 @@ int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 			*sta_out = ERR_PTR(-ENOENT);
 			return 0;
 		}
-		sta = sta_info_get_bss(sdata, skb->data);
+		if (bss)
+			sta = sta_info_get_bss(sdata, skb->data);
+		else
+			sta = sta_info_get(sdata, skb->data);
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
@@ -4340,7 +4343,8 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	    ieee80211_mesh_xmit_fast(sdata, skb, ctrl_flags))
 		goto out;
 
-	if (ieee80211_lookup_ra_sta(sdata, skb, &sta))
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta,
+				    skb->protocol == sdata->control_port_protocol))
 		goto out_free;
 
 	if (IS_ERR(sta))
@@ -4766,7 +4770,10 @@ static void __ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 
 	rcu_read_lock();
 
-	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+	if (unlikely(sdata->control_port_protocol == ehdr->h_proto))
+		goto skip_offload;
+
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta, false)) {
 		kfree_skb(skb);
 		goto out;
 	}
@@ -4787,8 +4794,7 @@ static void __ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 		link = &sdata->deflink;
 		key = rcu_dereference(link->default_multicast_key);
 	} else if (unlikely(IS_ERR_OR_NULL(sta) || !sta->uploaded ||
-		   !test_sta_flag(sta, WLAN_STA_AUTHORIZED) ||
-	    sdata->control_port_protocol == ehdr->h_proto)) {
+		   !test_sta_flag(sta, WLAN_STA_AUTHORIZED))) {
 		goto skip_offload;
 	} else {
 		key = rcu_dereference(sta->ptk[sta->ptk_idx]);
@@ -4849,7 +4855,7 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_lock();
 
-	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta, false)) {
 		kfree_skb(skb);
 		skb = ERR_PTR(-EINVAL);
 		goto out;
@@ -4920,7 +4926,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		}
 		result = ieee80211_tx(sdata, NULL, skb, true);
 	} else if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
-		if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+		if (ieee80211_lookup_ra_sta(sdata, skb, &sta, true)) {
 			dev_kfree_skb(skb);
 			return true;
 		}
@@ -6327,7 +6333,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	 * AF_PACKET
 	 */
 	rcu_read_lock();
-	err = ieee80211_lookup_ra_sta(sdata, skb, &sta);
+	err = ieee80211_lookup_ra_sta(sdata, skb, &sta, true);
 	if (err) {
 		dev_kfree_skb(skb);
 		rcu_read_unlock();
-- 
2.53.0



