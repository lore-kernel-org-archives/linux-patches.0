Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02A83DAAA4;
	Wed, 30 Sep 2026 19:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796022; cv=none; b=pgfKnzLFuUWTMILWdUSgb3RiK50d22JAfcSVHbvtVNVueCHoYy3HB/Qog0DmRFTW3/7F42SJ/zZ4r33fcc7BKDM4+NevMFTKM4ShpNv/Khqv44ZM4scjmFB5jutlYhi/9cSWtoYJ0pEIky83HAjmfGw3PqYWrwwnZFLKxsvMJic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796022; c=relaxed/simple;
	bh=ranZPXmLwqd3GixxaqkApdeqM8t5I4sYrpc7jKIiDnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gc5eIMNFS+XVg7QESdGu9GuCFmgz45Ck9fPCIHnbVdNgPRNLffgGBupL1h4VHD0ke9FRqs1aLcmYruLYwU4LVbm9Gy1EofZylwt64pcjWUoAEQ6scfatEhp00FqVNgsb3u5IU0WaExSRX11fsEIgqCFE60HMIW0bp33FG5FUItI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvdcnTH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvdcnTH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C7D1F000FF;
	Wed, 30 Sep 2026 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796020;
	bh=4I5fdrmdSLWxTtvIausoU6SOBXGS9uGR1Z2pdYupFgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvdcnTH/JRdsZWhyPr3KlduJcKdqeCTBj9c0t/3YKyOTUSJVlXhs4YzYqw8qGbd1+
	 JF9IAZq8zbHhvIQ/QiJTteKlSfmWbhxtoFVOnkbjpjFOkLAjaM/5b0qqppBYRr2zTk
	 +triCtDAWejPzSAVOt8P5sDhLUtA3zxutsyGpdKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0767/1193] wifi: mac80211: rework ack_frame_id handling a bit
Date: Wed, 30 Sep 2026 17:24:11 +0200
Message-ID: <20260930152451.296806905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 85d785060e761..faf1fd70ff945 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1119,7 +1119,9 @@ ieee80211_rate_get_vht_nss(const struct ieee80211_tx_rate *rate)
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
@@ -1159,10 +1161,11 @@ struct ieee80211_tx_info {
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
index c1b6c897f99d5..b4fe1fa8560c0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4040,7 +4040,8 @@ int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
 		return -ENOMEM;
 	}
 
-	IEEE80211_SKB_CB(skb)->ack_frame_id = id;
+	IEEE80211_SKB_CB(skb)->status_data_idr = 1;
+	IEEE80211_SKB_CB(skb)->status_data = id;
 
 	*cookie = ieee80211_mgmt_tx_cookie(local);
 	IEEE80211_SKB_CB(ack_skb)->ack.cookie = *cookie;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6013e021f5e49..fba2e9109300a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -85,6 +85,11 @@ extern const u8 ieee80211_ac_to_qos_mask[IEEE80211_NUM_ACS];
 
 #define IEEE80211_MAX_NAN_INSTANCE_ID 255
 
+enum ieee80211_status_data {
+	IEEE80211_STATUS_TYPE_MASK	= 0x00f,
+	IEEE80211_STATUS_TYPE_INVALID	= 0,
+	IEEE80211_STATUS_SUBDATA_MASK	= 0xff0,
+};
 
 /*
  * Keep a station's queues on the active list for deficit accounting purposes
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 9676ed15efecc..9f126f1b391e1 100644
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
index 912686d07a419..4ca983c9c943b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2969,7 +2969,10 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	memset(info, 0, sizeof(*info));
 
 	info->flags = info_flags;
-	info->ack_frame_id = info_id;
+	if (info_id) {
+		info->status_data = info_id;
+		info->status_data_idr = 1;
+	}
 	info->band = band;
 
 	if (likely(!cookie)) {
@@ -4675,9 +4678,12 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
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
 
 	dev_sw_netstats_tx_add(dev, skbs, len);
 	sta->deflink.tx_stats.packets[queue] += skbs;
-- 
2.53.0



