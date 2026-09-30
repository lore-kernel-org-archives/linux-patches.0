Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DC6403B11;
	Wed, 30 Sep 2026 19:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796671; cv=none; b=YNCKANp2DYCXigATsOaFk+rX95glJMKNaiy4+NxFmjI0EWVHUr87yRySvhStC/9/ZOPECtG39IztBDAA4ODB9dDw2FBoY0lh7hnd0xY77JgSxbf/33z9WfRJqc23f3Ru8gOiLiaqHXu0Uzaol9m62GbmXl4bz5rnyP4OwJTxIJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796671; c=relaxed/simple;
	bh=8xsfU/rUvPmwcBppl9oCbrmHqRKtvx6Ep6IpkpSyAlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDkNH5LqUBn2Jey5btWxJrUYBoiT7yBFeZGGbuGcAuO98VfPrXDd2C9tb2vXb7lmAqFw7OC8GoUB1a74WkUh7gEmI1muYn6bHr604ZKi7ive54LEslHkZAuPAq7JKqgRQwoUhewESemzJdEBmn0Ar9jacbO9pB9lNRWItd1Cl44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyJa0lbL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyJa0lbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C4C1F000FF;
	Wed, 30 Sep 2026 19:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796669;
	bh=3UbbvUtt4+pcrZfvohJS+m4Dmnu9PYWiwAzsmXwB+6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LyJa0lbLC4JGDwHkq3pRPRQHsVCxJ9pNZnR/hBFwpDdazFA8SKRTwTb5tHnhFqlPD
	 xJClcK+z1hHuvspgWJ4+5NCkISSDPPhetlHRuki+9hmMk567xoqTSPHBQUMm9XxFR5
	 44lshgY2gUdklYRd1kmL9I+C4DEJhwnjQrjAYWPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Scott Mitchell <scott.k.mitch1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0993/1193] netfilter: nfnetlink_queue: nfqnl_instance GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation
Date: Wed, 30 Sep 2026 17:27:57 +0200
Message-ID: <20260930152456.303917199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Scott Mitchell <scott.k.mitch1@gmail.com>

[ Upstream commit a4400a5b343d1bc4aa8f685608515413238e7ee2 ]

Currently, instance_create() uses GFP_ATOMIC because it's called while
holding instances_lock spinlock. This makes allocation more likely to
fail under memory pressure.

Refactor nfqnl_recv_config() to drop RCU lock after instance_lookup()
and peer_portid verification. A socket cannot simultaneously send a
message and close, so the queue owned by the sending socket cannot be
destroyed while processing its CONFIG message. This allows
instance_create() to allocate with GFP_KERNEL_ACCOUNT before taking
the spinlock.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Scott Mitchell <scott.k.mitch1@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 9461613afc59 ("netfilter: nfnetlink_queue: hold nfnl mutex in event notifier")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 75 +++++++++++++++------------------
 1 file changed, 34 insertions(+), 41 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index cfd12124e8272..cd6cd258754d9 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -121,17 +121,9 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 	unsigned int h;
 	int err;
 
-	spin_lock(&q->instances_lock);
-	if (instance_lookup(q, queue_num)) {
-		err = -EEXIST;
-		goto out_unlock;
-	}
-
-	inst = kzalloc(sizeof(*inst), GFP_ATOMIC);
-	if (!inst) {
-		err = -ENOMEM;
-		goto out_unlock;
-	}
+	inst = kzalloc(sizeof(*inst), GFP_KERNEL_ACCOUNT);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
 
 	inst->queue_num = queue_num;
 	inst->peer_portid = portid;
@@ -141,9 +133,15 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
 
+	spin_lock(&q->instances_lock);
+	if (instance_lookup(q, queue_num)) {
+		err = -EEXIST;
+		goto out_unlock;
+	}
+
 	if (!try_module_get(THIS_MODULE)) {
 		err = -EAGAIN;
-		goto out_free;
+		goto out_unlock;
 	}
 
 	h = instance_hashfn(queue_num);
@@ -153,10 +151,9 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 
 	return inst;
 
-out_free:
-	kfree(inst);
 out_unlock:
 	spin_unlock(&q->instances_lock);
+	kfree(inst);
 	return ERR_PTR(err);
 }
 
@@ -1343,7 +1340,8 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nfqnl_msg_config_cmd *cmd = NULL;
 	struct nfqnl_instance *queue;
 	__u32 flags = 0, mask = 0;
-	int ret = 0;
+
+	WARN_ON_ONCE(!lockdep_nfnl_is_held(NFNL_SUBSYS_QUEUE));
 
 	if (nfqa[NFQA_CFG_CMD]) {
 		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
@@ -1389,47 +1387,44 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 		}
 	}
 
+	/* Lookup queue under RCU. After peer_portid check (or for new queue
+	 * in BIND case), the queue is owned by the socket sending this message.
+	 * A socket cannot simultaneously send a message and close, so while
+	 * processing this CONFIG message, nfqnl_rcv_nl_event() (triggered by
+	 * socket close) cannot destroy this queue. Safe to use without RCU.
+	 */
 	rcu_read_lock();
 	queue = instance_lookup(q, queue_num);
 	if (queue && queue->peer_portid != NETLINK_CB(skb).portid) {
-		ret = -EPERM;
-		goto err_out_unlock;
+		rcu_read_unlock();
+		return -EPERM;
 	}
+	rcu_read_unlock();
 
 	if (cmd != NULL) {
 		switch (cmd->command) {
 		case NFQNL_CFG_CMD_BIND:
-			if (queue) {
-				ret = -EBUSY;
-				goto err_out_unlock;
-			}
-			queue = instance_create(q, queue_num,
-						NETLINK_CB(skb).portid);
-			if (IS_ERR(queue)) {
-				ret = PTR_ERR(queue);
-				goto err_out_unlock;
-			}
+			if (queue)
+				return -EBUSY;
+			queue = instance_create(q, queue_num, NETLINK_CB(skb).portid);
+			if (IS_ERR(queue))
+				return PTR_ERR(queue);
 			break;
 		case NFQNL_CFG_CMD_UNBIND:
-			if (!queue) {
-				ret = -ENODEV;
-				goto err_out_unlock;
-			}
+			if (!queue)
+				return -ENODEV;
 			instance_destroy(q, queue);
-			goto err_out_unlock;
+			return 0;
 		case NFQNL_CFG_CMD_PF_BIND:
 		case NFQNL_CFG_CMD_PF_UNBIND:
 			break;
 		default:
-			ret = -ENOTSUPP;
-			goto err_out_unlock;
+			return -EOPNOTSUPP;
 		}
 	}
 
-	if (!queue) {
-		ret = -ENODEV;
-		goto err_out_unlock;
-	}
+	if (!queue)
+		return -ENODEV;
 
 	if (nfqa[NFQA_CFG_PARAMS]) {
 		struct nfqnl_msg_config_params *params =
@@ -1454,9 +1449,7 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 		spin_unlock_bh(&queue->lock);
 	}
 
-err_out_unlock:
-	rcu_read_unlock();
-	return ret;
+	return 0;
 }
 
 static const struct nfnl_callback nfqnl_cb[NFQNL_MSG_MAX] = {
-- 
2.53.0



