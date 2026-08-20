Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C06367B9F;
	Thu, 20 Aug 2026 15:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238616; cv=none; b=SSkr1Ed6R6OMDMTPEFV71fnVDzH+9uxPWjNnEO+2J/E2cpc2BNsnfE2q0J4uWIIT7QZnxIij8qigHu5Jxzkh8O480KdvNPIoc9x9i9Kt+n4JR51DhXtnRHltn7+6MmtrGxosSCUQTa0Hew1i/kDvaX8/sulIigtlk7PfJVtBptc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238616; c=relaxed/simple;
	bh=FJpjMQG6sldfI89L/nNrp0RR0V8v1Yk73lsuUmFhMBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlFm7am0aVZeyhzyeVHmccUFZAazgGYiR2w4jUaZJ27GM/KC7QnZpQr0k9kK9Qhn917knS6VmVYmq3gwpyJMU7CEQtEA9TlC8QGrwNTz9C5RS6lu3+yDvwB9uFoK5xFL7PtBzCipiLVBMlI2EtP6gd8wPS80EpiTG5l1Kmx0pI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERZ7qips; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERZ7qips"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB631F000E9;
	Thu, 20 Aug 2026 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238614;
	bh=hf07U+zye00g3LQe74LkTUQouJOu/cpW2HS8rBfzQwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERZ7qipsUjU8urUvO+8uk0+DV7/po0Uh72iMh5qnMY1PpvW1jIRSHtAsaJdCBh2js
	 f+BGqv5yHPSKcQni9pcJO02HlY+D5yzLapPN2BDGmhQgyKc7IyPWS2Vjny3eMPnw9k
	 sD/AfeyV8Y4aOlThnqHpGizm5rg9thnTFPR6yyi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 209/228] net/sched: act_api: fix TOCTOU NULL deref on a->goto_chain
Date: Thu, 20 Aug 2026 16:55:51 +0200
Message-ID: <20260820145251.377424512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit f60b396ee174206fe08ebf997d16cd3801b77b22 ]

tcf_action_exec() handles TC_ACT_GOTO_CHAIN by first checking
rcu_access_pointer(a->goto_chain) and then calling
tcf_action_goto_chain_exec(), which does a second, independent
rcu_dereference_bh(a->goto_chain) read and immediately dereferences
chain->filter_chain. A concurrent tcf_action_set_ctrlact() (e.g. the gact
replace path) can clear a->goto_chain between the two reads, so the second
read returns NULL and tcf_action_goto_chain_exec() dereferences NULL.

Fix the race by doing a single rcu_dereference_bh() read of a->goto_chain
in tcf_action_exec(), checking it once for NULL, and passing the resulting
chain pointer into tcf_action_goto_chain_exec(). This turns the split
check/use into a single check/use on one value.

Fixes: ee3bbfe806cd ("net/sched: let actions use RCU to access 'goto_chain'")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
Link: https://patch.msgid.link/20260809090928.868186-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index b4a7e1c63cb87..0e131b2475890 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -41,11 +41,9 @@ int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
 }
 EXPORT_SYMBOL_GPL(tcf_dev_queue_xmit);
 
-static void tcf_action_goto_chain_exec(const struct tc_action *a,
+static void tcf_action_goto_chain_exec(const struct tcf_chain *chain,
 				       struct tcf_result *res)
 {
-	const struct tcf_chain *chain = rcu_dereference_bh(a->goto_chain);
-
 	res->goto_tp = rcu_dereference_bh(chain->filter_chain);
 }
 
@@ -1170,12 +1168,14 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 					return TC_ACT_OK;
 			}
 		} else if (TC_ACT_EXT_CMP(ret, TC_ACT_GOTO_CHAIN)) {
-			if (unlikely(!rcu_access_pointer(a->goto_chain))) {
+			struct tcf_chain *chain = rcu_dereference_bh(a->goto_chain);
+
+			if (unlikely(!chain)) {
 				tcf_set_drop_reason(skb,
 						    SKB_DROP_REASON_TC_CHAIN_NOTFOUND);
 				return TC_ACT_SHOT;
 			}
-			tcf_action_goto_chain_exec(a, res);
+			tcf_action_goto_chain_exec(chain, res);
 		}
 
 		if (ret != TC_ACT_PIPE)
-- 
2.53.0



