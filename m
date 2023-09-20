Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A2A2AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6ABC433CB;
	Wed, 20 Sep 2023 12:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211298;
	bh=47QLw4VOeypdYHuLb/OPGynRhOOw+UUUkrnyX5apZd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMUAXxbih4K+/F1j9tvbBy+CKMtpJFSgRB2Pkpl8IlXB3kteoFAMGy1OunxHx2135
	 TZd5PREx3TJOx40Gp327uDq6D3XS/x5QgnpPLOF+MAL/zWuqjGwX2VyMYOyebtEojR
	 9KDiAiz9xTMx3AMPd91FTo8QUAO+whRdy1p+sjQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Polaris Pi <pinkperfect2021@gmail.com>,
	Matthew Wang <matthewmwang@chromium.org>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 041/186] wifi: mwifiex: Fix OOB and integer underflow when rx packets
Date: Wed, 20 Sep 2023 13:29:04 +0200
Message-ID: <20230920112838.431098249@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Polaris Pi <pinkperfect2021@gmail.com>

[ Upstream commit 11958528161731c58e105b501ed60b83a91ea941 ]

Make sure mwifiex_process_mgmt_packet,
mwifiex_process_sta_rx_packet and mwifiex_process_uap_rx_packet,
mwifiex_uap_queue_bridged_pkt and mwifiex_process_rx_packet
not out-of-bounds access the skb->data buffer.

Fixes: 2dbaf751b1de ("mwifiex: report received management frames to cfg80211")
Signed-off-by: Polaris Pi <pinkperfect2021@gmail.com>
Reviewed-by: Matthew Wang <matthewmwang@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230723070741.1544662-1-pinkperfect2021@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/sta_rx.c | 11 ++++++++++-
 .../net/wireless/marvell/mwifiex/uap_txrx.c   | 19 +++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/util.c   | 10 +++++++---
 3 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_rx.c b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
index 00fcbda09349e..a3d716a215ef2 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
@@ -98,6 +98,14 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 	rx_pkt_len = le16_to_cpu(local_rx_pd->rx_pkt_length);
 	rx_pkt_hdr = (void *)local_rx_pd + rx_pkt_off;
 
+	if (sizeof(*rx_pkt_hdr) + rx_pkt_off > skb->len) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "wrong rx packet offset: len=%d, rx_pkt_off=%d\n",
+			    skb->len, rx_pkt_off);
+		priv->stats.rx_dropped++;
+		dev_kfree_skb_any(skb);
+	}
+
 	if ((!memcmp(&rx_pkt_hdr->rfc1042_hdr, bridge_tunnel_header,
 		     sizeof(bridge_tunnel_header))) ||
 	    (!memcmp(&rx_pkt_hdr->rfc1042_hdr, rfc1042_header,
@@ -203,7 +211,8 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 
 	rx_pkt_hdr = (void *)local_rx_pd + rx_pkt_offset;
 
-	if ((rx_pkt_offset + rx_pkt_length) > (u16) skb->len) {
+	if ((rx_pkt_offset + rx_pkt_length) > skb->len ||
+	    sizeof(rx_pkt_hdr->eth803_hdr) + rx_pkt_offset > skb->len) {
 		mwifiex_dbg(adapter, ERROR,
 			    "wrong rx packet: len=%d, rx_pkt_offset=%d, rx_pkt_length=%d\n",
 			    skb->len, rx_pkt_offset, rx_pkt_length);
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
index 1e6a62c69ac52..09243e6d8ba9a 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
@@ -116,6 +116,15 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 		return;
 	}
 
+	if (sizeof(*rx_pkt_hdr) +
+	    le16_to_cpu(uap_rx_pd->rx_pkt_offset) > skb->len) {
+		mwifiex_dbg(adapter, ERROR,
+			    "wrong rx packet offset: len=%d,rx_pkt_offset=%d\n",
+			    skb->len, le16_to_cpu(uap_rx_pd->rx_pkt_offset));
+		priv->stats.rx_dropped++;
+		dev_kfree_skb_any(skb);
+	}
+
 	if ((!memcmp(&rx_pkt_hdr->rfc1042_hdr, bridge_tunnel_header,
 		     sizeof(bridge_tunnel_header))) ||
 	    (!memcmp(&rx_pkt_hdr->rfc1042_hdr, rfc1042_header,
@@ -385,6 +394,16 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 	rx_pkt_type = le16_to_cpu(uap_rx_pd->rx_pkt_type);
 	rx_pkt_hdr = (void *)uap_rx_pd + le16_to_cpu(uap_rx_pd->rx_pkt_offset);
 
+	if (le16_to_cpu(uap_rx_pd->rx_pkt_offset) +
+	    sizeof(rx_pkt_hdr->eth803_hdr) > skb->len) {
+		mwifiex_dbg(adapter, ERROR,
+			    "wrong rx packet for struct ethhdr: len=%d, offset=%d\n",
+			    skb->len, le16_to_cpu(uap_rx_pd->rx_pkt_offset));
+		priv->stats.rx_dropped++;
+		dev_kfree_skb_any(skb);
+		return 0;
+	}
+
 	ether_addr_copy(ta, rx_pkt_hdr->eth803_hdr.h_source);
 
 	if ((le16_to_cpu(uap_rx_pd->rx_pkt_offset) +
diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index 51ccf10f44132..4fccdf01b8a05 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -403,11 +403,15 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 	}
 
 	rx_pd = (struct rxpd *)skb->data;
+	pkt_len = le16_to_cpu(rx_pd->rx_pkt_length);
+	if (pkt_len < sizeof(struct ieee80211_hdr) + sizeof(pkt_len)) {
+		mwifiex_dbg(priv->adapter, ERROR, "invalid rx_pkt_length");
+		return -1;
+	}
 
 	skb_pull(skb, le16_to_cpu(rx_pd->rx_pkt_offset));
 	skb_pull(skb, sizeof(pkt_len));
-
-	pkt_len = le16_to_cpu(rx_pd->rx_pkt_length);
+	pkt_len -= sizeof(pkt_len);
 
 	ieee_hdr = (void *)skb->data;
 	if (ieee80211_is_mgmt(ieee_hdr->frame_control)) {
@@ -420,7 +424,7 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 		skb->data + sizeof(struct ieee80211_hdr),
 		pkt_len - sizeof(struct ieee80211_hdr));
 
-	pkt_len -= ETH_ALEN + sizeof(pkt_len);
+	pkt_len -= ETH_ALEN;
 	rx_pd->rx_pkt_length = cpu_to_le16(pkt_len);
 
 	cfg80211_rx_mgmt(&priv->wdev, priv->roc_cfg.chan.center_freq,
-- 
2.40.1



