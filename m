Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032568;
	b=5mdUVA/rkM7z4GgPFweiYNqPG0Gui7WEaIHAFGT0lAXfTOj+PozZjcWkGk/k+3OskwVb
	 R86pwFBypjNFqzY3VN+Lat3PKZtHP7Ycy3bcN7wFUtjPNoDUYpHdAhZZSsVVfIcNOHt5e
	 M43rn4LInJhpQAln2NsT4umetcdW9Dopr5E+VeyNIUP5ylADXCIrPdX8nnfy82F+Y78a4
	 U9cf9vmpZmDGqulTwC8SxFpXFXxG+7SXYY8Pe8zHIAWzC7nZBq9pQKSA1EvStw+lDvb+J
	 m7FuDtSM04L0TDLc7uZo7WiuksoUmNa15pCiZTn1tAhsMHxghVyxVaAGJcVVY7k3gTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c4SUgEZgykfm0R2rNDlmvXAGvcHT408N2fzWYZqz7SM=;
	b=GvYywo6xv1NmIdD9Go/fB5mTDx5Qrki6+ADwpGMapBZe5wJNeLNpBffeOYAp5regVDcC
	 on7NmD5+8d77tZh7gGJylCXMZslCEYq003V6QMCVfx+BpSjU5/t4yMtYEF0ic+FuRxtK6
	 zqZgYIoLFFBBzTgLZh2rd3ZZnD1nWzkG2kZFNzxYVj0Q7xRCG1ecQWcYDxv8rORtLvLu1
	 CGj4hHBGISQaNhVP87DygKQ7mRzFYcMuW75DoV1qUKNERkSrmaD5PFfeXG7LqGiyQsExP
	 tQLxTb4W+2CXQF3A7u322sWv9QNCYD8F2UcYlw16bWC50SmboqB69Ge6zWWnMBdX6Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OGvI7ERT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F1F606A325;
	Wed, 18 Nov 2026 20:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OGvI7ERT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3BE1F000C4;
	Wed, 18 Nov 2026 20:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032568;
	bh=c4SUgEZgykfm0R2rNDlmvXAGvcHT408N2fzWYZqz7SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGvI7ERTAS4x+mqLy/5pyYRX4elNUzeKZest0ZkYI/VMAHI9F4Kie/iuNN3t8ybBm
	 giQBOJxHMtDpnTNMrA1kXKbuv1YAitRhuMfhjRFXdrMtdBeSi+gdQZlR+zq1EX2Rw1
	 X6T3y25IpVIsRbaUDP9VUv5DYbN+2fVMf5mtAnCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1455/1756] net: bcmasp: account for offload header in TX short packet padding
Date: Wed, 18 Nov 2026 15:59:42 +0100
Message-ID: <20261118150107.015157791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d44662063f1b0..fc5ab2af9d4a0 100644
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



