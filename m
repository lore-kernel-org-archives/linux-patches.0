Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257DA226CFB;
	Mon,  2 Jun 2025 14:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875016; cv=none; b=goEiC1XjLAZ6FVE6N+h8H/RZpd3y/TCs8DX9Oc7UvILyPDy1pbXPeMfDp2ABqUVgFfOSKLGqbGzMW9LgJvQhgucB3VFUgHUgxUlp+QVoB2n+Uk0C4aWVq2cvCawUid6nBO43eZN9mMMtwpdewsU5/YN3H5Z3fbJQVAGNLYuZ134=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875016; c=relaxed/simple;
	bh=R2wdLxGPtkz3cfInEHzYwOT7uNpnLzaCTfbE2VUSzPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trh2zNdpaO7zbZCs6ueLeEZe8WVn1GhQYEP9Ww1hWGpXTA0q05UCUncB8aMG4LrOraJVx2kpTaTLHQ9WdJr3hckp+j31WiEk27cjKa66OyCrKPeoghZ0vz9V1N11B0XoGIwLT1qnOGVS6RnAGXP8YNg6foN4HUx+YxcIh89KKz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+p+x1tc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+p+x1tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A980FC4CEF2;
	Mon,  2 Jun 2025 14:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875016;
	bh=R2wdLxGPtkz3cfInEHzYwOT7uNpnLzaCTfbE2VUSzPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+p+x1tcMiod8Ew9JTbQtJrAl83A6o2AtpgNTMjOEt0m0mA6IN5xOuENqM5bQz1iy
	 VgOd8V2WLuFbFCdGARfUJ3dZdQqUuJhwbnN/rywxLGO/ST7d+M9Qx8Z31rk7SJEzmi
	 Sva04TuBQSyWf91YC6rLnz7+I/gJhRVoQPzzKRm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anderson Nascimento <anderson@allelesecurity.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH 5.4 176/204] can: bcm: add locking for bcm_op runtime updates
Date: Mon,  2 Jun 2025 15:48:29 +0200
Message-ID: <20250602134302.565492651@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit c2aba69d0c36a496ab4f2e81e9c2b271f2693fd7 upstream.

The CAN broadcast manager (CAN BCM) can send a sequence of CAN frames via
hrtimer. The content and also the length of the sequence can be changed
resp reduced at runtime where the 'currframe' counter is then set to zero.

Although this appeared to be a safe operation the updates of 'currframe'
can be triggered from user space and hrtimer context in bcm_can_tx().
Anderson Nascimento created a proof of concept that triggered a KASAN
slab-out-of-bounds read access which can be prevented with a spin_lock_bh.

At the rework of bcm_can_tx() the 'count' variable has been moved into
the protected section as this variable can be modified from both contexts
too.

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Reported-by: Anderson Nascimento <anderson@allelesecurity.com>
Tested-by: Anderson Nascimento <anderson@allelesecurity.com>
Reviewed-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20250519125027.11900-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/bcm.c |   66 +++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 21 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -58,6 +58,7 @@
 #include <linux/can/skb.h>
 #include <linux/can/bcm.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <net/sock.h>
 #include <net/net_namespace.h>
 
