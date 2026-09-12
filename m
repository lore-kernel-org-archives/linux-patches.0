Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BF747CA62;
	Sat, 12 Sep 2026 13:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219249; cv=none; b=M6wOSQJMutQ/AvtLO9l8OjDatMMqX4w+JGbsgKLFKVQ65HUNZcvHx9aDzyJKbxZNTiDe0Lp6WNHUHi2F6HLeDqWVzd8yIDR3Acn616YnQ+x4G9pGVs+rnOH5hNt1TZJcGPJGPb31gR/syuBahvDrJ8D8t0iSWYGo6NCcUs8mkKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219249; c=relaxed/simple;
	bh=btiyc/n5KcUsugVyTK4Zpi7ncmjAEigaHC03Y2BjfUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDCAubIVaAWdT/Q9LLLWS6RZnlFZbb50gJiHYFkF/2T/gLCC9EdkAADI+MgFWZWy1wCKRLmqL6Nr48TuWLoUUDPPDX8fuqVHUEUab49zdVJqR0VOzKp8LyEcHz/6EqOdM6ZcmetNp97dhxDSb4gtl7eG6nqS9EzZRFBlToztHVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdljAmLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdljAmLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27CC1F000FF;
	Sat, 12 Sep 2026 13:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219248;
	bh=R6fi4h8lbpuoNpMN/lb+AuoITp2aGcFWzz7MsANDeqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qdljAmLx6QUvq7X8VDZmBIxlV/pliu4jXgSEfiMAvaC0CjmbRiY4eIIq/4XPAFDDS
	 ZG3jUts0LvniJAbg1EPriRoT3WiW+ouIf06tv3QtFQE+rTpdk5QwWaWnDaua1ZHUlo
	 o4cJVjT4zgeBVE/tadTH5yzpqunglIXDa72K1u4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1295/1376] net_sched: act_skbmod: use RCU in tcf_skbmod_dump()
Date: Sat, 12 Sep 2026 09:02:01 +0200
Message-ID: <20260912065636.397654705@linuxfoundation.org>
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

[ Upstream commit 53df77e7859042a92914d664c860f65d9689f88d ]

Also storing tcf_action into struct tcf_skbmod_params
makes sure there is no discrepancy in tcf_skbmod_act().

No longer block BH in tcf_skbmod_init() when acquiring tcf_lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250827125349.3505302-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 81d0d1e64f30 ("net/sched: act_skbmod: fix length calculations and avoid invalid header warnings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_skbmod.h |  1 +
 net/sched/act_skbmod.c         | 26 ++++++++++++--------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/net/tc_act/tc_skbmod.h b/include/net/tc_act/tc_skbmod.h
index 7c240d2fed4e3..626704cd6241b 100644
--- a/include/net/tc_act/tc_skbmod.h
+++ b/include/net/tc_act/tc_skbmod.h
@@ -12,6 +12,7 @@
 struct tcf_skbmod_params {
 	struct rcu_head	rcu;
 	u64	flags; /*up to 64 types of operations; extend if needed */
+	int	action;
 	u8	eth_dst[ETH_ALEN];
 	u16	eth_type;
 	u8	eth_src[ETH_ALEN];
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index dc02296934618..fce625eafcb2b 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -27,19 +27,18 @@ TC_INDIRECT_SCOPE int tcf_skbmod_act(struct sk_buff *skb,
 				     struct tcf_result *res)
 {
 	struct tcf_skbmod *d = to_skbmod(a);
-	int action, max_edit_len, err;
 	struct tcf_skbmod_params *p;
+	int max_edit_len, err;
 	u64 flags;
 
 	tcf_lastuse_update(&d->tcf_tm);
 	bstats_update(this_cpu_ptr(d->common.cpu_bstats), skb);
 
-	action = READ_ONCE(d->tcf_action);
-	if (unlikely(action == TC_ACT_SHOT))
+	p = rcu_dereference_bh(d->skbmod_p);
+	if (unlikely(p->action == TC_ACT_SHOT))
 		goto drop;
 
 	max_edit_len = skb_mac_header_len(skb);
-	p = rcu_dereference_bh(d->skbmod_p);
 	flags = p->flags;
 
 	/* tcf_skbmod_init() guarantees "flags" to be one of the following:
@@ -85,7 +84,7 @@ TC_INDIRECT_SCOPE int tcf_skbmod_act(struct sk_buff *skb,
 		INET_ECN_set_ce(skb);
 
 out:
-	return action;
+	return p->action;
 
 drop:
 	qstats_overlimit_inc(this_cpu_ptr(d->common.cpu_qstats));
@@ -193,9 +192,9 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 	}
 
 	p->flags = lflags;
-
+	p->action = parm->action;
 	if (ovr)
-		spin_lock_bh(&d->tcf_lock);
+		spin_lock(&d->tcf_lock);
 	/* Protected by tcf_lock if overwriting existing action. */
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	p_old = rcu_dereference_protected(d->skbmod_p, 1);
@@ -209,7 +208,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 
 	rcu_assign_pointer(d->skbmod_p, p);
 	if (ovr)
-		spin_unlock_bh(&d->tcf_lock);
+		spin_unlock(&d->tcf_lock);
 
 	if (p_old)
 		kfree_rcu(p_old, rcu);
@@ -248,10 +247,9 @@ static int tcf_skbmod_dump(struct sk_buff *skb, struct tc_action *a,
 	opt.index   = d->tcf_index;
 	opt.refcnt  = refcount_read(&d->tcf_refcnt) - ref;
 	opt.bindcnt = atomic_read(&d->tcf_bindcnt) - bind;
-	spin_lock_bh(&d->tcf_lock);
-	opt.action = d->tcf_action;
-	p = rcu_dereference_protected(d->skbmod_p,
-				      lockdep_is_held(&d->tcf_lock));
+	rcu_read_lock();
+	p = rcu_dereference(d->skbmod_p);
+	opt.action = p->action;
 	opt.flags  = p->flags;
 	if (nla_put(skb, TCA_SKBMOD_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
@@ -269,10 +267,10 @@ static int tcf_skbmod_dump(struct sk_buff *skb, struct tc_action *a,
 	if (nla_put_64bit(skb, TCA_SKBMOD_TM, sizeof(t), &t, TCA_SKBMOD_PAD))
 		goto nla_put_failure;
 
-	spin_unlock_bh(&d->tcf_lock);
+	rcu_read_unlock();
 	return skb->len;
 nla_put_failure:
-	spin_unlock_bh(&d->tcf_lock);
+	rcu_read_unlock();
 	nlmsg_trim(skb, b);
 	return -1;
 }
-- 
2.53.0



