Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575EF42A7B4;
	Tue, 21 Jul 2026 20:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665712; cv=none; b=Ok5sbuaoO7EG31UOevjzjn24gsUVPDSPz3CZTmYceBCBcxMeOOmDwgGLo88A20SXUjSFzVUjzYwxEDf9ASfu0cDtk58kKPVjD+0K1lOHkUOs9a9JJUYs+Iy0TI+xQcc4r5d0cC7lugbxfcCjfT204isVmhgV8aa4A/gLCwcECIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665712; c=relaxed/simple;
	bh=+dOCh9sy7aP4u/3PrZNqCjbmUHRxYIRycqd4xMopu4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSjNiRCSxjvuJlOOTX6XvXRBSJ+kaOt+kvTPZ43XFXQb6jLR9go9fNfusZucJh+symlbJwsmUQyNf15zEYKsgMcwRGmuaTDSqnp1gvrUdlr8qzHTxWA/G+kbQtsUrV3Tw0wQeQraQ1sYLVBRnw9D6A2zDO4iQ/z1L3Ob6bjk/9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGaIBsWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGaIBsWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635901F000E9;
	Tue, 21 Jul 2026 20:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665710;
	bh=ABVzzJ9Se9VJD/d5skfh9wEloSEvzom55GwOBxP1iqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGaIBsWZIe0bltLdxBoO09cOcWwQDgI1O9N3rXyVhDyDwJYsL3p7lCFzBvOcF2p67
	 qYvp2eWJpVVcKyqkU0zd4HAEaKTal2u9BOEmirSi1bFAxRirq9Cp00rgiVFQi1cpXY
	 Khkh8PEC38XsbvEET1UMItOSEsI2mJr3CtTPYxa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0405/1266] net/sched: sch_htb: annotate data-races (I)
Date: Tue, 21 Jul 2026 17:14:02 +0200
Message-ID: <20260721152450.895713572@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2388c1213e1d26..f1b903b3671748 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -568,7 +568,7 @@ htb_change_class_mode(struct htb_sched *q, struct htb_class *cl, s64 *diff)
 
 	if (new_mode == HTB_CANT_SEND) {
 		cl->overlimits++;
-		q->overlimits++;
+		WRITE_ONCE(q->overlimits, q->overlimits + 1);
 	}
 
 	if (cl->prio_activity) {	/* not necessary: speed optimization */
@@ -628,7 +628,7 @@ static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		/* enqueue to helper queue */
 		if (q->direct_queue.qlen < q->direct_qlen) {
 			__qdisc_enqueue_tail(skb, &q->direct_queue);
-			q->direct_pkts++;
+			WRITE_ONCE(q->direct_pkts, q->direct_pkts + 1);
 		} else {
 			return qdisc_drop(skb, sch, to_free);
 		}
@@ -1209,12 +1209,12 @@ static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
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



