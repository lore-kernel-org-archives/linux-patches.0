Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E093E33A6F2;
	Wed, 20 May 2026 17:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296634; cv=none; b=NEifaog9GvscEhBMXp+XBXjB9gxGEdl6VESagC1mo87mzEamTJdqnhEhW5R/rHwBDy4JQdA6ohoDLOvCRwbUyry+KiQCJM9ZG1I8NN+riY2HX5IuN+yxBzd/mm1TjmuJX96kMccHkMwylscDmACMz0ZYQ8lNBHm1m0550OAXXno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296634; c=relaxed/simple;
	bh=r+DBm+J5sqAOhe/weI30WRQY26hmZndLbtcuLjOKN7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHMIY/e/rW4KTU6htTbAQGGNlCdFPnI1fs+31ZPa2FeGBL20iRgnEyRFHlW40YfQqw+xQKrvgKoYHQZ4ZrqS36Ka++XGxEWgqnoK4k0N7tGKKB5H7pxoEXG+IKNHZJNUeUH1UCdokA49PvohOoJjE8Tk8hUbRlYQtVLHTMD1OiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdPckLsF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdPckLsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D0B1F000E9;
	Wed, 20 May 2026 17:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296632;
	bh=TkBwuxZcpveCGjf47fj7pJ6B+JzqFklTv0DDe6sk67s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NdPckLsFgT+wvfInxTnGZU3SNF3Z5V0lbN+Ucsq2NKH6FnEvts1ntVYPg2A8iqWPX
	 ugfpoeF05nWpXq+2Ug5b1V2xzFYPloTWP0jrsTCykEk8zawYA5db6r4wQRyn7mFpjL
	 04p+/PsMjDH6I4WnEq+u1ZPDj/kBZ/5Nh5IOGWus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kito Xu (veritas501)" <hxzene@gmail.com>,
	Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0821/1146] net/sched: sch_dualpi2: drain both C-queue and L-queue in dualpi2_change()
Date: Wed, 20 May 2026 18:17:51 +0200
Message-ID: <20260520162206.811573957@linuxfoundation.org>
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

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

[ Upstream commit 478ed6b7d2577439c610f91fa8759a4c878a4264 ]

Fix dualpi2_change() to correctly enforce updated limit and memlimit
values after a configuration change of the dualpi2 qdisc.

Before this patch, dualpi2_change() always attempted to dequeue packets
via the root qdisc (C-queue) when reducing backlog or memory usage, and
unconditionally assumed that a valid skb will be returned. When traffic
classification results in packets being queued in the L-queue while the
C-queue is empty, this leads to a NULL skb dereference during limit or
memlimit enforcement.

This is fixed by first dequeuing from the C-queue path if it is
non-empty. Once the C-queue is empty, packets are dequeued directly from
the L-queue. Return values from qdisc_dequeue_internal() are checked for
both queues. When dequeuing from the L-queue, the parent qdisc qlen and
backlog counters are updated explicitly to keep overall qdisc statistics
consistent.

Fixes: 320d031ad6e4 ("sched: Struct definition and parsing of dualpi2 qdisc")
Reported-by: "Kito Xu (veritas501)" <hxzene@gmail.com>
Closes: https://lore.kernel.org/netdev/20260413075740.2234828-1-hxzene@gmail.com/
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Link: https://patch.msgid.link/20260417152551.71648-1-chia-yu.chang@nokia-bell-labs.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_dualpi2.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_dualpi2.c b/net/sched/sch_dualpi2.c
index 6d7e6389758dc..d200c08ce50a1 100644
--- a/net/sched/sch_dualpi2.c
+++ b/net/sched/sch_dualpi2.c
@@ -872,11 +872,35 @@ static int dualpi2_change(struct Qdisc *sch, struct nlattr *opt,
 	old_backlog = sch->qstats.backlog;
 	while (qdisc_qlen(sch) > sch->limit ||
 	       q->memory_used > q->memory_limit) {
-		struct sk_buff *skb = qdisc_dequeue_internal(sch, true);
+		struct sk_buff *skb = NULL;
 
-		q->memory_used -= skb->truesize;
-		qdisc_qstats_backlog_dec(sch, skb);
-		rtnl_qdisc_drop(skb, sch);
+		if (qdisc_qlen(sch) > qdisc_qlen(q->l_queue)) {
+			skb = qdisc_dequeue_internal(sch, true);
+			if (unlikely(!skb)) {
+				WARN_ON_ONCE(1);
+				break;
+			}
+			q->memory_used -= skb->truesize;
+			rtnl_qdisc_drop(skb, sch);
+		} else if (qdisc_qlen(q->l_queue)) {
+			skb = qdisc_dequeue_internal(q->l_queue, true);
+			if (unlikely(!skb)) {
+				WARN_ON_ONCE(1);
+				break;
+			}
+			/* L-queue packets are counted in both sch and
+			 * l_queue on enqueue; qdisc_dequeue_internal()
+			 * handled l_queue, so we further account for sch.
+			 */
+			--sch->q.qlen;
+			qdisc_qstats_backlog_dec(sch, skb);
+			q->memory_used -= skb->truesize;
+			rtnl_qdisc_drop(skb, q->l_queue);
+			qdisc_qstats_drop(sch);
+		} else {
+			WARN_ON_ONCE(1);
+			break;
+		}
 	}
 	qdisc_tree_reduce_backlog(sch, old_qlen - qdisc_qlen(sch),
 				  old_backlog - sch->qstats.backlog);
-- 
2.53.0



