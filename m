Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B68F370AFB;
	Tue, 21 Jul 2026 22:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671447; cv=none; b=rko0lAR+siUv3YKOR78u1McSNcqjwUnUc6A4sS1ONK2nnulgMAr2IwyjQ3zSjpSQiZJtvkWdDAEDw+1/4rGyAxT+WZwfak9FvsD7AMlHcGnhMhJhapjyeFCXGX5YqwldpbAHrH9gRoBV4ErjzZf3rgRe2jeWOZfCO5T0ZO44RrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671447; c=relaxed/simple;
	bh=CtzeD9Au0sk2Bxvca0HPc7xxcWrG7MLlTryk3nXLjjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ay5r+Mx51A1mpRES2rBLOHtCyH1mtccwLAV5kfiNexxWsGRbIj9ykoh/c4rvyZCaSAMckyNei5YIbaC3mpIcySdzAbwy6/rQ4bveWpmi3uCk65Sjq9ec6mgzc8KEaaKCvpWumcCIkxRPZng63+pzDeqWkrTVMYe6lsKe6sdsVkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RL33D20w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RL33D20w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF071F000E9;
	Tue, 21 Jul 2026 22:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671445;
	bh=ZtITLX4HsVyQHyjZXpi4zELR546fFyBDszVbzsuj1OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RL33D20wQTcIhoZrlBkJiOb2Y6mQCEZZc29PvvTtlvRc8KhbnheUUMUj/gIMlEakE
	 CZMhR9j3unrHSv/42ztJ4JCNCKIP4S36UxeOsNDRawRbYxMAWsEhxTxalLoEsh5N1w
	 8gojdPDUXwuD5KlQVigBpgMEfAsWr0EdfXhdnqUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/843] net/sched: sch_drr: annotate data-races around cl->deficit
Date: Tue, 21 Jul 2026 17:18:03 +0200
Message-ID: <20260721152411.599295849@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5a543d35d53b8d..a2b9802d41c010 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -271,7 +271,7 @@ static int drr_dump_class_stats(struct Qdisc *sch, unsigned long arg,
 
 	memset(&xstats, 0, sizeof(xstats));
 	if (qlen)
-		xstats.deficit = cl->deficit;
+		xstats.deficit = READ_ONCE(cl->deficit);
 
 	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
 				  d, NULL, &cl->bstats) < 0 ||
@@ -371,7 +371,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (!cl_is_active(cl)) {
 		list_add_tail(&cl->alist, &q->active);
-		cl->deficit = cl->quantum;
+		WRITE_ONCE(cl->deficit, cl->quantum);
 	}
 
 	sch->qstats.backlog += len;
@@ -398,7 +398,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 
 		len = qdisc_pkt_len(skb);
 		if (len <= cl->deficit) {
-			cl->deficit -= len;
+			WRITE_ONCE(cl->deficit, cl->deficit - len);
 			skb = qdisc_dequeue_peeked(cl->qdisc);
 			if (unlikely(skb == NULL))
 				goto out;
@@ -412,7 +412,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			return skb;
 		}
 
-		cl->deficit += cl->quantum;
+		WRITE_ONCE(cl->deficit, cl->deficit + cl->quantum);
 		list_move_tail(&cl->alist, &q->active);
 	}
 out:
-- 
2.53.0



