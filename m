Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B95C51B196;
	Wed, 30 Sep 2026 18:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793097; cv=none; b=VarXIoiNkLXZcn+HL6srBexR7Fp+qA7q03qrRV/7Rkbmaot9j9WWRII25RvL9RPP2YmdQWhT+B6SqRTJNCTllpjRlEAEOOaWc6tXa/Hx+/dji+DZvH1nWGpJ3yf0AX2AeWTKGEvQVXUnrfKWGDNHxOT6u1JKHgDniacAgBN1iY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793097; c=relaxed/simple;
	bh=EVcCxavDYqOp+GCMPej9PwjGthypybBIDnAuv9+kO4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fz7A665INhKrdJKl6ilxhjyZoiBsIuPoGnr9EnzvpqwjU5V5ri4Dr7At8sIz/u6Jp7eEIN7gMAMHVRUh017pbgMMZnvS6NBZu6Oy200JrgoCtnH/FEYe9FMbJYg1pvY+d8ziVibFj9LMnoz8VzHO+dJAHvTtFKgLqL0wp5dtonY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfVWP3yo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfVWP3yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593BD1F000FF;
	Wed, 30 Sep 2026 18:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793095;
	bh=JQrfal/bhXnblXSOo0ENWxe8Rai57O3GbzP2AiVVfXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AfVWP3yoxgqOSpBW1M0sgX6tJ6+bxhuWaVpDzDbQwN8ZTdEAVT1yYu4kT6MPp3BJK
	 7pPH+EuMC6JOjnjN+I5+9a0j3L2xFpgFm8PJ78NnVTQ61uc0hIXMzM56CYMt6MLTb7
	 6CFsDA5zZSPymY6Zr7/2UvLPTnkwI+lDD1DVxFa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/395] net: stmmac: selftests: Capture all packets for vlan checks
Date: Wed, 30 Sep 2026 17:26:37 +0200
Message-ID: <20260930152343.574083033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index 71455457b0f3c..bd92d5b051953 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -242,6 +242,7 @@ struct stmmac_test_priv {
 	__be16 packet_type;
 	int (*func)(struct sk_buff *skb, struct net_device *ndev,
 		    struct packet_type *pt, struct net_device *orig_ndev);
+	bool capture_all;
 	int double_vlan;
 	int vlan_id;
 	int ok;
@@ -344,13 +345,15 @@ static void stmmac_sft_add_pack(struct packet_type *pt)
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
@@ -923,6 +926,11 @@ static int stmmac_test_vlan_validate(struct sk_buff *skb,
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
@@ -934,10 +942,6 @@ static int stmmac_test_vlan_validate(struct sk_buff *skb,
 		}
 	}
 
-	ehdr = (struct ethhdr *)skb_mac_header(skb);
-	if (!ether_addr_equal_unaligned(ehdr->h_dest, tpriv->packet->dst))
-		goto out;
-
 	ihdr = ip_hdr(skb);
 	if (tpriv->double_vlan)
 		ihdr = (struct iphdr *)(skb_network_header(skb) + 4);
@@ -979,6 +983,7 @@ static int __stmmac_test_vlanfilt(struct stmmac_priv *priv)
 	tpriv->pt.dev = priv->dev;
 	tpriv->pt.af_packet_priv = tpriv;
 	tpriv->packet = &attr;
+	tpriv->capture_all = true;
 
 	/*
 	 * As we use HASH filtering, false positives may appear. This is a
@@ -1075,6 +1080,7 @@ static int __stmmac_test_dvlanfilt(struct stmmac_priv *priv)
 	tpriv->pt.dev = priv->dev;
 	tpriv->pt.af_packet_priv = tpriv;
 	tpriv->packet = &attr;
+	tpriv->capture_all = true;
 
 	/*
 	 * As we use HASH filtering, false positives may appear. This is a
@@ -1355,6 +1361,7 @@ static int stmmac_test_vlanoff_common(struct stmmac_priv *priv, bool svlan)
 	tpriv->pt.af_packet_priv = tpriv;
 	tpriv->packet = &attr;
 	tpriv->vlan_id = 0x123;
+	tpriv->capture_all = true;
 
 	ret = vlan_vid_add(priv->dev, htons(proto), tpriv->vlan_id);
 	if (ret)
-- 
2.53.0



