Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A9A51477A;
	Wed, 30 Sep 2026 16:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786465; cv=none; b=IU3ZvXkRmi24m3uT71BTRaY3Wq4CNDpegWMPhNl0EM9WDVinMyD7FyTT32hwtgiMObefZkN8mBNYd+bVLH0MPCd+jtRLf25MR0B3cNTN0TL3aji1QhbHoJ/jwNMKnYvguA/+V7NBiPc9nRWwY0vPboJdVQDTIL/O+q2wTPIm3A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786465; c=relaxed/simple;
	bh=E7zOMbjvTYt5eJ9YYJiUUDo5oO72oaEK+7l6qHNR5G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuL1bcTGUcgxggTyR85X9Bv0ueJzPZPFOZcQrRMj2D/k7CDiQkBr1TP3I9r7Vv7nqXLKZAXX4tqHRXoPq/KY6I9FJDKVmvJjPlUWfI7CXLNamXlojo0wdlm5mUtMgL7XUE7G8pOdSZnLr/+rjdS5857KDucQZCNnUHLgVWoxn6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpcpl/UD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpcpl/UD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852551F000FF;
	Wed, 30 Sep 2026 16:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786463;
	bh=muXbvTcUOapLsYrgz/+EP1PKwPwkBi1jJkdj/bzDD88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpcpl/UDUS3pSPalYht+/ZeN17VEl2DJZGlS9K1eH1CsXpY7/i67KC9nPnta7ieHV
	 V6BlHvtmDjp6LAJhSf411MMpWGp0Jsasp0wX8TbtsWnmzn2FT8JtWWrOF9gjlgA7Oo
	 ckhZ/BsopK4QuXklyyLsQKj5Vpzc8du9QKWr4AUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Scott Mitchell <scott.k.mitch1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 834/982] netfilter: nfnetlink_queue: nfqnl_instance GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation
Date: Wed, 30 Sep 2026 17:26:10 +0200
Message-ID: <20260930152434.668611340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cdc420c29e112..a363853442cb9 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -119,17 +119,9 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
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
@@ -139,9 +131,15 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
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
@@ -151,10 +149,9 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 
 	return inst;
 
-out_free:
-	kfree(inst);
 out_unlock:
 	spin_unlock(&q->instances_lock);
+	kfree(inst);
 	return ERR_PTR(err);
 }
 
@@ -1322,7 +1319,8 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nfqnl_msg_config_cmd *cmd = NULL;
 	struct nfqnl_instance *queue;
 	__u32 flags = 0, mask = 0;
-	int ret = 0;
+
+	WARN_ON_ONCE(!lockdep_nfnl_is_held(NFNL_SUBSYS_QUEUE));
 
 	if (nfqa[NFQA_CFG_CMD]) {
 		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
@@ -1368,47 +1366,44 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
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
@@ -1433,9 +1428,7 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
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



