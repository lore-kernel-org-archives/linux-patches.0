Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359B64CF49B;
	Sat, 17 Oct 2026 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256335; cv=none; b=DRs0bacevpT4eg/0SG1ZtjZaofliLGH5mC+yA4eeOOgC4zXJ8SdDW6T9ZhkZwzomF10C6C3/fc8ZFW6HF6MK5Ql5eew+14lXJuwvfxYiOa2Wyfou6nIet/gjF6BFOGNdW6FWJv5OtLr8+9vJLnZpOSlC5m/SsC0yP4n64ADn0+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256335; c=relaxed/simple;
	bh=7LvLT/UvQlY5EdzFXZMRBBaNE8tmd5i+nuqDb8WNlng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2l5tRN/EczdsxfsKS7wdTKIKYFOFziubf2W2taBzScENOWx7ij5UoqIZkEmVjnpVbcve9VHSmzXdkbS/z6Xk6MwuAyuEgK+WRODbd2YJtuJq76aq6tFUyqXGgFO2AC4uYw57Ve6T79qHCXgIBNgrAC45w1GN4mx25Ob1rvNEt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GufZDJGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GufZDJGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6CA1F000C4;
	Sat, 17 Oct 2026 16:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256333;
	bh=hWer8QImOhDcVkI267o7VSNkFxW6sadU31kUMCDbFDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GufZDJGYkPeB6AI/fFxcs1vi0xl5P8DWqWuuvvhaF/NXKBv2Tg/qf2uni/3YDnDzv
	 0eH/5MGP1A9V0dmiS1/4VBLgSYJfUcEIatVbNLKIWCKoZEVK+1I374Y/TfjcmJHuts
	 UZTokJq2gSrSA78rczeKFsucKZSewuxPiVia4Hkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0200/1674] wifi: mac80211: Add 802.3 multicast encapsulation offload support
Date: Sat, 17 Oct 2026 17:41:12 +0200
Message-ID: <20261017160436.286207781@linuxfoundation.org>
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
index faf1fd70ff945..89fe0f0b69fed 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1786,12 +1786,16 @@ enum ieee80211_vif_flags {
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
index 9450cb7dff54c..62695450ad673 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4701,11 +4701,32 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
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
 
@@ -4716,14 +4737,30 @@ static void __ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
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



