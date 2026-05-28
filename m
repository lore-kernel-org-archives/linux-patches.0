Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE94827A476;
	Thu, 28 May 2026 20:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998569; cv=none; b=ox6Vo+TXxfBSRkcSSXZClT7irJR96+1Y1HtTt7AgXuR2/U3QKBUN7Unbc9tacjtD0pTLNOOsdKfkrlIM59y7hc8+6JdIHhi1LpnyBXsH7Y09oYsG9SNKBgZ56NC7H8MvdXI0QfX/+JgLSnFayt4+oAeq0PyIazYHbRBep6LKt1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998569; c=relaxed/simple;
	bh=OmiVzrgtVQtqualmxAZtgt9SxKmqyoTHGF537VRyfv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJxy+qWRAs4tErGn6bEDXDGyjgOcA3JKWWuP0rpjOjx1qZiNha7p1a4U2ckJivEeEg8Z7/s+8CBDthOhMGuz7etSKMzbtb0GHe7XLp5SNjGdAXBZLCXF+OZpoqt/+yfd8ZrV0JkV6ooG41dLIfUcHz4//SIrhDUjSuiZcL5poKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1E9f9zqA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1E9f9zqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274971F000E9;
	Thu, 28 May 2026 20:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998568;
	bh=i0y+/x2p2ZybAuWOCgz5/bUzkgylHfyHXboJh3iTBOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1E9f9zqAlVst7/tpXpwdEPl97dpIhWe+I1b2wwQ5IaEjLSsNz6KqgK5zRtLTAwJRf
	 C9FsLee52tCAJQbF/lf4xU3gBm1f4QqKRzVygc8wpQxyYyQZi+1axeMTsMaPK7reAP
	 mcyETfrLPGTGW46Qa96eKPyWm2zFJ608iqgF7RHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Karsten <mkarsten@uwaterloo.ca>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 220/461] net: napi: Avoid gro timer misfiring at end of busypoll
Date: Thu, 28 May 2026 21:45:49 +0200
Message-ID: <20260528194653.498702146@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 58e2330bd45572a6e3d46ea94cf7a9641f43591a ]

When in irq deferral mode (defer-hard-irqs > 0), a short enough
gro-flush timeout can trigger before NAPI_STATE_SCHED is cleared if the
last poll in busy_poll_stop() takes too long. This can have the effect
of leaving the queue stuck with interrupts disabled and no timer armed
which results in a tx timeout if there is no subsequent busypoll cycle.

To prevent this, defer the gro-flush timer arm after the last poll.

Fixes: 7fd3253a7de6 ("net: Introduce preferred busy-polling")
Co-developed-by: Martin Karsten <mkarsten@uwaterloo.ca>
Signed-off-by: Martin Karsten <mkarsten@uwaterloo.ca>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260506090808.820559-2-dtatulea@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e4fcf09ba2beb..fab5a0bebd924 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6855,9 +6855,9 @@ static void skb_defer_free_flush(void)
 
 #if defined(CONFIG_NET_RX_BUSY_POLL)
 
-static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
+static void __busy_poll_stop(struct napi_struct *napi, unsigned long timeout)
 {
-	if (!skip_schedule) {
+	if (!timeout) {
 		gro_normal_list(&napi->gro);
 		__napi_schedule(napi);
 		return;
@@ -6867,6 +6867,8 @@ static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
 	gro_flush_normal(&napi->gro, HZ >= 1000);
 
 	clear_bit(NAPI_STATE_SCHED, &napi->state);
+	hrtimer_start(&napi->timer, ns_to_ktime(timeout),
+		      HRTIMER_MODE_REL_PINNED);
 }
 
 enum {
@@ -6878,8 +6880,7 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
 			   unsigned flags, u16 budget)
 {
 	struct bpf_net_context __bpf_net_ctx, *bpf_net_ctx;
-	bool skip_schedule = false;
-	unsigned long timeout;
+	unsigned long timeout = 0;
 	int rc;
 
 	/* Busy polling means there is a high chance device driver hard irq
@@ -6899,10 +6900,12 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
 
 	if (flags & NAPI_F_PREFER_BUSY_POLL) {
 		napi->defer_hard_irqs_count = napi_get_defer_hard_irqs(napi);
-		timeout = napi_get_gro_flush_timeout(napi);
-		if (napi->defer_hard_irqs_count && timeout) {
-			hrtimer_start(&napi->timer, ns_to_ktime(timeout), HRTIMER_MODE_REL_PINNED);
-			skip_schedule = true;
+		if (napi->defer_hard_irqs_count) {
+			/* A short enough gro flush timeout and long enough
+			 * poll can result in timer firing too early.
+			 * Timer will be armed later if necessary.
+			 */
+			timeout = napi_get_gro_flush_timeout(napi);
 		}
 	}
 
@@ -6917,7 +6920,7 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
 	trace_napi_poll(napi, rc, budget);
 	netpoll_poll_unlock(have_poll_lock);
 	if (rc == budget)
-		__busy_poll_stop(napi, skip_schedule);
+		__busy_poll_stop(napi, timeout);
 	bpf_net_ctx_clear(bpf_net_ctx);
 	local_bh_enable();
 }
-- 
2.53.0



