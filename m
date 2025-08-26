Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF122350D57;
	Tue, 26 Aug 2025 13:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216765; cv=none; b=Ocyc7taepgVdyVCVc747qTWoF2mZHwdxp/ujcIpZRbAQ36SasJCaGJ7Pl5Q3c1fSs22OvVBXb/2bNsQOOSXSQaPPrUqo2qV7JBny6a51/ILR2htA+1e+pVmLuaviAUoMQ7HaFsVRHpIMZ0N2moKoW0SNGYTzZgdZ/QYJEN6PcBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216765; c=relaxed/simple;
	bh=zX6SqT+ueyoh6nEVC+HcgEaNVPgfccNSkRg3LWCjLIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+5C7z34tibrGWPrtyEen0KYN5ULnADClVuvYUyYr0l3iA7yTh/hCRx0dMWI4t9DNCvjsLG93CSW0L37MKZBY/BZcF1UbjBxZ/NZKwtaxKHPcBkf3OwC44vj18eDEIzN4TlgxCoYyuBjppaU8Ld0H/9Jp+XhrQB94l4BlQQ4XG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zN5WveUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zN5WveUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D5BC4CEF1;
	Tue, 26 Aug 2025 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216765;
	bh=zX6SqT+ueyoh6nEVC+HcgEaNVPgfccNSkRg3LWCjLIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zN5WveUdISm7eFfBTJdnusXXayTHn/ukZBKWtli45YEzOxdXcnocbzqO3lqzb9fPa
	 HEIZOVlD0Qb9EUV8IC7rYmie20GyXmfhzs2ity8fTBle7UP1WdhEbn9vdcZ7C85hDT
	 T5GOPmYps1RuLpbTLItfLqCScNTHBMASwDDXWbts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 505/644] sch_qfq: make qfq_qlen_notify() idempotent
Date: Tue, 26 Aug 2025 13:09:56 +0200
Message-ID: <20250826110959.012799575@linuxfoundation.org>
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
@@ -354,7 +354,7 @@ static void qfq_deactivate_class(struct
 	struct qfq_aggregate *agg = cl->agg;
 
 
-	list_del(&cl->alist); /* remove from RR queue of the aggregate */
+	list_del_init(&cl->alist); /* remove from RR queue of the aggregate */
 	if (list_empty(&agg->active)) /* agg is now inactive */
 		qfq_deactivate_agg(q, agg);
 }
@@ -486,6 +486,7 @@ static int qfq_change_class(struct Qdisc
 
 	cl->common.classid = classid;
 	cl->deficit = lmax;
+	INIT_LIST_HEAD(&cl->alist);
 
 	cl->qdisc = qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
 				      classid, NULL);
@@ -1006,7 +1007,7 @@ static struct sk_buff *agg_dequeue(struc
 	cl->deficit -= (int) len;
 
 	if (cl->qdisc->q.qlen == 0) /* no more packets, remove from list */
-		list_del(&cl->alist);
+		list_del_init(&cl->alist);
 	else if (cl->deficit < qdisc_pkt_len(cl->qdisc->ops->peek(cl->qdisc))) {
 		cl->deficit += agg->lmax;
 		list_move_tail(&cl->alist, &agg->active);
@@ -1438,6 +1439,8 @@ static void qfq_qlen_notify(struct Qdisc
 	struct qfq_sched *q = qdisc_priv(sch);
 	struct qfq_class *cl = (struct qfq_class *)arg;
 
+	if (list_empty(&cl->alist))
+		return;
 	qfq_deactivate_class(q, cl);
 }
 


