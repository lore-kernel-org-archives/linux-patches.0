Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021981;
	b=dyjZOr3B9h1wJOYjsmxnG4gKwHeFxiwstnbkZ4rE19e4bfuj5B+LLPLT5za2x0I06AjD
	 D0yl3lRbhc6r6N6bRYro2N29AxFzrZWAef/t1woJNdDdDLFxOSd1q4Oiq5lJ1ptBb0f9s
	 ja/7S1JC//jl119wb/dQGHFvdojfM76o5DBegXK6HFceSO5B7Fm7/qRDiSrKJBaNs4A6N
	 NDjU+k0opDpfleB5YQe6nJSUVmU+bsooYG2usp3JyS0jEul6hPm/Bk1uYLeauCjnAvH9A
	 Q/BMgzvvVLIqMd9JGfvVK/YAAjYojSKKPKCVZipnk1zBWpzWsuZsp1m3NLqlbez7a5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jm8ysn7ETsC1yr3MHi7YKV6YmGtsCKSE0bc6Py9+oYE=;
	b=B5qISDVritbSQuBfTi6czE7UbQC0/X45A1nryMFqg7lJdli1qTnhofFUixYhF5w0U19E
	 BPDDSan9TUfOo0hF/24soS5U5NypPA5PP0jqA8D4VlQnB/I1puXsjFrVS8fGtqmBJd+iE
	 x+g3JZS+6jlskzEaYetGbC0AccPUSeoUoRHepHe7ttJ/kAQeIfEQVQikdfphJYDpBo9RH
	 ZWYAyA+TeRlXkBPUsEulWDHevkkivgpDwjJiQB6aLeSZn4nuPH1fpKOD1GBiet4e8CBI3
	 du18dZYH6F4aqZxOGdam/ckMl6Wj48TJFenzhQ2npr3FgQ6tugzR92l3a+88eoaAPkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dsdqwpzy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F353606A32C;
	Wed, 18 Nov 2026 17:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dsdqwpzy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9521F000C4;
	Wed, 18 Nov 2026 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021980;
	bh=jm8ysn7ETsC1yr3MHi7YKV6YmGtsCKSE0bc6Py9+oYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsdqwpzyKrMylplapWxsFGAo/1wmfFer6jIhLT9BMO/wsem+ezpSKxPWHLP4XgR0M
	 jWjz0xBaE2N4Uo63EdmQVwqxWbYB7yswm1gsTrzOACDQ64xrj5C4jmECmjAXsTaa8+
	 YEZ0L/EHyYMCmWnqVQAOE7c93FyROQu1F3P6KxHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2501/2651] net: lan966x: release the in-flight slot of a stale TX skb
Date: Wed, 18 Nov 2026 16:02:21 +0100
Message-ID: <20261118150414.836861964@linuxfoundation.org>
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
index 8c40db90ee8f6..9be2cfe6feeb7 100644
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



