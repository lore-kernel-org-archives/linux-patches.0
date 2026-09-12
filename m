Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C2D47DF8F;
	Sat, 12 Sep 2026 13:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219519; cv=none; b=gQ394CNzUak+u42dUQOTOs03EmQa1Zg+rT4AevOXOYCz1sszuSBsFkEhEcl4Pj5pGe4/8pRmeb417MA0PISXrWZCkjUTm/olyMPt4G5I/HhhOd4i7JvZAYzPqWNjdQ1WJHtH+PRUFLsWAI7UcqfyMLkmPiX8+DYcB9hlfq8N+88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219519; c=relaxed/simple;
	bh=I44yaoVEjkU8xQ3kNFxZ3kqwwF9R40JjKSFKN0qnmZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPIUqcB6++WqFw/9uv2OuupgBIcAz0HwLpKoKVE/+ya9S6DPyyjLBo2xCGWZ/aY9DoCIxrf9YyDr3JIYvibA9GvfGDmb2lU+/VWHWVlQrwL4zFcAmSCTdBJuuZm9H0cR5wS3qslWXoOnyM/OkbttVpDhOlIEvGSsr7V1hB9M16c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRXAQfFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRXAQfFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698F51F000FF;
	Sat, 12 Sep 2026 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219518;
	bh=9Y6VuF3lmsjTwTc7mZ5hhUtHG/khXfghMg6TR1Tu+kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRXAQfFiO5TTROPFzBF3YoEpWlRAzQe/5SLfw/NKCn9B1nN3BoBcrmfQ/+3UGFVUh
	 59psEZoZCIa3500jRwVFAjuxOr6HZdkUK5lM/78WB838VPStcjJyI34nms3NTW32hP
	 BKVqu1DJVHRQllNLPRG1HD7IchHDGGGrGnZngsSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1367/1376] net_sched: act_skbedit: use RCU in tcf_skbedit_dump()
Date: Sat, 12 Sep 2026 09:03:13 +0200
Message-ID: <20260912065638.001049912@linuxfoundation.org>
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

[ Upstream commit 1f376373bd225c90381b745e38fa65a9386f7f8e ]

Also storing tcf_action into struct tcf_skbedit_params
makes sure there is no discrepancy in tcf_skbedit_act().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250709090204.797558-12-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3016024d7514 ("net_sched: add back BH safety to tcf_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_skbedit.h |  1 +
 net/sched/act_skbedit.c         | 20 +++++++++-----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
index 9649600fb3dcc..31b2cd0bebb5b 100644
--- a/include/net/tc_act/tc_skbedit.h
+++ b/include/net/tc_act/tc_skbedit.h
@@ -12,6 +12,7 @@
 #include <linux/tc_act/tc_skbedit.h>
 
 struct tcf_skbedit_params {
+	int action;
 	u32 flags;
 	u32 priority;
 	u32 mark;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 2680196b09d0d..5450c1293eb50 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -43,13 +43,11 @@ TC_INDIRECT_SCOPE int tcf_skbedit_act(struct sk_buff *skb,
 {
 	struct tcf_skbedit *d = to_skbedit(a);
 	struct tcf_skbedit_params *params;
-	int action;
 
 	tcf_lastuse_update(&d->tcf_tm);
 	bstats_update(this_cpu_ptr(d->common.cpu_bstats), skb);
 
 	params = rcu_dereference_bh(d->params);
-	action = READ_ONCE(d->tcf_action);
 
 	if (params->flags & SKBEDIT_F_PRIORITY)
 		skb->priority = params->priority;
@@ -85,7 +83,7 @@ TC_INDIRECT_SCOPE int tcf_skbedit_act(struct sk_buff *skb,
 	}
 	if (params->flags & SKBEDIT_F_PTYPE)
 		skb->pkt_type = params->ptype;
-	return action;
+	return params->action;
 
 err:
 	qstats_drop_inc(this_cpu_ptr(d->common.cpu_qstats));
@@ -266,6 +264,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	if (flags & SKBEDIT_F_MASK)
 		params_new->mask = *mask;
 
+	params_new->action = parm->action;
 	spin_lock_bh(&d->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	params_new = rcu_replace_pointer(d->params, params_new,
@@ -288,9 +287,9 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 static int tcf_skbedit_dump(struct sk_buff *skb, struct tc_action *a,
 			    int bind, int ref)
 {
+	const struct tcf_skbedit *d = to_skbedit(a);
 	unsigned char *b = skb_tail_pointer(skb);
-	struct tcf_skbedit *d = to_skbedit(a);
-	struct tcf_skbedit_params *params;
+	const struct tcf_skbedit_params *params;
 	struct tc_skbedit opt = {
 		.index   = d->tcf_index,
 		.refcnt  = refcount_read(&d->tcf_refcnt) - ref,
@@ -299,10 +298,9 @@ static int tcf_skbedit_dump(struct sk_buff *skb, struct tc_action *a,
 	u64 pure_flags = 0;
 	struct tcf_t t;
 
-	spin_lock_bh(&d->tcf_lock);
-	params = rcu_dereference_protected(d->params,
-					   lockdep_is_held(&d->tcf_lock));
-	opt.action = d->tcf_action;
+	rcu_read_lock();
+	params = rcu_dereference(d->params);
+	opt.action = params->action;
 
 	if (nla_put(skb, TCA_SKBEDIT_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
@@ -337,12 +335,12 @@ static int tcf_skbedit_dump(struct sk_buff *skb, struct tc_action *a,
 	tcf_tm_dump(&t, &d->tcf_tm);
 	if (nla_put_64bit(skb, TCA_SKBEDIT_TM, sizeof(t), &t, TCA_SKBEDIT_PAD))
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



