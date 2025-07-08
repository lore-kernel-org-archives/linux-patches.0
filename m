Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CADF9E8;
	Tue,  8 Jul 2025 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992816; cv=none; b=rIMehxTfzppEuVWMoPMWVDqykPf0RCDJuJS2zV46qzUgoLkhdaawdIzCHwjLUsy192C53YkloqEg66UC2ixTQAr68UrG+jwwSj1RRn9n03/og3O7gW25LL6SdjHJCPYcdZtGLCqdfYR6/l0HXY2ah1D/aVvwubDzCE4nqGZ/DhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992816; c=relaxed/simple;
	bh=CnCZeOvdjwNn4IfFmhiBv27jKwrMfJN4XwJW7jmAiUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0Y6EFD6ZTobkQ6b+mNLkGZ/cbLN5mKevo3BwVAQ851rNRdg13G71PdU4EPkboFMLLrbqx/8HtKKN9lDgKdWHQq4/muSNMk9iET5T8jo7h88yiMz+2z8+6Zvf5cxmJgfSFKExbN9Vxai0Q33JDLpbyL7WM6FntsdMP3+gTpyh9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMBT2VO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMBT2VO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DB5C4CEED;
	Tue,  8 Jul 2025 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992816;
	bh=CnCZeOvdjwNn4IfFmhiBv27jKwrMfJN4XwJW7jmAiUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMBT2VO6jkmzfhRyndHLD9X363oLheziYQjOJknqUBoPqhf4pIThOkTzqBTWHbx5T
	 73HDBFQmUdWIWxPPJf9sw9kmXtG2AKcrykmiEn/a5i+xq4/b/LTnpn+1NI8JGh8xqo
	 s+1b218rG4Sx3Ftid7J6cjfO4vjSlTIp6oxBpB60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lion Ackermann <nnamrec@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/232] net/sched: Always pass notifications when child class becomes empty
Date: Tue,  8 Jul 2025 18:21:26 +0200
Message-ID: <20250708162243.805651406@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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
index 518f52f65a49d..26378eac1bd08 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -779,15 +779,12 @@ static u32 qdisc_alloc_handle(struct net_device *dev)
 
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
@@ -796,17 +793,8 @@ void qdisc_tree_reduce_backlog(struct Qdisc *sch, int n, int len)
 
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
@@ -815,6 +803,9 @@ void qdisc_tree_reduce_backlog(struct Qdisc *sch, int n, int len)
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



