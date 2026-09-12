Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA72356A0D;
	Sat, 12 Sep 2026 11:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212042; cv=none; b=BzErvp42XRFsg1FBA/1+QPzjlmhXqmeAqTkfCZadeRHXX4dfDeE9PcRqe88Se35XQFs9UJNI6w4rm0K9iHag9yDSxlPeK26XyUb78f0NEpwPYtFFwKNGyWSyqrIi9aS4p4+Zd2Dxnx5k6Bj639BkIWhwInwHxc7rh6z9drD3C38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212042; c=relaxed/simple;
	bh=bCLXr2bHv8bH6sC/ihDr1GAIo1gwMzwIt4tu0QWeZw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUkmZM0oZUfxwqbzYThmC00FSohe1o+1ExhsOwQMklIFsjMbUbQ7HoZVkTjHlD2EaMI4im/snjIdU1oFf9smvQtn4OmESyUkY+6xrBCK1/E1tl8wfBAYnV4asT8mOJ8nr/vKkv0hMtPNNSAWeHkW+YVq0RNiiCTANrbWsArPOzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sdxntrop; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sdxntrop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58031F000FF;
	Sat, 12 Sep 2026 11:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212040;
	bh=xTlftPbNjNsocZ7gaU/X8ivb7f6JcjBwZg99NjTPvak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sdxntrop8BadAsHVdeDZOGdJZeTxsxUkvFSWQWEr6zwO7B0yUJ/rTiLp7nRj5OlaY
	 tb+PG2JqM9Q3hICsw5maZbmoHqqdsjwvlV1iIcIIySIbQ2uh8UxujKUa6FTxfzKDRL
	 0VzOnwoE3TkpwJI7odNwuYgF1MhHcbuQ5933oEpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1355/1518] ipmr: Move unregister_netdevice_many() out of ipmr_free_table().
Date: Sat, 12 Sep 2026 08:58:44 +0200
Message-ID: <20260912065654.181873836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit b7fdc3cfb60a4dd80bb71c818fe433d8b3449cf3 ]

This is a prep commit to convert ipmr_net_exit_batch() to
->exit_rtnl().

Let's move unregister_netdevice_many() in ipmr_free_table()
to its callers.

Now ipmr_rules_exit() can do batching all tables per netns.

Note that later we will remove RTNL and unregister_netdevice_many()
in ipmr_rules_init().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260228221800.1082070-9-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 235b42b58601 ("ip6mr: do not clone dst in ip6mr_cache_report()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index ec98a47c75f7b..8fd75eae7314c 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -102,7 +102,8 @@ static DEFINE_SPINLOCK(mfc_unres_lock);
 static struct kmem_cache *mrt_cachep __ro_after_init;
 
 static struct mr_table *ipmr_new_table(struct net *net, u32 id);
-static void ipmr_free_table(struct mr_table *mrt);
+static void ipmr_free_table(struct mr_table *mrt,
+			    struct list_head *dev_kill_list);
 
 static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 			  struct net_device *dev, struct sk_buff *skb,
@@ -251,6 +252,7 @@ static const struct fib_rules_ops __net_initconst ipmr_rules_ops_template = {
 static int __net_init ipmr_rules_init(struct net *net)
 {
 	struct fib_rules_ops *ops;
+	LIST_HEAD(dev_kill_list);
 	struct mr_table *mrt;
 	int err;
 
@@ -275,7 +277,8 @@ static int __net_init ipmr_rules_init(struct net *net)
 
 err2:
 	rtnl_lock();
-	ipmr_free_table(mrt);
+	ipmr_free_table(mrt, &dev_kill_list);
+	unregister_netdevice_many(&dev_kill_list);
 	rtnl_unlock();
 err1:
 	fib_rules_unregister(ops);
@@ -285,12 +288,15 @@ static int __net_init ipmr_rules_init(struct net *net)
 static void __net_exit ipmr_rules_exit(struct net *net)
 {
 	struct mr_table *mrt, *next;
+	LIST_HEAD(dev_kill_list);
 
 	ASSERT_RTNL();
 	list_for_each_entry_safe(mrt, next, &net->ipv4.mr_tables, list) {
 		list_del(&mrt->list);
-		ipmr_free_table(mrt);
+		ipmr_free_table(mrt, &dev_kill_list);
 	}
+
+	unregister_netdevice_many(&dev_kill_list);
 	fib_rules_unregister(net->ipv4.mr_rules_ops);
 }
 
@@ -349,8 +355,13 @@ static int __net_init ipmr_rules_init(struct net *net)
 
 static void __net_exit ipmr_rules_exit(struct net *net)
 {
+	LIST_HEAD(dev_kill_list);
+
 	ASSERT_RTNL();
-	ipmr_free_table(net->ipv4.mrt);
+
+	ipmr_free_table(net->ipv4.mrt, &dev_kill_list);
+	unregister_netdevice_many(&dev_kill_list);
+
 	net->ipv4.mrt = NULL;
 }
 
@@ -425,18 +436,16 @@ static struct mr_table *ipmr_new_table(struct net *net, u32 id)
 			      ipmr_expire_process, ipmr_new_table_set);
 }
 
-static void ipmr_free_table(struct mr_table *mrt)
+static void ipmr_free_table(struct mr_table *mrt, struct list_head *dev_kill_list)
 {
 	struct net *net = read_pnet(&mrt->net);
-	LIST_HEAD(dev_kill_list);
 
 	WARN_ON_ONCE(!mr_can_free_table(net));
 
 	timer_shutdown_sync(&mrt->ipmr_expire_timer);
 	mroute_clean_tables(mrt, MRT_FLUSH_VIFS | MRT_FLUSH_VIFS_STATIC |
 			    MRT_FLUSH_MFC | MRT_FLUSH_MFC_STATIC,
-			    &dev_kill_list);
-	unregister_netdevice_many(&dev_kill_list);
+			    dev_kill_list);
 	rhltable_destroy(&mrt->mfc_hash);
 	kfree(mrt);
 }
-- 
2.53.0



