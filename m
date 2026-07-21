Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A78344AB9E;
	Tue, 21 Jul 2026 21:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668793; cv=none; b=dDezm2FTFAgayHRmytEw0d0IzmhSiDRwRlC7EleHHtf1viCdB0nTXk4o5XgoUqP/UmIV70y18xhmmnFGypysTxvy/og4Kqx0IROSKuL7+ZiYQHmH9zwPidXI/iWlmNurb+r0UWYqFAI6dfFRPdti9nFPBa0FZfYaF2fyoQqSKsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668793; c=relaxed/simple;
	bh=25ktynxvrJqdgUop9bSzgI8B4P1FWXLWaURm82GFkTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQ5R8uGUGNSZTgOg3ZisMvlVzmd0H2pV0Ghx0baI3uko4HbxOSmFR7ToNdT5gy6t0RL4NEVtWA+nTwO8oIaKi9sZnE/9Q+DnnMf1ij7l6Zzfypp9Bz5mxA1ntZYRyTm/09LeKoxwnsThxstTxQK14t599ficafT4/akXoJMKdFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ph/fL2j1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ph/fL2j1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB241F00A3A;
	Tue, 21 Jul 2026 21:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668792;
	bh=zGWh4qSvpVHj+3+jbYATXudEidLOb9V22nzhZWjJ9u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ph/fL2j1PjLop71kyvoeAoTjzir5EVdh0Bqxsc3VPBU0W9kc69WwQa65S/PO5yfql
	 Zd54nyb1zPVD1c/TMY30tn4VS8wI5/1hqDXk/hBoH0mlCo4pqvKaKnAEmVARHjWNQS
	 rsvJta3J1kBXaLKus3a/Ktn/6RciEjUXn87rxPKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0310/1067] net/sched: sch_htb: annotate data-races (I)
Date: Tue, 21 Jul 2026 17:15:11 +0200
Message-ID: <20260721152431.529439886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e54c33503bf7cebb1c1790251ce90f1252678081 ]

htb_dump() runs without holding qdisc spinlock.

Add missing READ_ONCE()/WRITE_ONCE() annotations around
q->overlimits and q->direct_pkts.

Fixes: edb09eb17ed8 ("net: sched: do not acquire qdisc spinlock in qdisc/class stats dump")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260514095935.3926276-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 99e1a4c1fcb13d..0ce8bdf8726769 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -565,7 +565,7 @@ htb_change_class_mode(struct htb_sched *q, struct htb_class *cl, s64 *diff)
 
 	if (new_mode == HTB_CANT_SEND) {
 		cl->overlimits++;
-		q->overlimits++;
+		WRITE_ONCE(q->overlimits, q->overlimits + 1);
 	}
 
 	if (cl->prio_activity) {	/* not necessary: speed optimization */
@@ -625,7 +625,7 @@ static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		/* enqueue to helper queue */
 		if (q->direct_queue.qlen < q->direct_qlen) {
 			__qdisc_enqueue_tail(skb, &q->direct_queue);
-			q->direct_pkts++;
+			WRITE_ONCE(q->direct_pkts, q->direct_pkts + 1);
 		} else {
 			return qdisc_drop(skb, sch, to_free);
 		}
@@ -1206,12 +1206,12 @@ static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nest;
 	struct tc_htb_glob gopt;
 
-	sch->qstats.overlimits = q->overlimits;
+	sch->qstats.overlimits = READ_ONCE(q->overlimits);
 	/* Its safe to not acquire qdisc lock. As we hold RTNL,
 	 * no change can happen on the qdisc parameters.
 	 */
 
-	gopt.direct_pkts = q->direct_pkts;
+	gopt.direct_pkts = READ_ONCE(q->direct_pkts);
 	gopt.version = HTB_VER;
 	gopt.rate2quantum = q->rate2quantum;
 	gopt.defcls = q->defcls;
-- 
2.53.0



