Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D5038F233;
	Sat, 17 Oct 2026 17:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258849; cv=none; b=L41wzgNAfyILW6ai/xBgt0JyQHqspCj6RRRKpYlLxLKb3lNUsK8oI+gclX1+IxfOrvP56UXzeJimbD40xun44URYV69BJ4vOLoe/pVwwfomXYqVxHA1oAv1oskphtTeMhUFV0A1pASPFrTviYTSNtWx/MmUMv4de/Mxmr93A/Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258849; c=relaxed/simple;
	bh=z3rrJBLaNlfQ7BOkfrSBnbNc4sp7x6p3xl8HnUZaDp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1SROEQmSGL4mMkn0pA4mCXapsFovhcGQPBaAX5XQlXlSiTLk8I53HJn6CpVfnvzIBv5xJMhPGRN3Ao0UX2eCAznT7kGkP1ReSCAl3LWCV3O4lEXZZSOJqHTVYUUiQOQ76ZXTcy/6eMi2POuIftdJDHDA7CYoh7hlBcrkBm3/Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2U3hTVMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2U3hTVMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890111F000C4;
	Sat, 17 Oct 2026 17:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258848;
	bh=m3rrFvj/CNo5pfK9l+v/PPQlu1oB5Hjjlo0aQhIsldg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2U3hTVMe+EEkTEwf/iZU0UXw/D6C5Nzxp5qPkrLaHcfRSYh/Mfmp4CpqyyvmMy+ld
	 JBo1VV3xvqrU9k4nHBK08laRLari7vY4x/IhXMya3TrT+QPS64zBFZQKcJDHci6M7a
	 D+06StPUHgzxBHs/ssfoFYuksdRX80YE2fajK06I=
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
Subject: [PATCH 6.6 0979/1674] Revert "net/smc: Introduce TCP ULP support"
Date: Sat, 17 Oct 2026 17:54:11 +0200
Message-ID: <20261017160456.252359737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/smc/af_smc.c | 90 ++----------------------------------------------
 1 file changed, 3 insertions(+), 87 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index abd5a2589543b..db380048d06bf 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3370,11 +3370,10 @@ int smc_create_clcsk(struct net *net, struct sock *sk, int family)
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
 
@@ -3393,88 +3392,17 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
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
+	rc = smc_create_clcsk(net, sk, family);
 out:
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
@@ -3595,18 +3523,8 @@ static int __init smc_init(void)
 		pr_err("%s: ib_register fails with %d\n", __func__, rc);
 		goto out_sock;
 	}
-
-	rc = tcp_register_ulp(&smc_ulp_ops);
-	if (rc) {
-		pr_err("%s: tcp_ulp_register fails with %d\n", __func__, rc);
-		goto out_ib;
-	}
-
 	static_branch_enable(&tcp_have_smc);
 	return 0;
-
-out_ib:
-	smc_ib_unregister_client();
 out_sock:
 	sock_unregister(PF_SMC);
 out_proto6:
@@ -3639,7 +3557,6 @@ static int __init smc_init(void)
 static void __exit smc_exit(void)
 {
 	static_branch_disable(&tcp_have_smc);
-	tcp_unregister_ulp(&smc_ulp_ops);
 	sock_unregister(PF_SMC);
 	smc_core_exit();
 	smc_ib_unregister_client();
@@ -3664,5 +3581,4 @@ MODULE_AUTHOR("Ursula Braun <ubraun@linux.vnet.ibm.com>");
 MODULE_DESCRIPTION("smc socket address family");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_SMC);
-MODULE_ALIAS_TCP_ULP("smc");
 MODULE_ALIAS_GENL_FAMILY(SMC_GENL_FAMILY_NAME);
-- 
2.53.0



