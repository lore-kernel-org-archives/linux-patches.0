Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D12634AB1A;
	Tue, 26 Aug 2025 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216797; cv=none; b=jeCLJXfbHcRMT2kimaCuzS/nbijJi1WiAU3xBvS47FrrlQeCEWkoGSY/ZcmytL7b9puuBd5AE3KaRp1wTVZPA0ljY4+24axnbHNe7mfDZnmckoe/Yt0DJH7W7naMsg5QTdylDu+AG20syExXp9ZREkwESA7SDoAepBysadPGxOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216797; c=relaxed/simple;
	bh=cR5/h1meG/vOREnlgFk7Pq6Ym/1Ob2C+zbk/HA8mwTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8GgM3o2qJJUKZOgChBwNMHZxF/BnVgx5h/y+paUZsFue/C3E2bJxRFNkL3Ng5/7tJUhReIXVEjHEMaSvDdgjLhJf6V8yCjDvZrU0scGMT7BdxlWbqilWO/nMowAPA5rC7TPnacQWgQQb2r/fSc3bvsj9q6Eg05kklKmTtK+Gr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amoRU/Gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amoRU/Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6286C4CEF1;
	Tue, 26 Aug 2025 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216797;
	bh=cR5/h1meG/vOREnlgFk7Pq6Ym/1Ob2C+zbk/HA8mwTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amoRU/GhlI6cSYAuLo68YlieJzGVmqnHxWogxuU+KxOh2X0BJuodXuoI8lASQP/zD
	 y6LbQDmyasCKeHIfq/D3duHz8MhLkNAoxo+Kfj3AEWMjssbyiggkd6Zhmv4/zHK2Qf
	 rEX70oaZGHJks2CwP+w9VLUh0vQxc31H2aaKVcFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alan J. Wylie" <alan@wylie.me.uk>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 5.15 548/644] sch_htb: make htb_deactivate() idempotent
Date: Tue, 26 Aug 2025 13:10:39 +0200
Message-ID: <20250826111000.106594242@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 3769478610135e82b262640252d90f6efb05be71 upstream.

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
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_htb.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -345,7 +345,8 @@ static void htb_add_to_wait_tree(struct
  */
 static inline void htb_next_rb_node(struct rb_node **n)
 {
-	*n = rb_next(*n);
+	if (*n)
+		*n = rb_next(*n);
 }
 
 /**
@@ -606,8 +607,8 @@ static inline void htb_activate(struct h
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
@@ -1506,8 +1507,6 @@ static void htb_qlen_notify(struct Qdisc
 {
 	struct htb_class *cl = (struct htb_class *)arg;
 
-	if (!cl->prio_activity)
-		return;
 	htb_deactivate(qdisc_priv(sch), cl);
 }
 
@@ -1762,8 +1761,7 @@ static int htb_delete(struct Qdisc *sch,
 	if (cl->parent)
 		cl->parent->children--;
 
-	if (cl->prio_activity)
-		htb_deactivate(q, cl);
+	htb_deactivate(q, cl);
 
 	if (cl->cmode != HTB_CAN_SEND)
 		htb_safe_rb_erase(&cl->pq_node,
@@ -1975,8 +1973,7 @@ static int htb_change_class(struct Qdisc
 			/* turn parent into inner node */
 			qdisc_purge_queue(parent->leaf.q);
 			parent_qdisc = parent->leaf.q;
-			if (parent->prio_activity)
-				htb_deactivate(q, parent);
+			htb_deactivate(q, parent);
 
 			/* remove from evt list because of level change */
 			if (parent->cmode != HTB_CAN_SEND) {


