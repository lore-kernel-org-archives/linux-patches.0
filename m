Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B16A370AFB;
	Tue, 21 Jul 2026 22:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671415; cv=none; b=ljkAc6UpVEZ3FmUm2ZZcILAthOSh3bbupQI+y5cwj1Iyv7txkCnRFiq19mdhW4BT58RVcAKrClFvopbQLgJ9KySzL8v2KepxzP7xQ9ltcxvVwqUPYu7wacZwCRE08RxubCOG+j5fJiVhRHGT/g26SarNB8Wg/lkUYhpx/g0Can8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671415; c=relaxed/simple;
	bh=oCOK6OEjghdyqp/y1FSN+QDqL8wmOT91sdvTB08bMVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q0MGCPNHhVfujOex1ACAu2NuWG/wC5u/vJBrzKgirVSxFDrq3e2X+C5n4Xsv8HqoIyUE84EzYNevYYcFcTnLaeyX7ljJWP04DCx6S4YXWi3MtCYa3wpJbIrhv473GpGxigIoRI3bsS/9pJotKd1AfH4OMGEfblyPvV0q+FJH/Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRJa7kHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRJa7kHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2231F000E9;
	Tue, 21 Jul 2026 22:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671414;
	bh=fzX66bR8gppJgLdvUJj9gYmRjR6Pb69XVdV1mrQXekE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRJa7kHdvDasroDO9+BR2kIuKlMToSqwI6VrJiHTq/fIfAiYhk7RCn1BEYYCw0+2F
	 pioDxghOJKP53y017WfxqJJi9wpRVJ3jUyNYsSOsz6ppWUh12/M/8q9dxgB54/FMn+
	 laIqY22dNFKnt8lYUz/u5atfLO7g326o/KyVkv4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/843] net/sched: sch_hfsc: annotate data-races in hfsc_dump_class_stats()
Date: Tue, 21 Jul 2026 17:17:52 +0200
Message-ID: <20260721152411.347618779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e300c7d470ad2726d6abf7d11b31b5d9912d9cf0 ]

hfsc_dump_class_stats() runs without qdisc spinlock being held.

Add READ_ONCE()/WRITE_ONCE() annotations around:

- cl->level
- cl->cl_vtperiod
- cl->cl_total
- cl->cl_cumul

Fixes: edb09eb17ed8 ("net: sched: do not acquire qdisc spinlock in qdisc/class stats dump")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260513080853.1383975-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hfsc.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index f6c81c247418a3..c6140000fd4982 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -716,7 +716,7 @@ init_vf(struct hfsc_class *cl, unsigned int len)
 			rtsc_min(&cl->cl_virtual, &cl->cl_fsc, cl->cl_vt, cl->cl_total);
 			cl->cl_vtadj = 0;
 
-			cl->cl_vtperiod++;  /* increment vt period */
+			WRITE_ONCE(cl->cl_vtperiod, cl->cl_vtperiod + 1);  /* increment vt period */
 			cl->cl_parentperiod = cl->cl_parent->cl_vtperiod;
 			if (cl->cl_parent->cl_nactive == 0)
 				cl->cl_parentperiod++;
@@ -758,7 +758,7 @@ update_vf(struct hfsc_class *cl, unsigned int len, u64 cur_time)
 		go_passive = 1;
 
 	for (; cl->cl_parent != NULL; cl = cl->cl_parent) {
-		cl->cl_total += len;
+		WRITE_ONCE(cl->cl_total, cl->cl_total + len);
 
 		if (!(cl->cl_flags & HFSC_FSC) || cl->cl_nactive == 0)
 			continue;
@@ -848,7 +848,7 @@ hfsc_adjust_levels(struct hfsc_class *cl)
 			if (p->level >= level)
 				level = p->level + 1;
 		}
-		cl->level = level;
+		WRITE_ONCE(cl->level, level);
 	} while ((cl = cl->cl_parent) != NULL);
 }
 
@@ -1337,10 +1337,10 @@ hfsc_dump_class_stats(struct Qdisc *sch, unsigned long arg,
 	__u32 qlen;
 
 	qdisc_qstats_qlen_backlog(cl->qdisc, &qlen, &cl->qstats.backlog);
-	xstats.level   = cl->level;
-	xstats.period  = cl->cl_vtperiod;
-	xstats.work    = cl->cl_total;
-	xstats.rtwork  = cl->cl_cumul;
+	xstats.level   = READ_ONCE(cl->level);
+	xstats.period  = READ_ONCE(cl->cl_vtperiod);
+	xstats.work    = READ_ONCE(cl->cl_total);
+	xstats.rtwork  = READ_ONCE(cl->cl_cumul);
 
 	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch), d, NULL, &cl->bstats) < 0 ||
 	    gnet_stats_copy_rate_est(d, &cl->rate_est) < 0 ||
@@ -1459,15 +1459,15 @@ hfsc_change_qdisc(struct Qdisc *sch, struct nlattr *opt,
 static void
 hfsc_reset_class(struct hfsc_class *cl)
 {
-	cl->cl_total        = 0;
-	cl->cl_cumul        = 0;
+	WRITE_ONCE(cl->cl_total, 0);
+	WRITE_ONCE(cl->cl_cumul, 0);
 	cl->cl_d            = 0;
 	cl->cl_e            = 0;
 	cl->cl_vt           = 0;
 	cl->cl_vtadj        = 0;
 	cl->cl_cvtmin       = 0;
 	cl->cl_cvtoff       = 0;
-	cl->cl_vtperiod     = 0;
+	WRITE_ONCE(cl->cl_vtperiod, 0);
 	cl->cl_parentperiod = 0;
 	cl->cl_f            = 0;
 	cl->cl_myf          = 0;
@@ -1633,7 +1633,7 @@ hfsc_dequeue(struct Qdisc *sch)
 	bstats_update(&cl->bstats, skb);
 	update_vf(cl, qdisc_pkt_len(skb), cur_time);
 	if (realtime)
-		cl->cl_cumul += qdisc_pkt_len(skb);
+		WRITE_ONCE(cl->cl_cumul, cl->cl_cumul + qdisc_pkt_len(skb));
 
 	if (cl->cl_flags & HFSC_RSC) {
 		if (cl->qdisc->q.qlen != 0) {
-- 
2.53.0



