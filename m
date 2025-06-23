Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1EF1EFFA6;
	Mon, 23 Jun 2025 21:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714035; cv=none; b=gqfXIyV7xVHwLQKTElidqb2TTOg3sotgwp4u4+4/j5H1uwMNdzLJJohBvPk31r0pg5i2jmdcuPMaOTpTUPEOa2KPFoyekHHiByEg/ztETYVF4kgwj7Y10tXnhy3tNq2rudKv+tCKstDPwkmPC63tEnEEM380YvTfU4xyPCZ86G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714035; c=relaxed/simple;
	bh=by/kdzI2NnbGVwcwyMfM0EnGkP4EVGPzDOIVegBlbBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqG9W1TuaUsQh79cwMIPzt79gQR/SL/wbQRCfOMGegbYCu/pMPqW7fLmVfQE1ha554sohw4bc+PFUQBonYunTqVWH90BLQwFLb7/vXkMus1UUme8U+GbzN1pWFAc3wRwgKItO24CXqKpLmRY4qQKUb5LCIOoa23swj05Lgc/zVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxSpjhgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxSpjhgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C84C4CEEA;
	Mon, 23 Jun 2025 21:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714035;
	bh=by/kdzI2NnbGVwcwyMfM0EnGkP4EVGPzDOIVegBlbBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxSpjhgHZCAYS7zp11OhTne51T2NzgCSmg59VYc7PsANBGCyjPaj5ycJIh2lQHG2S
	 NQPamfMikIzOpuJCwZ2awI8KKmYeYo4/HFaIFi4JtUakQNSk9w6F/Cge6Cj4b73+H1
	 CGb7KgsW/9WUYgEzyU947mfJO880l9ozBB6vOeuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/411] sch_ets: make est_qlen_notify() idempotent
Date: Mon, 23 Jun 2025 15:05:05 +0200
Message-ID: <20250623130637.705674970@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

[ Upstream commit a7a15f39c682ac4268624da2abdb9114bdde96d5 ]

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
Stable-dep-of: d92adacdd8c2 ("net_sched: ets: fix a race in ets_qdisc_change()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_ets.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 07fae45f58732..a37979ec78f88 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -298,7 +298,7 @@ static void ets_class_qlen_notify(struct Qdisc *sch, unsigned long arg)
 	 * to remove them.
 	 */
 	if (!ets_class_is_strict(q, cl) && sch->q.qlen)
-		list_del(&cl->alist);
+		list_del_init(&cl->alist);
 }
 
 static int ets_class_dump(struct Qdisc *sch, unsigned long arg,
@@ -499,7 +499,7 @@ static struct sk_buff *ets_qdisc_dequeue(struct Qdisc *sch)
 			if (unlikely(!skb))
 				goto out;
 			if (cl->qdisc->q.qlen == 0)
-				list_del(&cl->alist);
+				list_del_init(&cl->alist);
 			return ets_qdisc_dequeue_skb(sch, skb);
 		}
 
@@ -674,7 +674,7 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 	}
 	for (i = q->nbands; i < oldbands; i++) {
 		if (i >= q->nstrict && q->classes[i].qdisc->q.qlen)
-			list_del(&q->classes[i].alist);
+			list_del_init(&q->classes[i].alist);
 		qdisc_tree_flush_backlog(q->classes[i].qdisc);
 	}
 	q->nstrict = nstrict;
@@ -723,7 +723,7 @@ static void ets_qdisc_reset(struct Qdisc *sch)
 
 	for (band = q->nstrict; band < q->nbands; band++) {
 		if (q->classes[band].qdisc->q.qlen)
-			list_del(&q->classes[band].alist);
+			list_del_init(&q->classes[band].alist);
 	}
 	for (band = 0; band < q->nbands; band++)
 		qdisc_reset(q->classes[band].qdisc);
-- 
2.39.5



