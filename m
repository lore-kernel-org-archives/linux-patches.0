Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C00369D64;
	Wed, 20 May 2026 16:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294833; cv=none; b=KhjaxwQK13vWsYPQIwH5V+C4SrIKG3oLWRH4akxRQx1ORXMj1zifDGNMHjIs2pjhnwKfaos35Owi0eD0smxCmVmYnx8Dew6Q3A32XyfKcjlYTgcr94Kd6O5aHjIEuyRlwlPuHXzyL8TT+Zz7R+tsM3KJhVLXWVkWN3X7MZppby4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294833; c=relaxed/simple;
	bh=YKD04oPAMQNkqHZ26kX0atEXQ2P008rzhlFpwnQHMRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxuyzAU+PVAmDnDUtfqiXoPFQKU/4yIlYdUEtUgvUowiVUHIJbZ8LbPcGWiNUwSTtvD27EEPscUQzDejtTGDkQVOwa6ezKrNGi+3I8Q8mqe4YBWKy/+HGYb9pnX8YFzl2ydpOoARmgC3A3fAMktotNrLdRTK+/xbO73KtmO1EKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqhhd33M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqhhd33M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882241F00899;
	Wed, 20 May 2026 16:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294832;
	bh=o9MF20V6pEyjjSMFAyOwi9wLbKeT6iZLDLYERmPeex0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqhhd33MMYsrNE5NKzmJ+PLD5VodecI+LnesLUKjw/z4CdLgwB6eD8mcaV2hxxM+A
	 1diDwJ0NwjvCjz+Xu641LGSeWIAMbEmPBqPlf9jGvVhdT3dLjDjjGbdZN2Wcgj4EEt
	 kGgqicRBP8TGEXd/SFZCSKZabY43415JPlRj22zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0189/1146] net/sched: act_ct: Only release RCU read lock after ct_ft
Date: Wed, 20 May 2026 18:07:19 +0200
Message-ID: <20260520162152.552084402@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit f462dca0c8415bf0058d0ffa476354c4476d0f09 ]

When looking up a flow table in act_ct in tcf_ct_flow_table_get(),
rhashtable_lookup_fast() internally opens and closes an RCU read critical
section before returning ct_ft.
The tcf_ct_flow_table_cleanup_work() can complete before refcount_inc_not_zero()
is invoked on the returned ct_ft resulting in a UAF on the already freed ct_ft
object. This vulnerability can lead to privilege escalation.

Analysis from zdi-disclosures@trendmicro.com:
When initializing act_ct, tcf_ct_init() is called, which internally triggers
tcf_ct_flow_table_get().

static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)

{
                struct zones_ht_key key = { .net = net, .zone = params->zone };
                struct tcf_ct_flow_table *ct_ft;
                int err = -ENOMEM;

                mutex_lock(&zones_mutex);
                ct_ft = rhashtable_lookup_fast(&zones_ht, &key, zones_params); // [1]
                if (ct_ft && refcount_inc_not_zero(&ct_ft->ref)) // [2]
                                goto out_unlock;
                ...
}

static __always_inline void *rhashtable_lookup_fast(
                struct rhashtable *ht, const void *key,
                const struct rhashtable_params params)
{
                void *obj;

                rcu_read_lock();
                obj = rhashtable_lookup(ht, key, params);
                rcu_read_unlock();

                return obj;
}

At [1], rhashtable_lookup_fast() looks up and returns the corresponding ct_ft
from zones_ht . The lookup is performed within an RCU read critical section
through rcu_read_lock() / rcu_read_unlock(), which prevents the object from
being freed. However, at the point of function return, rcu_read_unlock() has
already been called, and there is nothing preventing ct_ft from being freed
before reaching refcount_inc_not_zero(&ct_ft->ref) at [2]. This interval becomes
the race window, during which ct_ft can be freed.

Free Process:

tcf_ct_flow_table_put() is executed through the path tcf_ct_cleanup() call_rcu()
tcf_ct_params_free_rcu() tcf_ct_params_free() tcf_ct_flow_table_put().

static void tcf_ct_flow_table_put(struct tcf_ct_flow_table *ct_ft)
{
                if (refcount_dec_and_test(&ct_ft->ref)) {
                                rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
                                INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work); // [3]
                                queue_rcu_work(act_ct_wq, &ct_ft->rwork);
                }
}

At [3], tcf_ct_flow_table_cleanup_work() is scheduled as RCU work

static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)

{
                struct tcf_ct_flow_table *ct_ft;
                struct flow_block *block;

                ct_ft = container_of(to_rcu_work(work), struct tcf_ct_flow_table,
                                                                rwork);
                nf_flow_table_free(&ct_ft->nf_ft);
                block = &ct_ft->nf_ft.flow_block;
                down_write(&ct_ft->nf_ft.flow_block_lock);
                WARN_ON(!list_empty(&block->cb_list));
                up_write(&ct_ft->nf_ft.flow_block_lock);
                kfree(ct_ft); // [4]

                module_put(THIS_MODULE);
}

tcf_ct_flow_table_cleanup_work() frees ct_ft at [4]. When this function executes
between [1] and [2], UAF occurs.

This race condition has a very short race window, making it generally
difficult to trigger. Therefore, to trigger the vulnerability an msleep(100) was
inserted after[1]

Fixes: 138470a9b2cc2 ("net/sched: act_ct: fix lockdep splat in tcf_ct_flow_table_get")
Reported-by: zdi-disclosures@trendmicro.com
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260410111627.46611-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 7d5e50c921a07..6158e13c98d35 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -328,9 +328,13 @@ static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 	int err = -ENOMEM;
 
 	mutex_lock(&zones_mutex);
-	ct_ft = rhashtable_lookup_fast(&zones_ht, &key, zones_params);
-	if (ct_ft && refcount_inc_not_zero(&ct_ft->ref))
+	rcu_read_lock();
+	ct_ft = rhashtable_lookup(&zones_ht, &key, zones_params);
+	if (ct_ft && refcount_inc_not_zero(&ct_ft->ref)) {
+		rcu_read_unlock();
 		goto out_unlock;
+	}
+	rcu_read_unlock();
 
 	ct_ft = kzalloc_obj(*ct_ft);
 	if (!ct_ft)
-- 
2.53.0



