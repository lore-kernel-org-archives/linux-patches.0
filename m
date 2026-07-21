Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F322EBB8D;
	Tue, 21 Jul 2026 20:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667377; cv=none; b=Vzr5A/TReDCpuja/A+dly1wLg0odL4+2JpxNdUIr4OPAghzgz5gKxLaZmFJhSZ5kgdm3mjDryqDyhCGnctDx5E9WLV0XqnJB7b8+689oQQsOi13AXAdt2xM1rQeaLfOPWfTYT4gNcjo0En5KQ0PDK8u0qTrGCYTZ54Euoi8R9RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667377; c=relaxed/simple;
	bh=S4gCGjWGvq0VnWmne0LQ3Z+hLPNHr+0IliflsVjdv7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CydEEFYPUd1KSSOzh9PjBoxLGZ9s+heXY2Ty+p1HqNlPwhfmOndmNpvl2aBBvJY4xHF4LYhGkUagDPrJfB3hTjMf+3ifS+1ubWZBZLDYq4er8400OeQU1PBWUFmGC5oA28nmkCQa7z1vaZoRybeqSyyCi1ewd9VoCEcVXjde3JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+0n6Syx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+0n6Syx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D181F000E9;
	Tue, 21 Jul 2026 20:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667376;
	bh=QmUFXs8KAYC+PaQCrUXBH/g0VlqlpMftryBcphtyA7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+0n6Syx1DndZsgIHUa/xE60N4IE5u8PQO/tSBcvHnwo8w4eqGXdBpvRtxHzYxuKp
	 oWMBVRFmptHj3L2sr52SwsDbh+dkpFFpZ2t2qwWZOjFZ+ETOGWozs8l71UiuEoPBXN
	 PAZ2CWKloZ28C8sJ20cOJIHfByirrM948CWKYrKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Xue <feng.xue@outlook.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Lee Jones <lee@kernel.org>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 1038/1266] can: bcm: defer rx_op deallocation to workqueue to fix thrtimer UAF
Date: Tue, 21 Jul 2026 17:24:35 +0200
Message-ID: <20260721152505.049026000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

commit 68973f9db76144825e4f35dfdc80fb8279eb2d57 upstream.

Commit f1b4e32aca08 ("can: bcm: use call_rcu() instead of costly
synchronize_rcu()") replaced synchronize_rcu() in bcm_delete_rx_op()
with call_rcu() and introduced the RX_NO_AUTOTIMER flag.

However, this flag check was omitted for thrtimer in the packet rx
fast-path. During BCM RX operation teardown, a concurrent RCU reader
(bcm_rx_handler) can race and re-arm thrtimer via
bcm_rx_update_and_send() after call_rcu() has been scheduled.  Once
the RCU grace period elapses, bcm_op is freed.  The subsequently
firing thrtimer then dereferences the deallocated op, causing a UAF.

Adding flag checks to the rx fast-path (bcm_rx_update_and_send) does not
fully close the TOCTOU race and introduces latency for every CAN frame.
Conversely, calling hrtimer_cancel() directly inside the RCU callback
(softirq context) is fatal as hrtimer_cancel() can sleep, triggering
a "scheduling while atomic" panic.

Resolve this by deferring the timer cancellation and memory free to a
dedicated unbound workqueue (bcm_wq).  The RCU callback now queues a
work item to bcm_wq, which safely cancels both timers and deallocates
memory in sleepable process context.  A dedicated workqueue is used to
prevent system-wide WQ saturation and is cleanly flushed/destroyed
on module unload to avoid rmmod page faults.

Since the deferred work can now outlive the calling context by an
unbounded amount, also take a reference on op->sk when it is assigned
and drop it only once the deferred work has cancelled both timers, so a
socket can no longer be freed out from under a still-armed timer whose
callback (bcm_send_to_user()) dereferences op->sk.

Fixes: f1b4e32aca08 ("can: bcm: use call_rcu() instead of costly synchronize_rcu()")
Tested-by: Feng Xue <feng.xue@outlook.com>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260714-bcm_fixes-v15-1-562f7e3e42da@hartkopp.net
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/bcm.c |   37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -58,6 +58,7 @@
 #include <linux/can/skb.h>
 #include <linux/can/bcm.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <net/sock.h>
 #include <net/net_namespace.h>
@@ -89,6 +90,8 @@ MODULE_ALIAS("can-proto-2");
 
 #define BCM_MIN_NAMELEN CAN_REQUIRED_SIZE(struct sockaddr_can, can_ifindex)
 
+static struct workqueue_struct *bcm_wq;
+
 /*
  * easy access to the first 64 bit of can(fd)_frame payload. cp->data is
  * 64 bit aligned so the offset has to be multiples of 8 which is ensured
@@ -102,6 +105,7 @@ static inline u64 get_u64(const struct c
 struct bcm_op {
 	struct list_head list;
 	struct rcu_head rcu;
+	struct work_struct work;
 	int ifindex;
 	canid_t can_id;
 	u32 flags;
@@ -745,9 +749,12 @@ static struct bcm_op *bcm_find_op(struct
 	return NULL;
 }
 
-static void bcm_free_op_rcu(struct rcu_head *rcu_head)
+static void bcm_free_op_work(struct work_struct *work)
 {
-	struct bcm_op *op = container_of(rcu_head, struct bcm_op, rcu);
+	struct bcm_op *op = container_of(work, struct bcm_op, work);
+
+	hrtimer_cancel(&op->timer);
+	hrtimer_cancel(&op->thrtimer);
 
 	if ((op->frames) && (op->frames != &op->sframe))
 		kfree(op->frames);
@@ -755,9 +762,23 @@ static void bcm_free_op_rcu(struct rcu_h
 	if ((op->last_frames) && (op->last_frames != &op->last_sframe))
 		kfree(op->last_frames);
 
+	/* the last possible access to op->timer/op->thrtimer has now
+	 * happened above via hrtimer_cancel() - op->sk is no longer
+	 * needed by any pending timer callback, so drop our reference
+	 */
+	sock_put(op->sk);
+
 	kfree(op);
 }
 
