Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD0835BDDB;
	Wed,  3 Dec 2025 16:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779789; cv=none; b=oVlivN2Ab13zJ3ZEEzrk0R7AC9Ufk0c28agQldrNeM2EL95cyt8xsbS/jYqMSXC3Ptr5fQE2ofv6QEWTZD+eS81QS5qbTqOwbZtj7zpvIPjHFE8Pzj5kSM9c4tJzx7cu7felEsSU602bepBidWWY7kkV3bhnBvl6Q20f/GzUQdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779789; c=relaxed/simple;
	bh=fdXrAGYXAL102LShEElXWEg2mUnxiOp4cyDBmxFlEL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nga30fO6HqOKgMt8xKuy6lZtg5yI7+VcG4VDBXwy6zNAiuFICZJFZR28MB+CvYDW+0AqOd+xBT0KkI1znepJi7L8bJRGqIbjhvMzXcpfbEJBOfNz2q9GLN3swYVVjdXfAASgiLXYz82R2+bth50lDnKl6CiActujl1r+jsyPcdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvfrbTOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvfrbTOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD765C4CEF5;
	Wed,  3 Dec 2025 16:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779789;
	bh=fdXrAGYXAL102LShEElXWEg2mUnxiOp4cyDBmxFlEL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvfrbTOGlGQ48VjuX8o82Tri0bQyN8zYspNF7ZVtVMfRbCzurE/XHwc/o00yGYdF7
	 Xc9PSGUxqmmvlkMbm4qLQDRyxABv7uYClmH7FjUYZ6Ogoon+4Y/P+TkhqJJg+BGEv0
	 ddoo9FE+Nx+rthGHzZTmcV/D0gYwSE2GlFKlFYIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 362/568] net/sched: act_connmark: transition to percpu stats and rcu
Date: Wed,  3 Dec 2025 16:26:04 +0100
Message-ID: <20251203152453.959720194@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 288864effe33885988d53faf7830b35cb9a84c7a ]

The tc action act_connmark was using shared stats and taking the per
action lock in the datapath. Improve it by using percpu stats and rcu.

perf before:
- 13.55% tcf_connmark_act
   - 81.18% _raw_spin_lock
       80.46% native_queued_spin_lock_slowpath

perf after:
- 2.85% tcf_connmark_act

tdc results:
1..15
ok 1 2002 - Add valid connmark action with defaults
ok 2 56a5 - Add valid connmark action with control pass
ok 3 7c66 - Add valid connmark action with control drop
ok 4 a913 - Add valid connmark action with control pipe
ok 5 bdd8 - Add valid connmark action with control reclassify
ok 6 b8be - Add valid connmark action with control continue
ok 7 d8a6 - Add valid connmark action with control jump
ok 8 aae8 - Add valid connmark action with zone argument
ok 9 2f0b - Add valid connmark action with invalid zone argument
ok 10 9305 - Add connmark action with unsupported argument
ok 11 71ca - Add valid connmark action and replace it
ok 12 5f8f - Add valid connmark action with cookie
ok 13 c506 - Replace connmark with invalid goto chain control
ok 14 6571 - Delete connmark action with valid index
ok 15 3426 - Delete connmark action with invalid index

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 62b656e43eae ("net: sched: act_connmark: initialize struct tc_ife to fix kernel leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_connmark.h |   9 ++-
 net/sched/act_connmark.c         | 107 ++++++++++++++++++++-----------
 2 files changed, 75 insertions(+), 41 deletions(-)

diff --git a/include/net/tc_act/tc_connmark.h b/include/net/tc_act/tc_connmark.h
index 1f4cb477bb5d6..e8dd77a967480 100644
--- a/include/net/tc_act/tc_connmark.h
+++ b/include/net/tc_act/tc_connmark.h
@@ -4,10 +4,15 @@
 
 #include <net/act_api.h>
 
-struct tcf_connmark_info {
-	struct tc_action common;
+struct tcf_connmark_parms {
 	struct net *net;
 	u16 zone;
+	struct rcu_head rcu;
+};
+
+struct tcf_connmark_info {
+	struct tc_action common;
+	struct tcf_connmark_parms __rcu *parms;
 };
 
 #define to_connmark(a) ((struct tcf_connmark_info *)a)
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index d41002e4613ff..418d60435b9d4 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -34,13 +34,15 @@ static int tcf_connmark_act(struct sk_buff *skb, const struct tc_action *a,
 	struct nf_conntrack_tuple tuple;
 	enum ip_conntrack_info ctinfo;
 	struct tcf_connmark_info *ca = to_connmark(a);
+	struct tcf_connmark_parms *parms;
 	struct nf_conntrack_zone zone;
 	struct nf_conn *c;
 	int proto;
 
-	spin_lock(&ca->tcf_lock);
 	tcf_lastuse_update(&ca->tcf_tm);
-	bstats_update(&ca->tcf_bstats, skb);
+	tcf_action_update_bstats(&ca->common, skb);
+
+	parms = rcu_dereference_bh(ca->parms);
 
 	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
@@ -62,31 +64,29 @@ static int tcf_connmark_act(struct sk_buff *skb, const struct tc_action *a,
 	c = nf_ct_get(skb, &ctinfo);
 	if (c) {
 		skb->mark = READ_ONCE(c->mark);
-		/* using overlimits stats to count how many packets marked */
-		ca->tcf_qstats.overlimits++;
-		goto out;
+		goto count;
 	}
 
-	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
-			       proto, ca->net, &tuple))
+	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), proto, parms->net,
+			       &tuple))
 		goto out;
 
