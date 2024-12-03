Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648773BB24;
	Tue,  3 Dec 2024 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236396; cv=none; b=WdPNZhe8wmT2GX3dMWkr+6x8OUEZ6OikWv86usRfLp1JRn28weIjLLTggmPXzFjSMT7FfPSIbeQNI9gjetwNK69W+Y0D16dlUFHzeUeHZrQiDWr2u6XKwHU/+bLjjqbSGrTz+dQps3t6EGfAjngc4ZAioqOXtEvaSl1XSmrPL10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236396; c=relaxed/simple;
	bh=gg7mnNVWzAOE1DNxi7ful6QkRKwAey+owIxwO3I+mLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkMwS0ayjj1BpSnZFRT8IRM+KT3kuQ7Kk6djw6CrxPC/POGjADOYfxYogzK5FVMmTuMrgTlzw6sV9OqSg7CNGqb+ELH3la2cbL14N3eGMAQr6sLpeRAtvXp92tK3kaTC130KriMZXzo9LRZzbCDbavs2Py7XLAIgNZtCNeJLW8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQ54r1a2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQ54r1a2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FE0C4CECF;
	Tue,  3 Dec 2024 14:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236395;
	bh=gg7mnNVWzAOE1DNxi7ful6QkRKwAey+owIxwO3I+mLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQ54r1a2DIfHrebQux9t6Vfpq9JeXlASbOFCBqao+1GXcHCIkj/fL6A1tSiNmIOkR
	 UOHKzM/EiI1dXHiYhpQZZ1ZTKjTGsnnKA2zh2f+jsguY077zkAeT4zGEWxpsSFlGM0
	 V1cRSB/lY1zfqtcaSXpWQcUhs5MFzhwHg6e5WS88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/138] netlink: terminate outstanding dump on socket close
Date: Tue,  3 Dec 2024 15:30:30 +0100
Message-ID: <20241203141923.586600123@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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
 net/netlink/af_netlink.c |   31 ++++++++-----------------------
 net/netlink/af_netlink.h |    2 --
 2 files changed, 8 insertions(+), 25 deletions(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -393,15 +393,6 @@ static void netlink_skb_set_owner_r(stru
 
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
@@ -414,14 +405,6 @@ static void netlink_sock_destruct(struct
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
@@ -738,12 +721,6 @@ static void deferred_put_nlk_sk(struct r
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
 
@@ -793,6 +770,14 @@ static int netlink_release(struct socket
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
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -4,7 +4,6 @@
 
 #include <linux/rhashtable.h>
 #include <linux/atomic.h>
-#include <linux/workqueue.h>
 #include <net/sock.h>
 
 /* flags */
@@ -45,7 +44,6 @@ struct netlink_sock {
 
 	struct rhash_head	node;
 	struct rcu_head		rcu;
-	struct work_struct	work;
 };
 
 static inline struct netlink_sock *nlk_sk(struct sock *sk)


