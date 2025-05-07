Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41FA1CF5C6;
	Wed,  7 May 2025 18:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644242; cv=none; b=ZBSlPLIhaVWcT5NC21rBKdtUKUt9A+mlZ/4drinNXfbf7xAXPpbx7ASXbyvFxIEfO5E68C/SOngxV3umc5INpYtrySF2NscYHB+Kt4+g2wbw1lqCjqZgynFu3AyEZ16yDOGSMmbDeXokCxqoBSGSXBxK0P3S/vhuWy923oJMn0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644242; c=relaxed/simple;
	bh=KjVauNsC6TpOOI51n4YB4zBoCYb73riloWmbJXt0GXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUxbn3Fk8T1tX2/s+vYBxV+HjveuEhVHvQnIHCLpk1sMftKYkOrK3VyGiaKPDnbbHe1h3TE4mrV8SFf+yfSoTBReQHhRQQ1s3EDmibvkvb3X5ubZmv6KWCfI0dDaZPTuidqUlOSk3tSK2T3Px0XcyPI+Pq3ee3Ggp6JpoUtFzZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GL7Y1eKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GL7Y1eKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE55C4CEE2;
	Wed,  7 May 2025 18:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644241;
	bh=KjVauNsC6TpOOI51n4YB4zBoCYb73riloWmbJXt0GXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GL7Y1eKrL6npouLr1xxw1uRa6Qmydw/xJJJFPQTun1hCoTZLdtpGdbryn+JgzbLLx
	 ufLwWQOFOIBp/j/YLodgK7VBoMNPTbNL+c5s4h3Nt+/hCGn2hhQY9KRti0jHnXK/C0
	 fI0XLMU3G8nT2Ecw9GYDkvy5ut1xxRqhT4n/MTIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.14 164/183] sch_qfq: make qfq_qlen_notify() idempotent
Date: Wed,  7 May 2025 20:40:09 +0200
Message-ID: <20250507183831.513239821@linuxfoundation.org>
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

commit 55f9eca4bfe30a15d8656f915922e8c98b7f0728 upstream.

qfq_qlen_notify() always deletes its class from its active list
with list_del_init() _and_ calls qfq_deactivate_agg() when the whole list
becomes empty.

To make it idempotent, just skip everything when it is not in the active
list.

Also change other list_del()'s to list_del_init() just to be extra safe.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-5-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_qfq.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -352,7 +352,7 @@ static void qfq_deactivate_class(struct
 	struct qfq_aggregate *agg = cl->agg;
 
 
-	list_del(&cl->alist); /* remove from RR queue of the aggregate */
+	list_del_init(&cl->alist); /* remove from RR queue of the aggregate */
 	if (list_empty(&agg->active)) /* agg is now inactive */
 		qfq_deactivate_agg(q, agg);
 }
@@ -479,6 +479,7 @@ static int qfq_change_class(struct Qdisc
 	gnet_stats_basic_sync_init(&cl->bstats);
 	cl->common.classid = classid;
 	cl->deficit = lmax;
+	INIT_LIST_HEAD(&cl->alist);
 
 	cl->qdisc = qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
 				      classid, NULL);
@@ -987,7 +988,7 @@ static struct sk_buff *agg_dequeue(struc
 	cl->deficit -= (int) len;
 
 	if (cl->qdisc->q.qlen == 0) /* no more packets, remove from list */
-		list_del(&cl->alist);
+		list_del_init(&cl->alist);
 	else if (cl->deficit < qdisc_pkt_len(cl->qdisc->ops->peek(cl->qdisc))) {
 		cl->deficit += agg->lmax;
 		list_move_tail(&cl->alist, &agg->active);
@@ -1418,6 +1419,8 @@ static void qfq_qlen_notify(struct Qdisc
 	struct qfq_sched *q = qdisc_priv(sch);
 	struct qfq_class *cl = (struct qfq_class *)arg;
 
+	if (list_empty(&cl->alist))
+		return;
 	qfq_deactivate_class(q, cl);
 }
 


