Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF761E871;
	Fri,  6 Dec 2024 15:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497270; cv=none; b=P8YMZFcKD1B/knc1TlhC7HhtCJOFyWxUBGbE5Tf/GXJCWqdA0gLym6my4Kz6EH9+1sIXFMsQ9X/oG+/3hF4IdA5cnD6ZZQMzjcnHdAABX4QlmNEWBQG8LRzmGhJKvNOrncTBMlSbH15R+ZJ4aZ+CD194/764EW5AHAUNizjbhEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497270; c=relaxed/simple;
	bh=6DYPJDnvBpUXvflrMqQ/Rej2sDnnFK4+KjQJHcvxieI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSQ6TKfL3fn00rLCGtEbLbcnBf7ijeoM/qozCxx62XTK4mKtVSQMLfICK4p6eed1wydi32NVtI6829PMFz2h4aHOC5R+qka/xUjbzvEW/jK/W+8UU5FekEI4EAXf7WgNlZTCjoaPsT0EvhHXYCAQK2WIqTM4naidzGJBqbn/3do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWVsAXQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWVsAXQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACB4C4CED1;
	Fri,  6 Dec 2024 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497270;
	bh=6DYPJDnvBpUXvflrMqQ/Rej2sDnnFK4+KjQJHcvxieI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWVsAXQ2HmEAegvtT+WCVB3KhsXWarV6Mrej0bnncA2dtb5JnzKjWpgDF2/m2BbGR
	 g77+QRrU2BJCkxskmg1b4LN5YUrvqQ4YAZ7Oz+zjrYOKZ9X0xC0Dt4Si3PbOaQaZtx
	 aoXa4XiEQJC1NG/6eLUqV9zoz1QwfSuiAr5oovQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 242/676] sock_diag: allow concurrent operation in sock_diag_rcv_msg()
Date: Fri,  6 Dec 2024 15:31:01 +0100
Message-ID: <20241206143702.784521833@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 86e8921df05c6e9423ab74ab8d41022775d8b83a ]

TCPDIAG_GETSOCK and DCCPDIAG_GETSOCK diag are serialized
on sock_diag_table_mutex.

This is to make sure inet_diag module is not unloaded
while diag was ongoing.

