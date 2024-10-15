Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8285E3DAC15;
	Tue, 15 Oct 2024 13:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998324; cv=none; b=c+UL1KVNpBCUzkPvHIg7sG/ujgLytcEGoY2uZJvadjRxdV9+OX2Ew7+aeBjjJD1o0pN6uX3gob1h4N51cuuxjZ9Hbqnj3vj1qwf2nGvmXpgIAWuBwQSUH9xpNF4Z37uivFZ0uaSV7l7ChqsR8YiBjjbUp3ibYgmRfCvRRii4aog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998324; c=relaxed/simple;
	bh=5MfQRp4zV1+Zj5gw5WaS9SwyLQqQkCzF+b4RYIRD3DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ru3QhO7BwAMi5Tyd/vKCcHTlaWrxVOo7E7V13ISXOj16k9e3IIRaC54G3HKchC5huS8pV/0ZSNTk+3MVBMhShPVxEuoX6ANCJzZB+EKc55FjJ6VZIrJNODFEBQGPZq+iR9iJOw4O2IAlnu7oSlKkyfbDSPyCs/AdEdhGJco2AQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1j2Y3ZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1j2Y3ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDBEC4CEC6;
	Tue, 15 Oct 2024 13:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998324;
	bh=5MfQRp4zV1+Zj5gw5WaS9SwyLQqQkCzF+b4RYIRD3DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1j2Y3ZVTNOihOH0G+VgMV/R15pzUQtyzRBak6wiiyPbf3pLUTGIesnF6a7AZJqzQ
	 2q0iRGdRpeFrKvTr0evwoIry2vXuAb8zx4Wqny7EmmcJYKcAOyAfzuOBPPmM6QK44x
	 zBQyntMq8Aukk3xGBxX5CIf+6iW8yIf0udDbmjss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 437/518] net: ethernet: cortina: Drop TSO support
Date: Tue, 15 Oct 2024 14:45:41 +0200
Message-ID: <20241015123933.872890744@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit ac631873c9e7a50d2a8de457cfc4b9f86666403e ]

The recent change to allow large frames without hardware checksumming
slotted in software checksumming in the driver if hardware could not
do it.

This will however upset TSO (TCP Segment Offloading). Typical
error dumps includes this:

skb len=2961 headroom=222 headlen=66 tailroom=0
(...)
WARNING: CPU: 0 PID: 956 at net/core/dev.c:3259 skb_warn_bad_offload+0x7c/0x108
gemini-ethernet-port: caps=(0x0000010000154813, 0x00002007ffdd7889)

And the packets do not go through.

The TSO implementation is bogus: a TSO enabled driver must propagate
the skb_shinfo(skb)->gso_size value to the TSO engine on the NIC.

Drop the size check and TSO offloading features for now: this
needs to be fixed up properly.

After this ethernet works fine on Gemini devices with a direct connected
PHY such as D-Link DNS-313.

Also tested to still be working with a DSA switch using the Gemini
ethernet as conduit interface.

Link: https://lore.kernel.org/netdev/CANn89iJLfxng1sYL5Zk0mknXpyYQPCp83m3KgD2KJ2_hKCpEUg@mail.gmail.com/
Suggested-by: Eric Dumazet <edumazet@google.com>
Fixes: d4d0c5b4d279 ("net: ethernet: cortina: Handle large frames")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index fa46854fd697c..04a034cd5183f 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -80,8 +80,7 @@ MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 #define GMAC0_IRQ4_8 (GMAC0_MIB_INT_BIT | GMAC0_RX_OVERRUN_INT_BIT)
 
 #define GMAC_OFFLOAD_FEATURES (NETIF_F_SG | NETIF_F_IP_CSUM | \
-		NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM | \
-		NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6)
+			       NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM)
 
 /**
  * struct gmac_queue_page - page buffer per-page info
@@ -1149,23 +1148,13 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
 	struct gmac_txdesc *txd;
 	skb_frag_t *skb_frag;
 	dma_addr_t mapping;
-	unsigned short mtu;
 	void *buffer;
 	int ret;
 
-	mtu  = ETH_HLEN;
-	mtu += netdev->mtu;
-	if (skb->protocol == htons(ETH_P_8021Q))
-		mtu += VLAN_HLEN;
-
+	/* TODO: implement proper TSO using MTU in word3 */
 	word1 = skb->len;
 	word3 = SOF_BIT;
 
-	if (word1 > mtu) {
-		word1 |= TSS_MTU_ENABLE_BIT;
-		word3 |= mtu;
-	}
-
 	if (skb->len >= ETH_FRAME_LEN) {
 		/* Hardware offloaded checksumming isn't working on frames
 		 * bigger than 1514 bytes. A hypothesis about this is that the
-- 
2.43.0



