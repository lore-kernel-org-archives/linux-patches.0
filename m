Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF32A3D75C0;
	Wed,  8 Apr 2026 18:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671992; cv=none; b=A/BOwaVmMR44EeEXR8c54RPAvz9UrTwOoVCWaglwL/5UduDMvHuFjrhy7kdJE3eIluRwmz+fgJ6aXLLcludaCjm9PZpVueMcOFCBJE28b9N40i9bEjPUMXVyI99GCho+iBEqdgpKnNu4xilVEJSzg4btK+ta0mnHxbH7YwIlx/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671992; c=relaxed/simple;
	bh=r9MKZHJKIi9yW4eqMWaNnzGDMzxR6iKODVHQIG1MqAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N/0qrikT+WI5Itmx+8AvcfYiNTxNYDq0o2PR3yx2LyxfGKaq5QvBLWwgBo67JmO+nZFQYyZOPoGKM0Q1dulDd9KSgGy+4HAsB1ThHdLgEHvLzEjXQa8UW/KyE4K817JpJglfb0yxuVjW9UVI+MrPEKEAabzLN24fxOkrP5AIl4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbwkNH6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbwkNH6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439B0C19421;
	Wed,  8 Apr 2026 18:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671992;
	bh=r9MKZHJKIi9yW4eqMWaNnzGDMzxR6iKODVHQIG1MqAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbwkNH6QCzOa1RYh6TgHhzBn+KiqgT8cBteshuAwF/bjr6pWyrm4i6v3gvB3gYqY6
	 a7x/AinLiNUvL1ODZu6EhKKTJweX4us3Zk6yjh7xb13NBt5pr0Fi8cAAPHohoKl3BK
	 SKa6dTzFXafQZJPUOxSIC6gBkkqOv81vFmYiWhjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+006987d1be3586e13555@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/312] net: qrtr: replace qrtr_tx_flow radix_tree with xarray to fix memory leak
Date: Wed,  8 Apr 2026 20:01:04 +0200
Message-ID: <20260408175939.260094194@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 2428083101f6883f979cceffa76cd8440751ffe6 ]

__radix_tree_create() allocates and links intermediate nodes into the
tree one by one. If a subsequent allocation fails, the already-linked
nodes remain in the tree with no corresponding leaf entry. These orphaned
internal nodes are never reclaimed because radix_tree_for_each_slot()
only visits slots containing leaf values.

The radix_tree API is deprecated in favor of xarray. As suggested by
Matthew Wilcox, migrate qrtr_tx_flow from radix_tree to xarray instead
of fixing the radix_tree itself [1]. xarray properly handles cleanup of
internal nodes — xa_destroy() frees all internal xarray nodes when the
qrtr_node is released, preventing the leak.

[1] https://lore.kernel.org/all/20260225071623.41275-1-jiayuan.chen@linux.dev/T/
Reported-by: syzbot+006987d1be3586e13555@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000bfba3a060bf4ffcf@google.com/T/
Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow control")
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260324080645.290197-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/af_qrtr.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index a59e1b2fea1c5..3831eb25e240a 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -116,7 +116,7 @@ static DEFINE_XARRAY_ALLOC(qrtr_ports);
  * @ep: endpoint
  * @ref: reference count for node
  * @nid: node id
- * @qrtr_tx_flow: tree of qrtr_tx_flow, keyed by node << 32 | port
+ * @qrtr_tx_flow: xarray of qrtr_tx_flow, keyed by node << 32 | port
  * @qrtr_tx_lock: lock for qrtr_tx_flow inserts
  * @rx_queue: receive queue
  * @item: list item for broadcast list
@@ -127,7 +127,7 @@ struct qrtr_node {
 	struct kref ref;
 	unsigned int nid;
 
-	struct radix_tree_root qrtr_tx_flow;
+	struct xarray qrtr_tx_flow;
 	struct mutex qrtr_tx_lock; /* for qrtr_tx_flow */
 
 	struct sk_buff_head rx_queue;
@@ -170,6 +170,7 @@ static void __qrtr_node_release(struct kref *kref)
 	struct qrtr_tx_flow *flow;
 	unsigned long flags;
 	void __rcu **slot;
+	unsigned long index;
 
 	spin_lock_irqsave(&qrtr_nodes_lock, flags);
 	/* If the node is a bridge for other nodes, there are possibly
@@ -187,11 +188,9 @@ static void __qrtr_node_release(struct kref *kref)
 	skb_queue_purge(&node->rx_queue);
 
 	/* Free tx flow counters */
-	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
-		flow = *slot;
-		radix_tree_iter_delete(&node->qrtr_tx_flow, &iter, slot);
+	xa_for_each(&node->qrtr_tx_flow, index, flow)
 		kfree(flow);
-	}
+	xa_destroy(&node->qrtr_tx_flow);
 	kfree(node);
 }
 
@@ -226,9 +225,7 @@ static void qrtr_tx_resume(struct qrtr_node *node, struct sk_buff *skb)
 
 	key = remote_node << 32 | remote_port;
 
-	rcu_read_lock();
-	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
-	rcu_read_unlock();
+	flow = xa_load(&node->qrtr_tx_flow, key);
 	if (flow) {
 		spin_lock(&flow->resume_tx.lock);
 		flow->pending = 0;
@@ -267,12 +264,13 @@ static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
 		return 0;
 
 	mutex_lock(&node->qrtr_tx_lock);
-	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
+	flow = xa_load(&node->qrtr_tx_flow, key);
 	if (!flow) {
 		flow = kzalloc(sizeof(*flow), GFP_KERNEL);
 		if (flow) {
 			init_waitqueue_head(&flow->resume_tx);
-			if (radix_tree_insert(&node->qrtr_tx_flow, key, flow)) {
+			if (xa_err(xa_store(&node->qrtr_tx_flow, key, flow,
+					    GFP_KERNEL))) {
 				kfree(flow);
 				flow = NULL;
 			}
@@ -324,9 +322,7 @@ static void qrtr_tx_flow_failed(struct qrtr_node *node, int dest_node,
 	unsigned long key = (u64)dest_node << 32 | dest_port;
 	struct qrtr_tx_flow *flow;
 
-	rcu_read_lock();
-	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
-	rcu_read_unlock();
+	flow = xa_load(&node->qrtr_tx_flow, key);
 	if (flow) {
 		spin_lock_irq(&flow->resume_tx.lock);
 		flow->tx_failed = 1;
@@ -594,7 +590,7 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	node->nid = QRTR_EP_NID_AUTO;
 	node->ep = ep;
 
-	INIT_RADIX_TREE(&node->qrtr_tx_flow, GFP_KERNEL);
+	xa_init(&node->qrtr_tx_flow);
 	mutex_init(&node->qrtr_tx_lock);
 
 	qrtr_node_assign(node, nid);
@@ -622,6 +618,7 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 	struct qrtr_tx_flow *flow;
 	struct sk_buff *skb;
 	unsigned long flags;
+	unsigned long index;
 	void __rcu **slot;
 
 	mutex_lock(&node->ep_lock);
@@ -644,10 +641,8 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 
 	/* Wake up any transmitters waiting for resume-tx from the node */
 	mutex_lock(&node->qrtr_tx_lock);
-	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
-		flow = *slot;
+	xa_for_each(&node->qrtr_tx_flow, index, flow)
 		wake_up_interruptible_all(&flow->resume_tx);
-	}
 	mutex_unlock(&node->qrtr_tx_lock);
 
 	qrtr_node_release(node);
-- 
2.53.0



