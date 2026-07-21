Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9974839768C;
	Tue, 21 Jul 2026 22:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673523; cv=none; b=Hu7sAz3V3PVrdMkv9QsILyYAqR/HogfLjofDQHNr1SbHsKvwosJZ0tXJNZzuqtykvPULkSZ1VsqenO9yrC0HRLuiywL6AUbXu3Yu3sbnKuYEke4BOoTC/x9WWjOENPwgg/i4e/ARxfyfYYRVdXa3Kwj0JB6NUDag1qSVjnFsMWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673523; c=relaxed/simple;
	bh=3bD6mdFqrrYLH9RsRg7VuHhxYmSPkW7nCytaBQblCT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V76Ugo+zVY4IJaZW0JavdbGg8vasGAJ3ps+GjTMjOjwrp9gkTNfHtOIwSAqDv+3tcn6shudHSV1BFQi0k38khF1ZpN3jMGkmO0cZqkU4EzmkUgBwVxLmixZysXsxNnEAs5w5TWiSDyEUfI3pB9jrRCq3ItLMISVGJM+ReUttApA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVrHnwxT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVrHnwxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2861F000E9;
	Tue, 21 Jul 2026 22:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673522;
	bh=AHoGTkXLDyWJ+Q71dTX9XjbqlI0/z/W32lC0QLa6r+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVrHnwxTVInPjoEYamML3KRLuSnkzk2MwlwGdbm9gkCHNKFb1cROcdbX1ND2heDeD
	 MS95dL9oDJ4Kr+dOFFrcUef0mJWlhoNbACAV3uJOljiSWy85qH26rncmFTJGsZq5OP
	 uBqm8gi7DM9ewqloA2iVPW22qenNrYrC8L3J/EPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/699] net/sched: sch_drr: annotate data-races around cl->deficit
Date: Tue, 21 Jul 2026 17:19:13 +0200
Message-ID: <20260721152400.073988892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7200895d98c01e..5b78ce01b1e7f5 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -270,7 +270,7 @@ static int drr_dump_class_stats(struct Qdisc *sch, unsigned long arg,
 
 	memset(&xstats, 0, sizeof(xstats));
 	if (qlen)
-		xstats.deficit = cl->deficit;
+		xstats.deficit = READ_ONCE(cl->deficit);
 
 	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
 				  d, NULL, &cl->bstats) < 0 ||
@@ -370,7 +370,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (!cl_is_active(cl)) {
 		list_add_tail(&cl->alist, &q->active);
-		cl->deficit = cl->quantum;
+		WRITE_ONCE(cl->deficit, cl->quantum);
 	}
 
 	sch->qstats.backlog += len;
@@ -397,7 +397,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 
 		len = qdisc_pkt_len(skb);
 		if (len <= cl->deficit) {
-			cl->deficit -= len;
+			WRITE_ONCE(cl->deficit, cl->deficit - len);
 			skb = qdisc_dequeue_peeked(cl->qdisc);
 			if (unlikely(skb == NULL))
 				goto out;
@@ -411,7 +411,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			return skb;
 		}
 
-		cl->deficit += cl->quantum;
+		WRITE_ONCE(cl->deficit, cl->deficit + cl->quantum);
 		list_move_tail(&cl->alist, &q->active);
 	}
 out:
-- 
2.53.0



