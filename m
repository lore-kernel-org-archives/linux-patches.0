Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F02F18B0A;
	Wed, 25 Feb 2026 01:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983238; cv=none; b=WM15iCJAjJfh/hVA6Mwq/6jWgW+EMKLHmyC49Al9fOlJ8hnEZ+Y+AAOPszpuj7oIlOqpwv1qfhRoGfHOHethAGxWEO1k0VV4hKA8BCzpGbbLIMrjIaWF4BJO7mpT4Z5N81FzXVlZWOKiFLePA/bQtUk1Hm2mD/rpvoRA2Jv1iPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983238; c=relaxed/simple;
	bh=KhnAnmsGtckcSiIxl2yAeJ7pr417SHzhXMEF4pJEsIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpEBSY3i0NAWmOj+Upj5aad3J99knuT+xpzprvyeYgmszoiD1dc1HtjA3Ckya+UtAlKivyUc2jIImF5VPVqeBebakoM/F40ScRDlvCGtLlnvLRADSeUU3s9VNWdNmL0npw3DOgwGf8XX0PhEMFQQCS4iMTlYFGpu4nhik4ktwyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXaHBWI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXaHBWI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD93C116D0;
	Wed, 25 Feb 2026 01:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983238;
	bh=KhnAnmsGtckcSiIxl2yAeJ7pr417SHzhXMEF4pJEsIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXaHBWI/vaIscoap8aqI9J/u1OBEk2h1gsh0wVq0hhPiggMu2z9FyVN7v2OIGpGK1
	 Mt01nnNr4PtGNtCx0rE9bW210e87OWbCPeP3m+fEYBWfnQ3Br/OupMTA02rClz+YVQ
	 9KMAEltF8sl+YBUmReFqphMQPWeSZtfHArHLGJ8w=
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
Subject: [PATCH 6.19 380/781] Revert "net/smc: Introduce TCP ULP support"
Date: Tue, 24 Feb 2026 17:18:09 -0800
Message-ID: <20260225012409.014608250@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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
index f97f77b041d97..d8201eb3ac5f3 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3357,11 +3357,10 @@ int smc_create_clcsk(struct net *net, struct sock *sk, int family)
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
 
@@ -3380,15 +3379,7 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
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
@@ -3397,76 +3388,12 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
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
@@ -3589,16 +3516,10 @@ static int __init smc_init(void)
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
 	rc = bpf_smc_hs_ctrl_init();
 	if (rc) {
@@ -3610,8 +3531,6 @@ static int __init smc_init(void)
 	return 0;
 out_inet:
 	smc_inet_exit();
-out_ulp:
-	tcp_unregister_ulp(&smc_ulp_ops);
 out_ib:
 	smc_ib_unregister_client();
 out_sock:
@@ -3647,7 +3566,6 @@ static void __exit smc_exit(void)
 {
 	static_branch_disable(&tcp_have_smc);
 	smc_inet_exit();
-	tcp_unregister_ulp(&smc_ulp_ops);
 	sock_unregister(PF_SMC);
 	smc_core_exit();
 	smc_ib_unregister_client();
@@ -3672,7 +3590,6 @@ MODULE_AUTHOR("Ursula Braun <ubraun@linux.vnet.ibm.com>");
 MODULE_DESCRIPTION("smc socket address family");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_SMC);
-MODULE_ALIAS_TCP_ULP("smc");
 /* 256 for IPPROTO_SMC and 1 for SOCK_STREAM */
 MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 256, 1);
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.51.0



