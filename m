Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1A2329C6D;
	Sat, 30 May 2026 17:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163977; cv=none; b=CXqWn0oVYHCYvongALrDXv6eZlZqBTbTH4P7jIos2D5Fx2aPBto6/f+2ZJpHwRL9772HKD7f6BlHDFWKVCmAxhConTbLrG2xUpqjre7ai0lrRh40sRzyd4edyMk25n5PbQfdcyfPAVsc+xm9zD9MTp+3bpXgQaNO0Qfe2WH9vaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163977; c=relaxed/simple;
	bh=y3Iqx5t2H2mgkwSHA8/yYmgIJJyy9k3klMALzkAhdFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrDf75jgX8TvuLghepKmwpr0Jv8Inggehvc1X9aaTdADTQECCDNpUOZoOxjawDZ5yB6CT5mCFN/9faaUw6ziC3EqKNynpNtpyd7FpKyh2cA3EBC6hU4gKzgmIso+Y7ZrZ1rJFD12Cv87Rb9T7Tdu/b77+Wb08Q51MAeek7X1H1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6K5b1Vv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6K5b1Vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7A21F00893;
	Sat, 30 May 2026 17:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163976;
	bh=+Yp+GKCvALTSlOTlLlLZ2yCVvH/ILErRBld00D/n8/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6K5b1VvdllnlQclQgCe23sQJXasQKRViElsxmEKLjjb/Ql8Tyyu59M9p1dT/L/Cq
	 YEcBTV+pJr2SiYWyv4R7A8pbE/EnXQvTR518E7eEIcFHS6InQ3edue5QeUD7UFgwxC
	 t383nChUkuT7zXJEtWozUbbUjhL66zSfO3CRpbuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/776] net/sched: act_ct: Only release RCU read lock after ct_ft
Date: Sat, 30 May 2026 18:02:12 +0200
Message-ID: <20260530160251.276393257@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 171ebf4594793..1639cc2869ef1 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -290,9 +290,13 @@ static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
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
 
 	ct_ft = kzalloc(sizeof(*ct_ft), GFP_KERNEL);
 	if (!ct_ft)
-- 
2.53.0



