Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042174;
	b=qDqub2QVMJp51+3ig+tBsMZkP1VDe4Grv7lOsBsRO/N3pMyevJZzSSn5P0Ds7TiiQAPb
	 8UJAhEo/x6T+bBs5EQRnuHuOZ4h1q66otviPGikCGG5pofK5ILiimb1pswz5iYOxTyKLz
	 9B6gFbmNdta08GF9tbrGU384NBft3XzH+3T73RxcfhD02/YoYmGAUM3SQDcNoBHTbbm1f
	 OluvgGJM8Vq1Sh7F+pgNE83Y2MDOnrM2J4sKmphr5NOvjJOyv7Xl48sj0Kfj2DoJAOjFY
	 xaw4zlbJXsDo+h1e583t1zKqmbwOrzC9VZUjlOo38EflIOzWud/vkDNUA+q4mxyOgqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rp4yind+agSxvhBKGkKQRy4vVl5j2BVAA+pYlwLN3v8=;
	b=WkzfTKsjHPj8dR7lObij3+xIK6vrshiABrSx17Q8WlWfGDS1nxvNa9Auh4Y05tjqdAdl
	 QkXTHYQaA21MqE1re/jrz+l03NkgwWsPGK4ApIP1fkT/UPD8/0nxxdZkLHiT1eOdtOzgy
	 nzsTsr1yXQ4Jccv2Uf8Jwy+c0lLpUPSDr2ftxNUljbEwEWrTr3FCqR7+mcyoNQ2kSI0XR
	 nyqdV7SvWQf5ZLFI9dkBZ7LxVQQdCfcyC8IRFltIhcOco9ZGUUK1fTD7dECnoLLnCCgf2
	 hA+Ksd1j1uwtlMuYCGbiqQF3i6WT+WgYbcTzQu/EKol2MYiPDTEMNugdgPS85ewqPtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzthaHhz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92408606A31C;
	Wed, 18 Nov 2026 22:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzthaHhz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18D91F000C4;
	Wed, 18 Nov 2026 22:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042174;
	bh=Rp4yind+agSxvhBKGkKQRy4vVl5j2BVAA+pYlwLN3v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzthaHhzUWCeBLfqF/O6fhVL+Q2/xDxpFtsS8fRZvv6NOhJtokBX/LqyNT9TjmKS/
	 Z/cId5FGYWKdgCIMoPMob9NUy5D4zxuxQyZk6jYD4Rs0V6KEvv84J5djvtwL3+e9Xa
	 ECTWzgoRtdsfZwQQnQfuBiVUpqmZGafW/6QSfwmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3077/3318] net: bcmasp: account for offload header in TX short packet padding
Date: Wed, 18 Nov 2026 16:01:39 +0100
Message-ID: <20261118150452.393359160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 74667a55122ad2fad88af4fd7672e4c8175c2558 ]

When hardware checksum offload is enabled for an skb,
bcmasp_csum_offload() prepends a struct bcmasp_pkt_offload header
(20 bytes) to the skb via skb_push(). This increases skb->len and
skb_headlen(skb) by sizeof(struct bcmasp_pkt_offload).

Because the hardware descriptor processor strips this offload header
before transmitting the packet on the wire, the wire packet length is
smaller by sizeof(struct bcmasp_pkt_offload). The padding calculation
must account for this extra header; otherwise, short frames are sent on
the wire smaller than the minimum Ethernet frame size (ETH_ZLEN +
ETH_FCS_LEN).

Furthermore, small frames with payload in page fragments (such as small
TCP segments with CHECKSUM_PARTIAL) have nr_frags > 0 and were skipping
padding entirely because the padding check was restricted to
nr_frags == 0.

Perform the padding check on skb->len before the descriptor loop using
skb_put_padto(), adding sizeof(struct bcmasp_pkt_offload) to min_size
when checksum offload is enabled, and re-read nr_frags after padding in
case the skb was linearized.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-6-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/asp2/bcmasp_intf.c    | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 4e9fa6463831a..f5874190dbf64 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -268,7 +268,7 @@ static const struct bcmasp_intf_ops bcmasp_intf_ops = {
 static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bcmasp_intf *intf = netdev_priv(dev);
-	unsigned int total_bytes, size;
+	unsigned int total_bytes, size, min_size;
 	int spb_index, nr_frags, i, j;
 	struct bcmasp_tx_cb *txcb;
 	dma_addr_t mapping, valid;
@@ -294,16 +294,21 @@ static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (!skb)
 		return NETDEV_TX_OK;
 
+	min_size = ETH_ZLEN + ETH_FCS_LEN;
+	if (csum_hw)
+		min_size += sizeof(struct bcmasp_pkt_offload);
+
+	if (skb->len < min_size) {
+		if (skb_put_padto(skb, min_size))
+			return NETDEV_TX_OK;
+		nr_frags = skb_shinfo(skb)->nr_frags;
+	}
+
 	spb_index = intf->tx_spb_index;
 	valid = intf->tx_spb_dma_valid;
 	for (i = 0; i <= nr_frags; i++) {
 		if (!i) {
 			size = skb_headlen(skb);
-			if (!nr_frags && size < (ETH_ZLEN + ETH_FCS_LEN)) {
-				if (skb_put_padto(skb, ETH_ZLEN + ETH_FCS_LEN))
-					return NETDEV_TX_OK;
-				size = skb->len;
-			}
 			mapping = dma_map_single(kdev, skb->data, size,
 						 DMA_TO_DEVICE);
 		} else {
-- 
2.53.0



