Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6664187FED;
	Tue, 30 Jul 2024 16:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356669; cv=none; b=Q6OpyulSogZi8qoVvtmphNfxoeEuc2iwrg9o2qgXkwjQh+1mhRANlLE/F2w8cvQZ0nQkVCWlVgdo0Ht/mK8uTDn/PvL2+739Sj5JWNrQxtiicTp2A6yf8eyFliNt7Ps1P1vQ9LmONEawdESh2PiFmW4Nc+6Hy1Tap9WlYDJYbCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356669; c=relaxed/simple;
	bh=HRWsqBgQpgUfrxroh/AzY4i2sSpUK749uwxnMYQ+ArI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVPy4KrPvlXOpsZuPgwX3zVR7WfIF6U1W2MBUgv9ykhESxe8kyw4YZnOG/jkfPVH8HRGBosxqe55t11Bighu+dMhieDGJXCVkWyQgCylWPBhKyEeWFkASSaEoC5Myr5jrJU5rVGvMe8RoRwV/ygNK2hg+8lqql80tpBdsxx0SEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbbXj/3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbbXj/3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330D1C32782;
	Tue, 30 Jul 2024 16:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356669;
	bh=HRWsqBgQpgUfrxroh/AzY4i2sSpUK749uwxnMYQ+ArI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbbXj/3A8DQoQoFl9NcH3mLUIJpQEHvJWBJ0rJVBktSuzc2eGxWbRNJNEi9fMk2gV
	 E0A4jVSLo1/orn+Vc77qCKkJTSmQRhRYEeBCLcfChssFmMuP5X90zZjiiamp79R0Xy
	 Ol+PQFtQj6jwNZXSbTbAj45bMZNQc8TE0PXTzbYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 172/809] net: ethernet: cortina: Restore TSO support
Date: Tue, 30 Jul 2024 17:40:48 +0200
Message-ID: <20240730151731.398902116@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 2942dfab630444d46aaa37fb7d629b620abbf6ba ]

An earlier commit deleted the TSO support in the Cortina Gemini
driver because the driver was confusing gso_size and MTU,
probably because what the Linux kernel calls "gso_size" was
called "MTU" in the datasheet.

Restore the functionality properly reading the gso_size from
the skbuff.

Tested with iperf3, running a server on a different machine
and client on the device with the cortina gemini ethernet:

Connecting to host 192.168.1.2, port 5201
60008000.ethernet-port eth0: segment offloading mss = 05ea len=1c8a
60008000.ethernet-port eth0: segment offloading mss = 05ea len=1c8a
60008000.ethernet-port eth0: segment offloading mss = 05ea len=27da
60008000.ethernet-port eth0: segment offloading mss = 05ea len=0b92
60008000.ethernet-port eth0: segment offloading mss = 05ea len=2bda
(...)

(The hardware MSS 0x05ea here includes the ethernet headers.)

If I disable all segment offloading on the receiving host and
dump packets using tcpdump -xx like this:

ethtool -K enp2s0 gro off gso off tso off
tcpdump -xx -i enp2s0 host 192.168.1.136

I get segmented packages such as this when running iperf3:

23:16:54.024139 IP OpenWrt.lan.59168 > Fecusia.targus-getdata1:
Flags [.], seq 1486:2934, ack 1, win 4198,
options [nop,nop,TS val 3886192908 ecr 3601341877], length 1448
0x0000:  fc34 9701 a0c6 14d6 4da8 3c4f 0800 4500
0x0010:  05dc 16a0 4000 4006 9aa1 c0a8 0188 c0a8
0x0020:  0102 e720 1451 ff25 9822 4c52 29cf 8010
0x0030:  1066 ac8c 0000 0101 080a e7a2 990c d6a8
(...)
0x05c0:  5e49 e109 fe8c 4617 5e18 7a82 7eae d647
0x05d0:  e8ee ae64 dc88 c897 3f8a 07a4 3a33 6b1b
0x05e0:  3501 a30f 2758 cc44 4b4a

Several such packets often follow after each other verifying
the segmentation into 0x05a8 (1448) byte packages also on the
reveiving end. As can be seen, the ethernet frames are
0x05ea (1514) in size.

Performance with iperf3 before this patch: ~15.5 Mbit/s
Performance with iperf3 after this patch: ~175 Mbit/s

This was running a 60 second test (twice) the best measurement
was 179 Mbit/s.

For comparison if I run iperf3 with UDP I get around 1.05 Mbit/s
both before and after this patch.

While this is a gigabit ethernet interface, the CPU is a cheap
D-Link DIR-685 router (based on the ARMv5 Faraday FA526 at
~50 MHz), and the software is not supposed to drive traffic,
as the device has a DSA chip, so this kind of numbers can be
expected.

Fixes: ac631873c9e7 ("net: ethernet: cortina: Drop TSO support")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 5f0c9e1771dbf..7ebd61a3a49b0 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -79,7 +79,8 @@ MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 #define GMAC0_IRQ4_8 (GMAC0_MIB_INT_BIT | GMAC0_RX_OVERRUN_INT_BIT)
 
 #define GMAC_OFFLOAD_FEATURES (NETIF_F_SG | NETIF_F_IP_CSUM | \
-			       NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM)
+			       NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM | \
+			       NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6)
 
 /**
  * struct gmac_queue_page - page buffer per-page info
@@ -1148,13 +1149,25 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
 	skb_frag_t *skb_frag;
 	dma_addr_t mapping;
 	void *buffer;
+	u16 mss;
 	int ret;
 
-	/* TODO: implement proper TSO using MTU in word3 */
 	word1 = skb->len;
 	word3 = SOF_BIT;
 
-	if (skb->len >= ETH_FRAME_LEN) {
+	mss = skb_shinfo(skb)->gso_size;
+	if (mss) {
+		/* This means we are dealing with TCP and skb->len is the
+		 * sum total of all the segments. The TSO will deal with
+		 * chopping this up for us.
+		 */
+		/* The accelerator needs the full frame size here */
+		mss += skb_tcp_all_headers(skb);
+		netdev_dbg(netdev, "segment offloading mss = %04x len=%04x\n",
+			   mss, skb->len);
+		word1 |= TSS_MTU_ENABLE_BIT;
+		word3 |= mss;
+	} else if (skb->len >= ETH_FRAME_LEN) {
 		/* Hardware offloaded checksumming isn't working on frames
 		 * bigger than 1514 bytes. A hypothesis about this is that the
 		 * checksum buffer is only 1518 bytes, so when the frames get
@@ -1169,7 +1182,9 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
 				return ret;
 		}
 		word1 |= TSS_BYPASS_BIT;
-	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
+	}
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		int tcp = 0;
 
 		/* We do not switch off the checksumming on non TCP/UDP
-- 
2.43.0



