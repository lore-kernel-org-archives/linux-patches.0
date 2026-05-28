Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4362E332909;
	Thu, 28 May 2026 20:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000885; cv=none; b=EmdLkADIvsAGHWT+w7u2EDe7Lkgesf0G7pNoKdjDOXUjpZX23ADasp6eKh6lJqX99KOkExOLfvkEUrAqjHQ4AIzw6VDNxyLZed9vosk60Xx/DJI9RXkqtw/+Zbuh9setO4UdhjoynQ/D5Bwmv7F2nYupd5aTOc2pZyLXA1lUUH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000885; c=relaxed/simple;
	bh=19z8fPuD7uZAMVkBxBXMnsdQasx6GJ+T6MedAw5tQmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poX+jLrILyWAH7MnfOGwQRBs2xj3oH1xrtg8sy9H67jt0VQrtlwZ6A5jYk0pWc7ODNTj58XfyZvV+D6eEJ8EnQ9NqzB5Z6Uycfpfaq5f/hm//CvVSmeyvLuAwV5SImP56FlQHrKOJEDg6LtypF20r0odBSzhvaD+kh1RcX9ZdKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfjMPETc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfjMPETc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6401E1F000E9;
	Thu, 28 May 2026 20:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000883;
	bh=wWQB+ZX1OXZHVKwFKGI712/fEoEkVPgWPXl4cvNzw8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfjMPETcXlVmkqlAH+VX/e2ZDJ46xeP5lQ/HZgJ9tU0bg2bOmsBPjpUbNO1ZX07sM
	 LVQ2PE1j2FqLDmPXj18ibtRJkaBV000/OkxgZ4NvFWEnqopff+vuLs/HM34e9rQ9rq
	 2+gZs5eNOaXfelyxzsg8Bo9+Xi4pwsdpTwChihSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/272] net: ethernet: cortina: Make RX SKB per-port
Date: Thu, 28 May 2026 21:49:36 +0200
Message-ID: <20260528194634.903924905@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 92833eefc04b4..47072fbabcaee 100644
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
@@ -1442,10 +1444,10 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
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
@@ -1499,6 +1501,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 			if (skb) {
 				napi_free_frags(&port->napi);
 				port->stats.rx_dropped++;
+				skb = NULL;
 			}
 
 			skb = gmac_skb_if_good_frame(port, word0, frame_len);
@@ -1549,6 +1552,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		port->stats.rx_dropped++;
 	}
 
+	port->rx_skb = skb;
 	writew(r, ptr_reg);
 	return budget;
 }
@@ -1877,6 +1881,7 @@ static int gmac_stop(struct net_device *netdev)
 	gmac_disable_tx_rx(netdev);
 	gmac_stop_dma(port);
 	napi_disable(&port->napi);
+	port->rx_skb = NULL;
 
 	gmac_enable_irq(netdev, 0);
 	gmac_cleanup_rxq(netdev);
-- 
2.53.0



