Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB2213DBB6;
	Tue, 17 Dec 2024 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455833; cv=none; b=SCrQmZaU+GHFYJEmy2ScKnQcnMlXJsGM9wIcgCwCHGdQLadS1pTEVhwyTCI8UMV4ARYXabOM4XT1++fv6wRlcEjNwe2HWtkqCo/cwIjCAXQOc0X1U4NONzELR3nk44vEgxzEoL4/j0Vgfn4SE1nk7oTz+su9aCKHiYPwS/pWncU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455833; c=relaxed/simple;
	bh=HXpb+J3NVcr0tM+q73owg4DIaUSpny/Xpu96mM7FlZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rG4/smnntMj7w+q5Nrf1IUNVKuWZ4n0zAZKboQWQCmTHS8BFk9MzjJUVPWeTQEn5Db7TAoMSApQ14eqG6lbCBGGhXgfx5SYTEsTgRDAdcfUzzqSmVJBkgiEZthFjHtQuxxQ/H3sT1ZoJg5FAP6lE5d1K8q3DHgaluDZEgizah4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWVz8fEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWVz8fEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980E5C4CED3;
	Tue, 17 Dec 2024 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455833;
	bh=HXpb+J3NVcr0tM+q73owg4DIaUSpny/Xpu96mM7FlZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWVz8fEyrDG9wU/tBoY9ioe/V6pZO2tA+FpHEhfaEDwS+mqorkn0nE0DzR84gpoL1
	 2+PUMqEqOoSmXNF6EvQOnmbMDswHrvqAtcN8239O/5wywo0Cp9neW8o1zigxpZbyFg
	 R4ctqt4hNqJlIVsTcy/qIzdsxcrKRr0e4T6rrLH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 46/76] net: mscc: ocelot: ocelot->ts_id_lock and ocelot_port->tx_skbs.lock are IRQ-safe
Date: Tue, 17 Dec 2024 18:07:26 +0100
Message-ID: <20241217170528.176045418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0c53cdb95eb4a604062e326636971d96dd9b1b26 ]

ocelot_get_txtstamp() is a threaded IRQ handler, requested explicitly as
such by both ocelot_ptp_rdy_irq_handler() and vsc9959_irq_handler().

As such, it runs with IRQs enabled, and not in hardirq context. Thus,
ocelot_port_add_txtstamp_skb() has no reason to turn off IRQs, it cannot
be preempted by ocelot_get_txtstamp(). For the same reason,
dev_kfree_skb_any_reason() will always evaluate as kfree_skb_reason() in
this calling context, so just simplify the dev_kfree_skb_any() call to
kfree_skb().

Also, ocelot_port_txtstamp_request() runs from NET_TX softirq context,
not with hardirqs enabled. Thus, ocelot_get_txtstamp() which shares the
ocelot_port->tx_skbs.lock lock with it, has no reason to disable hardirqs.

This is part of a larger rework of the TX timestamping procedure.
A logical subportion of the rework has been split into a separate
change.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241205145519.1236778-4-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b454abfab525 ("net: mscc: ocelot: be resilient to loss of PTP packets during transmission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_ptp.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index 1386fb2ff4a9..c54e96ff3976 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -611,13 +611,12 @@ static int ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 					struct sk_buff *clone)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	unsigned long flags;
 
-	spin_lock_irqsave(&ocelot->ts_id_lock, flags);
+	spin_lock(&ocelot->ts_id_lock);
 
 	if (ocelot_port->ptp_skbs_in_flight == OCELOT_MAX_PTP_ID ||
 	    ocelot->ptp_skbs_in_flight == OCELOT_PTP_FIFO_SIZE) {
-		spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
+		spin_unlock(&ocelot->ts_id_lock);
 		return -EBUSY;
 	}
 
@@ -634,7 +633,7 @@ static int ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 
 	skb_queue_tail(&ocelot_port->tx_skbs, clone);
 
-	spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
+	spin_unlock(&ocelot->ts_id_lock);
 
 	return 0;
 }
@@ -753,7 +752,6 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		u32 val, id, seqid, txport;
 		struct ocelot_port *port;
 		struct timespec64 ts;
-		unsigned long flags;
 
 		val = ocelot_read(ocelot, SYS_PTP_STATUS);
 
@@ -777,7 +775,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 
 		/* Retrieve its associated skb */
 try_again:
-		spin_lock_irqsave(&port->tx_skbs.lock, flags);
+		spin_lock(&port->tx_skbs.lock);
 
 		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
 			if (OCELOT_SKB_CB(skb)->ts_id != id)
@@ -787,7 +785,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 			break;
 		}
 
-		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
+		spin_unlock(&port->tx_skbs.lock);
 
 		if (WARN_ON(!skb_match))
 			goto next_ts;
@@ -796,7 +794,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 			dev_err_ratelimited(ocelot->dev,
 					    "port %d received stale TX timestamp for seqid %d, discarding\n",
 					    txport, seqid);
-			dev_kfree_skb_any(skb);
+			kfree_skb(skb);
 			goto try_again;
 		}
 
-- 
2.39.5



