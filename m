Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7B83D45D5;
	Wed, 30 Sep 2026 19:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795266; cv=none; b=Qsoeg9xemcNpgsix918LJz/1uG0kU8OkAj2zW2pAwBCWVjrXa5PZcDKuVioYK0iR5+G0lkAgJmyVHNytMVJodkPGiwWybzTxwrYnOc01oD6a5gg9MBh2uoRxne4NfEwoMYT1X//fTizHpTJemtyoI+0cfrc3ZMWu7GCxwYNUrWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795266; c=relaxed/simple;
	bh=+Xe63axHNHauTyyLX0HE4RmYYRaRGW5PiB5or3YelOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbVwoZkkQVmR5u84qL58VCvwQ+4IA68RpSwVZfzxTt0TdLyNOWcvfNbPFn6/LxrLmbm8v7VHKZgqzrZ6SacymDzSDv6LiCDZ8JTgGd2NO7zRWDWN2X+SQ0t1QbuBgix1hocg4Ef+UPkGXYoCUAK9rksRJCXLvh3GI+AXzh2vIbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrSMoKca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrSMoKca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C371F00898;
	Wed, 30 Sep 2026 19:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795265;
	bh=FCFntvPGmJKgRpgsnrfm314FHhSeDXts8svWgZa5l9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrSMoKcaO80pvLxKIfzCeL9qr9D9TVddOES7vAEVvC1CTwzhI0PIlTAyIg8VUKfaK
	 a8NbRxCxhM6uPfT84Hd7Af0cNuZCkxqCHZZadQY8H/vJlZIc9wdSlklpsH53mgdqvs
	 k8Idc2u74Prk+pmqDhP2P5sQjlSDCI3/QvPWtgiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0500/1193] net/sched: defer qdisc freeing after failed creation
Date: Wed, 30 Sep 2026 17:19:44 +0200
Message-ID: <20260930152445.268231978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0ec685beb2fc5..9d623fc8b1fc2 100644
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
index 6aa39c3c6ff44..a62f8b3efdf7f 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1379,7 +1379,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 err_out3:
 	lockdep_unregister_key(&sch->root_lock_key);
 	netdev_put(dev, &sch->dev_tracker);
-	qdisc_free(sch);
+	qdisc_free_rcu(sch);
 err_out2:
 	module_put(ops->owner);
 err_out:
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 98c339b03bf5c..3d695ed25d322 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1047,21 +1047,21 @@ void qdisc_reset(struct Qdisc *qdisc)
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
@@ -1086,7 +1086,7 @@ static void __qdisc_destroy(struct Qdisc *qdisc)
 
 	trace_qdisc_destroy(qdisc);
 
-	call_rcu(&qdisc->rcu, qdisc_free_cb);
+	qdisc_free_rcu(qdisc);
 }
 
 void qdisc_destroy(struct Qdisc *qdisc)
-- 
2.53.0



