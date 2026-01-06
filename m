Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE243446C2;
	Tue,  6 Jan 2026 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722415; cv=none; b=Usf9snqvaXFtvqIuxRBo2Od+fkpXdODfYaTNT0Tqk6Mcyx3R3DLaJltabuB/qKf1N/xRrKyMOxHfMNfTnfTrbMla2nD/Ulu681dy/MZh96zejLnNrtxA/RgggkUjrdtKp+In5WvXpYxo6HEQkClrfLxWgqqsMdLsfxQZy2cjZdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722415; c=relaxed/simple;
	bh=MLTkoEBMAOecsJ82fvBi4/DxU9y4pbde0M9CCt0Jz8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIQ5zmhuiFANvPLmeOWk17bmHOXkFPRWaB7/Hy+inEk+L4cuiHa9T4VguHTK+T/exQQuzb0PAIHX9G0J5CnyV/MczKmXNIpCjHAZ2vo1vvmQL6JPWWHGuIWbD//VMGRFl+BAMau8VCZGyGuhMxAMkY3vXEXRtJq3woUhf56tQAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3SU7shY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3SU7shY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01259C116C6;
	Tue,  6 Jan 2026 18:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722415;
	bh=MLTkoEBMAOecsJ82fvBi4/DxU9y4pbde0M9CCt0Jz8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3SU7shYExTBcIAfCWnkX54pUTCO8sb3zRI5r76AhG96ZMT8JiErdLmB080RoJFi8
	 xoECJWm63HMTTaUVoPEac5TDV91hslGQJRD66MLbAf4hqmSJlWYwWqRHIblzAp89+T
	 nWqqvzFDrJUU2XR81ZG/5qWt0/9gEI3/Stu1kBh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <kexin.hao@windriver.com>,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 257/312] net: macb: Relocate mog_init_rings() callback from macb_mac_link_up() to macb_open()
Date: Tue,  6 Jan 2026 18:05:31 +0100
Message-ID: <20260106170557.145459828@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit 99537d5c476cada9cf75aef9fa75579a31faadb9 upstream.

