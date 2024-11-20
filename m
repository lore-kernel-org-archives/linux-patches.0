Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C123E1A0BE1;
	Wed, 20 Nov 2024 13:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107657; cv=none; b=cIVqgqYq8zpcZiHdp5TtCjQ4XkZZEoKiYVPD9JnxEMOjU3W61YQloh+WoJXww6SQODsG849YlpGHUfs8HE9JgrByGmml08HTfNAMgy6hTn8x/iqO/krUNoROt+QNxZ6pSRcgtM+iaBvpHp1nUYL5pqSuUiTU4Fe2g6z0IQssKdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107657; c=relaxed/simple;
	bh=qMmf4amnWShql8PYK7hSabbtvlWo8yIQr6fAr8Qsd2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCEYqYI5MDnNe1yaWWggf7noaEVY/iIyTgmkH7B/aZG9Aq/yjzSDkvBlhOYoePmV6f3zB1bdOlN6V0rXpVzL2Ackmu9ThI9T5JlPOX+Q51F2UeAeXBmZKhhqr00w3JkqtcQwSivAKHnjp/87G2JLKHRUsuT75tzt5J4nnfXUwvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7ZktVdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7ZktVdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A5AC4CECD;
	Wed, 20 Nov 2024 13:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107657;
	bh=qMmf4amnWShql8PYK7hSabbtvlWo8yIQr6fAr8Qsd2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7ZktVdvkkwkWA/khc7ytnvCjEeMt9m+F1eNHmL3D0Lu8q5jQjjMTEE2vZHXmm/4k
	 CWUeRT24cI6Fy3qZ65ONoxOLBcALOYyQRTp6YihoOW6G7MgvsCXvNUrDNmrlx5hGaF
	 NMS2s+2V9n3uj2atfuAVkMTN9QewL5BuwarG3lac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 01/73] netlink: terminate outstanding dump on socket close
Date: Wed, 20 Nov 2024 13:57:47 +0100
Message-ID: <20241120125809.660406976@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1904fb9ebf911441f90a68e96b22aa73e4410505 ]

Netlink supports iterative dumping of data. It provides the families
the following ops:
 - start - (optional) kicks off the dumping process
 - dump  - actual dump helper, keeps getting called until it returns 0
 - done  - (optional) pairs with .start, can be used for cleanup
The whole process is asynchronous and the repeated calls to .dump
don't actually happen in a tight loop, but rather are triggered
in response to recvmsg() on the socket.

This gives the user full control over the dump, but also means that
the user can close the socket without getting to the end of the dump.
To make sure .start is always paired with .done we check if there
is an ongoing dump before freeing the socket, and if so call .done.

The complication is that sockets can get freed from BH and .done
is allowed to sleep. So we use a workqueue to defer the call, when
needed.

Unfortunately this does not work correctly. What we defer is not
the cleanup but rather releasing a reference on the socket.
We have no guarantee that we own the last reference, if someone
else holds the socket they may release it in BH and we're back
to square one.

The whole dance, however, appears to be unnecessary. Only the user
can interact with dumps, so we can clean up when socket is closed.
And close always happens in process context. Some async code may
still access the socket after close, queue notification skbs to it etc.
but no dumps can start, end or otherwise make progress.

Delete the workqueue and flush the dump state directly from the release
handler. Note that further cleanup is possible in -next, for instance
we now always call .done before releasing the main module reference,
so dump doesn't have to take a reference of its own.

Reported-by: syzkaller <syzkaller@googlegroups.com>
Fixes: ed5d7788a934 ("netlink: Do not schedule work from sk_destruct")
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241106015235.2458807-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 31 ++++++++-----------------------
 net/netlink/af_netlink.h |  2 --
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 9eb87f35bc65e..8a74847dacaf1 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -393,15 +393,6 @@ static void netlink_skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 
 static void netlink_sock_destruct(struct sock *sk)
 {
-	struct netlink_sock *nlk = nlk_sk(sk);
-
-	if (nlk->cb_running) {
-		if (nlk->cb.done)
-			nlk->cb.done(&nlk->cb);
-		module_put(nlk->cb.module);
-		kfree_skb(nlk->cb.skb);
-	}
-
 	skb_queue_purge(&sk->sk_receive_queue);
 
 	if (!sock_flag(sk, SOCK_DEAD)) {
@@ -414,14 +405,6 @@ static void netlink_sock_destruct(struct sock *sk)
 	WARN_ON(nlk_sk(sk)->groups);
 }
 
-static void netlink_sock_destruct_work(struct work_struct *work)
-{
-	struct netlink_sock *nlk = container_of(work, struct netlink_sock,
-						work);
-
-	sk_free(&nlk->sk);
-}
-
 /* This lock without WQ_FLAG_EXCLUSIVE is good on UP and it is _very_ bad on
  * SMP. Look, when several writers sleep and reader wakes them up, all but one
  * immediately hit write lock and grab all the cpus. Exclusive sleep solves
@@ -736,12 +719,6 @@ static void deferred_put_nlk_sk(struct rcu_head *head)
 	if (!refcount_dec_and_test(&sk->sk_refcnt))
 		return;
 
-	if (nlk->cb_running && nlk->cb.done) {
-		INIT_WORK(&nlk->work, netlink_sock_destruct_work);
-		schedule_work(&nlk->work);
-		return;
-	}
-
 	sk_free(sk);
 }
 
@@ -791,6 +768,14 @@ static int netlink_release(struct socket *sock)
 				NETLINK_URELEASE, &n);
 	}
 
+	/* Terminate any outstanding dump */
+	if (nlk->cb_running) {
+		if (nlk->cb.done)
+			nlk->cb.done(&nlk->cb);
+		module_put(nlk->cb.module);
+		kfree_skb(nlk->cb.skb);
+	}
+
 	module_put(nlk->module);
 
 	if (netlink_is_kernel(sk)) {
diff --git a/net/netlink/af_netlink.h b/net/netlink/af_netlink.h
index b30b8fc760f71..aa430e4d58d80 100644
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -4,7 +4,6 @@
 
 #include <linux/rhashtable.h>
 #include <linux/atomic.h>
-#include <linux/workqueue.h>
 #include <net/sock.h>
 
 /* flags */
@@ -48,7 +47,6 @@ struct netlink_sock {
 
 	struct rhash_head	node;
 	struct rcu_head		rcu;
-	struct work_struct	work;
 };
 
 static inline struct netlink_sock *nlk_sk(struct sock *sk)
-- 
2.43.0



