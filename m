Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74292288F9;
	Mon,  2 Jun 2025 14:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875783; cv=none; b=ZJ/LPrq07sWDvW1FUk1M+MMUal+9hG7EzziLOOQNa5lc7qeYQySZLSqVdcRLAnGfYgBgOZkmqOL5c2SOkZeay0MsROzNvUiZA4HIm6EixPJdNcNm9ISU5LKNgBq/cGeSmk79INmeGue3PpbiutWxz1gr60Ta4cqCpk7zBDbXM/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875783; c=relaxed/simple;
	bh=FLSQEfmvSlAlzXMNQLUxSSouJzxi4PUAKhaYSMFIusU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMPWFrsln9UicC348udqm6EIy7zkYSn+VQwoOq5AMDrYJhtS6oSTDFFiN6pJpggdALvB4sLuA7MgEcHPYqgYNvrDU+Y4FYxo+61bD8wCCWyL3Z1qjUYwdFeew6DKC4DIJ9yS4iRAqHTbGM5dDY0ESWeCKQ6Y3JqFPWRyHp4j8zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ly4QPLED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ly4QPLED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E50BC4CEEB;
	Mon,  2 Jun 2025 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875783;
	bh=FLSQEfmvSlAlzXMNQLUxSSouJzxi4PUAKhaYSMFIusU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ly4QPLEDRSGnslQ7mAvTv5yW4C0VXT5B85VVIptLLKZ5CEc2/Nm3mFDtZbMfsDVyk
	 C4nJYkjWLLi6agPRg5e/dYD8yqcTXEAbDuDo5fkI9qzS6hdodWiLZcypt6Unl2LMX0
	 ctYrucWU5BxL/xaqNbAPBO1XspEltXDUlGFhDClU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anderson Nascimento <anderson@allelesecurity.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 243/270] can: bcm: add missing rcu read protection for procfs content
Date: Mon,  2 Jun 2025 15:48:48 +0200
Message-ID: <20250602134317.265100787@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit dac5e6249159ac255dad9781793dbe5908ac9ddb upstream.

When the procfs content is generated for a bcm_op which is in the process
to be removed the procfs output might show unreliable data (UAF).

As the removal of bcm_op's is already implemented with rcu handling this
patch adds the missing rcu_read_lock() and makes sure the list entries
are properly removed under rcu protection.

Fixes: f1b4e32aca08 ("can: bcm: use call_rcu() instead of costly synchronize_rcu()")
Reported-by: Anderson Nascimento <anderson@allelesecurity.com>
Suggested-by: Anderson Nascimento <anderson@allelesecurity.com>
Tested-by: Anderson Nascimento <anderson@allelesecurity.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20250519125027.11900-2-socketcan@hartkopp.net
Cc: stable@vger.kernel.org # >= 5.4
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/bcm.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -207,7 +207,9 @@ static int bcm_proc_show(struct seq_file
 	seq_printf(m, " / bound %s", bcm_proc_getifname(net, ifname, bo->ifindex));
 	seq_printf(m, " <<<\n");
 
-	list_for_each_entry(op, &bo->rx_ops, list) {
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(op, &bo->rx_ops, list) {
 
 		unsigned long reduction;
 
@@ -263,6 +265,9 @@ static int bcm_proc_show(struct seq_file
 		seq_printf(m, "# sent %ld\n", op->frames_abs);
 	}
 	seq_putc(m, '\n');
+
+	rcu_read_unlock();
+
 	return 0;
 }
 #endif /* CONFIG_PROC_FS */
@@ -811,7 +816,7 @@ static int bcm_delete_rx_op(struct list_
 						  REGMASK(op->can_id),
 						  bcm_rx_handler, op);
 
-			list_del(&op->list);
+			list_del_rcu(&op->list);
 			bcm_remove_op(op);
 			return 1; /* done */
 		}
@@ -831,7 +836,7 @@ static int bcm_delete_tx_op(struct list_
 	list_for_each_entry_safe(op, n, ops, list) {
 		if ((op->can_id == mh->can_id) && (op->ifindex == ifindex) &&
 		    (op->flags & CAN_FD_FRAME) == (mh->flags & CAN_FD_FRAME)) {
-			list_del(&op->list);
+			list_del_rcu(&op->list);
 			bcm_remove_op(op);
 			return 1; /* done */
 		}
@@ -1253,7 +1258,7 @@ static int bcm_rx_setup(struct bcm_msg_h
 					      bcm_rx_handler, op, "bcm", sk);
 		if (err) {
 			/* this bcm rx op is broken -> remove it */
-			list_del(&op->list);
+			list_del_rcu(&op->list);
 			bcm_remove_op(op);
 			return err;
 		}


