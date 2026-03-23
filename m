Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7837C286A4;
	Mon, 23 Mar 2026 13:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274227; cv=none; b=XkNzAa/dH7GVSwJ8AaHzm+455aPLpi8oAjMqz7gnhCZw6obrNm2T3+tT3RVFjd8kusurCm/Y6u80IYQHGETysVPUWnj4YuIynn7ny22Vx6jzWUm0zCUk3Hm628tslZoDlOeRT6sCr8qDDKJbW1lMux4Lh5e55Jm5chioaFNlBfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274227; c=relaxed/simple;
	bh=D9komQWLBGBAOArWKNN4G+TIMsoDc0hnGtU6PfIt4fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEAezw9NMkfWzNHxsQqXRSK851p66PO/kkLM07Z4BfX+l8qz5HTsLdOna4PnhgbhPbu9Jy4mKW/iwu23r6VhWatAYzE+EWCOPFj0HYomOO15T92cO1Mm2Z164G7WFHVBMY4axt+vDwkHREYIbERt1LphotHov9y4ItRP7XDqx9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg4fkeDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg4fkeDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE158C4CEF7;
	Mon, 23 Mar 2026 13:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274227;
	bh=D9komQWLBGBAOArWKNN4G+TIMsoDc0hnGtU6PfIt4fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zg4fkeDh9zngvZKeuuOxhf00f+HGbxeIbeat5DQJQ1dO0KXBnQjFhlk0zh0WKAq7Q
	 4sHZl7qKGQQ9IsNUtrZGlPvH+hHNHv0QzopFQKYtcxDf7NNKU0GQhgBFb94LVYJWiF
	 jucklclSYAso7BpYnhJ8SNYbaHGlIFbjQpA3KayU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+827ae2bfb3a3529333e9@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 149/220] net/smc: fix NULL dereference and UAF in smc_tcp_syn_recv_sock()
Date: Mon, 23 Mar 2026 14:45:26 +0100
Message-ID: <20260323134509.294705727@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 6d5e4538364b9ceb1ac2941a4deb86650afb3538 ]

Syzkaller reported a panic in smc_tcp_syn_recv_sock() [1].

smc_tcp_syn_recv_sock() is called in the TCP receive path
(softirq) via icsk_af_ops->syn_recv_sock on the clcsock (TCP
listening socket). It reads sk_user_data to get the smc_sock
pointer. However, when the SMC listen socket is being closed
concurrently, smc_close_active() sets clcsock->sk_user_data
to NULL under sk_callback_lock, and then the smc_sock itself
can be freed via sock_put() in smc_release().

This leads to two issues:

1) NULL pointer dereference: sk_user_data is NULL when
   accessed.
2) Use-after-free: sk_user_data is read as non-NULL, but the
   smc_sock is freed before its fields (e.g., queued_smc_hs,
   ori_af_ops) are accessed.

The race window looks like this (the syzkaller crash [1]
triggers via the SYN cookie path: tcp_get_cookie_sock() ->
smc_tcp_syn_recv_sock(), but the normal tcp_check_req() path
has the same race):

  CPU A (softirq)              CPU B (process ctx)

  tcp_v4_rcv()
    TCP_NEW_SYN_RECV:
    sk = req->rsk_listener
    sock_hold(sk)
    /* No lock on listener */
                               smc_close_active():
                                 write_lock_bh(cb_lock)
                                 sk_user_data = NULL
                                 write_unlock_bh(cb_lock)
                                 ...
                                 smc_clcsock_release()
                                 sock_put(smc->sk) x2
                                   -> smc_sock freed!
    tcp_check_req()
      smc_tcp_syn_recv_sock():
        smc = user_data(sk)
          -> NULL or dangling
        smc->queued_smc_hs
          -> crash!

Note that the clcsock and smc_sock are two independent objects
with separate refcounts. TCP stack holds a reference on the
clcsock, which keeps it alive, but this does NOT prevent the
smc_sock from being freed.

Fix this by using RCU and refcount_inc_not_zero() to safely
access smc_sock. Since smc_tcp_syn_recv_sock() is called in
the TCP three-way handshake path, taking read_lock_bh on
sk_callback_lock is too heavy and would not survive a SYN
flood attack. Using rcu_read_lock() is much more lightweight.

- Set SOCK_RCU_FREE on the SMC listen socket so that
  smc_sock freeing is deferred until after the RCU grace
  period. This guarantees the memory is still valid when
  accessed inside rcu_read_lock().
- Use rcu_read_lock() to protect reading sk_user_data.
- Use refcount_inc_not_zero(&smc->sk.sk_refcnt) to pin the
  smc_sock. If the refcount has already reached zero (close
  path completed), it returns false and we bail out safely.

Note: smc_hs_congested() has a similar lockless read of
sk_user_data without rcu_read_lock(), but it only checks for
NULL and accesses the global smc_hs_wq, never dereferencing
any smc_sock field, so it is not affected.

Reproducer was verified with mdelay injection and smc_run,
the issue no longer occurs with this patch applied.

