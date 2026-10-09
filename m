Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EB53B582F;
	Fri,  9 Oct 2026 14:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555567; cv=none; b=J7y/VNwRg2EJrt/ZzC3I0vf5K2bvEXiQxkGH7aKH4ojyVf3bSxJ9iHq9/tnA7TJxO1JNRsgyEX4k9GEFq0oivfExZgveqWWi7m7coM+MY4COXZ9kZrptvUL8QS3x7sgrIAKyHL9Me4fjf5UFO2IUuKv8xGRhhv9U6laTT9f6od8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555567; c=relaxed/simple;
	bh=YiNcXv6JUxyXk+hrxCutEi61psRKCY8PKwDQ3BZ9Mt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM3kYSKpGN+4sBZ3Ob3zzdLXQnjLTSsMbyGcjnsfgKyP3FpKYMeytyao3sFkjW/2MXxiesiKuzMlr3oJx1qtVORNGMpERCVFxG9f889FwB01fniWJSew2I6ab78u39adgaT9JmcinM2XS7MaLw7QqRDGrt8opXdJTfyZW3ejr5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNEYcdyv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNEYcdyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4E71F00893;
	Fri,  9 Oct 2026 14:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555554;
	bh=HjCyzqx0AEG4sALqJ+hZCd7AkvsMAZfKikR1sWvDkzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNEYcdyvgm78Hi5Y/e4EpbLyMvVa80HtsNU3x8q3cBlswYtamLnsTTN+BQiPCvsga
	 IylMLw4UcgzcEZm5FOMseWmrL6QTnyr3buf/Y+Vz7d9lFEwSk2kMJhimLsUrP45lw1
	 Di/V03iLnjBa1GRX86JU3fUXvC1PEe0nhKdJmOCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/403] wifi: mac80211: Add 802.3 multicast encapsulation offload support
Date: Fri,  9 Oct 2026 16:07:19 +0200
Message-ID: <20261009140953.920333537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>

[ Upstream commit 4cc0cc0b297c17c2b106d6892bd13d9c32fe66ce ]

mac80211 converts 802.3 multicast packets to 802.11 format
before driver TX, even when Ethernet encapsulation offload
is enabled. This prevents drivers that support multicast
Ethernet encapsulation offload from receiving frames in
native 802.3 format.

Introduce the IEEE80211_OFFLOAD_ENCAP_MCAST flag to bypass the
802.11 encapsulation step and pass the multicast packet to the
driver in 802.3 format. Drivers that support multicast Ethernet
encapsulation offload can advertise this flag.

Disable multicast encapsulation offload in MLO case for drivers not
advertising MLO_MCAST_MULTI_LINK_TX support for AP mode and for
3-address AP_VLAN multicast packets.

Signed-off-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
Link: https://patch.msgid.link/20260604162403.1563729-4-tamizh.raja@oss.qualcomm.com
[fix unlikely(), indentation]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 7f93ca31f7fd ("wifi: mac80211: prevent AP VLAN tx from other interfaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h |  4 ++++
 net/mac80211/tx.c      | 51 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d19b95d3c3a49..2fa6fc593df66 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1892,12 +1892,16 @@ enum ieee80211_vif_flags {
  * @IEEE80211_OFFLOAD_DECAP_ENABLED: rx encapsulation offload is enabled
  *	The driver supports passing received 802.11 frames as 802.3 frames to
  *	mac80211.
+ * @IEEE80211_OFFLOAD_ENCAP_MCAST: tx multicast encapsulation offload is enabled
+ *	The driver supports sending multicast frames passed as 802.3 frames
+ *	by mac80211.
  */
 
 enum ieee80211_offload_flags {
 	IEEE80211_OFFLOAD_ENCAP_ENABLED		= BIT(0),
 	IEEE80211_OFFLOAD_ENCAP_4ADDR		= BIT(1),
 	IEEE80211_OFFLOAD_DECAP_ENABLED		= BIT(2),
+	IEEE80211_OFFLOAD_ENCAP_MCAST		= BIT(3),
 };
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f1d84111aa24c..6b5c15298a2fd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4736,11 +4736,32 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	kfree_skb(skb);
 }
 
+static bool ieee80211_check_mcast_offload(struct ieee80211_sub_if_data *sdata,
+					  struct sk_buff *skb)
+{
+	struct ethhdr *ehdr = (struct ethhdr *)skb->data;
+
+	if ((ieee80211_vif_is_mld(&sdata->vif) &&
+	     (sdata->vif.type == NL80211_IFTYPE_AP &&
+	      !ieee80211_hw_check(&sdata->local->hw, MLO_MCAST_MULTI_LINK_TX))) ||
+	    (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+	     !sdata->wdev.use_4addr))
+		return false;
+
+	if (!is_multicast_ether_addr(skb->data) ||
+	    !(sdata->vif.offload_flags & IEEE80211_OFFLOAD_ENCAP_MCAST) ||
+	    sdata->control_port_protocol == ehdr->h_proto)
+		return false;
+
+	return true;
+}
+
 static void __ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 					      struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ethhdr *ehdr = (struct ethhdr *)skb->data;
+	struct ieee80211_link_data *link;
 	struct ieee80211_key *key;
 	struct sta_info *sta;
 
@@ -4751,14 +4772,30 @@ static void __ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 		goto out;
 	}
 
-	if (unlikely(IS_ERR_OR_NULL(sta) || !sta->uploaded ||
-	    !test_sta_flag(sta, WLAN_STA_AUTHORIZED) ||
-	    sdata->control_port_protocol == ehdr->h_proto))
+	/*
+	 * If STA is invalid, use the multicast offload path when applicable.
+	 * In AP mode, drop the frame if there are no associated stations;
+	 * otherwise use the default link and multicast key for transmission.
+	 */
+	if (unlikely(IS_ERR_OR_NULL(sta) &&
+		     ieee80211_check_mcast_offload(sdata, skb))) {
+		sta = NULL;
+		if (ieee80211_vif_get_num_mcast_if(sdata) <= 0) {
+			/* No associated STAs - no need to send multicast frames. */
+			kfree_skb(skb);
+			goto out;
+		}
+		link = &sdata->deflink;
+		key = rcu_dereference(link->default_multicast_key);
+	} else if (unlikely(IS_ERR_OR_NULL(sta) || !sta->uploaded ||
+		   !test_sta_flag(sta, WLAN_STA_AUTHORIZED) ||
+	    sdata->control_port_protocol == ehdr->h_proto)) {
 		goto skip_offload;
-
-	key = rcu_dereference(sta->ptk[sta->ptk_idx]);
-	if (!key)
-		key = rcu_dereference(sdata->default_unicast_key);
+	} else {
+		key = rcu_dereference(sta->ptk[sta->ptk_idx]);
+		if (!key)
+			key = rcu_dereference(sdata->default_unicast_key);
+	}
 
 	if (key && (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) ||
 		    key->conf.cipher == WLAN_CIPHER_SUITE_TKIP))
-- 
2.53.0