-	zone.id = ca->zone;
+	zone.id = parms->zone;
 	zone.dir = NF_CT_DEFAULT_ZONE_DIR;
 
-	thash = nf_conntrack_find_get(ca->net, &zone, &tuple);
+	thash = nf_conntrack_find_get(parms->net, &zone, &tuple);
 	if (!thash)
 		goto out;
 
 	c = nf_ct_tuplehash_to_ctrack(thash);
-	/* using overlimits stats to count how many packets marked */
-	ca->tcf_qstats.overlimits++;
 	skb->mark = READ_ONCE(c->mark);
 	nf_ct_put(c);
 
+count:
+	/* using overlimits stats to count how many packets marked */
+	tcf_action_inc_overlimit_qstats(&ca->common);
 out:
-	spin_unlock(&ca->tcf_lock);
-	return ca->tcf_action;
+	return READ_ONCE(ca->tcf_action);
 }
 
 static const struct nla_policy connmark_policy[TCA_CONNMARK_MAX + 1] = {
@@ -99,6 +99,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 			     struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, act_connmark_ops.net_id);
+	struct tcf_connmark_parms *nparms, *oparms;
 	struct nlattr *tb[TCA_CONNMARK_MAX + 1];
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct tcf_chain *goto_ch = NULL;
@@ -118,52 +119,66 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	if (!tb[TCA_CONNMARK_PARMS])
 		return -EINVAL;
 
+	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
+	if (!nparms)
+		return -ENOMEM;
+
 	parm = nla_data(tb[TCA_CONNMARK_PARMS]);
 	index = parm->index;
 	ret = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!ret) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_connmark_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_connmark_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
-			return ret;
+			err = ret;
+			goto out_free;
 		}
 
 		ci = to_connmark(*a);
-		err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch,
-					       extack);
-		if (err < 0)
-			goto release_idr;
-		tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-		ci->net = net;
-		ci->zone = parm->zone;
+
+		nparms->net = net;
+		nparms->zone = parm->zone;
 
 		ret = ACT_P_CREATED;
 	} else if (ret > 0) {
 		ci = to_connmark(*a);
-		if (bind)
-			return 0;
-		if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
-			tcf_idr_release(*a, bind);
-			return -EEXIST;
+		if (bind) {
+			err = 0;
+			goto out_free;
 		}
-		err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch,
-					       extack);
-		if (err < 0)
+		if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
+			err = -EEXIST;
 			goto release_idr;
-		/* replacing action and zone */
-		spin_lock_bh(&ci->tcf_lock);
-		goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
-		ci->zone = parm->zone;
-		spin_unlock_bh(&ci->tcf_lock);
-		if (goto_ch)
-			tcf_chain_put_by_act(goto_ch);
+		}
+
+		nparms->net = rtnl_dereference(ci->parms)->net;
+		nparms->zone = parm->zone;
+
 		ret = 0;
 	}
 
+	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
+	if (err < 0)
+		goto release_idr;
+
+	spin_lock_bh(&ci->tcf_lock);
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	oparms = rcu_replace_pointer(ci->parms, nparms, lockdep_is_held(&ci->tcf_lock));
+	spin_unlock_bh(&ci->tcf_lock);
+
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+
+	if (oparms)
+		kfree_rcu(oparms, rcu);
+
 	return ret;
+
 release_idr:
 	tcf_idr_release(*a, bind);
+out_free:
+	kfree(nparms);
 	return err;
 }
 
@@ -177,11 +192,14 @@ static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
 		.refcnt  = refcount_read(&ci->tcf_refcnt) - ref,
 		.bindcnt = atomic_read(&ci->tcf_bindcnt) - bind,
 	};
+	struct tcf_connmark_parms *parms;
 	struct tcf_t t;
 
 	spin_lock_bh(&ci->tcf_lock);
+	parms = rcu_dereference_protected(ci->parms, lockdep_is_held(&ci->tcf_lock));
+
 	opt.action = ci->tcf_action;
-	opt.zone = ci->zone;
+	opt.zone = parms->zone;
 	if (nla_put(skb, TCA_CONNMARK_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
 
@@ -199,6 +217,16 @@ static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
 	return -1;
 }
 
+static void tcf_connmark_cleanup(struct tc_action *a)
+{
+	struct tcf_connmark_info *ci = to_connmark(a);
+	struct tcf_connmark_parms *parms;
+
+	parms = rcu_dereference_protected(ci->parms, 1);
+	if (parms)
+		kfree_rcu(parms, rcu);
+}
+
 static struct tc_action_ops act_connmark_ops = {
 	.kind		=	"connmark",
 	.id		=	TCA_ID_CONNMARK,
@@ -206,6 +234,7 @@ static struct tc_action_ops act_connmark_ops = {
 	.act		=	tcf_connmark_act,
 	.dump		=	tcf_connmark_dump,
 	.init		=	tcf_connmark_init,
+	.cleanup	=	tcf_connmark_cleanup,
 	.size		=	sizeof(struct tcf_connmark_info),
 };
 
-- 
2.51.0



