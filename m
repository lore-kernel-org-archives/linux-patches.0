Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40270477298;
	Sat, 12 Sep 2026 13:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219534; cv=none; b=KZrAikITobzkyH53K7Hj4uUgNXaVohhh7opedvgvDDeiGVMq+GuB045xRR44JpIAjEFIw3U+i6X8fIP1TKYsMDR/zFzgm3xBjPwKirEFOPwkRaZr4aNj+2oJVX4AcQCiusZapb+qkggJvilGMEpKI7bGyaklw9VG7h9yeeyAbVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219534; c=relaxed/simple;
	bh=Sj9qJd1gKXXVnXCZwVZJvIR5QTYNCkIPEuJa1zMP6SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzUoP0ki/AHC3qgJr8rskG2OVojbS/gHTau4o9NxpndUNZHE+rOBq72bqiy0Zl+7lE5V+Uhp907JsWZjJ6W88ckxtOKaeHP+dxJQfznN+4BWcVvWh2B/2TSFR6U6PbJ0IT53C/F43W/CmIj02RdcMot85C4z7jz3pocO3n2bxqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iI1A3G+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iI1A3G+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A261F000FF;
	Sat, 12 Sep 2026 13:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219533;
	bh=I0u4+Dtr+eslwInSHG6io3GCqzzP+sz854er/xY4c6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iI1A3G+1N8kqWkWNFPLJten+LvL0/XqykgW6xlMrYocmmsvhtQoCsrn9SqCQfJBFW
	 16xEB9w8rw+J6w4/8hre+zmflUHl0r3sU9vaHy7VNwt32G83DfnKB+nVh1ZQS1DErw
	 LGZzzTWK7fAzORiQdJhs6j3EajpuU+iZp8r2ev50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1369/1376] net_sched: act_tunnel_key: use RCU in tunnel_key_dump()
Date: Sat, 12 Sep 2026 09:03:15 +0200
Message-ID: <20260912065638.044690517@linuxfoundation.org>
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

[ Upstream commit e97ae742972f6cb57986a5ebb846048f80b90003 ]

Also storing tcf_action into struct tcf_tunnel_key_params
makes sure there is no discrepancy in tunnel_key_act().

No longer block BH in tunnel_key_init() when acquiring tcf_lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250827125349.3505302-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3016024d7514 ("net_sched: add back BH safety to tcf_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_tunnel_key.h |  1 +
 net/sched/act_tunnel_key.c         | 20 +++++++++-----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/net/tc_act/tc_tunnel_key.h b/include/net/tc_act/tc_tunnel_key.h
index 879fe8cff5819..0f1925f975202 100644
--- a/include/net/tc_act/tc_tunnel_key.h
+++ b/include/net/tc_act/tc_tunnel_key.h
@@ -14,6 +14,7 @@
 struct tcf_tunnel_key_params {
 	struct rcu_head		rcu;
 	int			tcft_action;
+	int			action;
 	struct metadata_dst     *tcft_enc_metadata;
 };
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index a1ecc2665b107..bcb13823165b9 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -29,13 +29,11 @@ TC_INDIRECT_SCOPE int tunnel_key_act(struct sk_buff *skb,
 {
 	struct tcf_tunnel_key *t = to_tunnel_key(a);
 	struct tcf_tunnel_key_params *params;
-	int action;
 
 	params = rcu_dereference_bh(t->params);
 
 	tcf_lastuse_update(&t->tcf_tm);
 	tcf_action_update_bstats(&t->common, skb);
-	action = READ_ONCE(t->tcf_action);
 
 	switch (params->tcft_action) {
 	case TCA_TUNNEL_KEY_ACT_RELEASE:
@@ -51,7 +49,7 @@ TC_INDIRECT_SCOPE int tunnel_key_act(struct sk_buff *skb,
 		break;
 	}
 
-	return action;
+	return params->action;
 }
 
 static const struct nla_policy
@@ -538,11 +536,12 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	params_new->tcft_action = parm->t_action;
 	params_new->tcft_enc_metadata = metadata;
 
-	spin_lock_bh(&t->tcf_lock);
+	params_new->action = parm->action;
+	spin_lock(&t->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	params_new = rcu_replace_pointer(t->params, params_new,
 					 lockdep_is_held(&t->tcf_lock));
-	spin_unlock_bh(&t->tcf_lock);
+	spin_unlock(&t->tcf_lock);
 	tunnel_key_release_params(params_new);
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
@@ -732,10 +731,9 @@ static int tunnel_key_dump(struct sk_buff *skb, struct tc_action *a,
 	};
 	struct tcf_t tm;
 
-	spin_lock_bh(&t->tcf_lock);
-	params = rcu_dereference_protected(t->params,
-					   lockdep_is_held(&t->tcf_lock));
-	opt.action   = t->tcf_action;
+	rcu_read_lock();
+	params = rcu_dereference(t->params);
+	opt.action   = params->action;
 	opt.t_action = params->tcft_action;
 
 	if (nla_put(skb, TCA_TUNNEL_KEY_PARMS, sizeof(opt), &opt))
@@ -772,12 +770,12 @@ static int tunnel_key_dump(struct sk_buff *skb, struct tc_action *a,
 	if (nla_put_64bit(skb, TCA_TUNNEL_KEY_TM, sizeof(tm),
 			  &tm, TCA_TUNNEL_KEY_PAD))
 		goto nla_put_failure;
-	spin_unlock_bh(&t->tcf_lock);
+	rcu_read_unlock();
 
 	return skb->len;
 
 nla_put_failure:
-	spin_unlock_bh(&t->tcf_lock);
+	rcu_read_unlock();
 	nlmsg_trim(skb, b);
 	return -1;
 }
-- 
2.53.0



