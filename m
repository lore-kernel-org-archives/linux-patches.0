Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01E65B5AB;
	Sat, 17 Oct 2026 16:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253681; cv=none; b=mbtnBA0kIRcANEZ1IZH3UwSPqVwIPeKQGCwSbhTXkCJEYsDcFXJFbHGs+zA46m/v6vhavQXCGzafuuC+hSHR9KRI3lek2zEY6PD0RF16jcqxLm57w68h+s6ToOqXPgxf9oIp2E5an2VJNbcPeDT6WXlupWPtA/Yux3IbJtED+qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253681; c=relaxed/simple;
	bh=BA00hLm4zSt1uHwR71IorXcWkN6iUFdX3BeejrRd4Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8ks8/6Yjgutq7JYvsIX0oh7IzY93+45yAJ9zbGcvo8qxhLZRhYYQozSvR+55BiIKVlA1yU5yXmho+ywWuSTsg8TfjlF7UuePKwbzf9nybeiifFX6wUCsQZryvC5zOKHLZMcRLPOCLn9kQxxwPZKUU9dMVVd/oXBIgAj6avASyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2hV8dZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2hV8dZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123AB1F000C4;
	Sat, 17 Oct 2026 16:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253680;
	bh=UB0pvR4c9Nah2XS/bNbmptZK0CRhPePc8qwV9ZuAtIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2hV8dZcX50WPbIzYlcbV+zGvKfetUvR/kEXCRchLYh9hZ7MH5jMHjPpct3dweq2z
	 gmC8JWuPLYqkdVwumwYbjRqVQ8oG2kMWu7stykZXVgpYrm2AslV2RNZXy0g3WG2G+1
	 llFF1p68Y3EPJKB8Nze0GRxOq7DQIVtgimVKmWV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/869] net: Add ops_undo_single for module load/unload.
Date: Sat, 17 Oct 2026 17:50:37 +0200
Message-ID: <20261017160042.081671757@linuxfoundation.org>
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

[ Upstream commit fed176bf3143362ac9935e3964949ab6a5c3286b ]

If ops_init() fails while loading a module or we unload the
module, free_exit_list() rolls back the changes.

The rollback sequence is the same as ops_undo_list().

The ops is already removed from pernet_list before calling
free_exit_list().  If we link the ops to a temporary list,
we can reuse ops_undo_list().

Let's add a wrapper of ops_undo_list() and use it instead
of free_exit_list().

Now, we have the central place to roll back ops_init().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20250411205258.63164-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 60a25ef8dacb ("wireguard: device: use exit_rtnl callback instead of manual rtnl_lock in pre_exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 54 ++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 25f84a3764f71..f2171ff0e7b09 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -236,6 +236,17 @@ static void ops_undo_list(const struct list_head *ops_list,
 		ops_free_list(ops, net_exit_list);
 }
 
+static void ops_undo_single(struct pernet_operations *ops,
+			    struct list_head *net_exit_list)
+{
+	bool hold_rtnl = !!ops->exit_batch_rtnl;
+	LIST_HEAD(ops_list);
+
+	list_add(&ops->list, &ops_list);
+	ops_undo_list(&ops_list, NULL, net_exit_list, false, hold_rtnl);
+	list_del(&ops->list);
+}
+
 /* should be called with nsid_lock held */
 static int alloc_netid(struct net *net, struct net *peer, int reqid)
 {
@@ -1226,31 +1237,13 @@ void __init net_ns_init(void)
 		      RTNL_FLAG_DUMP_UNLOCKED);
 }
 
-static void free_exit_list(struct pernet_operations *ops, struct list_head *net_exit_list)
-{
-	ops_pre_exit_list(ops, net_exit_list);
-	synchronize_rcu();
-
-	if (ops->exit_batch_rtnl) {
-		LIST_HEAD(dev_kill_list);
-
-		rtnl_lock();
-		ops->exit_batch_rtnl(net_exit_list, &dev_kill_list);
-		unregister_netdevice_many(&dev_kill_list);
-		rtnl_unlock();
-	}
-	ops_exit_list(ops, net_exit_list);
-
-	ops_free_list(ops, net_exit_list);
-}
-
 #ifdef CONFIG_NET_NS
 static int __register_pernet_operations(struct list_head *list,
 					struct pernet_operations *ops)
 {
+	LIST_HEAD(net_exit_list);
 	struct net *net;
 	int error;
-	LIST_HEAD(net_exit_list);
 
 	list_add_tail(&ops->list, list);
 	if (ops->init || ops->id) {
@@ -1269,21 +1262,21 @@ static int __register_pernet_operations(struct list_head *list,
 out_undo:
 	/* If I have an error cleanup all namespaces I initialized */
 	list_del(&ops->list);
-	free_exit_list(ops, &net_exit_list);
+	ops_undo_single(ops, &net_exit_list);
 	return error;
 }
 
 static void __unregister_pernet_operations(struct pernet_operations *ops)
 {
-	struct net *net;
 	LIST_HEAD(net_exit_list);
+	struct net *net;
 
-	list_del(&ops->list);
 	/* See comment in __register_pernet_operations() */
 	for_each_net(net)
 		list_add_tail(&net->exit_list, &net_exit_list);
 
-	free_exit_list(ops, &net_exit_list);
+	list_del(&ops->list);
+	ops_undo_single(ops, &net_exit_list);
 }
 
 #else
@@ -1291,22 +1284,23 @@ static void __unregister_pernet_operations(struct pernet_operations *ops)
 static int __register_pernet_operations(struct list_head *list,
 					struct pernet_operations *ops)
 {
-	if (!init_net_initialized) {
-		list_add_tail(&ops->list, list);
+	list_add_tail(&ops->list, list);
+
+	if (!init_net_initialized)
 		return 0;
-	}
 
 	return ops_init(ops, &init_net);
 }
 
 static void __unregister_pernet_operations(struct pernet_operations *ops)
 {
-	if (!init_net_initialized) {
-		list_del(&ops->list);
-	} else {
+	list_del(&ops->list);
+
+	if (init_net_initialized) {
 		LIST_HEAD(net_exit_list);
+
 		list_add(&init_net.exit_list, &net_exit_list);
-		free_exit_list(ops, &net_exit_list);
+		ops_undo_single(ops, &net_exit_list);
 	}
 }
 
-- 
2.53.0



