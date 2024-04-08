Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04697173E;
	Mon,  8 Apr 2024 13:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582019; cv=none; b=IA4nkFhH8lf6513TIb7wW+ffS4OeOhFJLXY8EYAnGyUCEFq9WDOe8OnY3AQGYjZvxceJsSyUCXCRJ4DBRYraDKOSKifbDSEQFOZ1h93F+RdZIxDNyjojzXTXdl2KnCaCw8u5O0Y732nKKDjfTiCx4xtd+077oP+Wh+AWlw78piw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582019; c=relaxed/simple;
	bh=Yp9xaFeN9IRh2PmjNOF84aiXiv3M3ApF+uKK+xfb2gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzy4gXEyf7bfkgYV9FY/ZNvjMGnDHmotcj5b/UkSo1GQUpZaqBROUnita0yPWoqXp4ND/4tvRHzAOiVGbTwMwib6cydGmoZg0pf6LO715F5udVgrfjnZvMznEhGNLVu6g1SM7fDwMXFyCWP9GF6pKFYDZSrNotKjmwZox9TNTW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODa4vlsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODa4vlsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA30C433C7;
	Mon,  8 Apr 2024 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582019;
	bh=Yp9xaFeN9IRh2PmjNOF84aiXiv3M3ApF+uKK+xfb2gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODa4vlsQ3gE0iVD/pG68FzWQjV2XvQrFo1Fu9M0IeN4wDS4IdWV8PJWlfQOr3qIqL
	 jcaij/ZubDbAn5im4IX/CRejBXFbGhebfP43kVZe5DJadAaLnFNbIs/P8iOv4QkDqb
	 G0S7R2JZhvJCXV7+8Jo4QLVnfubGLtgu7VgS6ck8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 040/273] mlxbf_gige: call request_irq() after NAPI initialized
Date: Mon,  8 Apr 2024 14:55:15 +0200
Message-ID: <20240408125310.534990634@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit f7442a634ac06b953fc1f7418f307b25acd4cfbc ]

The mlxbf_gige driver encounters a NULL pointer exception in
mlxbf_gige_open() when kdump is enabled.  The sequence to reproduce
the exception is as follows:
a) enable kdump
b) trigger kdump via "echo c > /proc/sysrq-trigger"
c) kdump kernel executes
d) kdump kernel loads mlxbf_gige module
e) the mlxbf_gige module runs its open() as the
   the "oob_net0" interface is brought up