It is time to get rid of this mutex and use RCU protection,
allowing full parallelism.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: eb02688c5c45 ("ipv6: release nexthop on device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sock_diag.h |  9 ++++++--
 net/core/sock_diag.c      | 43 +++++++++++++++++++++++----------------
 net/ipv4/inet_diag.c      |  9 ++++++--
 3 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/include/linux/sock_diag.h b/include/linux/sock_diag.h
index 7c07754d711b9..110978dc9af1b 100644
--- a/include/linux/sock_diag.h
+++ b/include/linux/sock_diag.h
@@ -23,8 +23,13 @@ struct sock_diag_handler {
 int sock_diag_register(const struct sock_diag_handler *h);
 void sock_diag_unregister(const struct sock_diag_handler *h);
 
-void sock_diag_register_inet_compat(int (*fn)(struct sk_buff *skb, struct nlmsghdr *nlh));
-void sock_diag_unregister_inet_compat(int (*fn)(struct sk_buff *skb, struct nlmsghdr *nlh));
+struct sock_diag_inet_compat {
+	struct module *owner;
+	int (*fn)(struct sk_buff *skb, struct nlmsghdr *nlh);
+};
+
+void sock_diag_register_inet_compat(const struct sock_diag_inet_compat *ptr);
+void sock_diag_unregister_inet_compat(const struct sock_diag_inet_compat *ptr);
 
 u64 __sock_gen_cookie(struct sock *sk);
 
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index 72009e1f4380d..5c3666431df49 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -17,8 +17,9 @@
 #include <linux/sock_diag.h>
 
 static const struct sock_diag_handler __rcu *sock_diag_handlers[AF_MAX];
-static int (*inet_rcv_compat)(struct sk_buff *skb, struct nlmsghdr *nlh);
-static DEFINE_MUTEX(sock_diag_table_mutex);
+
+static struct sock_diag_inet_compat __rcu *inet_rcv_compat;
+
 static struct workqueue_struct *broadcast_wq;
 
 DEFINE_COOKIE(sock_cookie);
@@ -184,19 +185,20 @@ void sock_diag_broadcast_destroy(struct sock *sk)
 	queue_work(broadcast_wq, &bsk->work);
 }
 
-void sock_diag_register_inet_compat(int (*fn)(struct sk_buff *skb, struct nlmsghdr *nlh))
+void sock_diag_register_inet_compat(const struct sock_diag_inet_compat *ptr)
 {
-	mutex_lock(&sock_diag_table_mutex);
-	inet_rcv_compat = fn;
-	mutex_unlock(&sock_diag_table_mutex);
+	xchg((__force const struct sock_diag_inet_compat **)&inet_rcv_compat,
+	     ptr);
 }
 EXPORT_SYMBOL_GPL(sock_diag_register_inet_compat);
 
-void sock_diag_unregister_inet_compat(int (*fn)(struct sk_buff *skb, struct nlmsghdr *nlh))
+void sock_diag_unregister_inet_compat(const struct sock_diag_inet_compat *ptr)
 {
-	mutex_lock(&sock_diag_table_mutex);
-	inet_rcv_compat = NULL;
-	mutex_unlock(&sock_diag_table_mutex);
+	const struct sock_diag_inet_compat *old;
+
+	old = xchg((__force const struct sock_diag_inet_compat **)&inet_rcv_compat,
+		   NULL);
+	WARN_ON_ONCE(old != ptr);
 }
 EXPORT_SYMBOL_GPL(sock_diag_unregister_inet_compat);
 
@@ -259,20 +261,27 @@ static int __sock_diag_cmd(struct sk_buff *skb, struct nlmsghdr *nlh)
 static int sock_diag_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			     struct netlink_ext_ack *extack)
 {
+	const struct sock_diag_inet_compat *ptr;
 	int ret;
 
 	switch (nlh->nlmsg_type) {
 	case TCPDIAG_GETSOCK:
 	case DCCPDIAG_GETSOCK:
-		if (inet_rcv_compat == NULL)
+
+		if (!rcu_access_pointer(inet_rcv_compat))
 			sock_load_diag_module(AF_INET, 0);
 
-		mutex_lock(&sock_diag_table_mutex);
-		if (inet_rcv_compat != NULL)
-			ret = inet_rcv_compat(skb, nlh);
-		else
-			ret = -EOPNOTSUPP;
-		mutex_unlock(&sock_diag_table_mutex);
+		rcu_read_lock();
+		ptr = rcu_dereference(inet_rcv_compat);
+		if (ptr && !try_module_get(ptr->owner))
+			ptr = NULL;
+		rcu_read_unlock();
+
+		ret = -EOPNOTSUPP;
+		if (ptr) {
+			ret = ptr->fn(skb, nlh);
+			module_put(ptr->owner);
+		}
 
 		return ret;
 	case SOCK_DIAG_BY_FAMILY:
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index c1ff0e426b677..5d09ab3ed735e 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -1445,6 +1445,11 @@ void inet_diag_unregister(const struct inet_diag_handler *h)
 }
 EXPORT_SYMBOL_GPL(inet_diag_unregister);
 
+static const struct sock_diag_inet_compat inet_diag_compat = {
+	.owner	= THIS_MODULE,
+	.fn	= inet_diag_rcv_msg_compat,
+};
+
 static int __init inet_diag_init(void)
 {
 	const int inet_diag_table_size = (IPPROTO_MAX *
@@ -1463,7 +1468,7 @@ static int __init inet_diag_init(void)
 	if (err)
 		goto out_free_inet;
 
-	sock_diag_register_inet_compat(inet_diag_rcv_msg_compat);
+	sock_diag_register_inet_compat(&inet_diag_compat);
 out:
 	return err;
 
@@ -1478,7 +1483,7 @@ static void __exit inet_diag_exit(void)
 {
 	sock_diag_unregister(&inet6_diag_handler);
 	sock_diag_unregister(&inet_diag_handler);
-	sock_diag_unregister_inet_compat(inet_diag_rcv_msg_compat);
+	sock_diag_unregister_inet_compat(&inet_diag_compat);
 	kfree(inet_diag_table);
 }
 
-- 
2.43.0



