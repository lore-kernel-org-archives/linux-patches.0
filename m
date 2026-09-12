Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E0F2BCF4C;
	Sat, 12 Sep 2026 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231985; cv=none; b=KeKiBgezRixv10qcB9f4D5U8UUYuuAIDhfh6cXg5OUOHD9UO1KanqTQ1Ue3jAjqPLtU+0BqnkqOBg1OnBL8R64wBWqX0f5TmUgD+aqi12FyfvyL4Vh4Lij5XX5bh/Yr41nxEAsztW3yuSZ4hxOtKlYN24mVM1Nb2CU87KyewUBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231985; c=relaxed/simple;
	bh=4Bm0URaecYLBUmyEak0wu79QGSWoccByboMEAfGYTTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SniLS2/VGBRKQO87gQnKnGfevXhZThrzCDoGr/p+3nbJaEUYBUr76IhLCTXdNdW4WucuxuF7OMY5MdnF4JNKGHgRZoQWRQFb37YOmv83PJiErPyHXT9pZrw/a3pb1gypRvs6uhV6mVg7aU/Ki9k5ftlQ6I+lRYAJ1Aei0dEFLCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEHex3m+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEHex3m+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2061F000FF;
	Sat, 12 Sep 2026 16:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231983;
	bh=5EhFAsg1CHOIg4Mn1p29OnBFcsH4gXddTH/meBlduns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEHex3m+z0iPumJ/BUkEQwOHfCDV+Gfdg6Q55VRCYtd5N7iEm6Tm8IwzmNHlDO1XP
	 KKy5SkEaEQFVQA0ubhjh7Q5IFR9u/3RE+CuEeRd9/M9IWHqdgN9Qox20CL6x41O82o
	 zu8/Sp5qE/pstgtlTC6Q019m8pTm/YF75czEouRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1103/1191] net_sched: act_skbmod: use RCU in tcf_skbmod_dump()
Date: Sat, 12 Sep 2026 09:03:51 +0200
Message-ID: <20260912065612.927930999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 744ff9729469e..94a18d029b28a 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -25,19 +25,18 @@ static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
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
@@ -83,7 +82,7 @@ static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
 		INET_ECN_set_ce(skb);
 
 out:
-	return action;
+	return p->action;
 
 drop:
 	qstats_overlimit_inc(this_cpu_ptr(d->common.cpu_qstats));
@@ -191,9 +190,9 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
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
@@ -207,7 +206,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 
 	rcu_assign_pointer(d->skbmod_p, p);
 	if (ovr)
-		spin_unlock_bh(&d->tcf_lock);
+		spin_unlock(&d->tcf_lock);
 
 	if (p_old)
 		kfree_rcu(p_old, rcu);
@@ -246,10 +245,9 @@ static int tcf_skbmod_dump(struct sk_buff *skb, struct tc_action *a,
 	opt.index   = d->tcf_index;
 	opt.refcnt  = refcount_read(&d->tcf_refcnt) - ref,
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
@@ -267,10 +265,10 @@ static int tcf_skbmod_dump(struct sk_buff *skb, struct tc_action *a,
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



