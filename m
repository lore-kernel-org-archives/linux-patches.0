Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3E639A7FD;
	Tue, 21 Jul 2026 19:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661120; cv=none; b=NIrG6mbQ7Fo5JVTedJcBw8GKVfty58Ux2jkC2bAY0HXvCWvnXQA/DNiLK8mFKiNfAaeOupt7asMUQp8TPBAXO7NKnP0PQFaq3fCeK71077Tp1RgdovB/P1iKykuPgBqKQ2XYRlsPfHASSQB7fhd0LKxwyHvdzg3Dv7gKPpGSLDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661120; c=relaxed/simple;
	bh=Nbusi7K/bX4nke0Gv4zZ3iDMAyXY75hNvPuXVZc0ZLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3FJY4N4qxX58aG5HYBBS+F3ww5HdNutnsVA26BqT6Cb+Oon4CJUpzyikZXFCcLjznM773zEXUktPZ4OhdawymCj7sGt3Hbi0mfHlMCwBRqXtFvawLH6I6J91D7sEWrvwc0LPzKV6BzJ+uG1FR28TGIEwwLCgnnqAaFZGEl9PCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqJ50VxP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqJ50VxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9C11F000E9;
	Tue, 21 Jul 2026 19:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661119;
	bh=BkdDjfd7sn+MxsOj0zPT3Ks+nNaIs/wYr2fpNllEK8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqJ50VxPM13seak0rCpWqeO9bGAXBhZiftrTsyOaPvFbOf0tIdMEhIjrXLAD0djYf
	 QP8ARUWjrhsE4bxOBTVq43RYT/LF1/l038XGzNRsIv1THz+8JgPc+Onl0jNc48aaex
	 uI4O24RJjkG/sql9WpNeWyLI2I0Bu5WQVMi7eQ6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1236/2077] netfilter: nf_conntrack_expect: store master_tuple in expectation
Date: Tue, 21 Jul 2026 17:15:09 +0200
Message-ID: <20260721152621.965499988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 979c13114c0bb6ab9135e2c93e00c79c412aef09 ]

Store master conntrack tuple in the expectation since exp->master might
refer to a different conntrack when accessed from rcu read side lock
area due to typesafe rcu rules.

Fixes: 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_expect.h |  1 +
 net/netfilter/nf_conntrack_broadcast.c      |  1 +
 net/netfilter/nf_conntrack_expect.c         |  2 ++
 net/netfilter/nf_conntrack_netlink.c        | 10 ++++------
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index be4a120d549eb3..c024345c9bd862 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -26,6 +26,7 @@ struct nf_conntrack_expect {
 	possible_net_t net;
 
 	/* We expect this tuple, with the following mask */
+	struct nf_conntrack_tuple master_tuple;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_mask mask;
 
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 400119b6320e72..bf78828c7549d4 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -62,6 +62,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	if (exp == NULL)
 		goto out;
 
+	exp->master_tuple	  = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
 	exp->tuple                = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 
 	helper = rcu_dereference(help->helper);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 49e18eda037ef1..9454913e1b337e 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -355,6 +355,8 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
 
+	exp->master_tuple = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+
 	if (saddr) {
 		memcpy(&exp->tuple.src.u3, saddr, len);
 		if (sizeof(exp->tuple.src.u3) > len)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 211f361188f189..b11b8b7f31aaa7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3007,7 +3007,6 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
 {
 	__s32 timeout = (__s32)(READ_ONCE(exp->timeout) - nfct_time_stamp) / HZ;
-	struct nf_conn *master = exp->master;
 	struct nf_conntrack_helper *helper;
 #if IS_ENABLED(CONFIG_NF_NAT)
 	struct nlattr *nest_parms;
@@ -3022,9 +3021,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (ctnetlink_exp_dump_mask(skb, &exp->tuple, &exp->mask) < 0)
 		goto nla_put_failure;
-	if (ctnetlink_exp_dump_tuple(skb,
-				 &master->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-				 CTA_EXPECT_MASTER) < 0)
+	if (ctnetlink_exp_dump_tuple(skb, &exp->master_tuple, CTA_EXPECT_MASTER) < 0)
 		goto nla_put_failure;
 
 #if IS_ENABLED(CONFIG_NF_NAT)
@@ -3037,9 +3034,9 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 		if (nla_put_be32(skb, CTA_EXPECT_NAT_DIR, htonl(exp->dir)))
 			goto nla_put_failure;
 
-		nat_tuple.src.l3num = nf_ct_l3num(master);
+		nat_tuple.src.l3num = exp->master_tuple.src.l3num;
 		nat_tuple.src.u3 = exp->saved_addr;
-		nat_tuple.dst.protonum = nf_ct_protonum(master);
+		nat_tuple.dst.protonum = exp->master_tuple.dst.protonum;
 		nat_tuple.src.u = exp->saved_proto;
 
 		if (ctnetlink_exp_dump_tuple(skb, &nat_tuple,
@@ -3581,6 +3578,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 #endif
 	rcu_assign_pointer(exp->helper, helper);
 	rcu_assign_pointer(exp->assign_helper, assign_helper);
+	exp->master_tuple = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
 	exp->tuple = *tuple;
 	exp->mask.src.u3 = mask->src.u3;
 	exp->mask.src.u.all = mask->src.u.all;
-- 
2.53.0



