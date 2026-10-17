Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1B13CAE99;
	Sat, 17 Oct 2026 18:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260038; cv=none; b=WYR8yRNwiT3JWIwmE9XT3Watan5jAskn8WK4r9XkZnrlvDqCbYXOphkUYZGaTXRXUuvEXo0Uwzc/hpzzNckX/uHbCNbra3gvrxKyB63O5cUm1WZ/xrUjcACk/HPsmdF1ZuzOib3oqxhU0jNXj5hHI42T0A3FvYxiBfx162f3KNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260038; c=relaxed/simple;
	bh=L9u4QlpWYE6GsNf1c6HzVD9vdLYhnewPJ+7FvWqU/1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSLf7g65IFlVHZTTN/vMbEJHUICvZ1gER4xuH8wEvhejocwaxSrAKOWEzPTQI4f68GU2VWUbX4adXPrVf/oBHp/Wn276OUkZVPBlWSeRaGJCyNT7rrCcR5paJ0bjmtsYnHB30V/2KFtgI1BxFGlXbiMe6TgvCG0Mxo6fDvb86Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AowCtr7c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AowCtr7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2697D1F000C4;
	Sat, 17 Oct 2026 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260037;
	bh=b7e0kfaxaeAlHRlEGPj0gnhpsosZS6Tcik9FH/MwIZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AowCtr7cWX2NCpbHP+jnQL4/JHQzzgCxmsjwwLCktxCnMrTktWBzKdAIyvjXlhfkv
	 osEj2C7JYWOdlvIRjYz1Ili/6rvkS4zU8eN/RrcDQOS/N6aZjKdjWGxf1YoCm0HoDv
	 oq9rxlRwoCl+IHz9lVF8h/mh7Fv8jvzyPbX3966o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1371/1674] net_sched: sch_fq: change how @inactive is tracked
Date: Sat, 17 Oct 2026 18:00:43 +0200
Message-ID: <20261017160506.351627098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit ee9af4e14d166c34ec78896bb1ba545249445df0 ]

Currently, when one fq qdisc has no more packets to send, it can still
have some flows stored in its RR lists (q->new_flows & q->old_flows)

This was a design choice, but what is a bit disturbing is that
the inactive_flows counter does not include the count of empty flows
in RR lists.

As next patch needs to know better if there are active flows,
this change makes inactive_flows exact.

Before the patch, following command on an empty qdisc could have returned:

lpaa17:~# tc -s -d qd sh dev eth1 | grep inactive
  flows 1322 (inactive 1316 throttled 0)
  flows 1330 (inactive 1325 throttled 0)
  flows 1193 (inactive 1190 throttled 0)
  flows 1208 (inactive 1202 throttled 0)

After the patch, we now have:

lpaa17:~# tc -s -d qd sh dev eth1 | grep inactive
  flows 1322 (inactive 1322 throttled 0)
  flows 1330 (inactive 1330 throttled 0)
  flows 1193 (inactive 1193 throttled 0)
  flows 1208 (inactive 1208 throttled 0)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 709f34f7c28d ("net/sched: fq: add overflow bounds to quantum and initial quantum")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 9ea2735df4f75..a99950d8baa1b 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -125,7 +125,7 @@ struct fq_sched_data {
 /* Read/Write fields. */
 
 	u32		flows;
-	u32		inactive_flows;
+	u32		inactive_flows; /* Flows with no packet to send. */
 	u32		throttled_flows;
 
 	u64		stat_throttled;
@@ -402,9 +402,12 @@ static void fq_erase_head(struct Qdisc *sch, struct fq_flow *flow,
 static void fq_dequeue_skb(struct Qdisc *sch, struct fq_flow *flow,
 			   struct sk_buff *skb)
 {
+	struct fq_sched_data *q = qdisc_priv(sch);
+
 	fq_erase_head(sch, flow, skb);
 	skb_mark_not_on_list(skb);
-	flow->qlen--;
+	if (--flow->qlen == 0)
+		q->inactive_flows++;
 	qdisc_qstats_backlog_dec(sch, skb);
 	sch->q.qlen--;
 }
@@ -484,13 +487,13 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		return qdisc_drop(skb, sch, to_free);
 	}
 
-	f->qlen++;
+	if (f->qlen++ == 0)
+		q->inactive_flows--;
 	qdisc_qstats_backlog_inc(sch, skb);
 	if (fq_flow_is_detached(f)) {
 		fq_flow_add_tail(&q->new_flows, f);
 		if (time_after(jiffies, f->age + q->flow_refill_delay))
 			f->credit = max_t(u32, f->credit, q->quantum);
-		q->inactive_flows--;
 	}
 
 	/* Note: this overwrites f->age */
@@ -597,7 +600,6 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 			fq_flow_add_tail(&q->old_flows, f);
 		} else {
 			fq_flow_set_detached(f);
-			q->inactive_flows++;
 		}
 		goto begin;
 	}
-- 
2.53.0