[1] https://syzkaller.appspot.com/bug?extid=827ae2bfb3a3529333e9

Fixes: 8270d9c21041 ("net/smc: Limit backlog connections")
Reported-by: syzbot+827ae2bfb3a3529333e9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67eaf9b8.050a0220.3c3d88.004a.GAE@google.com/T/
Suggested-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://patch.msgid.link/20260312092909.48325-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c    | 23 +++++++++++++++++------
 net/smc/smc.h       |  5 +++++
 net/smc/smc_close.c |  2 +-
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 18c56b0d7ad53..765f26aaca93d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -131,7 +131,14 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
 	struct smc_sock *smc;
 	struct sock *child;
 
-	smc = smc_clcsock_user_data(sk);
+	rcu_read_lock();
+	smc = smc_clcsock_user_data_rcu(sk);
+	if (!smc || !refcount_inc_not_zero(&smc->sk.sk_refcnt)) {
+		rcu_read_unlock();
+		smc = NULL;
+		goto drop;
+	}
+	rcu_read_unlock();
 
 	if (READ_ONCE(sk->sk_ack_backlog) + atomic_read(&smc->queued_smc_hs) >
 				sk->sk_max_ack_backlog)
@@ -153,11 +160,14 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
 		if (inet_csk(child)->icsk_af_ops == inet_csk(sk)->icsk_af_ops)
 			inet_csk(child)->icsk_af_ops = smc->ori_af_ops;
 	}
+	sock_put(&smc->sk);
 	return child;
 
 drop:
 	dst_release(dst);
 	tcp_listendrop(sk);
+	if (smc)
+		sock_put(&smc->sk);
 	return NULL;
 }
 
@@ -254,7 +264,7 @@ static void smc_fback_restore_callbacks(struct smc_sock *smc)
 	struct sock *clcsk = smc->clcsock->sk;
 
 	write_lock_bh(&clcsk->sk_callback_lock);
-	clcsk->sk_user_data = NULL;
+	rcu_assign_sk_user_data(clcsk, NULL);
 
 	smc_clcsock_restore_cb(&clcsk->sk_state_change, &smc->clcsk_state_change);
 	smc_clcsock_restore_cb(&clcsk->sk_data_ready, &smc->clcsk_data_ready);
@@ -902,7 +912,7 @@ static void smc_fback_replace_callbacks(struct smc_sock *smc)
 	struct sock *clcsk = smc->clcsock->sk;
 
 	write_lock_bh(&clcsk->sk_callback_lock);
-	clcsk->sk_user_data = (void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+	__rcu_assign_sk_user_data_with_flags(clcsk, smc, SK_USER_DATA_NOCOPY);
 
 	smc_clcsock_replace_cb(&clcsk->sk_state_change, smc_fback_state_change,
 			       &smc->clcsk_state_change);
@@ -2665,8 +2675,8 @@ int smc_listen(struct socket *sock, int backlog)
 	 * smc-specific sk_data_ready function
 	 */
 	write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
-	smc->clcsock->sk->sk_user_data =
-		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+	__rcu_assign_sk_user_data_with_flags(smc->clcsock->sk, smc,
+					     SK_USER_DATA_NOCOPY);
 	smc_clcsock_replace_cb(&smc->clcsock->sk->sk_data_ready,
 			       smc_clcsock_data_ready, &smc->clcsk_data_ready);
 	write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
@@ -2687,10 +2697,11 @@ int smc_listen(struct socket *sock, int backlog)
 		write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 		smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
 				       &smc->clcsk_data_ready);
-		smc->clcsock->sk->sk_user_data = NULL;
+		rcu_assign_sk_user_data(smc->clcsock->sk, NULL);
 		write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
 		goto out;
 	}
+	sock_set_flag(sk, SOCK_RCU_FREE);
 	sk->sk_max_ack_backlog = backlog;
 	sk->sk_ack_backlog = 0;
 	sk->sk_state = SMC_LISTEN;
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 9e6af72784baa..52145df83f6e7 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -346,6 +346,11 @@ static inline struct smc_sock *smc_clcsock_user_data(const struct sock *clcsk)
 	       ((uintptr_t)clcsk->sk_user_data & ~SK_USER_DATA_NOCOPY);
 }
 
+static inline struct smc_sock *smc_clcsock_user_data_rcu(const struct sock *clcsk)
+{
+	return (struct smc_sock *)rcu_dereference_sk_user_data(clcsk);
+}
+
 /* save target_cb in saved_cb, and replace target_cb with new_cb */
 static inline void smc_clcsock_replace_cb(void (**target_cb)(struct sock *),
 					  void (*new_cb)(struct sock *),
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 10219f55aad14..bb0313ef5f7c1 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -218,7 +218,7 @@ int smc_close_active(struct smc_sock *smc)
 			write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 			smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
 					       &smc->clcsk_data_ready);
-			smc->clcsock->sk->sk_user_data = NULL;
+			rcu_assign_sk_user_data(smc->clcsock->sk, NULL);
 			write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
 			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
 		}
-- 
2.51.0



