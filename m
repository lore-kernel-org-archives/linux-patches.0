Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9CF442FA6;
	Thu, 30 Jul 2026 15:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425314; cv=none; b=E6Q2iXklbK5vZI16loj4Fid/e+SJz441wShWxuOJLVbHEWS35X5/ttcMZ1m80RThzuCxSfPnzXz6RNmhNdduI1BCsbp1MIAEAtX85E5PuUjQfEXFxy2CkByCRtnPicfOsCQmVfVXDoIcE9+UnMTPw6VjeoayAGHBKcNankW8VMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425314; c=relaxed/simple;
	bh=7bg5vhQed3dpm1QCdmB2COBwaant5PWiQA580Qsm5Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkQ4RixG26yBtHOUq/FQ5rJL8nGouw+kEomEXBFfS1akEetvj6Y1oCn5SzOUDynnkp0uPD3ytlJ/TbI3EoSJo7ympNjgkpLIAKfMnQWD0wHUU3tNm86pWSt4I4P4x/fk8g2QV2jRCTsDsstfNibTLnQFjUeOrXzx+SGb3s/ImT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tfldbx8W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tfldbx8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA711F000E9;
	Thu, 30 Jul 2026 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425313;
	bh=sH0NgGp2HG/cmjXHB0HJuERRUsRZS5Vfxj3DcYTCXWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tfldbx8WDjiFj07gwffzKIUMXY6AJ7qqRcz9UCs97mmK8vJ2uMxP3SbJzwWdpoRSH
	 OTnlAqiHSwKrtg85EOs82Q7dxrwurlD1Xet8Z4xWzm1Wz5RUYatM7XgXuTgawWgCct
	 jiEjf6zvGP2Qf7bUy2faPnP0mXjnqycoXQLzAh+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/602] can: bcm: track a single source interface for ANYDEV timeout/throttle ops
Date: Thu, 30 Jul 2026 16:06:57 +0200
Message-ID: <20260730141436.532761589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 2f5976f54a04e9f18b25283036ac3136be453b17 upstream.

An ANYDEV rx op (ifindex == 0) with an active RX timeout and/or
throttle timer has no defined semantics when matching frames arrive
from several interfaces: bcm_rx_handler() can run concurrently for
the same op on different CPUs, racing hrtimer_cancel()/
bcm_rx_starttimer() against bcm_rx_timeout_handler() and causing
spurious RX_TIMEOUT notifications and last_frames corruption. The
same concurrency lets throttled multiplex frames from different
interfaces clobber the single rx_ifindex/rx_stamp fields shared by
the op.

Add op->if_detected to track the first interface that delivers a
matching frame while a timeout/throttle timer is configured, and
reject frames from any other interface for that op. The claim is
decided in bcm_rx_handler() before hrtimer_cancel() touches
op->timer, so a rejected frame can never disturb the claimed
interface's watchdog. RTR-mode ops are excluded via RX_RTR_FRAME,
independent of kt_ival1/kt_ival2, since those may briefly hold a
stale value from an earlier non-RTR configuration.

The claim is released in bcm_notify() on NETDEV_UNREGISTER and in
bcm_rx_setup() when SETTIMER reconfigures the timer values.

A (re-)claim is only possible on CAN devices in NETREG_REGISTERED
dev->reg_state to cover the release in bcm_notify() where reg_state
becomes NETREG_UNREGISTERING until synchronize_net().

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-can/20260709105031.1A39C1F000E9@smtp.kernel.org/
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260714-bcm_fixes-v15-11-562f7e3e42da@hartkopp.net
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/bcm.c | 49 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 0312b69a988c5f..0c7e6203eb44e2 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -116,6 +116,7 @@ struct bcm_op {
 	struct hrtimer timer, thrtimer;
 	ktime_t rx_stamp, kt_ival1, kt_ival2, kt_lastmsg;
 	int rx_ifindex;
+	int if_detected; /* first received ifindex in ANYDEV rx_op mode */
 	int cfsiz;
 	u32 count;
 	u32 nframes;
@@ -790,6 +791,33 @@ static void bcm_rx_handler(struct sk_buff *skb, void *data)
 			return;
 	}
 
+	/* An ANYDEV op with an active RX timeout and/or throttle timer
+	 * tracks a single source interface: claim the first interface that
+	 * delivers a matching frame and reject frames from any other one,
+	 * before hrtimer_cancel() below can touch op->timer - this avoids
+	 * racing bcm_rx_timeout_handler() across concurrent interfaces.
+	 * RX_RTR_FRAME ops are excluded, as kt_ival1/kt_ival2 may briefly
+	 * hold a stale value from an earlier non-RTR configuration.
+	 */
+	if (!op->ifindex) {
+		spin_lock_bh(&op->bcm_rx_update_lock);
+
+		if (!(op->flags & RX_RTR_FRAME) &&
+		    (op->kt_ival1 || op->kt_ival2)) {
+			/* don't claim to vanishing interface */
+			if (!op->if_detected &&
+			    skb->dev->reg_state == NETREG_REGISTERED)
+				op->if_detected = skb->dev->ifindex;
+
+			if (op->if_detected != skb->dev->ifindex) {
+				spin_unlock_bh(&op->bcm_rx_update_lock);
+				return;
+			}
+		}
+
+		spin_unlock_bh(&op->bcm_rx_update_lock);
+	}
+
 	/* disable timeout */
 	hrtimer_cancel(&op->timer);
 
@@ -824,10 +852,9 @@ static void bcm_rx_handler(struct sk_buff *skb, void *data)
 			traffic_flags |= RX_OWN;
 	}
 
-	/* save rx timestamp and originator for recvfrom() under lock.
-	 * For an op subscribed on all interfaces (ifindex == 0)
-	 * bcm_rx_handler() can run concurrently on different CPUs so
-	 * the CAN content and the meta data must be bundled correctly.
+	/* save rx timestamp and originator for recvfrom() under lock: an
+	 * ANYDEV op without an active timer can still run concurrently on
+	 * different CPUs, so content and meta data must be bundled here.
 	 */
 	op->rx_stamp = skb->tstamp;
 	op->rx_ifindex = skb->dev->ifindex;
@@ -1363,6 +1390,7 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 			op->kt_ival1 = bcm_timeval_to_ktime(msg_head->ival1);
 			op->kt_ival2 = bcm_timeval_to_ktime(msg_head->ival2);
 			op->kt_lastmsg = 0;
+			op->if_detected = 0; /* reclaim ifindex in ANYDEV mode */
 		}
 		spin_unlock_bh(&op->bcm_rx_update_lock);
 
@@ -1766,10 +1794,21 @@ static void bcm_notify(struct bcm_sock *bo, unsigned long msg,
 		lock_sock(sk);
 
 		/* rx_ops: remove device specific receive entries */
-		list_for_each_entry(op, &bo->rx_ops, list)
+		list_for_each_entry(op, &bo->rx_ops, list) {
 			if (op->rx_reg_dev == dev)
 				bcm_rx_unreg(dev, op);
 
+			/* release an ANYDEV op's claim (see bcm_rx_handler())
+			 * on this now confirmed-gone interface.
+			 */
+			if (!op->ifindex) {
+				spin_lock_bh(&op->bcm_rx_update_lock);
+				if (op->if_detected == dev->ifindex)
+					op->if_detected = 0;
+				spin_unlock_bh(&op->bcm_rx_update_lock);
+			}
+		}
+
 		/* tx_ops: stop device specific cyclic transmissions on the
 		 * vanishing ifindex. Cancelling the timer is enough to stop
 		 * cyclic bcm_can_tx() calls as there is no re-arming.
-- 
2.53.0



