Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F92E3B42CE;
	Tue, 21 Jul 2026 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665849; cv=none; b=YPeBiQTqFr6cYkvEzgqE3rXov9MQGyTXy6p3mmtigMkelR2YDAebzkPXXjDa+W7J0PahHikjuoMc/T88iaMGVE8r+svNGvqO6IXK0JHYckPp1CVFgxsakORuKvDdJ5nx8EgUt3KjXFdv2EmyUZI+yo4jGQqu/rZENey4tNZ34QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665849; c=relaxed/simple;
	bh=LoBIC/+U/NaZ+ZlchuKWNXnWwqvjUemG21nhhGnleEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j11YvsjMiJszTD43iBTSLIVdUzLRyJh4r7J4hJyyqCWXFz5Ud9Bray8F6RS8TqqRUtzVWsDblGyj8u/GlMhVunDDvJaQPEH+dw6i0zeO1pxqS8knqfjQ/Btd/729j4w+GJdbT5xgQpjWJhqCFGsXN3MF8JibmANaE31w9pqA5c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahN2X6yA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahN2X6yA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CDC1F000E9;
	Tue, 21 Jul 2026 20:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665848;
	bh=En+6SYwMnUW+aYO/8RCOVXYW51aKs3v9oxydg35eHKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahN2X6yA8228cW1VAaN/cWIrcsJM4XdX4L2SECFZ4geHloYOq0gfWTuckTAuz7IsS
	 FKYUFFrWDIc1hTmoe1+fscGy51xeLNgJVZpV+WKvy255ybuaUfJZuHjjrmydMdAOCb
	 5k6Aflntm672dFU/pEBbN9yTE8JyUGGUeoSNbJ8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0416/1266] net/sched: sch_drr: annotate data-races around cl->deficit
Date: Tue, 21 Jul 2026 17:14:13 +0200
Message-ID: <20260721152451.147417762@linuxfoundation.org>
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
index 9b36955e32b142..9a7d9b14bc8821 100644
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



