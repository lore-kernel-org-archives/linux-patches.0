Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B1447124F;
	Sat, 12 Sep 2026 11:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212294; cv=none; b=sh+Bo8bI/oVKM5FQCoPtDLe+Du4S/oxYC1IRRmX32SMEipw49e2fRoR0rQFduxWcxgUezZhoAY8x3N5VyX0kHOTKmeajKLqSZtJubwYVVg0mk8Fvdj1e6wbs2UJtLKbfkpIvtR2BcpuYH/T/2S9PeyGugHOqHqHdjebEAwoj25Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212294; c=relaxed/simple;
	bh=59ITyRZ4DiAR3E27hY5lxui7AEGk0uQVv7iS+SBW21g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlLeKuT8XgnzoXHIm0SPuLZCfwjHQQVDBk6BdrX6SXNomXObiwVoSVG2iYzTsGynLQit4zEB6t0aufT6XbbUONzQmwFusQeVVBdWRKkv5+jw0+ItnKZEEKSUuZF8TpCNyEEkEJTQta/wQKgN6jpL88KCz+JlUNi7a86gp+ophwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5dBPFHA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5dBPFHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266521F000FF;
	Sat, 12 Sep 2026 11:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212292;
	bh=kDX8ptHwXVULxWcHOtzIHDh1OnuPGONRh94LnX0+XQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5dBPFHASQM6NSXrxGCaTSevgj/GaV0xhr1malMUO9noHE6TulPJAyb5S4HI3x5se
	 4O+yCDiGIpQ7Y4Vy+Pnrru1CKvx48ZDZHvPe1sGBQiQNK9RVmb+MaazCVwV53MlTsZ
	 lqr2r14RXDJ/CRuCgfgf8EcIjfan4yivREHpyK0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1406/1518] net/sched: add qstats_cpu_drop_inc() helper
Date: Sat, 12 Sep 2026 08:59:35 +0200
Message-ID: <20260912065655.353729137@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 3f3aa77ff1c8b45ec8c9e40212f1a24a93e00df3 ]

1) Using this_cpu_inc() is better than going through this_cpu_ptr():

- Single instruction on x86.
- Store tearing prevention.

2) Change tcf_action_update_stats() to use this_cpu_add().

3) Add WRITE_ONCE() to __qdisc_qstats_drop() and qstats_drop_inc()
   in preparation for lockless "tc qdisc show".

