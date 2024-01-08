Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5BD52F82;
	Mon,  8 Jan 2024 15:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+Yp+atk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F09C433C9;
	Mon,  8 Jan 2024 15:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728660;
	bh=eqvrGjGMnZ5fM5niaxYUfgpTNwU0ABji7kFZoGD4w6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+Yp+atk0ytaftCr+2FebMbXsMxvZAlKXRymJACdUrP0RP0232UGaC1nnUNqNnEHO
	 p8pGCULihMNLqPBSd0EQnHoL652uvYOWIwdu2KOMTjW4iLBzHDIM65VOT2wlKRTPuV
	 KquJWgR2/8Z2b9qjQiIRPne1v0y64VmkV95oyCiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/150] net: sched: call tcf_ct_params_free to free params in tcf_ct_init
Date: Mon,  8 Jan 2024 16:36:11 +0100
Message-ID: <20240108153516.727089290@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 1913894100ca53205f2d56091cb34b8eba1de217 ]

This patch is to make the err path simple by calling tcf_ct_params_free(),
so that it won't cause problems when more members are added into param and
need freeing on the err path.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 125f1c7f26ff ("net/sched: act_ct: Take per-cb reference to tcf_ct_flow_table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 4c7f7861ea967..478cedc29b737 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -345,11 +345,9 @@ static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
 	module_put(THIS_MODULE);
 }
 
-static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
+static void tcf_ct_flow_table_put(struct tcf_ct_flow_table *ct_ft)
 {
-	struct tcf_ct_flow_table *ct_ft = params->ct_ft;
-
-	if (refcount_dec_and_test(&params->ct_ft->ref)) {
+	if (refcount_dec_and_test(&ct_ft->ref)) {
 		rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
 		INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
 		queue_rcu_work(act_ct_wq, &ct_ft->rwork);
@@ -832,18 +830,23 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 	return err;
 }
 
-static void tcf_ct_params_free(struct rcu_head *head)
+static void tcf_ct_params_free(struct tcf_ct_params *params)
 {
-	struct tcf_ct_params *params = container_of(head,
-						    struct tcf_ct_params, rcu);
-
-	tcf_ct_flow_table_put(params);
-
+	if (params->ct_ft)
+		tcf_ct_flow_table_put(params->ct_ft);
 	if (params->tmpl)
 		nf_ct_put(params->tmpl);
 	kfree(params);
 }
 
+static void tcf_ct_params_free_rcu(struct rcu_head *head)
+{
+	struct tcf_ct_params *params;
+
+	params = container_of(head, struct tcf_ct_params, rcu);
+	tcf_ct_params_free(params);
+}
+
 #if IS_ENABLED(CONFIG_NF_NAT)
 /* Modelled after nf_nat_ipv[46]_fn().
  * range is only used for new, uninitialized NAT state.
@@ -1390,7 +1393,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	err = tcf_ct_flow_table_get(net, params);
 	if (err)
-		goto cleanup_params;
+		goto cleanup;
 
 	spin_lock_bh(&c->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -1401,17 +1404,15 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 	if (params)
-		call_rcu(&params->rcu, tcf_ct_params_free);
+		call_rcu(&params->rcu, tcf_ct_params_free_rcu);
 
 	return res;
 
-cleanup_params:
-	if (params->tmpl)
-		nf_ct_put(params->tmpl);
 cleanup:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-	kfree(params);
+	if (params)
+		tcf_ct_params_free(params);
 	tcf_idr_release(*a, bind);
 	return err;
 }
@@ -1423,7 +1424,7 @@ static void tcf_ct_cleanup(struct tc_action *a)
 
 	params = rcu_dereference_protected(c->params, 1);
 	if (params)
-		call_rcu(&params->rcu, tcf_ct_params_free);
+		call_rcu(&params->rcu, tcf_ct_params_free_rcu);
 }
 
 static int tcf_ct_dump_key_val(struct sk_buff *skb,
-- 
2.43.0