f) mlxbf_gige module will experience an exception
   during its open(), something like:

     Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
     Mem abort info:
       ESR = 0x0000000086000004
       EC = 0x21: IABT (current EL), IL = 32 bits
       SET = 0, FnV = 0
       EA = 0, S1PTW = 0
       FSC = 0x04: level 0 translation fault
     user pgtable: 4k pages, 48-bit VAs, pgdp=00000000e29a4000
     [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
     Internal error: Oops: 0000000086000004 [#1] SMP
     CPU: 0 PID: 812 Comm: NetworkManager Tainted: G           OE     5.15.0-1035-bluefield #37-Ubuntu
     Hardware name: https://www.mellanox.com BlueField-3 SmartNIC Main Card/BlueField-3 SmartNIC Main Card, BIOS 4.6.0.13024 Jan 19 2024
     pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
     pc : 0x0
     lr : __napi_poll+0x40/0x230
     sp : ffff800008003e00
     x29: ffff800008003e00 x28: 0000000000000000 x27: 00000000ffffffff
     x26: ffff000066027238 x25: ffff00007cedec00 x24: ffff800008003ec8
     x23: 000000000000012c x22: ffff800008003eb7 x21: 0000000000000000
     x20: 0000000000000001 x19: ffff000066027238 x18: 0000000000000000
     x17: ffff578fcb450000 x16: ffffa870b083c7c0 x15: 0000aaab010441d0
     x14: 0000000000000001 x13: 00726f7272655f65 x12: 6769675f6662786c
     x11: 0000000000000000 x10: 0000000000000000 x9 : ffffa870b0842398
     x8 : 0000000000000004 x7 : fe5a48b9069706ea x6 : 17fdb11fc84ae0d2
     x5 : d94a82549d594f35 x4 : 0000000000000000 x3 : 0000000000400100
     x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000066027238
     Call trace:
      0x0
      net_rx_action+0x178/0x360
      __do_softirq+0x15c/0x428
      __irq_exit_rcu+0xac/0xec
      irq_exit+0x18/0x2c
      handle_domain_irq+0x6c/0xa0
      gic_handle_irq+0xec/0x1b0
      call_on_irq_stack+0x20/0x2c
      do_interrupt_handler+0x5c/0x70
      el1_interrupt+0x30/0x50
      el1h_64_irq_handler+0x18/0x2c
      el1h_64_irq+0x7c/0x80
      __setup_irq+0x4c0/0x950
      request_threaded_irq+0xf4/0x1bc
      mlxbf_gige_request_irqs+0x68/0x110 [mlxbf_gige]
      mlxbf_gige_open+0x5c/0x170 [mlxbf_gige]
      __dev_open+0x100/0x220
      __dev_change_flags+0x16c/0x1f0
      dev_change_flags+0x2c/0x70
      do_setlink+0x220/0xa40
      __rtnl_newlink+0x56c/0x8a0
      rtnl_newlink+0x58/0x84
      rtnetlink_rcv_msg+0x138/0x3c4
      netlink_rcv_skb+0x64/0x130
      rtnetlink_rcv+0x20/0x30
      netlink_unicast+0x2ec/0x360
      netlink_sendmsg+0x278/0x490
      __sock_sendmsg+0x5c/0x6c
      ____sys_sendmsg+0x290/0x2d4
      ___sys_sendmsg+0x84/0xd0
      __sys_sendmsg+0x70/0xd0
      __arm64_sys_sendmsg+0x2c/0x40
      invoke_syscall+0x78/0x100
      el0_svc_common.constprop.0+0x54/0x184
      do_el0_svc+0x30/0xac
      el0_svc+0x48/0x160
      el0t_64_sync_handler+0xa4/0x12c
      el0t_64_sync+0x1a4/0x1a8
     Code: bad PC value
     ---[ end trace 7d1c3f3bf9d81885 ]---
     Kernel panic - not syncing: Oops: Fatal exception in interrupt
     Kernel Offset: 0x2870a7a00000 from 0xffff800008000000
     PHYS_OFFSET: 0x80000000
     CPU features: 0x0,000005c1,a3332a5a
     Memory Limit: none
     ---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---

The exception happens because there is a pending RX interrupt before the
call to request_irq(RX IRQ) executes.  Then, the RX IRQ handler fires
immediately after this request_irq() completes. The RX IRQ handler runs
"napi_schedule()" before NAPI is fully initialized via "netif_napi_add()"
and "napi_enable()", both which happen later in the open() logic.

The logic in mlxbf_gige_open() must fully initialize NAPI before any calls
to request_irq() execute.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Link: https://lore.kernel.org/r/20240325183627.7641-1-davthompson@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c      | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index cef0e2d3f1a7b..77134ca929382 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -139,13 +139,10 @@ static int mlxbf_gige_open(struct net_device *netdev)
 	control |= MLXBF_GIGE_CONTROL_PORT_EN;
 	writeq(control, priv->base + MLXBF_GIGE_CONTROL);
 
-	err = mlxbf_gige_request_irqs(priv);
-	if (err)
-		return err;
 	mlxbf_gige_cache_stats(priv);
 	err = mlxbf_gige_clean_port(priv);
 	if (err)
-		goto free_irqs;
+		return err;
 
 	/* Clear driver's valid_polarity to match hardware,
 	 * since the above call to clean_port() resets the
@@ -166,6 +163,10 @@ static int mlxbf_gige_open(struct net_device *netdev)
 	napi_enable(&priv->napi);
 	netif_start_queue(netdev);
 
+	err = mlxbf_gige_request_irqs(priv);
+	if (err)
+		goto napi_deinit;
+
 	/* Set bits in INT_EN that we care about */
 	int_en = MLXBF_GIGE_INT_EN_HW_ACCESS_ERROR |
 		 MLXBF_GIGE_INT_EN_TX_CHECKSUM_INPUTS |
@@ -182,14 +183,17 @@ static int mlxbf_gige_open(struct net_device *netdev)
 
 	return 0;
 
+napi_deinit:
+	netif_stop_queue(netdev);
+	napi_disable(&priv->napi);
+	netif_napi_del(&priv->napi);
+	mlxbf_gige_rx_deinit(priv);
+
 tx_deinit:
 	mlxbf_gige_tx_deinit(priv);
 
 phy_deinit:
 	phy_stop(phydev);
-
-free_irqs:
-	mlxbf_gige_free_irqs(priv);
 	return err;
 }
 
-- 
2.43.0



