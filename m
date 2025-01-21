Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2491E9B38;
	Tue, 21 Jan 2025 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482061; cv=none; b=uCl8MTxvNX2EO3zZQfWemPrxfWkJE0t/KBu48uYz+bZH4EIGXjMWXKFRwx7wSBqb1x/KpwgOCtP9XQh38dNfBEgfux01PaCcWNy8IvvF43A5fyHjNxWbKI+sv64nhb53W64T4Z740YR1jIp0HWgUIucxbLY0G0+S67mh3FFwT4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482061; c=relaxed/simple;
	bh=CrQhThOl/LtI0EFWoDJj4G0aYaryRcVPlD+ydLPsTU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHxYpK78dUhxV1120DFkpkz/6uvezqUEbclVB31xVc9kbKMbaQ/efA7YqmZBLmn+NCpf8mB2u8nAeprOYrXf25/lNMRFwEZOOT2j7ogQTahQ/0HQ6tf3vaWvb/ayJbCgAGKBill9eyDLlgWHwZ1xqG8fR1Y1VeO9Y3E7MCU9WQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rtw9nC/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rtw9nC/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2861C4CEDF;
	Tue, 21 Jan 2025 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482061;
	bh=CrQhThOl/LtI0EFWoDJj4G0aYaryRcVPlD+ydLPsTU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rtw9nC/1QDhbw1iExIwNU67kKJSvSYlGzhMErJ/6Cw4sPBTdRp8OS/N6Yy0FTeBle
	 cJxfnB6fGvhZninQwhJusoygLMPRCcpmSFRZrT8uOVpf4xHfbjecybbz248BCzpzUt
	 v2UFFMOGkUhR+VHXEFOihK9mIIDfKIw2EkDxQvaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 05/72] net: add exit_batch_rtnl() method
Date: Tue, 21 Jan 2025 18:51:31 +0100
Message-ID: <20250121174523.639012500@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 958c805df1915..1befad79a6734 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -442,6 +442,9 @@ struct pernet_operations {
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
index 92b7fea4d495c..70ac9d9bc8770 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -321,8 +321,9 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 {
 	/* Must be called with pernet_ops_rwsem held */
 	const struct pernet_operations *ops, *saved_ops;
-	int error = 0;
 	LIST_HEAD(net_exit_list);
+	LIST_HEAD(dev_kill_list);
+	int error = 0;
 
 	refcount_set(&net->ns.count, 1);
 	ref_tracker_dir_init(&net->refcnt_tracker, 128, "net refcnt");
@@ -360,6 +361,15 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 
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
@@ -588,6 +598,7 @@ static void cleanup_net(struct work_struct *work)
 	struct net *net, *tmp, *last;
 	struct llist_node *net_kill_list;
 	LIST_HEAD(net_exit_list);
+	LIST_HEAD(dev_kill_list);
 
 	/* Atomically snapshot the list of namespaces to cleanup */
 	net_kill_list = llist_del_all(&cleanup_list);
@@ -628,6 +639,14 @@ static void cleanup_net(struct work_struct *work)
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
@@ -1170,7 +1189,17 @@ static void free_exit_list(struct pernet_operations *ops, struct list_head *net_
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



