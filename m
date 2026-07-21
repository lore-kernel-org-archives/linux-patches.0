Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255D840B112;
	Tue, 21 Jul 2026 17:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655894; cv=none; b=LHzJe+FUw/PsLACEfNI2jdeluVN/cOMA6dnI/HJIDN4Hb79898GKJzKnmQxl7OJYamt1sFNgebmZuszdJ5Ped/MVJZ67g3RCtf+VRK5BOKu9eN4jieVK18sD9FhTuf0uhGXfdJmEnbiOD/yZQoCk87eemtRdmty+ati9RfJj+2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655894; c=relaxed/simple;
	bh=U3nuXhzyvKZwLSgDvheSPWweab2adfTZeKFoso6yaNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHc1XcTd/lWi1YWZ5yPT+l4eWKPm6CUP3gFlUY7h91WCjU01WCrPK/T7OQIPqDJ+yiN/8wSDndnShq0uG1kjYWeaV3k5nqQthlfCcfw1Qr62G1vvrDHoU5zu2ct07nl8vhbNpxiC7zbkrbW3ZHBGtXla81OA3uUuNT3gmCsn7yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FH8UZJxF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FH8UZJxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3CA1F000E9;
	Tue, 21 Jul 2026 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655892;
	bh=74+ZXTxyplXSgP2UQRrS9ZvtMlzfd0DcpoRZu9u2U34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FH8UZJxFGDbl8qKR9/0+a1Z8/dm3VAdDZaCwkxVgzv3qP+PeAVTbJwjPL4/ZZu16z
	 ubi3e8XPdExXhhr/Kpt4NlI4cX35py9dMNmRVUdS+EkU7icNftgLOOZ2HKQiurQ/Pa
	 VK94cTggDCb0DL66ljxyMXyAzWgr6Kat6CneDlhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0180/1611] net/sched: sch_drr: annotate data-races around cl->deficit
Date: Tue, 21 Jul 2026 17:04:56 +0200
Message-ID: <20260721152518.968265364@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c67b104fd7982162885c5e43057ca761006748e2 ]

drr_dump_class_stats() runs without qdisc spinlock held.

Add missing READ_ONCE()/WRITE_ONCE() annotations around cl->deficit.

Fixes: edb09eb17ed8 ("net: sched: do not acquire qdisc spinlock in qdisc/class stats dump")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260519094618.2632073-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_drr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 9b6d79bd873712..44686fd1c27497 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -270,7 +270,7 @@ static int drr_dump_class_stats(struct Qdisc *sch, unsigned long arg,
 
 	memset(&xstats, 0, sizeof(xstats));
 	if (qlen)
-		xstats.deficit = cl->deficit;
+		xstats.deficit = READ_ONCE(cl->deficit);
 
 	if (gnet_stats_copy_basic(d, NULL, &cl->bstats, true) < 0 ||
 	    gnet_stats_copy_rate_est(d, &cl->rate_est) < 0 ||
@@ -362,7 +362,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (!cl_is_active(cl)) {
 		list_add_tail(&cl->alist, &q->active);
-		cl->deficit = cl->quantum;
+		WRITE_ONCE(cl->deficit, cl->quantum);
 	}
 
 	sch->qstats.backlog += len;
@@ -389,7 +389,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 
 		len = qdisc_pkt_len(skb);
 		if (len <= cl->deficit) {
-			cl->deficit -= len;
+			WRITE_ONCE(cl->deficit, cl->deficit - len);
 			skb = qdisc_dequeue_peeked(cl->qdisc);
 			if (unlikely(skb == NULL))
 				goto out;
@@ -403,7 +403,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			return skb;
 		}
 
-		cl->deficit += cl->quantum;
+		WRITE_ONCE(cl->deficit, cl->deficit + cl->quantum);
 		list_move_tail(&cl->alist, &q->active);
 	}
 out:
-- 
2.53.0



