Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587B734C127;
	Fri, 21 Nov 2025 13:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733268; cv=none; b=ZprLHUD4D5u9Ev1mJxzFeHN+4gbofkNR0jwAQpChsfFKqxfpjQolr6Jhh7ePf+5Uz2JztThWx9Ys/9d+MBEeDPsoI4bziZb/g/MpZAlCXLGqMszGvH3jij09BPzkbn6Shoiz5Dc7fMy+Fr171xlHFh+s6Zd0NBNraoHahIySvyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733268; c=relaxed/simple;
	bh=Vc9x/6HqdmP4qqSGEEeJrMorLFcFeiL31+SU6k8zfhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmS1rW4aTRkOESBeKvkptJFgH2Se2A0Ue5zghcm668QgDdZOL4i3sZA3wmtGeU/rG7G+U/lTHF7EnIqQqjCn915VEcR31BAD/6EgMoCBtMC+Ijq2FsE+UHy5q1aBLjCOMYW81cWewZ6L6meFO/z8u6sbUlmPkZ582mslTFbaTlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5Ot/7Cq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5Ot/7Cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD30C4CEF1;
	Fri, 21 Nov 2025 13:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733266;
	bh=Vc9x/6HqdmP4qqSGEEeJrMorLFcFeiL31+SU6k8zfhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5Ot/7Cq9lsFGzDowQdlvpgWlfI30aGHEoK0gj8I/R8GjxcVYGNq1NPEbrKfYZLmn
	 Js/JjdDw0tWL+DJBr1ny90R1OMnuD9Om5nh7V9anjLZsF060yb1vUbECkHEnvbU/jW
	 HWc+Xf0tLpsvnT970faof7jBSfOc+oytsLX8cIdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 409/529] net_sched: act_connmark: use RCU in tcf_connmark_dump()
Date: Fri, 21 Nov 2025 14:11:48 +0100
Message-ID: <20251121130245.572181753@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 0d7aee8933c5f..31719a113ed31 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -88,7 +88,7 @@ TC_INDIRECT_SCOPE int tcf_connmark_act(struct sk_buff *skb,
 	/* using overlimits stats to count how many packets marked */
 	tcf_action_inc_overlimit_qstats(&ca->common);
 out:
-	return READ_ONCE(ca->tcf_action);
+	return parms->action;
 }
 
 static const struct nla_policy connmark_policy[TCA_CONNMARK_MAX + 1] = {
@@ -167,6 +167,8 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	if (err < 0)
 		goto release_idr;
 
+	nparms->action = parm->action;
+
 	spin_lock_bh(&ci->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	oparms = rcu_replace_pointer(ci->parms, nparms, lockdep_is_held(&ci->tcf_lock));
@@ -190,20 +192,20 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
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
@@ -212,12 +214,12 @@ static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
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



