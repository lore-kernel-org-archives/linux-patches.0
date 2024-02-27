Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C281CFA9;
	Tue, 27 Feb 2024 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040663; cv=none; b=XWlf+ufDkyLV2JQljt4vIHmCx5vnPXZtIHcq3FmVVtw5B8c5UJp/HCtsXAqwaKKHZeRcLm2KJICaGMp43lX9wWXeN5EuQlnzkPgtl//UtmhJiIiWX8owc5WCwMylxsIyqgPLbWh4gOL+cuXKvfnKkWMIRmNjSr9GStkDvcB04Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040663; c=relaxed/simple;
	bh=AU1CWaqg/Tpv1SKEaJgmRas0hsDaFnoWBUAtzWXd8ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4nj8evFO/XIbGWF6i2U+Q7EJk573NGnvLa14SqXNcqT3YOpkgShqDW1lZ+pegCwcYjLdwQVI0OBZs1aVPA84BBp2Pjm0zhuDDsdxZUjpSdIpSGoF+dryqq6uRXsLv4b+Pd9byUgHYF8hOFIsI1cT1k5/TFACL3WRxypISSQ51s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUID32jS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUID32jS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40740C433C7;
	Tue, 27 Feb 2024 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040663;
	bh=AU1CWaqg/Tpv1SKEaJgmRas0hsDaFnoWBUAtzWXd8ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUID32jSnK0yuLbBjxJ6sVZ4PANo8EEIXoY+W0bc4uOYW+sAgYa7WW217BID2kYmf
	 Oq632+MBT3l+QfsIfDjNPY8OWZWvY0rEpRg5vxRooIOYE9p+Ed88pPv1foEOWboaLi
	 pZwulMmRfxSs9JzO6HlkVzHBsmLSxFK22fR/eKNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 066/334] nvmet-fc: defer cleanup using RCU properly
Date: Tue, 27 Feb 2024 14:18:44 +0100
Message-ID: <20240227131632.690466445@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 4049dc96b8de7aeb3addcea039446e464726a525 ]

When the target executes a disconnect and the host triggers a reconnect
immediately, the reconnect command still finds an existing association.

The reconnect crashes later on because nvmet_fc_delete_target_assoc
blindly removes resources while the reconnect code wants to use it.

To address this, nvmet_fc_find_target_assoc should not be able to
lookup an association which is being removed. The association list
is already under RCU lifetime management, so let's properly use it
and remove the association from the list and wait for a grace period
before cleaning up all. This means we also can drop the RCU management
on the queues, because this is now handled via the association itself.

