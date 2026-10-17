Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE10277026;
	Sat, 17 Oct 2026 16:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253684; cv=none; b=dMitW4A/Gh5DtrEtQpORCwgDnwxZUOc5gpvQkEV7uHIaPpviZDtLbPIlX5PzVOiSax1EcMCAHvdCZWbsfL38zgPgtQSieYkU/usNLkF6F7INOKtOVj29O92C6Wv7v88izu/TQqNi0okngXidxwreixkBd0MmEm3sa1xVgfQr1qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253684; c=relaxed/simple;
	bh=0UBfHKKJm/qdHrhpOWdwK4ZnZKvIR/p8S+D4cr1uZa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAWqJlvNy3Ibtg0NfciYNHZc77DIC8u3xbZ9BqnNYYXTpnXLmkxM7Xt5hXBF4BnZ1muFHkCZl0nEZRuMr/uF2bOxB/7TVLs3Tr2ggtZsOwmsTKw2Ra7uDL6V8illPpH/z9TUqXXMGHChW20th+zXVolZWKET+BqGvNy8yIbcb4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8hFG+Nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8hFG+Nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CF41F000C4;
	Sat, 17 Oct 2026 16:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253683;
	bh=CFQ7T5ZZcVJnO4sKR49/Zd6m7jRvO+aT8eq1eJnJe+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8hFG+Nnpfb13KyTldZBAS84mcXNKwNpVUKq9b9IB/LlnF38qbt7zeNce6dB5j8I5
	 vWIRHccp4EdOOrnCnGNqYjWe4V70eLpkc0tGzxg87IH2g9aiQvIATmgxYZRKK/vGKf
	 kO4NL/Osrt3weqxUXJEsZszakvO1BLH59B5kY0hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/869] net: Add ->exit_rtnl() hook to struct pernet_operations.
Date: Sat, 17 Oct 2026 17:50:38 +0200
Message-ID: <20261017160042.107648943@linuxfoundation.org>
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

[ Upstream commit 7a60d91c690bf73c2c78e763efa29f294e217c3a ]

struct pernet_operations provides two batching hooks; ->exit_batch()
and ->exit_batch_rtnl().

The batching variant is beneficial if ->exit() meets any of the
following conditions:

  1) ->exit() repeatedly acquires a global lock for each netns

  2) ->exit() has a time-consuming operation that can be factored
     out (e.g. synchronize_rcu(), smp_mb(), etc)

  3) ->exit() does not need to repeat the same iterations for each
     netns (e.g. inet_twsk_purge())

Currently, none of the ->exit_batch_rtnl() functions satisfy any of
the above conditions because RTNL is factored out and held by the
caller and all of these functions iterate over the dying netns list.

Also, we want to hold per-netns RTNL there but avoid spreading
__rtnl_net_lock() across multiple locations.

Let's add ->exit_rtnl() hook and run it under __rtnl_net_lock().

The following patches will convert all ->exit_batch_rtnl() users
to ->exit_rtnl().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20250411205258.63164-4-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 60a25ef8dacb ("wireguard: device: use exit_rtnl callback instead of manual rtnl_lock in pre_exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/net_namespace.h |  2 ++
 net/core/net_namespace.c    | 53 +++++++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 47181fd749b25..f659d1efcd3ce 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -470,6 +470,8 @@ struct pernet_operations {
 	void (*exit)(struct net *net);
 	void (*exit_batch)(struct list_head *net_exit_list);
 	/* Following method is called with RTNL held. */
+	void (*exit_rtnl)(struct net *net,
+			  struct list_head *dev_kill_list);
 	void (*exit_batch_rtnl)(struct list_head *net_exit_list,
 				struct list_head *dev_kill_list);
 	unsigned int * const id;
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index f2171ff0e7b09..9e518df2cfeb5 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -164,16 +164,51 @@ static void ops_pre_exit_list(const struct pernet_operations *ops,
 	}
 }
 
+static void ops_exit_rtnl_list(const struct list_head *ops_list,
+			       const struct pernet_operations *ops,
+			       struct list_head *net_exit_list)
+{
+	const struct pernet_operations *saved_ops = ops;
+	LIST_HEAD(dev_kill_list);
+	struct net *net;
+
+	rtnl_lock();
+
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		__rtnl_net_lock(net);
+
+		ops = saved_ops;
+		list_for_each_entry_continue_reverse(ops, ops_list, list) {
+			if (ops->exit_rtnl)
+				ops->exit_rtnl(net, &dev_kill_list);
+		}
+
+		__rtnl_net_unlock(net);
+	}
+
+	ops = saved_ops;
+	list_for_each_entry_continue_reverse(ops, ops_list, list) {
+		if (ops->exit_batch_rtnl)
+			ops->exit_batch_rtnl(net_exit_list, &dev_kill_list);
+	}
+
+	unregister_netdevice_many(&dev_kill_list);
+
+	rtnl_unlock();
+}
+
 static void ops_exit_list(const struct pernet_operations *ops,
 			  struct list_head *net_exit_list)
 {
-	struct net *net;
 	if (ops->exit) {
+		struct net *net;
+
 		list_for_each_entry(net, net_exit_list, exit_list) {
 			ops->exit(net);
 			cond_resched();
 		}
 	}
+
 	if (ops->exit_batch)
 		ops->exit_batch(net_exit_list);
 }
@@ -214,18 +249,8 @@ static void ops_undo_list(const struct list_head *ops_list,
 	else
 		synchronize_rcu();
 
-	if (hold_rtnl) {
-		LIST_HEAD(dev_kill_list);
-
-		ops = saved_ops;
-		rtnl_lock();
-		list_for_each_entry_continue_reverse(ops, ops_list, list) {
-			if (ops->exit_batch_rtnl)
-				ops->exit_batch_rtnl(net_exit_list, &dev_kill_list);
-		}
-		unregister_netdevice_many(&dev_kill_list);
-		rtnl_unlock();
-	}
+	if (hold_rtnl)
+		ops_exit_rtnl_list(ops_list, saved_ops, net_exit_list);
 
 	ops = saved_ops;
 	list_for_each_entry_continue_reverse(ops, ops_list, list)
@@ -239,7 +264,7 @@ static void ops_undo_list(const struct list_head *ops_list,
 static void ops_undo_single(struct pernet_operations *ops,
 			    struct list_head *net_exit_list)
 {
-	bool hold_rtnl = !!ops->exit_batch_rtnl;
+	bool hold_rtnl = ops->exit_rtnl || ops->exit_batch_rtnl;
 	LIST_HEAD(ops_list);
 
 	list_add(&ops->list, &ops_list);
-- 
2.53.0



