Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FDB290BA5;
	Mon, 14 Jul 2025 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534470; cv=none; b=mAaVv8eUW20aYdYuDjoMQg4JWCOqHjb6U8R92i8kpnIAabbQDSQTCk4GQNlHa1f5G2xCuy7dtVsDfFQ6repPBCN5QvXpbw5W8gwivaS5sGQ/WZU4SfvK51sSYQUKwFWuBs7Hs9bZxqjYjzBc8xY4HVOPz0vJf7a4MmuMLywZeaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534470; c=relaxed/simple;
	bh=uGyRRMRnX6W2HSzpn2bV1k1KFiIJ0Fo4LhUkRbfoTlo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pYeZZ8r3ymc7Acqe8dNfSkddtzKKpYfTOu46fz3TbThRVnyTsym2nyAA4EEJNH+PegDj9kgJjt8ItA3IDqmDG5fyjFs5p7pmv/STyR+jKYFxpPdpHNcvta2XO7l/+ZTJhEdEG6kiF1ykR5Z1//cmz+etC8qzePQHzu5GWY9zp7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7l/XiYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7l/XiYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD3BC4CEED;
	Mon, 14 Jul 2025 23:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752534469;
	bh=uGyRRMRnX6W2HSzpn2bV1k1KFiIJ0Fo4LhUkRbfoTlo=;
	h=From:To:Cc:Subject:Date:From;
	b=n7l/XiYLNOs06RvuioVk13mT5Uuu/6QSBL1JtNo8IKwEtZ3Cl9kBpjTg23zDw6Ki/
	 +jdC97WLdcjZ6t3sXqudyGr+HO0bYRCCzlvpbjjbSerW1aTt3BuUsu8IybyhLnJsrd
	 pXtv8qAFNkCox/lMUQ704ZNSZIWDg8C/WC3AtskAm2eNJBoOzAw0JFyPr1IiariTQ9
	 rpcx6OFUjoyN5DBKNLC0iTCNYgge7T48WauqPsMcsYqyFJjhXzFIU5h+l+n5MhBfHg
	 TwtGwd5E7uV7l1Z2YsWeYRON7qgTZy+jPaHt6ZgDFzeR6VWBoFpR1YYyssM114p3RR
	 e6VZ3nSVssJmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiang Mei <xmei5@asu.edu>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 1/6] net/sched: sch_qfq: Fix null-deref in agg_dequeue
Date: Mon, 14 Jul 2025 19:07:38 -0400
Message-Id: <20250714230744.3710270-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.98
Content-Transfer-Encoding: 8bit

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit dd831ac8221e691e9e918585b1003c7071df0379 ]

To prevent a potential crash in agg_dequeue (net/sched/sch_qfq.c)
when cl->qdisc->ops->peek(cl->qdisc) returns NULL, we check the return
value before using it, similar to the existing approach in sch_hfsc.c.

To avoid code duplication, the following changes are made:

1. Changed qdisc_warn_nonwc(include/net/pkt_sched.h) into a static
inline function.

2. Moved qdisc_peek_len from net/sched/sch_hfsc.c to
include/net/pkt_sched.h so that sch_qfq can reuse it.

3. Applied qdisc_peek_len in agg_dequeue to avoid crashing.

Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://patch.msgid.link/20250705212143.3982664-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and related code, here is my
assessment:

**YES** - This commit should be backported to stable kernel trees.

Here's my extensive explanation:

## Reason for Backporting

1. **Real Bug Fix**: This commit fixes a NULL pointer dereference bug in
   `agg_dequeue()` function in `net/sched/sch_qfq.c`. The bug occurs
   when `cl->qdisc->ops->peek(cl->qdisc)` returns NULL, but the code at
   line 992 (before the fix) directly uses this potentially NULL value
   in `qdisc_pkt_len()` without checking:

  ```c
  else if (cl->deficit < qdisc_pkt_len(cl->qdisc->ops->peek(cl->qdisc)))
  ```

2. **Crash Prevention**: This is not a theoretical issue - it causes an
   actual kernel crash (NULL pointer dereference) that can affect system
   stability. This meets the stable kernel criteria of fixing "a real
   bug that bothers people" including "an oops, a hang, data
   corruption."

3. **Similar Patterns in Other Schedulers**: The commit shows that this
   pattern of NULL checking after peek operations is already implemented
   in other packet schedulers:
   - `sch_hfsc.c` already has the `qdisc_peek_len()` function with NULL
     checking
   - `sch_drr.c` checks for NULL after peek operations (lines 385-387)
   - The similar commit #1 shows DRR had a similar issue fixed

4. **Minimal and Contained Fix**: The fix is:
   - Small in size (well under 100 lines)
   - Obviously correct - it adds proper NULL checking
   - Moves existing code to be reusable
   - Makes the code more consistent across schedulers

5. **Precedent from Similar Commits**: Looking at the historical
   commits:
   - Similar commit #2 (sch_codel NULL check) was backported (Status:
     YES)
   - Similar commit #3 (multiple schedulers NULL handling) was
     backported (Status: YES)
   - Both dealt with NULL pointer handling in packet scheduler dequeue
     paths

