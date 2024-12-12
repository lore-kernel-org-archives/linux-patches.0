Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1AE212D6A;
	Thu, 12 Dec 2024 15:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017538; cv=none; b=SNhdyzcsICSpmKpQkKdRjI90ga4Hs/E1+IeEyuLh9Z466DrXWJH4jj0nlGDMbihQ3jlw5wws9hoF1UmmtHzZOf6mCqAAmR4b13jUk8bda2SX1u996AjQaPQbNEEMNnlIrpRZeN9EBIDvakdwmh/1yI/0xEm6f3Jum3+qSU/xAns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017538; c=relaxed/simple;
	bh=EXn094QhVlbgTDTqWc6N+CG5m2jnzpCY5eXMNLYeL7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPKv6xO39mNjuyoNVEvLkhc7udN96FAWF+sIcxXnuBFyAvfJ8D9PPFKCYR/HN3s1MxbePm4HPA0RYhpq8ZDZbdWlK0/dCZmqQWCcj5QEQltoxo/QVPoPO2z1Zjt5oyzkbp84nZaZRvSu/KF4oJS5JffY8MCHENOadLTYxy5LOqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ff+RXAM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ff+RXAM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF6CC4CECE;
	Thu, 12 Dec 2024 15:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017538;
	bh=EXn094QhVlbgTDTqWc6N+CG5m2jnzpCY5eXMNLYeL7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ff+RXAM+rDanQQ2/OO6FJ5Vfog+J8Wc0ncJueATcBRBOPq+Ha25pxN98YUKLr+9bj
	 RBWfw2ZisJUFg6cC8ULs51/oA90nJZGGVGiwratNMNrctZDvywRgydszv8LHSkJiLs
	 cBzQm+ROZ+LPL+jB26+kc6NC+autcEMprnTxWeoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/356] net/smc: refactoring initialization of smc sock
Date: Thu, 12 Dec 2024 15:56:01 +0100
Message-ID: <20241212144246.292578574@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit d0e35656d83458d668593930f1568d464dde429c ]

This patch aims to isolate the shared components of SMC socket
allocation by introducing smc_sk_init() for sock initialization
and __smc_create_clcsk() for the initialization of clcsock.

This is in preparation for the subsequent implementation of the
AF_INET version of SMC.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Tested-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0541db8ee32c ("net/smc: initialize close_work early to avoid warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 86 +++++++++++++++++++++++++++---------------------
 net/smc/smc.h    |  5 +++
 2 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c4b30ea4b6ca0..f343e91eec0e4 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -362,25 +362,15 @@ static void smc_destruct(struct sock *sk)
 		return;
 }
 
-static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
-				   int protocol)
+void smc_sk_init(struct net *net, struct sock *sk, int protocol)
 {
-	struct smc_sock *smc;
-	struct proto *prot;
-	struct sock *sk;
-
-	prot = (protocol == SMCPROTO_SMC6) ? &smc_proto6 : &smc_proto;
-	sk = sk_alloc(net, PF_SMC, GFP_KERNEL, prot, 0);
-	if (!sk)
-		return NULL;
+	struct smc_sock *smc = smc_sk(sk);
 
-	sock_init_data(sock, sk); /* sets sk_refcnt to 1 */
 	sk->sk_state = SMC_INIT;
 	sk->sk_destruct = smc_destruct;
 	sk->sk_protocol = protocol;
 	WRITE_ONCE(sk->sk_sndbuf, 2 * READ_ONCE(net->smc.sysctl_wmem));
 	WRITE_ONCE(sk->sk_rcvbuf, 2 * READ_ONCE(net->smc.sysctl_rmem));
-	smc = smc_sk(sk);
 	INIT_WORK(&smc->tcp_listen_work, smc_tcp_listen_work);
 	INIT_WORK(&smc->connect_work, smc_connect_work);
 	INIT_DELAYED_WORK(&smc->conn.tx_work, smc_tx_work);
@@ -390,6 +380,24 @@ static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
 	sk->sk_prot->hash(sk);
 	mutex_init(&smc->clcsock_release_lock);
 	smc_init_saved_callbacks(smc);
+	smc->limit_smc_hs = net->smc.limit_smc_hs;
+	smc->use_fallback = false; /* assume rdma capability first */
+	smc->fallback_rsn = 0;
+}
+
+static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
+				   int protocol)
+{
+	struct proto *prot;
+	struct sock *sk;
+
+	prot = (protocol == SMCPROTO_SMC6) ? &smc_proto6 : &smc_proto;
+	sk = sk_alloc(net, PF_SMC, GFP_KERNEL, prot, 0);
+	if (!sk)
+		return NULL;
+
+	sock_init_data(sock, sk); /* sets sk_refcnt to 1 */
+	smc_sk_init(net, sk, protocol);
 
 	return sk;
 }
