Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6781C37756C;
	Mon,  9 Feb 2026 14:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647205; cv=none; b=tlVpOlTAmGwQZYPxqqg7TNFZCyaz2DJbUVyWHnY7LjLVrh0PYPRtRdUWIzTn4YTDnyaOOfAYe85W4HvUoFKDev8i5J4mJz2QPRmNJtuTItjc4lQt9m+tzjhgsgEFk59Z7GjgQUKdW9WTlOhfQ+IcH3fFtHSGqoao1QXddC56Zko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647205; c=relaxed/simple;
	bh=M3O3iEvQkR/X3xcaL5BWMKaoVIfEaEFbwH8SY0msjw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKepYNBn0vO29DfQDENUobEpyVcxMolmqiLrw/0rbp38dcIphgwWYzsNNDQx+g5hIllHJ/vKoZDCh0ZPzqAuUo8Qyd8c4qOtdCI/DjyIN8lM+eSXRX15Yw82ev2SLfmEdlPOImcr9RqW6S5TfQQzHnK1PL4Ij5IMk+Z2nsdJxZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJiYOKyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJiYOKyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989C7C116C6;
	Mon,  9 Feb 2026 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647205;
	bh=M3O3iEvQkR/X3xcaL5BWMKaoVIfEaEFbwH8SY0msjw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJiYOKyqedMXXsDnfoQiAuL4rO3ILpBKEAaQwOuqlnpDZmuIqGgJIYqhlkrsM3qy0
	 9/CiT9bQ6sMb7GYMWRPRSWdxmpq3DXznon0/L7p2VxiKriAs3Pz9qpN8pcas0KqQ/x
	 qMBWLqeQUg0emkM3xR9VSrVmczOrpr7jGirChpH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Hlavacek <tmshlvck@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 031/175] net: spacemit: k1-emac: fix jumbo frame support
Date: Mon,  9 Feb 2026 15:21:44 +0100
Message-ID: <20260209142321.596349581@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Tomas Hlavacek <tmshlvck@gmail.com>

commit 3125fc17016945b11e9725c6aff30ff3326fd58f upstream.

The driver never programs the MAC frame size and jabber registers,
causing the hardware to reject frames larger than the default 1518
bytes even when larger DMA buffers are allocated.

Program MAC_MAXIMUM_FRAME_SIZE, MAC_TRANSMIT_JABBER_SIZE, and
MAC_RECEIVE_JABBER_SIZE based on the configured MTU. Also fix the
maximum buffer size from 4096 to 4095, since the descriptor buffer
size field is only 12 bits. Account for double VLAN tags in frame
size calculations.

Fixes: bfec6d7f2001 ("net: spacemit: Add K1 Ethernet MAC")
Cc: stable@vger.kernel.org
Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>
Link: https://patch.msgid.link/20260130102301.477514-1-tmshlvck@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/spacemit/k1_emac.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/spacemit/k1_emac.c b/drivers/net/ethernet/spacemit/k1_emac.c
index 88e9424d2d51..b49c4708bf9e 100644
--- a/drivers/net/ethernet/spacemit/k1_emac.c
+++ b/drivers/net/ethernet/spacemit/k1_emac.c
@@ -12,6 +12,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <linux/if_vlan.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
@@ -38,7 +39,7 @@
 
 #define EMAC_DEFAULT_BUFSIZE		1536
 #define EMAC_RX_BUF_2K			2048
-#define EMAC_RX_BUF_4K			4096
+#define EMAC_RX_BUF_MAX			FIELD_MAX(RX_DESC_1_BUFFER_SIZE_1_MASK)
 
 /* Tuning parameters from SpacemiT */
 #define EMAC_TX_FRAMES			64
@@ -202,8 +203,7 @@ static void emac_init_hw(struct emac_priv *priv)
 {
 	/* Destination address for 802.3x Ethernet flow control */
 	u8 fc_dest_addr[ETH_ALEN] = { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x01 };
-
-	u32 rxirq = 0, dma = 0;
+	u32 rxirq = 0, dma = 0, frame_sz;
 
 	regmap_set_bits(priv->regmap_apmu,
 			priv->regmap_apmu_offset + APMU_EMAC_CTRL_REG,
@@ -228,6 +228,15 @@ static void emac_init_hw(struct emac_priv *priv)
 		DEFAULT_TX_THRESHOLD);
 	emac_wr(priv, MAC_RECEIVE_PACKET_START_THRESHOLD, DEFAULT_RX_THRESHOLD);
 
+	/* Set maximum frame size and jabber size based on configured MTU,
+	 * accounting for Ethernet header, double VLAN tags, and FCS.
+	 */
+	frame_sz = priv->ndev->mtu + ETH_HLEN + 2 * VLAN_HLEN + ETH_FCS_LEN;
+
+	emac_wr(priv, MAC_MAXIMUM_FRAME_SIZE, frame_sz);
+	emac_wr(priv, MAC_TRANSMIT_JABBER_SIZE, frame_sz);
+	emac_wr(priv, MAC_RECEIVE_JABBER_SIZE, frame_sz);
+
 	/* Configure flow control (enabled in emac_adjust_link() later) */
 	emac_set_mac_addr_reg(priv, fc_dest_addr, MAC_FC_SOURCE_ADDRESS_HIGH);
 	emac_wr(priv, MAC_FC_PAUSE_HIGH_THRESHOLD, DEFAULT_FC_FIFO_HIGH);
@@ -924,14 +933,14 @@ static int emac_change_mtu(struct net_device *ndev, int mtu)
 		return -EBUSY;
 	}
 
-	frame_len = mtu + ETH_HLEN + ETH_FCS_LEN;
+	frame_len = mtu + ETH_HLEN + 2 * VLAN_HLEN + ETH_FCS_LEN;
 
 	if (frame_len <= EMAC_DEFAULT_BUFSIZE)
 		priv->dma_buf_sz = EMAC_DEFAULT_BUFSIZE;
 	else if (frame_len <= EMAC_RX_BUF_2K)
 		priv->dma_buf_sz = EMAC_RX_BUF_2K;
 	else
-		priv->dma_buf_sz = EMAC_RX_BUF_4K;
+		priv->dma_buf_sz = EMAC_RX_BUF_MAX;
 
 	ndev->mtu = mtu;
 
@@ -2025,7 +2034,7 @@ static int emac_probe(struct platform_device *pdev)
 	ndev->hw_features = NETIF_F_SG;
 	ndev->features |= ndev->hw_features;
 
-	ndev->max_mtu = EMAC_RX_BUF_4K - (ETH_HLEN + ETH_FCS_LEN);
+	ndev->max_mtu = EMAC_RX_BUF_MAX - (ETH_HLEN + 2 * VLAN_HLEN + ETH_FCS_LEN);
 	ndev->pcpu_stat_type = NETDEV_PCPU_STAT_DSTATS;
 
 	priv = netdev_priv(ndev);
-- 
2.53.0