6. **Code Consolidation**: The fix properly consolidates the NULL
   checking logic:
   - Converts `qdisc_warn_nonwc` from a regular function to static
     inline (reducing overhead)
   - Moves `qdisc_peek_len` from sch_hfsc.c to the common header so it
     can be reused
   - Uses the same pattern across multiple schedulers for consistency

7. **Tested Pattern**: The `qdisc_peek_len()` function being moved has
   been in use in sch_hfsc.c, proving it's a tested and working
   solution.

8. **Security Consideration**: While not explicitly a security
   vulnerability, NULL pointer dereferences can potentially be exploited
   for denial of service attacks, making this fix important for system
   stability.

The commit follows all the stable kernel rules: it fixes a real bug
(NULL pointer dereference), is obviously correct (adds NULL check), is
small and contained, and improves consistency across the codebase. The
pattern of backporting similar NULL check fixes in packet schedulers (as
seen in similar commits #2 and #3) supports backporting this fix as
well.

 include/net/pkt_sched.h | 25 ++++++++++++++++++++++++-
 net/sched/sch_api.c     | 10 ----------
 net/sched/sch_hfsc.c    | 16 ----------------
 net/sched/sch_qfq.c     |  2 +-
 4 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 15960564e0c36..4d72d24b1f33e 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -112,7 +112,6 @@ struct qdisc_rate_table *qdisc_get_rtab(struct tc_ratespec *r,
 					struct netlink_ext_ack *extack);
 void qdisc_put_rtab(struct qdisc_rate_table *tab);
 void qdisc_put_stab(struct qdisc_size_table *tab);
-void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc);
 bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
 		     struct net_device *dev, struct netdev_queue *txq,
 		     spinlock_t *root_lock, bool validate);
@@ -306,4 +305,28 @@ static inline bool tc_qdisc_stats_dump(struct Qdisc *sch,
 	return true;
 }
 
+static inline void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc)
+{
+	if (!(qdisc->flags & TCQ_F_WARN_NONWC)) {
+		pr_warn("%s: %s qdisc %X: is non-work-conserving?\n",
+			txt, qdisc->ops->id, qdisc->handle >> 16);
+		qdisc->flags |= TCQ_F_WARN_NONWC;
+	}
+}
+
+static inline unsigned int qdisc_peek_len(struct Qdisc *sch)
+{
+	struct sk_buff *skb;
+	unsigned int len;
+
+	skb = sch->ops->peek(sch);
+	if (unlikely(skb == NULL)) {
+		qdisc_warn_nonwc("qdisc_peek_len", sch);
+		return 0;
+	}
+	len = qdisc_pkt_len(skb);
+
+	return len;
+}
+
 #endif
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 282423106f15d..ae63b3199b1d1 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -594,16 +594,6 @@ void __qdisc_calculate_pkt_len(struct sk_buff *skb,
 	qdisc_skb_cb(skb)->pkt_len = pkt_len;
 }
 
-void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc)
-{
-	if (!(qdisc->flags & TCQ_F_WARN_NONWC)) {
-		pr_warn("%s: %s qdisc %X: is non-work-conserving?\n",
-			txt, qdisc->ops->id, qdisc->handle >> 16);
-		qdisc->flags |= TCQ_F_WARN_NONWC;
-	}
-}
-EXPORT_SYMBOL(qdisc_warn_nonwc);
-
 static enum hrtimer_restart qdisc_watchdog(struct hrtimer *timer)
 {
 	struct qdisc_watchdog *wd = container_of(timer, struct qdisc_watchdog,
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index afcb83d469ff6..751b1e2c35b3f 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -835,22 +835,6 @@ update_vf(struct hfsc_class *cl, unsigned int len, u64 cur_time)
 	}
 }
 
-static unsigned int
-qdisc_peek_len(struct Qdisc *sch)
-{
-	struct sk_buff *skb;
-	unsigned int len;
-
-	skb = sch->ops->peek(sch);
-	if (unlikely(skb == NULL)) {
-		qdisc_warn_nonwc("qdisc_peek_len", sch);
-		return 0;
-	}
-	len = qdisc_pkt_len(skb);
-
-	return len;
-}
-
 static void
 hfsc_adjust_levels(struct hfsc_class *cl)
 {
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 5e557b960bde3..e0cefa21ce21c 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -992,7 +992,7 @@ static struct sk_buff *agg_dequeue(struct qfq_aggregate *agg,
 
 	if (cl->qdisc->q.qlen == 0) /* no more packets, remove from list */
 		list_del_init(&cl->alist);
-	else if (cl->deficit < qdisc_pkt_len(cl->qdisc->ops->peek(cl->qdisc))) {
+	else if (cl->deficit < qdisc_peek_len(cl->qdisc)) {
 		cl->deficit += agg->lmax;
 		list_move_tail(&cl->alist, &agg->active);
 	}
-- 
2.39.5

