Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCDB3E557D;
	Tue, 13 Oct 2026 12:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893649; cv=none; b=mrSFDk1J+jzIkuHC9lgfXVF11Qaqq4rfaZEUPHG0VWmR8ZpKVCYiPOQTvr8hzSnSu7O7zcgGGtPyOEODbC2NBAEsIoczHLCVitj4dqaUIQnjRWcxqrDHpzvCZ1C3p4eiWDr29m/gEFJBJ1r/u23IirSPq7Hk8CV3n9lygouPafQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893649; c=relaxed/simple;
	bh=WbMnalPUu4y5FfnoVQnRb9tKSOlLkpNREiyk6gaAcBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvYGX19BKl6lYHOC0+S5uvq0wyqTpaJ0CnECe8+k9miyxfQxk+ih9Fs4cSEjhTkkTwLHjwiLUae1+jFwkAAx46mWBxCjmfHa2UZN/Z1JCBpagCm8yg23HjIzU1bsLzH6CO7lb7OgqCJ/jyKjhl6Hcw8iPNOsPZAAaus/e2ORL2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzlBaDDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzlBaDDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1CB1F00893;
	Tue, 13 Oct 2026 12:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893648;
	bh=PGQDg0cjLrgiHJ3KF7kJHX9Z/5V+PACXEi/Mq8D05Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pzlBaDDdoyNEXV1kDX2LZt7IfPeeWjTSQHoklY5ZUdK0N+BrO/M2M82MCoN5IQ4S0
	 bOuilGk1LeTTlk/gCXc8YkhKTHpZWuIfN1xYEzW2wypRqj5uPNYnrHiFKXjpOWX8n8
	 lgiCGGIhJrUXKYMu3PcDDGXsnIBbb/oQg+tAfpI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 294/621] net: optimize enqueue_to_backlog() for the fast path
Date: Tue, 13 Oct 2026 13:34:49 +0200
Message-ID: <20261013112927.834532752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

[ Upstream commit a086e9860ce6a751acd71dbec54d24a819dd6baa ]

Add likely() and unlikely() clauses for the common cases:

Device is running.
Queue is not full.
Queue is less than half capacity.

Add max_backlog parameter to skb_flow_limit() to avoid
a second READ_ONCE(net_hotdata.max_backlog).

skb_flow_limit() does not need the backlog_lock protection,
and can be called before we acquire the lock, for even better
resistance to attacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20251024090517.3289181-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 46762cefe7f4 ("net: serialize netif_running() check in enqueue_to_backlog()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 10e02845fea44..327b4798837d8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5282,14 +5282,15 @@ void kick_defer_list_purge(unsigned int cpu)
 int netdev_flow_limit_table_len __read_mostly = (1 << 12);
 #endif
 
-static bool skb_flow_limit(struct sk_buff *skb, unsigned int qlen)
+static bool skb_flow_limit(struct sk_buff *skb, unsigned int qlen,
+			   int max_backlog)
 {
 #ifdef CONFIG_NET_FLOW_LIMIT
-	struct sd_flow_limit *fl;
-	struct softnet_data *sd;
 	unsigned int old_flow, new_flow;
+	const struct softnet_data *sd;
+	struct sd_flow_limit *fl;
 
-	if (qlen < (READ_ONCE(net_hotdata.max_backlog) >> 1))
+	if (likely(qlen < (max_backlog >> 1)))
 		return false;
 
 	sd = this_cpu_ptr(&softnet_data);
@@ -5334,19 +5335,19 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	u32 tail;
 
 	reason = SKB_DROP_REASON_DEV_READY;
-	if (!netif_running(skb->dev))
+	if (unlikely(!netif_running(skb->dev)))
 		goto bad_dev;
 
-	reason = SKB_DROP_REASON_CPU_BACKLOG;
 	sd = &per_cpu(softnet_data, cpu);
 
 	qlen = skb_queue_len_lockless(&sd->input_pkt_queue);
 	max_backlog = READ_ONCE(net_hotdata.max_backlog);
-	if (unlikely(qlen > max_backlog))
+	if (unlikely(qlen > max_backlog) ||
+	    skb_flow_limit(skb, qlen, max_backlog))
 		goto cpu_backlog_drop;
 	backlog_lock_irq_save(sd, &flags);
 	qlen = skb_queue_len(&sd->input_pkt_queue);
-	if (qlen <= max_backlog && !skb_flow_limit(skb, qlen)) {
+	if (likely(qlen <= max_backlog)) {
 		if (!qlen) {
 			/* Schedule NAPI for backlog device. We can use
 			 * non atomic operation as we own the queue lock.
@@ -5367,6 +5368,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	backlog_unlock_irq_restore(sd, &flags);
 
 cpu_backlog_drop:
+	reason = SKB_DROP_REASON_CPU_BACKLOG;
 	numa_drop_add(&sd->drop_counters, 1);
 bad_dev:
 	dev_core_stats_rx_dropped_inc(skb->dev);
-- 
2.53.0



