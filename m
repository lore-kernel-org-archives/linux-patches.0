Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D819C423E9C;
	Fri,  9 Oct 2026 14:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555910; cv=none; b=MDoIiJXWfM8piZq12UZPeDRFyemZetXl1ZR/e0AmekmX83gM8RgiUH/Cus+2lMTWiePE6ejKP3JUyhvG3pM2yAM82cKBNMsbRdhYbaFsnHz7+gjxSJ9oqleAzy0W4m3dA8BuJNqdHXVGdPkTo0U/V+qNh9ipDTrTjEXI6grdeXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555910; c=relaxed/simple;
	bh=bFp8sHtPbvNaum0cosBnKdzWcovKOTMwVCsf9HxQUDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBjBO1paEoFvy1C6+g99YF0Pi5E/vjEyzAoi3HIaiSGoLrNbcjc8FslOZoL62HxtHWSsnm8OWt37w3EqfA9hLCmXKoA+/tVOwui07Z9IMbiDkgeJlnd2wvGet2jeI1I0GZxz2+LWUGOIZbydqKXB+QDPzWIwgl1ROLdRvBNYo7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiB+11dR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiB+11dR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB581F000FF;
	Fri,  9 Oct 2026 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555908;
	bh=eJ+jJKw5+TqMqseAyap2fJKexNqpy34m/FpEkcp7Xss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DiB+11dRuVjsshHdg8loLCEfP0brUxB5RLJ3HGMXfql63Hc+8MV5SLzRLXNKS5xwq
	 zWDvRlBUV2sX7iGYeQYjA849T6Pp8VRGmSuUVHCpbPsfrnZ5lrXfGUk1Nkd2xoV0M5
	 9h0n1YawtJe/t11Q5EQKgKf9po87NDIPvzzGtfgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 089/428] wifi: mac80211: prevent AP VLAN tx from other interfaces
Date: Fri,  9 Oct 2026 16:07:06 +0200
Message-ID: <20261009140948.153884209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
index 0564370419fba..011ec7fbb7118 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2478,7 +2478,7 @@ static inline bool ieee80211_require_encrypted_assoc(__le16 fc,
 /* sta_out needs to be checked for ERR_PTR() before using */
 int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb,
-			    struct sta_info **sta_out);
+			    struct sta_info **sta_out, bool bss);
 
 static inline void
 ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e264121208736..77e7d5a17abe0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2523,7 +2523,7 @@ static inline bool ieee80211_is_tdls_setup(struct sk_buff *skb)
 
 int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb,
-			    struct sta_info **sta_out)
+			    struct sta_info **sta_out, bool bss)
 {
 	struct sta_info *sta;
 
@@ -2544,7 +2544,10 @@ int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
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
@@ -4390,7 +4393,8 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	    ieee80211_mesh_xmit_fast(sdata, skb, ctrl_flags))
 		goto out;
 
-	if (ieee80211_lookup_ra_sta(sdata, skb, &sta))
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta,
+				    skb->protocol == sdata->control_port_protocol))
 		goto out_free;
 
 	if (IS_ERR(sta))
@@ -4820,7 +4824,10 @@ static void __ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 
 	rcu_read_lock();
 
-	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+	if (unlikely(sdata->control_port_protocol == ehdr->h_proto))
+		goto skip_offload;
+
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta, false)) {
 		kfree_skb(skb);
 		goto out;
 	}
@@ -4841,8 +4848,7 @@ static void __ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 		link = &sdata->deflink;
 		key = rcu_dereference(link->default_multicast_key);
 	} else if (unlikely(IS_ERR_OR_NULL(sta) || !sta->uploaded ||
-		   !test_sta_flag(sta, WLAN_STA_AUTHORIZED) ||
-	    sdata->control_port_protocol == ehdr->h_proto)) {
+		   !test_sta_flag(sta, WLAN_STA_AUTHORIZED))) {
 		goto skip_offload;
 	} else {
 		key = rcu_dereference(sta->ptk[sta->ptk_idx]);
@@ -4903,7 +4909,7 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_lock();
 
-	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta, false)) {
 		kfree_skb(skb);
 		skb = ERR_PTR(-EINVAL);
 		goto out;
@@ -4974,7 +4980,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		}
 		result = ieee80211_tx(sdata, NULL, skb, true);
 	} else if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
-		if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+		if (ieee80211_lookup_ra_sta(sdata, skb, &sta, true)) {
 			dev_kfree_skb(skb);
 			return true;
 		}
@@ -6611,7 +6617,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
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



