Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C0B22333F;
	Thu, 12 Dec 2024 17:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024958; cv=none; b=k25jhjuw6YxqkqAKpGiXodZEcoScyqj60+0jSKKx91lev/HeMzYQtmPmWLbF8g4JbTUsOsek+V/MoFTqJfg2+N7Mif443+oaHLMuuZaZ4+SQ4E2cFDOu7RXUs94I2RPC/M1TsrWVOWD1i06R63f2pCtbhHWrEjMDMdt29nAtPSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024958; c=relaxed/simple;
	bh=8LiWcANfiGLIxk1rsbqMhOWk4gjPCpI5R4tg7E74R0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pa20NSRba7B+h6a+7kFx+7ANYM6stUpGuZG3u4Yw3j+ccLgroTx0d+cg0nYkh+2uP7URUm5BBAG+8krzhWVQx6izRHjk/kC4yguFBtTKFHiQu1zCTVNWTEGVf9lq/Hl1IUTNuzY/RjMenM0UcqrYWNnBl2eC0ACw1P6OZ0rS8vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUnrtLma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUnrtLma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33CBC4CECE;
	Thu, 12 Dec 2024 17:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024958;
	bh=8LiWcANfiGLIxk1rsbqMhOWk4gjPCpI5R4tg7E74R0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wUnrtLmaeEE8g+83E8/SJVN9vOv4NpDDs/rXgQWhYRH/Zeoo6TgDrv0ayxWn7qs1m
	 WOOClG29jozjbYK3pe/SVwxrLMv2u4yGwGmMdF/GyqknCZwa90+/AFbFxmmLIsEoVA
	 nBEYBuWK0B51JQnrOoApCyWQnZNnYpr+SoFFytHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/321] netlink: terminate outstanding dump on socket close
Date: Thu, 12 Dec 2024 15:58:39 +0100
Message-ID: <20241212144229.368838967@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 719af25cd4d11..17d86eee8bd8b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -384,15 +384,6 @@ static void netlink_skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 
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
@@ -405,14 +396,6 @@ static void netlink_sock_destruct(struct sock *sk)
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
@@ -729,12 +712,6 @@ static void deferred_put_nlk_sk(struct rcu_head *head)
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
 
@@ -784,6 +761,14 @@ static int netlink_release(struct socket *sock)
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
index 5f454c8de6a4d..fca9556848885 100644
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -4,7 +4,6 @@
 
 #include <linux/rhashtable.h>
 #include <linux/atomic.h>
-#include <linux/workqueue.h>
 #include <net/sock.h>
 
 /* flags */
@@ -46,7 +45,6 @@ struct netlink_sock {
 
 	struct rhash_head	node;
 	struct rcu_head		rcu;
-	struct work_struct	work;
 };
 
 static inline struct netlink_sock *nlk_sk(struct sock *sk)
-- 
2.43.0



