Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021295;
	b=Iyh8f7dwCDVdTEJ+7gTvWLwf0KzU+PnF8I8tyM8MEukEghMmSgPZD9et4F0cMC4OgJBZ
	 mQaNJ1iXCj4tEJJoT2iHVu4oirFMz4cVjOutP4ZfHc32CkgMwByTm5blQ4RA8Yr4hNsiF
	 trOb3NO2uwaNQU/nYICIgfdBaA4Ibel5Xjx9/vs50NP4JCoLUaTAzR6gsEhAPN/UJyTAg
	 ZxQ77ZyIYW57xGq3TfEAYyhOovgnQI2G7C0j14UWydGgZg1KXmvtkrqn3545xmSPWCNXH
	 NCoUy90kEtNTq6MfClE9nMkUWe0fljphqRxhobk3pd8p5bHQ5h9KnNFfTm3bw7AtGkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BwvrskVdUZJLm7c9HvgExe7gLeINoxJUZ/ElPW53/5I=;
	b=sqpioU8bSNjhikcZMhNKLfgpPE2gKxEqf6oWzlcOeCkJMzKXf3ELDGHy5mJiRTddiEAD
	 oSw18/fKXS21gnMjuJOPrSIwsJ1sjUoT6oMBhT7qS0wwPRw2sx/WA4VH/+Gss5JBjXXA2
	 QizP+jaogurgHeB+xnYZaNQCu6f9QHZ+C7fvYmdjMveNf1HVsOUQi+LFhU3lDBzUovGwB
	 3oEGFfyODaJwA7gJYuawH1DxaqjPoo8BeSpZbqGq99zIow4piQZRBaKgV28jGEjAtIhLp
	 7Q3SYvF/a7OKRdsqlj1mPrYKWLL4HCkW8MqgDYUw45P6KfIA7B5U0KzyFYT3LZ/KP5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngQDM0x3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E344606A32A;
	Wed, 18 Nov 2026 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngQDM0x3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11C71F000C4;
	Wed, 18 Nov 2026 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021295;
	bh=BwvrskVdUZJLm7c9HvgExe7gLeINoxJUZ/ElPW53/5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngQDM0x37Uae+7oH5e1d+duvqNAn1HNaqJqzcU2eaQZI54dTrz+NkZChnezOmUVEm
	 ++FHuU0YsP4DHSmyT1YiaK3Jm/SK6FrmQbwNGmzPaaPcwqoOairv4L3X3h9APzW0VT
	 C7nBwpF31X1pRs0I9Aue0yDczquHl5BJJQMCwcx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2256/2651] net: bcmasp: account for offload header in TX short packet padding
Date: Wed, 18 Nov 2026 15:58:16 +0100
Message-ID: <20261118150406.641651029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 693e8cdfe9604..a855e637b6f01 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -236,7 +236,7 @@ static struct sk_buff *bcmasp_csum_offload(struct net_device *dev,
 static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bcmasp_intf *intf = netdev_priv(dev);
-	unsigned int total_bytes, size;
+	unsigned int total_bytes, size, min_size;
 	int spb_index, nr_frags, i, j;
 	struct bcmasp_tx_cb *txcb;
 	dma_addr_t mapping, valid;
@@ -262,16 +262,21 @@ static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
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



