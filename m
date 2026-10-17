Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ECC18787A;
	Sat, 17 Oct 2026 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253678; cv=none; b=bhWFsp6Ruztfr1hBgieNufNXGR5sKR6M5WXpWNiJM7WlsEHgAOqAWAUttqSTOXuSfNitC8lYIwAvQiiIxcxXx+iitEvYMq6uN6tQAGDlkau0g2PnbkdgS0EtfdZIqvYjbN+g7qLN2A7PBgrXUN1FE5xhiItiBfaPkATCzmkQ2xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253678; c=relaxed/simple;
	bh=JxiAbLx9ycS05iSGN4dXcdV866zlSegPUyypM6acoCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBKn+tPshuf6pkpuvHBg+TlLvin6EB/nocpuJIJDvb72QHWAqHriMrOH8lTceRUhRJk7tt/+7wSUeuKZ3sFkWjiV581gCQMqjLINYZA/D+2Vp6nSKbhbqJyT7hc0wC3LhvUr8Go9NCNc3epBXE4xMWZIvD+6+N6kyMp0vsT1G/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnJFF7y8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnJFF7y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D221F000C4;
	Sat, 17 Oct 2026 16:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253677;
	bh=CjtCB0QlA2xhmd9tj87zagySmfSUsW/4uzw9U8NC7Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnJFF7y8YrSOX6watfGk1ig14PuTirczgTujfqsWkeWZxUqTQIEz+tFwrYakJsOoU
	 G+mMexImjP3/5OdEd3QsP8Dovm5Y9NZt5B9JsJ8R7xPBSVIer5aboFme/PP0XGYZi7
	 1OZ57Amr0RsKTcpTIoCnkHfBr5I1rjlSry0oQB7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/869] net: Factorise setup_net() and cleanup_net().
Date: Sat, 17 Oct 2026 17:50:36 +0200
Message-ID: <20261017160042.056647584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit e333b1c3cf25fca348422c9ad5cc8db40b4243fa ]

When we roll back the changes made by struct pernet_operations.init(),
we execute mostly identical sequences in three places.

  * setup_net()
  * cleanup_net()
  * free_exit_list()

The only difference between the first two is which list and RCU helpers
to use.

In setup_net(), an ops could fail on the way, so we need to perform a
reverse walk from its previous ops in pernet_list.  OTOH, in cleanup_net(),
we iterate the full list from tail to head.

The former passes the failed ops to list_for_each_entry_continue_reverse().
It's tricky, but we can reuse it for the latter if we pass list_entry() of
the head node.

Also, synchronize_rcu() and synchronize_rcu_expedited() can be easily
switched by an argument.

Let's factorise the rollback part in setup_net() and cleanup_net().

In the next patch, ops_undo_list() will be reused for free_exit_list(),
and then two arguments (ops_list and hold_rtnl) will differ.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20250411205258.63164-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 60a25ef8dacb ("wireguard: device: use exit_rtnl callback instead of manual rtnl_lock in pre_exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 106 +++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 55 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 613b2b07bad9f..25f84a3764f71 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -189,6 +189,53 @@ static void ops_free_list(const struct pernet_operations *ops,
 	}
 }
 
