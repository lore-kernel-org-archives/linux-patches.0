Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F439223304;
	Thu, 12 Dec 2024 16:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019359; cv=none; b=huJCFtFPEa11AnMBPE23Icr2Sr3blW/7b7/biEbd4vj4Q88abouKgPf8acrkL/aY0WiCj4L/B00C4iR/Awj2s2YfKsNM8jAM9+0reQEmkRUb+G+pnHNTdKcVRef8rbd1vkM/8rOKvWPbxq1C5vbm3hc727MXhq3xGWRIpLn1i9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019359; c=relaxed/simple;
	bh=qm1YnoW+vQ+UocEeRoE3mSzBQ3xaBYGlx3dd/71L7jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtEI0c+7wazrnHHLjGKs0Ft+WRJDj9RSNgXckitpNP9DmxAL2mbib6aOe7XLuw0B7KyfN6hO9tb9KtoDtmJxMY2VucCq0C91Nz5HCclR72htBVr8Zgyw5P9+Ce5lufP8zywQJiuvrcsQ1CpdjblTQFKdPduRYTvPcaXU25c8pu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+CA8n47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+CA8n47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13E1C4CECE;
	Thu, 12 Dec 2024 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019359;
	bh=qm1YnoW+vQ+UocEeRoE3mSzBQ3xaBYGlx3dd/71L7jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+CA8n47XuRA39dFC+kv1eYS6M1qHjyVc8b3xas/0iRYFFH2BQnmHieRvjD60g8ZU
	 +4HWBYM8p2CfszXiAnX+AhgFcNqRDF2LscJfTADkJEX7KwUTM/mFoWJHxS4rkGtCia
	 tPfvE1EFMpSYS6rfuy+YGgT72W2PRrN5pbgRRRuY=
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
Subject: [PATCH 6.1 186/772] sock_diag: allow concurrent operations
Date: Thu, 12 Dec 2024 15:52:11 +0100
Message-ID: <20241212144357.628277824@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1d55a6974756cf3979efd2cc68bcece611a44053 ]

sock_diag_broadcast_destroy_work() and __sock_diag_cmd()
are currently using sock_diag_table_mutex to protect
against concurrent sock_diag_handlers[] changes.

This makes inet_diag dump serialized, thus less scalable
than legacy /proc files.

It is time to switch to full RCU protection.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: eb02688c5c45 ("ipv6: release nexthop on device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_diag.c | 73 +++++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index e6ea6764d10ab..73b2e36032b3e 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -16,7 +16,7 @@
 #include <linux/inet_diag.h>
 #include <linux/sock_diag.h>
 
-static const struct sock_diag_handler *sock_diag_handlers[AF_MAX];
+static const struct sock_diag_handler __rcu *sock_diag_handlers[AF_MAX];
 static int (*inet_rcv_compat)(struct sk_buff *skb, struct nlmsghdr *nlh);
 static DEFINE_MUTEX(sock_diag_table_mutex);
 static struct workqueue_struct *broadcast_wq;
@@ -119,6 +119,24 @@ static size_t sock_diag_nlmsg_size(void)
 	       + nla_total_size_64bit(sizeof(struct tcp_info))); /* INET_DIAG_INFO */
 }
 
