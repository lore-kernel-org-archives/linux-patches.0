Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A616ABB
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A99C43395;
	Sun, 17 Sep 2023 20:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982047;
	bh=us/Z7j9BKAP9zsxzrgucXlnLIICC+8xE7rslnRBdIpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zzp0RfTvl281cNW6+T0DOBqW1j22Fk7Qv74cQho3vlX6ef7QyOS+id3iMPPbebgZS
	 kSYf+A8vXqp7XILeH3qDvXnYKnOa9Ovnf1K/242JFU0hLoJaA1Ga6RlDXI5BuJLmH1
	 Vi7KxxKWC11x9wtEW7vDnoajY6rUWiZISUvP+XSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/219] net: macb: fix sleep inside spinlock
Date: Sun, 17 Sep 2023 21:15:37 +0200
Message-ID: <20230917191048.523066573@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 403f0e771457e2b8811dc280719d11b9bacf10f4 ]

macb_set_tx_clk() is called under a spinlock but itself calls clk_set_rate()
which can sleep. This results in:

| BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
| pps pps1: new PPS source ptp1
| in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 40, name: kworker/u4:3
| preempt_count: 1, expected: 0
| RCU nest depth: 0, expected: 0
| 4 locks held by kworker/u4:3/40:
|  #0: ffff000003409148
| macb ff0c0000.ethernet: gem-ptp-timer ptp clock registered.
|  ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work+0x14c/0x51c
|  #1: ffff8000833cbdd8 ((work_completion)(&pl->resolve)){+.+.}-{0:0}, at: process_one_work+0x14c/0x51c
|  #2: ffff000004f01578 (&pl->state_mutex){+.+.}-{4:4}, at: phylink_resolve+0x44/0x4e8
|  #3: ffff000004f06f50 (&bp->lock){....}-{3:3}, at: macb_mac_link_up+0x40/0x2ac
| irq event stamp: 113998
| hardirqs last  enabled at (113997): [<ffff800080e8503c>] _raw_spin_unlock_irq+0x30/0x64
| hardirqs last disabled at (113998): [<ffff800080e84478>] _raw_spin_lock_irqsave+0xac/0xc8
| softirqs last  enabled at (113608): [<ffff800080010630>] __do_softirq+0x430/0x4e4
| softirqs last disabled at (113597): [<ffff80008001614c>] ____do_softirq+0x10/0x1c
| CPU: 0 PID: 40 Comm: kworker/u4:3 Not tainted 6.5.0-11717-g9355ce8b2f50-dirty #368
| Hardware name: ... ZynqMP ... (DT)
| Workqueue: events_power_efficient phylink_resolve
| Call trace:
|  dump_backtrace+0x98/0xf0
|  show_stack+0x18/0x24
|  dump_stack_lvl+0x60/0xac
|  dump_stack+0x18/0x24
|  __might_resched+0x144/0x24c
|  __might_sleep+0x48/0x98
|  __mutex_lock+0x58/0x7b0
|  mutex_lock_nested+0x24/0x30
|  clk_prepare_lock+0x4c/0xa8
|  clk_set_rate+0x24/0x8c
|  macb_mac_link_up+0x25c/0x2ac
|  phylink_resolve+0x178/0x4e8
|  process_one_work+0x1ec/0x51c
|  worker_thread+0x1ec/0x3e4
|  kthread+0x120/0x124
|  ret_from_fork+0x10/0x20

The obvious fix is to move the call to macb_set_tx_clk() out of the
protected area. This seems safe as rx and tx are both disabled anyway at
this point.
It is however not entirely clear what the spinlock shall protect. It
could be the read-modify-write access to the NCFGR register, but this
is accessed in macb_set_rx_mode() and macb_set_rxcsum_feature() as well
without holding the spinlock. It could also be the register accesses
done in mog_init_rings() or macb_init_buffers(), but again these
functions are called without holding the spinlock in macb_hresp_error_task().
The locking seems fishy in this driver and it might deserve another look
before this patch is applied.

Fixes: 633e98a711ac0 ("net: macb: use resolved link config in mac_link_up()")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20230908112913.1701766-1-s.hauer@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 9470e895591e5..54b032a46b48a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -705,8 +705,6 @@ static void macb_mac_link_up(struct phylink_config *config,
 		if (rx_pause)
 			ctrl |= MACB_BIT(PAE);
 
-		macb_set_tx_clk(bp, speed);
-
 		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
 		 * cleared the pipeline and control registers.
 		 */
@@ -726,6 +724,9 @@ static void macb_mac_link_up(struct phylink_config *config,
 
 	spin_unlock_irqrestore(&bp->lock, flags);
 
+	if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC))
+		macb_set_tx_clk(bp, speed);
+
 	/* Enable Rx and Tx; Enable PTP unicast */
 	ctrl = macb_readl(bp, NCR);
 	if (gem_has_ptp(bp))
-- 
2.40.1



