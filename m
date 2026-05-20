Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841323F44D9;
	Wed, 20 May 2026 17:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296830; cv=none; b=F1pxgV19dcFLQ9GOKf7Bbu+ZG+owfrzx+iaMV2NeCtlOa+59h9o1r6NSofG31hgK1DAxqvW3ybkjnb+uP0HND/h48IkRjto4j2YWPhZQDdlPwoxUnIrfWaGSMIpnbRiIuYbH0VllLYXtGmIhL47lYgRh272qdQAV7rHXE5cRJUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296830; c=relaxed/simple;
	bh=ZU7odlbl7Pv3Elx/XZTuVWIMl3/1epRLojqzegAe9h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMZNKyqqzuXBLAFlLWGMThMYgiTTRtWrLRouGOQDgiowojAr2WD80aLIxRclMK6QJf2XP5sbfX8kKd9A3r5zLh1GIRKGKVgcQxBcVBU+En+85FilFPXJpjXZoJmFMvFEqvqC/zNb4DjLgc6Oayr3tLpCS8WOm3/aSdc7WF19So8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cO37vAeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cO37vAeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BA21F000E9;
	Wed, 20 May 2026 17:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296827;
	bh=xj/tW+dKwrwlWm+i4tl/4yvvO1jgeIj2LaeErXBkiJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cO37vAeRaPa5CxvtxeQaQarFoDWrPBXtvWPrNAaO1VapuRcri+epKhn9osG6Mk1e7
	 yLqMcZ1M5KYcCp2a7RbmRQrOHeIsoOtdYCPVAFDiJzAlfb8sIYrGESRvYOjkkBZYxd
	 w/DbnR2NwSzfrOCi7cOJS8RcJnpZs5zJEWU3HV7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0946/1146] net/sched: taprio: fix NULL pointer dereference in class dump
Date: Wed, 20 May 2026 18:19:56 +0200
Message-ID: <20260520162209.641856249@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 3d07ca5c0fae311226f737963984bd94bb159a87 ]

When a TAPRIO child qdisc is deleted via RTM_DELQDISC, taprio_graft()
is called with new == NULL and stores NULL into q->qdiscs[cl - 1].
Subsequent RTM_GETTCLASS dump operations walk all classes via
taprio_walk() and call taprio_dump_class(), which calls taprio_leaf()
returning the NULL pointer, then dereferences it to read child->handle,
causing a kernel NULL pointer dereference.

The bug is reachable with namespace-scoped CAP_NET_ADMIN on any kernel
with CONFIG_NET_SCH_TAPRIO enabled. On systems with unprivileged user
namespaces enabled, an unprivileged local user can trigger a kernel
panic by creating a taprio qdisc inside a new network namespace,
grafting an explicit child qdisc, deleting it, and requesting a class
dump. The RTM_GETTCLASS dump itself requires no capability.

 Oops: general protection fault, probably for non-canonical address 0xdffffc0000000007: 0000 [#1] SMP KASAN NOPTI
 KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
 RIP: 0010:taprio_dump_class (net/sched/sch_taprio.c:2478)
 Call Trace:
  <TASK>
  tc_fill_tclass (net/sched/sch_api.c:1966)
  qdisc_class_dump (net/sched/sch_api.c:2326)
  taprio_walk (net/sched/sch_taprio.c:2514)
  tc_dump_tclass_qdisc (net/sched/sch_api.c:2352)
  tc_dump_tclass_root (net/sched/sch_api.c:2370)
  tc_dump_tclass (net/sched/sch_api.c:2431)
  rtnl_dumpit (net/core/rtnetlink.c:6864)
  netlink_dump (net/netlink/af_netlink.c:2325)
  rtnetlink_rcv_msg (net/core/rtnetlink.c:6959)
  netlink_rcv_skb (net/netlink/af_netlink.c:2550)
  </TASK>

Fix this by substituting &noop_qdisc when new is NULL in
taprio_graft(), a common pattern used by other qdiscs (e.g.,
multiq_graft()) to ensure the q->qdiscs[] slots are never NULL.
This makes control-plane dump paths safe without requiring individual
NULL checks.

Since the data-plane paths (taprio_enqueue and taprio_dequeue_from_txq)
previously had explicit NULL guards that would drop/skip the packet
cleanly, update those checks to test for &noop_qdisc instead. Without
this, packets would reach taprio_enqueue_one() which increments the root
qdisc's qlen and backlog before calling the child's enqueue; noop_qdisc
drops the packet but those counters are never rolled back, permanently
inflating the root qdisc's statistics.

After this change *old can be a valid qdisc, NULL, or &noop_qdisc.
Only call qdisc_put(*old) in the first case to avoid decreasing
noop_qdisc's refcount, which was never increased.

Fixes: 665338b2a7a0 ("net/sched: taprio: dump class stats for the actual q->qdiscs[]")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260422161958.2517539-3-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 0316f2dee06ac..3c85ef1ef4818 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -634,7 +634,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	queue = skb_get_queue_mapping(skb);
 
 	child = q->qdiscs[queue];
-	if (unlikely(!child))
+	if (unlikely(child == &noop_qdisc))
 		return qdisc_drop(skb, sch, to_free);
 
 	if (taprio_skb_exceeds_queue_max_sdu(sch, skb)) {
@@ -717,7 +717,7 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	int len;
 	u8 tc;
 
-	if (unlikely(!child))
+	if (unlikely(child == &noop_qdisc))
 		return NULL;
 
 	if (TXTIME_ASSIST_IS_ENABLED(q->flags))
@@ -2184,6 +2184,9 @@ static int taprio_graft(struct Qdisc *sch, unsigned long cl,
 	if (!dev_queue)
 		return -EINVAL;
 
+	if (!new)
+		new = &noop_qdisc;
+
 	if (dev->flags & IFF_UP)
 		dev_deactivate(dev);
 
@@ -2197,14 +2200,14 @@ static int taprio_graft(struct Qdisc *sch, unsigned long cl,
 	*old = q->qdiscs[cl - 1];
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
 		WARN_ON_ONCE(dev_graft_qdisc(dev_queue, new) != *old);
-		if (new)
+		if (new != &noop_qdisc)
 			qdisc_refcount_inc(new);
-		if (*old)
+		if (*old && *old != &noop_qdisc)
 			qdisc_put(*old);
 	}
 
 	q->qdiscs[cl - 1] = new;
-	if (new)
+	if (new != &noop_qdisc)
 		new->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
 
 	if (dev->flags & IFF_UP)
-- 
2.53.0



