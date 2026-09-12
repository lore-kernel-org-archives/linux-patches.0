Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073412E06E4;
	Sat, 12 Sep 2026 19:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240554; cv=none; b=f+GZAmwa96VcsarvY+jPQb47jQ0VPVtmFZ6PH6vhseYu5G46X2RSN6GO2qnbm/+3c2sotwTifoawgU3o5OsLvquK7z9AR0/MAL/oxIl6xphvigA1wP1Y2QD6YurWsMfEET9yfVodoD87UH78Hb1TPA2IncKnPTGslneEpG2CsqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240554; c=relaxed/simple;
	bh=XlBO/NQSbZ0y5ZBbh7GAeF9MslYQAM30fpSu9qTB7Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kw+MiZBgEUlCfTK6pAFGLp08yxc2U+Q5isiM4f0eBgoeoozT5y++mzb0oQFgiOeDAlLU4On5tbwcOWXJ+Ot00secM+CsZs2usc6JSQuDM6nZUzOss8YmJuDnrO/4yh6s1j1E6Q1AAuDVJxkcvjIRg06+gX4lV4sqUHjAkUlHj1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FO6BZMr6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FO6BZMr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43AB1F000FF;
	Sat, 12 Sep 2026 19:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240552;
	bh=dQQdNVC45ZQiiDgmYkca8DUvxFiYYgK/cQgGSlsz3GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FO6BZMr64dgJmtQ/pkEqfiCfmiQ9Yuvnzh9/R4ZS18SQ9Xls0wKPJ9kl0Fs/4ePXr
	 vybULqO1wO5pm8mL6Luy0yn5H8ziu2vwCp/Pqp+9G1WpqmG1UexdRHN/kuazw9smOw
	 B8L0aFDfVPOml+Vr28EUrPK8SdH/bQbAR+syL/jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 891/935] net_sched: sch_fq: struct sched_data reorg
Date: Sat, 12 Sep 2026 09:05:21 +0200
Message-ID: <20260912065547.248332988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

[ Upstream commit 54ff8ad69c6e93c0767451ae170b41c000e565dd ]

q->flows can be often modified, and q->timer_slack is read mostly.

Exchange the two fields, so that cache line countaining
quantum, initial_quantum, and other critical parameters
stay clean (read-mostly).

Move q->watchdog next to q->stat_throttled

Add comments explaining how the structure is split in
three different parts.

pahole output before the patch:

struct fq_sched_data {
	struct fq_flow_head        new_flows;            /*     0  0x10 */
	struct fq_flow_head        old_flows;            /*  0x10  0x10 */
	struct rb_root             delayed;              /*  0x20   0x8 */
	u64                        time_next_delayed_flow; /*  0x28   0x8 */
	u64                        ktime_cache;          /*  0x30   0x8 */
	unsigned long              unthrottle_latency_ns; /*  0x38   0x8 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	struct fq_flow             internal __attribute__((__aligned__(64))); /*  0x40  0x80 */

	/* XXX last struct has 16 bytes of padding */

	/* --- cacheline 3 boundary (192 bytes) --- */
	u32                        quantum;              /*  0xc0   0x4 */
	u32                        initial_quantum;      /*  0xc4   0x4 */
	u32                        flow_refill_delay;    /*  0xc8   0x4 */
	u32                        flow_plimit;          /*  0xcc   0x4 */
	unsigned long              flow_max_rate;        /*  0xd0   0x8 */
	u64                        ce_threshold;         /*  0xd8   0x8 */
	u64                        horizon;              /*  0xe0   0x8 */
	u32                        orphan_mask;          /*  0xe8   0x4 */
	u32                        low_rate_threshold;   /*  0xec   0x4 */
	struct rb_root *           fq_root;              /*  0xf0   0x8 */
	u8                         rate_enable;          /*  0xf8   0x1 */
	u8                         fq_trees_log;         /*  0xf9   0x1 */
	u8                         horizon_drop;         /*  0xfa   0x1 */

	/* XXX 1 byte hole, try to pack */

<bad>	u32                        flows;                /*  0xfc   0x4 */
	/* --- cacheline 4 boundary (256 bytes) --- */
	u32                        inactive_flows;       /* 0x100   0x4 */
	u32                        throttled_flows;      /* 0x104   0x4 */
	u64                        stat_gc_flows;        /* 0x108   0x8 */
	u64                        stat_internal_packets; /* 0x110   0x8 */
	u64                        stat_throttled;       /* 0x118   0x8 */
	u64                        stat_ce_mark;         /* 0x120   0x8 */
	u64                        stat_horizon_drops;   /* 0x128   0x8 */
	u64                        stat_horizon_caps;    /* 0x130   0x8 */
	u64                        stat_flows_plimit;    /* 0x138   0x8 */
	/* --- cacheline 5 boundary (320 bytes) --- */
	u64                        stat_pkts_too_long;   /* 0x140   0x8 */
	u64                        stat_allocation_errors; /* 0x148   0x8 */
<bad>	u32                        timer_slack;          /* 0x150   0x4 */

	/* XXX 4 bytes hole, try to pack */

