Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE231A285;
	Wed,  8 Apr 2026 18:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673840; cv=none; b=Mri9eHVvmmkILv/TxDp9ndEyEzjV2CWWU+KQVK2WHPyRBSTyS6ss35zl/27A+UJy06nkbanSyPUr9W2nn9koz3G3+5cP7iAvytCuTJVBx18aFEyATW5l3aPXX1mfJ0Y/1E8kkPwxIHYLgyST2x4xaLHZKYokPZK3YtWHSIoxcqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673840; c=relaxed/simple;
	bh=Y3tJanjwlzpoynQwjqfwI7ZDMX4JVvA/ajpEtNQx1pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jcl9TcryhFvZhhEQDatJc20RHB9VAXLItivIwvTnj2GHd/2Vcn7mNGElqiwWclGtSrwGBIAAn1teEDnqztN9vIbOtO2SbyW2SHtXWAqXAun8EOZMFUlaRi345xxHTfkKcvfLZiZ+q3DDiAK6cXUyGNsXdoMheHTIi97K7TrG1lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhqNl13S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhqNl13S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846C6C19421;
	Wed,  8 Apr 2026 18:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673839;
	bh=Y3tJanjwlzpoynQwjqfwI7ZDMX4JVvA/ajpEtNQx1pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhqNl13SCFBafLGoXM3liLElf4hKFz3x8lu2yhMvYvRgbk512ob3u2/jMLkq101HY
	 Lyk2OgSDMzNOfdJLSVJLNwwSpFZoz6EgRWtHUnPdxp+myzgKpi/oBp52MJj/WLTPaY
	 cQAuBfdOo5Q034mF+xPa2QjUtUvAPIza3otBvgK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/242] netfilter: ctnetlink: ignore explicit helper on new expectations
Date: Wed,  8 Apr 2026 20:01:57 +0200
Message-ID: <20260408175929.966575933@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 917b61fa2042f11e2af4c428e43f08199586633a ]

Use the existing master conntrack helper, anything else is not really
supported and it just makes validation more complicated, so just ignore
what helper userspace suggests for this expectation.

This was uncovered when validating CTA_EXPECT_CLASS via different helper
provided by userspace than the existing master conntrack helper:

  BUG: KASAN: slab-out-of-bounds in nf_ct_expect_related_report+0x2479/0x27c0
  Read of size 4 at addr ffff8880043fe408 by task poc/102
  Call Trace:
   nf_ct_expect_related_report+0x2479/0x27c0
   ctnetlink_create_expect+0x22b/0x3b0
   ctnetlink_new_expect+0x4bd/0x5c0
   nfnetlink_rcv_msg+0x67a/0x950
   netlink_rcv_skb+0x120/0x350

Allowing to read kernel memory bytes off the expectation boundary.

CTA_EXPECT_HELP_NAME is still used to offer the helper name to userspace
via netlink dump.

Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
Reported-by: Qi Tang <tpluszz77@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 54 +++++-----------------------
 1 file changed, 9 insertions(+), 45 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d262e64f1c152..323e147fe282b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2630,7 +2630,6 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
 
 static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
-		       struct nf_conntrack_helper *helper,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask);
 
@@ -2859,7 +2858,6 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 {
 	struct nlattr *cda[CTA_EXPECT_MAX+1];
 	struct nf_conntrack_tuple tuple, mask;
-	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conntrack_expect *exp;
 	int err;
 
@@ -2873,17 +2871,8 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	if (err < 0)
 		return err;
 
-	if (cda[CTA_EXPECT_HELP_NAME]) {
-		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
-
-		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
-						    nf_ct_protonum(ct));
-		if (helper == NULL)
-			return -EOPNOTSUPP;
-	}
-
 	exp = ctnetlink_alloc_expect((const struct nlattr * const *)cda, ct,
-				     helper, &tuple, &mask);
+				     &tuple, &mask);
 	if (IS_ERR(exp))
 		return PTR_ERR(exp);
 
@@ -3512,11 +3501,11 @@ ctnetlink_parse_expect_nat(const struct nlattr *attr,
 
 static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
-		       struct nf_conntrack_helper *helper,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask)
 {
 	struct net *net = read_pnet(&ct->ct_net);
+	struct nf_conntrack_helper *helper;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn_help *help;
 	u32 class = 0;
@@ -3526,7 +3515,11 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (!help)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	if (cda[CTA_EXPECT_CLASS] && helper) {
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (cda[CTA_EXPECT_CLASS]) {
 		class = ntohl(nla_get_be32(cda[CTA_EXPECT_CLASS]));
 		if (class > helper->expect_class_max)
 			return ERR_PTR(-EINVAL);
@@ -3560,8 +3553,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	exp->zone = ct->zone;
 #endif
-	if (!helper)
-		helper = rcu_dereference(help->helper);
 	rcu_assign_pointer(exp->helper, helper);
 	exp->tuple = *tuple;
 	exp->mask.src.u3 = mask->src.u3;
@@ -3593,7 +3584,6 @@ ctnetlink_create_expect(struct net *net,
 {
 	struct nf_conntrack_tuple tuple, mask, master_tuple;
 	struct nf_conntrack_tuple_hash *h = NULL;
-	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn *ct;
 	int err;
@@ -3619,33 +3609,7 @@ ctnetlink_create_expect(struct net *net,
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	rcu_read_lock();
-	if (cda[CTA_EXPECT_HELP_NAME]) {
-		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
-
-		helper = __nf_conntrack_helper_find(helpname, u3,
-						    nf_ct_protonum(ct));
-		if (helper == NULL) {
-			rcu_read_unlock();
-#ifdef CONFIG_MODULES
-			if (request_module("nfct-helper-%s", helpname) < 0) {
-				err = -EOPNOTSUPP;
-				goto err_ct;
-			}
-			rcu_read_lock();
-			helper = __nf_conntrack_helper_find(helpname, u3,
-							    nf_ct_protonum(ct));
-			if (helper) {
-				err = -EAGAIN;
-				goto err_rcu;
-			}
-			rcu_read_unlock();
-#endif
-			err = -EOPNOTSUPP;
-			goto err_ct;
-		}
-	}
-
-	exp = ctnetlink_alloc_expect(cda, ct, helper, &tuple, &mask);
+	exp = ctnetlink_alloc_expect(cda, ct, &tuple, &mask);
 	if (IS_ERR(exp)) {
 		err = PTR_ERR(exp);
 		goto err_rcu;
@@ -3655,8 +3619,8 @@ ctnetlink_create_expect(struct net *net,
 	nf_ct_expect_put(exp);
 err_rcu:
 	rcu_read_unlock();
-err_ct:
 	nf_ct_put(ct);
+
 	return err;
 }
 
-- 
2.53.0



