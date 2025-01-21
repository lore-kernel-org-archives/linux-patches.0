Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28621F0E36;
	Tue, 21 Jan 2025 18:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482662; cv=none; b=IOw4u9n6y117GbaNOsMMRte8xejFnRqiomGE9eqald/k7s7Kt4lZ9luUTx94/96g0rut9u9qWTv02uN36R49h7cS4cYPy+dNN1Gx08c4D9zy2e/5SR511ExFlnXWsFz6tp4abVZm3Z470ovvNYp/j+uFGTBUpXxqDPTpGlujlos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482662; c=relaxed/simple;
	bh=oG7DkdfnBrFPyeuoD2ycTSqsyPV2hjGsyGoHd/9kHTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlB5Lg/Hy9SqaS3uN6yjnYG5GQkNN9sc6o60ZAOKg9lVcyoNWpHodZGULJkOEWcGgZslJM3vrf+wwflXPtMKAMJRJrLUbwf8ckzHiK/9k6nkpAkTJ/VcBh6dmBXNLO+LAt8PFjHGZTsjE4ktUCABmlnpiIOmNd2qZW1Gfihu6dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7SrRKxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7SrRKxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB15C4CEDF;
	Tue, 21 Jan 2025 18:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482662;
	bh=oG7DkdfnBrFPyeuoD2ycTSqsyPV2hjGsyGoHd/9kHTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7SrRKxLDOzkUOou6/clQTEx9qOOBui5gJMHGO8SocC4mghtTF0sfRQvv/V5jTK9S
	 iEubOCqPuXM0k9g4oOoQ773pgvOgAJxoovpqpDs5XAXIuNdCTC1jXWKjgdOBQP9GdI
	 bj7pnih6u7aavcKmKPYlVvcWzYLF1vMk5V49N6Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/64] net: add exit_batch_rtnl() method
Date: Tue, 21 Jan 2025 18:52:04 +0100
Message-ID: <20250121174521.774480523@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7ca4b7af57ca6..17c7a88418345 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -426,6 +426,9 @@ struct pernet_operations {
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
index 6c6d2a785c004..abf1e1751d6c8 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -314,8 +314,9 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 {
 	/* Must be called with pernet_ops_rwsem held */
 	const struct pernet_operations *ops, *saved_ops;
-	int error = 0;
 	LIST_HEAD(net_exit_list);
+	LIST_HEAD(dev_kill_list);
+	int error = 0;
 
 	refcount_set(&net->ns.count, 1);
 	ref_tracker_dir_init(&net->refcnt_tracker, 128);
@@ -353,6 +354,15 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 
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
@@ -576,6 +586,7 @@ static void cleanup_net(struct work_struct *work)
 	struct net *net, *tmp, *last;
 	struct llist_node *net_kill_list;
 	LIST_HEAD(net_exit_list);
+	LIST_HEAD(dev_kill_list);
 
 	/* Atomically snapshot the list of namespaces to cleanup */
 	net_kill_list = llist_del_all(&cleanup_list);
@@ -616,6 +627,14 @@ static void cleanup_net(struct work_struct *work)
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
@@ -1159,7 +1178,17 @@ static void free_exit_list(struct pernet_operations *ops, struct list_head *net_
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



