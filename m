Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EC0471250;
	Tue, 21 Jul 2026 18:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658956; cv=none; b=pT5sivWX2c/HjmvN6v5OY5l6gWzbiAwKP9Kdui1bri3h8QM95mrUE7jFC/AS5QPd1ZWE0/9rwkXIPUPiblllQn0T+lHz1ln3tXIwdHHOh9BC370eC5iyKvODkCJHtnh/233PEmRDtOqsp6ti+t2PKbqhmvD2F+XHXZM8pR+JxVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658956; c=relaxed/simple;
	bh=YuhpRy213Dcz+n3oKcUkuIIhrS6wmJoZU3bcNxeVwmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kU+mDRC/bmJZzn2g4JYbiLSUm2sfM9si2wTWi9A0eYALWZW35j+jx38oDFG/ZRJu1L/o9JH7a3BjZX3DiIymGAlTxGhmoeE/5z6Kw8J/LvTabCUbBTXiAyZqqe33Ap2nj2swpDvTuHoWrmNJrc1zb3TEyiDXwOPXgGmQAy79ORk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wd8oD+K5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wd8oD+K5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190A51F000E9;
	Tue, 21 Jul 2026 18:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658954;
	bh=yYj/4y1ryBr8ecT+7DR7i9eP8DusOQl7WEJY1/ziHp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wd8oD+K5HXrHfyMisWEPoQQCQkXPhSzvSxnPKdP0wVj/tWDz1R3x2ixu1auDTJma5
	 6URtIXhZ8BbKxCTv1l7Pch4xg3OAwTSOW2EFF2x8eOje5gr9D00zq6CqaC9pK/0ePG
	 qnPwuvgWb6NzKiafs9PHHXmItbx9R4g5bqwhdfUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-reviews@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 1337/1611] can: bcm: add missing rcu list annotations and operations
Date: Tue, 21 Jul 2026 17:24:13 +0200
Message-ID: <20260721152545.525710914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 7b2c3eabc4dafc062a25e10711154f2107526a78 upstream.

sashiko-bot remarked the missing use of list_add_rcu() in
bcm_[rx|tx]_setup() to have a proper initialized bcm_op structure
when bcm_proc_show() traverses the bcm_op's under rcu_read_lock().

To cover all initial settings of the bcm_op's the list_add_rcu() calls
are moved to the end of the setup code.

While at it, also fix the mirroring removal side: bcm_release() called
bcm_remove_op() - which frees the op via call_rcu() - on ops that were
still linked in bo->tx_ops/bo->rx_ops, without list_del_rcu() first.
Unlink each op with list_del_rcu() before handing it to bcm_remove_op(),
matching the existing pattern in bcm_delete_tx_op()/bcm_delete_rx_op().

Reported-by: sashiko-reviews@lists.linux.dev
Closes: https://lore.kernel.org/linux-can/20260610094654.A1FFE1F00893@smtp.kernel.org/
Fixes: dac5e6249159 ("can: bcm: add missing rcu read protection for procfs content")
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260714-bcm_fixes-v15-5-562f7e3e42da@hartkopp.net
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/bcm.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -260,7 +260,7 @@ static int bcm_proc_show(struct seq_file
 			   (reduction == 100) ? "near " : "", reduction);
 	}
 
-	list_for_each_entry(op, &bo->tx_ops, list) {
+	list_for_each_entry_rcu(op, &bo->tx_ops, list) {
 
 		seq_printf(m, "tx_op: %03X %s ", op->can_id,
 			   bcm_proc_getifname(net, ifname, op->ifindex));
@@ -946,6 +946,7 @@ static int bcm_tx_setup(struct bcm_msg_h
 	struct bcm_sock *bo = bcm_sk(sk);
 	struct bcm_op *op;
 	struct canfd_frame *cf;
+	bool add_op_to_list = false;
 	unsigned int i;
 	int err;
 
@@ -1087,8 +1088,7 @@ static int bcm_tx_setup(struct bcm_msg_h
 		hrtimer_setup(&op->thrtimer, hrtimer_dummy_timeout, CLOCK_MONOTONIC,
 			      HRTIMER_MODE_REL_SOFT);
 
-		/* add this bcm_op to the list of the tx_ops */
-		list_add(&op->list, &bo->tx_ops);
+		add_op_to_list = true;
 
 	} /* if ((op = bcm_find_op(&bo->tx_ops, msg_head->can_id, ifindex))) */
 
@@ -1110,6 +1110,10 @@ static int bcm_tx_setup(struct bcm_msg_h
 		op->flags |= TX_ANNOUNCE;
 	}
 
+	/* add this bcm_op to the list of the tx_ops? */
+	if (add_op_to_list)
+		list_add_rcu(&op->list, &bo->tx_ops);
+
 	if (op->flags & TX_ANNOUNCE)
 		bcm_can_tx(op);
 
@@ -1250,9 +1254,6 @@ static int bcm_rx_setup(struct bcm_msg_h
 		hrtimer_setup(&op->thrtimer, bcm_rx_thr_handler, CLOCK_MONOTONIC,
 			      HRTIMER_MODE_REL_SOFT);
 
-		/* add this bcm_op to the list of the rx_ops */
-		list_add(&op->list, &bo->rx_ops);
-
 		/* call can_rx_register() */
 		do_rx_register = 1;
 
@@ -1331,10 +1332,12 @@ static int bcm_rx_setup(struct bcm_msg_h
 					      bcm_rx_handler, op, "bcm", sk);
 		if (err) {
 			/* this bcm rx op is broken -> remove it */
-			list_del_rcu(&op->list);
 			bcm_remove_op(op);
 			return err;
 		}
+
+		/* add this bcm_op to the list of the rx_ops */
+		list_add_rcu(&op->list, &bo->rx_ops);
 	}
 
 	return msg_head->nframes * op->cfsiz + MHSIZ;
@@ -1664,8 +1667,10 @@ static int bcm_release(struct socket *so
 		remove_proc_entry(bo->procname, net->can.bcmproc_dir);
 #endif /* CONFIG_PROC_FS */
 
-	list_for_each_entry_safe(op, next, &bo->tx_ops, list)
+	list_for_each_entry_safe(op, next, &bo->tx_ops, list) {
+		list_del_rcu(&op->list);
 		bcm_remove_op(op);
+	}
 
 	list_for_each_entry_safe(op, next, &bo->rx_ops, list) {
 		/*
@@ -1696,8 +1701,10 @@ static int bcm_release(struct socket *so
 
 	synchronize_rcu();
 
-	list_for_each_entry_safe(op, next, &bo->rx_ops, list)
+	list_for_each_entry_safe(op, next, &bo->rx_ops, list) {
+		list_del_rcu(&op->list);
 		bcm_remove_op(op);
+	}
 
 	/* remove device reference */
 	if (bo->bound) {