A second step split the execution context so that the initial disconnect
command can complete without running the reconnect code in the same
context. As usual, this is done by deferring the ->done to a workqueue.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 83 ++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 46 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 8cd1ef293769b..bb0791c9c0e3a 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -166,7 +166,7 @@ struct nvmet_fc_tgt_assoc {
 	struct nvmet_fc_hostport	*hostport;
 	struct nvmet_fc_ls_iod		*rcv_disconn;
 	struct list_head		a_list;
-	struct nvmet_fc_tgt_queue __rcu	*queues[NVMET_NR_QUEUES + 1];
+	struct nvmet_fc_tgt_queue 	*queues[NVMET_NR_QUEUES + 1];
 	struct kref			ref;
 	struct work_struct		del_work;
 	struct rcu_head			rcu;
@@ -803,14 +803,11 @@ nvmet_fc_alloc_target_queue(struct nvmet_fc_tgt_assoc *assoc,
 	if (!queue)
 		return NULL;
 
-	if (!nvmet_fc_tgt_a_get(assoc))
-		goto out_free_queue;
-
 	queue->work_q = alloc_workqueue("ntfc%d.%d.%d", 0, 0,
 				assoc->tgtport->fc_target_port.port_num,
 				assoc->a_id, qid);
 	if (!queue->work_q)
-		goto out_a_put;
+		goto out_free_queue;
 
 	queue->qid = qid;
 	queue->sqsize = sqsize;
@@ -832,15 +829,13 @@ nvmet_fc_alloc_target_queue(struct nvmet_fc_tgt_assoc *assoc,
 		goto out_fail_iodlist;
 
 	WARN_ON(assoc->queues[qid]);
-	rcu_assign_pointer(assoc->queues[qid], queue);
+	assoc->queues[qid] = queue;
 
 	return queue;
 
 out_fail_iodlist:
 	nvmet_fc_destroy_fcp_iodlist(assoc->tgtport, queue);
 	destroy_workqueue(queue->work_q);
-out_a_put:
-	nvmet_fc_tgt_a_put(assoc);
 out_free_queue:
 	kfree(queue);
 	return NULL;
@@ -853,12 +848,8 @@ nvmet_fc_tgt_queue_free(struct kref *ref)
 	struct nvmet_fc_tgt_queue *queue =
 		container_of(ref, struct nvmet_fc_tgt_queue, ref);
 
-	rcu_assign_pointer(queue->assoc->queues[queue->qid], NULL);
-
 	nvmet_fc_destroy_fcp_iodlist(queue->assoc->tgtport, queue);
 
-	nvmet_fc_tgt_a_put(queue->assoc);
-
 	destroy_workqueue(queue->work_q);
 
 	kfree_rcu(queue, rcu);
@@ -970,7 +961,7 @@ nvmet_fc_find_target_queue(struct nvmet_fc_tgtport *tgtport,
 	rcu_read_lock();
 	list_for_each_entry_rcu(assoc, &tgtport->assoc_list, a_list) {
 		if (association_id == assoc->association_id) {
-			queue = rcu_dereference(assoc->queues[qid]);
+			queue = assoc->queues[qid];
 			if (queue &&
 			    (!atomic_read(&queue->connected) ||
 			     !nvmet_fc_tgt_q_get(queue)))
@@ -1173,13 +1164,18 @@ nvmet_fc_target_assoc_free(struct kref *ref)
 	struct nvmet_fc_tgtport *tgtport = assoc->tgtport;
 	struct nvmet_fc_ls_iod	*oldls;
 	unsigned long flags;
+	int i;
+
+	for (i = NVMET_NR_QUEUES; i >= 0; i--) {
+		if (assoc->queues[i])
+			nvmet_fc_delete_target_queue(assoc->queues[i]);
+	}
 
 	/* Send Disconnect now that all i/o has completed */
 	nvmet_fc_xmt_disconnect_assoc(assoc);
 
 	nvmet_fc_free_hostport(assoc->hostport);
 	spin_lock_irqsave(&tgtport->lock, flags);
-	list_del_rcu(&assoc->a_list);
 	oldls = assoc->rcv_disconn;
 	spin_unlock_irqrestore(&tgtport->lock, flags);
 	/* if pending Rcv Disconnect Association LS, send rsp now */
@@ -1209,7 +1205,7 @@ static void
 nvmet_fc_delete_target_assoc(struct nvmet_fc_tgt_assoc *assoc)
 {
 	struct nvmet_fc_tgtport *tgtport = assoc->tgtport;
-	struct nvmet_fc_tgt_queue *queue;
+	unsigned long flags;
 	int i, terminating;
 
 	terminating = atomic_xchg(&assoc->terminating, 1);
@@ -1218,29 +1214,21 @@ nvmet_fc_delete_target_assoc(struct nvmet_fc_tgt_assoc *assoc)
 	if (terminating)
 		return;
 
+	spin_lock_irqsave(&tgtport->lock, flags);
+	list_del_rcu(&assoc->a_list);
+	spin_unlock_irqrestore(&tgtport->lock, flags);
 
-	for (i = NVMET_NR_QUEUES; i >= 0; i--) {
-		rcu_read_lock();
-		queue = rcu_dereference(assoc->queues[i]);
-		if (!queue) {
-			rcu_read_unlock();
-			continue;
-		}
+	synchronize_rcu();
 
-		if (!nvmet_fc_tgt_q_get(queue)) {
-			rcu_read_unlock();
-			continue;
-		}
-		rcu_read_unlock();
-		nvmet_fc_delete_target_queue(queue);
-		nvmet_fc_tgt_q_put(queue);
+	/* ensure all in-flight I/Os have been processed */
+	for (i = NVMET_NR_QUEUES; i >= 0; i--) {
+		if (assoc->queues[i])
+			flush_workqueue(assoc->queues[i]->work_q);
 	}
 
 	dev_info(tgtport->dev,
 		"{%d:%d} Association deleted\n",
 		tgtport->fc_target_port.port_num, assoc->a_id);
-
-	nvmet_fc_tgt_a_put(assoc);
 }
 
 static struct nvmet_fc_tgt_assoc *
@@ -1493,9 +1481,8 @@ __nvmet_fc_free_assocs(struct nvmet_fc_tgtport *tgtport)
 	list_for_each_entry_rcu(assoc, &tgtport->assoc_list, a_list) {
 		if (!nvmet_fc_tgt_a_get(assoc))
 			continue;
-		if (!queue_work(nvmet_wq, &assoc->del_work))
-			/* already deleting - release local reference */
-			nvmet_fc_tgt_a_put(assoc);
+		queue_work(nvmet_wq, &assoc->del_work);
+		nvmet_fc_tgt_a_put(assoc);
 	}
 	rcu_read_unlock();
 }
@@ -1548,9 +1535,8 @@ nvmet_fc_invalidate_host(struct nvmet_fc_target_port *target_port,
 			continue;
 		assoc->hostport->invalid = 1;
 		noassoc = false;
-		if (!queue_work(nvmet_wq, &assoc->del_work))
-			/* already deleting - release local reference */
-			nvmet_fc_tgt_a_put(assoc);
+		queue_work(nvmet_wq, &assoc->del_work);
+		nvmet_fc_tgt_a_put(assoc);
 	}
 	spin_unlock_irqrestore(&tgtport->lock, flags);
 
@@ -1582,7 +1568,7 @@ nvmet_fc_delete_ctrl(struct nvmet_ctrl *ctrl)
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(assoc, &tgtport->assoc_list, a_list) {
-			queue = rcu_dereference(assoc->queues[0]);
+			queue = assoc->queues[0];
 			if (queue && queue->nvme_sq.ctrl == ctrl) {
 				if (nvmet_fc_tgt_a_get(assoc))
 					found_ctrl = true;
@@ -1594,9 +1580,8 @@ nvmet_fc_delete_ctrl(struct nvmet_ctrl *ctrl)
 		nvmet_fc_tgtport_put(tgtport);
 
 		if (found_ctrl) {
-			if (!queue_work(nvmet_wq, &assoc->del_work))
-				/* already deleting - release local reference */
-				nvmet_fc_tgt_a_put(assoc);
+			queue_work(nvmet_wq, &assoc->del_work);
+			nvmet_fc_tgt_a_put(assoc);
 			return;
 		}
 
@@ -1626,6 +1611,8 @@ nvmet_fc_unregister_targetport(struct nvmet_fc_target_port *target_port)
 	/* terminate any outstanding associations */
 	__nvmet_fc_free_assocs(tgtport);
 
+	flush_workqueue(nvmet_wq);
+
 	/*
 	 * should terminate LS's as well. However, LS's will be generated
 	 * at the tail end of association termination, so they likely don't
@@ -1871,9 +1858,6 @@ nvmet_fc_ls_disconnect(struct nvmet_fc_tgtport *tgtport,
 				sizeof(struct fcnvme_ls_disconnect_assoc_acc)),
 			FCNVME_LS_DISCONNECT_ASSOC);
 
-	/* release get taken in nvmet_fc_find_target_assoc */
-	nvmet_fc_tgt_a_put(assoc);
-
 	/*
 	 * The rules for LS response says the response cannot
 	 * go back until ABTS's have been sent for all outstanding
@@ -1888,8 +1872,6 @@ nvmet_fc_ls_disconnect(struct nvmet_fc_tgtport *tgtport,
 	assoc->rcv_disconn = iod;
 	spin_unlock_irqrestore(&tgtport->lock, flags);
 
-	nvmet_fc_delete_target_assoc(assoc);
-
 	if (oldls) {
 		dev_info(tgtport->dev,
 			"{%d:%d} Multiple Disconnect Association LS's "
@@ -1905,6 +1887,9 @@ nvmet_fc_ls_disconnect(struct nvmet_fc_tgtport *tgtport,
 		nvmet_fc_xmt_ls_rsp(tgtport, oldls);
 	}
 
+	queue_work(nvmet_wq, &assoc->del_work);
+	nvmet_fc_tgt_a_put(assoc);
+
 	return false;
 }
 
@@ -2903,6 +2888,9 @@ nvmet_fc_remove_port(struct nvmet_port *port)
 
 	nvmet_fc_portentry_unbind(pe);
 
+	/* terminate any outstanding associations */
+	__nvmet_fc_free_assocs(pe->tgtport);
+
 	kfree(pe);
 }
 
@@ -2934,6 +2922,9 @@ static int __init nvmet_fc_init_module(void)
 
 static void __exit nvmet_fc_exit_module(void)
 {
+	/* ensure any shutdown operation, e.g. delete ctrls have finished */
+	flush_workqueue(nvmet_wq);
+
 	/* sanity check - all lports should be removed */
 	if (!list_empty(&nvmet_fc_target_list))
 		pr_warn("%s: targetport list not empty\n", __func__);
-- 
2.43.0



