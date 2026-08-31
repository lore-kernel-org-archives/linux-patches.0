Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FD14FB9A8;
	Mon, 31 Aug 2026 13:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183689; cv=none; b=YcUEVWfgU/JV7QuUHVIIEfdInOB5oA73o+0+DagNEY5IOM7S32CI40I1BH2bxnH+Y9unpe7qlFnZnloGYYvXKSYEwie8wl704+ylDjkRVXSifclgHS1pOS81kI8uyROMcFeFmktp93tlQggT8btoHn1NR9yKarcmbkT/qAuu/8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183689; c=relaxed/simple;
	bh=l0F5Tva7NyiXDFKG6OZv/jso8uxw2veGQ8tR5IgMvZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b2o7wiazhQZMkFxcJbLykbq1BErVVKwwzBCkHenCc1XA9TL5R8CxIKoO1mKYs9ZQHyVEm8fRG8hYQMd07VpqZ4RX84YiiRfvICKFv/bb4OAnLGf90JZEwbBzPgyvdiYnD10wn+84VDt2ta+NaN+ACN+3nBKn/ooUhC1uwLUF/+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDmFnjC/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDmFnjC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB8D1F00A3F;
	Mon, 31 Aug 2026 13:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183687;
	bh=NkgP11C4/Cybgsngll6cPTs9F7sLLO00L7G3sG5QjCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kDmFnjC/wvEB6g/KCi0KIEzc9CHiPI6tI6gjTMEpqyVuthLtc7S+tQMzbEY27V83R
	 jvP5Ps80WRIcQ6bTFqVp9xwrHXfpBhBW9I4yc+3cFO9oBS8Go3BLQySEHIwbcknfb9
	 4soW8UMNjnhnGEo8FckQGvBDZmaVHzEyw7ntzoK1Tfuoxbvbmq06g2T6ZeEoevuVKk
	 hBaEii/QujTMMJjyFu2UFNHvkoAMGLdThkozsvEE0n0bXSFDyEZ5gQuOdi7O6NUVzo
	 rGkdbt/62PUfQyuRFEcJOkd4oq45edjlsk7sGQOdqp1CrOe+uddPG8GY5HxENqainW
	 EFa4yCqCrNa8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Martin Karsten <mkarsten@uwaterloo.ca>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: napi: Skip last poll when arming gro timer in busy poll
Date: Mon, 31 Aug 2026 09:24:33 -0400
Message-ID: <20260831133314.4125787-245-sashal@kernel.org>
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

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
That background search on `linus-next` finished with no matches (it ran
~25 minutes and returned empty). The commit is already identified on
`origin/master` as `7599c13dbe7a2` — it went through the netdev tree,
not `linus-next`. That doesn’t change the **YES** backport
recommendation for 6.18.44.

 net/core/dev.c | 62 ++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 35 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a83083e8761b1..e61cf0b7487fb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6787,22 +6787,6 @@ static void skb_defer_free_flush(void)
 
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
@@ -6818,8 +6802,8 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
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
@@ -6832,27 +6816,35 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
 
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

