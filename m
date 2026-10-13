Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552EF471269;
	Tue, 13 Oct 2026 12:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893511; cv=none; b=Z4olKIxxdPaSiJh/mf/HyMyYP6wZ3hDIOkIvCIuf0zMl+EVfr5CNwf6YMvruMF2fLrqee4kI0423dG4AXptscNK11mmJfHoamp3PbdVX6ret3ZwKYYmAmJEUGyUeBps38KM0FDuxafW7BZyJlH9BTPPodhNmi7JyaoPUdkj7DRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893511; c=relaxed/simple;
	bh=ueaBacZhipotuWR2brzI5VafqmsRFPx2MiBpTALFPr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQsABLF4rAM9MqPTp0Gf9pD0DCb5T2L1zgfb2hVwfZ+QNwEPRdl9DAG33Q8udUzLkp1OhHknICq7vIAkhjmbrHKfO6qwMm1k5cKBAgj3+QmTUPYeohjhQbrDEok2yAlj6aL9rG43Zhow9qLT0tRHfNuQIAWnD7Qxnl38Psli2Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKDlEY3E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKDlEY3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8611F000FF;
	Tue, 13 Oct 2026 12:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893510;
	bh=NRZhflA+cDUTEwKI3nRS6xRAR8il0ag9XEMUtd3XI5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gKDlEY3EpbUOsA2WmGM8DTFVPA1Z7MIyB2OFgac2I1tf2HhnWz+aeKgOeux8tIPeL
	 cMzbnJt+KZLmB/P5fOVUqzjTvCKWwlTvMbYDwOYhv1tAMlNuc8rkUY/anYk1ijCo3g
	 BYYNTtmdr6KjgmouBzCbS/yNsUyUUnCCB7yOBXck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 206/621] Revert "net/smc: Introduce TCP ULP support"
Date: Tue, 13 Oct 2026 13:33:21 +0200
Message-ID: <20261013112925.749270575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit df31a6b0a3057e66994ad6ccf5d95b9b9514f033 ]

This reverts commit d7cd421da9da2cc7b4d25b8537f66db5c8331c40.

As reported by Al Viro, the TCP ULP support for SMC is fundamentally
broken. The implementation attempts to convert an active TCP socket
into an SMC socket by modifying the underlying `struct file`, dentry,
and inode in-place, which violates core VFS invariants that assume
these structures are immutable for an open file, creating a risk of
use after free errors and general system instability.

Given the severity of this design flaw and the fact that cleaner
alternatives (e.g., LD_PRELOAD, BPF) exist for legacy application
transparency, the correct course of action is to remove this feature
entirely.

Fixes: d7cd421da9da ("net/smc: Introduce TCP ULP support")
Link: https://lore.kernel.org/netdev/Yus1SycZxcd+wHwz@ZenIV/
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260128055452.98251-1-alibuda@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 91 +++---------------------------------------------
 1 file changed, 4 insertions(+), 87 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index b110d21000cc3..1db56310fda01 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3379,11 +3379,10 @@ int smc_create_clcsk(struct net *net, struct sock *sk, int family)
 	return 0;
 }
 