In the non-RT kernel, local_bh_disable() merely disables preemption,
whereas it maps to an actual spin lock in the RT kernel. Consequently,
when attempting to refill RX buffers via netdev_alloc_skb() in
macb_mac_link_up(), a deadlock scenario arises as follows:

   WARNING: possible circular locking dependency detected
   6.18.0-08691-g2061f18ad76e #39 Not tainted
   ------------------------------------------------------
   kworker/0:0/8 is trying to acquire lock:
   ffff00080369bbe0 (&bp->lock){+.+.}-{3:3}, at: macb_start_xmit+0x808/0xb7c

   but task is already holding lock:
   ffff000803698e58 (&queue->tx_ptr_lock){+...}-{3:3}, at: macb_start_xmit
   +0x148/0xb7c

   which lock already depends on the new lock.

   the existing dependency chain (in reverse order) is:

   -> #3 (&queue->tx_ptr_lock){+...}-{3:3}:
          rt_spin_lock+0x50/0x1f0
          macb_start_xmit+0x148/0xb7c
          dev_hard_start_xmit+0x94/0x284
          sch_direct_xmit+0x8c/0x37c
          __dev_queue_xmit+0x708/0x1120
          neigh_resolve_output+0x148/0x28c
          ip6_finish_output2+0x2c0/0xb2c
          __ip6_finish_output+0x114/0x308
          ip6_output+0xc4/0x4a4
          mld_sendpack+0x220/0x68c
          mld_ifc_work+0x2a8/0x4f4
          process_one_work+0x20c/0x5f8
          worker_thread+0x1b0/0x35c
          kthread+0x144/0x200
          ret_from_fork+0x10/0x20

   -> #2 (_xmit_ETHER#2){+...}-{3:3}:
          rt_spin_lock+0x50/0x1f0
          sch_direct_xmit+0x11c/0x37c
          __dev_queue_xmit+0x708/0x1120
          neigh_resolve_output+0x148/0x28c
          ip6_finish_output2+0x2c0/0xb2c
          __ip6_finish_output+0x114/0x308
          ip6_output+0xc4/0x4a4
          mld_sendpack+0x220/0x68c
          mld_ifc_work+0x2a8/0x4f4
          process_one_work+0x20c/0x5f8
          worker_thread+0x1b0/0x35c
          kthread+0x144/0x200
          ret_from_fork+0x10/0x20

   -> #1 ((softirq_ctrl.lock)){+.+.}-{3:3}:
          lock_release+0x250/0x348
          __local_bh_enable_ip+0x7c/0x240
          __netdev_alloc_skb+0x1b4/0x1d8
          gem_rx_refill+0xdc/0x240
          gem_init_rings+0xb4/0x108
          macb_mac_link_up+0x9c/0x2b4
          phylink_resolve+0x170/0x614
          process_one_work+0x20c/0x5f8
          worker_thread+0x1b0/0x35c
          kthread+0x144/0x200
          ret_from_fork+0x10/0x20

   -> #0 (&bp->lock){+.+.}-{3:3}:
          __lock_acquire+0x15a8/0x2084
          lock_acquire+0x1cc/0x350
          rt_spin_lock+0x50/0x1f0
          macb_start_xmit+0x808/0xb7c
          dev_hard_start_xmit+0x94/0x284
          sch_direct_xmit+0x8c/0x37c
          __dev_queue_xmit+0x708/0x1120
          neigh_resolve_output+0x148/0x28c
          ip6_finish_output2+0x2c0/0xb2c
          __ip6_finish_output+0x114/0x308
          ip6_output+0xc4/0x4a4
          mld_sendpack+0x220/0x68c
          mld_ifc_work+0x2a8/0x4f4
          process_one_work+0x20c/0x5f8
          worker_thread+0x1b0/0x35c
          kthread+0x144/0x200
          ret_from_fork+0x10/0x20

   other info that might help us debug this:

   Chain exists of:
     &bp->lock --> _xmit_ETHER#2 --> &queue->tx_ptr_lock

    Possible unsafe locking scenario:

          CPU0                    CPU1
          ----                    ----
     lock(&queue->tx_ptr_lock);
                                  lock(_xmit_ETHER#2);
                                  lock(&queue->tx_ptr_lock);
     lock(&bp->lock);

    *** DEADLOCK ***

   Call trace:
    show_stack+0x18/0x24 (C)
    dump_stack_lvl+0xa0/0xf0
    dump_stack+0x18/0x24
    print_circular_bug+0x28c/0x370
    check_noncircular+0x198/0x1ac
    __lock_acquire+0x15a8/0x2084
    lock_acquire+0x1cc/0x350
    rt_spin_lock+0x50/0x1f0
    macb_start_xmit+0x808/0xb7c
    dev_hard_start_xmit+0x94/0x284
    sch_direct_xmit+0x8c/0x37c
    __dev_queue_xmit+0x708/0x1120
    neigh_resolve_output+0x148/0x28c
    ip6_finish_output2+0x2c0/0xb2c
    __ip6_finish_output+0x114/0x308
    ip6_output+0xc4/0x4a4
    mld_sendpack+0x220/0x68c
    mld_ifc_work+0x2a8/0x4f4
    process_one_work+0x20c/0x5f8
    worker_thread+0x1b0/0x35c
    kthread+0x144/0x200
    ret_from_fork+0x10/0x20

Notably, invoking the mog_init_rings() callback upon link establishment
is unnecessary. Instead, we can exclusively call mog_init_rings() within
the ndo_open() callback. This adjustment resolves the deadlock issue.
Furthermore, since MACB_CAPS_MACB_IS_EMAC cases do not use mog_init_rings()
when opening the network interface via at91ether_open(), moving
mog_init_rings() to macb_open() also eliminates the MACB_CAPS_MACB_IS_EMAC
check.

Fixes: 633e98a711ac ("net: macb: use resolved link config in mac_link_up()")
Cc: stable@vger.kernel.org
Suggested-by: Kevin Hao <kexin.hao@windriver.com>
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Link: https://patch.msgid.link/20251222015624.1994551-1-xiaolei.wang@windriver.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -744,7 +744,6 @@ static void macb_mac_link_up(struct phyl
 		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
 		 * cleared the pipeline and control registers.
 		 */
-		bp->macbgem_ops.mog_init_rings(bp);
 		macb_init_buffers(bp);
 
 		for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
@@ -2991,6 +2990,8 @@ static int macb_open(struct net_device *
 		goto pm_exit;
 	}
 
+	bp->macbgem_ops.mog_init_rings(bp);
+
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
 		napi_enable(&queue->napi_rx);
 		napi_enable(&queue->napi_tx);


