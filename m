Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6664B19AD59;
	Tue, 16 Jul 2024 15:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145381; cv=none; b=kVjeBc9WVSx6TwXzKo8ioz4A9HBrYJQ0xR5+zU5DsGg4+/ILipgRkhHqo8eISw7n4fk+Dy3CBWGx7/jb+qvlvUkC2HdRz08V7P+mPl6PPJdIPqHLrvqf+kXSAU2Rczz0Gv5kR8u930E2ncCM0uy4Fo9xIG1fCH+mHpEQZ6MY+lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145381; c=relaxed/simple;
	bh=R6ULpI4OweR8CsFb1rfR4oxT0jSSifXID8epGske/LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obbP8iaCcyXiKAWaMHhXFAYQHYVtO3HBV+OIbBbipofNlaFAkF8I4tsjKnxx9gn7l9a0BbRzLGv7lFANy+XlD4dOCtZJwJfUKbJL9Keu9gQyjamEEZ5BTiAi1FO2VHpVgqXGTc2e1he95CMqzbASgbkAymrcWcyvHFg3/QiD58Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUsl08wZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUsl08wZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EE7C4AF0B;
	Tue, 16 Jul 2024 15:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145381;
	bh=R6ULpI4OweR8CsFb1rfR4oxT0jSSifXID8epGske/LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUsl08wZPwO5y0pKzOMhk6zFYXHKnJHSej0K4Pwvu4Uiab+U1zGUZMz4iYhu4sOJk
	 LKXeYqjLDryjppNYxOzR+p5oUTD+bmSPBIGeLzBeC2oQ3FecmZy7Yf6aXMO9Nxm5ZJ
	 tK7otJ+rtBwZ/yc/KIvKCAAG5VaJxZgsnyy0xAP0=
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
Subject: [PATCH 6.1 48/96] net: ks8851: Fix deadlock with the SPI chip variant
Date: Tue, 16 Jul 2024 17:31:59 +0200
Message-ID: <20240716152748.353244648@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

From: Ronald Wahl <ronald.wahl@raritan.com>

commit 0913ec336a6c0c4a2b296bd9f74f8e41c4c83c8c upstream.

When SMP is enabled and spinlocks are actually functional then there is
a deadlock with the 'statelock' spinlock between ks8851_start_xmit_spi
and ks8851_irq:

    watchdog: BUG: soft lockup - CPU#0 stuck for 27s!
    call trace:
      queued_spin_lock_slowpath+0x100/0x284
      do_raw_spin_lock+0x34/0x44
      ks8851_start_xmit_spi+0x30/0xb8
      ks8851_start_xmit+0x14/0x20
      netdev_start_xmit+0x40/0x6c
      dev_hard_start_xmit+0x6c/0xbc
      sch_direct_xmit+0xa4/0x22c
      __qdisc_run+0x138/0x3fc
      qdisc_run+0x24/0x3c
      net_tx_action+0xf8/0x130
      handle_softirqs+0x1ac/0x1f0
      __do_softirq+0x14/0x20
      ____do_softirq+0x10/0x1c
      call_on_irq_stack+0x3c/0x58
      do_softirq_own_stack+0x1c/0x28
      __irq_exit_rcu+0x54/0x9c
      irq_exit_rcu+0x10/0x1c
      el1_interrupt+0x38/0x50
      el1h_64_irq_handler+0x18/0x24
      el1h_64_irq+0x64/0x68
      __netif_schedule+0x6c/0x80
      netif_tx_wake_queue+0x38/0x48
      ks8851_irq+0xb8/0x2c8
      irq_thread_fn+0x2c/0x74
      irq_thread+0x10c/0x1b0
      kthread+0xc8/0xd8
      ret_from_fork+0x10/0x20

This issue has not been identified earlier because tests were done on
a device with SMP disabled and so spinlocks were actually NOPs.

Now use spin_(un)lock_bh for TX queue related locking to avoid execution
of softirq work synchronously that would lead to a deadlock.

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
Link: https://patch.msgid.link/20240706101337.854474-1-rwahl@gmx.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/micrel/ks8851_common.c |    8 ++++----
 drivers/net/ethernet/micrel/ks8851_spi.c    |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -352,11 +352,11 @@ static irqreturn_t ks8851_irq(int irq, v
 		netif_dbg(ks, intr, ks->netdev,
 			  "%s: txspace %d\n", __func__, tx_space);
 
-		spin_lock(&ks->statelock);
+		spin_lock_bh(&ks->statelock);
 		ks->tx_space = tx_space;
 		if (netif_queue_stopped(ks->netdev))
 			netif_wake_queue(ks->netdev);
-		spin_unlock(&ks->statelock);
+		spin_unlock_bh(&ks->statelock);
 	}
 
 	if (status & IRQ_SPIBEI) {
@@ -635,14 +635,14 @@ static void ks8851_set_rx_mode(struct ne
 
 	/* schedule work to do the actual set of the data if needed */
 
-	spin_lock(&ks->statelock);
+	spin_lock_bh(&ks->statelock);
 
 	if (memcmp(&rxctrl, &ks->rxctrl, sizeof(rxctrl)) != 0) {
 		memcpy(&ks->rxctrl, &rxctrl, sizeof(ks->rxctrl));
 		schedule_work(&ks->rxctrl_work);
 	}
 
-	spin_unlock(&ks->statelock);
+	spin_unlock_bh(&ks->statelock);
 }
 
 static int ks8851_set_mac_address(struct net_device *dev, void *addr)
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -340,10 +340,10 @@ static void ks8851_tx_work(struct work_s
 
 	tx_space = ks8851_rdreg16_spi(ks, KS_TXMIR);
 
-	spin_lock(&ks->statelock);
+	spin_lock_bh(&ks->statelock);
 	ks->queued_len -= dequeued_len;
 	ks->tx_space = tx_space;
-	spin_unlock(&ks->statelock);
+	spin_unlock_bh(&ks->statelock);
 
 	ks8851_unlock_spi(ks, &flags);
 }


