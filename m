Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758D235A29D;
	Tue, 26 Aug 2025 14:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219466; cv=none; b=BgSy4Ob9AewrY7fdwcns8SfhaTaOCYaJAhVM+dH0LvS/QlJeFNFa556ZxjF1aSTlb0Y19knbmEaCS3H8jlrREiqmA/w8X2s6ZFiLta2usIKrisWcN4Q1YI51kZZKoAa4aCGQh6+/lNu2fVHgeQH4zoH+g8BFS0vMiYa6Gqv132M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219466; c=relaxed/simple;
	bh=DGZdmFNC2BI6h7U0G6V3UmKZ7yLXIuyFYtVPr2+SnTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUH3d/P/tWGP+QSZxrkcpbBlgexQYWz6CF0x4Dv47glZQowwXWg+BJKgG8FC+YLtIOxF3uarBj4uHJBJetkHpYvjpGzIhDjX+CCMnGss7PAN1B0YF4KhoGkT3IGtXmnmHtAUCjJXf1vTLRpWI4vDsnQlQKEXb3rJ8Ulbx593DJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2c5NoQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2c5NoQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070E4C113CF;
	Tue, 26 Aug 2025 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219466;
	bh=DGZdmFNC2BI6h7U0G6V3UmKZ7yLXIuyFYtVPr2+SnTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2c5NoQx0WxYxSnrKPZYlNB1mE6CSbc6tpmopri9LCvZX3J2CKxdOTEVzFRso3WuV
	 mCTvqhJhanoBpzMUO06SMPGg/xKHffQj9YiupLdhzfG9IQV9p0LqeR6vGVzywht4Gw
	 hoaLWGSmRy7OHo5BCQI42qz5c6VCypr1xgY7o45E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@mellanox.com>,
	Jiri Pirko <jiri@mellanox.com>,
	"David S. Miller" <davem@davemloft.net>,
	Shubham Kulkarni <skulkarni@mvista.com>
Subject: [PATCH 5.4 385/403] net: sched: dont expose action qstats to skb_tc_reinsert()
Date: Tue, 26 Aug 2025 13:11:51 +0200
Message-ID: <20250826110917.656579846@linuxfoundation.org>
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

[ Upstream commit ef816f3c49c1c404ababc50e10d4cbe5109da678 ]

Previous commit introduced helper function for updating qstats and
refactored set of actions to use the helpers, instead of modifying qstats
directly. However, one of the affected action exposes its qstats to
skb_tc_reinsert(), which then modifies it.

Refactor skb_tc_reinsert() to return integer error code and don't increment
overlimit qstats in case of error, and use the returned error code in
tcf_mirred_act() to manually increment the overlimit counter with new
helper function.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ skulkarni: Adjusted patch for file 'sch_generic.h' wrt the mainline commit ]
Stable-dep-of: ca22da2fbd69 ("act_mirred: use the backlog for nested calls to mirred ingress")
Signed-off-by: Shubham Kulkarni <skulkarni@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sch_generic.h |   12 ++----------
 net/sched/act_mirred.c    |    4 ++--
 2 files changed, 4 insertions(+), 12 deletions(-)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1320,17 +1320,9 @@ void mini_qdisc_pair_swap(struct mini_Qd
 void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 			  struct mini_Qdisc __rcu **p_miniq);
 
-static inline void skb_tc_reinsert(struct sk_buff *skb, struct tcf_result *res)
+static inline int skb_tc_reinsert(struct sk_buff *skb, struct tcf_result *res)
 {
-	struct gnet_stats_queue *stats = res->qstats;
-	int ret;
-
-	if (res->ingress)
-		ret = netif_receive_skb(skb);
-	else
-		ret = dev_queue_xmit(skb);
-	if (ret && stats)
-		qstats_overlimit_inc(res->qstats);
+	return res->ingress ? netif_receive_skb(skb) : dev_queue_xmit(skb);
 }
 
 /* Make sure qdisc is no longer in SCHED state. */
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -295,8 +295,8 @@ static int tcf_mirred_act(struct sk_buff
 		/* let's the caller reinsert the packet, if possible */
 		if (use_reinsert) {
 			res->ingress = want_ingress;
-			res->qstats = this_cpu_ptr(m->common.cpu_qstats);
-			skb_tc_reinsert(skb, res);
+			if (skb_tc_reinsert(skb, res))
+				tcf_action_inc_overlimit_qstats(&m->common);
 			__this_cpu_dec(mirred_rec_level);
 			return TC_ACT_CONSUMED;
 		}