+static const struct sock_diag_handler *sock_diag_lock_handler(int family)
+{
+	const struct sock_diag_handler *handler;
+
+	rcu_read_lock();
+	handler = rcu_dereference(sock_diag_handlers[family]);
+	if (handler && !try_module_get(handler->owner))
+		handler = NULL;
+	rcu_read_unlock();
+
+	return handler;
+}
+
+static void sock_diag_unlock_handler(const struct sock_diag_handler *handler)
+{
+	module_put(handler->owner);
+}
+
 static void sock_diag_broadcast_destroy_work(struct work_struct *work)
 {
 	struct broadcast_sk *bsk =
@@ -135,12 +153,12 @@ static void sock_diag_broadcast_destroy_work(struct work_struct *work)
 	if (!skb)
 		goto out;
 
-	mutex_lock(&sock_diag_table_mutex);
-	hndl = sock_diag_handlers[sk->sk_family];
-	if (hndl && hndl->get_info)
-		err = hndl->get_info(skb, sk);
-	mutex_unlock(&sock_diag_table_mutex);
-
+	hndl = sock_diag_lock_handler(sk->sk_family);
+	if (hndl) {
+		if (hndl->get_info)
+			err = hndl->get_info(skb, sk);
+		sock_diag_unlock_handler(hndl);
+	}
 	if (!err)
 		nlmsg_multicast(sock_net(sk)->diag_nlsk, skb, 0, group,
 				GFP_KERNEL);
@@ -181,33 +199,26 @@ EXPORT_SYMBOL_GPL(sock_diag_unregister_inet_compat);
 
 int sock_diag_register(const struct sock_diag_handler *hndl)
 {
-	int err = 0;
+	int family = hndl->family;
 
-	if (hndl->family >= AF_MAX)
+	if (family >= AF_MAX)
 		return -EINVAL;
 
-	mutex_lock(&sock_diag_table_mutex);
-	if (sock_diag_handlers[hndl->family])
-		err = -EBUSY;
-	else
-		WRITE_ONCE(sock_diag_handlers[hndl->family], hndl);
-	mutex_unlock(&sock_diag_table_mutex);
-
-	return err;
+	return !cmpxchg((const struct sock_diag_handler **)
+				&sock_diag_handlers[family],
+			NULL, hndl) ? 0 : -EBUSY;
 }
 EXPORT_SYMBOL_GPL(sock_diag_register);
 
-void sock_diag_unregister(const struct sock_diag_handler *hnld)
+void sock_diag_unregister(const struct sock_diag_handler *hndl)
 {
-	int family = hnld->family;
+	int family = hndl->family;
 
 	if (family >= AF_MAX)
 		return;
 
-	mutex_lock(&sock_diag_table_mutex);
-	BUG_ON(sock_diag_handlers[family] != hnld);
-	WRITE_ONCE(sock_diag_handlers[family], NULL);
-	mutex_unlock(&sock_diag_table_mutex);
+	xchg((const struct sock_diag_handler **)&sock_diag_handlers[family],
+	     NULL);
 }
 EXPORT_SYMBOL_GPL(sock_diag_unregister);
 
@@ -224,20 +235,20 @@ static int __sock_diag_cmd(struct sk_buff *skb, struct nlmsghdr *nlh)
 		return -EINVAL;
 	req->sdiag_family = array_index_nospec(req->sdiag_family, AF_MAX);
 
-	if (READ_ONCE(sock_diag_handlers[req->sdiag_family]) == NULL)
+	if (!rcu_access_pointer(sock_diag_handlers[req->sdiag_family]))
 		sock_load_diag_module(req->sdiag_family, 0);
 
-	mutex_lock(&sock_diag_table_mutex);
-	hndl = sock_diag_handlers[req->sdiag_family];
+	hndl = sock_diag_lock_handler(req->sdiag_family);
 	if (hndl == NULL)
-		err = -ENOENT;
-	else if (nlh->nlmsg_type == SOCK_DIAG_BY_FAMILY)
+		return -ENOENT;
+
+	if (nlh->nlmsg_type == SOCK_DIAG_BY_FAMILY)
 		err = hndl->dump(skb, nlh);
 	else if (nlh->nlmsg_type == SOCK_DESTROY && hndl->destroy)
 		err = hndl->destroy(skb, nlh);
 	else
 		err = -EOPNOTSUPP;
-	mutex_unlock(&sock_diag_table_mutex);
+	sock_diag_unlock_handler(hndl);
 
 	return err;
 }
@@ -283,12 +294,12 @@ static int sock_diag_bind(struct net *net, int group)
 	switch (group) {
 	case SKNLGRP_INET_TCP_DESTROY:
 	case SKNLGRP_INET_UDP_DESTROY:
-		if (!READ_ONCE(sock_diag_handlers[AF_INET]))
+		if (!rcu_access_pointer(sock_diag_handlers[AF_INET]))
 			sock_load_diag_module(AF_INET, 0);
 		break;
 	case SKNLGRP_INET6_TCP_DESTROY:
 	case SKNLGRP_INET6_UDP_DESTROY:
-		if (!READ_ONCE(sock_diag_handlers[AF_INET6]))
+		if (!rcu_access_pointer(sock_diag_handlers[AF_INET6]))
 			sock_load_diag_module(AF_INET6, 0);
 		break;
 	}
-- 
2.43.0



