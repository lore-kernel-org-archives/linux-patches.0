Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A953D6474;
	Thu, 15 Jan 2026 17:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499749; cv=none; b=CPb97fM3Ka7KRypsO3rNv6HJi670dYkS2NEE8hC/SADagGu26jcmLKg4vJePtmxj9Id8r1FrL0FIUem6PFfWVPwm6mt3ubkCi1JizUDUGZqecsi0vA/1YvQhS0rHcwKb5kJA2SYB4svqFblGCZOi+9y7N0uOIroRrxEw5MnI4NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499749; c=relaxed/simple;
	bh=owac2MCe2iBJPGZEiy8V7FyNjrcSLfdQ+/prNmI1A/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZ1kGhctRFv+LAgHYY+xh9UnFAxN+qIJ4h/G4EWRk0qxoP/gmmeEIubfvIReSMwb6EFP83+EnHLrSlqg3hpLHGSQCtEq1XpyiApQvJjopGLUCVrl20ky81NXOmOVNnPYM6YmhuWrLMc0kcueAes4u/0pVJcLio8ZgU4/9ISK9fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGRZTEU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGRZTEU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7834C116D0;
	Thu, 15 Jan 2026 17:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499749;
	bh=owac2MCe2iBJPGZEiy8V7FyNjrcSLfdQ+/prNmI1A/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGRZTEU9Cx8rBqjk39tjwHRVFuv28dl1fKh6YkVeL0i/NCrVO8o5y+awL8Rof93PZ
	 RLQKFAGySezT1up5u2whAmvJCV0VW+JX/Z29vUKYjzYJj/1XiXJG6tTF0FTMBjE25a
	 JA6pa+prizAGGUxl5/jVW7n/VzyqmoecjoyVqYE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <kexin.hao@windriver.com>,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 335/451] net: macb: Relocate mog_init_rings() callback from macb_mac_link_up() to macb_open()
Date: Thu, 15 Jan 2026 17:48:56 +0100
Message-ID: <20260115164243.014159406@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -654,7 +654,6 @@ static void macb_mac_link_up(struct phyl
 		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
 		 * cleared the pipeline and control registers.
 		 */
-		bp->macbgem_ops.mog_init_rings(bp);
 		macb_init_buffers(bp);
 
 		for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
@@ -2287,6 +2286,8 @@ static void gem_init_rings(struct macb *
 	unsigned int q;
 	int i;
 
+	bp->macbgem_ops.mog_init_rings(bp);
+
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
 		for (i = 0; i < bp->tx_ring_size; i++) {
 			desc = macb_tx_desc(queue, i);


