Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621165;
	b=XOLqSNkn4UCR8AYp1WOYs/dHFHrMfj8/1tknttxAb3Fo6aaiSdkqbTTgrOyqurStwAB8
	 UG3rzWwFigDRq8cLYS7xGZKLWR3ynIPBT3wfCO1fUpAcklVO5zKliY3bnWASp3PDq9dp4
	 yf2z7D1TXOICbZS6C5VW2wnIzEucNAYj3vGVKBqaHXWxAdRn78BkBT4rfWTaAr5XdRoSS
	 +GxGNQt4pAAztVkmTn4QKIZ4RM78be2kH2jAXmkwjpDH/NlvdPaDq2W8PIcGM4/Zk5UrY
	 BoIXzxrcH5J4xwvxX7/HaMCU98id8QT41ZoZDNHW6C7HXp2aaTw0mXaZhaExrLtd6XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=100AttQis0PcnKGqn3zsNsMINApdAxXF5/bZMWv1S4I=;
	b=ZhWtRMYI6vXqPy/0b2fio02OJA00HuK+yejNHn21Bro/u6D/xhaAcj4SH6F1kcIHNezu
	 KkW1bTKOdperUdW4wb85FtlTGFNUYjgplF6BeMI9nqobeEIa+8slik/+FurNW7WlZaTUq
	 jrCEDzG5NG5Ou6pAJu7D7Cl08kjRP4ckFW1PEuGmypM+mdeMU0ECk2q+mz9xtm7MYJ5aT
	 LzMbEa/B8hnyfERzd8Qi50nuVYQ7BiFSPqtWXCWA5JwGwjEs19zQv1Xt0Pj5q11s2gq5v
	 NW/s/JA8nXsa9nLBxsdse6rDd2p9U+7KdmwYR0/uOBNTBm1MviEAO291CmLOB+CjThA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lRSMWp0J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01907606A6B9;
	Wed, 25 Nov 2026 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lRSMWp0J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011841F000C4;
	Wed, 25 Nov 2026 15:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621164;
	bh=100AttQis0PcnKGqn3zsNsMINApdAxXF5/bZMWv1S4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRSMWp0JmI8pCi2+0ZvNip56l5KB4gYPkTtmleuFVmxigYG7/y5FHFRC4lhLq8EMz
	 IqrSG1i/WaoBqRb0Vu0C50Q1c5RbKzZZUAndjzRILEeIcdVzEyf1N1NYj1hVYPXClk
	 BNHM/e2p143zpUzn4JpHG4KHxydoUkI5FGZOZrAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/990] net: stmmac: fix VLAN tag stripping on short and non-linear RX frames
Date: Wed, 25 Nov 2026 15:25:08 +0100
Message-ID: <20261125143825.388065953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 68bdbffcae08699af5c16f7a2ec61a5489b78dbe ]

stmmac_rx_vlan() reads the VLAN header straight from skb->data and
removes it with skb_pull(), assuming the header is fully present in the
linear part of the skb. XDP can change the frame length and head layout
before the tag is stripped.

An XDP program can use bpf_xdp_adjust_tail() to shrink a frame to as
little as ETH_HLEN while bytes 12-13 still contain a VLAN ethertype. The
driver then reads h_vlan_TCI past skb->len and pops the tag, leaving less
than ETH_HLEN in the skb. eth_type_trans() cannot pull the MAC header, so
a malformed skb is passed up. The TCI is also read from the wrong place
when the tag is not fully in the linear head, e.g. when it spans into a
frag.

Read h_vlan_proto after pulling ETH_HLEN into the linear part, and check
it together with the device features. Only if the tag is actually going
to be popped, pull VLAN_ETH_HLEN and re-derive the header pointer
afterwards, as pskb_may_pull() may reallocate the skb head. Return an
error so the callers can drop a frame that claims a VLAN tag but cannot
provide the full header. This also drops and counts frames shorter than
ETH_HLEN in rx_dropped, even when VLAN RX offload is disabled;
bpf_xdp_adjust_head() and bpf_xdp_adjust_tail() cannot produce such a
frame, so it only affects a runt that reaches the driver, and dropping it
is safer than handing it to eth_type_trans().

