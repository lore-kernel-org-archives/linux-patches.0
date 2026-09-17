Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7664ABBCC;
	Thu, 17 Sep 2026 18:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670514; cv=none; b=Qfqt9KZxtQjmKLCaKx+6lGEN6e5CniL/frIbPOTiSsVOJQxc0GfW8kt/CyWSeOf2Vto6bbMMTL0nxDWo+uYJILNCzIaLtUdXPmP3QpA1mIev0osF2TM8Y7PDwj3T+GgalqVJ3269gWO+1DBSec1EiaehWY7+7wr9U8sUiiUYAZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670514; c=relaxed/simple;
	bh=McStbwgePR8woPwEHO0KjvICagkfrqJEPdJivAGkwgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNLohZEPsoTBJWfR4sH2RrwijcMGB/pBN+3nNr1L7YZ7bf/pC3KZKClsrbowU0G895FRhAhYRY/DbAA53Bu0Y/Rcp44RWYuoY+CygxgY1Q4tQOHel79U0y4D5etoNHJJsMblgmhdekI6HN0dlMN4Ng8qnQFayKxyT18P3n8lMag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNWJupjN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNWJupjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933441F000FF;
	Thu, 17 Sep 2026 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670512;
	bh=WmxPPd8oeJ0Fm9xhyeko1XkX0PHtvpwLZjRhxChv9Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNWJupjN3Rvqdn0owParuCm3PzM9f+yvXsJbEsYOy/WpILhDls2wB2vjelAbUd5O0
	 dmzjGVkZ/WoIkAYb08Q6tOnHkyMgmxWcsLDiHXuQjxAzGMceCCbsyObborqpJcmH3e
	 5w39C0d3ihkL0Ug0X67qQSR8jGJm6oHnHkqygsHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0686/1102] net/sched: defer qdisc freeing after failed creation
Date: Thu, 17 Sep 2026 16:10:29 +0100
Message-ID: <20260917151557.483079572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1b461d1816479..2c1bb37c929ee 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -755,7 +755,7 @@ void qdisc_offload_query_caps(struct net_device *dev,
 struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 			  const struct Qdisc_ops *ops,
 			  struct netlink_ext_ack *extack);
-void qdisc_free(struct Qdisc *qdisc);
+void qdisc_free_rcu(struct Qdisc *qdisc);
 struct Qdisc *qdisc_create_dflt(struct netdev_queue *dev_queue,
 				const struct Qdisc_ops *ops, u32 parentid,
 				struct netlink_ext_ack *extack);
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 1d76f78534048..f25201067cceb 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1408,7 +1408,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 err_out3:
 	lockdep_unregister_key(&sch->root_lock_key);
 	netdev_put(dev, &sch->dev_tracker);
-	qdisc_free(sch);
+	qdisc_free_rcu(sch);
 err_out2:
 	module_put(ops->owner);
 err_out:
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index db24aa644ad95..6a61bd0c081c6 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1050,21 +1050,21 @@ void qdisc_reset(struct Qdisc *qdisc)
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
@@ -1091,7 +1091,7 @@ static void __qdisc_destroy(struct Qdisc *qdisc)
 
 	trace_qdisc_destroy(qdisc);
 
-	call_rcu(&qdisc->rcu, qdisc_free_cb);
+	qdisc_free_rcu(qdisc);
 }
 
 void qdisc_destroy(struct Qdisc *qdisc)
-- 
2.53.0



