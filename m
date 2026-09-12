Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ABD42DA55;
	Sat, 12 Sep 2026 08:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202915; cv=none; b=aR7dfVLkKmM5c5p86wDHkU5E7oQkn5FE7r6a5hDMzOGYz732UfLsR0+I6OlVSfjeQJJNb/eWtMMUGfa02BR96/eiIR4uJdE0lCMtUYt/S12ZOUPxqC33es+bbcEBFJF7+PeEJJWoZfm7OGEgholuJ1Wlxa0HEiHZbp/LUybBmhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202915; c=relaxed/simple;
	bh=Q7xZ02PJU3pXR9puSzU3ImOroa2mGLJX/cYl1F8xRoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6mjffqUNM9DXBfB2usvOfG74sgsNH+JrdWDnrwRE5N1Jv/Z2LepdvVoYlrcmZ87enspf6FwRn+dRcmpOMTleCxeYAz1lrz5v6hFIZoXml4ziHILwPsns7tLqCEU8U16H03Mjqxm70B1VIsR0sanyZddWlAh+Fc70gljp4RxdNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjGMcaPI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjGMcaPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24ADA1F000FF;
	Sat, 12 Sep 2026 08:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202913;
	bh=EjkbkD4q5oZFlgHqrk4Kp5efMpNvmV331b3Nn4CPsd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjGMcaPIe4awSw+cYF/W5PSsgosTgcNjjwEPDceuIi1PolEPJLtOWsUnC49NoQItg
	 qm0mseKtauxhzfd2UUpeFtErUcCHhqjU0Yju7jNONwWSD6BfsYEgC1m2jjSiYlBFcm
	 fksD3tNK/hzsce3azqL4x5gnvFw+DOSEBwMFa288=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1301/1815] netfilter: nft_ct: support expectation creation for natted flows
Date: Sat, 12 Sep 2026 08:50:51 +0200
Message-ID: <20260912065719.558916379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d4beefc90a66672e43fdf82b43e4b3c0b1b18c5e ]

This feature only works for connections originating from the host
and only if there no source address rewrite.

Add the needed nat glue to have the expectation follow the original
nat binding.

Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 3679da4ad8be ("netfilter: nft_ct: move custom expectation support to helper")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 03a88c77e0f02..358b9287e12e8 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1297,6 +1297,17 @@ static int nft_ct_expect_obj_dump(struct sk_buff *skb,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+static void nft_ct_nat_follow_master(struct nf_conn *ct, struct nf_conntrack_expect *this)
+{
+	const struct nf_ct_helper_expectfn *expfn;
+
+	expfn = nf_ct_helper_expectfn_find_by_name("nat-follow-master");
+	if (expfn)
+		expfn->expectfn(ct, this);
+}
+#endif
+
 static void nft_ct_expect_obj_eval(struct nft_object *obj,
 				   struct nft_regs *regs,
 				   const struct nft_pktinfo *pkt)
@@ -1342,6 +1353,13 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		          priv->l4proto, NULL, &priv->dport);
 	exp->timeout += priv->timeout;
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+	if (ct->status & IPS_NAT_MASK) {
+		exp->saved_proto.tcp.port = priv->dport;
+		exp->dir = !dir;
+		exp->expectfn = nft_ct_nat_follow_master;
+	}
+#endif
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
 
@@ -1375,6 +1393,13 @@ static struct nft_object_type nft_ct_expect_obj_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+static struct nf_ct_helper_expectfn nft_ct_nat __read_mostly = {
+	.name = "nft_ct-follow-master",
+	.expectfn = nft_ct_nat_follow_master,
+};
+#endif
+
 static int __init nft_ct_module_init(void)
 {
 	int err;
@@ -1400,6 +1425,9 @@ static int __init nft_ct_module_init(void)
 	err = nft_register_obj(&nft_ct_timeout_obj_type);
 	if (err < 0)
 		goto err4;
+#endif
+#if IS_ENABLED(CONFIG_NF_NAT)
+	nf_ct_helper_expectfn_register(&nft_ct_nat);
 #endif
 	return 0;
 
@@ -1425,6 +1453,13 @@ static void __exit nft_ct_module_exit(void)
 	nft_unregister_obj(&nft_ct_helper_obj_type);
 	nft_unregister_expr(&nft_notrack_type);
 	nft_unregister_expr(&nft_ct_type);
+
+#if IS_ENABLED(CONFIG_NF_NAT)
+	nf_ct_helper_expectfn_unregister(&nft_ct_nat);
+	synchronize_rcu();
+	nf_ct_helper_expectfn_destroy(&nft_ct_nat);
+	synchronize_rcu();
+#endif
 }
 
 module_init(nft_ct_module_init);
-- 
2.53.0



