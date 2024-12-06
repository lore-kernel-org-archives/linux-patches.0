Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FFD1E871;
	Fri,  6 Dec 2024 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497267; cv=none; b=gOQEFbhJWemwX8VgSfIRJWSBT3evf4J7DBizjlyAsRcM7B0kf+RbYTv+f4oU0Uhz+8y50HP2jPLHqv8vbSZPWoVVEJ0VwHDJuOKzUKDFmCo8omrwIqPYasqEBe7jNSFHkgFSn2Xj+yhEqsdwglUddG0hYHMoZ6W0b9ZHsRuGhkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497267; c=relaxed/simple;
	bh=i6GCL+OzcDY3Ub4+w2T0RRev9ed+P2uTfmmApCYcgyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAMR3spuf1oO3a9zELYqKhzCvVwTdfLcg7K3yGcrRw/EiDvVGonVhFeCYSf07U4chbNYq9YbM+pSZ975jaH9v+zujpB5UMIzEGvP+EfOByXfFHDZlVA8Vm3VwabbHZteZdTpjEWF9UR+ZuBJUJy9ISs4Eqg3cW1JdhuXrnBAUzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Na7MpHOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Na7MpHOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873E1C4CED1;
	Fri,  6 Dec 2024 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497267;
	bh=i6GCL+OzcDY3Ub4+w2T0RRev9ed+P2uTfmmApCYcgyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Na7MpHOZ0llL/uyB2T6w7Dx6kcJ2QFNQENSRMLdFweoup2yvogbgmvXgtN1N1SB/j
	 GnsiByomEGxtxJD+3ZlKh7JpC8jx3JWZutKcmw4K6trddIamtxMT5t0xRZMh/1+fka
	 7NWLNMXyoT0HTPGnpa8ki27VeF8jxEKeWuYUh2RU=
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
Subject: [PATCH 6.6 241/676] sock_diag: allow concurrent operations
Date: Fri,  6 Dec 2024 15:31:00 +0100
Message-ID: <20241206143702.745099725@linuxfoundation.org>
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
index c53b731f2d672..72009e1f4380d 100644
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
@@ -122,6 +122,24 @@ static size_t sock_diag_nlmsg_size(void)
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
@@ -138,12 +156,12 @@ static void sock_diag_broadcast_destroy_work(struct work_struct *work)
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
@@ -184,33 +202,26 @@ EXPORT_SYMBOL_GPL(sock_diag_unregister_inet_compat);
 
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
 
@@ -227,20 +238,20 @@ static int __sock_diag_cmd(struct sk_buff *skb, struct nlmsghdr *nlh)
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
@@ -286,12 +297,12 @@ static int sock_diag_bind(struct net *net, int group)
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



