Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531B1261B91;
	Sat, 30 May 2026 18:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167218; cv=none; b=cZTV8bnSbeFsQhljVyinqdv/j9ETwF0X+0eTcaPR7RXw64u1S4p+mNodU8dVRT41aMGLU0+c07JbTX99Ihtfd3ioFyMzjZ7zE9tToHxbYDULexzxxKgW9z6PSo+Ir3rBx+7bHddm7dAglwKfKxDhAXkvOn/7Mup0Uz5OLw2RZzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167218; c=relaxed/simple;
	bh=Jmww14LSx8pq+yNfqRjGPOYYalxfdw3rGctV5Hpm/MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPScEewYSpa3XPRo08yrr8U5jzpAjf5Y8HW9cWWCzqKVefNHt1Z3oVV9QHLtjAIfJmOrlivEJN2zafmy2953AISRsTma10cvDe8aZNwyI7Pxij2g/bnIo1OnS/mE2DEwqTlZbrxJaVMcC3YcfXeGEovxIEGdiKM3StII/zD8cyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCFEO3ve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCFEO3ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366941F00893;
	Sat, 30 May 2026 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167215;
	bh=cUWb1i0BCUnRLBeb2vNatz2dKKRwccA/EblLhvkYdbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCFEO3veuH+pl46fgQAxVxzk9TZjA1TOSbfEizz/R7h+6WNl6bSFXxluGSdJwYR42
	 n4yypXy0GocAosgt/VytPtzccj5C1JdRI35w3Eow+r5WXIDcsUmD59e2o6nDKo9dN4
	 NzZlNuEGBKf1kyVaJ0DbDO0rN3+9c8lMvkAz9/O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 575/589] net: ethernet: cortina: Make RX SKB per-port
Date: Sat, 30 May 2026 18:07:36 +0200
Message-ID: <20260530160239.722991601@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 04a034cd5183f..ee51367df6488 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -121,6 +121,8 @@ struct gemini_ethernet_port {
 	struct napi_struct	napi;
 	struct hrtimer		rx_coalesce_timer;
 	unsigned int		rx_coalesce_nsecs;
+	struct sk_buff		*rx_skb;
+
 	unsigned int		freeq_refill;
 	struct gmac_txq		txq[TX_QUEUE_NUM];
 	unsigned int		txq_order;
@@ -1412,10 +1414,10 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
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
@@ -1469,6 +1471,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 			if (skb) {
 				napi_free_frags(&port->napi);
 				port->stats.rx_dropped++;
+				skb = NULL;
 			}
 
 			skb = gmac_skb_if_good_frame(port, word0, frame_len);
@@ -1519,6 +1522,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		port->stats.rx_dropped++;
 	}
 
+	port->rx_skb = skb;
 	writew(r, ptr_reg);
 	return budget;
 }
@@ -1847,6 +1851,7 @@ static int gmac_stop(struct net_device *netdev)
 	gmac_disable_tx_rx(netdev);
 	gmac_stop_dma(port);
 	napi_disable(&port->napi);
+	port->rx_skb = NULL;
 
 	gmac_enable_irq(netdev, 0);
 	gmac_cleanup_rxq(netdev);
-- 
2.53.0



