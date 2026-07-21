Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18300471413;
	Tue, 21 Jul 2026 20:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665701; cv=none; b=plxLr1XjdyVYIllp4elAApHA/uREx3jp8DIKQo4k6beI4Yzkc8Jw0BjV7oAPakr8TFwBBMtMmJwpw4xKJpNktg7nOG6o3fbxQJJPr0cTVc0SnnGhCnqfZc8TmtmYTExDLgmAMzqiCijssWQu7q3zkwmXtccVfxcx7wdgkO6IkLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665701; c=relaxed/simple;
	bh=U2UKAVYXDXYDxbkJi2XvKm+C9dTBdCAZNOj8Vx64eaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H49uZmXwVWNRzKIAzD9IWUHPdmUMxYqmYp+VxAmqejHX8x3zLCo8cxVcXSujz9hNTnHdg3GZhXBdXfgZ0SGtP4khxDr1GaOpddibQd4rrB/Ahmmn7NHsdCDm7uWTgFUTAep5ZJ8Q9ZXQHPBqz9vJ7iOZFCcRr9kJFgYH0XlR7Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpAt5c+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpAt5c+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FBA1F00A3A;
	Tue, 21 Jul 2026 20:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665697;
	bh=PUazpM3a4pgUbb5zRwpuwlHQMnG9fg08dgveYwzaW9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpAt5c+jcymVEE2FI/7okROEYgmZQEjkU+lMWZFd/5WnmXTnCO735Ic5IjiuCAn8i
	 c30PTbsWP1GFwPztatojY4GYNfM8gPAsF+KZGRz3uPR18nSMFaVkSciPq6xbh9kAuq
	 gVvp4ZW0jNIyAooQf3ES4ixG1a/6Ve9q/wQBXEgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0401/1266] net/sched: sch_hfsc: annotate data-races in hfsc_dump_class_stats()
Date: Tue, 21 Jul 2026 17:13:58 +0200
Message-ID: <20260721152450.804535558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1ac51d02499195..11ae998cda3a85 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -715,7 +715,7 @@ init_vf(struct hfsc_class *cl, unsigned int len)
 			rtsc_min(&cl->cl_virtual, &cl->cl_fsc, cl->cl_vt, cl->cl_total);
 			cl->cl_vtadj = 0;
 
-			cl->cl_vtperiod++;  /* increment vt period */
+			WRITE_ONCE(cl->cl_vtperiod, cl->cl_vtperiod + 1);  /* increment vt period */
 			cl->cl_parentperiod = cl->cl_parent->cl_vtperiod;
 			if (cl->cl_parent->cl_nactive == 0)
 				cl->cl_parentperiod++;
@@ -757,7 +757,7 @@ update_vf(struct hfsc_class *cl, unsigned int len, u64 cur_time)
 		go_passive = 1;
 
 	for (; cl->cl_parent != NULL; cl = cl->cl_parent) {
-		cl->cl_total += len;
+		WRITE_ONCE(cl->cl_total, cl->cl_total + len);
 
 		if (!(cl->cl_flags & HFSC_FSC) || cl->cl_nactive == 0)
 			continue;
@@ -847,7 +847,7 @@ hfsc_adjust_levels(struct hfsc_class *cl)
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
 
 	if (gnet_stats_copy_basic(d, NULL, &cl->bstats, true) < 0 ||
 	    gnet_stats_copy_rate_est(d, &cl->rate_est) < 0 ||
@@ -1453,15 +1453,15 @@ hfsc_change_qdisc(struct Qdisc *sch, struct nlattr *opt,
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
@@ -1627,7 +1627,7 @@ hfsc_dequeue(struct Qdisc *sch)
 	bstats_update(&cl->bstats, skb);
 	update_vf(cl, qdisc_pkt_len(skb), cur_time);
 	if (realtime)
-		cl->cl_cumul += qdisc_pkt_len(skb);
+		WRITE_ONCE(cl->cl_cumul, cl->cl_cumul + qdisc_pkt_len(skb));
 
 	if (cl->cl_flags & HFSC_RSC) {
 		if (cl->qdisc->q.qlen != 0) {
-- 
2.53.0



