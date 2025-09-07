Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10FA4315A;
	Sun,  7 Sep 2025 20:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277697; cv=none; b=Ayj0PAOtERUn1jgu1uIMVfzzhBJZ0EEPO1BwQ7Lnq/nYkPvKwkN7XYt+HwMrlPpX2ZrFJ2/KSUswXtuH/2v9zwnIrN/u38YqhFSCZo2gYnOvgt2TVuWGZUtznW9j502KuRg3dJNvORxLP3d98cQoxikU1NW6zAvoyx1DEj4cWxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277697; c=relaxed/simple;
	bh=3vAkz7xOpBTqg/zJosKh7vNxFkEWqSu86inMl/LMarE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gkmfwy5Kt1dVTEN7Gpsdvr7hRmY7Dia9d5rZV7rqbSt9SO4swaM5awyk9iNXVNaRZOhxlSUQlX7Loal0Hk/dxh2KAlOzMdmxkWctPeIamJ+i3plKkWjqqAFL8u2E4TK8e0tmxCONFfaM50LroVjhqU3VjBXiIJcuwpmM/lSurKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1zKG3PT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1zKG3PT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3833FC4CEF0;
	Sun,  7 Sep 2025 20:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277697;
	bh=3vAkz7xOpBTqg/zJosKh7vNxFkEWqSu86inMl/LMarE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1zKG3PTsub1RHH/7ry/PCdVWAbFt8tKBsrRRYXeBvZqN9n4u9kmJtEVj4/Zz6bz5
	 IaGiJGuPsgOqDn82LkgeUz9oXXYARpQtUHMeK6tdnbdhRVX0eJW/YpS7A22yK4UdYK
	 zCgdtAn9zzjC+YhhYA07NcNCJTKlUyEu9gALcpdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 095/183] phy: mscc: Stop taking ts_lock for tx_queue and use its own lock
Date: Sun,  7 Sep 2025 21:58:42 +0200
Message-ID: <20250907195618.044442065@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 9b2bfdbf43adb9929c5ddcdd96efedbf1c88cf53 ]

When transmitting a PTP frame which is timestamp using 2 step, the
following warning appears if CONFIG_PROVE_LOCKING is enabled:
=============================
[ BUG: Invalid wait context ]
6.17.0-rc1-00326-ge6160462704e #427 Not tainted
-----------------------------
ptp4l/119 is trying to lock:
c2a44ed4 (&vsc8531->ts_lock){+.+.}-{3:3}, at: vsc85xx_txtstamp+0x50/0xac
other info that might help us debug this:
context-{4:4}
4 locks held by ptp4l/119:
 #0: c145f068 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x58/0x1440
 #1: c29df974 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: __dev_queue_xmit+0x5c4/0x1440
 #2: c2aaaad0 (_xmit_ETHER#2){+.-.}-{2:2}, at: sch_direct_xmit+0x108/0x350
 #3: c2aac170 (&lan966x->tx_lock){+.-.}-{2:2}, at: lan966x_port_xmit+0xd0/0x350
stack backtrace:
CPU: 0 UID: 0 PID: 119 Comm: ptp4l Not tainted 6.17.0-rc1-00326-ge6160462704e #427 NONE
Hardware name: Generic DT based system
Call trace:
 unwind_backtrace from show_stack+0x10/0x14
 show_stack from dump_stack_lvl+0x7c/0xac
 dump_stack_lvl from __lock_acquire+0x8e8/0x29dc
 __lock_acquire from lock_acquire+0x108/0x38c
 lock_acquire from __mutex_lock+0xb0/0xe78
 __mutex_lock from mutex_lock_nested+0x1c/0x24
 mutex_lock_nested from vsc85xx_txtstamp+0x50/0xac
 vsc85xx_txtstamp from lan966x_fdma_xmit+0xd8/0x3a8
 lan966x_fdma_xmit from lan966x_port_xmit+0x1bc/0x350
 lan966x_port_xmit from dev_hard_start_xmit+0xc8/0x2c0
 dev_hard_start_xmit from sch_direct_xmit+0x8c/0x350
 sch_direct_xmit from __dev_queue_xmit+0x680/0x1440
 __dev_queue_xmit from packet_sendmsg+0xfa4/0x1568
 packet_sendmsg from __sys_sendto+0x110/0x19c
 __sys_sendto from sys_send+0x18/0x20
 sys_send from ret_fast_syscall+0x0/0x1c
