Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346163DA7C6;
	Wed, 20 May 2026 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296553; cv=none; b=EvQ7ZppInMyqWIiBGLPrWDQ+Z5WAHFuuKLeJEpNTHsvQl2ltf5nsOoQz66Bw4GHXqxybKL8uUXlfyK30VTyNXFTWoYoNbFIle8CUrcdpAaLFz54SqGw0ysmIKaGiySApZn6nGwUmLLIzSylarv2unrYOVWj5zw3xUWu/pWBP0aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296553; c=relaxed/simple;
	bh=r7RsjlJZTyHPBa7eZ8Z7TpciEWvBfPy/z5xmv4V8EAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD5TqdyNTdaLO9rKzS4skPrbh1Hem7ACoZUlDtMDiSj8dmuRM5IPSj9kmatZ9sswJRmUMCXFZJBcYc30mx5eAORYbGBWoASCrTrQWoxewtvgutLMhDhjk5CDrBvoDGShazI3Bdb3w+u1y7Z/3UfTi0x+Nh9Vb58L3VgkSTfkFWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BieEDwDD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BieEDwDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645621F00893;
	Wed, 20 May 2026 17:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296550;
	bh=yRn9t95SN8fHaMB8Kv2MYRTggMTYTYK8xgYY3U5MlR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BieEDwDDykn6igeu3APd5ZrNHUopIDyjvwZyQCKci3ytf9RmKj5L64EsA9uyM4v9M
	 fX2SGmZyRDxADzS2OkM5wiYmawQgU5WxcdKmzzcby9NVVKYrQjy0tD1v5+CuaINuSH
	 NqM3Wt4jeJV7XD5x1jvBgqJDJ5pfwuimomVrLkY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0842/1146] net/sched: sch_red: annotate data-races in red_dump_stats()
Date: Wed, 20 May 2026 18:18:12 +0200
Message-ID: <20260520162207.290245598@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a8f5192809caf636d05ba47c144f282cfd0e3839 ]

red_dump_stats() only runs with RTNL held,
reading fields that can be changed in qdisc fast path.

Add READ_ONCE()/WRITE_ONCE() annotations.

Alternative would be to acquire the qdisc spinlock, but our long-term
goal is to make qdisc dump operations lockless as much as we can.

tc_red_xstats fields don't need to be latched atomically,
otherwise this bug would have been caught earlier.

Fixes: edb09eb17ed8 ("net: sched: do not acquire qdisc spinlock in qdisc/class stats dump")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260421142309.3964322-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_red.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 68ee41ce78c50..86651a68d4015 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -90,17 +90,20 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	case RED_PROB_MARK:
 		qdisc_qstats_overlimit(sch);
 		if (!red_use_ecn(q)) {
-			q->stats.prob_drop++;
+			WRITE_ONCE(q->stats.prob_drop,
+				   q->stats.prob_drop + 1);
 			goto congestion_drop;
 		}
 
 		if (INET_ECN_set_ce(skb)) {
-			q->stats.prob_mark++;
+			WRITE_ONCE(q->stats.prob_mark,
+				   q->stats.prob_mark + 1);
 			skb = tcf_qevent_handle(&q->qe_mark, sch, skb, to_free, &ret);
 			if (!skb)
 				return NET_XMIT_CN | ret;
 		} else if (!red_use_nodrop(q)) {
-			q->stats.prob_drop++;
+			WRITE_ONCE(q->stats.prob_drop,
+				   q->stats.prob_drop + 1);
 			goto congestion_drop;
 		}
 
@@ -111,17 +114,20 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		reason = SKB_DROP_REASON_QDISC_OVERLIMIT;
 		qdisc_qstats_overlimit(sch);
 		if (red_use_harddrop(q) || !red_use_ecn(q)) {
-			q->stats.forced_drop++;
+			WRITE_ONCE(q->stats.forced_drop,
+				   q->stats.forced_drop + 1);
 			goto congestion_drop;
 		}
 
 		if (INET_ECN_set_ce(skb)) {
-			q->stats.forced_mark++;
+			WRITE_ONCE(q->stats.forced_mark,
+				   q->stats.forced_mark + 1);
 			skb = tcf_qevent_handle(&q->qe_mark, sch, skb, to_free, &ret);
 			if (!skb)
 				return NET_XMIT_CN | ret;
 		} else if (!red_use_nodrop(q)) {
-			q->stats.forced_drop++;
+			WRITE_ONCE(q->stats.forced_drop,
+				   q->stats.forced_drop + 1);
 			goto congestion_drop;
 		}
 
@@ -135,7 +141,8 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		sch->qstats.backlog += len;
 		sch->q.qlen++;
 	} else if (net_xmit_drop_count(ret)) {
-		q->stats.pdrop++;
+		WRITE_ONCE(q->stats.pdrop,
+			   q->stats.pdrop + 1);
 		qdisc_qstats_drop(sch);
 	}
 	return ret;
@@ -463,9 +470,13 @@ static int red_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 		dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_RED,
 					      &hw_stats_request);
 	}
-	st.early = q->stats.prob_drop + q->stats.forced_drop;
-	st.pdrop = q->stats.pdrop;
-	st.marked = q->stats.prob_mark + q->stats.forced_mark;
+	st.early = READ_ONCE(q->stats.prob_drop) +
+		   READ_ONCE(q->stats.forced_drop);
+
+	st.pdrop = READ_ONCE(q->stats.pdrop);
+
+	st.marked = READ_ONCE(q->stats.prob_mark) +
+		    READ_ONCE(q->stats.forced_mark);
 
 	return gnet_stats_copy_app(d, &st, sizeof(st));
 }
-- 
2.53.0



