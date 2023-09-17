Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EE8746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3252C433C7;
	Sun, 17 Sep 2023 20:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983034;
	bh=eUTq/9XG7npsuponzLARsESNkddbhxwUmDGeMbrO/lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngkdybrxXehcPo6TDJ8VPb+PYhMIxZ7iTBL5JPxhkalx5BZD4AUfeSefFzY0YvkCZ
	 /sPcT/ZyUAbGG8lNEEK5yhpH/9gr0xdOBf71GFCMdscTbkY3mdFGp5crl7oh7+sKwf
	 3kfoITJOyggU3EC792u9m35pGmyibIazff8OQbkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e46fbd5289363464bc13@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 426/511] net/sched: fq_pie: avoid stalls in fq_pie_timer()
Date: Sun, 17 Sep 2023 21:14:13 +0200
Message-ID: <20230917191124.058568518@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 8c21ab1bae945686c602c5bfa4e3f3352c2452c5 ]

When setting a high number of flows (limit being 65536),
fq_pie_timer() is currently using too much time as syzbot reported.

Add logic to yield the cpu every 2048 flows (less than 150 usec
on debug kernels).
It should also help by not blocking qdisc fast paths for too long.
Worst case (65536 flows) would need 31 jiffies for a complete scan.

Relevant extract from syzbot report:

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { 0-.... } 2663 jiffies s: 873 root: 0x1/.
rcu: blocking rcu_node structures (internal RCU debug):
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 5177 Comm: syz-executor273 Not tainted 6.5.0-syzkaller-00453-g727dbda16b83 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/26/2023
RIP: 0010:check_kcov_mode kernel/kcov.c:173 [inline]
RIP: 0010:write_comp_data+0x21/0x90 kernel/kcov.c:236
Code: 2e 0f 1f 84 00 00 00 00 00 65 8b 05 01 b2 7d 7e 49 89 f1 89 c6 49 89 d2 81 e6 00 01 00 00 49 89 f8 65 48 8b 14 25 80 b9 03 00 <a9> 00 01 ff 00 74 0e 85 f6 74 59 8b 82 04 16 00 00 85 c0 74 4f 8b
RSP: 0018:ffffc90000007bb8 EFLAGS: 00000206
RAX: 0000000000000101 RBX: ffffc9000dc0d140 RCX: ffffffff885893b0
RDX: ffff88807c075940 RSI: 0000000000000100 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc9000dc0d178
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000555555d54380(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6b442f6130 CR3: 000000006fe1c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <IRQ>
 pie_calculate_probability+0x480/0x850 net/sched/sch_pie.c:415
 fq_pie_timer+0x1da/0x4f0 net/sched/sch_fq_pie.c:387
 call_timer_fn+0x1a0/0x580 kernel/time/timer.c:1700

Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Link: https://lore.kernel.org/lkml/00000000000017ad3f06040bf394@google.com/
Reported-by: syzbot+e46fbd5289363464bc13@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20230829123541.3745013-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_pie.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index ce7833f95214f..1fb68c973f451 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -61,6 +61,7 @@ struct fq_pie_sched_data {
 	struct pie_params p_params;
 	u32 ecn_prob;
 	u32 flows_cnt;
+	u32 flows_cursor;
 	u32 quantum;
 	u32 memory_limit;
 	u32 new_flow_count;
@@ -378,21 +379,31 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
 static void fq_pie_timer(struct timer_list *t)
 {
 	struct fq_pie_sched_data *q = from_timer(q, t, adapt_timer);
+	unsigned long next, tupdate;
 	struct Qdisc *sch = q->sch;
 	spinlock_t *root_lock; /* to lock qdisc for probability calculations */
-	u32 idx;
+	int max_cnt, i;
 
 	root_lock = qdisc_lock(qdisc_root_sleeping(sch));
 	spin_lock(root_lock);
 
-	for (idx = 0; idx < q->flows_cnt; idx++)
-		pie_calculate_probability(&q->p_params, &q->flows[idx].vars,
-					  q->flows[idx].backlog);
-
-	/* reset the timer to fire after 'tupdate' jiffies. */
-	if (q->p_params.tupdate)
-		mod_timer(&q->adapt_timer, jiffies + q->p_params.tupdate);
+	/* Limit this expensive loop to 2048 flows per round. */
+	max_cnt = min_t(int, q->flows_cnt - q->flows_cursor, 2048);
+	for (i = 0; i < max_cnt; i++) {
+		pie_calculate_probability(&q->p_params,
+					  &q->flows[q->flows_cursor].vars,
+					  q->flows[q->flows_cursor].backlog);
+		q->flows_cursor++;
+	}
 
+	tupdate = q->p_params.tupdate;
+	next = 0;
+	if (q->flows_cursor >= q->flows_cnt) {
+		q->flows_cursor = 0;
+		next = tupdate;
+	}
+	if (tupdate)
+		mod_timer(&q->adapt_timer, jiffies + next);
 	spin_unlock(root_lock);
 }
 
-- 
2.40.1



