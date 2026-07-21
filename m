Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E91E46F48B;
	Tue, 21 Jul 2026 19:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663007; cv=none; b=SkSVRyqLEd3zo2wEaF8Zz85iaes7K1J16SYpS3jrQAzIo3MH7GwtEmCgn/DyjuY9FM5IhLjeauZWcsuW5/SFJOpwUH2sH+9byBwdHQjFgaM++9kjoDhjvD6w0MJPH7RbKkc/m7dmIYfpzReGDGF1kMmu94Q4IpqXk3kZIiqzlo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663007; c=relaxed/simple;
	bh=9GXISyiCNyjdWSXz0YqBrHl83X5/7U7eln0CXfOSbbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ND+qv6Pwf4PdAaMyGUQxnIVNnH3HeWhIOxSwwJkY9QFBUww7Vg7HBavuig32rxHYDEjq/MA0khVVHkVkknIHylvhqwpPRyGHfEqfiO/QDPD5BmxVrl9d2hPZZDeq2DvGuFhEgJReANGPT43L++MEcQn1prPLuYRbyCAQZBJHr1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiOO3hLk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiOO3hLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50491F000E9;
	Tue, 21 Jul 2026 19:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663006;
	bh=gZumLV07qvg4j7VtJvXjCCHehm07US+qe6J5purDnow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiOO3hLkTcQpCeVsZ8R55SJgiXtj0f9IzWfpfY8HN92Jcxnue4MNVVUB9OUFzfgzP
	 3EW8MBNrOxxsCTKbl+yUfFy1uMvY5t47Tx0cFm/SQ64KaJpMReeDddIqEyPsZxjoMb
	 6w1ADLkGuOwwbmo2CZib4wAV5YiaqE/8DMJur0gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0661/1276] rtnetlink: Add per-netns RTNL.
Date: Tue, 21 Jul 2026 17:18:24 +0200
Message-ID: <20260721152500.898462711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

[ Upstream commit 76aed95319da25d6884dff01d5f0149e4b542f96 ]

The goal is to break RTNL down into per-netns mutex.

This patch adds per-netns mutex and its helper functions, rtnl_net_lock()
and rtnl_net_unlock().

rtnl_net_lock() acquires the global RTNL and per-netns RTNL mutex, and
rtnl_net_unlock() releases them.

We will replace 800+ rtnl_lock() with rtnl_net_lock() and finally removes
rtnl_lock() in rtnl_net_lock().

When we need to nest per-netns RTNL mutex, we will use __rtnl_net_lock(),
and its locking order is defined by rtnl_net_lock_cmp_fn() as follows:

  1. init_net is first
  2. netns address ascending order

