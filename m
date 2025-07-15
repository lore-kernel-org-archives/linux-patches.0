Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9D019066B;
	Tue, 15 Jul 2025 13:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585407; cv=none; b=Xn+3skonausnG4eFlSAkCcNjNoDpjZE9awMPzjH9SRJwuJyRdU4ZbprdOoyC+LcYWRdwnLDKDopFKAuwczIGZMdYureODqyDAPKGOJHoxdijBy1uphupW/L1EDwaElKOxNh25I2LvFRWkcJnaAAvjN9sQt4tX3MctQ3ELz8WyJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585407; c=relaxed/simple;
	bh=eE3KYbL18wBdU2P1E4U9/74kUIJLtQaCOGaNDA1Opbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGqZa89Y77LnUXn8nAsJ/SrsqKeNPi/C6MXj2BzvvO6+pz1/LYaqD+7Iig+mVdD7T5iSOqETsKMQkTldlHTQl/ghHSlJus+O4KG4ne/R/LJtvVvpD3ojePFaxHHSR94CWvRCUnWSO9Tt4P4wcBmeEDtOs/1ltSpQwvxMCYesRzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6QHMPRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6QHMPRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76412C4CEE3;
	Tue, 15 Jul 2025 13:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585406;
	bh=eE3KYbL18wBdU2P1E4U9/74kUIJLtQaCOGaNDA1Opbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6QHMPRBt2vk/bH35hTD7zgSq+Jb3PFWpwn8KUhY63zwFhXF5F6IUQ+YEQZRPcuG3
	 +Sbmdz9XbrLdO2VMU5V/H3oYP4wgKUJpWHg6QFOziTxNWd7EtAMkKjxeBahUQQ4IcN
	 dlMIn3irucx6LZCFgeKINlnShL0vqz8X97ZcOfCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Baron <jbaron@akamai.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/163] netlink: Fix wraparounds of sk->sk_rmem_alloc.
Date: Tue, 15 Jul 2025 15:11:37 +0200
Message-ID: <20250715130809.926161182@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 775d707ec708a..116c183d0e7c5 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -387,7 +387,6 @@ static void netlink_skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 	WARN_ON(skb->sk != NULL);
 	skb->sk = sk;
 	skb->destructor = netlink_skb_destructor;
-	atomic_add(skb->truesize, &sk->sk_rmem_alloc);
 	sk_mem_charge(sk, skb->truesize);
 }
 
@@ -1216,41 +1215,48 @@ struct sk_buff *netlink_alloc_large_skb(unsigned int size, int broadcast)
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
@@ -1310,6 +1316,7 @@ static int netlink_unicast_kernel(struct sock *sk, struct sk_buff *skb,
 	ret = -ECONNREFUSED;
 	if (nlk->netlink_rcv != NULL) {
 		ret = skb->len;
+		atomic_add(skb->truesize, &sk->sk_rmem_alloc);
 		netlink_skb_set_owner_r(skb, sk);
 		NETLINK_CB(skb).sk = ssk;
 		netlink_deliver_tap_kernel(sk, ssk, skb);
@@ -1386,13 +1393,19 @@ EXPORT_SYMBOL_GPL(netlink_strict_get_check);
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
 
@@ -2252,6 +2265,7 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 	struct module *module;
 	int err = -ENOBUFS;
 	int alloc_min_size;
+	unsigned int rmem;
 	int alloc_size;
 
 	if (!lock_taken)
@@ -2261,9 +2275,6 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 		goto errout_skb;
 	}
 
-	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf)
-		goto errout_skb;
-
 	/* NLMSG_GOODSIZE is small to avoid high order allocations being
 	 * required, but it makes sense to _attempt_ a 16K bytes allocation
 	 * to reduce number of system calls on dump operations, if user
@@ -2286,6 +2297,12 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 	if (!skb)
 		goto errout_skb;
 
+	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
+	if (rmem >= READ_ONCE(sk->sk_rcvbuf)) {
+		atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
+		goto errout_skb;
+	}
+
 	/* Trim skb to allocated size. User is expected to provide buffer as
 	 * large as max(min_dump_alloc, 16KiB (mac_recvmsg_len capped at
 	 * netlink_recvmsg())). dump will pack as many smaller messages as
-- 
2.39.5



