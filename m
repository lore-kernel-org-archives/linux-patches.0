Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A64C8E8
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A91EC433C8;
	Mon, 19 Jun 2023 11:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172505;
	bh=uNFocsi7N1RgA8UkLMlt1LvhP0IcPSlFM/ZkoVlt+xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRhKfZ9jqzl8tsIaQ70jaukv7Ta4vsN6asdAD17yHkt4vo26k35m9h4dLR6lR51Bq
	 WXUxe2YSUQUDJyHoo9N/EfpJrsKzPWdTBUxlqlZ4qen+FxK95CvZc32iYGZWy31mDE
	 aQylmZ5bYjRIkMBSLMkYIFz7oUvVGfUjlbMIbp7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingshuai Ren <renmingshuai@huawei.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/107] net/sched: cls_api: Fix lockup on flushing explicitly created chain
Date: Mon, 19 Jun 2023 12:31:17 +0200
Message-ID: <20230619102145.810438590@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit c9a82bec02c339cdda99b37c5e62b3b71fc4209c ]

Mingshuai Ren reports:

When a new chain is added by using tc, one soft lockup alarm will be
 generated after delete the prio 0 filter of the chain. To reproduce
 the problem, perform the following steps:
(1) tc qdisc add dev eth0 root handle 1: htb default 1
(2) tc chain add dev eth0
(3) tc filter del dev eth0 chain 0 parent 1: prio 0
(4) tc filter add dev eth0 chain 0 parent 1:

Fix the issue by accounting for additional reference to chains that are
explicitly created by RTM_NEWCHAIN message as opposed to implicitly by
RTM_NEWTFILTER message.

Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
Reported-by: Mingshuai Ren <renmingshuai@huawei.com>
Closes: https://lore.kernel.org/lkml/87legswvi3.fsf@nvidia.com/T/
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Link: https://lore.kernel.org/r/20230612093426.2867183-1-vladbu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d88a0946301c5..a5864ddfb8902 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -533,8 +533,8 @@ static void __tcf_chain_put(struct tcf_chain *chain, bool by_act,
 {
 	struct tcf_block *block = chain->block;
 	const struct tcf_proto_ops *tmplt_ops;
+	unsigned int refcnt, non_act_refcnt;
 	bool free_block = false;
-	unsigned int refcnt;
 	void *tmplt_priv;
 
 	mutex_lock(&block->lock);
@@ -554,13 +554,15 @@ static void __tcf_chain_put(struct tcf_chain *chain, bool by_act,
 	 * save these to temporary variables.
 	 */
 	refcnt = --chain->refcnt;
+	non_act_refcnt = refcnt - chain->action_refcnt;
 	tmplt_ops = chain->tmplt_ops;
 	tmplt_priv = chain->tmplt_priv;
 
-	/* The last dropped non-action reference will trigger notification. */
-	if (refcnt - chain->action_refcnt == 0 && !by_act) {
-		tc_chain_notify_delete(tmplt_ops, tmplt_priv, chain->index,
-				       block, NULL, 0, 0, false);
+	if (non_act_refcnt == chain->explicitly_created && !by_act) {
+		if (non_act_refcnt == 0)
+			tc_chain_notify_delete(tmplt_ops, tmplt_priv,
+					       chain->index, block, NULL, 0, 0,
+					       false);
 		/* Last reference to chain, no need to lock. */
 		chain->flushing = false;
 	}
-- 
2.39.2



