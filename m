Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901EF1DE4C4;
	Wed,  7 May 2025 18:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643389; cv=none; b=Kx96HvradTK6Mpk8dNChP4wN1trjwveH0mhNLQujQHilOf/PbStJQCflIDDQQAwVYJTUnlca2VZZbLHbYwkXBz82Mhu7/7oPe+W+hvL9w0w+lpEvE+IK7kWE2bPNiaXre0DeGNyWSZFOX7/UpAncUCklnt3VH09AvTd6BLzjDfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643389; c=relaxed/simple;
	bh=+6XCn/GY6AryQwCiUfpYQGxt6flsBLhVIfLOpmQAIoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWrst/+6eoPdR1ms/b2+XmnH+Nfg4JIhtEjpNstb6WyyWVsCatXteDd9K5X4NhwpynPX77pkM0TDE+UoE8dVerU525AB7k3zCE5Z5hjRbJIilr+i7v+uahibedjJNwtgshbQYk5IgCbKtphrBRoKvtD8nsE6oPqvjCJzTCli958=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYkSY7l0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYkSY7l0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F052C4CEE2;
	Wed,  7 May 2025 18:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643389;
	bh=+6XCn/GY6AryQwCiUfpYQGxt6flsBLhVIfLOpmQAIoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYkSY7l0F55L//ozKzaLmqqtKnOKnCj+0kCoXVu76OgMzuIsyQ3ks1yrl63niKhMF
	 S+pEuRvJ3Q9Vhlq8s51p19Qdhppy8msqERZWzbggc3ILyld4t4uZDn1XqM5J+KEB4u
	 MQfWPaG4q94Og2+4D/yhmuGmiC6xICofYHXf0Uqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 26/55] net_sched: qfq: Fix double list add in class with netem as child qdisc
Date: Wed,  7 May 2025 20:39:27 +0200
Message-ID: <20250507183800.095202856@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit f139f37dcdf34b67f5bf92bc8e0f7f6b3ac63aa4 ]

As described in Gerrard's report [1], there are use cases where a netem
child qdisc will make the parent qdisc's enqueue callback reentrant.
In the case of qfq, there won't be a UAF, but the code will add the same
classifier to the list twice, which will cause memory corruption.

This patch checks whether the class was already added to the agg->active
list (cl_is_active) before doing the addition to cater for the reentrant
case.

[1] https://lore.kernel.org/netdev/CAHcdcOm+03OD2j6R0=YHKqmy=VgJ8xEOKuP6c7mSgnp-TEJJbw@mail.gmail.com/

Fixes: 37d9cf1a3ce3 ("sched: Fix detection of empty queues in child qdiscs")
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20250425220710.3964791-5-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index b1dbe03dde1b5..a198145f1251f 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -204,6 +204,11 @@ struct qfq_sched {
  */
 enum update_reason {enqueue, requeue};
 
+static bool cl_is_active(struct qfq_class *cl)
+{
+	return !list_empty(&cl->alist);
+}
+
 static struct qfq_class *qfq_find_class(struct Qdisc *sch, u32 classid)
 {
 	struct qfq_sched *q = qdisc_priv(sch);
@@ -1223,7 +1228,6 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct qfq_class *cl;
 	struct qfq_aggregate *agg;
 	int err = 0;
-	bool first;
 
 	cl = qfq_classify(skb, sch, &err);
 	if (cl == NULL) {
@@ -1245,7 +1249,6 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	gso_segs = skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
-	first = !cl->qdisc->q.qlen;
 	err = qdisc_enqueue(skb, cl->qdisc, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		pr_debug("qfq_enqueue: enqueue failed %d\n", err);
@@ -1262,8 +1265,8 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	++sch->q.qlen;
 
 	agg = cl->agg;
-	/* if the queue was not empty, then done here */
-	if (!first) {
+	/* if the class is active, then done here */
+	if (cl_is_active(cl)) {
 		if (unlikely(skb == cl->qdisc->ops->peek(cl->qdisc)) &&
 		    list_first_entry(&agg->active, struct qfq_class, alist)
 		    == cl && cl->deficit < len)
-- 
2.39.5