	struct qdisc_watchdog      watchdog;             /* 0x158  0x48 */

	/* size: 448, cachelines: 7, members: 34 */
	/* sum members: 411, holes: 2, sum holes: 5 */
	/* padding: 32 */
	/* paddings: 1, sum paddings: 16 */
	/* forced alignments: 1 */
};

pahole output after the patch:

struct fq_sched_data {
	struct fq_flow_head        new_flows;            /*     0  0x10 */
	struct fq_flow_head        old_flows;            /*  0x10  0x10 */
	struct rb_root             delayed;              /*  0x20   0x8 */
	u64                        time_next_delayed_flow; /*  0x28   0x8 */
	u64                        ktime_cache;          /*  0x30   0x8 */
	unsigned long              unthrottle_latency_ns; /*  0x38   0x8 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	struct fq_flow             internal __attribute__((__aligned__(64))); /*  0x40  0x80 */

	/* XXX last struct has 16 bytes of padding */

	/* --- cacheline 3 boundary (192 bytes) --- */
	u32                        quantum;              /*  0xc0   0x4 */
	u32                        initial_quantum;      /*  0xc4   0x4 */
	u32                        flow_refill_delay;    /*  0xc8   0x4 */
	u32                        flow_plimit;          /*  0xcc   0x4 */
	unsigned long              flow_max_rate;        /*  0xd0   0x8 */
	u64                        ce_threshold;         /*  0xd8   0x8 */
	u64                        horizon;              /*  0xe0   0x8 */
	u32                        orphan_mask;          /*  0xe8   0x4 */
	u32                        low_rate_threshold;   /*  0xec   0x4 */
	struct rb_root *           fq_root;              /*  0xf0   0x8 */
	u8                         rate_enable;          /*  0xf8   0x1 */
	u8                         fq_trees_log;         /*  0xf9   0x1 */
	u8                         horizon_drop;         /*  0xfa   0x1 */

	/* XXX 1 byte hole, try to pack */

<good>	u32                        timer_slack;          /*  0xfc   0x4 */
	/* --- cacheline 4 boundary (256 bytes) --- */
<good>	u32                        flows;                /* 0x100   0x4 */
	u32                        inactive_flows;       /* 0x104   0x4 */
	u32                        throttled_flows;      /* 0x108   0x4 */

	/* XXX 4 bytes hole, try to pack */

	u64                        stat_throttled;       /* 0x110   0x8 */
<better> struct qdisc_watchdog     watchdog;             /* 0x118  0x48 */
	/* --- cacheline 5 boundary (320 bytes) was 32 bytes ago --- */
	u64                        stat_gc_flows;        /* 0x160   0x8 */
	u64                        stat_internal_packets; /* 0x168   0x8 */
	u64                        stat_ce_mark;         /* 0x170   0x8 */
	u64                        stat_horizon_drops;   /* 0x178   0x8 */
	/* --- cacheline 6 boundary (384 bytes) --- */
	u64                        stat_horizon_caps;    /* 0x180   0x8 */
	u64                        stat_flows_plimit;    /* 0x188   0x8 */
	u64                        stat_pkts_too_long;   /* 0x190   0x8 */
	u64                        stat_allocation_errors; /* 0x198   0x8 */

	/* Force padding: */
	u64                        :64;
	u64                        :64;
	u64                        :64;
	u64                        :64;

	/* size: 448, cachelines: 7, members: 34 */
	/* sum members: 411, holes: 2, sum holes: 5 */
	/* padding: 32 */
	/* paddings: 1, sum paddings: 16 */
	/* forced alignments: 1 */
};

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 709f34f7c28d ("net/sched: fq: add overflow bounds to quantum and initial quantum")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 65b12b39e2ec5..8114291a95133 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -104,6 +104,9 @@ struct fq_sched_data {
 	unsigned long	unthrottle_latency_ns;
 
 	struct fq_flow	internal;	/* for non classified or high prio packets */
+
+/* Read mostly cache line */
+
 	u32		quantum;
 	u32		initial_quantum;
 	u32		flow_refill_delay;
@@ -117,22 +120,27 @@ struct fq_sched_data {
 	u8		rate_enable;
 	u8		fq_trees_log;
 	u8		horizon_drop;
+	u32		timer_slack; /* hrtimer slack in ns */
+
+/* Read/Write fields. */
+
 	u32		flows;
 	u32		inactive_flows;
 	u32		throttled_flows;
 
+	u64		stat_throttled;
+	struct qdisc_watchdog watchdog;
 	u64		stat_gc_flows;
+
+/* Seldom used fields. */
+
 	u64		stat_internal_packets;
-	u64		stat_throttled;
 	u64		stat_ce_mark;
 	u64		stat_horizon_drops;
 	u64		stat_horizon_caps;
 	u64		stat_flows_plimit;
 	u64		stat_pkts_too_long;
 	u64		stat_allocation_errors;
-
-	u32		timer_slack; /* hrtimer slack in ns */
-	struct qdisc_watchdog watchdog;
 };
 
 /*
-- 
2.53.0



