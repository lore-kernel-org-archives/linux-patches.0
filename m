Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDE31A683C;
	Wed,  8 Apr 2026 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672049; cv=none; b=XVmtHqsDDKc1E2pYRlPEjyQRiu80Xiw4/RHRDsUP/j9xWmsvXnHo0gT8CT8Iks9tKQ3Lc4uL6HqaPMLdlFj5Cg9JVxwz3Z7EAsmq18FpGDW0lr7P4V2j1dGAPMt68ruWROeKyP/V6xSumvGP1aafJ7Ov1uHlbAQBugcQ9YE48+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672049; c=relaxed/simple;
	bh=FNOwV66qg6IDtO7ROG0BCCW/4dR0928KTAF9zin318Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVQkZJ1QtgSQ5dW3GoB8v07D1V7e2VyG25eyEIXx5Kr1EvZ/anKsgrgrxOJQcE4Yyrc7N6acY7CzfPgI2xy3cb9wD46H6SzwevLkDatiUim2+dfRiqhv7mQpWpV+PAQIeps6c8rDtDPyZZvLsKqrmGljg7JY6NKMgXl4cA2anfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04JBsbIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04JBsbIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F42C19421;
	Wed,  8 Apr 2026 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672049;
	bh=FNOwV66qg6IDtO7ROG0BCCW/4dR0928KTAF9zin318Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04JBsbIGQlV4Xjo7exrcZTZe7/n2djt8oasaeItRn2DvOrNHRm4nhTuwzzcl1KeWF
	 HrgjUL5efLOA3GqBJTZO70SuZMJxnxUiOaucSuyZDBXvECdi+BA4SQFPYUza7t2qT0
	 fO00yW53/EGhNlt6WLigT/ADYEI73zy1GyWTM224=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/312] netfilter: nf_conntrack_expect: honor expectation helper field
Date: Wed,  8 Apr 2026 20:01:27 +0200
Message-ID: <20260408175940.114124537@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 9c42bc9db90a154bc61ae337a070465f3393485a ]

The expectation helper field is mostly unused. As a result, the
netfilter codebase relies on accessing the helper through exp->master.

Always set on the expectation helper field so it can be used to reach
the helper.

nf_ct_expect_init() is called from packet path where the skb owns
the ct object, therefore accessing exp->master for the newly created
expectation is safe. This saves a lot of updates in all callsites
to pass the ct object as parameter to nf_ct_expect_init().

This is a preparation patches for follow up fixes.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 917b61fa2042 ("netfilter: ctnetlink: ignore explicit helper on new expectations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_expect.h |  2 +-
 net/netfilter/nf_conntrack_broadcast.c      |  2 +-
 net/netfilter/nf_conntrack_expect.c         | 14 +++++++++++++-
 net/netfilter/nf_conntrack_h323_main.c      | 12 ++++++------
 net/netfilter/nf_conntrack_helper.c         |  7 ++++++-
 net/netfilter/nf_conntrack_netlink.c        |  2 +-
 net/netfilter/nf_conntrack_sip.c            |  2 +-
 7 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 165e7a03b8e9d..1b01400b10bdb 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -40,7 +40,7 @@ struct nf_conntrack_expect {
 			 struct nf_conntrack_expect *this);
 
 	/* Helper to assign to new connection */
-	struct nf_conntrack_helper *helper;
+	struct nf_conntrack_helper __rcu *helper;
 
 	/* The conntrack of the master connection */
 	struct nf_conn *master;
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 9fb9b80312989..721b3e87416be 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -70,7 +70,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->expectfn             = NULL;
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
 	exp->class		  = NF_CT_EXPECT_CLASS_DEFAULT;
-	exp->helper               = NULL;
+	rcu_assign_pointer(exp->helper, helper);
 
 	nf_ct_expect_related(exp, 0);
 	nf_ct_expect_put(exp);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 7bc64eb89bac4..43c6fc0576177 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -309,12 +309,19 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
 
+/* This function can only be used from packet path, where accessing
+ * master's helper is safe, because the packet holds a reference on
+ * the conntrack object. Never use it from control plane.
+ */
 void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 		       u_int8_t family,
 		       const union nf_inet_addr *saddr,
 		       const union nf_inet_addr *daddr,
 		       u_int8_t proto, const __be16 *src, const __be16 *dst)
 {
+	struct nf_conntrack_helper *helper = NULL;
+	struct nf_conn *ct = exp->master;
+	struct nf_conn_help *help;
 	int len;
 
 	if (family == AF_INET)
@@ -325,7 +332,12 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 	exp->flags = 0;
 	exp->class = class;
 	exp->expectfn = NULL;
-	exp->helper = NULL;
+
+	help = nfct_help(ct);
+	if (help)
+		helper = rcu_dereference(help->helper);
+
+	rcu_assign_pointer(exp->helper, helper);
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
 
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index ed983421e2eb2..791aafe9f3960 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -642,7 +642,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	exp->helper = &nf_conntrack_helper_h245;
+	rcu_assign_pointer(exp->helper, &nf_conntrack_helper_h245);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -766,7 +766,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
-	exp->helper = nf_conntrack_helper_q931;
+	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -1233,7 +1233,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 				&ct->tuplehash[!dir].tuple.src.u3 : NULL,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	exp->helper = nf_conntrack_helper_q931;
+	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
 	exp->flags = NF_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
@@ -1305,7 +1305,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_UDP, NULL, &port);
-	exp->helper = nf_conntrack_helper_ras;
+	rcu_assign_pointer(exp->helper, nf_conntrack_helper_ras);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect RAS ");
@@ -1522,7 +1522,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	exp->helper = nf_conntrack_helper_q931;
+	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
@@ -1576,7 +1576,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	exp->helper = nf_conntrack_helper_q931;
+	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 2a15176731fe8..bc66589d2194b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -402,7 +402,7 @@ static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
 	const struct nf_conntrack_helper *me = data;
 	const struct nf_conntrack_helper *this;
 
-	if (exp->helper == me)
+	if (rcu_access_pointer(exp->helper) == me)
 		return true;
 
 	this = rcu_dereference_protected(help->helper,
@@ -424,6 +424,11 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 
 	nf_ct_expect_iterate_destroy(expect_iter_me, me);
 	nf_ct_iterate_destroy(unhelp, me);
+
+	/* nf_ct_iterate_destroy() does an unconditional synchronize_rcu() as
+	 * last step, this ensures rcu readers of exp->helper are done.
+	 * No need for another synchronize_rcu() here.
+	 */
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c5480f952f157..296386c7983f3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3559,7 +3559,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 
 	exp->class = class;
 	exp->master = ct;
-	exp->helper = helper;
+	rcu_assign_pointer(exp->helper, helper);
 	exp->tuple = *tuple;
 	exp->mask.src.u3 = mask->src.u3;
 	exp->mask.src.u.all = mask->src.u.all;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 84334537c6067..6ae30a4cf3601 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1303,7 +1303,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
 			  saddr, &daddr, proto, NULL, &port);
 	exp->timeout.expires = sip_timeout * HZ;
-	exp->helper = helper;
+	rcu_assign_pointer(exp->helper, helper);
 	exp->flags = NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE;
 
 	hooks = rcu_dereference(nf_nat_sip_hooks);
-- 
2.53.0



