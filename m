Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050698;
	b=LQ1noC4P4YlGdR8wymf9huwxT7y+w8v4LZWumB4iZcHqsSpjBTXc8lYEIU7NlEtLfhFd
	 /wt1yfyBlFDFO42AcDlzAKLgdoqANgurT1C5hoEuvNC8ElvLUdGJBbo3zkMJsl3a0RmrY
	 8WlCKEUTkoW7RfIo0CjGwRw50Oh5KkgJYhkOi1wn+QLEmKBP38FJ5YVdPI7maVTBErWOQ
	 v0Pjny3G7DR52QdSBWILHU1azBF+67QXa5C7NYza4/NhyONoIRA4DEM6MmAiGL6nwO3DB
	 p0i7kjI/MFgI2LEBtFrGAAHvqZmNfyOboWweWY23N55L4tqmFZ52Z0aOxFSyKeQgYiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BsSGmIwlgq9R4w1KtsxDmXsHKjB25yoSN/QbTmpeWjY=;
	b=mESUqi7F33cDtuCmvUJR0DaPr//iDtajc7wFMwSaT5avF53MTkAWXIn/DCAZYtRWcyvE
	 vzN3kahHqSd6XrApQFsJSI2uw/an0t1s+ckomob7M9zydYNAHUqvOuAHKCpVC6pfKqrzZ
	 +/rmFOklcYYGezqoELehiN8iVkjxI3XJoA5111EHBRbWqI325IyURnwcQlOH4ZnLORXdB
	 DrNLWCUZsqKY28IRRn5ol5WuAPJksMjeeQY7BDevBcPlEiJGlN8uXLUVbaVKcRrR863GK
	 PiO5A7xpJMn1K9lewITWKFpV1ks09WeSowzzjlKQHqh8fA2PzbGLgdZPtP47SS9zFIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=je3EjDyv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA51606A320;
	Thu, 19 Nov 2026 01:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=je3EjDyv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409E01F000C4;
	Thu, 19 Nov 2026 01:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050697;
	bh=BsSGmIwlgq9R4w1KtsxDmXsHKjB25yoSN/QbTmpeWjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=je3EjDyvL1+xHxHctQdYuYRpKi7QHA2TEp7fhuFFyi0wqSC5zTh5jFEQ5jnjNhDBJ
	 7MF4KCe73PPxuCPMF1WJJm/UY98Iy1iindUzHW/G9FPd13ZS6HbxtEMXW8yK2qQ15v
	 HDhpkhDW0q4RljdSm8P6OpLdvlPHxE9EoOpUMI2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2759/2857] net: lan966x: release the in-flight slot of a stale TX skb
Date: Wed, 18 Nov 2026 16:03:13 +0100
Message-ID: <20261118150340.948130988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 667f2651ee309..465f7fe2dca04 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -140,9 +140,10 @@ static int lan966x_ptp_classify(struct lan966x_port *port, struct sk_buff *skb)
 	return IFH_REW_OP_TWO_STEP_PTP;
 }
 
-static void lan966x_ptp_txtstamp_old_release(struct lan966x_port *port)
+static unsigned int lan966x_ptp_txtstamp_old_release(struct lan966x_port *port)
 {
 	struct sk_buff *skb, *skb_tmp;
+	unsigned int purged = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->tx_skbs.lock, flags);
@@ -153,14 +154,18 @@ static void lan966x_ptp_txtstamp_old_release(struct lan966x_port *port)
 
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
 	u8 rew_op;
 
@@ -170,9 +175,10 @@ int lan966x_ptp_txtstamp_request(struct lan966x_port *port,
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



