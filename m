Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F08511197;
	Wed, 30 Sep 2026 16:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785184; cv=none; b=ACunkp0xqgSEmu/UZPQmJI2WfCr902M0C5Hxmx8kOJcNzsKr3BMW4FudHfC6vaJJUQz2v1ItXTPvt1ke6L1WDupxPq3px1fiQVt5sdekLXwjqX3dPxl40vOyBA77Rjgl1DR30dUlw6RvSSkjflRoRh07AlkyYiP1fApDkxVAEk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785184; c=relaxed/simple;
	bh=YohwSiFGmsq1WbHCE4LrLAQADXj+AK0p3mTlL1Xs5B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7AZ3QeO9PgGb6fQIF7ClhLmXQkn0rzrP675zWtp9eB3nfKW5Qnu0ILbwuqkYvF2Q1s0v6At5T5TwDmRASlyxXjeoIwnHEnthlK+SEnUXUAPrIrCezt/5YEgRWuCwd1f+P8ChRfNHd0Gg59V5M2dqXMOgJebwkRbZ/HHw5Yy6f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSJbLDdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSJbLDdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4EC1F000FF;
	Wed, 30 Sep 2026 16:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785178;
	bh=tfNog9FTzIBs2Z4BVymz/Oo0gIfKz/J3IRjjiSo7PMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSJbLDdAzbcPbglkMW39a6OzQsg0XrpOAFMcI2Dukx8tOZNTbMeTAoZJ7X1sXXrwl
	 /ziRg65gf6lWIBbrxcF2kyIpuFtK7SHh/T+PNp4zWFIMnzYzVPmdTpiadgxKoTVYjr
	 q4qjPzZWx1qhI8urYwRB9HED8CFRG239E7Sd4hWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 417/982] net/sched: defer qdisc freeing after failed creation
Date: Wed, 30 Sep 2026 17:19:13 +0200
Message-ID: <20260930152425.760036052@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit e6662f2100f8d33b0f4d0047c219efd6bba186ea ]

An RTM_NEWQDISC request can make clsact bind a populated shared ingress
block during ->init(), publishing an embedded mini_Qdisc to lockless
readers.  If the same request has an invalid TCA_RATE, estimator setup
fails after ->init(); the unwind removes the pointer but synchronously
frees its containing qdisc while tc_run() may still hold it.

Retire failed qdiscs through the same RCU helper as normal destruction.
Inline the synchronous free into the callback now that no direct callers
remain.

Fixes: 51ab2994c387 ("net: sched: allow ingress and clsact qdiscs to share filter blocks")
Reported-by: Xiang Mei <xmei5@asu.edu>
Link: https://lore.kernel.org/netdev/20260805102505.740806-1-david.lee@trailofbits.com/
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260902155231.2149915-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h |  2 +-
 net/sched/sch_api.c       |  2 +-
 net/sched/sch_generic.c   | 20 ++++++++++----------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index a0499bff7ff40..7ec1f5aa6adaf 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -721,7 +721,7 @@ void qdisc_offload_query_caps(struct net_device *dev,
 struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 			  const struct Qdisc_ops *ops,
 			  struct netlink_ext_ack *extack);
-void qdisc_free(struct Qdisc *qdisc);
+void qdisc_free_rcu(struct Qdisc *qdisc);
 struct Qdisc *qdisc_create_dflt(struct netdev_queue *dev_queue,
 				const struct Qdisc_ops *ops, u32 parentid,
 				struct netlink_ext_ack *extack);
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 104a186a4dc8b..48e956724d3b2 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1372,7 +1372,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 err_out3:
 	lockdep_unregister_key(&sch->root_lock_key);
 	netdev_put(dev, &sch->dev_tracker);
-	qdisc_free(sch);
+	qdisc_free_rcu(sch);
 err_out2:
 	module_put(ops->owner);
 err_out:
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 54041342f1c6d..f58ec57e31f46 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1045,21 +1045,21 @@ void qdisc_reset(struct Qdisc *qdisc)
 }
 EXPORT_SYMBOL(qdisc_reset);
 
-void qdisc_free(struct Qdisc *qdisc)
+static void qdisc_free_cb(struct rcu_head *head)
 {
-	if (qdisc_is_percpu_stats(qdisc)) {
-		free_percpu(qdisc->cpu_bstats);
-		free_percpu(qdisc->cpu_qstats);
+	struct Qdisc *q = container_of(head, struct Qdisc, rcu);
+
+	if (qdisc_is_percpu_stats(q)) {
+		free_percpu(q->cpu_bstats);
+		free_percpu(q->cpu_qstats);
 	}
 
-	kfree(qdisc);
+	kfree(q);
 }
 
-static void qdisc_free_cb(struct rcu_head *head)
+void qdisc_free_rcu(struct Qdisc *qdisc)
 {
-	struct Qdisc *q = container_of(head, struct Qdisc, rcu);
-
-	qdisc_free(q);
+	call_rcu(&qdisc->rcu, qdisc_free_cb);
 }
 
 static void __qdisc_destroy(struct Qdisc *qdisc)
@@ -1084,7 +1084,7 @@ static void __qdisc_destroy(struct Qdisc *qdisc)
 
 	trace_qdisc_destroy(qdisc);
 
-	call_rcu(&qdisc->rcu, qdisc_free_cb);
+	qdisc_free_rcu(qdisc);
 }
 
 void qdisc_destroy(struct Qdisc *qdisc)
-- 
2.53.0



