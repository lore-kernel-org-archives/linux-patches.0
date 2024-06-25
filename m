Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BC21482EA;
	Tue, 25 Jun 2024 09:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309083; cv=none; b=eaPVuMKpc7y1GMVGEnJsAVkCazZmju+L6/Bga1kFu8ZsSijo7dtptkiuXo8xdaSUYncTxTxyQHScG1LligIFLa8gVFjAl3EOPQcGD3s2DOho/7Kkp4jqtqbgqkrZ/1GMD4br4ts+/bx+lbkMxbbs9sYsqLjbSF3F1obIuHK6g4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309083; c=relaxed/simple;
	bh=nPxNhsUTwrng1+iYwYhoEdo0K6QlOyBYvA2m5pWAZ90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPgSP3AocCRoNnaJphFki03XX7Xp972f7VF7LP1xEkhbPruGA3W3nn3cE7RXWl9I7zzYCHlfM579v70F6QI8pAsFZVqpyu//jAEgOVpqNENTkUCV9P0ersZS99qe0BVJRjVEd67D6aHWB/MREk+doCajsyIuNn8elF4vVFUOomc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfaELVAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfaELVAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A37AC32781;
	Tue, 25 Jun 2024 09:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309083;
	bh=nPxNhsUTwrng1+iYwYhoEdo0K6QlOyBYvA2m5pWAZ90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfaELVADX1wzGBsQXC3tIll3xe857H+2P8OTe46TY/ZUSEejalnyRP4jekEX6fpiL
	 axUTCLCHSN+MWa1IupE4YnfmoIraLbVYWl2Hm1p+RhFmyDLrk0rVTZrkieUy2WTXs5
	 5TRY2ObbyV/ZAAgFe8Ozkqm8TFjCpIkXwMsFPkWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuang Li <shuali@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/192] sched: act_ct: add netns into the key of tcf_ct_flow_table
Date: Tue, 25 Jun 2024 11:32:42 +0200
Message-ID: <20240625085540.631079541@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 88c67aeb14070bab61d3dd8be96c8b42ebcaf53a ]

zones_ht is a global hashtable for flow_table with zone as key. However,
it does not consider netns when getting a flow_table from zones_ht in
tcf_ct_init(), and it means an act_ct action in netns A may get a
flow_table that belongs to netns B if it has the same zone value.

In Shuang's test with the TOPO:

  tcf2_c <---> tcf2_sw1 <---> tcf2_sw2 <---> tcf2_s

tcf2_sw1 and tcf2_sw2 saw the same flow and used the same flow table,
which caused their ct entries entering unexpected states and the
TCP connection not able to end normally.

This patch fixes the issue simply by adding netns into the key of
tcf_ct_flow_table so that an act_ct action gets a flow_table that
belongs to its own netns in tcf_ct_init().

Note that for easy coding we don't use tcf_ct_flow_table.nf_ft.net,
as the ct_ft is initialized after inserting it to the hashtable in
tcf_ct_flow_table_get() and also it requires to implement several
functions in rhashtable_params including hashfn, obj_hashfn and
obj_cmpfn.

Fixes: 64ff70b80fd4 ("net/sched: act_ct: Offload established connections to flow table")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/1db5b6cc6902c5fc6f8c6cbd85494a2008087be5.1718488050.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index a7b3f60dd0a8d..1bd86868726bf 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -41,21 +41,26 @@ static struct workqueue_struct *act_ct_wq;
 static struct rhashtable zones_ht;
 static DEFINE_MUTEX(zones_mutex);
 
+struct zones_ht_key {
+	struct net *net;
+	u16 zone;
+};
+
 struct tcf_ct_flow_table {
 	struct rhash_head node; /* In zones tables */
 
 	struct rcu_work rwork;
 	struct nf_flowtable nf_ft;
 	refcount_t ref;
-	u16 zone;
+	struct zones_ht_key key;
 
 	bool dying;
 };
 
 static const struct rhashtable_params zones_params = {
 	.head_offset = offsetof(struct tcf_ct_flow_table, node),
-	.key_offset = offsetof(struct tcf_ct_flow_table, zone),
-	.key_len = sizeof_field(struct tcf_ct_flow_table, zone),
+	.key_offset = offsetof(struct tcf_ct_flow_table, key),
+	.key_len = sizeof_field(struct tcf_ct_flow_table, key),
 	.automatic_shrinking = true,
 };
 
@@ -316,11 +321,12 @@ static struct nf_flowtable_type flowtable_ct = {
 
 static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 {
+	struct zones_ht_key key = { .net = net, .zone = params->zone };
 	struct tcf_ct_flow_table *ct_ft;
 	int err = -ENOMEM;
 
 	mutex_lock(&zones_mutex);
-	ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
+	ct_ft = rhashtable_lookup_fast(&zones_ht, &key, zones_params);
 	if (ct_ft && refcount_inc_not_zero(&ct_ft->ref))
 		goto out_unlock;
 
@@ -329,7 +335,7 @@ static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 		goto err_alloc;
 	refcount_set(&ct_ft->ref, 1);
 
-	ct_ft->zone = params->zone;
+	ct_ft->key = key;
 	err = rhashtable_insert_fast(&zones_ht, &ct_ft->node, zones_params);
 	if (err)
 		goto err_insert;
-- 
2.43.0



