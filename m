Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A881553FD50;
	Mon, 31 Aug 2026 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183953; cv=none; b=LYTkgvGKdd8RgVQNQLMgVHXVJnCwrgxDkOeIcqdUJSxv4djEgzjERZKFGnageBrTBEf1Xwx0fyvayapUz4m8BaBejQBX79/ZllERq6jphKNbT7JIyscoAhM53lw3mM15aCICgPzcPVc4LuZ483sRE8Re+p7AbfnX/TCwDAcFIzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183953; c=relaxed/simple;
	bh=DM5ff/qhZJeeiGLm8TfCXiw0INSoVLZAEztmpha2lIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e3TuI3u4ETa12qG75h19xqB7Xyu+1sdyDEMjWqdjBd9zuNhoB9wjOXw5qUXC6+1+CIcXSYnIrV872sRRjIuKQ3bu36a2MAjG/OGgeRxJChQC7XYFIRc8/ZV0MzGIp5t/CX6hg/rQQKCEenK7HYuRcuWoNd6m7jJkHjvpxuGCOdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mab0oEPp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mab0oEPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E0C1F000E9;
	Mon, 31 Aug 2026 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183951;
	bh=MJ3AHh10fDwkUnJ+disBlcPwfPnvJCKnmnUNsTWnrKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mab0oEPpvagti6D39d1zQmXBMaKcBRMDnC4oRY3QK7wNPIFnwzo2CDXCAm4JTCD7x
	 kQGUfHmddxQpGOZuHMyv7RXgVj07RBoOWGoq48mpbHrcLIw9huYaOrpsamrpm9lfEq
	 HDTu5aH1SuZttUqUr3ZoyAhyKAd6IgSDy+e0Ez1kzfVztwKQEiCD6g2YgIoWw/6DFx
	 RN4DTwIpTRuXWRkbQSnbdZ46tqFdq+dbVKfN+DHAPnPOsrO9BcLYPI7LMcxkp12Hvr
	 Iei62RSuUfe+Mmt1xFFSAXadflfW2MH+tEP8PDta+4YtDpk/OQnLaxk04h75PZ6Ls8
	 ZUjIJrjmvf+qQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net_sched: sch_fq: convert skb->tstamp if not monotonic
Date: Mon, 31 Aug 2026 09:27:08 -0400
Message-ID: <20260831133314.4125787-400-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit c4f796c4f16ba375b43c608d6bd0f72e20168312 ]

FQ currently assumes skb->tstamp holds monotonic time, as used by TCP.

