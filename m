Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F9F1482F5;
	Wed,  7 May 2025 18:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644245; cv=none; b=p0/M/nuYet9MclHCVlkrt8gxXeEKJ7kAXTvBsfONjNZUv13cXWGIodkCEPoitHh6wHhr++NOT5F/Sjc0H9gwT1tnalBQNpSVxZReaZjxaqUK2CZ242Ug6SgIAgweCwZh8xk8HGHTTeGPU2hscQ/jSUkMgq5CYGgMK2Iuhzkw0tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644245; c=relaxed/simple;
	bh=FV0lwDxEErFeXPJsvg0Aghog0wY3pvuvPU1mHC0EcKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFuNwn3od1qTIiTYx9RaB2VLr88rolon9XIjqwpQXUuLC5QLx1p2xZzE3LPRgNz+6oFux+kZOs9/xz7AXsOpZEU6JyeK/0VwTrlqtX9W5tK+gktk8868a7eM759PMb7bR0m4fRWCHv87L4UWmQe9L3RTvQkjSyxtiI2JNBVBxrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suT00L9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suT00L9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70617C4CEE2;
	Wed,  7 May 2025 18:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644244;
	bh=FV0lwDxEErFeXPJsvg0Aghog0wY3pvuvPU1mHC0EcKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suT00L9o7hwvqvj0LoOVHrwe45bWr1Sqs8l0WdgKDRQwogcZCFwxUB/lPfgANbx3U
	 jJVqDWPGHrdQJXFyuYIK7Ztj0owoxxxM5917tZfXBiR4LhJAcFtpPlWhcffpw65xuW
	 xTv4AV0SOdTIwdRdXJqAnSYtxLebFPvccGky7JkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.14 165/183] sch_ets: make est_qlen_notify() idempotent
Date: Wed,  7 May 2025 20:40:10 +0200
Message-ID: <20250507183831.553048867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 	WRITE_ONCE(q->nstrict, nstrict);
@@ -716,7 +716,7 @@ static void ets_qdisc_reset(struct Qdisc
 
 	for (band = q->nstrict; band < q->nbands; band++) {
 		if (q->classes[band].qdisc->q.qlen)
-			list_del(&q->classes[band].alist);
+			list_del_init(&q->classes[band].alist);
 	}
 	for (band = 0; band < q->nbands; band++)
 		qdisc_reset(q->classes[band].qdisc);


