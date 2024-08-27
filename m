Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140B11C6F55;
	Tue, 27 Aug 2024 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771932; cv=none; b=OxMVdu70JE2oYWjw13erusNYQ+9YBnsxkk0O9Orf91EObEulJOLCfNdP0JtBSKmS9Y4GM6qKu8BQhcyhZBGwuj8Qi3uv7sJoSOSPO/mIzkYi8gTplHWaFjV1P8DIjFewi08TdnseJpZE9cCVR7aiVKytri3hQyGqUWlY8vyoVe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771932; c=relaxed/simple;
	bh=5WWOconbX6jJZCVnuAhw+VuL7VjuaCaALN6/UtKzB20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZADO3eANthRCv0jhcfqFFr5463y8mVClZq/7QhXb+ZsE1Bl1d0VA+Lzso096/SQIhVFA+9/c6eycyvG+vEAkvc4vv97pmmZmAQ6rNJgZ0BcPELZtJ9sfQ3r5ol7on0aANq5fbqYd1C8LRkUnHWLIBboCs7v6+Bee/aa5LXeLcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8I2hQiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8I2hQiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15187C61067;
	Tue, 27 Aug 2024 15:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771931;
	bh=5WWOconbX6jJZCVnuAhw+VuL7VjuaCaALN6/UtKzB20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8I2hQiqmw9G2JtGbN2mS3DzWdPAWUWO2ShIbQHHfan6o2iPZSZJQyL4948WA5vhN
	 Ixw1bhW4HuB5maMO4qp1JKZ2PwOfZwU0w4KOo//9vpVMdwceWGJTWGdpeXbQRPsBxL
	 8CpD5rOYR8ZlWNLatMyCD83WfbJE1sHq2qfPUFW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/321] wifi: mac80211: fix and simplify unencrypted drop check for mesh
Date: Tue, 27 Aug 2024 16:36:10 +0200
Message-ID: <20240827143840.597294089@linuxfoundation.org>
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

[ Upstream commit 94b9b9de05b62ac54d8766caa9865fb4d82cc47e ]

ieee80211_drop_unencrypted is called from ieee80211_rx_h_mesh_fwding and
ieee80211_frame_allowed.

Since ieee80211_rx_h_mesh_fwding can forward packets for other mesh nodes
and is called earlier, it needs to check the decryptions status and if the
packet is using the control protocol on its own, instead of deferring to
the later call from ieee80211_frame_allowed.

Because of that, ieee80211_drop_unencrypted has a mesh specific check
that skips over the mesh header in order to check the payload protocol.
This code is invalid when called from ieee80211_frame_allowed, since that
happens after the 802.11->802.3 conversion.

Fix this by moving the mesh specific check directly into
ieee80211_rx_h_mesh_fwding.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20221201135730.19723-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 9ad797485692 ("wifi: cfg80211: check A-MSDU format more carefully")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c4c80037df91d..b68a9200403e7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2408,7 +2408,6 @@ static int ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
 
 static int ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
 {
-	struct ieee80211_hdr *hdr = (void *)rx->skb->data;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
@@ -2419,31 +2418,6 @@ static int ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
 	if (status->flag & RX_FLAG_DECRYPTED)
 		return 0;
 
-	/* check mesh EAPOL frames first */
-	if (unlikely(rx->sta && ieee80211_vif_is_mesh(&rx->sdata->vif) &&
-		     ieee80211_is_data(fc))) {
-		struct ieee80211s_hdr *mesh_hdr;
-		u16 hdr_len = ieee80211_hdrlen(fc);
-		u16 ethertype_offset;
-		__be16 ethertype;
-
-		if (!ether_addr_equal(hdr->addr1, rx->sdata->vif.addr))
-			goto drop_check;
-
-		/* make sure fixed part of mesh header is there, also checks skb len */
-		if (!pskb_may_pull(rx->skb, hdr_len + 6))
-			goto drop_check;
-
-		mesh_hdr = (struct ieee80211s_hdr *)(skb->data + hdr_len);
-		ethertype_offset = hdr_len + ieee80211_get_mesh_hdrlen(mesh_hdr) +
-				   sizeof(rfc1042_header);
-
-		if (skb_copy_bits(rx->skb, ethertype_offset, &ethertype, 2) == 0 &&
-		    ethertype == rx->sdata->control_port_protocol)
-			return 0;
-	}
-
-drop_check:
 	/* Drop unencrypted frames if key is set. */
 	if (unlikely(!ieee80211_has_protected(fc) &&
 		     !ieee80211_is_any_nullfunc(fc) &&
@@ -2897,8 +2871,16 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	hdr = (struct ieee80211_hdr *) skb->data;
 	mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
 
-	if (ieee80211_drop_unencrypted(rx, hdr->frame_control))
-		return RX_DROP_MONITOR;
+	if (ieee80211_drop_unencrypted(rx, hdr->frame_control)) {
+		int offset = hdrlen + ieee80211_get_mesh_hdrlen(mesh_hdr) +
+			     sizeof(rfc1042_header);
+		__be16 ethertype;
+
+		if (!ether_addr_equal(hdr->addr1, rx->sdata->vif.addr) ||
+		    skb_copy_bits(rx->skb, offset, &ethertype, 2) != 0 ||
+		    ethertype != rx->sdata->control_port_protocol)
+			return RX_DROP_MONITOR;
+	}
 
 	/* frame is in RMC, don't forward */
 	if (ieee80211_is_data(hdr->frame_control) &&
-- 
2.43.0



