Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9144228DBA
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfF6tlWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96073C433C7;
	Mon, 16 Oct 2023 14:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468107;
	bh=Y4weePe7yXClNebEhisWLEpRvSjlNeA6VRB7f/q84I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfF6tlWxytRUAAEa+n0TRnjJ1zwljG/Sl13dzazUZ9b7dU9ZxwogsiZjXV71TFkIx
	 61aC5eLraBbCBdXpL347zLKMTde36+CSU8KM7cTLB1UIhv/HTrlkALgyhVppYz58dR
	 XsNr1g5a14eBUXkeaf+GIYGZSAUETDz3iRwaC6gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.5 159/191] can: sja1000: Always restart the Tx queue after an overrun
Date: Mon, 16 Oct 2023 10:42:24 +0200
Message-ID: <20231016084019.085891508@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit b5efb4e6fbb06da928526eca746f3de243c12ab2 upstream.

Upstream commit 717c6ec241b5 ("can: sja1000: Prevent overrun stalls with
a soft reset on Renesas SoCs") fixes an issue with Renesas own SJA1000
CAN controller reception: the Rx buffer is only 5 messages long, so when
the bus loaded (eg. a message every 50us), overrun may easily
happen. Upon an overrun situation, due to a possible internal crosstalk
situation, the controller enters a frozen state which only can be
unlocked with a soft reset (experimentally). The solution was to offload
a call to sja1000_start() in a threaded handler. This needs to happen in
process context as this operation requires to sleep. sja1000_start()
basically enters "reset mode", performs a proper software reset and
returns back into "normal mode".

Since this fix was introduced, we no longer observe any stalls in
reception. However it was sporadically observed that the transmit path
would now freeze. Further investigation blamed the fix mentioned above,
and especially the reset operation. Reproducing the reset in a loop
helped identifying what could possibly go wrong. The sja1000 is a single
Tx queue device, which leverages the netdev helpers to process one Tx
message at a time. The logic is: the queue is stopped, the message sent
to the transceiver, once properly transmitted the controller sets a
status bit which triggers an interrupt, in the interrupt handler the
transmission status is checked and the queue woken up. Unfortunately, if
an overrun happens, we might perform the soft reset precisely between
the transmission of the buffer to the transceiver and the advent of the
transmission status bit. We would then stop the transmission operation
without re-enabling the queue, leading to all further transmissions to
be ignored.

The reset interrupt can only happen while the device is "open", and
after a reset we anyway want to resume normal operations, no matter if a
packet to transmit got dropped in the process, so we shall wake up the
queue. Restarting the device and waking-up the queue is exactly what
sja1000_set_mode(CAN_MODE_START) does. In order to be consistent about
the queue state, we must acquire a lock both in the reset handler and in
the transmit path to ensure serialization of both operations. It turns
out, a lock is already held when entering the transmit path, so we can
just acquire/release it as well with the regular net helpers inside the
threaded interrupt handler and this way we should be safe. As the
reset handler might still be called after the transmission of a frame to
the transceiver but before it actually gets transmitted, we must ensure
we don't leak the skb, so we free it (the behavior is consistent, no
matter if there was an skb on the stack or not).

Fixes: 717c6ec241b5 ("can: sja1000: Prevent overrun stalls with a soft reset on Renesas SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/all/20231002160206.190953-1-miquel.raynal@bootlin.com
[mkl: fixed call to can_free_echo_skb()]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/sja1000/sja1000.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 0ada0e160e93..743c2eb62b87 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -392,7 +392,13 @@ static irqreturn_t sja1000_reset_interrupt(int irq, void *dev_id)
 	struct net_device *dev = (struct net_device *)dev_id;
 
 	netdev_dbg(dev, "performing a soft reset upon overrun\n");
-	sja1000_start(dev);
+
+	netif_tx_lock(dev);
+
+	can_free_echo_skb(dev, 0, NULL);
+	sja1000_set_mode(dev, CAN_MODE_START);
+
+	netif_tx_unlock(dev);
 
 	return IRQ_HANDLED;
 }
-- 
2.42.0