@@ -122,6 +123,7 @@ struct bcm_op {
 	struct canfd_frame last_sframe;
 	struct sock *sk;
 	struct net_device *rx_reg_dev;
+	spinlock_t bcm_tx_lock; /* protect currframe/count in runtime updates */
 };
 
 struct bcm_sock {
@@ -275,13 +277,18 @@ static void bcm_can_tx(struct bcm_op *op
 {
 	struct sk_buff *skb;
 	struct net_device *dev;
-	struct canfd_frame *cf = op->frames + op->cfsiz * op->currframe;
+	struct canfd_frame *cf;
 	int err;
 
 	/* no target device? => exit */
 	if (!op->ifindex)
 		return;
 
+	/* read currframe under lock protection */
+	spin_lock_bh(&op->bcm_tx_lock);
+	cf = op->frames + op->cfsiz * op->currframe;
+	spin_unlock_bh(&op->bcm_tx_lock);
+
 	dev = dev_get_by_index(sock_net(op->sk), op->ifindex);
 	if (!dev) {
 		/* RFC: should this bcm_op remove itself here? */
@@ -302,6 +309,10 @@ static void bcm_can_tx(struct bcm_op *op
 	skb->dev = dev;
 	can_skb_set_owner(skb, op->sk);
 	err = can_send(skb, 1);
+
+	/* update currframe and count under lock protection */
+	spin_lock_bh(&op->bcm_tx_lock);
+
 	if (!err)
 		op->frames_abs++;
 
@@ -310,6 +321,11 @@ static void bcm_can_tx(struct bcm_op *op
 	/* reached last frame? */
 	if (op->currframe >= op->nframes)
 		op->currframe = 0;
+
+	if (op->count > 0)
+		op->count--;
+
+	spin_unlock_bh(&op->bcm_tx_lock);
 out:
 	dev_put(dev);
 }
@@ -406,7 +422,7 @@ static enum hrtimer_restart bcm_tx_timeo
 	struct bcm_msg_head msg_head;
 
 	if (op->kt_ival1 && (op->count > 0)) {
-		op->count--;
+		bcm_can_tx(op);
 		if (!op->count && (op->flags & TX_COUNTEVT)) {
 
 			/* create notification to user */
@@ -421,7 +437,6 @@ static enum hrtimer_restart bcm_tx_timeo
 
 			bcm_send_to_user(op, &msg_head, NULL, 0);
 		}
-		bcm_can_tx(op);
 
 	} else if (op->kt_ival2) {
 		bcm_can_tx(op);
@@ -911,6 +926,27 @@ static int bcm_tx_setup(struct bcm_msg_h
 		}
 		op->flags = msg_head->flags;
 
+		/* only lock for unlikely count/nframes/currframe changes */
+		if (op->nframes != msg_head->nframes ||
+		    op->flags & TX_RESET_MULTI_IDX ||
+		    op->flags & SETTIMER) {
+
+			spin_lock_bh(&op->bcm_tx_lock);
+
+			if (op->nframes != msg_head->nframes ||
+			    op->flags & TX_RESET_MULTI_IDX) {
+				/* potentially update changed nframes */
+				op->nframes = msg_head->nframes;
+				/* restart multiple frame transmission */
+				op->currframe = 0;
+			}
+
+			if (op->flags & SETTIMER)
+				op->count = msg_head->count;
+
+			spin_unlock_bh(&op->bcm_tx_lock);
+		}
+
 	} else {
 		/* insert new BCM operation for the given can_id */
 
@@ -918,9 +954,14 @@ static int bcm_tx_setup(struct bcm_msg_h
 		if (!op)
 			return -ENOMEM;
 
+		spin_lock_init(&op->bcm_tx_lock);
 		op->can_id = msg_head->can_id;
 		op->cfsiz = CFSIZ(msg_head->flags);
 		op->flags = msg_head->flags;
+		op->nframes = msg_head->nframes;
+
+		if (op->flags & SETTIMER)
+			op->count = msg_head->count;
 
 		/* create array for CAN frames and copy the data */
 		if (msg_head->nframes > 1) {
@@ -979,22 +1020,8 @@ static int bcm_tx_setup(struct bcm_msg_h
 
 	} /* if ((op = bcm_find_op(&bo->tx_ops, msg_head->can_id, ifindex))) */
 
-	if (op->nframes != msg_head->nframes) {
-		op->nframes   = msg_head->nframes;
-		/* start multiple frame transmission with index 0 */
-		op->currframe = 0;
-	}
-
-	/* check flags */
-
-	if (op->flags & TX_RESET_MULTI_IDX) {
-		/* start multiple frame transmission with index 0 */
-		op->currframe = 0;
-	}
-
 	if (op->flags & SETTIMER) {
 		/* set timer values */
-		op->count = msg_head->count;
 		op->ival1 = msg_head->ival1;
 		op->ival2 = msg_head->ival2;
 		op->kt_ival1 = bcm_timeval_to_ktime(msg_head->ival1);
@@ -1011,11 +1038,8 @@ static int bcm_tx_setup(struct bcm_msg_h
 		op->flags |= TX_ANNOUNCE;
 	}
 
-	if (op->flags & TX_ANNOUNCE) {
+	if (op->flags & TX_ANNOUNCE)
 		bcm_can_tx(op);
-		if (op->count)
-			op->count--;
-	}
 
 	if (op->flags & STARTTIMER)
 		bcm_tx_start_timer(op);


