Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AE34F7CD4;
	Thu, 17 Sep 2026 16:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664009; cv=none; b=rC8vzIAC4YDJqXtDPPqFc3ixNKR/A0DlmU5c5UoBiwyegHoqPrFOlLhyQHtuBzoewitB5BbRBuQ+o/2Ji1CVxXI507vkJUs+DqMmvmBCzf8jmTNcBKxpBJg1ZsO22ldTTpAFn223T4emSXPp+D/eTQK6dMj6V8t88fv/gKU8w1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664009; c=relaxed/simple;
	bh=PDHrpwQdYaNoJot2EDhxLUJzuVhtmYToP32wtPt4RFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPmycqP6z1KHm4UfGidSRwLcs1LpD+eH/DXzjeNlSetoXiZLVpuJxTLi7BcNUdA6bOwNMna9d3cQvymJf5OUWPmJdZ8wxEOHI+Xnn7DZYOI9c1CGh0HUeAo839veV8gfuqZkSAjHKF1l8sL4i4tDxnxJ0e+QnutmAKA0D03Prkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnRY2KLW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnRY2KLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3ED1F000FF;
	Thu, 17 Sep 2026 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664007;
	bh=3vFdPwpiEC3GHtl4bavOAI4mS/6eCiil5tbDwhVQETk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnRY2KLW67Vf0mbDL87WAKXQDjS3Ymef6JknPkiNe2LKQedkvEdZhEWP120nErGD/
	 abaHNe/HaYfVkEq6Os3C68Q02OISZIxzzjOWxqLs95JD9p/PZm0IBuMFgeTMZbEvf1
	 8/zZduWl0VXGnNK2IV7HtaGgWc+EOe7oCUc4cDaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0229/1250] net: napi: Skip last poll when arming gro timer in busy poll
Date: Thu, 17 Sep 2026 16:00:24 +0100
Message-ID: <20260917151558.348778162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Martin Karsten <mkarsten@uwaterloo.ca>

[ Upstream commit 7599c13dbe7a2dc49e33f4c6581c6f1287d9410e ]

Skip the extra call to napi->poll(), if the gro timer is armed at the
end of busy polling. This removes the need for having a separate
__busy_poll_stop() routine and its code is moved directly into the
relevant places in busy_poll_stop(). Remove obsolete comment about
ndo_busy_poll_stop().

This is a follow-up to commit 58e2330bd455 ("net: napi: Avoid gro timer
misfiring at end of busypoll"), which has deferred arming the gro timer
to the end of __busy_poll_stop() to eliminate a race condition between
a short timer and long poll that could leave the queue stuck with
interrupts disabled and no timer armed.

Co-developed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Martin Karsten <mkarsten@uwaterloo.ca>
Link: https://patch.msgid.link/20260523012247.1574691-1-mkarsten@uwaterloo.ca
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 62 ++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 35 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ae5e8dfd2fc21..c7e35768238cc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6791,22 +6791,6 @@ static void skb_defer_free_flush(void)
 
 #if defined(CONFIG_NET_RX_BUSY_POLL)
 
-static void __busy_poll_stop(struct napi_struct *napi, unsigned long timeout)
-{
-	if (!timeout) {
-		gro_normal_list(&napi->gro);
-		__napi_schedule(napi);
-		return;
-	}
-
-	/* Flush too old packets. If HZ < 1000, flush all packets */
-	gro_flush_normal(&napi->gro, HZ >= 1000);
-
-	clear_bit(NAPI_STATE_SCHED, &napi->state);
-	hrtimer_start(&napi->timer, ns_to_ktime(timeout),
-		      HRTIMER_MODE_REL_PINNED);
-}
-
 enum {
 	NAPI_F_PREFER_BUSY_POLL	= 1,
 	NAPI_F_END_ON_RESCHED	= 2,
@@ -6822,8 +6806,8 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
 	/* Busy polling means there is a high chance device driver hard irq
 	 * could not grab NAPI_STATE_SCHED, and that NAPI_STATE_MISSED was
 	 * set in napi_schedule_prep().
-	 * Since we are about to call napi->poll() once more, we can safely
-	 * clear NAPI_STATE_MISSED.
+	 * Since we either call napi->poll() once more or start the timer,
+	 * we can safely clear NAPI_STATE_MISSED.
 	 *
 	 * Note: x86 could use a single "lock and ..." instruction
 	 * to perform these two clear_bit()
@@ -6836,27 +6820,35 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
 
 	if (flags & NAPI_F_PREFER_BUSY_POLL) {
 		napi->defer_hard_irqs_count = napi_get_defer_hard_irqs(napi);
-		if (napi->defer_hard_irqs_count) {
-			/* A short enough gro flush timeout and long enough
-			 * poll can result in timer firing too early.
-			 * Timer will be armed later if necessary.
-			 */
+		if (napi->defer_hard_irqs_count)
 			timeout = napi_get_gro_flush_timeout(napi);
+	}
+	if (timeout) {
+		netpoll_poll_unlock(have_poll_lock);
+
+		/* Drain aged GRO packets before clearing SCHED since the NAPI
+		 * won't run again until after the timer fires. When HZ < 1000,
+		 * GRO age comparison is too coarse, so flush everything.
+		 */
+		gro_flush_normal(&napi->gro, HZ >= 1000);
+
+		clear_bit(NAPI_STATE_SCHED, &napi->state);
+		hrtimer_start(&napi->timer, ns_to_ktime(timeout),
+			      HRTIMER_MODE_REL_PINNED);
+	} else {
+		/* Use driver poll to re-enable device interrupts. */
+		rc = napi->poll(napi, budget);
+		/* Unless rc == budget we no longer own the NAPI instance,
+		 * IRQ may fire on another CPU, poll this NAPI, and enter GRO.
+		 */
+		trace_napi_poll(napi, rc, budget);
+		netpoll_poll_unlock(have_poll_lock);
+		if (rc == budget) {
+			gro_normal_list(&napi->gro);
+			__napi_schedule(napi);
 		}
 	}
 
-	/* All we really want here is to re-enable device interrupts.
-	 * Ideally, a new ndo_busy_poll_stop() could avoid another round.
-	 */
-	rc = napi->poll(napi, budget);
-	/* We can't gro_normal_list() here, because napi->poll() might have
-	 * rearmed the napi (napi_complete_done()) in which case it could
-	 * already be running on another CPU.
-	 */
-	trace_napi_poll(napi, rc, budget);
-	netpoll_poll_unlock(have_poll_lock);
-	if (rc == budget)
-		__busy_poll_stop(napi, timeout);
 	bpf_net_ctx_clear(bpf_net_ctx);
 	local_bh_enable();
 }
-- 
2.53.0



