Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDA22210FE;
	Thu, 12 Dec 2024 17:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023165; cv=none; b=XnUwGcFFj0cJSk90wWhwkiJLkOTM7FYCYlYHO8GiDti97aLk49kzyLxhkJqOGavgYGXyvHt+QkekyMAerOB9j/QWKMicrehew/50GqlIlgqsj9pZYqP6SPqyzzzTMDCuT3m1/T2TvtX+1N5jRISomrxt+L7m0nvqas1NBMC2W9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023165; c=relaxed/simple;
	bh=xtsSGlkdpUY6w99tbIuSa4vB739slkxWIpZtoNl0TA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUaRB8+oROqLiKrlMaD32LWiiTUZXDbcspjlwch33lNG1OAP2rSjOeCSd2NM2IGBZYWuvQh5/cqVmpEXumY2hbNFAzfDTjjV3dExSpqJ07PGniZGbQInbd3nT/L1lx41F8sukCfRqIBMXVjXEZh6zI6iMlDlZ3rRBesrxscc6bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWj750+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWj750+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73760C4CED0;
	Thu, 12 Dec 2024 17:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023164;
	bh=xtsSGlkdpUY6w99tbIuSa4vB739slkxWIpZtoNl0TA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWj750+WC+1X+MHoPSHsyr26xpzOA49O6AxNrJuhp7++JxkkhmK2ZsKEXnlxTaTU8
	 NdkDTfDRoanQasiW1mjyFa+7/bOzcvXLvLQMV5UxXGO7xxILUoUxg8E2bJDQQJkTe0
	 GLhQ0N8NVBIoO/v9GXgqrHvPn6JyJ94+9Ow8Dz2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 417/565] net/smc: Limit backlog connections
Date: Thu, 12 Dec 2024 16:00:12 +0100
Message-ID: <20241212144328.144861871@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit 8270d9c21041470f58348248b9d9dcf3bf79592e ]

Current implementation does not handling backlog semantics, one
potential risk is that server will be flooded by infinite amount
connections, even if client was SMC-incapable.

This patch works to put a limit on backlog connections, referring to the
TCP implementation, we divides SMC connections into two categories:

1. Half SMC connection, which includes all TCP established while SMC not
connections.

2. Full SMC connection, which includes all SMC established connections.

For half SMC connection, since all half SMC connections starts with TCP
established, we can achieve our goal by put a limit before TCP
established. Refer to the implementation of TCP, this limits will based
on not only the half SMC connections but also the full connections,
which is also a constraint on full SMC connections.

For full SMC connections, although we know exactly where it starts, it's
quite hard to put a limit before it. The easiest way is to block wait
before receive SMC confirm CLC message, while it's under protection by
smc_server_lgr_pending, a global lock, which leads this limit to the
entire host instead of a single listen socket. Another way is to drop
the full connections, but considering the cast of SMC connections, we
prefer to keep full SMC connections.

Even so, the limits of full SMC connections still exists, see commits
about half SMC connection below.

After this patch, the limits of backend connection shows like:

For SMC:

1. Client with SMC-capability can makes 2 * backlog full SMC connections
   or 1 * backlog half SMC connections and 1 * backlog full SMC
   connections at most.

2. Client without SMC-capability can only makes 1 * backlog half TCP
   connections and 1 * backlog full TCP connections.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 2c7f14ed9c19 ("net/smc: fix LGR and link use-after-free issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc.h    |  6 +++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index bd0b3a8b95d50..d433b88e6a277 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -71,6 +71,36 @@ static void smc_set_keepalive(struct sock *sk, int val)
 	smc->clcsock->sk->sk_prot->keepalive(smc->clcsock->sk, val);
 }
 
+static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
+					  struct sk_buff *skb,
+					  struct request_sock *req,
+					  struct dst_entry *dst,
+					  struct request_sock *req_unhash,
+					  bool *own_req)
+{
+	struct smc_sock *smc;
+
+	smc = smc_clcsock_user_data(sk);
+
+	if (READ_ONCE(sk->sk_ack_backlog) + atomic_read(&smc->queued_smc_hs) >
+				sk->sk_max_ack_backlog)
+		goto drop;
+
+	if (sk_acceptq_is_full(&smc->sk)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
+		goto drop;
+	}
+
+	/* passthrough to original syn recv sock fct */
+	return smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash,
+					      own_req);
+
+drop:
+	dst_release(dst);
+	tcp_listendrop(sk);
+	return NULL;
+}
+
 static struct smc_hashinfo smc_v4_hashinfo = {
 	.lock = __RW_LOCK_UNLOCKED(smc_v4_hashinfo.lock),
 };
@@ -1476,6 +1506,9 @@ static void smc_listen_out(struct smc_sock *new_smc)
 	struct smc_sock *lsmc = new_smc->listen_smc;
 	struct sock *newsmcsk = &new_smc->sk;
 
+	if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
+		atomic_dec(&lsmc->queued_smc_hs);
+
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		lock_sock_nested(&lsmc->sk, SINGLE_DEPTH_NESTING);
 		smc_accept_enqueue(&lsmc->sk, newsmcsk);
@@ -2008,6 +2041,9 @@ static void smc_tcp_listen_work(struct work_struct *work)
 		if (!new_smc)
 			continue;
 
+		if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
+			atomic_inc(&lsmc->queued_smc_hs);
+
 		new_smc->listen_smc = lsmc;
 		new_smc->use_fallback = lsmc->use_fallback;
 		new_smc->fallback_rsn = lsmc->fallback_rsn;
@@ -2074,6 +2110,15 @@ static int smc_listen(struct socket *sock, int backlog)
 	smc->clcsock->sk->sk_data_ready = smc_clcsock_data_ready;
 	smc->clcsock->sk->sk_user_data =
 		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+
+	/* save original ops */
+	smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
+
+	smc->af_ops = *smc->ori_af_ops;
+	smc->af_ops.syn_recv_sock = smc_tcp_syn_recv_sock;
+
+	inet_csk(smc->clcsock->sk)->icsk_af_ops = &smc->af_ops;
+
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc) {
 		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 57e376756b913..1c00f1bba2cdb 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -241,6 +241,10 @@ struct smc_sock {				/* smc sock container */
 	bool			use_fallback;	/* fallback to tcp */
 	int			fallback_rsn;	/* reason for fallback */
 	u32			peer_diagnosis; /* decline reason from peer */
+	atomic_t                queued_smc_hs;  /* queued smc handshakes */
+	struct inet_connection_sock_af_ops		af_ops;
+	const struct inet_connection_sock_af_ops	*ori_af_ops;
+						/* original af ops */
 	int			sockopt_defer_accept;
 						/* sockopt TCP_DEFER_ACCEPT
 						 * value
@@ -265,7 +269,7 @@ static inline struct smc_sock *smc_sk(const struct sock *sk)
 	return (struct smc_sock *)sk;
 }
 
-static inline struct smc_sock *smc_clcsock_user_data(struct sock *clcsk)
+static inline struct smc_sock *smc_clcsock_user_data(const struct sock *clcsk)
 {
 	return (struct smc_sock *)
 	       ((uintptr_t)clcsk->sk_user_data & ~SK_USER_DATA_NOCOPY);
-- 
2.43.0



