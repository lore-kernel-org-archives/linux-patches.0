Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107E82561AE;
	Wed,  3 Dec 2025 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778121; cv=none; b=mWw3Y2LyTekW9mF8WGJFnUHd+q7EzsHLu/5yvpk1GAwbii8j8Jy15otSwdIOe5Az5a6ABNu5BDB1loBLxSzzZqqiP8ppuFfjw3RQEs7VvK2JkJpQEJvn6kdC/s1hGU0TJUK1bpLSXu+Ijo41DuI6rd064r5dCeghsOPK6WddS2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778121; c=relaxed/simple;
	bh=yPVB/YhVCQc4M/YU7x4I7xwoTJfUU0hXTiqD1D9tVKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjKF28xCW93vOlE0YDz5arSiJ/5+ZEDyRfokd7nRzU4NtRM8bsx8yHv+MLcK+tc8njWNrS3PkIR9G9SnesSRnvhOWS3rDcVMLLgSTspnC22eRTswrIil9wjK9XoiFg8Wyz3MlSQ7rRj5svzYrhpPCnEZt1wKFJZ531KId6/k420=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQY2CM/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQY2CM/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43635C4CEF5;
	Wed,  3 Dec 2025 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778120;
	bh=yPVB/YhVCQc4M/YU7x4I7xwoTJfUU0hXTiqD1D9tVKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQY2CM/TRWA1yy0Up504LLLEbxWLIh7U2E5e3uNZ2ItWVc8qicDiuqR5aDthsa22u
	 /k7oavOWsaj02gainucrI362AnWQ67S7EtyR3owho4ggXTDkn2pKzBlROEr2u9MV4H
	 cD1O8aFqQXnN+/mMQyWuDZ7/+SlAGFB3itczLOPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 250/392] net_sched: act_connmark: use RCU in tcf_connmark_dump()
Date: Wed,  3 Dec 2025 16:26:40 +0100
Message-ID: <20251203152423.370247157@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0d752877705c0252ef2726e4c63c5573f048951c ]

Also storing tcf_action into struct tcf_connmark_parms
makes sure there is no discrepancy in tcf_connmark_act().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250709090204.797558-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 62b656e43eae ("net: sched: act_connmark: initialize struct tc_ife to fix kernel leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_connmark.h |  1 +
 net/sched/act_connmark.c         | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/net/tc_act/tc_connmark.h b/include/net/tc_act/tc_connmark.h
index e8dd77a967480..a5ce83f3eea4b 100644
--- a/include/net/tc_act/tc_connmark.h
+++ b/include/net/tc_act/tc_connmark.h
@@ -7,6 +7,7 @@
 struct tcf_connmark_parms {
 	struct net *net;
 	u16 zone;
+	int action;
 	struct rcu_head rcu;
 };
 
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 418d60435b9d4..79cfe51a09e74 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -86,7 +86,7 @@ static int tcf_connmark_act(struct sk_buff *skb, const struct tc_action *a,
 	/* using overlimits stats to count how many packets marked */
 	tcf_action_inc_overlimit_qstats(&ca->common);
 out:
-	return READ_ONCE(ca->tcf_action);
+	return parms->action;
 }
 
 static const struct nla_policy connmark_policy[TCA_CONNMARK_MAX + 1] = {
@@ -162,6 +162,8 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	if (err < 0)
 		goto release_idr;
 
+	nparms->action = parm->action;
+
 	spin_lock_bh(&ci->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	oparms = rcu_replace_pointer(ci->parms, nparms, lockdep_is_held(&ci->tcf_lock));
@@ -185,20 +187,20 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
 				    int bind, int ref)
 {
+	const struct tcf_connmark_info *ci = to_connmark(a);
 	unsigned char *b = skb_tail_pointer(skb);
-	struct tcf_connmark_info *ci = to_connmark(a);
+	const struct tcf_connmark_parms *parms;
 	struct tc_connmark opt = {
 		.index   = ci->tcf_index,
 		.refcnt  = refcount_read(&ci->tcf_refcnt) - ref,
 		.bindcnt = atomic_read(&ci->tcf_bindcnt) - bind,
 	};
-	struct tcf_connmark_parms *parms;
 	struct tcf_t t;
 
-	spin_lock_bh(&ci->tcf_lock);
-	parms = rcu_dereference_protected(ci->parms, lockdep_is_held(&ci->tcf_lock));
+	rcu_read_lock();
+	parms = rcu_dereference(ci->parms);
 
-	opt.action = ci->tcf_action;
+	opt.action = parms->action;
 	opt.zone = parms->zone;
 	if (nla_put(skb, TCA_CONNMARK_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
@@ -207,12 +209,12 @@ static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
 	if (nla_put_64bit(skb, TCA_CONNMARK_TM, sizeof(t), &t,
 			  TCA_CONNMARK_PAD))
 		goto nla_put_failure;
-	spin_unlock_bh(&ci->tcf_lock);
+	rcu_read_unlock();
 
 	return skb->len;
 
 nla_put_failure:
-	spin_unlock_bh(&ci->tcf_lock);
+	rcu_read_unlock();
 	nlmsg_trim(skb, b);
 	return -1;
 }
-- 
2.51.0



