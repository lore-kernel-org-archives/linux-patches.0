Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC59377A97;
	Sat, 17 Oct 2026 16:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254004; cv=none; b=tNq44vTHv3XCvRZYEd3KBocORs7AF1Lc7OzNB91obZs1e3ELAOcyEe7k7JakXzsr88hqLhgs8HQXLr7e8M3EbuO1JBC9ycVgh+N1LxQvSwM53zqaR40FILbOhgWvD+F5lHVqDfDnMizhXaQrWEOiZF8SfVX5nDnmk0b1WO6RTs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254004; c=relaxed/simple;
	bh=gkEP3K90O7nqdjYwgzLINYpwu+R9adT9oiVF5xfrmhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKzkpSU4cHdLUrIaLuIY3xLMKI3Ki67S6Ft3cP9jfF6Nyqon1+/A07TagKgeREoPhgQL5K7+xK6foN3P1qkwaFOHbOTjCAesjmD1pQa9Hd+sFvs4k0hGNIwnTMOUp5sfMk5t4E88gtmgf/ZWIdRsLRvFTg5BGDFNHAGEA64yaoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+5Mf2WK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+5Mf2WK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D192C1F000C4;
	Sat, 17 Oct 2026 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254003;
	bh=cFGfVmmhXxrOEdmqX8yqIWCYkikZdcPYQocqJVwehcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+5Mf2WKwZCi8Nqx79E8eLE7masISC3810GokAokeHmIpdiMVjHGRDkGRmD2rzt00
	 MYPXouJBJcIwOsWGCRAboUf2K3gUYG0FfR23f3+zL+5EP6whgxnrhyK2/iAV0l7L86
	 A9szNH1Q8X6/0Uh1WVCp9uhot1W3SQtCq7v5lahU=
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
Subject: [PATCH 6.12 305/869] Revert "net/smc: Introduce TCP ULP support"
Date: Sat, 17 Oct 2026 17:52:26 +0200
Message-ID: <20261017160044.894456161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 net/smc/af_smc.c | 90 +++---------------------------------------------
 1 file changed, 4 insertions(+), 86 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 17ce4d32f64f2..6f8c9b79e7bfb 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3380,11 +3380,10 @@ int smc_create_clcsk(struct net *net, struct sock *sk, int family)
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
 
@@ -3403,15 +3402,7 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
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
@@ -3420,76 +3411,12 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
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
@@ -3617,20 +3544,13 @@ static int __init smc_init(void)
 		goto out_ib;
 	}
 
-	rc = tcp_register_ulp(&smc_ulp_ops);
-	if (rc) {
-		pr_err("%s: tcp_ulp_register fails with %d\n", __func__, rc);
-		goto out_lo;
-	}
 	rc = smc_inet_init();
 	if (rc) {
 		pr_err("%s: smc_inet_init fails with %d\n", __func__, rc);
-		goto out_ulp;
+		goto out_lo;
 	}
 	static_branch_enable(&tcp_have_smc);
 	return 0;
-out_ulp:
-	tcp_unregister_ulp(&smc_ulp_ops);
 out_lo:
 	smc_loopback_exit();
 out_ib:
@@ -3668,7 +3588,6 @@ static void __exit smc_exit(void)
 {
 	static_branch_disable(&tcp_have_smc);
 	smc_inet_exit();
-	tcp_unregister_ulp(&smc_ulp_ops);
 	sock_unregister(PF_SMC);
 	smc_core_exit();
 	smc_loopback_exit();
@@ -3694,7 +3613,6 @@ MODULE_AUTHOR("Ursula Braun <ubraun@linux.vnet.ibm.com>");
 MODULE_DESCRIPTION("smc socket address family");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_SMC);
-MODULE_ALIAS_TCP_ULP("smc");
 /* 256 for IPPROTO_SMC and 1 for SOCK_STREAM */
 MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 256, 1);
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.53.0