+static void ops_undo_list(const struct list_head *ops_list,
+			  const struct pernet_operations *ops,
+			  struct list_head *net_exit_list,
+			  bool expedite_rcu, bool hold_rtnl)
+{
+	const struct pernet_operations *saved_ops;
+
+	if (!ops)
+		ops = list_entry(ops_list, typeof(*ops), list);
+
+	saved_ops = ops;
+
+	list_for_each_entry_continue_reverse(ops, ops_list, list)
+		ops_pre_exit_list(ops, net_exit_list);
+
+	/* Another CPU might be rcu-iterating the list, wait for it.
+	 * This needs to be before calling the exit() notifiers, so the
+	 * rcu_barrier() after ops_undo_list() isn't sufficient alone.
+	 * Also the pre_exit() and exit() methods need this barrier.
+	 */
+	if (expedite_rcu)
+		synchronize_rcu_expedited();
+	else
+		synchronize_rcu();
+
+	if (hold_rtnl) {
+		LIST_HEAD(dev_kill_list);
+
+		ops = saved_ops;
+		rtnl_lock();
+		list_for_each_entry_continue_reverse(ops, ops_list, list) {
+			if (ops->exit_batch_rtnl)
+				ops->exit_batch_rtnl(net_exit_list, &dev_kill_list);
+		}
+		unregister_netdevice_many(&dev_kill_list);
+		rtnl_unlock();
+	}
+
+	ops = saved_ops;
+	list_for_each_entry_continue_reverse(ops, ops_list, list)
+		ops_exit_list(ops, net_exit_list);
+
+	ops = saved_ops;
+	list_for_each_entry_continue_reverse(ops, ops_list, list)
+		ops_free_list(ops, net_exit_list);
+}
+
 /* should be called with nsid_lock held */
 static int alloc_netid(struct net *net, struct net *peer, int reqid)
 {
@@ -349,9 +396,8 @@ static __net_init void preinit_net(struct net *net, struct user_namespace *user_
 static __net_init int setup_net(struct net *net)
 {
 	/* Must be called with pernet_ops_rwsem held */
-	const struct pernet_operations *ops, *saved_ops;
+	const struct pernet_operations *ops;
 	LIST_HEAD(net_exit_list);
-	LIST_HEAD(dev_kill_list);
 	int error = 0;
 
 	preempt_disable();
@@ -374,29 +420,7 @@ static __net_init int setup_net(struct net *net)
 	 * for the pernet modules whose init functions did not fail.
 	 */
 	list_add(&net->exit_list, &net_exit_list);
-	saved_ops = ops;
-	list_for_each_entry_continue_reverse(ops, &pernet_list, list)
-		ops_pre_exit_list(ops, &net_exit_list);
-
-	synchronize_rcu();
-
-	ops = saved_ops;
-	rtnl_lock();
-	list_for_each_entry_continue_reverse(ops, &pernet_list, list) {
-		if (ops->exit_batch_rtnl)
-			ops->exit_batch_rtnl(&net_exit_list, &dev_kill_list);
-	}
-	unregister_netdevice_many(&dev_kill_list);
-	rtnl_unlock();
-
-	ops = saved_ops;
-	list_for_each_entry_continue_reverse(ops, &pernet_list, list)
-		ops_exit_list(ops, &net_exit_list);
-
-	ops = saved_ops;
-	list_for_each_entry_continue_reverse(ops, &pernet_list, list)
-		ops_free_list(ops, &net_exit_list);
-
+	ops_undo_list(&pernet_list, ops, &net_exit_list, false, true);
 	rcu_barrier();
 	goto out;
 }
@@ -594,11 +618,9 @@ static LLIST_HEAD(cleanup_list);
 
 static void cleanup_net(struct work_struct *work)
 {
-	const struct pernet_operations *ops;
-	struct net *net, *tmp, *last;
 	struct llist_node *net_kill_list;
+	struct net *net, *tmp, *last;
 	LIST_HEAD(net_exit_list);
-	LIST_HEAD(dev_kill_list);
 
 	/* Atomically snapshot the list of namespaces to cleanup */
 	net_kill_list = llist_del_all(&cleanup_list);
@@ -627,33 +649,7 @@ static void cleanup_net(struct work_struct *work)
 		list_add_tail(&net->exit_list, &net_exit_list);
 	}
 
-	/* Run all of the network namespace pre_exit methods */
-	list_for_each_entry_reverse(ops, &pernet_list, list)
-		ops_pre_exit_list(ops, &net_exit_list);
-
-	/*
-	 * Another CPU might be rcu-iterating the list, wait for it.
-	 * This needs to be before calling the exit() notifiers, so
-	 * the rcu_barrier() below isn't sufficient alone.
-	 * Also the pre_exit() and exit() methods need this barrier.
-	 */
-	synchronize_rcu_expedited();
-
-	rtnl_lock();
-	list_for_each_entry_reverse(ops, &pernet_list, list) {
-		if (ops->exit_batch_rtnl)
-			ops->exit_batch_rtnl(&net_exit_list, &dev_kill_list);
-	}
-	unregister_netdevice_many(&dev_kill_list);
-	rtnl_unlock();
-
-	/* Run all of the network namespace exit methods */
-	list_for_each_entry_reverse(ops, &pernet_list, list)
-		ops_exit_list(ops, &net_exit_list);
-
-	/* Free the net generic variables */
-	list_for_each_entry_reverse(ops, &pernet_list, list)
-		ops_free_list(ops, &net_exit_list);
+	ops_undo_list(&pernet_list, NULL, &net_exit_list, true, true);
 
 	up_read(&pernet_ops_rwsem);
 
-- 
2.53.0