$ scripts/bloat-o-meter -t vmlinux.old vmlinux.new
add/remove: 0/0 grow/shrink: 3/17 up/down: 72/-216 (-144)
Function                                     old     new   delta
dualpi2_enqueue_skb                          462     511     +49
tcf_ife_act                                 1061    1077     +16
taprio_enqueue                               613     620      +7
codel_qdisc_enqueue                          149     143      -6
tcf_vlan_act                                 684     676      -8
tcf_skbedit_act                              626     618      -8
tcf_police_act                               725     717      -8
tcf_mpls_act                                1297    1289      -8
tcf_gate_act                                 310     302      -8
tcf_gact_act                                 222     214      -8
tcf_csum_act                                2438    2430      -8
tcf_bpf_act                                  709     701      -8
tcf_action_update_stats                      124     115      -9
pie_qdisc_enqueue                            865     856      -9
pfifo_enqueue                                116     107      -9
choke_enqueue                               2069    2059     -10
plug_enqueue                                 139     128     -11
bfifo_enqueue                                121     110     -11
tcf_nat_act                                 1501    1489     -12
gred_enqueue                                1743    1668     -75
Total: Before=24388609, After=24388465, chg -0.00%

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260501135916.2566766-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5b483f7791b0 ("net/sched: act_ife: Only operate on Ethernet frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/act_api.h     | 2 +-
 include/net/sch_generic.h | 9 +++++++--
 net/sched/act_api.c       | 2 +-
 net/sched/act_bpf.c       | 2 +-
 net/sched/act_ife.c       | 8 ++++----
 net/sched/act_mpls.c      | 2 +-
 net/sched/act_police.c    | 2 +-
 net/sched/act_skbedit.c   | 2 +-
 net/sched/sch_cake.c      | 2 +-
 net/sched/sch_fq_codel.c  | 2 +-
 net/sched/sch_gred.c      | 2 +-
 11 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 1ef22d70553bf..bac933abcd4cc 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -242,7 +242,7 @@ static inline void tcf_action_update_bstats(struct tc_action *a,
 static inline void tcf_action_inc_drop_qstats(struct tc_action *a)
 {
 	if (likely(a->cpu_qstats)) {
-		qstats_drop_inc(this_cpu_ptr(a->cpu_qstats));
+		qstats_cpu_drop_inc(a->cpu_qstats);
 		return;
 	}
 	atomic_inc(&a->tcfa_drops);
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index b15a0cdf101b9..cf1923f8cb524 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -967,12 +967,17 @@ static inline void qdisc_qstats_cpu_requeues_inc(struct Qdisc *sch)
 
 static inline void __qdisc_qstats_drop(struct Qdisc *sch, int count)
 {
-	sch->qstats.drops += count;
+	WRITE_ONCE(sch->qstats.drops, sch->qstats.drops + count);
 }
 
 static inline void qstats_drop_inc(struct gnet_stats_queue *qstats)
 {
-	qstats->drops++;
+	WRITE_ONCE(qstats->drops, qstats->drops + 1);
+}
+
+static inline void qstats_cpu_drop_inc(struct gnet_stats_queue __percpu *qstats)
+{
+	this_cpu_inc(qstats->drops);
 }
 
 static inline void qstats_overlimit_inc(struct gnet_stats_queue *qstats)
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 3909715bbf76c..6fc6a986a7991 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1581,7 +1581,7 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 	if (a->cpu_bstats) {
 		_bstats_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
 
-		this_cpu_ptr(a->cpu_qstats)->drops += drops;
+		this_cpu_add(a->cpu_qstats->drops, drops);
 
 		if (hw)
 			_bstats_update(this_cpu_ptr(a->cpu_bstats_hw),
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index e99b9269ea1a9..06d8f78b73683 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -76,7 +76,7 @@ TC_INDIRECT_SCOPE int tcf_bpf_act(struct sk_buff *skb,
 		break;
 	case TC_ACT_SHOT:
 		action = filter_res;
-		qstats_drop_inc(this_cpu_ptr(prog->common.cpu_qstats));
+		qstats_cpu_drop_inc(prog->common.cpu_qstats);
 		break;
 	case TC_ACT_UNSPEC:
 		action = prog->tcf_action;
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index a90d7959fc432..3333714b68650 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -727,7 +727,7 @@ static int tcf_ife_decode(struct sk_buff *skb, const struct tc_action *a,
 
 	tlv_data = ife_decode(skb, &metalen);
 	if (unlikely(!tlv_data)) {
-		qstats_drop_inc(this_cpu_ptr(ife->common.cpu_qstats));
+		qstats_cpu_drop_inc(ife->common.cpu_qstats);
 		return TC_ACT_SHOT;
 	}
 
@@ -740,7 +740,7 @@ static int tcf_ife_decode(struct sk_buff *skb, const struct tc_action *a,
 		curr_data = ife_tlv_meta_decode(tlv_data, ifehdr_end, &mtype,
 						&dlen, NULL);
 		if (!curr_data) {
-			qstats_drop_inc(this_cpu_ptr(ife->common.cpu_qstats));
+			qstats_cpu_drop_inc(ife->common.cpu_qstats);
 			return TC_ACT_SHOT;
 		}
 
@@ -755,7 +755,7 @@ static int tcf_ife_decode(struct sk_buff *skb, const struct tc_action *a,
 	}
 
 	if (WARN_ON(tlv_data != ifehdr_end)) {
-		qstats_drop_inc(this_cpu_ptr(ife->common.cpu_qstats));
+		qstats_cpu_drop_inc(ife->common.cpu_qstats);
 		return TC_ACT_SHOT;
 	}
 
@@ -821,7 +821,7 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
 	 * so lets be conservative.. */
 	if ((action == TC_ACT_SHOT) || exceed_mtu) {
 drop:
-		qstats_drop_inc(this_cpu_ptr(ife->common.cpu_qstats));
+		qstats_cpu_drop_inc(ife->common.cpu_qstats);
 		return TC_ACT_SHOT;
 	}
 
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 6654011dcd2ba..758a13f53213f 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -123,7 +123,7 @@ TC_INDIRECT_SCOPE int tcf_mpls_act(struct sk_buff *skb,
 	return p->action;
 
 drop:
-	qstats_drop_inc(this_cpu_ptr(m->common.cpu_qstats));
+	qstats_cpu_drop_inc(m->common.cpu_qstats);
 	return TC_ACT_SHOT;
 }
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 775e8b1840434..e5fb45ad76bfe 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -316,7 +316,7 @@ TC_INDIRECT_SCOPE int tcf_police_act(struct sk_buff *skb,
 	qstats_overlimit_inc(this_cpu_ptr(police->common.cpu_qstats));
 inc_drops:
 	if (ret == TC_ACT_SHOT)
-		qstats_drop_inc(this_cpu_ptr(police->common.cpu_qstats));
+		qstats_cpu_drop_inc(police->common.cpu_qstats);
 end:
 	return ret;
 }
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 5450c1293eb50..8691fe1e67da8 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -86,7 +86,7 @@ TC_INDIRECT_SCOPE int tcf_skbedit_act(struct sk_buff *skb,
 	return params->action;
 
 err:
-	qstats_drop_inc(this_cpu_ptr(d->common.cpu_qstats));
+	qstats_cpu_drop_inc(d->common.cpu_qstats);
 	return TC_ACT_SHOT;
 }
 
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index e03fe7096b357..8ed8ac120693d 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1829,7 +1829,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		if (ack) {
 			WRITE_ONCE(b->ack_drops, b->ack_drops + 1);
-			sch->qstats.drops++;
+			qdisc_qstats_drop(sch);
 			ack_pkt_len = qdisc_pkt_len(ack);
 			b->bytes += ack_pkt_len;
 			q->buffer_used += skb->truesize - ack->truesize;
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 3548985bbd422..c708445a649e7 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -176,7 +176,7 @@ static unsigned int fq_codel_drop(struct Qdisc *sch, unsigned int max_packets,
 	flow->cvars.count += i;
 	q->backlogs[idx] -= len;
 	q->memory_usage -= mem;
-	sch->qstats.drops += i;
+	__qdisc_qstats_drop(sch, i);
 	sch->qstats.backlog -= len;
 	sch->q.qlen -= i;
 	return idx;
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 8503621289bb5..9185b361dd78e 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -389,7 +389,7 @@ static int gred_offload_dump_stats(struct Qdisc *sch)
 		packets += u64_stats_read(&hw_stats->stats.bstats[i].packets);
 		sch->qstats.qlen += hw_stats->stats.qstats[i].qlen;
 		sch->qstats.backlog += hw_stats->stats.qstats[i].backlog;
-		sch->qstats.drops += hw_stats->stats.qstats[i].drops;
+		__qdisc_qstats_drop(sch, hw_stats->stats.qstats[i].drops);
 		sch->qstats.requeues += hw_stats->stats.qstats[i].requeues;
 		sch->qstats.overlimits += hw_stats->stats.qstats[i].overlimits;
 	}
-- 
2.53.0



