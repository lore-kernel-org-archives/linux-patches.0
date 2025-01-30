Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A87A1E6DCF;
	Thu, 30 Jan 2025 14:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247075; cv=none; b=u+bf7lum603HN3EjgmTGTwq2CTlACf7QWilMMFC6rLnK6XOzku/20RN0/xvuM1UhM/wF5C9PAdhobEAepjaEcVfvte1Sw5Aeln+OqOXBWG0xPNk3N/PyqTmdzPCQb7ntl2Jx4o+9UIouawW00a16gt+5v/CUlXRKk/mfavfe4vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247075; c=relaxed/simple;
	bh=Zn8SFY+yQo93XWo5cUFlkzONTGEQN6MLj1inZq5yJ2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kq6TUU2N/yoQ86baA6q4je0EGZeTcy4oP0E4/TmO7AusQcGoh3k0+28pQUbFh/7mWIssGy8upOOUDGVsXSFpyxiyF90SM3SIOFgIaJFBTCnrQyuapWthwPtHiwhqnjdguOr12HyGjUQUvqyaoXt3MDwCs2xvzJJAvJ+N3n1eDZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vY4AX+AG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vY4AX+AG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901A9C4CED2;
	Thu, 30 Jan 2025 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247075;
	bh=Zn8SFY+yQo93XWo5cUFlkzONTGEQN6MLj1inZq5yJ2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vY4AX+AGIsIb/BCNaTTRvLDF5EvZbu4/xqJodD54rvSbQWWfcL97lyELLafTKkpq4
	 vlEtOlL7BtivW8W5cqRppKbldRhj8utdfRxsB0pmjbkJ9go8lCHn62yVBqAXjBjPv1
	 7evGmBZmvQ1r3n5mufHnuplRfeQsqUEfDB+2n/wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/133] net: add exit_batch_rtnl() method
Date: Thu, 30 Jan 2025 15:01:03 +0100
Message-ID: <20250130140145.497215377@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit fd4f101edbd9f99567ab2adb1f2169579ede7c13 ]

Many (struct pernet_operations)->exit_batch() methods have
to acquire rtnl.

In presence of rtnl mutex pressure, this makes cleanup_net()
very slow.

This patch adds a new exit_batch_rtnl() method to reduce
number of rtnl acquisitions from cleanup_net().

exit_batch_rtnl() handlers are called while rtnl is locked,
and devices to be killed can be queued in a list provided
as their second argument.

A single unregister_netdevice_many() is called right
before rtnl is released.

exit_batch_rtnl() handlers are called before ->exit() and
->exit_batch() handlers.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://lore.kernel.org/r/20240206144313.2050392-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 46841c7053e6 ("gtp: Use for_each_netdev_rcu() in gtp_genl_dump_pdp().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/net_namespace.h |  3 +++
 net/core/net_namespace.c    | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index eb0e7731f3b1c..c41e922fdd97e 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -393,6 +393,9 @@ struct pernet_operations {
 	void (*pre_exit)(struct net *net);
 	void (*exit)(struct net *net);
 	void (*exit_batch)(struct list_head *net_exit_list);
+	/* Following method is called with RTNL held. */
+	void (*exit_batch_rtnl)(struct list_head *net_exit_list,
+				struct list_head *dev_kill_list);
 	unsigned int *id;
 	size_t size;
 };
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index ef19a0eaa55aa..bcf3533cb8ff1 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -331,8 +331,9 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 {
 	/* Must be called with pernet_ops_rwsem held */
 	const struct pernet_operations *ops, *saved_ops;
-	int error = 0;
 	LIST_HEAD(net_exit_list);
+	LIST_HEAD(dev_kill_list);
+	int error = 0;
 
 	refcount_set(&net->count, 1);
 	refcount_set(&net->passive, 1);
@@ -365,6 +366,15 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 
 	synchronize_rcu();
 
+	ops = saved_ops;
+	rtnl_lock();
+	list_for_each_entry_continue_reverse(ops, &pernet_list, list) {
+		if (ops->exit_batch_rtnl)
+			ops->exit_batch_rtnl(&net_exit_list, &dev_kill_list);
+	}
+	unregister_netdevice_many(&dev_kill_list);
+	rtnl_unlock();
+
 	ops = saved_ops;
 	list_for_each_entry_continue_reverse(ops, &pernet_list, list)
 		ops_exit_list(ops, &net_exit_list);
@@ -569,6 +579,7 @@ static void cleanup_net(struct work_struct *work)
 	struct net *net, *tmp, *last;
 	struct llist_node *net_kill_list;
 	LIST_HEAD(net_exit_list);
+	LIST_HEAD(dev_kill_list);
 
 	/* Atomically snapshot the list of namespaces to cleanup */
 	net_kill_list = llist_del_all(&cleanup_list);
@@ -609,6 +620,14 @@ static void cleanup_net(struct work_struct *work)
 	 */
 	synchronize_rcu();
 
+	rtnl_lock();
+	list_for_each_entry_reverse(ops, &pernet_list, list) {
+		if (ops->exit_batch_rtnl)
+			ops->exit_batch_rtnl(&net_exit_list, &dev_kill_list);
+	}
+	unregister_netdevice_many(&dev_kill_list);
+	rtnl_unlock();
+
 	/* Run all of the network namespace exit methods */
 	list_for_each_entry_reverse(ops, &pernet_list, list)
 		ops_exit_list(ops, &net_exit_list);
@@ -1160,7 +1179,17 @@ static void free_exit_list(struct pernet_operations *ops, struct list_head *net_
 {
 	ops_pre_exit_list(ops, net_exit_list);
 	synchronize_rcu();
+
+	if (ops->exit_batch_rtnl) {
+		LIST_HEAD(dev_kill_list);
+
+		rtnl_lock();
+		ops->exit_batch_rtnl(net_exit_list, &dev_kill_list);
+		unregister_netdevice_many(&dev_kill_list);
+		rtnl_unlock();
+	}
 	ops_exit_list(ops, net_exit_list);
+
 	ops_free_list(ops, net_exit_list);
 }
 
-- 
2.39.5



