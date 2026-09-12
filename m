Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0F715A85A;
	Sat, 12 Sep 2026 15:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226240; cv=none; b=fPIcdDK8aeR6VtI6Pz8VSX47/HmsdmglIOM8D8Wm7Z3sLq03IXc2TNDkRFDR93ireMj6a+Ye2l8b+2y6pCdprzX9f9AJcKBchf7/UfG9I0Qjttm/d2dxzFW8kxJHV7afmZ1CkJA2awCzM3QV9a5GNQtWdi511DEqHqldrTeu25k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226240; c=relaxed/simple;
	bh=E0GUuK58PmzxTBqPcwDx7KcdoLkbTfm2mknbo8FuPws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUpyk5+fwMgZlNPRXn2B6heJtmXRn27Cz19u0SLYYqA2Z012Q12sdj6u6jGcV0jitk4He+bfl55ZYBm7eJkxadAGXkReSCVm5Spk/hilZk46T/v5P4p8Egikj+AQk+fOb59MIeEv9aH4P2sUyFcprx0xca6J4j+TxtDUkLMH0eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzSiSCA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzSiSCA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59E81F000FF;
	Sat, 12 Sep 2026 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226238;
	bh=frSGzEs4jpoHABjH9Kg10xYFQrAtkm5JdPjmpW+t0sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tzSiSCA3Lo5XyzSLIOK8t2CRJIf+wU+betg7miYGAQZ+cZxMNpE8YvwnkSjuaex4x
	 CrcTJtvcdWlSYcN6FUzFP21opGmS2gGQAh1/1Km1U9smr1EZcu69fEPKL/YFcp5pd6
	 10O/CqToj2UigeMUbJFF14sJ/mdi5HeWk0ZB6j98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1360/1424] net_sched: act_skbmod: use RCU in tcf_skbmod_dump()
Date: Sat, 12 Sep 2026 09:03:12 +0200
Message-ID: <20260912065637.721099003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e34f1be151645..3daeaac17dabe 100644
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



