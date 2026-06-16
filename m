Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8367835AC1E;
	Tue, 16 Jun 2026 16:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626699; cv=none; b=HKt8x/0XrkXVIWfFkbjxvuULr1CQzDIqzK8Cpat6zXcShPdshL0SQa1u65NRoI37rtlkVDR78WcRREwhVBK4P1j/W1uqjbgJ+0GqtlhmypaI4F4g/IlTDm9XMNB+Yj31Rk5MXStV3d37aFf1tOydQxpb7PhE9eFG7M9ZjEaR9SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626699; c=relaxed/simple;
	bh=CLzp+df0c+LHtZoemPP6IQSkxPolwWJ9o5cyBm1LQXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6/4ovbLbOxqbnO8GlVB7ffXrvT227O14aphW5cvepOxIYjGJiGpD3gF072jdIr9UKFIEOTFSH49178zUKMM963ET5jlvQlRe+AV+60cL0IBbFBZ/9ljQE3jlmIUhFxhRnebDyFAm/JOIUInbWXALa/kckBxq5b+F7nUFJkLaF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mw6pyPy9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mw6pyPy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967671F000E9;
	Tue, 16 Jun 2026 16:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626698;
	bh=AlOvCY2ICeezt5JPs4/O7KjP8XlQ7pjoNVmF7/V3sWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mw6pyPy9LZOeUoXz/hnAXXBTIq8G2aukrrKfpSJcV8/DhN0h9zzAo51IRjGiklzyG
	 qaf8lhb9TCqKROWd7GXwwqfU6siWPnfJROqA7PEoXRiiHZ5UVE8loxDAaEwHn42GWf
	 AuKxQAmI8b5djOqOzFpCGOJBoNNNTl0IAEofRmJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/261] net_sched: act_pedit: use RCU in tcf_pedit_dump()
Date: Tue, 16 Jun 2026 20:28:10 +0530
Message-ID: <20260616145047.561651539@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

[ Upstream commit 9d096746572616a50cac4906f528a1959c0ee1c2 ]

Also storing tcf_action into struct tcf_pedit_params
makes sure there is no discrepancy in tcf_pedit_act().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250709090204.797558-10-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 899ee91156e5 ("net/sched: fix pedit partial COW leading to page cache corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_pedit.h |  1 +
 net/sched/act_pedit.c         | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
index 83fe3993178180..f58ee15cd858cf 100644
--- a/include/net/tc_act/tc_pedit.h
+++ b/include/net/tc_act/tc_pedit.h
@@ -14,6 +14,7 @@ struct tcf_pedit_key_ex {
 struct tcf_pedit_parms {
 	struct tc_pedit_key	*tcfp_keys;
 	struct tcf_pedit_key_ex	*tcfp_keys_ex;
+	int action;
 	u32 tcfp_off_max_hint;
 	unsigned char tcfp_nkeys;
 	unsigned char tcfp_flags;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index fc0a35a7b62ac7..4b65901397a888 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -279,7 +279,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	}
 
 	p = to_pedit(*a);
-
+	nparms->action = parm->action;
 	spin_lock_bh(&p->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	oparms = rcu_replace_pointer(p->parms, nparms, 1);
@@ -483,7 +483,7 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 bad:
 	tcf_action_inc_overlimit_qstats(&p->common);
 done:
-	return p->tcf_action;
+	return parms->action;
 }
 
 static void tcf_pedit_stats_update(struct tc_action *a, u64 bytes, u64 packets,
@@ -500,19 +500,19 @@ static int tcf_pedit_dump(struct sk_buff *skb, struct tc_action *a,
 			  int bind, int ref)
 {
 	unsigned char *b = skb_tail_pointer(skb);
-	struct tcf_pedit *p = to_pedit(a);
-	struct tcf_pedit_parms *parms;
+	const struct tcf_pedit *p = to_pedit(a);
+	const struct tcf_pedit_parms *parms;
 	struct tc_pedit *opt;
 	struct tcf_t t;
 	int s;
 
-	spin_lock_bh(&p->tcf_lock);
-	parms = rcu_dereference_protected(p->parms, 1);
+	rcu_read_lock();
+	parms = rcu_dereference(p->parms);
 	s = struct_size(opt, keys, parms->tcfp_nkeys);
 
 	opt = kzalloc(s, GFP_ATOMIC);
 	if (unlikely(!opt)) {
-		spin_unlock_bh(&p->tcf_lock);
+		rcu_read_unlock();
 		return -ENOBUFS;
 	}
 	opt->nkeys = parms->tcfp_nkeys;
@@ -521,7 +521,7 @@ static int tcf_pedit_dump(struct sk_buff *skb, struct tc_action *a,
 	       flex_array_size(opt, keys, parms->tcfp_nkeys));
 	opt->index = p->tcf_index;
 	opt->flags = parms->tcfp_flags;
-	opt->action = p->tcf_action;
+	opt->action = parms->action;
 	opt->refcnt = refcount_read(&p->tcf_refcnt) - ref;
 	opt->bindcnt = atomic_read(&p->tcf_bindcnt) - bind;
 
@@ -540,13 +540,13 @@ static int tcf_pedit_dump(struct sk_buff *skb, struct tc_action *a,
 	tcf_tm_dump(&t, &p->tcf_tm);
 	if (nla_put_64bit(skb, TCA_PEDIT_TM, sizeof(t), &t, TCA_PEDIT_PAD))
 		goto nla_put_failure;
-	spin_unlock_bh(&p->tcf_lock);
+	rcu_read_unlock();
 
 	kfree(opt);
 	return skb->len;
 
 nla_put_failure:
-	spin_unlock_bh(&p->tcf_lock);
+	rcu_read_unlock();
 	nlmsg_trim(skb, b);
 	kfree(opt);
 	return -1;
-- 
2.53.0



