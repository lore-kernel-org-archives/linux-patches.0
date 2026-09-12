Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A22F41F35E;
	Sat, 12 Sep 2026 13:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219524; cv=none; b=f2BLN1Gbnh25XuExQrvhOrlWw3eFUnWqdEnKrkB9aVBKCWxSerWzsfzHbDjHVItyw0+urDYJuADnZn3M9WffBr2C6MpqIgwbyUW2YAe1tdZWOpf8IJBYXLUhM0BFrEADzlX7qwdlpvQEX8Fiq7hFuCiSYqiPFMRpX66Xn4LMoUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219524; c=relaxed/simple;
	bh=IM7UgifAyBmMwD3TYqpJ0jxazPGbY9T3P2FJUo4P6oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7KSoKurTDhrVWQfctj2yq/fs0TGvGl/1Kdzh1FQF//TkC1t0ULuFSJkQ5o36odNUlAtCiJSSuRynANy4nSdi+PnEzJVF7Ji2VZyiAPfq/5Bitg4qNC/pkRjj4QgO6jRMGe1eSyFhZmWfMedgKdqGP3HDIsqcVrqD+ZVPSBEJKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0iNK6MY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0iNK6MY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD641F000FF;
	Sat, 12 Sep 2026 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219523;
	bh=fUaioQUBxCr3zGlQ6udsjSUS1+i1yQoTiSTRoWH6Mxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0iNK6MYP7RqR6GqCxJ8E75BS883KMdE3c8FmFg+V1uEayehYDUZyFnTfRHFDEV73
	 N8wkUpvEJZJCarYXv5Og7NQRqCkjnWldeAKICRskLyW3k1UzGh3EREcpN9Hxt1kj1D
	 u4GDxBrgZ2ogA0VVCI5dC6RTISOh3rmbL0BkgVxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1368/1376] net_sched: act_vlan: use RCU in tcf_vlan_dump()
Date: Sat, 12 Sep 2026 09:03:14 +0200
Message-ID: <20260912065638.022714971@linuxfoundation.org>
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

[ Upstream commit 48b5e5dbdb234ffc951cacceaec7f8ee37c83b2d ]

Also storing tcf_action into struct tcf_vlan_params
makes sure there is no discrepancy in tcf_vlan_act().

No longer block BH in tcf_vlan_init() when acquiring tcf_lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250827125349.3505302-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3016024d7514 ("net_sched: add back BH safety to tcf_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_vlan.h |  1 +
 net/sched/act_vlan.c         | 20 +++++++++-----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/net/tc_act/tc_vlan.h b/include/net/tc_act/tc_vlan.h
index 904eddfc1826f..2e39df2e717b7 100644
--- a/include/net/tc_act/tc_vlan.h
+++ b/include/net/tc_act/tc_vlan.h
@@ -10,6 +10,7 @@
 #include <linux/tc_act/tc_vlan.h>
 
 struct tcf_vlan_params {
+	int		  action;
 	int               tcfv_action;
 	unsigned char     tcfv_push_dst[ETH_ALEN];
 	unsigned char     tcfv_push_src[ETH_ALEN];
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 383bf18b6862f..b46f980f3b2ae 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -25,7 +25,6 @@ TC_INDIRECT_SCOPE int tcf_vlan_act(struct sk_buff *skb,
 {
 	struct tcf_vlan *v = to_vlan(a);
 	struct tcf_vlan_params *p;
-	int action;
 	int err;
 	u16 tci;
 
@@ -38,8 +37,6 @@ TC_INDIRECT_SCOPE int tcf_vlan_act(struct sk_buff *skb,
 	if (skb_at_tc_ingress(skb))
 		skb_push_rcsum(skb, skb->mac_len);
 
-	action = READ_ONCE(v->tcf_action);
-
 	p = rcu_dereference_bh(v->vlan_p);
 
 	switch (p->tcfv_action) {
@@ -97,7 +94,7 @@ TC_INDIRECT_SCOPE int tcf_vlan_act(struct sk_buff *skb,
 		skb_pull_rcsum(skb, skb->mac_len);
 
 	skb_reset_mac_len(skb);
-	return action;
+	return p->action;
 
 drop:
 	tcf_action_inc_drop_qstats(&v->common);
@@ -255,10 +252,11 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 			   ETH_ALEN);
 	}
 
-	spin_lock_bh(&v->tcf_lock);
+	p->action = parm->action;
+	spin_lock(&v->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	p = rcu_replace_pointer(v->vlan_p, p, lockdep_is_held(&v->tcf_lock));
-	spin_unlock_bh(&v->tcf_lock);
+	spin_unlock(&v->tcf_lock);
 
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
@@ -297,9 +295,9 @@ static int tcf_vlan_dump(struct sk_buff *skb, struct tc_action *a,
 	};
 	struct tcf_t t;
 
-	spin_lock_bh(&v->tcf_lock);
-	opt.action = v->tcf_action;
-	p = rcu_dereference_protected(v->vlan_p, lockdep_is_held(&v->tcf_lock));
+	rcu_read_lock();
+	p = rcu_dereference(v->vlan_p);
+	opt.action = p->action;
 	opt.v_action = p->tcfv_action;
 	if (nla_put(skb, TCA_VLAN_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
@@ -325,12 +323,12 @@ static int tcf_vlan_dump(struct sk_buff *skb, struct tc_action *a,
 	tcf_tm_dump(&t, &v->tcf_tm);
 	if (nla_put_64bit(skb, TCA_VLAN_TM, sizeof(t), &t, TCA_VLAN_PAD))
 		goto nla_put_failure;
-	spin_unlock_bh(&v->tcf_lock);
+	rcu_read_unlock();
 
 	return skb->len;
 
 nla_put_failure:
-	spin_unlock_bh(&v->tcf_lock);
+	rcu_read_unlock();
 	nlmsg_trim(skb, b);
 	return -1;
 }
-- 
2.53.0



