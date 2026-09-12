Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD32147DD4A;
	Sat, 12 Sep 2026 13:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219514; cv=none; b=rDxYkisFInS80exQPw65/95fQihHU0SRaa/TF/zQq1D/VP7qBeBxHZogkqExVQI9P6EETtDnDfpefR+ItoqyNZtUv3oYPdEAqHt7wMVUxg5qjDVmGxaBGUZmMmtmpLOKA7mZcZM1DFBqCDIFlBCnAmFoY5tLo3H36e+cuuBzB74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219514; c=relaxed/simple;
	bh=xaCNiKA6Ent1ndOVpvTV71SKcgyBVURUw7CxZWJmrWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNqMQBjQ8xITnaOWhX+aUQyobykG5tHrYXa5kEQCPgle8djW3rCv+R80UUJTy84djGbxIFxXCT8cjCZNcLhlDXKuj3DV2Si3I9+1Io276XI/yFVAiRFDSHme9xJPmNkGzEJ0Jk3D5aw9fVGj95ZL7w9W7AP8JwBT6jpa05cuG/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5u4XjK+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5u4XjK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C9B1F000FF;
	Sat, 12 Sep 2026 13:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219513;
	bh=bwFV3bcN9QE/lYASh3ooGERazDfXbwK+gFlEDBesdUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5u4XjK+Jd336hyLCI+ttaitTGabqay3tg7XUUQxMbwZ9AlIIia6SFNyIZeNgf9bf
	 MLBfW1VM47lN5ym/eLylYXhkMcIPFZVZuWkNCVpHp29ONAiuyngP2uxxzIxs1Gn/Pq
	 8yjB8pcwAzb/tFISqpP9v56w6PggaGW+ly0aT5zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1366/1376] net_sched: act_ctinfo: use RCU in tcf_ctinfo_dump()
Date: Sat, 12 Sep 2026 09:03:12 +0200
Message-ID: <20260912065637.977897240@linuxfoundation.org>
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

[ Upstream commit 799c94178cf9c9e80575b05b7479396de8b42b61 ]

Also storing tcf_action into struct tcf_ctinfo_params
makes sure there is no discrepancy in tcf_ctinfo_act().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250709090204.797558-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3016024d7514 ("net_sched: add back BH safety to tcf_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_ctinfo.h |  1 +
 net/sched/act_ctinfo.c         | 23 +++++++++++------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/tc_act/tc_ctinfo.h b/include/net/tc_act/tc_ctinfo.h
index a04bcac7adf4b..7fe01ab236da4 100644
--- a/include/net/tc_act/tc_ctinfo.h
+++ b/include/net/tc_act/tc_ctinfo.h
@@ -7,6 +7,7 @@
 struct tcf_ctinfo_params {
 	struct rcu_head rcu;
 	struct net *net;
+	int action;
 	u32 dscpmask;
 	u32 dscpstatemask;
 	u32 cpmarkmask;
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 3a32a8d8a0f83..17abb1d064deb 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -88,13 +88,11 @@ TC_INDIRECT_SCOPE int tcf_ctinfo_act(struct sk_buff *skb,
 	struct tcf_ctinfo_params *cp;
 	struct nf_conn *ct;
 	int proto, wlen;
-	int action;
 
 	cp = rcu_dereference_bh(ca->params);
 
 	tcf_lastuse_update(&ca->tcf_tm);
 	tcf_action_update_bstats(&ca->common, skb);
-	action = READ_ONCE(ca->tcf_action);
 
 	wlen = skb_network_offset(skb);
 	switch (skb_protocol(skb, true)) {
@@ -141,7 +139,7 @@ TC_INDIRECT_SCOPE int tcf_ctinfo_act(struct sk_buff *skb,
 	if (thash)
 		nf_ct_put(ct);
 out:
-	return action;
+	return cp->action;
 }
 
 static const struct nla_policy ctinfo_policy[TCA_CTINFO_MAX + 1] = {
@@ -258,6 +256,8 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 		cp_new->mode |= CTINFO_MODE_CPMARK;
 	}
 
+	cp_new->action = actparm->action;
+
 	spin_lock_bh(&ci->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, actparm->action, goto_ch);
 	cp_new = rcu_replace_pointer(ci->params, cp_new,
@@ -282,25 +282,24 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 static int tcf_ctinfo_dump(struct sk_buff *skb, struct tc_action *a,
 			   int bind, int ref)
 {
-	struct tcf_ctinfo *ci = to_ctinfo(a);
+	const struct tcf_ctinfo *ci = to_ctinfo(a);
+	unsigned char *b = skb_tail_pointer(skb);
+	const struct tcf_ctinfo_params *cp;
 	struct tc_ctinfo opt = {
 		.index   = ci->tcf_index,
 		.refcnt  = refcount_read(&ci->tcf_refcnt) - ref,
 		.bindcnt = atomic_read(&ci->tcf_bindcnt) - bind,
 	};
-	unsigned char *b = skb_tail_pointer(skb);
-	struct tcf_ctinfo_params *cp;
 	struct tcf_t t;
 
-	spin_lock_bh(&ci->tcf_lock);
-	cp = rcu_dereference_protected(ci->params,
-				       lockdep_is_held(&ci->tcf_lock));
+	rcu_read_lock();
+	cp = rcu_dereference(ci->params);
 
 	tcf_tm_dump(&t, &ci->tcf_tm);
 	if (nla_put_64bit(skb, TCA_CTINFO_TM, sizeof(t), &t, TCA_CTINFO_PAD))
 		goto nla_put_failure;
 
-	opt.action = ci->tcf_action;
+	opt.action = cp->action;
 	if (nla_put(skb, TCA_CTINFO_ACT, sizeof(opt), &opt))
 		goto nla_put_failure;
 
@@ -337,11 +336,11 @@ static int tcf_ctinfo_dump(struct sk_buff *skb, struct tc_action *a,
 			      TCA_CTINFO_PAD))
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
2.53.0