-static int __smc_create(struct net *net, struct socket *sock, int protocol,
-			int kern, struct socket *clcsock)
+static int smc_create(struct net *net, struct socket *sock, int protocol,
+		      int kern)
 {
 	int family = (protocol == SMCPROTO_SMC6) ? PF_INET6 : PF_INET;
-	struct smc_sock *smc;
 	struct sock *sk;
 	int rc;
 
@@ -3402,15 +3401,7 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 	if (!sk)
 		goto out;
 
-	/* create internal TCP socket for CLC handshake and fallback */
-	smc = smc_sk(sk);
-
-	rc = 0;
-	if (clcsock)
-		smc->clcsock = clcsock;
-	else
-		rc = smc_create_clcsk(net, sk, family);
-
+	rc = smc_create_clcsk(net, sk, family);
 	if (rc) {
 		sk_common_release(sk);
 		sock->sk = NULL;
@@ -3419,76 +3410,12 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 	return rc;
 }
 
-static int smc_create(struct net *net, struct socket *sock, int protocol,
-		      int kern)
-{
-	return __smc_create(net, sock, protocol, kern, NULL);
-}
-
 static const struct net_proto_family smc_sock_family_ops = {
 	.family	= PF_SMC,
 	.owner	= THIS_MODULE,
 	.create	= smc_create,
 };
 
-static int smc_ulp_init(struct sock *sk)
-{
-	struct socket *tcp = sk->sk_socket;
-	struct net *net = sock_net(sk);
-	struct socket *smcsock;
-	int protocol, ret;
-
-	/* only TCP can be replaced */
-	if (tcp->type != SOCK_STREAM || sk->sk_protocol != IPPROTO_TCP ||
-	    (sk->sk_family != AF_INET && sk->sk_family != AF_INET6))
-		return -ESOCKTNOSUPPORT;
-	/* don't handle wq now */
-	if (tcp->state != SS_UNCONNECTED || !tcp->file || tcp->wq.fasync_list)
-		return -ENOTCONN;
-
-	if (sk->sk_family == AF_INET)
-		protocol = SMCPROTO_SMC;
-	else
-		protocol = SMCPROTO_SMC6;
-
-	smcsock = sock_alloc();
-	if (!smcsock)
-		return -ENFILE;
-
-	smcsock->type = SOCK_STREAM;
-	__module_get(THIS_MODULE); /* tried in __tcp_ulp_find_autoload */
-	ret = __smc_create(net, smcsock, protocol, 1, tcp);
-	if (ret) {
-		sock_release(smcsock); /* module_put() which ops won't be NULL */
-		return ret;
-	}
-
-	/* replace tcp socket to smc */
-	smcsock->file = tcp->file;
-	smcsock->file->private_data = smcsock;
-	smcsock->file->f_inode = SOCK_INODE(smcsock); /* replace inode when sock_close */
-	smcsock->file->f_path.dentry->d_inode = SOCK_INODE(smcsock); /* dput() in __fput */
-	tcp->file = NULL;
-
-	return ret;
-}
-
-static void smc_ulp_clone(const struct request_sock *req, struct sock *newsk,
-			  const gfp_t priority)
-{
-	struct inet_connection_sock *icsk = inet_csk(newsk);
-
-	/* don't inherit ulp ops to child when listen */
-	icsk->icsk_ulp_ops = NULL;
-}
-
-static struct tcp_ulp_ops smc_ulp_ops __read_mostly = {
-	.name		= "smc",
-	.owner		= THIS_MODULE,
-	.init		= smc_ulp_init,
-	.clone		= smc_ulp_clone,
-};
-
 unsigned int smc_net_id;
 
 static __net_init int smc_net_init(struct net *net)
@@ -3609,21 +3536,13 @@ static int __init smc_init(void)
 		pr_err("%s: ib_register fails with %d\n", __func__, rc);
 		goto out_sock;
 	}
-
-	rc = tcp_register_ulp(&smc_ulp_ops);
-	if (rc) {
-		pr_err("%s: tcp_ulp_register fails with %d\n", __func__, rc);
-		goto out_ib;
-	}
 	rc = smc_inet_init();
 	if (rc) {
 		pr_err("%s: smc_inet_init fails with %d\n", __func__, rc);
-		goto out_ulp;
+		goto out_ib;
 	}
 	static_branch_enable(&tcp_have_smc);
 	return 0;
-out_ulp:
-	tcp_unregister_ulp(&smc_ulp_ops);
 out_ib:
 	smc_ib_unregister_client();
 out_sock:
@@ -3659,7 +3578,6 @@ static void __exit smc_exit(void)
 {
 	static_branch_disable(&tcp_have_smc);
 	smc_inet_exit();
-	tcp_unregister_ulp(&smc_ulp_ops);
 	sock_unregister(PF_SMC);
 	smc_core_exit();
 	smc_ib_unregister_client();
@@ -3684,7 +3602,6 @@ MODULE_AUTHOR("Ursula Braun <ubraun@linux.vnet.ibm.com>");
 MODULE_DESCRIPTION("smc socket address family");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_SMC);
-MODULE_ALIAS_TCP_ULP("smc");
 /* 256 for IPPROTO_SMC and 1 for SOCK_STREAM */
 MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 256, 1);
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.53.0



