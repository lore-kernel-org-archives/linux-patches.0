Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DE24F85B0;
	Thu, 17 Sep 2026 17:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665760; cv=none; b=FH1TeYuTxvT0Razfbvyd4z8RA7fLjLC2vJkMvWJRk4AVnYXNos8ky9o2J1fpvyNvEE/E+bN3Ne2KMblQsGOrdTRzTvnVXwrA1DzDCMEJsk4L22r2oaZrjORWz6f2DGa4YzwcLl215XXhg1AUMUA7k2iB6kroje+sTnJgGDbPi4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665760; c=relaxed/simple;
	bh=Xvue89D0lMUHjWYkAIDZEC/rUzr/dMYmVKtFspn1Qus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afSrwX0OCFE8Ez2F7iYyo7cYytfXJol2RNIs9d/EcrhnMiEzOhR+MRp3ymuuvS770gcgkwCEiVc/uRiDevVZNC53yqf2CpXp3g2yPmbaBv4BnI9532w/T0VDK0kmV2c+vG9/v2axHVF4lgEbJHUo2prNe5OiTZJedITT1lItbWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vz+TF3VM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vz+TF3VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5CC1F000FF;
	Thu, 17 Sep 2026 17:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665759;
	bh=JsKEu4p9voYaMLmzEcVtJSVSHWRQE2LsFyS2DLt2EeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vz+TF3VMMHNe62kWP8+2RcVdIJB07d9XFtNVnNn+6M/K82nBVbA0f9EsH4T6xXYHr
	 gBGPmqJZ1i7GQDk6Ufn6HRITqmnCiV+lrIVixpFgoEcOTZss9o6x9YNLGmJmzVXK+6
	 VYuZAIgXbkbKP6udbd/ttBoY8vnTt4zIGdbG5XWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0810/1250] net/sched: defer qdisc freeing after failed creation
Date: Thu, 17 Sep 2026 16:10:05 +0100
Message-ID: <20260917151613.872957716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cf1923f8cb524..97c1b2828bcd5 100644
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
index efe055a9c669b..df271cbc2d9f2 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1381,7 +1381,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 err_out3:
 	lockdep_unregister_key(&sch->root_lock_key);
 	netdev_put(dev, &sch->dev_tracker);
-	qdisc_free(sch);
+	qdisc_free_rcu(sch);
 err_out2:
 	bpf_module_put(ops, ops->owner);
 err_out:
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a753945f860c3..bf8bd129ce911 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1067,21 +1067,21 @@ void qdisc_reset(struct Qdisc *qdisc)
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
@@ -1108,7 +1108,7 @@ static void __qdisc_destroy(struct Qdisc *qdisc)
 
 	trace_qdisc_destroy(qdisc);
 
-	call_rcu(&qdisc->rcu, qdisc_free_cb);
+	qdisc_free_rcu(qdisc);
 }
 
 void qdisc_destroy(struct Qdisc *qdisc)
-- 
2.53.0



