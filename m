Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99528477298;
	Sat, 12 Sep 2026 13:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219539; cv=none; b=hswo6Yw4KCylhmqsSvKgJ6ZXrCweP8Q/CO2PoYHgtFfXKfdIwaSuSkvhpEdBOH11aDuzie+rxtW8pEArctjvOF8kvkSzZXtNBg5uF0/ZijbTvfKoHDs5H1Oy+MiADvCqLoEojMh7qGa6FhkhTrWV1wkHqfC6e1L3PNOBTTgvAsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219539; c=relaxed/simple;
	bh=XGc83mNOJxM7mLnG6GJVED9IMeOdrTdUKcnZpIZ87g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Srx8UO4OmQG/zXKbwZXQQ9NpMF32uJcM6dL7p33pNsnba/h0gnZmFzTSp6bR6FRlD994T7bED9uoMvXXyH6ocZhWNLpXXLhx3zcIU+GN1WQh+s6616xJVtsMiYTFxA+wp92EwzQwKpd0l9DNogzntGv6Gy2QHt7VPu4oJGIMvIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMq/j12i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMq/j12i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF191F000FF;
	Sat, 12 Sep 2026 13:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219538;
	bh=35Cr26jsgbfN/uFcpNtTN/jXyP/LJa8gcf91TvIVi+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMq/j12ipwZgqkyKqy9n2ulULQ3qmB1vpqt7yYDHak3173F9ndsQLVytQftb4807V
	 ieFRM5TeOrOjhr86B4sXnurEmlJac4G8t59d9frT31PC7GWN871uBn3/5d8swbyl0I
	 ebMfFMKrqr9RVJ2MoI91Hjw4xf7mQbWg9CGCi6ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1370/1376] net_sched: add back BH safety to tcf_lock
Date: Sat, 12 Sep 2026 09:03:16 +0200
Message-ID: <20260912065638.068092082@linuxfoundation.org>
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

[ Upstream commit 3016024d7514e953cb3a6715ce29799373512eb4 ]

Jamal reported that we had to use BH safety after all,
because stats can be updated from BH handler.

Fixes: 3133d5c15cb5 ("net_sched: remove BH blocking in eight actions")
Fixes: 53df77e78590 ("net_sched: act_skbmod: use RCU in tcf_skbmod_dump()")
Fixes: e97ae742972f ("net_sched: act_tunnel_key: use RCU in tunnel_key_dump()")
Fixes: 48b5e5dbdb23 ("net_sched: act_vlan: use RCU in tcf_vlan_dump()")
Reported-by: Jamal Hadi Salim <jhs@mojatatu.com>
Closes: https://lore.kernel.org/netdev/CAM0EoMmhq66EtVqDEuNik8MVFZqkgxFbMu=fJtbNoYD7YXg4bA@mail.gmail.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20250901092608.2032473-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_skbmod.c     | 4 ++--
 net/sched/act_tunnel_key.c | 4 ++--
 net/sched/act_vlan.c       | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index e0e4019aa9c0b..caa3cdfd2d3dd 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -198,7 +198,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 	p->flags = lflags;
 	p->action = parm->action;
 	if (ovr)
-		spin_lock(&d->tcf_lock);
+		spin_lock_bh(&d->tcf_lock);
 	/* Protected by tcf_lock if overwriting existing action. */
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	p_old = rcu_dereference_protected(d->skbmod_p, 1);
@@ -212,7 +212,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 
 	rcu_assign_pointer(d->skbmod_p, p);
 	if (ovr)
-		spin_unlock(&d->tcf_lock);
+		spin_unlock_bh(&d->tcf_lock);
 
 	if (p_old)
 		kfree_rcu(p_old, rcu);
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index bcb13823165b9..0134def61ddc6 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -537,11 +537,11 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	params_new->tcft_enc_metadata = metadata;
 
 	params_new->action = parm->action;
-	spin_lock(&t->tcf_lock);
+	spin_lock_bh(&t->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	params_new = rcu_replace_pointer(t->params, params_new,
 					 lockdep_is_held(&t->tcf_lock));
-	spin_unlock(&t->tcf_lock);
+	spin_unlock_bh(&t->tcf_lock);
 	tunnel_key_release_params(params_new);
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index b46f980f3b2ae..a74621797d695 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -253,10 +253,10 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	}
 
 	p->action = parm->action;
-	spin_lock(&v->tcf_lock);
+	spin_lock_bh(&v->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	p = rcu_replace_pointer(v->vlan_p, p, lockdep_is_held(&v->tcf_lock));
-	spin_unlock(&v->tcf_lock);
+	spin_unlock_bh(&v->tcf_lock);
 
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-- 
2.53.0



