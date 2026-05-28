Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FD02E7379;
	Thu, 28 May 2026 20:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999834; cv=none; b=AneUC0uWGJvfHCEdKK9VqTGChzZeAfp4UY5wFulcadtqiYsaIPUJlxVCKgsfiUq6SsHultm5gVXC+RumxaItRtmmfQ1Z2petET5j45VBp1DLgNcv36R8KGL1/8t8/C5ZaN6Q4vJe7p5AdmMxY7IvqeV0z3E878HxufU+pHsJx5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999834; c=relaxed/simple;
	bh=YYEl8zMouIrCcx/WgwPK8VXLG2LO25RzXOTat06lbbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9VO/94sM2Ae+rNRKYfazXPmFrjIGpxdGz5SMGpqTB1uKC+pY7EBhvcwHT5OC3dLa2KVnoVf9jMjsbXdPVe+Zvvq89SFJW3sT6B7EFO7J0Yy2kOwdk70HcXlvSQlFWs2PIPeVtLk8qxWT+SYEW89Df9F3FXYww7zys4xiE/NJow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5/12ro2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5/12ro2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2537A1F000E9;
	Thu, 28 May 2026 20:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999832;
	bh=1jAWuROhiz9WGpmvsQrlUuLASlwwTHCFr9kUioGdfQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5/12ro27H8WMgpbcjAUho1OL7Tu9DPL3Ttx4BRdV1aHLeiFNnXvcX+NtsSD5Kr5M
	 CSuXWleknUIbUnQPEZB/0557Z+tOFlkazuqowHl27culnb40P/fh8j0WstduReST7D
	 ledRaY7buZxnvDZYYh9ijPkQbD2vdgoUFx7gf1Ec=
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
Subject: [PATCH 6.18 208/377] net: napi: Avoid gro timer misfiring at end of busypoll
Date: Thu, 28 May 2026 21:47:26 +0200
Message-ID: <20260528194644.427140119@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index 29f2f35ae5ebe..681d7de89c505 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6777,9 +6777,9 @@ static void skb_defer_free_flush(void)
 
 #if defined(CONFIG_NET_RX_BUSY_POLL)
 
-static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
+static void __busy_poll_stop(struct napi_struct *napi, unsigned long timeout)
 {
-	if (!skip_schedule) {
+	if (!timeout) {
 		gro_normal_list(&napi->gro);
 		__napi_schedule(napi);
 		return;
@@ -6789,6 +6789,8 @@ static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
 	gro_flush_normal(&napi->gro, HZ >= 1000);
 
 	clear_bit(NAPI_STATE_SCHED, &napi->state);
+	hrtimer_start(&napi->timer, ns_to_ktime(timeout),
+		      HRTIMER_MODE_REL_PINNED);
 }
 
 enum {
@@ -6800,8 +6802,7 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
 			   unsigned flags, u16 budget)
 {
 	struct bpf_net_context __bpf_net_ctx, *bpf_net_ctx;
-	bool skip_schedule = false;
-	unsigned long timeout;
+	unsigned long timeout = 0;
 	int rc;
 
 	/* Busy polling means there is a high chance device driver hard irq
@@ -6821,10 +6822,12 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
 
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
 
@@ -6839,7 +6842,7 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
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



