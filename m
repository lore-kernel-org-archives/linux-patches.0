Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C01847A0DD;
	Wed, 30 Sep 2026 16:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785888; cv=none; b=cGAQ6gnawrj1aebyXS8HV0BteqTtq0NgWWBmHzo7GYZNeOOatf7O76Ojb92Ji7dndDqS+F2UQ/mJeybXRjYKMesVj3L7JguOFJ/RfIdgM45AHSayj8EZchOHjw+IebUyfERVlMCntj3sqzGpdQjrU369ksm0G9R8KdSKtRXNPq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785888; c=relaxed/simple;
	bh=BJooxqavvQyCnWVH1x//7pUxEXBQuMYIk+ZVICYftME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXoHm8s9rMkLkqPqYMgqoUerPFv1Rg1HdONYeT7uNe9VIds1QuxJk2VCCXBxQNfxoS3YbTRBAINT2Gw3kqNpuSrRZiKLxBDhKeXUv5Y11rqI0W+Imxen7lmvHAHaXZOQ8qm4UQZsfecrQyb7mziKXXCz9XHJu885g89Bv5CZoMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTl7dK7h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTl7dK7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914D11F000FF;
	Wed, 30 Sep 2026 16:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785887;
	bh=EjLaa0eVsHykKuNm0hFnX90hHdWaj00dq4ftxsv485U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTl7dK7hHFfTXkFxhK43JIOnCjEPEAcZZsq/J+aXxicfXuCd80R/INEli8J5eQvc2
	 Hk7inJvPLKG9hE6bXK3AfE/M/aEb69R0HdVI4iaTeP3N+ONKYqem2AqJkH5PeQZgbP
	 eKZjs/LZ3MW48IK7xwLcjsZE2UFKD8zOwvU3UBao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 640/982] wifi: mac80211: rework ack_frame_id handling a bit
Date: Wed, 30 Sep 2026 17:22:56 +0200
Message-ID: <20260930152430.513553980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f498f6ab7adb461a68e13ea6d4443cb3636f2d93 ]

Take one more free bit to indicate it's IDR vs. internal
usage, to be able to carve out some bits here for other
internal usage, other than IDR handling with a full ACK
SKB, that is.

Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 50d3d79dc074 ("wifi: mac80211: set up the TX info early to fix failure paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h     |  9 ++++++---
 net/mac80211/cfg.c         |  3 ++-
 net/mac80211/ieee80211_i.h |  5 +++++
 net/mac80211/status.c      |  4 ++--
 net/mac80211/tx.c          | 14 ++++++++++----
 5 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1769d03e6b1d4..c68df4da7a367 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1071,7 +1071,9 @@ ieee80211_rate_get_vht_nss(const struct ieee80211_tx_rate *rate)
  *	not valid if the interface is an MLD since we won't know which
  *	link the frame will be transmitted on
  * @hw_queue: HW queue to put the frame on, skb_get_queue_mapping() gives the AC
- * @ack_frame_id: internal frame ID for TX status, used internally
+ * @status_data: internal data for TX status handling, assigned privately,
+ *	see also &enum ieee80211_status_data for the internal documentation
+ * @status_data_idr: indicates status data is IDR allocated ID for ack frame
  * @tx_time_est: TX time estimate in units of 4us, used internally
  * @control: union part for control data
  * @control.rates: TX rates array to try
@@ -1111,10 +1113,11 @@ struct ieee80211_tx_info {
 	/* common information */
 	u32 flags;
 	u32 band:3,
-	    ack_frame_id:13,
+	    status_data_idr:1,
+	    status_data:13,
 	    hw_queue:4,
 	    tx_time_est:10;
-	/* 2 free bits */
+	/* 1 free bit */
 
 	union {
 		struct {
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b1c9d869305f9..82c62fc4f0578 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3955,7 +3955,8 @@ int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
 		return -ENOMEM;
 	}
 
-	IEEE80211_SKB_CB(skb)->ack_frame_id = id;
+	IEEE80211_SKB_CB(skb)->status_data_idr = 1;
+	IEEE80211_SKB_CB(skb)->status_data = id;
 
 	*cookie = ieee80211_mgmt_tx_cookie(local);
 	IEEE80211_SKB_CB(ack_skb)->ack.cookie = *cookie;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5c3993f611625..9e1c1c859cf65 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -83,6 +83,11 @@ extern const u8 ieee80211_ac_to_qos_mask[IEEE80211_NUM_ACS];
 
 #define IEEE80211_MAX_NAN_INSTANCE_ID 255
 
+enum ieee80211_status_data {
+	IEEE80211_STATUS_TYPE_MASK	= 0x00f,
+	IEEE80211_STATUS_TYPE_INVALID	= 0,
+	IEEE80211_STATUS_SUBDATA_MASK	= 0xff0,
+};
 
 /*
  * Keep a station's queues on the active list for deficit accounting purposes
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 9a8fca897d9f9..48870656e6c0d 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -633,7 +633,7 @@ static void ieee80211_report_ack_skb(struct ieee80211_local *local,
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->ack_status_lock, flags);
-	skb = idr_remove(&local->ack_status_frames, info->ack_frame_id);
+	skb = idr_remove(&local->ack_status_frames, info->status_data);
 	spin_unlock_irqrestore(&local->ack_status_lock, flags);
 
 	if (!skb)
@@ -759,7 +759,7 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 		}
 
 		rcu_read_unlock();
-	} else if (info->ack_frame_id) {
+	} else if (info->status_data_idr) {
 		ieee80211_report_ack_skb(local, skb, acked, dropped,
 					 ack_hwtstamp);
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0cd02bd3fae30..d1e0510d1086f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2982,7 +2982,10 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	memset(info, 0, sizeof(*info));
 
 	info->flags = info_flags;
-	info->ack_frame_id = info_id;
+	if (info_id) {
+		info->status_data = info_id;
+		info->status_data_idr = 1;
+	}
 	info->band = band;
 
 	if (likely(!cookie)) {
@@ -4579,9 +4582,12 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (unlikely(skb->sk &&
-		     skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS))
-		info->ack_frame_id = ieee80211_store_ack_skb(local, skb,
-							     &info->flags, NULL);
+		     skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS)) {
+		info->status_data = ieee80211_store_ack_skb(local, skb,
+							    &info->flags, NULL);
+		if (info->status_data)
+			info->status_data_idr = 1;
+	}
 
 	info->hw_queue = sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
 
-- 
2.53.0



