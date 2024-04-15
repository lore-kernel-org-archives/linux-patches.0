Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B65782486;
	Mon, 15 Apr 2024 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191800; cv=none; b=enJvc5kv3yKpI/hn6PuAc6djjuT3psnUZqfgKDzxLE+lroS0C/9qcjAEWBu+lLRqJYLuxRISBYi64xclJHd5z6u7DURVibm5T4phBYJj7ZdT2Ttny4Rym81wFnl+E6J5M9OewE68UYbZLJSTV23IxitCA4NfAqz3ki0SyRoyVRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191800; c=relaxed/simple;
	bh=jpyLELkIGDBD6zEoW2ddiuz8KtVK9mG5FACzjkjD5bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qj6mHcdxwR7P42CETP6FPeftXUbvoOxtd9AR01kiDNtL+YU2c9WB6qTvS44dKz83hZp7b2DK6fauZHFEhJB/Io3j12csbB8WQqsYNkSTCfjXugCVgOQr1BrpM8vewlQA7Qs/45gEgKjS4QS342CFEfxVVwqVWsnCMJv0VQw/Vv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oEoQOf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oEoQOf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5866C113CC;
	Mon, 15 Apr 2024 14:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191800;
	bh=jpyLELkIGDBD6zEoW2ddiuz8KtVK9mG5FACzjkjD5bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oEoQOf3GyrtcG8eqJUjq/klmLS2Gnswy/cyA08M3/lFkNesYc6YSSKsHlyQrIfLE
	 G0sXP8SfeDZn//7ePBsw01ZToDDHCXDzArlPBBMzugGNqlG1qICl5uafQG/XPQK1Al
	 Yo62HCYc3DpmaqbVJntis8kdVJstQa+unT8p1mtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/122] net: ks8851: Handle softirqs at the end of IRQ thread to fix hang
Date: Mon, 15 Apr 2024 16:20:07 +0200
Message-ID: <20240415141954.629177358@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit be0384bf599cf1eb8d337517feeb732d71f75a6f ]

The ks8851_irq() thread may call ks8851_rx_pkts() in case there are
any packets in the MAC FIFO, which calls netif_rx(). This netif_rx()
implementation is guarded by local_bh_disable() and local_bh_enable().
The local_bh_enable() may call do_softirq() to run softirqs in case
any are pending. One of the softirqs is net_rx_action, which ultimately
reaches the driver .start_xmit callback. If that happens, the system
hangs. The entire call chain is below:

ks8851_start_xmit_par from netdev_start_xmit
netdev_start_xmit from dev_hard_start_xmit
dev_hard_start_xmit from sch_direct_xmit
sch_direct_xmit from __dev_queue_xmit
__dev_queue_xmit from __neigh_update
__neigh_update from neigh_update
neigh_update from arp_process.constprop.0
arp_process.constprop.0 from __netif_receive_skb_one_core
__netif_receive_skb_one_core from process_backlog
process_backlog from __napi_poll.constprop.0
__napi_poll.constprop.0 from net_rx_action
net_rx_action from __do_softirq
__do_softirq from call_with_stack
call_with_stack from do_softirq
do_softirq from __local_bh_enable_ip
__local_bh_enable_ip from netif_rx
netif_rx from ks8851_irq
ks8851_irq from irq_thread_fn
irq_thread_fn from irq_thread
irq_thread from kthread
kthread from ret_from_fork

The hang happens because ks8851_irq() first locks a spinlock in
ks8851_par.c ks8851_lock_par() spin_lock_irqsave(&ksp->lock, ...)
and with that spinlock locked, calls netif_rx(). Once the execution
reaches ks8851_start_xmit_par(), it calls ks8851_lock_par() again
which attempts to claim the already locked spinlock again, and the
hang happens.

Move the do_softirq() call outside of the spinlock protected section
of ks8851_irq() by disabling BHs around the entire spinlock protected
section of ks8851_irq() handler. Place local_bh_enable() outside of
the spinlock protected section, so that it can trigger do_softirq()
without the ks8851_par.c ks8851_lock_par() spinlock being held, and
safely call ks8851_start_xmit_par() without attempting to lock the
already locked spinlock.

Since ks8851_irq() is protected by local_bh_disable()/local_bh_enable()
now, replace netif_rx() with __netif_rx() which is not duplicating the
local_bh_disable()/local_bh_enable() calls.

Fixes: 797047f875b5 ("net: ks8851: Implement Parallel bus operations")
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20240405203204.82062-2-marex@denx.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851_common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 896d43bb8883d..d4cdf3d4f5525 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -299,7 +299,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 					ks8851_dbg_dumpkkt(ks, rxpkt);
 
 				skb->protocol = eth_type_trans(skb, ks->netdev);
-				netif_rx(skb);
+				__netif_rx(skb);
 
 				ks->netdev->stats.rx_packets++;
 				ks->netdev->stats.rx_bytes += rxlen;
@@ -330,6 +330,8 @@ static irqreturn_t ks8851_irq(int irq, void *_ks)
 	unsigned long flags;
 	unsigned int status;
 
+	local_bh_disable();
+
 	ks8851_lock(ks, &flags);
 
 	status = ks8851_rdreg16(ks, KS_ISR);
@@ -406,6 +408,8 @@ static irqreturn_t ks8851_irq(int irq, void *_ks)
 	if (status & IRQ_LCI)
 		mii_check_link(&ks->mii);
 
+	local_bh_enable();
+
 	return IRQ_HANDLED;
 }
 
-- 
2.43.0



