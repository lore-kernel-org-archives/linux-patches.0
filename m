Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6A51E8820;
	Wed,  6 Nov 2024 12:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897862; cv=none; b=UK4B+HcqZtZ0pu+7O33aYRxmJIoX9Cj+j2KRloDutd9MxljhtkurN2AHMOy/wkjS+gde4a17E3bkypiPcoGeuLTWJQcTLJcas1q75D1EdVtFLBc4oVFWfd9YngcLhhRqGS/lujMso5llGVqTMl1H6cVSLcF1e0Ttm1xLK+zQvtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897862; c=relaxed/simple;
	bh=x34XVKb+aHKoMyCpAcQMHgNJUaicf42BRFHp+7XWXH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnjIw5Ku9pLr0j1tBpYAuFHiBFldCxOLcKySZ4siTVsCbNb2eQcI37D+g6K8F+4p1GSXYeMvuTSrJKBZ7p14xEOHd4AkQgpYX3eocXg0lhhOwcbIMOn4hfmCSQ8lEM3K1X4Y2J5jPKN4hzllGS9rdr0hPCUFF3vP2y+JBnjFQwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWFFNxVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWFFNxVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AECC4CECD;
	Wed,  6 Nov 2024 12:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897862;
	bh=x34XVKb+aHKoMyCpAcQMHgNJUaicf42BRFHp+7XWXH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWFFNxVouE8ZBkkChkyQz3d35bMCPznFEyEfnt3J2b7r2oCL/aTblRZeZxu8ge2Kv
	 XxH73/B/riNCQuEeoFtd6WVbuKnUEZ5kT/InY4iSz/ZZQ7NN1/Liop3R4Yo/PmhWJF
	 HPYxBkLYhqcZgN9K4WSU8n01d9HuIXa+t8IPwwa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/462] mac80211: parse radiotap header when selecting Tx queue
Date: Wed,  6 Nov 2024 12:58:58 +0100
Message-ID: <20241106120332.632114777@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>

[ Upstream commit cb17ed29a7a5fea8c9bf70e8a05757d71650e025 ]

Already parse the radiotap header in ieee80211_monitor_select_queue.
In a subsequent commit this will allow us to add a radiotap flag that
influences the queue on which injected packets will be sent.

This also fixes the incomplete validation of the injected frame in
ieee80211_monitor_select_queue: currently an out of bounds memory
access may occur in in the called function ieee80211_select_queue_80211
if the 802.11 header is too small.

Note that in ieee80211_monitor_start_xmit the radiotap header is parsed
again, which is necessairy because ieee80211_monitor_select_queue is not
always called beforehand.

Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Link: https://lore.kernel.org/r/20200723100153.31631-6-Mathy.Vanhoef@kuleuven.be
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 9d301de12da6 ("wifi: mac80211: use two-phase skb reclamation in ieee80211_do_stop()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h |  8 +++++++
 net/mac80211/iface.c   | 15 ++++++++----
 net/mac80211/tx.c      | 54 +++++++++++++++++++-----------------------
 3 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d9ba9a77bcf29..cf67d7778d3d0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6134,6 +6134,14 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, struct sk_buff *skb,
 			      int band, struct ieee80211_sta **sta);
 
+/**
+ * Sanity-check and parse the radiotap header of injected frames
+ * @skb: packet injected by userspace
+ * @dev: the &struct device of this 802.11 device
+ */
+bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
+				 struct net_device *dev);
+
 /**
  * struct ieee80211_noa_data - holds temporary data for tracking P2P NoA state
  *
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ddc001ad90555..1f691180e13db 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1175,17 +1175,24 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
-	struct ieee80211_radiotap_header *rtap = (void *)skb->data;
+	int len_rthdr;
 
 	if (local->hw.queues < IEEE80211_NUM_ACS)
 		return 0;
 
-	if (skb->len < 4 ||
-	    skb->len < le16_to_cpu(rtap->it_len) + 2 /* frame control */)
+	/* reset flags and info before parsing radiotap header */
+	memset(info, 0, sizeof(*info));
+
+	if (!ieee80211_parse_tx_radiotap(skb, dev))
 		return 0; /* doesn't matter, frame will be dropped */
 
