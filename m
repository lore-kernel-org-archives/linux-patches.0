Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752EB37A825;
	Wed, 30 Sep 2026 18:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791549; cv=none; b=fRdLJ7L4OQyNWWJFNOPfT9P84T0iJLz9+EfMA2hNB5yAAAsYsdUFNR/p8uCZx3CAt6R7SUSkrOw9kAUUsPz6lrff2kXI2UwZIvImZ9pGOjAsNsDoyf/T733uJW+nXUd74g1HRlrfcaV39BsFBGDP4WUWXfYp8diLScuNfobHj2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791549; c=relaxed/simple;
	bh=AAgUl8HqZtCJULv8/yhrXMcxm9ZtvzPaApt4S/YBFGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZP21WKBPzLUnszoUgGjf7Vm/Mkm34Iujsm4qaGryx/qyi7P2Ua6j929v2/bltQkPJAVEvRrT3ua9BFgqPL4um6J9MPyvE+Cy4T1Kv/rKN9o8IkTNRyFmsgn4fS77df/LBq3OuHdXQdd2hkAZfosaUEzMYnx/HEg7sNUguXv0uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeJjXrqP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeJjXrqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931B61F000FF;
	Wed, 30 Sep 2026 18:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791548;
	bh=NAGSpAg9Aes52NVwgWGvECFoRYd8+CgsYcmqF/xtyc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeJjXrqPDqbAgBqU0XNjfLDorM4RRAK/PE8+bff/7OUTW4DP6S8B9YBdjbY9Bf/x/
	 tkXGy71SdC8g5YNZTl825dZ3N4zuDPKxYfZkVEMEgtmw2iVnEvuW8+8bZa12McLl5S
	 VuPkC/dkquY2GaNQnOA1czJQUCz2ua388rMX8ngs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 341/752] net: ethernet: cortina: Count RX descriptors for freeq refill
Date: Wed, 30 Sep 2026 17:23:31 +0200
Message-ID: <20260930152405.671822625@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit e89e88ad41d9f31c829c2af39c48313e8e48d5b0 ]

The software free queue provides one buffer fragment for every descriptor
moved to an RX queue. The refill heuristic instead advances by NAPI work,
which counts frames. A fragmented or discarded frame can consume several
queue entries while adding only one to the refill count.

Count the RX descriptors as they are consumed and report that separately
from NAPI work. Use the descriptor count to drive free queue refills.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Assisted-by: LLM
Reviewed-by: Joe Damato <joe@dama.to>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260903-gemini-ethernet-fixes-v2-5-2bbbd598ca6e@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index f00d88b9d0ea5..0067930a822e5 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1409,7 +1409,8 @@ static struct sk_buff *gmac_skb_if_good_frame(struct gemini_ethernet_port *port,
 	return skb;
 }
 
-static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
+static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget,
+			    unsigned int *freeq_consumed)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 	unsigned short m = (1 << port->rxq_order) - 1;
@@ -1417,6 +1418,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	void __iomem *ptr_reg = port->rxq_rwptr;
 	unsigned int frag_nr = port->rx_frag_nr;
 	struct sk_buff *skb = port->rx_skb;
+	unsigned int consumed = 0;
 	unsigned int frame_len, frag_len;
 	struct gmac_rxdesc *rx = NULL;
 	struct gmac_queue_page *gpage;
@@ -1452,6 +1454,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 
 		r++;
 		r &= m;
+		consumed++;
 
 		frag_len = word0.bits.buffer_size;
 		frame_len = word1.bits.byte_count;
@@ -1544,6 +1547,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	port->rx_skb = skb;
 	port->rx_frag_nr = frag_nr;
 	port->rx_dropping = dropping;
+	*freeq_consumed = consumed;
 	writew(r, ptr_reg);
 	return received;
 }
@@ -1553,18 +1557,19 @@ static int gmac_napi_poll(struct napi_struct *napi, int budget)
 	struct gemini_ethernet_port *port = netdev_priv(napi->dev);
 	struct gemini_ethernet *geth = port->geth;
 	unsigned int freeq_threshold;
+	unsigned int freeq_consumed;
 	unsigned int received;
 
 	freeq_threshold = 1 << (geth->freeq_order - 1);
 	u64_stats_update_begin(&port->rx_stats_syncp);
 
-	received = gmac_rx(napi->dev, budget);
+	received = gmac_rx(napi->dev, budget, &freeq_consumed);
 	if (received < budget)
 		++port->rx_napi_exits;
 
 	u64_stats_update_end(&port->rx_stats_syncp);
 
-	port->freeq_refill += received;
+	port->freeq_refill += freeq_consumed;
 	if (port->freeq_refill > freeq_threshold) {
 		port->freeq_refill -= freeq_threshold;
 		geth_fill_freeq(geth, true);
-- 
2.53.0