Also move the XDP metadata written with bpf_xdp_adjust_meta() together
with the MAC header when the tag is popped, so data_meta still points at
the metadata after eth_type_trans() anchors mac_header, instead of at the
first bytes of the destination MAC.

Fixes: 5fabb01207a2 ("net: stmmac: Add initial XDP support")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-stmmac-xdp-fixes-v2-5-10eae8a093a8@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 48 +++++++++++++------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4d5e3ec64dfa5..123f2415e745e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4832,22 +4832,35 @@ static netdev_features_t stmmac_features_check(struct sk_buff *skb,
 	return vlan_features_check(skb, features);
 }
 
-static void stmmac_rx_vlan(struct net_device *dev, struct sk_buff *skb)
+static int stmmac_rx_vlan(struct net_device *dev, struct sk_buff *skb)
 {
-	struct vlan_ethhdr *veth = skb_vlan_eth_hdr(skb);
-	__be16 vlan_proto = veth->h_vlan_proto;
-	u16 vlanid;
+	struct vlan_ethhdr *veth;
 
-	if ((vlan_proto == htons(ETH_P_8021Q) &&
+	if (!pskb_may_pull(skb, ETH_HLEN))
+		return -EINVAL;
+
+	veth = skb_vlan_eth_hdr(skb);
+	if ((veth->h_vlan_proto == htons(ETH_P_8021Q) &&
 	     dev->features & NETIF_F_HW_VLAN_CTAG_RX) ||
-	    (vlan_proto == htons(ETH_P_8021AD) &&
+	    (veth->h_vlan_proto == htons(ETH_P_8021AD) &&
 	     dev->features & NETIF_F_HW_VLAN_STAG_RX)) {
+		__be16 vlan_proto = veth->h_vlan_proto;
+		u8 meta_len = skb_metadata_len(skb);
+		u16 vlanid;
+
 		/* pop the vlan tag */
+		if (!pskb_may_pull(skb, VLAN_ETH_HLEN))
+			return -EINVAL;
+
+		veth = skb_vlan_eth_hdr(skb);
 		vlanid = ntohs(veth->h_vlan_TCI);
-		memmove(skb->data + VLAN_HLEN, veth, ETH_ALEN * 2);
+		memmove(skb->data - meta_len + VLAN_HLEN,
+			skb->data - meta_len, meta_len + ETH_ALEN * 2);
 		skb_pull(skb, VLAN_HLEN);
 		__vlan_hwaccel_put_tag(skb, vlan_proto, vlanid);
 	}
+
+	return 0;
 }
 
 /**
@@ -5228,12 +5241,15 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 	}
 
 	stmmac_get_rx_hwtstamp(priv, p, np, skb);
-	if (priv->hw->hw_vlan_en)
+	if (priv->hw->hw_vlan_en) {
 		/* MAC level stripping. */
 		stmmac_rx_hw_vlan(priv, priv->hw, p, skb);
-	else
-		/* Driver level stripping. */
-		stmmac_rx_vlan(priv->dev, skb);
+	} else if (stmmac_rx_vlan(priv->dev, skb)) {
+		dev_kfree_skb_any(skb);
+		priv->xstats.rx_dropped++;
+		return;
+	}
+
 	skb->protocol = eth_type_trans(skb, priv->dev);
 
 	if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb))
@@ -5785,12 +5801,14 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		stmmac_get_rx_hwtstamp(priv, p, np, skb);
 
-		if (priv->hw->hw_vlan_en)
+		if (priv->hw->hw_vlan_en) {
 			/* MAC level stripping. */
 			stmmac_rx_hw_vlan(priv, priv->hw, p, skb);
-		else
-			/* Driver level stripping. */
-			stmmac_rx_vlan(priv->dev, skb);
+		} else if (stmmac_rx_vlan(priv->dev, skb)) {
+			dev_kfree_skb_any(skb);
+			rx_dropped++;
+			goto next;
+		}
 
 		skb->protocol = eth_type_trans(skb, priv->dev);
 
-- 
2.53.0