Exception stack(0xf0b05fa8 to 0xf0b05ff0)
5fa0:                   00000001 0000000e 0000000e 0004b47a 0000003a 00000000
5fc0: 00000001 0000000e 00000000 00000121 0004af58 00044874 00000000 00000000
5fe0: 00000001 bee9d420 00025a10 b6e75c7c

So, instead of using the ts_lock for tx_queue, use the spinlock that
skb_buff_head has.

Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Fixes: 7d272e63e0979d ("net: phy: mscc: timestamping and PHC support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://patch.msgid.link/20250902121259.3257536-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_ptp.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index 72847320cb652..d692df7d975c7 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -456,12 +456,12 @@ static void vsc85xx_dequeue_skb(struct vsc85xx_ptp *ptp)
 		*p++ = (reg >> 24) & 0xff;
 	}
 
-	len = skb_queue_len(&ptp->tx_queue);
+	len = skb_queue_len_lockless(&ptp->tx_queue);
 	if (len < 1)
 		return;
 
 	while (len--) {
-		skb = __skb_dequeue(&ptp->tx_queue);
+		skb = skb_dequeue(&ptp->tx_queue);
 		if (!skb)
 			return;
 
@@ -486,7 +486,7 @@ static void vsc85xx_dequeue_skb(struct vsc85xx_ptp *ptp)
 		 * packet in the FIFO right now, reschedule it for later
 		 * packets.
 		 */
-		__skb_queue_tail(&ptp->tx_queue, skb);
+		skb_queue_tail(&ptp->tx_queue, skb);
 	}
 }
 
@@ -1068,6 +1068,7 @@ static int vsc85xx_hwtstamp(struct mii_timestamper *mii_ts,
 	case HWTSTAMP_TX_ON:
 		break;
 	case HWTSTAMP_TX_OFF:
+		skb_queue_purge(&vsc8531->ptp->tx_queue);
 		break;
 	default:
 		return -ERANGE;
@@ -1092,9 +1093,6 @@ static int vsc85xx_hwtstamp(struct mii_timestamper *mii_ts,
 
 	mutex_lock(&vsc8531->ts_lock);
 
-	__skb_queue_purge(&vsc8531->ptp->tx_queue);
-	__skb_queue_head_init(&vsc8531->ptp->tx_queue);
-
 	/* Disable predictor while configuring the 1588 block */
 	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
 				  MSCC_PHY_PTP_INGR_PREDICTOR);
@@ -1180,9 +1178,7 @@ static void vsc85xx_txtstamp(struct mii_timestamper *mii_ts,
 
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
-	mutex_lock(&vsc8531->ts_lock);
-	__skb_queue_tail(&vsc8531->ptp->tx_queue, skb);
-	mutex_unlock(&vsc8531->ts_lock);
+	skb_queue_tail(&vsc8531->ptp->tx_queue, skb);
 	return;
 
 out:
@@ -1548,6 +1544,7 @@ void vsc8584_ptp_deinit(struct phy_device *phydev)
 	if (vsc8531->ptp->ptp_clock) {
 		ptp_clock_unregister(vsc8531->ptp->ptp_clock);
 		skb_queue_purge(&vsc8531->rx_skbs_list);
+		skb_queue_purge(&vsc8531->ptp->tx_queue);
 	}
 }
 
@@ -1571,7 +1568,7 @@ irqreturn_t vsc8584_handle_ts_interrupt(struct phy_device *phydev)
 	if (rc & VSC85XX_1588_INT_FIFO_ADD) {
 		vsc85xx_get_tx_ts(priv->ptp);
 	} else if (rc & VSC85XX_1588_INT_FIFO_OVERFLOW) {
-		__skb_queue_purge(&priv->ptp->tx_queue);
+		skb_queue_purge(&priv->ptp->tx_queue);
 		vsc85xx_ts_reset_fifo(phydev);
 	}
 
@@ -1591,6 +1588,7 @@ int vsc8584_ptp_probe(struct phy_device *phydev)
 	mutex_init(&vsc8531->phc_lock);
 	mutex_init(&vsc8531->ts_lock);
 	skb_queue_head_init(&vsc8531->rx_skbs_list);
+	skb_queue_head_init(&vsc8531->ptp->tx_queue);
 
 	/* Retrieve the shared load/save GPIO. Request it as non exclusive as
 	 * the same GPIO can be requested by all the PHYs of the same package.
-- 
2.50.1



