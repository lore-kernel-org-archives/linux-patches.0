Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714E01EA7E
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82B4C433CA;
	Tue, 25 Jul 2023 10:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282614;
	bh=Z/OlgjhMjiySxS1XlOa4qHMTHonGQiHorUHsOAEB89g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FV0zGm3IRaGxxDMGpe6b2UxPwWCK/dIzFtAzD6iPi8BFCijfmI7pCXebtAEu9a7Ki
	 73m+pBtLH+P+COotnpojZS2QKHfA+fRINaYIkkZlPpT9UgJbYvTvZ0kEwqE3io+VT5
	 xjn4j/uTDL/goQacjIFSe5Iy+10bXPauOwzCm4Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 163/227] net: sched: cls_matchall: Undo tcf_bind_filter in case of failure after mall_set_parms
Date: Tue, 25 Jul 2023 12:45:30 +0200
Message-ID: <20230725104521.669663756@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit b3d0e0489430735e2e7626aa37e6462cdd136e9d ]

In case an error occurred after mall_set_parms executed successfully, we
must undo the tcf_bind_filter call it issues.

Fix that by calling tcf_unbind_filter in err_replace_hw_filter label.

Fixes: ec2507d2a306 ("net/sched: cls_matchall: Fix error path")
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_matchall.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index fa3bbd187eb97..c4ed11df62548 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -159,26 +159,6 @@ static const struct nla_policy mall_policy[TCA_MATCHALL_MAX + 1] = {
 	[TCA_MATCHALL_FLAGS]		= { .type = NLA_U32 },
 };
 
-static int mall_set_parms(struct net *net, struct tcf_proto *tp,
-			  struct cls_mall_head *head,
-			  unsigned long base, struct nlattr **tb,
-			  struct nlattr *est, u32 flags, u32 fl_flags,
-			  struct netlink_ext_ack *extack)
-{
-	int err;
-
-	err = tcf_exts_validate_ex(net, tp, tb, est, &head->exts, flags,
-				   fl_flags, extack);
-	if (err < 0)
-		return err;
-
-	if (tb[TCA_MATCHALL_CLASSID]) {
-		head->res.classid = nla_get_u32(tb[TCA_MATCHALL_CLASSID]);
-		tcf_bind_filter(tp, &head->res, base);
-	}
-	return 0;
-}
-
 static int mall_change(struct net *net, struct sk_buff *in_skb,
 		       struct tcf_proto *tp, unsigned long base,
 		       u32 handle, struct nlattr **tca,
@@ -187,6 +167,7 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 {
 	struct cls_mall_head *head = rtnl_dereference(tp->root);
 	struct nlattr *tb[TCA_MATCHALL_MAX + 1];
+	bool bound_to_filter = false;
 	struct cls_mall_head *new;
 	u32 userflags = 0;
 	int err;
@@ -226,11 +207,17 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 		goto err_alloc_percpu;
 	}
 
-	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE],
-			     flags, new->flags, extack);
-	if (err)
+	err = tcf_exts_validate_ex(net, tp, tb, tca[TCA_RATE],
+				   &new->exts, flags, new->flags, extack);
+	if (err < 0)
 		goto err_set_parms;
 
+	if (tb[TCA_MATCHALL_CLASSID]) {
+		new->res.classid = nla_get_u32(tb[TCA_MATCHALL_CLASSID]);
+		tcf_bind_filter(tp, &new->res, base);
+		bound_to_filter = true;
+	}
+
 	if (!tc_skip_hw(new->flags)) {
 		err = mall_replace_hw_filter(tp, new, (unsigned long)new,
 					     extack);
@@ -246,6 +233,8 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 	return 0;
 
 err_replace_hw_filter:
+	if (bound_to_filter)
+		tcf_unbind_filter(tp, &new->res);
 err_set_parms:
 	free_percpu(new->pf);
 err_alloc_percpu:
-- 
2.39.2



