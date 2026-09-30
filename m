Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4031E3BE642;
	Wed, 30 Sep 2026 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792416; cv=none; b=YEOhTsXvH31n0JpRk7x6iOLjLXBPTP91ryoGsgk/IOE5acUoa7nryiNkxtTqUJOCT4Tt30CgvRlR0/qclpJjY1EWRhtmwq/xfFseAGxb5akSp8CRZAacZXcc6ZJaP35BIc/poM2ozo/54Qtly7CYKFf5TzDEzVX6uWMEABbhOXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792416; c=relaxed/simple;
	bh=6WPzfQNhvIRiOOlmZHRRwqrzHrfnWR0LdnFrRDH5y0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfGxPrZ+ryNJ9FLNQd99eu/B+VmqRNXnNnS43j2YtoWaZYufCTtrJRTC6FVFkJX3jMjHrjdXKqUS1JESTg1kgDzjahn0g+OAyHRdlpijU7lGa/TP+8gSaWMVAt4qeetnwjJWAHaqmNLjsS/0tA0vO5gbK9Tvs0Ed/XiiOQB/Tds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVcxt6cX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVcxt6cX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECA81F000FF;
	Wed, 30 Sep 2026 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792415;
	bh=b6SduS7oTaQXeOqXAFtQ+/MHiKtDhHRgJG7YjMf1U28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SVcxt6cXfk18/Al3+0XBU/VwqkgJHXorAP8HYGAEt74e3ASUOiUG4OGI6gMy8IQuB
	 lULzYV1xvyA6Wuxi4TtjRQBYn4dGVFmXRVN1DCe+WFChwQzNDNYDiR4yXhG9jbvpBZ
	 +or4xSDUwWEznB9QkQ+1Jg9IbjxeHLyO98uaLZEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 645/752] net: stmmac: selftests: Capture all packets for vlan checks
Date: Wed, 30 Sep 2026 17:28:35 +0200
Message-ID: <20260930152412.222305018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dd6ef393b1966..5b1610e427e02 100644
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



