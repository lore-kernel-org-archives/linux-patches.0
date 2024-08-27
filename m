Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2A71CFBC;
	Tue, 27 Aug 2024 15:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772037; cv=none; b=KWFTwDx4Qb0ZJpunr0izJoSUW+fte3KEXCZAuZqEJHHY+pDt+4NsGyX0ZtC082x7hBPtVZfiH/n+iJ/r+qLWQQFcf/gYLe3uw69e80/yHknEHZUh5ssFYU+Ha+azrmbW14gh3g2OoYTt6V2jf7k+KsnS6orT/K26U9wl+n2Ar+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772037; c=relaxed/simple;
	bh=oVwtgDR9A3V98KPbFSPxqPTYQpP/M1/diEUv5K6wNzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLQ9Kse45vZKAauRitrQfRasaY+aDKtsY0V6jvs3ox2SfP5YknGeDXt1bsgDb+ae3BxX4uYDYj5lbDiAhVoaZTT5vdTzIsZhkyj2g9z06rgR2vTDPSBg1OVXZRfwjnoB4emRneI9xlPqkn+c5ks5Wro2FoX7V51SeYNpfaUEMZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nO1hRj/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nO1hRj/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BC2C4DDFC;
	Tue, 27 Aug 2024 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772037;
	bh=oVwtgDR9A3V98KPbFSPxqPTYQpP/M1/diEUv5K6wNzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nO1hRj/Dqb/BClUY3I2oZPuqF1W7ZPuvwBz2+wjprtVkAP2XUKzUo38cFIobeeJ+5
	 PhvR5dpyNflxtkkJSiSLkfFKbvhN1JI1maoExlBkG54EOezeurtrUirKQpXS0N8Wpn
	 KPPa52/P8Lp+931euw/TwPTLygN1YpVBCAA0nTAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/321] wifi: mac80211: add a workaround for receiving non-standard mesh A-MSDU
Date: Tue, 27 Aug 2024 16:36:15 +0200
Message-ID: <20240827143840.790310485@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 6e4c0d0460bd32ca9244dff3ba2d2da27235de11 ]

At least ath10k and ath11k supported hardware (maybe more) does not implement
mesh A-MSDU aggregation in a standard compliant way.
802.11-2020 9.3.2.2.2 declares that the Mesh Control field is part of the
A-MSDU header (and little-endian).
As such, its length must not be included in the subframe length field.
Hardware affected by this bug treats the mesh control field as part of the
MSDU data and sets the length accordingly.
In order to avoid packet loss, keep track of which stations are affected
by this and take it into account when converting A-MSDU to 802.3 + mesh control
packets.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230213100855.34315-5-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 9ad797485692 ("wifi: cfg80211: check A-MSDU format more carefully")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h  | 13 +++++++++++++
 net/mac80211/rx.c       | 15 ++++++++++++---
 net/mac80211/sta_info.c |  3 +++
 net/mac80211/sta_info.h |  1 +
 net/wireless/util.c     | 32 ++++++++++++++++++++++++++++++++
 5 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c2f7d01b3a16e..2a0fc4a64af1e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6301,6 +6301,19 @@ static inline int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 	return ieee80211_data_to_8023_exthdr(skb, NULL, addr, iftype, 0, false);
 }
 
+/**
+ * ieee80211_is_valid_amsdu - check if subframe lengths of an A-MSDU are valid
+ *
+ * This is used to detect non-standard A-MSDU frames, e.g. the ones generated
+ * by ath10k and ath11k, where the subframe length includes the length of the
+ * mesh control field.
+ *
+ * @skb: The input A-MSDU frame without any headers.
+ * @mesh_hdr: use standard compliant mesh A-MSDU subframe header
+ * Returns: true if subframe header lengths are valid for the @mesh_hdr mode
+ */
+bool ieee80211_is_valid_amsdu(struct sk_buff *skb, bool mesh_hdr);
+
 /**
  * ieee80211_amsdu_to_8023s - decode an IEEE 802.11n A-MSDU frame
  *
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8d2379944f3de..7cf1444c242d0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2904,7 +2904,6 @@ __ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx, u8 data_offset)
 	static ieee80211_rx_result res;
 	struct ethhdr ethhdr;
 	const u8 *check_da = ethhdr.h_dest, *check_sa = ethhdr.h_source;
-	bool mesh = false;
 
 	if (unlikely(ieee80211_has_a4(hdr->frame_control))) {
 		check_da = NULL;
@@ -2922,7 +2921,6 @@ __ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx, u8 data_offset)
 		case NL80211_IFTYPE_MESH_POINT:
 			check_sa = NULL;
 			check_da = NULL;
-			mesh = true;
 			break;
 		default:
 			break;
@@ -2937,10 +2935,21 @@ __ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx, u8 data_offset)
 					  data_offset, true))
 		return RX_DROP_UNUSABLE;
 
+	if (rx->sta && rx->sta->amsdu_mesh_control < 0) {
+		bool valid_std = ieee80211_is_valid_amsdu(skb, true);
+		bool valid_nonstd = ieee80211_is_valid_amsdu(skb, false);
+
+		if (valid_std && !valid_nonstd)
+			rx->sta->amsdu_mesh_control = 1;
+		else if (valid_nonstd && !valid_std)
+			rx->sta->amsdu_mesh_control = 0;
+	}
+
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
 				 rx->sdata->vif.type,
 				 rx->local->hw.extra_tx_headroom,
-				 check_da, check_sa, mesh);
+				 check_da, check_sa,
+				 rx->sta->amsdu_mesh_control);
 
 	while (!skb_queue_empty(&frame_list)) {
 		rx->skb = __skb_dequeue(&frame_list);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f388b39531748..91768abf2d75b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -594,6 +594,9 @@ __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	sta->sta_state = IEEE80211_STA_NONE;
 
+	if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+		sta->amsdu_mesh_control = -1;
+
 	/* Mark TID as unreserved */
 	sta->reserved_tid = IEEE80211_TID_UNRESERVED;
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4809756a43dd1..dbf441a0ac6b6 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -706,6 +706,7 @@ struct sta_info {
 	struct codel_params cparams;
 
 	u8 reserved_tid;
+	s8 amsdu_mesh_control;
 
 	struct cfg80211_chan_def tdls_chandef;
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 61a76f31fac89..4cf17c3c18392 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -776,6 +776,38 @@ __ieee80211_amsdu_copy(struct sk_buff *skb, unsigned int hlen,
 	return frame;
 }
 
+bool ieee80211_is_valid_amsdu(struct sk_buff *skb, bool mesh_hdr)
+{
+	int offset = 0, remaining, subframe_len, padding;
+
+	for (offset = 0; offset < skb->len; offset += subframe_len + padding) {
+		struct {
+		    __be16 len;
+		    u8 mesh_flags;
+		} hdr;
+		u16 len;
+
+		if (skb_copy_bits(skb, offset + 2 * ETH_ALEN, &hdr, sizeof(hdr)) < 0)
+			return false;
+
+		if (mesh_hdr)
+			len = le16_to_cpu(*(__le16 *)&hdr.len) +
+			      __ieee80211_get_mesh_hdrlen(hdr.mesh_flags);
+		else
+			len = ntohs(hdr.len);
+
+		subframe_len = sizeof(struct ethhdr) + len;
+		padding = (4 - subframe_len) & 0x3;
+		remaining = skb->len - offset;
+
+		if (subframe_len > remaining)
+			return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(ieee80211_is_valid_amsdu);
+
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			      const u8 *addr, enum nl80211_iftype iftype,
 			      const unsigned int extra_headroom,
-- 
2.43.0



