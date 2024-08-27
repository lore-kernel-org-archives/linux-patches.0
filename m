Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B9019F485;
	Tue, 27 Aug 2024 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772076; cv=none; b=p8of0+Fy3fv9B0Sk/C+IMv9GWhZxAWbE+Nak7ktIoC798HwkOM8BkBRf3sKwX3lVmQUT4sB2h8a8hnFVlWHIA2km6xJdAxxUtTWtRyVaT6cK8+Zkuc7/ADIKNq1G65A0qj4cpH0jDCSoeIR8ztQ3KKq9S9rheXypvx36FEnlTDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772076; c=relaxed/simple;
	bh=8ChAghU4OLbtg8biKnMYE+RCUZBytg94tROosmVJPts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fewj4JERvCO7cyWgue+2YAHYyud/fb2AY1VZo0m28heGbpH3Two58BaZn9lHJ8pLT7LEa7wkUgQBZzxjoo6QChRJtPtmXo6Jexy6fBLIZj+m8ZTRUI59nyYMxE46r+22iiHzsOJGLYbIHHbXHt8U94Z+Hs0wJBi+F6pRHP3OF6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TojBMLUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TojBMLUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27768C4FE00;
	Tue, 27 Aug 2024 15:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772076;
	bh=8ChAghU4OLbtg8biKnMYE+RCUZBytg94tROosmVJPts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TojBMLUykWQntsYGaS6nJDIBSiVLOD5tAEE68K/gipC6bWoN1LltvH9f79MLJ4XtW
	 QUdlfdx2byJFt7aF+kUz0Z65f6cKb1kkL51DR8ByiuHCwFHaU77Pid4P2ORpxtrH2C
	 Zx2s/AsxXqhzE0wG44XNDG4cH+bO1RsWaAX+jYCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/321] wifi: cfg80211: factor out bridge tunnel / RFC1042 header check
Date: Tue, 27 Aug 2024 16:36:12 +0200
Message-ID: <20240827143840.674333067@linuxfoundation.org>
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

[ Upstream commit 9f718554e7eacea62d3f972cae24d969755bf3b6 ]

The same check is done in multiple places, unify it.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230213100855.34315-2-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 9ad797485692 ("wifi: cfg80211: check A-MSDU format more carefully")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 4680e65460c85..8597694a0cfdb 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -542,6 +542,21 @@ unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 }
 EXPORT_SYMBOL(ieee80211_get_mesh_hdrlen);
 
+static bool ieee80211_get_8023_tunnel_proto(const void *hdr, __be16 *proto)
+{
+	const __be16 *hdr_proto = hdr + ETH_ALEN;
+
+	if (!(ether_addr_equal(hdr, rfc1042_header) &&
+	      *hdr_proto != htons(ETH_P_AARP) &&
+	      *hdr_proto != htons(ETH_P_IPX)) &&
+	    !ether_addr_equal(hdr, bridge_tunnel_header))
+		return false;
+
+	*proto = *hdr_proto;
+
+	return true;
+}
+
 int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 				  const u8 *addr, enum nl80211_iftype iftype,
 				  u8 data_offset, bool is_amsdu)
@@ -633,14 +648,9 @@ int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 
 	if (likely(!is_amsdu &&
 		   skb_copy_bits(skb, hdrlen, &payload, sizeof(payload)) == 0 &&
-	           ((ether_addr_equal(payload.hdr, rfc1042_header) &&
-		     payload.proto != htons(ETH_P_AARP) &&
-		     payload.proto != htons(ETH_P_IPX)) ||
-		    ether_addr_equal(payload.hdr, bridge_tunnel_header)))) {
-		/* remove RFC1042 or Bridge-Tunnel encapsulation and
-		 * replace EtherType */
+		   ieee80211_get_8023_tunnel_proto(&payload, &tmp.h_proto))) {
+		/* remove RFC1042 or Bridge-Tunnel encapsulation */
 		hdrlen += ETH_ALEN + 2;
-		tmp.h_proto = payload.proto;
 		skb_postpull_rcsum(skb, &payload, ETH_ALEN + 2);
 	} else {
 		tmp.h_proto = htons(skb->len - hdrlen);
@@ -756,8 +766,6 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 {
 	unsigned int hlen = ALIGN(extra_headroom, 4);
 	struct sk_buff *frame = NULL;
-	u16 ethertype;
-	u8 *payload;
 	int offset = 0, remaining;
 	struct ethhdr eth;
 	bool reuse_frag = skb->head_frag && !skb_has_frag_list(skb);
@@ -811,14 +819,8 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 		frame->dev = skb->dev;
 		frame->priority = skb->priority;
 
-		payload = frame->data;
-		ethertype = (payload[6] << 8) | payload[7];
-		if (likely((ether_addr_equal(payload, rfc1042_header) &&
-			    ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
-			   ether_addr_equal(payload, bridge_tunnel_header))) {
-			eth.h_proto = htons(ethertype);
+		if (likely(ieee80211_get_8023_tunnel_proto(frame->data, &eth.h_proto)))
 			skb_pull(frame, ETH_ALEN + 2);
-		}
 
 		memcpy(skb_push(frame, sizeof(eth)), &eth, sizeof(eth));
 		__skb_queue_tail(list, frame);
-- 
2.43.0



