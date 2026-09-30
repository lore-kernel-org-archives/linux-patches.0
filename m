Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827E94DDB23;
	Wed, 30 Sep 2026 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787366; cv=none; b=SvX0ien43N7NAFeCJ3M0JtYLWbkBpnnD29znVLaZcHZPcg1LDenzCgxl/w8INnDXrJ9PoyYlFCCYnjkgLUIA+hjrQgkiqzK8Y2hIVWLWWsKXsUaYmS6X72b0fPG3kdWlCbeY+wz5LnO0PLjHCqXcTXKt5XUm+HbBHBrCRFIvsII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787366; c=relaxed/simple;
	bh=PcNFbjauUsYh+2ckrMs7pWhCupyfDYwY0/44nZ7noG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezt/s8LZmxlu1CuZwaeOFQztVhwLuQ+X7dk+X4DZ2noNNzXB5AVUvKAcipvqowWc8tflksM9tRcIBm+iBj4ZtsX7G1HW6143GsqrzvDcVAkcCYUGcohq6pKUDWq6kYgyvUOcgossBBxYTxPsJejrrcRNJ4cj6mAVUWKS0QlzH+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XycgtH7K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XycgtH7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A891F000FF;
	Wed, 30 Sep 2026 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787365;
	bh=9Ne9DK3UdCyKqocP45o397B6cMIhuxFLRcw7TpFzuTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XycgtH7KYrAQLjpR9DgX1/0BRANdMsxc1f19mn7a0y6/rnEcMAa3TbCv+tngLIMlJ
	 JNiqHK8xW37km8r0F7u0TwLZACDfnnoyjwC7oJiPaIvZ/eNvCWW6GvYqe4Cd9u2zk4
	 /bT4U4/IpvAyH0VhTTtNxODNI0ElG3jj1YZchO3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 160/457] net: stmmac: selftests: Capture all packets for vlan checks
Date: Wed, 30 Sep 2026 17:24:25 +0200
Message-ID: <20260930152349.502583915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 960db6f65788c21249ea04a947d5c01e38d19294 ]

While we use vlan_vid_add to trigger the tag filtering machinery
in the driver, there's no netdev associated to the VLAN. This causes the
skb to arrive with empty skb->vlan_tci fields, as the packet is marked
OTHERHOST in __netif_receive_skb_core(), and we fail our validation.

Let's use the proxy mechanism introduced for DSA, that registers a
ETH_P_ALL packet handler that runs earlier, before the vlan netdev
lookup, then filters for the correct ethertype before passing an skb
clone to our validation function.

As we may receive external frames with the right tag from the outside,
let's move the address check in the vlan validation function earlier.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260917215339.2022523-5-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../stmicro/stmmac/stmmac_selftests.c         | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 53bb911b69ffb..b3b05a7753335 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -243,6 +243,7 @@ struct stmmac_test_priv {
 	__be16 packet_type;
 	int (*func)(struct sk_buff *skb, struct net_device *ndev,
 		    struct packet_type *pt, struct net_device *orig_ndev);
+	bool capture_all;
 	int double_vlan;
 	int vlan_id;
 	int ok;
@@ -345,13 +346,15 @@ static void stmmac_sft_add_pack(struct packet_type *pt)
 {
 	struct stmmac_test_priv *tpriv = pt->af_packet_priv;
 
-	if (netdev_uses_dsa(tpriv->pt.dev)) {
+	if (netdev_uses_dsa(tpriv->pt.dev) || tpriv->capture_all) {
 		tpriv->packet_type = tpriv->pt.type;
 		tpriv->func = tpriv->pt.func;
 
 		/* DSA conduit will report ETH_P_XDSA, so our packet handler
 		 * won't match. Let's register a ETH_P_ALL match and filter
-		 * manually in stmmac_sft_filter.
+		 * manually in stmmac_sft_filter. This is also useful for
+		 * VLAN tests, to capture packets otherwise marked as
+		 * OTHERHOST.
 		 */
 		tpriv->pt.type = htons(ETH_P_ALL);
 		tpriv->pt.func = stmmac_sft_filter;
@@ -963,6 +966,11 @@ static int stmmac_test_vlan_validate(struct sk_buff *skb,
 		goto out;
 	if (skb_headlen(skb) < (STMMAC_TEST_PKT_SIZE - ETH_HLEN))
 		goto out;
+
+	ehdr = (struct ethhdr *)skb_mac_header(skb);
+	if (!ether_addr_equal_unaligned(ehdr->h_dest, tpriv->packet->dst))
+		goto out;
+
 	if (tpriv->vlan_id) {
 		if (skb->vlan_proto != htons(proto))
 			goto out;
@@ -974,10 +982,6 @@ static int stmmac_test_vlan_validate(struct sk_buff *skb,
 		}
 	}
 
-	ehdr = (struct ethhdr *)skb_mac_header(skb);
-	if (!ether_addr_equal_unaligned(ehdr->h_dest, tpriv->packet->dst))
-		goto out;
-
 	ihdr = ip_hdr(skb);
 	if (tpriv->double_vlan)
 		ihdr = (struct iphdr *)(skb_network_header(skb) + 4);
@@ -1019,6 +1023,7 @@ static int __stmmac_test_vlanfilt(struct stmmac_priv *priv)
 	tpriv->pt.dev = priv->dev;
 	tpriv->pt.af_packet_priv = tpriv;
 	tpriv->packet = &attr;
+	tpriv->capture_all = true;
 
 	/*
 	 * As we use HASH filtering, false positives may appear. This is a
@@ -1115,6 +1120,7 @@ static int __stmmac_test_dvlanfilt(struct stmmac_priv *priv)
 	tpriv->pt.dev = priv->dev;
 	tpriv->pt.af_packet_priv = tpriv;
 	tpriv->packet = &attr;
+	tpriv->capture_all = true;
 
 	/*
 	 * As we use HASH filtering, false positives may appear. This is a
@@ -1395,6 +1401,7 @@ static int stmmac_test_vlanoff_common(struct stmmac_priv *priv, bool svlan)
 	tpriv->pt.af_packet_priv = tpriv;
 	tpriv->packet = &attr;
 	tpriv->vlan_id = 0x123;
+	tpriv->capture_all = true;
 
 	ret = vlan_vid_add(priv->dev, htons(proto), tpriv->vlan_id);
 	if (ret)
-- 
2.53.0



