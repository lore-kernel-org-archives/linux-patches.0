Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E8863B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F1DC4339C;
	Mon, 20 Feb 2023 13:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901397;
	bh=ibmDf64zmZ+kVCRc5Kd7KaLvZ0pAUQL460Zuqyp9dJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhhKKe4znsXNL9RiR4BBquc78bst1w8IybxrpAZz4oIuhKOtfDOlLKW60Z8YeLf1S
	 UNn49Qfzs7ZaKCqhA99eN/bV0tgWt6of5iFINKvAGd2/8vtykGnsGwhpmsPD3gMzF9
	 rioIWqvwgB+9w6lkLw8a806OOz53BASFMmqzCu/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/57] net/sched: act_ctinfo: use percpu stats
Date: Mon, 20 Feb 2023 14:36:58 +0100
Message-Id: <20230220133551.109125946@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 21c167aa0ba943a7cac2f6969814f83bb701666b ]

The tc action act_ctinfo was using shared stats, fix it to use percpu stats
since bstats_update() must be called with locks or with a percpu pointer argument.

tdc results:
1..12
ok 1 c826 - Add ctinfo action with default setting
ok 2 0286 - Add ctinfo action with dscp
ok 3 4938 - Add ctinfo action with valid cpmark and zone
ok 4 7593 - Add ctinfo action with drop control
ok 5 2961 - Replace ctinfo action zone and action control
ok 6 e567 - Delete ctinfo action with valid index
ok 7 6a91 - Delete ctinfo action with invalid index
ok 8 5232 - List ctinfo actions
ok 9 7702 - Flush ctinfo actions
ok 10 3201 - Add ctinfo action with duplicate index
ok 11 8295 - Add ctinfo action with invalid index
ok 12 3964 - Replace ctinfo action with invalid goto_chain control

Fixes: 24ec483cec98 ("net: sched: Introduce act_ctinfo action")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://lore.kernel.org/r/20230210200824.444856-1-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ctinfo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 9bde94e7bb939..5aa005835c066 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -92,7 +92,7 @@ static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
 	cp = rcu_dereference_bh(ca->params);
 
 	tcf_lastuse_update(&ca->tcf_tm);
-	bstats_update(&ca->tcf_bstats, skb);
+	tcf_action_update_bstats(&ca->common, skb);
 	action = READ_ONCE(ca->tcf_action);
 
 	wlen = skb_network_offset(skb);
@@ -211,8 +211,8 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	index = actparm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_ctinfo_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_ctinfo_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
-- 
2.39.0



