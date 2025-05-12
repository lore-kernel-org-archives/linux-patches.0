Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998E01E505;
	Mon, 12 May 2025 17:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072664; cv=none; b=TuiUu+I/rkKE7boLOdR8tgR5HM9pW6FCrSVQElJYaQka66kDgKQeyLQYWOsJldWtoV66rbulSgNxl6A4ckiUZWlNsOmE1raYNFOFSuaBTkzG/BU05moBtFcAaI56Ozw8g8SdyRlGaWEYXBZPy2tZmlJxHZ+DkT3n0GZSTU6vsco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072664; c=relaxed/simple;
	bh=oVXElsTcTpGrOn3iSSQ0Viz7y4fjA+Feg8olR5oEe8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qf7+0UjAZXIIuikT1BFO3MhFXOb3vxkwqwwxbpdknlQvMumnmR88tMG2VVBaSnbdic0K6vsrkOeyj9boCeBE3u1mEqP6knNtRcu4ryXmQRTxg7nxqr89RudVhmKinGTcc4rHjr2zVvyXtRwcENhLmtPNMUYfg3AoiGwYZphuhSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5cCzf9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5cCzf9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216D1C4CEE7;
	Mon, 12 May 2025 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072664;
	bh=oVXElsTcTpGrOn3iSSQ0Viz7y4fjA+Feg8olR5oEe8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5cCzf9CTyEUrYtdE9ywCjktxG3Sfl9P62Xk4f99WmYlV0O4YMbZ2aQOP7MAm2Hg4
	 pDjas/9p5uPnJQj3R3TbIhH+KB+WqT+9CONojAIk5gcOUprINormI8sikLjyhYveZO
	 4gI0fu1bmG37PhP6OhypJ321OXQ99xM3YMbJZDSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alan J. Wylie" <alan@wylie.me.uk>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/184] sch_htb: make htb_deactivate() idempotent
Date: Mon, 12 May 2025 19:43:40 +0200
Message-ID: <20250512172042.461571049@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 3769478610135e82b262640252d90f6efb05be71 ]

Alan reported a NULL pointer dereference in htb_next_rb_node()
after we made htb_qlen_notify() idempotent.

It turns out in the following case it introduced some regression:

htb_dequeue_tree():
  |-> fq_codel_dequeue()
    |-> qdisc_tree_reduce_backlog()
      |-> htb_qlen_notify()
        |-> htb_deactivate()
  |-> htb_next_rb_node()
  |-> htb_deactivate()

For htb_next_rb_node(), after calling the 1st htb_deactivate(), the
clprio[prio]->ptr could be already set to  NULL, which means
htb_next_rb_node() is vulnerable here.

For htb_deactivate(), although we checked qlen before calling it, in
case of qlen==0 after qdisc_tree_reduce_backlog(), we may call it again
which triggers the warning inside.

To fix the issues here, we need to:

1) Make htb_deactivate() idempotent, that is, simply return if we
   already call it before.
2) Make htb_next_rb_node() safe against ptr==NULL.

Many thanks to Alan for testing and for the reproducer.

Fixes: 5ba8b837b522 ("sch_htb: make htb_qlen_notify() idempotent")
Reported-by: Alan J. Wylie <alan@wylie.me.uk>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://patch.msgid.link/20250428232955.1740419-2-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 12cccc84d58a0..b2494d24a5425 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -348,7 +348,8 @@ static void htb_add_to_wait_tree(struct htb_sched *q,
  */
 static inline void htb_next_rb_node(struct rb_node **n)
 {
-	*n = rb_next(*n);
+	if (*n)
+		*n = rb_next(*n);
 }
 
 /**
@@ -609,8 +610,8 @@ static inline void htb_activate(struct htb_sched *q, struct htb_class *cl)
  */
 static inline void htb_deactivate(struct htb_sched *q, struct htb_class *cl)
 {
-	WARN_ON(!cl->prio_activity);
-
+	if (!cl->prio_activity)
+		return;
 	htb_deactivate_prios(q, cl);
 	cl->prio_activity = 0;
 }
@@ -1485,8 +1486,6 @@ static void htb_qlen_notify(struct Qdisc *sch, unsigned long arg)
 {
 	struct htb_class *cl = (struct htb_class *)arg;
 
-	if (!cl->prio_activity)
-		return;
 	htb_deactivate(qdisc_priv(sch), cl);
 }
 
@@ -1740,8 +1739,7 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg,
 	if (cl->parent)
 		cl->parent->children--;
 
-	if (cl->prio_activity)
-		htb_deactivate(q, cl);
+	htb_deactivate(q, cl);
 
 	if (cl->cmode != HTB_CAN_SEND)
 		htb_safe_rb_erase(&cl->pq_node,
@@ -1949,8 +1947,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			/* turn parent into inner node */
 			qdisc_purge_queue(parent->leaf.q);
 			parent_qdisc = parent->leaf.q;
-			if (parent->prio_activity)
-				htb_deactivate(q, parent);
+			htb_deactivate(q, parent);
 
 			/* remove from evt list because of level change */
 			if (parent->cmode != HTB_CAN_SEND) {
-- 
2.39.5



