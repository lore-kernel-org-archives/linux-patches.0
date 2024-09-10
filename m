Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE16718C030;
	Tue, 10 Sep 2024 09:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961198; cv=none; b=iMyQ/TWQw0b7+yKrhkWhpPYSr/LVFsV2tpUCoVyUw73GUYyl9gBWD/1rxtV37Ohak767vsQBn90U190VXtKSWl+YWwHz4n5triYss5gpTzz869WUdYhrZQtt1Vv9Y0Ea/yLlb5HbzE3GbXO9bbE+Q4czJCY/J88KgsBgJfjKN4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961198; c=relaxed/simple;
	bh=kyy/790lIBs5YW4W2PX9HpmyuiL/84qg79n3iA3SEVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1YrrTJx4PFfHe0joRRGqk9cAAcOkLix2gFsczNScNtR50aKndCdWGFY9RdpngxB9ZLXpGDNca2asnegqL12l6paQseyUsyfEIwAPC8VZ37QZTMO7IiNABzaOAFVIFOseJIFh9puFSbiwf7ar9gfcjMxoD5dijoJLgz7VLbNmdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMF1JbhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMF1JbhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56053C4CEC3;
	Tue, 10 Sep 2024 09:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961198;
	bh=kyy/790lIBs5YW4W2PX9HpmyuiL/84qg79n3iA3SEVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMF1JbhHMVB4e33rZBw3QaCKIfMIZrvyDAfkHH2zzO3uld1wq5pSB25dQHMzxV335
	 XA3b0k1kUWxPkEXC1SHt9YW9QfK4nN7PQJcOJZrvFzLQl96kqtTVly35+XYPyCW7H9
	 SpGltRhU3GTOQpVnm5tCTEI8eblgxbdXJxK1SlWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 86/96] netns: add pre_exit method to struct pernet_operations
Date: Tue, 10 Sep 2024 11:32:28 +0200
Message-ID: <20240910092545.321536832@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit d7d99872c144a2c2f5d9c9d83627fa833836cba5 upstream.

Current struct pernet_operations exit() handlers are highly
discouraged to call synchronize_rcu().

There are cases where we need them, and exit_batch() does
not help the common case where a single netns is dismantled.

This patch leverages the existing synchronize_rcu() call
in cleanup_net()

Calling optional ->pre_exit() method before ->exit() or
->exit_batch() allows to benefit from a single synchronize_rcu()
call.

Note that the synchronize_rcu() calls added in this patch
are only in error paths or slow paths.

Tested:

$ time for i in {1..1000}; do unshare -n /bin/false;done

real	0m2.612s
user	0m0.171s
sys	0m2.216s

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/net_namespace.h |    5 +++++
 net/core/net_namespace.c    |   28 ++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -353,8 +353,13 @@ struct pernet_operations {
 	 * synchronize_rcu() related to these pernet_operations,
 	 * instead of separate synchronize_rcu() for every net.
 	 * Please, avoid synchronize_rcu() at all, where it's possible.
+	 *
+	 * Note that a combination of pre_exit() and exit() can
+	 * be used, since a synchronize_rcu() is guaranteed between
+	 * the calls.
 	 */
 	int (*init)(struct net *net);
+	void (*pre_exit)(struct net *net);
 	void (*exit)(struct net *net);
 	void (*exit_batch)(struct list_head *net_exit_list);
 	unsigned int *id;
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -154,6 +154,17 @@ static void ops_free(const struct pernet
 	}
 }
 
+static void ops_pre_exit_list(const struct pernet_operations *ops,
+			      struct list_head *net_exit_list)
+{
+	struct net *net;
+
+	if (ops->pre_exit) {
+		list_for_each_entry(net, net_exit_list, exit_list)
+			ops->pre_exit(net);
+	}
+}
+
 static void ops_exit_list(const struct pernet_operations *ops,
 			  struct list_head *net_exit_list)
 {
@@ -342,6 +353,12 @@ out_undo:
 	list_add(&net->exit_list, &net_exit_list);
 	saved_ops = ops;
 	list_for_each_entry_continue_reverse(ops, &pernet_list, list)
+		ops_pre_exit_list(ops, &net_exit_list);
+
+	synchronize_rcu();
+
+	saved_ops = ops;
+	list_for_each_entry_continue_reverse(ops, &pernet_list, list)
 		ops_exit_list(ops, &net_exit_list);
 
 	ops = saved_ops;
@@ -554,10 +571,15 @@ static void cleanup_net(struct work_stru
 		list_add_tail(&net->exit_list, &net_exit_list);
 	}
 
+	/* Run all of the network namespace pre_exit methods */
+	list_for_each_entry_reverse(ops, &pernet_list, list)
+		ops_pre_exit_list(ops, &net_exit_list);
+
 	/*
 	 * Another CPU might be rcu-iterating the list, wait for it.
 	 * This needs to be before calling the exit() notifiers, so
 	 * the rcu_barrier() below isn't sufficient alone.
+	 * Also the pre_exit() and exit() methods need this barrier.
 	 */
 	synchronize_rcu();
 
@@ -977,6 +999,8 @@ static int __register_pernet_operations(
 out_undo:
 	/* If I have an error cleanup all namespaces I initialized */
 	list_del(&ops->list);
+	ops_pre_exit_list(ops, &net_exit_list);
+	synchronize_rcu();
 	ops_exit_list(ops, &net_exit_list);
 	ops_free_list(ops, &net_exit_list);
 	return error;
@@ -991,6 +1015,8 @@ static void __unregister_pernet_operatio
 	/* See comment in __register_pernet_operations() */
 	for_each_net(net)
 		list_add_tail(&net->exit_list, &net_exit_list);
+	ops_pre_exit_list(ops, &net_exit_list);
+	synchronize_rcu();
 	ops_exit_list(ops, &net_exit_list);
 	ops_free_list(ops, &net_exit_list);
 }
@@ -1015,6 +1041,8 @@ static void __unregister_pernet_operatio
 	} else {
 		LIST_HEAD(net_exit_list);
 		list_add(&init_net.exit_list, &net_exit_list);
+		ops_pre_exit_list(ops, &net_exit_list);
+		synchronize_rcu();
 		ops_exit_list(ops, &net_exit_list);
 		ops_free_list(ops, &net_exit_list);
 	}


