Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E77C2E266C;
	Tue, 15 Jul 2025 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586817; cv=none; b=sPoQYFuwh/7mWKkwSkEaXhM0ZWazhES/2b8jpioV3BxV+YltSO9A14yjMYTRg/m0sKxg5eUP/K5wRa3ys8oz2e5telIek3GI8Pp7xDNVly2RPhwk+dAc+8jsUy9hcCO7emxZaDCfgAF7SGhGc2BpvXRcNwDeUYcFlHEkYdruhyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586817; c=relaxed/simple;
	bh=WxcVVwmCJ/RmX7V05W5+HTSNlkEp29no4Xvq+gRO+Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNBZ0hgGL5bG8jPTMFhUAspQRNjn8VC/fEusqJV1Wt9UhCmXgopJOVl5tW4oKFxVs5tW11zahQq0VDbLEcGSsV3D6+wUCoVkgHuUzP8Rzw5I7UA/8e69SmBM5nlzbjixd6LKys0usuEN8LPrBUeGIq4BtDxZ8bG7yjogdaDZzek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XV/CL572; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XV/CL572"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE916C4CEE3;
	Tue, 15 Jul 2025 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586817;
	bh=WxcVVwmCJ/RmX7V05W5+HTSNlkEp29no4Xvq+gRO+Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XV/CL572n2EEmGIA2bBnjE08pB618Xu+qNRwoJOplJo6wFSF2SoQS9CHsg4yjKtEn
	 SmDQKGleC8SUO9QkNVgljaLUj71xP1ZbZHhgseK6awJLmzDbIEhHm00KrDQzlD5YPE
	 N1criM4BUfZilWrUxxlRvjd7MQesDcQyP7aNOljc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Baron <jbaron@akamai.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 028/192] netlink: Fix wraparounds of sk->sk_rmem_alloc.
Date: Tue, 15 Jul 2025 15:12:03 +0200
Message-ID: <20250715130815.992284581@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit ae8f160e7eb24240a2a79fc4c815c6a0d4ee16cc ]

Netlink has this pattern in some places

  if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
  	atomic_add(skb->truesize, &sk->sk_rmem_alloc);

