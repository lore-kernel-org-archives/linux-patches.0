Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AE01B414A;
	Wed,  7 May 2025 18:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643672; cv=none; b=mbuW7flWcN7adHRA9XVhLg4vfCTmkQf1YSGYqC5CGe+Z8tklcYm9KqlJHiYgMBgFbl4w8opHd3sKv36/1vDGIOk2LeWkVs75VVg1iHHA+6dSh9cIYZzU7kiR2XFNtuQOV0vKs1x+G17LLvhzJdQ3qr5Q8zZDuyRV+q7Wgwf5Ddc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643672; c=relaxed/simple;
	bh=O/UolIC9mI4SeA8NTxh2SDjWyHSuqi5PmNqeA/AG8Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCN4M6R+cA1CedWUSjIQ6fp4o3TvvA31GnjSuBRQdFKUTSLlxh/9px/p481OUChuARuLkA9APGneZMMuF6ltQpMGlMBGXLyIBwV8/01HXl9kP84H9gABNumHLAdueREKe7n45I6PWF+77SWmfNVt9Y9RHpWYeOY/ib0pr7XywI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3y7joQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3y7joQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5F1C4CEE2;
	Wed,  7 May 2025 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643672;
	bh=O/UolIC9mI4SeA8NTxh2SDjWyHSuqi5PmNqeA/AG8Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3y7joQPxz8DFsp/wOirqZHN2U0SpfI/r5qWOpXpTyX8He4MZMNOqMQLMc4hsrFMJ
	 OZzf+myuRlTS3mkolOCg0ETDOlfQqXtzeiK6Bxd9WJ0yvF+N8BRMjRw1Wsa6xeUB5C
	 Pb9qzzEdwQCGpS03ehh7P9ZQwnDn3WA10V/TAVTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 78/97] sch_ets: make est_qlen_notify() idempotent
Date: Wed,  7 May 2025 20:39:53 +0200
Message-ID: <20250507183810.122058083@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

From: Cong Wang <xiyou.wangcong@gmail.com>

commit a7a15f39c682ac4268624da2abdb9114bdde96d5 upstream.

est_qlen_notify() deletes its class from its active list with
list_del() when qlen is 0, therefore, it is not idempotent and
not friendly to its callers, like fq_codel_dequeue().

Let's make it idempotent to ease qdisc_tree_reduce_backlog() callers'
life. Also change other list_del()'s to list_del_init() just to be
extra safe.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://patch.msgid.link/20250403211033.166059-6-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_ets.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -298,7 +298,7 @@ static void ets_class_qlen_notify(struct
 	 * to remove them.
 	 */
 	if (!ets_class_is_strict(q, cl) && sch->q.qlen)
-		list_del(&cl->alist);
+		list_del_init(&cl->alist);
 }
 
 static int ets_class_dump(struct Qdisc *sch, unsigned long arg,
@@ -491,7 +491,7 @@ static struct sk_buff *ets_qdisc_dequeue
 			if (unlikely(!skb))
 				goto out;
 			if (cl->qdisc->q.qlen == 0)
-				list_del(&cl->alist);
+				list_del_init(&cl->alist);
 			return ets_qdisc_dequeue_skb(sch, skb);
 		}
 
@@ -660,7 +660,7 @@ static int ets_qdisc_change(struct Qdisc
 	}
 	for (i = q->nbands; i < oldbands; i++) {
 		if (i >= q->nstrict && q->classes[i].qdisc->q.qlen)
-			list_del(&q->classes[i].alist);
+			list_del_init(&q->classes[i].alist);
 		qdisc_tree_flush_backlog(q->classes[i].qdisc);
 	}
 	q->nstrict = nstrict;
@@ -716,7 +716,7 @@ static void ets_qdisc_reset(struct Qdisc
 
 	for (band = q->nstrict; band < q->nbands; band++) {
 		if (q->classes[band].qdisc->q.qlen)
-			list_del(&q->classes[band].alist);
+			list_del_init(&q->classes[band].alist);
 	}
 	for (band = 0; band < q->nbands; band++)
 		qdisc_reset(q->classes[band].qdisc);


