Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042599;
	b=RjXD+y73y9UpUD2V9ZP8TKVsSTtBgkXthM5Y8rQ1fuQhyNtWArQZgAwe7/rUzW+vPvkM
	 FuPB1t7si3Kop1qT11XphLET+1juZV06N4XU4mdlVEYPuorvbZQoOzGtvOSHc1QTW4Isp
	 wAiBsvFHQzaa2uD1xargMZVd+LQC3B7Ppq1sSY9K3RzUCLUnfFpy/U/bsR/HOuiesCNwX
	 IURbAZyjHk/7Tasc2Ay0yqigbDlxoJg6xqpLjeYRAM0IBCN+Hm1+7O5Kbal5Fz9GBH3dc
	 7NogWqkrN7msQUGRH2LXSnPH7v55bDxWfSSPOFGIvGz2kV5FyEKCxA7btz+XTmZC26w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iEtyEyP5BjopbykjP4UgCrxpvo1csLFSG0yY2IUKA7I=;
	b=h0SWrSv5WCrqdy7bzjm3oTQgN2ozs7Yme4+h1LKukOTh9+Pl8X9jv4qfWcvbZW0dtMgX
	 8Gl2VlZgl6+UKzQWS3x0btV8FJDcUIPe2aBHfqQW837pMF09aLzeBCeMwluyfXjEDY9Qa
	 1XG99i6GjIv3dzvDj48UFNoQgZdA1x2ksCnpYYi5SJHZZ5aLO+cVlNIPqhm9HyWt5+nCI
	 caFWOo5hnYu2pGXyPtPn/HeCjSmnhLGwVSEobHjiKwaz3zlipATe4dZ320jRvMQSl0NTf
	 pazp4brteuewlfzGoVUGHvm5qO1u7mEcFOR4g9UHL93MK8U6Uot5vVY09MAY92yNA7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1J6d68bV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF84606A31C;
	Wed, 18 Nov 2026 22:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1J6d68bV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C1C1F000C4;
	Wed, 18 Nov 2026 22:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042599;
	bh=iEtyEyP5BjopbykjP4UgCrxpvo1csLFSG0yY2IUKA7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1J6d68bVwyd3Wna/FtchzsnVjdCihFSRQ2Bw+MLieIEovYaDBU3hCpimAp6k7psyh
	 7ggZMFvaL23qQFcL3dCGVNOVSEirUZ+p0XaxYJwijNOBlY6JPFTseE2h/SLkP5qp4h
	 T9te/uUYo1Yw1hAtK8VbvY/cL9fsMiOQs0VfuWi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3201/3318] net: lan966x: release the in-flight slot of a stale TX skb
Date: Wed, 18 Nov 2026 16:03:43 +0100
Message-ID: <20261118150455.790035181@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 074caa30a62726c0ee959e8b8ccb64cda0b26ae5 ]

lan966x_ptp_txtstamp_request() counts every two step TX skb waiting for
its timestamp in lan966x->ptp_skbs, and refuses new ones once
LAN966X_MAX_PTP_ID are in flight. lan966x_ptp_txtstamp_old_release()
frees the skbs that have waited longer than LAN966X_PTP_TIMEOUT.

Before this patch, old_release() does not decrement ptp_skbs, so every
skb whose timestamp never arrives, for example because the switch
discarded the frame, keeps its slot forever. Once LAN966X_MAX_PTP_ID
slots are lost, two step frames fail to transmit on every port of the
switch.

Return the number of released skbs from old_release() and subtract it
from ptp_skbs in txtstamp_request(), under the ptp_ts_id_lock it already
takes.

This fixes the accounting only. A port's stale skbs are still aged out
only when that port sends a two step frame, so a port that stops sending
them keeps its stale skbs, and their slots, until it sends one again.
That behaviour is unchanged by this patch.

Found by an AI code review agent. Reproduced on a lan9668 board.

Fixes: 77eecf25bd9d ("net: lan966x: Update extraction/injection for timestamping")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261026-lan966x-ptp-stale-tx-slot-v1-1-9f7c895eb1ff@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index 84f5b4410e48e..fd213d5b57e69 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -376,9 +376,10 @@ static void lan966x_ptp_classify(struct lan966x_port *port, struct sk_buff *skb,
 	*rew_op = IFH_REW_OP_TWO_STEP_PTP;
 }
 
-static void lan966x_ptp_txtstamp_old_release(struct lan966x_port *port)
+static unsigned int lan966x_ptp_txtstamp_old_release(struct lan966x_port *port)
 {
 	struct sk_buff *skb, *skb_tmp;
+	unsigned int purged = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->tx_skbs.lock, flags);
@@ -389,14 +390,18 @@ static void lan966x_ptp_txtstamp_old_release(struct lan966x_port *port)
 
 		__skb_unlink(skb, &port->tx_skbs);
 		dev_kfree_skb_any(skb);
+		purged++;
 	}
 	spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
+
+	return purged;
 }
 
 int lan966x_ptp_txtstamp_request(struct lan966x_port *port,
 				 struct sk_buff *skb)
 {
 	struct lan966x *lan966x = port->lan966x;
+	unsigned int purged;
 	unsigned long flags;
 	u8 pdu_type;
 	u8 rew_op;
@@ -408,9 +413,10 @@ int lan966x_ptp_txtstamp_request(struct lan966x_port *port,
 	if (rew_op != IFH_REW_OP_TWO_STEP_PTP)
 		return 0;
 
-	lan966x_ptp_txtstamp_old_release(port);
+	purged = lan966x_ptp_txtstamp_old_release(port);
 
 	spin_lock_irqsave(&lan966x->ptp_ts_id_lock, flags);
+	lan966x->ptp_skbs -= purged;
 	if (lan966x->ptp_skbs == LAN966X_MAX_PTP_ID) {
 		spin_unlock_irqrestore(&lan966x->ptp_ts_id_lock, flags);
 		return -EBUSY;
-- 
2.53.0



