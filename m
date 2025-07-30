Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE322989A2;
	Wed, 30 Jul 2025 09:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868632; cv=none; b=QeKgrm2ME7PcfNQDZAzSd6V1D5G/h2cGU9w5zy6azqwgGzVOKgcqF6ZKTdgHtTHy929qz5agnayn9hbiyU/2j/uK01cv9Vb/4832WmIGcqM4tVPwZZWQsZcSqpJOCqJF1GKsEMvniECpHXu46SuTPHPig1XPnfImncVxsoYeQtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868632; c=relaxed/simple;
	bh=OqlUrox7py4+xPWPGf46JQIkjDhGhzK3tASvJcDirmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXX+tPBFYkFCL1+1RzRqFm+nmc9F8m4+2JSXpB9RDDMDS6PDjm3JmEk1xydKKwyo22BolqirnxpvkG27FcGe7EaxByJ+02yBLzdkEqcG0dioIbze24KZfwWHLFTpi+YL6GWWOOlVPCPTVqRGePdoBWfaWlmm+6e5Y0Gz72gjwaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1zSKUqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1zSKUqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D740C4CEF6;
	Wed, 30 Jul 2025 09:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868632;
	bh=OqlUrox7py4+xPWPGf46JQIkjDhGhzK3tASvJcDirmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1zSKUqB5agGcpBtQRzfTcp8ILVbKfh9SZDOIpO2s1fyIl0OmLX8psH0IfOZh+tmj
	 RhT+0gXXyyoG3+hBRA95pVOuo8apy2yPxURVmqPQAYmJA+aJQ6kARMUccyqjQzQtE+
	 boDyAfn1aHv0ThXSBAgg9/XTsx7aUWjKfEfoSV+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Xiang Mei <xmei5@asu.edu>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/117] net/sched: sch_qfq: Avoid triggering might_sleep in atomic context in qfq_delete_class
Date: Wed, 30 Jul 2025 11:34:58 +0200
Message-ID: <20250730093234.698515766@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit cf074eca0065bc5142e6004ae236bb35a2687fdf ]

might_sleep could be trigger in the atomic context in qfq_delete_class.

qfq_destroy_class was moved into atomic context locked
by sch_tree_lock to avoid a race condition bug on
qfq_aggregate. However, might_sleep could be triggered by
qfq_destroy_class, which introduced sleeping in atomic context (path:
qfq_destroy_class->qdisc_put->__qdisc_destroy->lockdep_unregister_key
->might_sleep).

Considering the race is on the qfq_aggregate objects, keeping
qfq_rm_from_agg in the lock but moving the left part out can solve
this issue.

Fixes: 5e28d5a3f774 ("net/sched: sch_qfq: Fix race condition on qfq_aggregate")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/4a04e0cc-a64b-44e7-9213-2880ed641d77@sabinyo.mountain
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20250717230128.159766-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 8e60fb5a7083b..5a345ef35c9f6 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -539,9 +539,6 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 static void qfq_destroy_class(struct Qdisc *sch, struct qfq_class *cl)
 {
-	struct qfq_sched *q = qdisc_priv(sch);
-
-	qfq_rm_from_agg(q, cl);
 	gen_kill_estimator(&cl->rate_est);
 	qdisc_put(cl->qdisc);
 	kfree(cl);
@@ -562,10 +559,11 @@ static int qfq_delete_class(struct Qdisc *sch, unsigned long arg,
 
 	qdisc_purge_queue(cl->qdisc);
 	qdisc_class_hash_remove(&q->clhash, &cl->common);
-	qfq_destroy_class(sch, cl);
+	qfq_rm_from_agg(q, cl);
 
 	sch_tree_unlock(sch);
 
+	qfq_destroy_class(sch, cl);
 	return 0;
 }
 
@@ -1506,6 +1504,7 @@ static void qfq_destroy_qdisc(struct Qdisc *sch)
 	for (i = 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry_safe(cl, next, &q->clhash.hash[i],
 					  common.hnode) {
+			qfq_rm_from_agg(q, cl);
 			qfq_destroy_class(sch, cl);
 		}
 	}
-- 
2.39.5