+static void bcm_free_op_rcu(struct rcu_head *rcu_head)
+{
+	struct bcm_op *op = container_of(rcu_head, struct bcm_op, rcu);
+
+	INIT_WORK(&op->work, bcm_free_op_work);
+	queue_work(bcm_wq, &op->work);
+}
+
 static void bcm_remove_op(struct bcm_op *op)
 {
 	hrtimer_cancel(&op->timer);
@@ -1012,6 +1033,7 @@ static int bcm_tx_setup(struct bcm_msg_h
 
 		/* bcm_can_tx / bcm_tx_timeout_handler needs this */
 		op->sk = sk;
+		sock_hold(sk);
 		op->ifindex = ifindex;
 
 		/* initialize uninitialized (kzalloc) structure */
@@ -1174,6 +1196,7 @@ static int bcm_rx_setup(struct bcm_msg_h
 
 		/* bcm_can_tx / bcm_tx_timeout_handler needs this */
 		op->sk = sk;
+		sock_hold(sk);
 		op->ifindex = ifindex;
 
 		/* ifindex for timeout events w/o previous frame reception */
@@ -1787,11 +1810,15 @@ static int __init bcm_module_init(void)
 {
 	int err;
 
+	bcm_wq = alloc_workqueue("can-bcm-wq", WQ_UNBOUND, 0);
+	if (!bcm_wq)
+		return -ENOMEM;
+
 	pr_info("can: broadcast manager protocol\n");
 
 	err = register_pernet_subsys(&canbcm_pernet_ops);
 	if (err)
-		return err;
+		goto register_pernet_failed;
 
 	err = register_netdevice_notifier(&canbcm_notifier);
 	if (err)
@@ -1809,6 +1836,8 @@ register_proto_failed:
 	unregister_netdevice_notifier(&canbcm_notifier);
 register_notifier_failed:
 	unregister_pernet_subsys(&canbcm_pernet_ops);
+register_pernet_failed:
+	destroy_workqueue(bcm_wq);
 	return err;
 }
 
@@ -1817,6 +1846,8 @@ static void __exit bcm_module_exit(void)
 	can_proto_unregister(&bcm_can_proto);
 	unregister_netdevice_notifier(&canbcm_notifier);
 	unregister_pernet_subsys(&canbcm_pernet_ops);
+	rcu_barrier();
+	destroy_workqueue(bcm_wq);
 }
 
 module_init(bcm_module_init);


