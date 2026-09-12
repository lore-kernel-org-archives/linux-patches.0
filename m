Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F7D47DD4E;
	Sat, 12 Sep 2026 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219510; cv=none; b=elJv2qlt8kMR8eTlSeamKaCL33eWoxoA/t7EX9lYiByizBtZJhNEPKNpfJYiK+GBYoqLvmz5OSagAOnU50Z73D6TzK8TDQMX8UYdX/hblWllgH4S9Jh/8+ULRGRFzH23TDlmDbK0fiRkjlu83PBvMIj1PUd3wCCiCtaGARBQS0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219510; c=relaxed/simple;
	bh=f+7QB3fUQ6r0HnZis6WOn1GKje2b0rit1SJSXmMs7Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grJkeWITJ1Lc3kQn0fAj3JvqXrbCqi1RTUnF2fgaQEsNBoUjRJrS253BK1Op0yXhSkHHTV3RT6Y7Cad0lpX1jhJ4mG0fCu/6s2KQUBrzLlmjCB9CwUNrT3WrSyEd+zezMpTddHNLJKVci14ADJKbPbL60jgDzn/Or0E/fNq4BXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyrNOVf1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyrNOVf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52E41F000FF;
	Sat, 12 Sep 2026 13:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219508;
	bh=dNCFnS+YLpK66ZKAAzXQ4vObR2Q3sEFM1B4q+3fQazo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vyrNOVf1BzdDNCwg/rOibYPdlP4Qwxxz3LE4VbhZzC/xavfIWbQ0vW02pqMhzOsDw
	 HVH+ON5vzOS4m0PZk399GzGLGyVrtrVslcbdH6x+GQaStead5jZPr/SAE9DjByMKHE
	 X/Uhw3cQfUYYqGmt8QSZm3oKEGVdW/UsQgdcZQwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1365/1376] net_sched: act_ct: use RCU in tcf_ct_dump()
Date: Sat, 12 Sep 2026 09:03:11 +0200
Message-ID: <20260912065637.955479802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 554e66bad84ce4181ad91a2ae9cc74c7c440e836 ]

Also storing tcf_action into struct tcf_ct_params
makes sure there is no discrepancy in tcf_ct_act().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250709090204.797558-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3016024d7514 ("net_sched: add back BH safety to tcf_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_ct.h |  2 +-
 net/sched/act_ct.c         | 30 +++++++++++++++---------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
index 77f87c622a2ef..c18e7cf22d035 100644
--- a/include/net/tc_act/tc_ct.h
+++ b/include/net/tc_act/tc_ct.h
@@ -13,7 +13,7 @@ struct tcf_ct_params {
 	struct nf_conntrack_helper *helper;
 	struct nf_conn *tmpl;
 	u16 zone;
-
+	int action;
 	u32 mark;
 	u32 mark_mask;
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f735cf9bfd403..8aed25cad9eef 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -994,7 +994,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 
 	p = rcu_dereference_bh(c->params);
 
-	retval = READ_ONCE(c->tcf_action);
+	retval = p->action;
 	commit = p->ct_action & TCA_CT_ACT_COMMIT;
 	clear = p->ct_action & TCA_CT_ACT_CLEAR;
 	tmpl = p->tmpl;
@@ -1443,6 +1443,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (err)
 		goto cleanup;
 
+	params->action = parm->action;
 	spin_lock_bh(&c->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	params = rcu_replace_pointer(c->params, params,
@@ -1476,8 +1477,8 @@ static void tcf_ct_cleanup(struct tc_action *a)
 }
 
 static int tcf_ct_dump_key_val(struct sk_buff *skb,
-			       void *val, int val_type,
-			       void *mask, int mask_type,
+			       const void *val, int val_type,
+			       const void *mask, int mask_type,
 			       int len)
 {
 	int err;
@@ -1498,9 +1499,9 @@ static int tcf_ct_dump_key_val(struct sk_buff *skb,
 	return 0;
 }
 
-static int tcf_ct_dump_nat(struct sk_buff *skb, struct tcf_ct_params *p)
+static int tcf_ct_dump_nat(struct sk_buff *skb, const struct tcf_ct_params *p)
 {
-	struct nf_nat_range2 *range = &p->range;
+	const struct nf_nat_range2 *range = &p->range;
 
 	if (!(p->ct_action & TCA_CT_ACT_NAT))
 		return 0;
@@ -1538,7 +1539,8 @@ static int tcf_ct_dump_nat(struct sk_buff *skb, struct tcf_ct_params *p)
 	return 0;
 }
 
-static int tcf_ct_dump_helper(struct sk_buff *skb, struct nf_conntrack_helper *helper)
+static int tcf_ct_dump_helper(struct sk_buff *skb,
+			      const struct nf_conntrack_helper *helper)
 {
 	if (!helper)
 		return 0;
@@ -1555,9 +1557,8 @@ static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
 			      int bind, int ref)
 {
 	unsigned char *b = skb_tail_pointer(skb);
-	struct tcf_ct *c = to_ct(a);
-	struct tcf_ct_params *p;
-
+	const struct tcf_ct *c = to_ct(a);
+	const struct tcf_ct_params *p;
 	struct tc_ct opt = {
 		.index   = c->tcf_index,
 		.refcnt  = refcount_read(&c->tcf_refcnt) - ref,
@@ -1565,10 +1566,9 @@ static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
 	};
 	struct tcf_t t;
 
-	spin_lock_bh(&c->tcf_lock);
-	p = rcu_dereference_protected(c->params,
-				      lockdep_is_held(&c->tcf_lock));
-	opt.action = c->tcf_action;
+	rcu_read_lock();
+	p = rcu_dereference(c->params);
+	opt.action = p->action;
 
 	if (tcf_ct_dump_key_val(skb,
 				&p->ct_action, TCA_CT_ACTION,
@@ -1613,11 +1613,11 @@ static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
 	tcf_tm_dump(&t, &c->tcf_tm);
 	if (nla_put_64bit(skb, TCA_CT_TM, sizeof(t), &t, TCA_CT_PAD))
 		goto nla_put_failure;
-	spin_unlock_bh(&c->tcf_lock);
+	rcu_read_unlock();
 
 	return skb->len;
 nla_put_failure:
-	spin_unlock_bh(&c->tcf_lock);
+	rcu_read_unlock();
 	nlmsg_trim(skb, b);
 	return -1;
 }
-- 
2.53.0



