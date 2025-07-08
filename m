Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DA7217722;
	Tue,  8 Jul 2025 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992049; cv=none; b=lOcxzzwCm3BjsyUZ0+4YupYloEk9YmbcCNMhuaFVUHpr0kseU9eO+hgtITkjMf8Zz2On//fO4NTErQmr5ofmVTu91oagi7O6boR0uNYWSBxaguf36pzXXsQI3sBiNUpy2ZMVUgdOpATR35YXiMYZaWQjt+kKDvkc4+AD181qsI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992049; c=relaxed/simple;
	bh=h+qDHtjuLc1ieNO2TA4NeRfwh0R7LDPJpM9iTGzMQXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oc7FxU0tILuF9vo9McOqVFhOtKds183vbL2GWuv/p0chVrXBjnrwOwQg82qlNq/p8q61DLrTJoqB30pXn9J50xqdrQvudgVNP6QRbnwCcT9EWacuzGb4JSlZ+kvam0izW+iG3cG1/ZFgSlEbGIl+AclamWaSMOpJHdV5dPtd3L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZ4xEPTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZ4xEPTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC23BC4CEED;
	Tue,  8 Jul 2025 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992049;
	bh=h+qDHtjuLc1ieNO2TA4NeRfwh0R7LDPJpM9iTGzMQXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZ4xEPTf6t7MlcYSMmw3VDVk2mQY0xPSoO/LirPC2VAbjLPO/Lgeor/DfGKEI4W8k
	 pV572s2QE/jQWLZzCoX68BUQYYEqbUOjYXzTi4pHxnQ8XjAppY2Y/Gos3Rsd0Gs6KY
	 j2UvQZ3ba8idLaq1QN1SZQRJmlRHw939aWozFLXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lion Ackermann <nnamrec@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 42/81] net/sched: Always pass notifications when child class becomes empty
Date: Tue,  8 Jul 2025 18:23:34 +0200
Message-ID: <20250708162226.337069241@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lion Ackermann <nnamrec@gmail.com>

[ Upstream commit 103406b38c600fec1fe375a77b27d87e314aea09 ]

Certain classful qdiscs may invoke their classes' dequeue handler on an
enqueue operation. This may unexpectedly empty the child qdisc and thus
make an in-flight class passive via qlen_notify(). Most qdiscs do not
expect such behaviour at this point in time and may re-activate the
class eventually anyways which will lead to a use-after-free.

The referenced fix commit attempted to fix this behavior for the HFSC
case by moving the backlog accounting around, though this turned out to
be incomplete since the parent's parent may run into the issue too.
The following reproducer demonstrates this use-after-free:

    tc qdisc add dev lo root handle 1: drr
    tc filter add dev lo parent 1: basic classid 1:1
    tc class add dev lo parent 1: classid 1:1 drr
    tc qdisc add dev lo parent 1:1 handle 2: hfsc def 1
    tc class add dev lo parent 2: classid 2:1 hfsc rt m1 8 d 1 m2 0
    tc qdisc add dev lo parent 2:1 handle 3: netem
    tc qdisc add dev lo parent 3:1 handle 4: blackhole

    echo 1 | socat -u STDIN UDP4-DATAGRAM:127.0.0.1:8888
    tc class delete dev lo classid 1:1
    echo 1 | socat -u STDIN UDP4-DATAGRAM:127.0.0.1:8888

Since backlog accounting issues leading to a use-after-frees on stale
class pointers is a recurring pattern at this point, this patch takes
a different approach. Instead of trying to fix the accounting, the patch
ensures that qdisc_tree_reduce_backlog always calls qlen_notify when
the child qdisc is empty. This solves the problem because deletion of
qdiscs always involves a call to qdisc_reset() and / or
qdisc_purge_queue() which ultimately resets its qlen to 0 thus causing
the following qdisc_tree_reduce_backlog() to report to the parent. Note
that this may call qlen_notify on passive classes multiple times. This
is not a problem after the recent patch series that made all the
classful qdiscs qlen_notify() handlers idempotent.

Fixes: 3f981138109f ("sch_hfsc: Fix qlen accounting bug when using peek in hfsc_enqueue()")
Signed-off-by: Lion Ackermann <nnamrec@gmail.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/d912cbd7-193b-4269-9857-525bee8bbb6a@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index c395e7a98232d..7c5df62421bbd 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -776,15 +776,12 @@ static u32 qdisc_alloc_handle(struct net_device *dev)
 
 void qdisc_tree_reduce_backlog(struct Qdisc *sch, int n, int len)
 {
-	bool qdisc_is_offloaded = sch->flags & TCQ_F_OFFLOADED;
 	const struct Qdisc_class_ops *cops;
 	unsigned long cl;
 	u32 parentid;
 	bool notify;
 	int drops;
 
-	if (n == 0 && len == 0)
-		return;
 	drops = max_t(int, n, 0);
 	rcu_read_lock();
 	while ((parentid = sch->parent)) {
@@ -793,17 +790,8 @@ void qdisc_tree_reduce_backlog(struct Qdisc *sch, int n, int len)
 
 		if (sch->flags & TCQ_F_NOPARENT)
 			break;
-		/* Notify parent qdisc only if child qdisc becomes empty.
-		 *
-		 * If child was empty even before update then backlog
-		 * counter is screwed and we skip notification because
-		 * parent class is already passive.
-		 *
-		 * If the original child was offloaded then it is allowed
-		 * to be seem as empty, so the parent is notified anyway.
-		 */
-		notify = !sch->q.qlen && !WARN_ON_ONCE(!n &&
-						       !qdisc_is_offloaded);
+		/* Notify parent qdisc only if child qdisc becomes empty. */
+		notify = !sch->q.qlen;
 		/* TODO: perform the search on a per txq basis */
 		sch = qdisc_lookup_rcu(qdisc_dev(sch), TC_H_MAJ(parentid));
 		if (sch == NULL) {
@@ -812,6 +800,9 @@ void qdisc_tree_reduce_backlog(struct Qdisc *sch, int n, int len)
 		}
 		cops = sch->ops->cl_ops;
 		if (notify && cops->qlen_notify) {
+			/* Note that qlen_notify must be idempotent as it may get called
+			 * multiple times.
+			 */
 			cl = cops->find(sch, parentid);
 			cops->qlen_notify(sch, cl);
 		}
-- 
2.39.5



