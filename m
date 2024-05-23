Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C70313BAC3;
	Thu, 23 May 2024 13:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470761; cv=none; b=ZKoH5NVvv8jlw396T34g+faqLG5CSy/maCOwWGtB56GsvkZC/22N6dYQj0HqrSUGPiny5hntSs4TTFuGAC5d9or6H2Z7gt8Loa1PrOw3iF5S7JODDucUsrxZ/vDJhIVJ2Zl0nO7InC2ctjRDibyHCpQNicULbj5SE012dIrcsSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470761; c=relaxed/simple;
	bh=f/oxHXUbFIWaQ+ViiCGL5kOIzgHUlBSfpA1+uYOV8mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW1F/B5VmbfZMD+RosOMo3FpMVZo11f+mFtXSYM5LpoxgeoImUUJU8Isp8zlBHqMOGE6cBJ9VhpRpEt579vQJyPalui/i9FOIRx2kpYZW17vdn+F0prP6jZIWms/T0jlTEdhB0SuXcxucZPsmiPkC62msUgDcX8HL9wJ1xsu6X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XloqCdMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XloqCdMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89038C2BD10;
	Thu, 23 May 2024 13:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470760;
	bh=f/oxHXUbFIWaQ+ViiCGL5kOIzgHUlBSfpA1+uYOV8mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XloqCdMYfABJtIkMbWFcPs1SWyAgkLX7O77hp/iE4NT8fy8pKBhRrG+vEJi1KqNN2
	 UBgBpeYqeb7yh3rbK5PRwKE26boWJ7sA6f3xKl6hg2xDIDH7usvm4CvLCdlqqS90va
	 IZNAvpxlgBz8b4TVeGSRo7VJjYQYqrDrQgHXUYk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	Ronald Wahl <ronald.wahl@raritan.com>
Subject: [PATCH 6.6 078/102] net: ks8851: Fix another TX stall caused by wrong ISR flag handling
Date: Thu, 23 May 2024 15:13:43 +0200
Message-ID: <20240523130345.408565178@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronald Wahl <ronald.wahl@raritan.com>

commit 317a215d493230da361028ea8a4675de334bfa1a upstream.

Under some circumstances it may happen that the ks8851 Ethernet driver
stops sending data.

Currently the interrupt handler resets the interrupt status flags in the
hardware after handling TX. With this approach we may lose interrupts in
the time window between handling the TX interrupt and resetting the TX
interrupt status bit.

When all of the three following conditions are true then transmitting
data stops:

  - TX queue is stopped to wait for room in the hardware TX buffer
  - no queued SKBs in the driver (txq) that wait for being written to hw
  - hardware TX buffer is empty and the last TX interrupt was lost

This is because reenabling the TX queue happens when handling the TX
interrupt status but if the TX status bit has already been cleared then
this interrupt will never come.

With this commit the interrupt status flags will be cleared before they
are handled. That way we stop losing interrupts.

The wrong handling of the ISR flags was there from the beginning but
with commit 3dc5d4454545 ("net: ks8851: Fix TX stall caused by TX
buffer overrun") the issue becomes apparent.

Fixes: 3dc5d4454545 ("net: ks8851: Fix TX stall caused by TX buffer overrun")
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/micrel/ks8851_common.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -328,7 +328,6 @@ static irqreturn_t ks8851_irq(int irq, v
 {
 	struct ks8851_net *ks = _ks;
 	struct sk_buff_head rxq;
-	unsigned handled = 0;
 	unsigned long flags;
 	unsigned int status;
 	struct sk_buff *skb;
@@ -336,24 +335,17 @@ static irqreturn_t ks8851_irq(int irq, v
 	ks8851_lock(ks, &flags);
 
 	status = ks8851_rdreg16(ks, KS_ISR);
+	ks8851_wrreg16(ks, KS_ISR, status);
 
 	netif_dbg(ks, intr, ks->netdev,
 		  "%s: status 0x%04x\n", __func__, status);
 
-	if (status & IRQ_LCI)
-		handled |= IRQ_LCI;
-
 	if (status & IRQ_LDI) {
 		u16 pmecr = ks8851_rdreg16(ks, KS_PMECR);
 		pmecr &= ~PMECR_WKEVT_MASK;
 		ks8851_wrreg16(ks, KS_PMECR, pmecr | PMECR_WKEVT_LINK);
-
-		handled |= IRQ_LDI;
 	}
 
-	if (status & IRQ_RXPSI)
-		handled |= IRQ_RXPSI;
-
 	if (status & IRQ_TXI) {
 		unsigned short tx_space = ks8851_rdreg16(ks, KS_TXMIR);
 
@@ -365,20 +357,12 @@ static irqreturn_t ks8851_irq(int irq, v
 		if (netif_queue_stopped(ks->netdev))
 			netif_wake_queue(ks->netdev);
 		spin_unlock(&ks->statelock);
-
-		handled |= IRQ_TXI;
 	}
 
-	if (status & IRQ_RXI)
-		handled |= IRQ_RXI;
-
 	if (status & IRQ_SPIBEI) {
 		netdev_err(ks->netdev, "%s: spi bus error\n", __func__);
-		handled |= IRQ_SPIBEI;
 	}
 
-	ks8851_wrreg16(ks, KS_ISR, handled);
-
 	if (status & IRQ_RXI) {
 		/* the datasheet says to disable the rx interrupt during
 		 * packet read-out, however we're masking the interrupt


