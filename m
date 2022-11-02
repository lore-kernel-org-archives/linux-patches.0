Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162167E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCD6C433D6;
	Wed,  2 Nov 2022 03:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358660;
	bh=D6eSAMPsbYbN8Or4q8IP9FC5yWZnlYFKTEJzMRHBOdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFnMwG2ys+bM10lkVw7onmoj21tZBq4OdfxRtF3eGo9vbh14Dq+688DHbKNxKY1BP
	 RIEISS9OtrOyxbY4phoHQmldNf3K4ukYPZrNpqZauq//36fwL4TM2E6NT/Soz4qxNh
	 nLBhxCNIgdOPKduixQBYLlTcu10rlMR1pvCap1A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 5.15 129/132] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive
Date: Wed,  2 Nov 2022 03:33:55 +0100
Message-Id: <20221102022103.061845507@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 702de2c21eed04c67cefaaedc248ef16e5f6b293 upstream.

We are seeing an IRQ storm on the global receive IRQ line under heavy
CAN bus load conditions with both CAN channels enabled.

Conditions:

The global receive IRQ line is shared between can0 and can1, either of
the channels can trigger interrupt while the other channel's IRQ line
is disabled (RFIE).

When global a receive IRQ interrupt occurs, we mask the interrupt in
the IRQ handler. Clearing and unmasking of the interrupt is happening
in rx_poll(). There is a race condition where rx_poll() unmasks the
interrupt, but the next IRQ handler does not mask the IRQ due to
NAPIF_STATE_MISSED flag (e.g.: can0 RX FIFO interrupt is disabled and
can1 is triggering RX interrupt, the delay in rx_poll() processing
results in setting NAPIF_STATE_MISSED flag) leading to an IRQ storm.

This patch fixes the issue by checking IRQ active and enabled before
handling the IRQ on a particular channel.

Fixes: dd3bd23eb438 ("can: rcar_canfd: Add Renesas R-Car CAN FD driver")
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/all/20221025155657.1426948-2-biju.das.jz@bp.renesas.com
Cc: stable@vger.kernel.org
[mkl: adjust commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[biju: removed gpriv from RCANFD_RFCC_RFIE macro]
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1106,11 +1106,13 @@ static void rcar_canfd_handle_global_rec
 {
 	struct rcar_canfd_channel *priv = gpriv->ch[ch];
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
-	u32 sts;
+	u32 sts, cc;
 
 	/* Handle Rx interrupts */
 	sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
-	if (likely(sts & RCANFD_RFSTS_RFIF)) {
+	cc = rcar_canfd_read(priv->base, RCANFD_RFCC(ridx));
+	if (likely(sts & RCANFD_RFSTS_RFIF &&
+		   cc & RCANFD_RFCC_RFIE)) {
 		if (napi_schedule_prep(&priv->napi)) {
 			/* Disable Rx FIFO interrupts */
 			rcar_canfd_clear_bit(priv->base,


