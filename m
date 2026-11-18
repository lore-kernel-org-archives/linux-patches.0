Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021336;
	b=zJzwar1l3SZEqWAkS7mi9avRIWlUgVNok/oE1hCYdA4pTfMrCMAPYs2XDBr1nlybam5w
	 yx16gVz3KPVqTFA9oovcURyHK3WoUiXVU5/KUrKYtB3+K0tKZ1P0eLImwSbs2ivmAw005
	 c1/NqOz9AD8qX4Bh93Smvm+gbqO6NoU0QWwC5FucOpl1dq9Q73D+MxcsNzCaLqls1iDl6
	 nu7OYYiGk96XpQLA1FfdZWufXChmPis+Z2SIZkth03bpOh9QARbz06TO1a8ndjaS6jUhR
	 zgxNddvf7TwFynD+CqumUlM1g9eZPF15obDkFI23MXteV54qXv+bdaqxidcO3K/PpYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KAkpYPFCnLpn5qPgH/ZmmO+4xBKV3y/JUgRQ/KDWAl8=;
	b=aiG3T8ZWfibemGozZSyMISXDayHgzQc6mo/kcWb97cZ4TgByvuE2kUb1S+ZruAHGWRA8
	 9s+XU6icCSp1zIndIr/HbyMLcOdz1iK2gyuxls+W48btR9MKsQF6VD1SUUrZQA7hHaBOK
	 rlNOYKT3jDRa6N1nWhRX1lFAhzWmu5OLnf5MikV2d7ueF0j4S/yrQ9XYQkoc6PszfSnJ1
	 HXI0LC9rbMVurhC2ySz5B7ODzA2oaVxaTMXK/hJNG3EyaTuEadElEQOO0k+XKv0u9eUhs
	 uVIvExZz4XklLa5ueJpn8xbZ0kdTSPF/m/NntDpotcr0eHpu2OwVZ2i5nNzfcvxx8mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfWzajFT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737FC606A338;
	Wed, 18 Nov 2026 17:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfWzajFT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C059A1F000C4;
	Wed, 18 Nov 2026 17:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021336;
	bh=KAkpYPFCnLpn5qPgH/ZmmO+4xBKV3y/JUgRQ/KDWAl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfWzajFTx/9u9WQm3Gi7h7Sd1tQb3ot7jWsFqCTYf0skkSJNmPzwsUb1O3bvwfJkw
	 oxpKdco4pCVtazXJZKv/5y6tV9su00++g5vmH5pVFH4Qsl4QJob47m65gmvLzlqfxB
	 t3Z5Lt8Z9iEoSB8NcMxE3l5SQ5d/3CWuSVrRDgyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2269/2651] ibmveth: fix netpoll races with RX replenish
Date: Wed, 18 Nov 2026 15:58:29 +0100
Message-ID: <20261118150407.052732799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingming Cao <mmc@linux.ibm.com>

[ Upstream commit 8d9ecac6b96e61d0e6d126c60644829fd9f66952 ]

ibmveth_poll_controller() runs RX replenish outside NAPI and without
a lock, racing NAPI's replenish on another CPU. Both can fill the
same slot, so an skb and its DMA mapping leak and PHYP can write
into an unmapped buffer. netpoll calls it from netconsole and from
netpoll-enabled bonds.

ibmveth_open() also enables NAPI before the RX resources exist.
ibmveth_change_mtu(), veth_pool_store(), ibmveth_set_csum_offload()
and ibmveth_set_tso() call close() and open() directly, so while
open() is still setting up, netpoll and the direct ibmveth_interrupt()
calls can replenish NULL pools and read freed memory.

Remove the callback, as Eric Dumazet did for many drivers after
commit ac3d9dd034e5 ("netpoll: make ndo_poll_controller() optional"),
including ibmvnic in commit 0c3b9d1b37df ("ibmvnic: remove
ndo_poll_controller"). netpoll then polls NAPI itself with budget 0.
napi->poll_owner serializes that with NAPI, but not with a NAPI poll
that was already running when netpoll was set up, so skip RX
replenish at budget 0, which netpoll uses for TX only. TX completes
synchronously, so ibmveth_poll() has nothing else to do for netpoll.

Enable NAPI just before request_irq(), once everything
ibmveth_poll() touches exists.

Found in review of the ibmveth multi-queue RX series and confirmed by
code inspection of poll_one_napi() and the direct close()/open()
callers; neither race was reproduced. Tested on a POWER10 LPAR with
netconsole over ibmveth: a ping flood (678,470 packets, no loss) during
a printk flood, and MTU changes and buffer pool toggles under traffic,
with no warnings. No kernel selftests cover ibmveth.

Fixes: 6b4223748895 ("[PATCH] ibmveth: Add netpoll function")
Fixes: bea3348eef27 ("[NET]: Make NAPI polling independent of struct net_device objects.")
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Link: https://patch.msgid.link/20261013182926.30417-2-mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmveth.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index abebdb1fc2628..4a5869183be66 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -628,8 +628,6 @@ static int ibmveth_open(struct net_device *netdev)
 
 	netdev_dbg(netdev, "open starting\n");
 
-	napi_enable(&adapter->napi);
-
 	for(i = 0; i < IBMVETH_NUM_BUFF_POOLS; i++)
 		rxq_entries += adapter->rx_buff_pool[i].size;
 
@@ -717,10 +715,18 @@ static int ibmveth_open(struct net_device *netdev)
 		}
 	}
 
+	/* NAPI can run as soon as it is enabled, from netpoll during the
+	 * direct close()/open() pairs or from a direct ibmveth_interrupt()
+	 * call, so enable it only once everything ibmveth_poll() touches
+	 * exists.
+	 */
+	napi_enable(&adapter->napi);
+
 	netdev_dbg(netdev, "registering irq 0x%x\n", netdev->irq);
 	rc = request_irq(netdev->irq, ibmveth_interrupt, 0, netdev->name,
 			 netdev);
 	if (rc != 0) {
+		napi_disable(&adapter->napi);
 		netdev_err(netdev, "unable to request irq 0x%x, rc %d\n",
 			   netdev->irq, rc);
 		goto out_free_buffer_pools;
@@ -765,7 +771,6 @@ static int ibmveth_open(struct net_device *netdev)
 out_free_buffer_list:
 	free_page((unsigned long)adapter->buffer_list_addr);
 out:
-	napi_disable(&adapter->napi);
 	return rc;
 }
 
@@ -1542,7 +1547,11 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
 		}
 	}
 
-	ibmveth_replenish_task(adapter);
+	/* netpoll polls with budget 0 for TX only, and is not serialized
+	 * with a NAPI poll that was already running when it was set up
+	 */
+	if (budget)
+		ibmveth_replenish_task(adapter);
 
 	if (frames_processed == budget)
 		goto out;
@@ -1682,14 +1691,6 @@ static int ibmveth_change_mtu(struct net_device *dev, int new_mtu)
 	return -EINVAL;
 }
 
-#ifdef CONFIG_NET_POLL_CONTROLLER
-static void ibmveth_poll_controller(struct net_device *dev)
-{
-	ibmveth_replenish_task(netdev_priv(dev));
-	ibmveth_interrupt(dev->irq, dev);
-}
-#endif
-
 /**
  * ibmveth_get_desired_dma - Calculate IO memory desired by the driver
  *
@@ -1791,9 +1792,6 @@ static const struct net_device_ops ibmveth_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address    = ibmveth_set_mac_addr,
 	.ndo_features_check	= ibmveth_features_check,
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller	= ibmveth_poll_controller,
-#endif
 };
 
 static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
-- 
2.53.0



