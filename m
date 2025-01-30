Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C151E7C25;
	Thu, 30 Jan 2025 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246750; cv=none; b=rt9iJl2DGGWPdetRBqjIOPU8DY/YG155bnL56mO2Uchp9rm0zNTerPD0z0Wzj8CYnezouqerDZser/H0L+WxmuHVhi+OrgkR0YS96IwJQ2w2BJad1scBesbNS2pgfcqgTUmNFHoN4nEHPWonzLSAMnL8AxOe8hzH5xhMTyU5+q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246750; c=relaxed/simple;
	bh=oGRS5VESMEZC9LvRCc8PLRoTIiJFHB860Nr4pXt5sL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euX3RtwyYd5K74VWzaw95m8Jp2gbmVG3FgZofCoR8BwsF6eJSN1N7eDXKiTpQ89I6pESNe0lrt/NJRTYrQtxV9yQdqSGEpiLJU8Uif1b9hdW417vsZbWyqM77VWz8Rh4nDB9fNN1Q1X4rAhaXueN1crcPzBwXW9f9rUCulPqUSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ij+rNBON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ij+rNBON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF75C4CED2;
	Thu, 30 Jan 2025 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246750;
	bh=oGRS5VESMEZC9LvRCc8PLRoTIiJFHB860Nr4pXt5sL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ij+rNBONCZOB2+4eVM5dnR/a5RFURu9mwP2g68nUHGHJp+iphC+d6XBLUWozUixWG
	 veuPeW1uv8O3qyf/DKmXG6IoCugtNiJxjjJ20G+wSouZ2cAqF+KjBVDaTU7HMN3TAG
	 WMuy5f6zWMUFBrdy9+BjAumBB1YQeb3iVVGtkYOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yajun Deng <yajun.deng@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 55/91] net: net_namespace: Optimize the code
Date: Thu, 30 Jan 2025 15:01:14 +0100
Message-ID: <20250130140135.871621164@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 41467d2ff4dfe1837cbb0f45e2088e6e787580c6 ]

There is only one caller for ops_free(), so inline it.
Separate net_drop_ns() and net_free(), so the net_free()
can be called directly.
Add free_exit_list() helper function for free net_exit_list.

====================
v2:
 - v1 does not apply, rebase it.
====================

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 46841c7053e6 ("gtp: Use for_each_netdev_rcu() in gtp_genl_dump_pdp().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 52 +++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index c94179d30d426..c4bcedc06822b 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -98,7 +98,7 @@ static int net_assign_generic(struct net *net, unsigned int id, void *data)
 	}
 
 	ng = net_alloc_generic();
-	if (ng == NULL)
+	if (!ng)
 		return -ENOMEM;
 
 	/*
@@ -155,13 +155,6 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
 	return err;
 }
 
-static void ops_free(const struct pernet_operations *ops, struct net *net)
-{
-	if (ops->id && ops->size) {
-		kfree(net_generic(net, *ops->id));
-	}
-}
-
 static void ops_pre_exit_list(const struct pernet_operations *ops,
 			      struct list_head *net_exit_list)
 {
@@ -193,7 +186,7 @@ static void ops_free_list(const struct pernet_operations *ops,
 	struct net *net;
 	if (ops->size && ops->id) {
 		list_for_each_entry(net, net_exit_list, exit_list)
-			ops_free(ops, net);
+			kfree(net_generic(net, *ops->id));
 	}
 }
 
@@ -448,15 +441,18 @@ static struct net *net_alloc(void)
 
 static void net_free(struct net *net)
 {
-	kfree(rcu_access_pointer(net->gen));
-	kmem_cache_free(net_cachep, net);
+	if (refcount_dec_and_test(&net->passive)) {
+		kfree(rcu_access_pointer(net->gen));
+		kmem_cache_free(net_cachep, net);
+	}
 }
 
 void net_drop_ns(void *p)
 {
-	struct net *ns = p;
-	if (ns && refcount_dec_and_test(&ns->passive))
-		net_free(ns);
+	struct net *net = (struct net *)p;
+
+	if (net)
+		net_free(net);
 }
 
 struct net *copy_net_ns(unsigned long flags,
@@ -496,7 +492,7 @@ struct net *copy_net_ns(unsigned long flags,
 		key_remove_domain(net->key_domain);
 #endif
 		put_user_ns(user_ns);
-		net_drop_ns(net);
+		net_free(net);
 dec_ucounts:
 		dec_net_namespaces(ucounts);
 		return ERR_PTR(rv);
@@ -630,7 +626,7 @@ static void cleanup_net(struct work_struct *work)
 		key_remove_domain(net->key_domain);
 #endif
 		put_user_ns(net->user_ns);
-		net_drop_ns(net);
+		net_free(net);
 	}
 }
 
@@ -1150,6 +1146,14 @@ static int __init net_ns_init(void)
 
 pure_initcall(net_ns_init);
 
+static void free_exit_list(struct pernet_operations *ops, struct list_head *net_exit_list)
+{
+	ops_pre_exit_list(ops, net_exit_list);
+	synchronize_rcu();
+	ops_exit_list(ops, net_exit_list);
+	ops_free_list(ops, net_exit_list);
+}
+
 #ifdef CONFIG_NET_NS
 static int __register_pernet_operations(struct list_head *list,
 					struct pernet_operations *ops)
@@ -1175,10 +1179,7 @@ static int __register_pernet_operations(struct list_head *list,
 out_undo:
 	/* If I have an error cleanup all namespaces I initialized */
 	list_del(&ops->list);
-	ops_pre_exit_list(ops, &net_exit_list);
-	synchronize_rcu();
-	ops_exit_list(ops, &net_exit_list);
-	ops_free_list(ops, &net_exit_list);
+	free_exit_list(ops, &net_exit_list);
 	return error;
 }
 
@@ -1191,10 +1192,8 @@ static void __unregister_pernet_operations(struct pernet_operations *ops)
 	/* See comment in __register_pernet_operations() */
 	for_each_net(net)
 		list_add_tail(&net->exit_list, &net_exit_list);
-	ops_pre_exit_list(ops, &net_exit_list);
-	synchronize_rcu();
-	ops_exit_list(ops, &net_exit_list);
-	ops_free_list(ops, &net_exit_list);
+
+	free_exit_list(ops, &net_exit_list);
 }
 
 #else
@@ -1217,10 +1216,7 @@ static void __unregister_pernet_operations(struct pernet_operations *ops)
 	} else {
 		LIST_HEAD(net_exit_list);
 		list_add(&init_net.exit_list, &net_exit_list);
-		ops_pre_exit_list(ops, &net_exit_list);
-		synchronize_rcu();
-		ops_exit_list(ops, &net_exit_list);
-		ops_free_list(ops, &net_exit_list);
+		free_exit_list(ops, &net_exit_list);
 	}
 }
 
-- 
2.39.5