-	hdr = (void *)((u8 *)skb->data + le16_to_cpu(rtap->it_len));
+	len_rthdr = ieee80211_get_radiotap_len(skb->data);
+	hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
+	if (skb->len < len_rthdr + 2 ||
+	    skb->len < len_rthdr + ieee80211_hdrlen(hdr->frame_control))
+		return 0; /* doesn't matter, frame will be dropped */
 
 	return ieee80211_select_queue_80211(sdata, skb, hdr);
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5fd9a6f752a1d..4afced0588bd4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2034,9 +2034,10 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx(sdata, sta, skb, false, txdata_flags);
 }
 
-static bool ieee80211_parse_tx_radiotap(struct ieee80211_local *local,
-					struct sk_buff *skb)
+bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
+				 struct net_device *dev)
 {
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_radiotap_iterator iterator;
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
@@ -2055,6 +2056,18 @@ static bool ieee80211_parse_tx_radiotap(struct ieee80211_local *local,
 	u8 vht_mcs = 0, vht_nss = 0;
 	int i;
 
+	/* check for not even having the fixed radiotap header part */
+	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
+		return false; /* too short to be possibly valid */
+
+	/* is it a header version we can trust to find length from? */
+	if (unlikely(rthdr->it_version))
+		return false; /* only version 0 is supported */
+
+	/* does the skb contain enough to deliver on the alleged length? */
+	if (unlikely(skb->len < ieee80211_get_radiotap_len(skb->data)))
+		return false; /* skb too short for claimed rt header extent */
+
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 		       IEEE80211_TX_CTL_DONTFRAG;
 
@@ -2210,13 +2223,6 @@ static bool ieee80211_parse_tx_radiotap(struct ieee80211_local *local,
 						     local->hw.max_rate_tries);
 	}
 
-	/*
-	 * remove the radiotap header
-	 * iterator->_max_length was sanity-checked against
-	 * skb->len by iterator init
-	 */
-	skb_pull(skb, iterator._max_length);
-
 	return true;
 }
 
@@ -2225,8 +2231,6 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_radiotap_header *prthdr =
-		(struct ieee80211_radiotap_header *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_sub_if_data *tmp_sdata, *sdata;
@@ -2234,21 +2238,17 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	u16 len_rthdr;
 	int hdrlen;
 
-	/* check for not even having the fixed radiotap header part */
-	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
-		goto fail; /* too short to be possibly valid */
+	memset(info, 0, sizeof(*info));
+	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
+		      IEEE80211_TX_CTL_INJECTED;
 
-	/* is it a header version we can trust to find length from? */
-	if (unlikely(prthdr->it_version))
-		goto fail; /* only version 0 is supported */
+	/* Sanity-check and process the injection radiotap header */
+	if (!ieee80211_parse_tx_radiotap(skb, dev))
+		goto fail;
 
-	/* then there must be a radiotap header with a length we can use */
+	/* we now know there is a radiotap header with a length we can use */
 	len_rthdr = ieee80211_get_radiotap_len(skb->data);
 
-	/* does the skb contain enough to deliver on the alleged length? */
-	if (unlikely(skb->len < len_rthdr))
-		goto fail; /* skb too short for claimed rt header extent */
-
 	/*
 	 * fix up the pointers accounting for the radiotap
 	 * header still being in there.  We are being given
@@ -2294,11 +2294,6 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 		skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
 	}
 
-	memset(info, 0, sizeof(*info));
-
-	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
-		      IEEE80211_TX_CTL_INJECTED;
-
 	rcu_read_lock();
 
 	/*
@@ -2361,9 +2356,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 
 	info->band = chandef->chan->band;
 
-	/* process and remove the injection radiotap header */
-	if (!ieee80211_parse_tx_radiotap(local, skb))
-		goto fail_rcu;
+	/* remove the injection radiotap header */
+	skb_pull(skb, len_rthdr);
 
 	ieee80211_xmit(sdata, NULL, skb, 0);
 	rcu_read_unlock();
-- 
2.43.0