Users with ns_capable CAP_NET_ADMIN can transmit skbs using SO_TXTIME
with CLOCK_MONOTONIC, CLOCK_REALTIME or CLOCK_TAI clockids as of
commit 80b14dee2bea ("net: Add a new socket option for a future
transmit time.")

More recently, skbs also gained tstamp_type to explicitly communicate
the clockid of skb->tstamp, with commit 4d25ca2d6801 ("net: Rename
mono_delivery_time to tstamp_type for scalabilty"), commit
1693c5db6ab8 ("net: Add additional bit to support clockid_t timestamp
type") and a few others.

Detect other clocks and convert to monotonic for use in FQ. That is,
convert fq_skb_cb(skb)->time_to_send. Do not convert skb->tstamp
itself. Network device clocks are more commonly synchronized to TAI.

Conversion may be imprecise due to clock adjustment (e.g., adjfreq)
between when SCM_TSTAMP is set and when it is converted in fq_enqueue.
The common codepath is short, so skew will be well below common pacing
operation. Even in edge cases, bursts (too soon) or beyond horizon
(too late) are indistinguishable from network conditions. To which
senders must be robust, as long as infrequent.

Avoid overflow due to negative offsets becoming huge when converting
from signed ktime_t to u64 time_to_send. Bound lower to mono 1 and
upper to now + q->horizon. This protects against bad input, e.g.,
from BPF programs.

Detect legacy BPF programs that program skb->tstamp without setting
skb->tstamp_type. Here tstamp_type is zero (SKB_CLOCK_REALTIME), but
the value will be unrealistic for realtime in the 21st century. Follow
existing TIME_UPTIME_SEC_MAX as bound between mono and realtime.

Signed-off-by: Willem de Bruijn <willemb@google.com>

----

Changes
  v1 -> v2
    - replace Fixes tag with references inside the commit message

Link: https://patch.msgid.link/20260604194221.3319080-3-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished and match what the full analysis
already found:

- **Commit search:** The fix (`fq_skb_tstamp_to_mono`, subject grep) is
  **not** in this tree yet (6.18.44). `b4 dig` on `HEAD` wasn’t useful;
  using the mainline hash `c4f796c4f16b` did locate the lore thread.
- **Related fixes:** No existing `sch_fq` clock-conversion fix here. The
  grep hits are separate forwarding-path cleanups (clearing
  `skb->tstamp` in OVS, netfilter, ipvs) — related timestamp handling,
  but not this FQ bug.

**Verdict stands: YES** for 6.18.y — FQ still compares monotonic `now`
against unconverted REALTIME/TAI `skb->tstamp`, and with default
`horizon_drop=1` those SO_TXTIME packets get dropped. The patch cherry-
picks cleanly onto 6.18.44.

 net/sched/sch_fq.c | 43 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 5e41930079948..e4f5a1cb238ff 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -531,14 +531,44 @@ static void flow_queue_add(struct fq_flow *flow, struct sk_buff *skb)
 	rb_insert_color(&skb->rbnode, &flow->t_root);
 }
 
-static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
+static bool fq_packet_beyond_horizon(ktime_t time_to_send,
 				     const struct fq_sched_data *q, u64 now)
 {
-	return unlikely((s64)skb->tstamp > (s64)(now + q->horizon));
+	return unlikely((s64)time_to_send > (s64)(now + q->horizon));
 }
 
 #define FQDR(reason) SKB_DROP_REASON_FQ_##reason
 
+static ktime_t fq_skb_tstamp_to_mono(struct sk_buff *skb)
+{
+	const ktime_t mono_max = NSEC_PER_SEC * TIME_UPTIME_SEC_MAX;
+
+	if (likely(skb->tstamp_type == SKB_CLOCK_MONOTONIC))
+		return max(skb->tstamp, 1);
+
+	if (skb->tstamp_type == SKB_CLOCK_TAI)
+		return max(ktime_sub(skb->tstamp, ktime_mono_to_any(0, TK_OFFS_TAI)), 1);
+
+	if (likely(skb->tstamp > mono_max))
+		return max(ktime_sub(skb->tstamp, ktime_mono_to_real(0)), 1);
+
+	/* Handle BPF programs setting skb->stamp but not tstamp_type */
+	net_warn_ratelimited("fq: likely mono tstamp with tstamp_type 0\n");
+
+	skb->tstamp_type = SKB_CLOCK_MONOTONIC;
+	return max(skb->tstamp, 1);
+}
+
+static void fq_mono_to_skb_tstamp(struct sk_buff *skb, ktime_t time_to_send)
+{
+	if (skb->tstamp_type == SKB_CLOCK_MONOTONIC)
+		skb->tstamp = time_to_send;
+	else if (skb->tstamp_type == SKB_CLOCK_REALTIME)
+		skb->tstamp = ktime_mono_to_real(time_to_send);
+	else
+		skb->tstamp = ktime_mono_to_any(time_to_send, TK_OFFS_TAI);
+}
+
 static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		      struct sk_buff **to_free)
 {
@@ -558,17 +588,20 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (!skb->tstamp) {
 		fq_skb_cb(skb)->time_to_send = now;
 	} else {
+		ktime_t time_to_send = fq_skb_tstamp_to_mono(skb);
+
 		/* Check if packet timestamp is too far in the future. */
-		if (fq_packet_beyond_horizon(skb, q, now)) {
+		if (fq_packet_beyond_horizon(time_to_send, q, now)) {
 			if (q->horizon_drop) {
 				q->stat_horizon_drops++;
 				return qdisc_drop_reason(skb, sch, to_free,
 							 FQDR(HORIZON_LIMIT));
 			}
 			q->stat_horizon_caps++;
-			skb->tstamp = now + q->horizon;
+			time_to_send = now + q->horizon;
+			fq_mono_to_skb_tstamp(skb, time_to_send);
 		}
-		fq_skb_cb(skb)->time_to_send = skb->tstamp;
+		fq_skb_cb(skb)->time_to_send = (u64)time_to_send;
 	}
 
 	f = fq_classify(sch, skb, now);
-- 
2.53.0

