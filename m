Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F0235EDBD;
	Tue, 21 Jul 2026 17:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655920; cv=none; b=m8roKqENAbXtcuA8NVItt1kwoMWFJFrrQAomxVnSsaFBZdMI5pFDNtlYVntF+crHBj149j1CshctMFMORyy0Yt0rFOQVKJMA4MiGSF+W2iLlOZl+c+XoDDPjIaIDZ3u4DfMmlFgYqb4H+vslXC8gQPpAj1vizyk8bpl+Joa50ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655920; c=relaxed/simple;
	bh=ipl9d7s4sUd+r8/qcrAs59h1NPOxuTdwW8o2M2YDEz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uvcESUpK67v5EhsSHhzCyqg07BAER5wOPkdQF/k/JtyaD12PBGjP7MC4yKJBj4PoY6MT92Efc+ENtyMmaZRfFK4CtahrL59QfowBaWUBUL1rZKe4WUVfRPIMDy7XBn3xynHSBuW/GKAGxvwznmepiNcskKMc96Yc4ffkCHUn4R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnfeccOY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnfeccOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2D81F000E9;
	Tue, 21 Jul 2026 17:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655919;
	bh=WsbZ5xT1VmHrleK3h5LsvmFMuGOt43f2SS7wAaJigoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnfeccOYESkVmRl2BF614OxMWINwuPq5XKmKjSbGsH849xQEC8vMyEaiX1proIDyg
	 9DRGPbH3J1jlyZDQwrfJ+dliPLV43WAJaM4dRh0oy5aOJY/Wek/Gcssq6RaP/B+27R
	 9zgj5IcM23QWsLvcrWGHSelR799B3FrybORz16Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0147/1611] net/sched: sch_hfsc: annotate data-races in hfsc_dump_class_stats()
Date: Tue, 21 Jul 2026 17:04:23 +0200
Message-ID: <20260721152518.185463521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 57221522fe56d2..9c6e6d2b47f8e3 100644
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
 
@@ -1338,10 +1338,10 @@ hfsc_dump_class_stats(struct Qdisc *sch, unsigned long arg,
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
@@ -1452,15 +1452,15 @@ hfsc_change_qdisc(struct Qdisc *sch, struct nlattr *opt,
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
@@ -1626,7 +1626,7 @@ hfsc_dequeue(struct Qdisc *sch)
 	bstats_update(&cl->bstats, skb);
 	update_vf(cl, qdisc_pkt_len(skb), cur_time);
 	if (realtime)
-		cl->cl_cumul += qdisc_pkt_len(skb);
+		WRITE_ONCE(cl->cl_cumul, cl->cl_cumul + qdisc_pkt_len(skb));
 
 	if (cl->cl_flags & HFSC_RSC) {
 		if (cl->qdisc->q.qlen != 0) {
-- 
2.53.0



