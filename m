Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A7215ADD
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/G5W2Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D65C433C8;
	Mon, 16 Oct 2023 09:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697447165;
	bh=PVZGknIGjWUEqTR95INB/ZGx0N/sjips6r3Hd5UwSXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/G5W2Cdr/ghzPuLvB7g/Xcf8phJPXgpyoNqiRepraE699TtF8aulTh8aWk+0MH34
	 1rCmpQqXU1OYEgZ5aQIQuXf2tz3AFWBpDNnmMBv577z3jrDNOhgXi9bfqhdQJxOcAG
	 Jy89Sc9BdET20ByfSR5mWYGLrw5XIdrFmQWoujzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 001/191] net: stmmac: remove unneeded stmmac_poll_controller
Date: Mon, 16 Oct 2023 10:39:46 +0200
Message-ID: <20231016084015.436294403@linuxfoundation.org>
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

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 3eef8555891026628aa1cc6dbc01db86df88aa26 ]

Using netconsole netpoll_poll_dev could be called from interrupt
context, thus using disable_irq() would cause the following kernel
warning with CONFIG_DEBUG_ATOMIC_SLEEP enabled:

  BUG: sleeping function called from invalid context at kernel/irq/manage.c:137
  in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 10, name: ksoftirqd/0
  CPU: 0 PID: 10 Comm: ksoftirqd/0 Tainted: G        W         5.15.42-00075-g816b502b2298-dirty #117
  Hardware name: aml (r1) (DT)
  Call trace:
   dump_backtrace+0x0/0x270
   show_stack+0x14/0x20
   dump_stack_lvl+0x8c/0xac
   dump_stack+0x18/0x30
   ___might_sleep+0x150/0x194
   __might_sleep+0x64/0xbc
   synchronize_irq+0x8c/0x150
   disable_irq+0x2c/0x40
   stmmac_poll_controller+0x140/0x1a0
   netpoll_poll_dev+0x6c/0x220
   netpoll_send_skb+0x308/0x390
   netpoll_send_udp+0x418/0x760
   write_msg+0x118/0x140 [netconsole]
   console_unlock+0x404/0x500
   vprintk_emit+0x118/0x250
   dev_vprintk_emit+0x19c/0x1cc
   dev_printk_emit+0x90/0xa8
   __dev_printk+0x78/0x9c
   _dev_warn+0xa4/0xbc
   ath10k_warn+0xe8/0xf0 [ath10k_core]
   ath10k_htt_txrx_compl_task+0x790/0x7fc [ath10k_core]
   ath10k_pci_napi_poll+0x98/0x1f4 [ath10k_pci]
   __napi_poll+0x58/0x1f4
   net_rx_action+0x504/0x590
   _stext+0x1b8/0x418
   run_ksoftirqd+0x74/0xa4
   smpboot_thread_fn+0x210/0x3c0
   kthread+0x1fc/0x210
   ret_from_fork+0x10/0x20

Since [0] .ndo_poll_controller is only needed if driver doesn't or
partially use NAPI. Because stmmac does so, stmmac_poll_controller
can be removed fixing the above warning.

[0] commit ac3d9dd034e5 ("netpoll: make ndo_poll_controller() optional")

Cc: <stable@vger.kernel.org> # 5.15.x
Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet controllers")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/1c156a6d8c9170bd6a17825f2277115525b4d50f.1696429960.git.repk@triplefau.lt
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 30 -------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6931973028aef..e840cadb2d75a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5940,33 +5940,6 @@ static irqreturn_t stmmac_msi_intr_rx(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_NET_POLL_CONTROLLER
-/* Polling receive - used by NETCONSOLE and other diagnostic tools
- * to allow network I/O with interrupts disabled.
- */
-static void stmmac_poll_controller(struct net_device *dev)
-{
-	struct stmmac_priv *priv = netdev_priv(dev);
-	int i;
-
-	/* If adapter is down, do nothing */
-	if (test_bit(STMMAC_DOWN, &priv->state))
-		return;
-
-	if (priv->plat->multi_msi_en) {
-		for (i = 0; i < priv->plat->rx_queues_to_use; i++)
-			stmmac_msi_intr_rx(0, &priv->dma_conf.rx_queue[i]);
-
-		for (i = 0; i < priv->plat->tx_queues_to_use; i++)
-			stmmac_msi_intr_tx(0, &priv->dma_conf.tx_queue[i]);
-	} else {
-		disable_irq(dev->irq);
-		stmmac_interrupt(dev->irq, dev);
-		enable_irq(dev->irq);
-	}
-}
-#endif
-
 /**
  *  stmmac_ioctl - Entry point for the Ioctl
  *  @dev: Device pointer.
@@ -6802,9 +6775,6 @@ static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_eth_ioctl = stmmac_ioctl,
 	.ndo_setup_tc = stmmac_setup_tc,
 	.ndo_select_queue = stmmac_select_queue,
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller = stmmac_poll_controller,
-#endif
 	.ndo_set_mac_address = stmmac_set_mac_address,
 	.ndo_vlan_rx_add_vid = stmmac_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid = stmmac_vlan_rx_kill_vid,
-- 
2.40.1