Note that the conversion will be done under CONFIG_DEBUG_NET_SMALL_RTNL
with LOCKDEP so that we can carefully add the extra mutex without slowing
down RTNL operations during conversion.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 17dc3b245de4 ("ipv6: fix missing notification for ignore_routes_with_linkdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rtnetlink.h   | 21 ++++++++++++++
 include/net/net_namespace.h |  4 +++
 net/Kconfig.debug           | 15 ++++++++++
 net/core/net_namespace.c    |  6 ++++
 net/core/rtnetlink.c        | 58 +++++++++++++++++++++++++++++++++++++
 5 files changed, 104 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index a7da7dfc06a2a4..067098030ad2c6 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -95,6 +95,27 @@ static inline bool lockdep_rtnl_is_held(void)
 #define rcu_replace_pointer_rtnl(rp, p)			\
 	rcu_replace_pointer(rp, p, lockdep_rtnl_is_held())
 
+#ifdef CONFIG_DEBUG_NET_SMALL_RTNL
+void __rtnl_net_lock(struct net *net);
+void __rtnl_net_unlock(struct net *net);
+void rtnl_net_lock(struct net *net);
+void rtnl_net_unlock(struct net *net);
+int rtnl_net_lock_cmp_fn(const struct lockdep_map *a, const struct lockdep_map *b);
+#else
+static inline void __rtnl_net_lock(struct net *net) {}
+static inline void __rtnl_net_unlock(struct net *net) {}
+
+static inline void rtnl_net_lock(struct net *net)
+{
+	rtnl_lock();
+}
+
+static inline void rtnl_net_unlock(struct net *net)
+{
+	rtnl_unlock();
+}
+#endif
+
 static inline struct netdev_queue *dev_ingress_queue(struct net_device *dev)
 {
 	return rtnl_dereference(dev->ingress_queue);
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 022ee2fc627cff..47181fd749b256 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -189,6 +189,10 @@ struct net {
 #if IS_ENABLED(CONFIG_SMC)
 	struct netns_smc	smc;
 #endif
+#ifdef CONFIG_DEBUG_NET_SMALL_RTNL
+	/* Move to a better place when the config guard is removed. */
+	struct mutex		rtnl_mutex;
+#endif
 } __randomize_layout;
 
 #include <linux/seq_file_net.h>
diff --git a/net/Kconfig.debug b/net/Kconfig.debug
index 5e3fffe707ddce..277fab8c4d77ca 100644
--- a/net/Kconfig.debug
+++ b/net/Kconfig.debug
@@ -24,3 +24,18 @@ config DEBUG_NET
 	help
 	  Enable extra sanity checks in networking.
 	  This is mostly used by fuzzers, but is safe to select.
+
+config DEBUG_NET_SMALL_RTNL
+	bool "Add extra per-netns mutex inside RTNL"
+	depends on DEBUG_KERNEL && NET && LOCK_DEBUGGING_SUPPORT
+	select PROVE_LOCKING
+	default n
+	help
+	  rtnl_lock() is being replaced with rtnl_net_lock() that
+	  acquires the global RTNL and a small per-netns RTNL mutex.
+
+	  During the conversion, rtnl_net_lock() just adds an extra
+	  mutex in every RTNL scope and slows down the operations.
+
+	  Once the conversion completes, rtnl_lock() will be removed
+	  and rtnetlink will gain per-netns scalability.
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index bb4ae3864ad256..cc03e3fd85fcdb 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -334,6 +334,12 @@ static __net_init void preinit_net(struct net *net, struct user_namespace *user_
 	idr_init(&net->netns_ids);
 	spin_lock_init(&net->nsid_lock);
 	mutex_init(&net->ipv4.ra_mutex);
+
+#ifdef CONFIG_DEBUG_NET_SMALL_RTNL
+	mutex_init(&net->rtnl_mutex);
+	lock_set_cmp_fn(&net->rtnl_mutex, rtnl_net_lock_cmp_fn, NULL);
+#endif
+
 	preinit_net_sysctl(net);
 }
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 118612325ce9e1..5b29f6ce12bc4a 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -179,6 +179,64 @@ bool lockdep_rtnl_is_held(void)
 EXPORT_SYMBOL(lockdep_rtnl_is_held);
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 
+#ifdef CONFIG_DEBUG_NET_SMALL_RTNL
+void __rtnl_net_lock(struct net *net)
+{
+	ASSERT_RTNL();
+
+	mutex_lock(&net->rtnl_mutex);
+}
+EXPORT_SYMBOL(__rtnl_net_lock);
+
+void __rtnl_net_unlock(struct net *net)
+{
+	ASSERT_RTNL();
+
+	mutex_unlock(&net->rtnl_mutex);
+}
+EXPORT_SYMBOL(__rtnl_net_unlock);
+
+void rtnl_net_lock(struct net *net)
+{
+	rtnl_lock();
+	__rtnl_net_lock(net);
+}
+EXPORT_SYMBOL(rtnl_net_lock);
+
+void rtnl_net_unlock(struct net *net)
+{
+	__rtnl_net_unlock(net);
+	rtnl_unlock();
+}
+EXPORT_SYMBOL(rtnl_net_unlock);
+
+static int rtnl_net_cmp_locks(const struct net *net_a, const struct net *net_b)
+{
+	if (net_eq(net_a, net_b))
+		return 0;
+
+	/* always init_net first */
+	if (net_eq(net_a, &init_net))
+		return -1;
+
+	if (net_eq(net_b, &init_net))
+		return 1;
+
+	/* otherwise lock in ascending order */
+	return net_a < net_b ? -1 : 1;
+}
+
+int rtnl_net_lock_cmp_fn(const struct lockdep_map *a, const struct lockdep_map *b)
+{
+	const struct net *net_a, *net_b;
+
+	net_a = container_of(a, struct net, rtnl_mutex.dep_map);
+	net_b = container_of(b, struct net, rtnl_mutex.dep_map);
+
+	return rtnl_net_cmp_locks(net_a, net_b);
+}
+#endif
+
 static struct rtnl_link __rcu *__rcu *rtnl_msg_handlers[RTNL_FAMILY_MAX + 1];
 
 static inline int rtm_msgindex(int msgtype)
-- 
2.53.0