, which has the same problem fixed by commit 5a465a0da13e ("udp:
Fix multiple wraparounds of sk->sk_rmem_alloc.").

For example, if we set INT_MAX to SO_RCVBUFFORCE, the condition
is always false as the two operands are of int.

Then, a single socket can eat as many skb as possible until OOM
happens, and we can see multiple wraparounds of sk->sk_rmem_alloc.

Let's fix it by using atomic_add_return() and comparing the two
variables as unsigned int.

Before:
  [root@fedora ~]# ss -f netlink
  Recv-Q      Send-Q Local Address:Port                Peer Address:Port
  -1668710080 0               rtnl:nl_wraparound/293               *

After:
  [root@fedora ~]# ss -f netlink
  Recv-Q     Send-Q Local Address:Port                Peer Address:Port
  2147483072 0               rtnl:nl_wraparound/290               *
  ^
  `--- INT_MAX - 576

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Jason Baron <jbaron@akamai.com>
Closes: https://lore.kernel.org/netdev/cover.1750285100.git.jbaron@akamai.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250704054824.1580222-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 81 ++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 32 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index e8972a857e51e..79fbaf7333ce2 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -387,7 +387,6 @@ static void netlink_skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 	WARN_ON(skb->sk != NULL);
 	skb->sk = sk;
 	skb->destructor = netlink_skb_destructor;
-	atomic_add(skb->truesize, &sk->sk_rmem_alloc);
 	sk_mem_charge(sk, skb->truesize);
 }
 
@@ -1212,41 +1211,48 @@ struct sk_buff *netlink_alloc_large_skb(unsigned int size, int broadcast)
 int netlink_attachskb(struct sock *sk, struct sk_buff *skb,
 		      long *timeo, struct sock *ssk)
 {
+	DECLARE_WAITQUEUE(wait, current);
 	struct netlink_sock *nlk;
+	unsigned int rmem;
 
 	nlk = nlk_sk(sk);
+	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
 
-	if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
-	     test_bit(NETLINK_S_CONGESTED, &nlk->state))) {
-		DECLARE_WAITQUEUE(wait, current);
-		if (!*timeo) {
-			if (!ssk || netlink_is_kernel(ssk))
-				netlink_overrun(sk);
-			sock_put(sk);
-			kfree_skb(skb);
-			return -EAGAIN;
-		}
-
-		__set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&nlk->wait, &wait);
+	if ((rmem == skb->truesize || rmem < READ_ONCE(sk->sk_rcvbuf)) &&
+	    !test_bit(NETLINK_S_CONGESTED, &nlk->state)) {
+		netlink_skb_set_owner_r(skb, sk);
+		return 0;
+	}
 
-		if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
-		     test_bit(NETLINK_S_CONGESTED, &nlk->state)) &&
-		    !sock_flag(sk, SOCK_DEAD))
-			*timeo = schedule_timeout(*timeo);
+	atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
 
-		__set_current_state(TASK_RUNNING);
-		remove_wait_queue(&nlk->wait, &wait);
+	if (!*timeo) {
+		if (!ssk || netlink_is_kernel(ssk))
+			netlink_overrun(sk);
 		sock_put(sk);
+		kfree_skb(skb);
+		return -EAGAIN;
+	}
 
-		if (signal_pending(current)) {
-			kfree_skb(skb);
-			return sock_intr_errno(*timeo);
-		}
-		return 1;
+	__set_current_state(TASK_INTERRUPTIBLE);
+	add_wait_queue(&nlk->wait, &wait);
+	rmem = atomic_read(&sk->sk_rmem_alloc);
+
+	if (((rmem && rmem + skb->truesize > READ_ONCE(sk->sk_rcvbuf)) ||
+	     test_bit(NETLINK_S_CONGESTED, &nlk->state)) &&
+	    !sock_flag(sk, SOCK_DEAD))
+		*timeo = schedule_timeout(*timeo);
+
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&nlk->wait, &wait);
+	sock_put(sk);
+
+	if (signal_pending(current)) {
+		kfree_skb(skb);
+		return sock_intr_errno(*timeo);
 	}
-	netlink_skb_set_owner_r(skb, sk);
-	return 0;
+
+	return 1;
 }
 
 static int __netlink_sendskb(struct sock *sk, struct sk_buff *skb)
@@ -1307,6 +1313,7 @@ static int netlink_unicast_kernel(struct sock *sk, struct sk_buff *skb,
 	ret = -ECONNREFUSED;
 	if (nlk->netlink_rcv != NULL) {
 		ret = skb->len;
+		atomic_add(skb->truesize, &sk->sk_rmem_alloc);
 		netlink_skb_set_owner_r(skb, sk);
 		NETLINK_CB(skb).sk = ssk;
 		netlink_deliver_tap_kernel(sk, ssk, skb);
@@ -1383,13 +1390,19 @@ EXPORT_SYMBOL_GPL(netlink_strict_get_check);
 static int netlink_broadcast_deliver(struct sock *sk, struct sk_buff *skb)
 {
 	struct netlink_sock *nlk = nlk_sk(sk);
+	unsigned int rmem, rcvbuf;
 
-	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
+	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
+	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
+
+	if ((rmem != skb->truesize || rmem <= rcvbuf) &&
 	    !test_bit(NETLINK_S_CONGESTED, &nlk->state)) {
 		netlink_skb_set_owner_r(skb, sk);
 		__netlink_sendskb(sk, skb);
-		return atomic_read(&sk->sk_rmem_alloc) > (sk->sk_rcvbuf >> 1);
+		return rmem > (rcvbuf >> 1);
 	}
+
+	atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
 	return -1;
 }
 
@@ -2249,6 +2262,7 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 	struct module *module;
 	int err = -ENOBUFS;
 	int alloc_min_size;
+	unsigned int rmem;
 	int alloc_size;
 
 	if (!lock_taken)
@@ -2258,9 +2272,6 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 		goto errout_skb;
 	}
 
-	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf)
-		goto errout_skb;
-
 	/* NLMSG_GOODSIZE is small to avoid high order allocations being
 	 * required, but it makes sense to _attempt_ a 32KiB allocation
 	 * to reduce number of system calls on dump operations, if user
@@ -2283,6 +2294,12 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 	if (!skb)
 		goto errout_skb;
 
+	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
+	if (rmem >= READ_ONCE(sk->sk_rcvbuf)) {
+		atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
+		goto errout_skb;
+	}
+
 	/* Trim skb to allocated size. User is expected to provide buffer as
 	 * large as max(min_dump_alloc, 32KiB (max_recvmsg_len capped at
 	 * netlink_recvmsg())). dump will pack as many smaller messages as
-- 
2.39.5



