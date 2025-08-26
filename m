Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5216260586;
	Tue, 26 Aug 2025 14:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219445; cv=none; b=tAXNABwByluaPG9RVPVn+eWLzS6LuX6crTp0/uxietUeP6aLvuEnQm5eNPwWaZqfpGKwjVRTtW71wqu3Uy4pFTLp2HT+cEeOoOdQ3wBJR1DgdQBTlK1Ecy5GAokR+T70DWjU5i7+xm0Wvael+7nXYBAAS8UIYwRpE2mIZHGNtSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219445; c=relaxed/simple;
	bh=KGjXnGspEwswb2xyNCdnd5DpH/aYPy4Pkj+RMv9aYY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTngloBhFcwwl4dC5oWPBLxzfYgnDT3oI3j+MY99jLvT8u+oCtJfmtb/y/JC+WmLHIlOY2lPn2vPNkgK2ThlRbXikd/a2Ber2omjYSmOtF8nNVgWGFuGBJStbi9xSWSqMT2enMXj4qUUC1+9feeQeOtp7CBMcX0PLduEoxvflfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ya48iZ96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ya48iZ96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435C3C4CEF1;
	Tue, 26 Aug 2025 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219445;
	bh=KGjXnGspEwswb2xyNCdnd5DpH/aYPy4Pkj+RMv9aYY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ya48iZ961SYY5xFjzuYUS+LT0RgC+30VqXGVA6SnNNzy6ZyI+pHpof+VUA1NEk+/T
	 867+jUjRZhhp8QxeMT30suLH3IxjeM+ShIbiDR726zI3oPmTxOZXPAF46iNxvHNPtE
	 Tl4nkTWUvpsxFSej5mZSfJ2UHMScPffOTpn9i7mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@mellanox.com>,
	Jiri Pirko <jiri@mellanox.com>,
	"David S. Miller" <davem@davemloft.net>,
	Shubham Kulkarni <skulkarni@mvista.com>
Subject: [PATCH 5.4 383/403] net: sched: extract bstats update code into function
Date: Tue, 26 Aug 2025 13:11:49 +0200
Message-ID: <20250826110917.598400661@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 5e1ad95b630e652d3467d1fd1f0b5e5ea2c441e2 ]

Extract common code that increments cpu_bstats counter into standalone act
API function. Change hardware offloaded actions that use percpu counter
allocation to use the new function instead of incrementing cpu_bstats
directly.

This commit doesn't change functionality.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ca22da2fbd69 ("act_mirred: use the backlog for nested calls to mirred ingress")
Signed-off-by: Shubham Kulkarni <skulkarni@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/act_api.h      |    7 +++++++
 net/sched/act_csum.c       |    2 +-
 net/sched/act_ct.c         |    2 +-
 net/sched/act_gact.c       |    2 +-
 net/sched/act_mirred.c     |    2 +-
 net/sched/act_tunnel_key.c |    2 +-
 net/sched/act_vlan.c       |    2 +-
 7 files changed, 13 insertions(+), 6 deletions(-)

--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -186,6 +186,13 @@ int tcf_action_dump(struct sk_buff *skb,
 		    int ref);
 int tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int, int);
 int tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int, int);
+
+static inline void tcf_action_update_bstats(struct tc_action *a,
+					    struct sk_buff *skb)
+{
+	bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), skb);
+}
+
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
 			     bool drop, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -577,7 +577,7 @@ static int tcf_csum_act(struct sk_buff *
 	params = rcu_dereference_bh(p->params);
 
 	tcf_lastuse_update(&p->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(p->common.cpu_bstats), skb);
+	tcf_action_update_bstats(&p->common, skb);
 
 	action = READ_ONCE(p->tcf_action);
 	if (unlikely(action == TC_ACT_SHOT))
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -482,7 +482,7 @@ out_push:
 	skb_push_rcsum(skb, nh_ofs);
 
 out:
-	bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), skb);
+	tcf_action_update_bstats(&c->common, skb);
 	return retval;
 
 drop:
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -159,7 +159,7 @@ static int tcf_gact_act(struct sk_buff *
 		action = gact_rand[ptype](gact);
 	}
 #endif
-	bstats_cpu_update(this_cpu_ptr(gact->common.cpu_bstats), skb);
+	tcf_action_update_bstats(&gact->common, skb);
 	if (action == TC_ACT_SHOT)
 		qstats_drop_inc(this_cpu_ptr(gact->common.cpu_qstats));
 
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -233,7 +233,7 @@ static int tcf_mirred_act(struct sk_buff
 	}
 
 	tcf_lastuse_update(&m->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(m->common.cpu_bstats), skb);
+	tcf_action_update_bstats(&m->common, skb);
 
 	m_mac_header_xmit = READ_ONCE(m->tcfm_mac_header_xmit);
 	m_eaction = READ_ONCE(m->tcfm_eaction);
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -31,7 +31,7 @@ static int tunnel_key_act(struct sk_buff
 	params = rcu_dereference_bh(t->params);
 
 	tcf_lastuse_update(&t->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(t->common.cpu_bstats), skb);
+	tcf_action_update_bstats(&t->common, skb);
 	action = READ_ONCE(t->tcf_action);
 
 	switch (params->tcft_action) {
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -29,7 +29,7 @@ static int tcf_vlan_act(struct sk_buff *
 	u16 tci;
 
 	tcf_lastuse_update(&v->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(v->common.cpu_bstats), skb);
+	tcf_action_update_bstats(&v->common, skb);
 
 	/* Ensure 'data' points at mac_header prior calling vlan manipulating
 	 * functions.