@@ -3303,6 +3311,31 @@ static const struct proto_ops smc_sock_ops = {
 	.splice_read	= smc_splice_read,
 };
 
+int smc_create_clcsk(struct net *net, struct sock *sk, int family)
+{
+	struct smc_sock *smc = smc_sk(sk);
+	int rc;
+
+	rc = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP,
+			      &smc->clcsock);
+	if (rc) {
+		sk_common_release(sk);
+		return rc;
+	}
+
+	/* smc_clcsock_release() does not wait smc->clcsock->sk's
+	 * destruction;  its sk_state might not be TCP_CLOSE after
+	 * smc->sk is close()d, and TCP timers can be fired later,
+	 * which need net ref.
+	 */
+	sk = smc->clcsock->sk;
+	__netns_tracker_free(net, &sk->ns_tracker, false);
+	sk->sk_net_refcnt = 1;
+	get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
+	sock_inuse_add(net, 1);
+	return 0;
+}
+
 static int __smc_create(struct net *net, struct socket *sock, int protocol,
 			int kern, struct socket *clcsock)
 {
@@ -3328,35 +3361,12 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 
 	/* create internal TCP socket for CLC handshake and fallback */
 	smc = smc_sk(sk);
-	smc->use_fallback = false; /* assume rdma capability first */
-	smc->fallback_rsn = 0;
-
-	/* default behavior from limit_smc_hs in every net namespace */
-	smc->limit_smc_hs = net->smc.limit_smc_hs;
 
 	rc = 0;
-	if (!clcsock) {
-		rc = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP,
-				      &smc->clcsock);
-		if (rc) {
-			sk_common_release(sk);
-			goto out;
-		}
-
-		/* smc_clcsock_release() does not wait smc->clcsock->sk's
-		 * destruction;  its sk_state might not be TCP_CLOSE after
-		 * smc->sk is close()d, and TCP timers can be fired later,
-		 * which need net ref.
-		 */
-		sk = smc->clcsock->sk;
-		__netns_tracker_free(net, &sk->ns_tracker, false);
-		sk->sk_net_refcnt = 1;
-		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
-		sock_inuse_add(net, 1);
-	} else {
+	if (clcsock)
 		smc->clcsock = clcsock;
-	}
-
+	else
+		rc = smc_create_clcsk(net, sk, family);
 out:
 	return rc;
 }
diff --git a/net/smc/smc.h b/net/smc/smc.h
index e0afef7a786f8..36699ba551887 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -34,6 +34,11 @@
 extern struct proto smc_proto;
 extern struct proto smc_proto6;
 
+/* smc sock initialization */
+void smc_sk_init(struct net *net, struct sock *sk, int protocol);
+/* clcsock initialization */
+int smc_create_clcsk(struct net *net, struct sock *sk, int family);
+
 #ifdef ATOMIC64_INIT
 #define KERNEL_HAS_ATOMIC64
 #endif
-- 
2.43.0



