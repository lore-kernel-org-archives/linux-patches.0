Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B904274FDC;
	Sat, 30 May 2026 18:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165221; cv=none; b=dgLucyV4emcA6kTV20BNdkLiPrko3ttI38u1Jg2pqUuRTe+6qo7y6MJNlMjBPuIZFNAIujHpFNqlZ4hlAIfx+Vpmr2TmHpcO2vkLVYS7xf/uAW7kAc06uBDT3tj7MJsuQR2OUyDRk4FzYHoPayhJ2SE1e7x6Wij9m42MsbBp1zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165221; c=relaxed/simple;
	bh=fdWtphvnOj4zxZTAy90Sd7MJqSicRdf7vA/OKOmGthM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5Iue7N6vE15T7N1K63ildVZfbw41xbwSeBJIvz2oqPRFL93H8VhcYobaL2OlwgIHzJ43voM0aObTwaUX7viMVgwJNoIOpqp6tHUMHLUJhQ9sxoHa/pIUQHBowTRRr+n+4OXEk51iVOYEyMK4qnAcEQJdBktFrFFr3v1RJIdHLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+sfhEn7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+sfhEn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00701F00893;
	Sat, 30 May 2026 18:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165220;
	bh=6H2l5hWFtC9YB/YjESuDw+k/odBI0qOkTk2/DXpyT8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W+sfhEn7faPlKfH8FMVCcen1W+HUdllGpgAgYnDvnyk/EHFuIWRFa34+L13vXTNhY
	 NuG4CSkuOYo1NkAaAhkrpCR3BkTCXA/OoRvxAG5XkHWXKIyuBmv3xrTTBmMiFpCPuq
	 3JrWQPHr0jyw9Hi24+ubFgVSvBMHNKF44LPmnJO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 748/776] net: ethernet: cortina: Make RX SKB per-port
Date: Sat, 30 May 2026 18:07:42 +0200
Message-ID: <20260530160259.103471782@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 06937db21ee311ed07eba47954447245041a982d ]

The SKB used to assemble packets from fragments in gmac_rx()
is static local, but the Gemini has two ethernet ports, meaning
there can be races between the ports on a bad day if a device
is using both.

Make the RX SKB a per-port variable and carry it over between
invocations in the port struct instead.

Zero the pointer once we call napi_gro_frags(), on error (after
calling napi_free_frags()) or if the port is stopped.

Zero it in some place where not strictly necessary just to
emphasize what is going on.

This was found by Sashiko during normal patch review.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Link: https://sashiko.dev/#/patchset/20260505-gemini-ethernet-fix-v2-1-997c31d06079%40kernel.org
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260509-gemini-ethernet-fixes-v1-2-6c5d20ddc35b@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 3a11dccec8c1b..29f8e19661efa 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -120,6 +120,8 @@ struct gemini_ethernet_port {
 	struct napi_struct	napi;
 	struct hrtimer		rx_coalesce_timer;
 	unsigned int		rx_coalesce_nsecs;
+	struct sk_buff		*rx_skb;
+
 	unsigned int		freeq_refill;
 	struct gmac_txq		txq[TX_QUEUE_NUM];
 	unsigned int		txq_order;
@@ -1411,10 +1413,10 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	unsigned short m = (1 << port->rxq_order) - 1;
 	struct gemini_ethernet *geth = port->geth;
 	void __iomem *ptr_reg = port->rxq_rwptr;
+	struct sk_buff *skb = port->rx_skb;
 	unsigned int frame_len, frag_len;
 	struct gmac_rxdesc *rx = NULL;
 	struct gmac_queue_page *gpage;
-	static struct sk_buff *skb;
 	union gmac_rxdesc_0 word0;
 	union gmac_rxdesc_1 word1;
 	union gmac_rxdesc_3 word3;
@@ -1468,6 +1470,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 			if (skb) {
 				napi_free_frags(&port->napi);
 				port->stats.rx_dropped++;
+				skb = NULL;
 			}
 
 			skb = gmac_skb_if_good_frame(port, word0, frame_len);
@@ -1518,6 +1521,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		port->stats.rx_dropped++;
 	}
 
+	port->rx_skb = skb;
 	writew(r, ptr_reg);
 	return budget;
 }
@@ -1846,6 +1850,7 @@ static int gmac_stop(struct net_device *netdev)
 	gmac_disable_tx_rx(netdev);
 	gmac_stop_dma(port);
 	napi_disable(&port->napi);
+	port->rx_skb = NULL;
 
 	gmac_enable_irq(netdev, 0);
 	gmac_cleanup_rxq(netdev);
-- 
2.53.0



