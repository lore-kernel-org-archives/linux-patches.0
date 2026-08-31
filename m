Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E804D2ED7;
	Mon, 31 Aug 2026 13:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183552; cv=none; b=eHuyWkXEvDMZJSKVdfux5dJCjoIesAeVklI8A6FLZgrZBxNssM2GeIBlGr1GagCpAPQ/537UzksN6jIxcS4vA4I6elbzFcKmqLuV4EJhquP3XUjfUEgQSG/3hF8/PNEv874gxBV1WIT/aLkBUIz1weQfGvC3D/fcBy0ZINjuBP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183552; c=relaxed/simple;
	bh=Hs89yeBBiR3IFgWW9tIOguyFiZrebdlNqLMTbH5m9GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo25fuwAZPe2kvjovC81cRGtXHZVg0qkoeVXet5AB3mBL8f2/STB5qAK57oV8ak94iE6PYXWuxsGgE2gccgbl2cRn0MQR93nZ5HWUZ1fLx08vrCBI6xUdkkldWUKWap1vaK2KfWlBzQYT5YkMR75PzTUz1Qek14fmjDeyJTa0y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ws+IZ8rd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ws+IZ8rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D30D1F00A3E;
	Mon, 31 Aug 2026 13:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183550;
	bh=h3cbwCW7ZKrQoomvise66fWGsmuxvBb+nVkghwNwQ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ws+IZ8rd9zmRjAe7/bjkTisER0bAUSDIxHjC0ARXCT1t02zvJ58k/BYjBZLg3s0qK
	 pGq9hG8niZFy4NU9/PpRfLtFg6ezlP+9UhUKP4CIR11IrlIcDkRnYsd8mBI6f3s0oE
	 EM13vm+pCnRy4MFBIGEQ8cTEBPP20CVe9xE4uxjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.2 35/71] xfrm: avoid lock inversion in nat keepalive work
Date: Mon, 31 Aug 2026 15:34:00 +0200
Message-ID: <20260831133400.921747816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <xizh2024@lzu.edu.cn>

commit 763fe700b7c58ad64fe5202c5638848244dd4127 upstream.

nat_keepalive_work() walks the state table while xfrm_state_walk()
holds net->xfrm.xfrm_state_lock. Its callback then acquires x->lock,
which conflicts with the delete path taking the same locks in reverse
order via xfrm_state_delete() and __xfrm_state_delete(). This creates
an AB-BA deadlock that is reported by lockdep when a NAT keepalive
worker races with SA deletion.

Fix this by splitting the keepalive walk into two phases. First,
collect the candidate states while the walk holds xfrm_state_lock and
take a reference on each state. Then, after the walk completes, process
each collected state and acquire x->lock without nesting it under
xfrm_state_lock.

Fixes: f531d13bdfe3 ("xfrm: support sending NAT keepalives in ESP in UDP states")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_nat_keepalive.c |   57 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 9 deletions(-)

--- a/net/xfrm/xfrm_nat_keepalive.c
+++ b/net/xfrm/xfrm_nat_keepalive.c
@@ -156,24 +156,51 @@ static void nat_keepalive_send(struct na
 }
 
 struct nat_keepalive_work_ctx {
+	struct list_head states;
 	time64_t next_run;
 	time64_t now;
 };
 
-static int nat_keepalive_work_single(struct xfrm_state *x, int count, void *ptr)
+struct nat_keepalive_state {
+	struct list_head list;
+	struct xfrm_state *x;
+};
+
+static int nat_keepalive_work_collect(struct xfrm_state *x, int count, void *ptr)
 {
 	struct nat_keepalive_work_ctx *ctx = ptr;
+	struct nat_keepalive_state *state;
+
+	if (!READ_ONCE(x->nat_keepalive_interval))
+		return 0;
+
+	state = kmalloc_obj(*state, GFP_ATOMIC);
+	if (!state)
+		return -ENOMEM;
+
+	xfrm_state_hold(x);
+	state->x = x;
+	list_add_tail(&state->list, &ctx->states);
+	return 0;
+}
+
+static void nat_keepalive_work_single(struct xfrm_state *x,
+				      struct nat_keepalive_work_ctx *ctx)
+{
 	bool send_keepalive = false;
 	struct nat_keepalive ka;
-	time64_t next_run;
+	time64_t next_run = 0;
 	u32 interval;
 	int delta;
 
+	spin_lock_bh(&x->lock);
+
+	if (x->km.state == XFRM_STATE_DEAD)
+		goto out;
+
 	interval = x->nat_keepalive_interval;
 	if (!interval)
-		return 0;
-
-	spin_lock(&x->lock);
+		goto out;
 
 	delta = (int)(ctx->now - x->lastused);
 	if (delta < interval) {
@@ -187,29 +214,41 @@ static int nat_keepalive_work_single(str
 		send_keepalive = true;
 	}
 
-	spin_unlock(&x->lock);
+out:
+	spin_unlock_bh(&x->lock);
 
 	if (send_keepalive)
 		nat_keepalive_send(&ka);
 
-	if (!ctx->next_run || next_run < ctx->next_run)
+	if (next_run && (!ctx->next_run || next_run < ctx->next_run))
 		ctx->next_run = next_run;
-	return 0;
 }
 
 static void nat_keepalive_work(struct work_struct *work)
 {
+	struct nat_keepalive_state *state, *tmp;
 	struct nat_keepalive_work_ctx ctx;
 	struct xfrm_state_walk walk;
 	struct net *net;
+	int err;
 
+	INIT_LIST_HEAD(&ctx.states);
 	ctx.next_run = 0;
 	ctx.now = ktime_get_real_seconds();
 
 	net = container_of(work, struct net, xfrm.nat_keepalive_work.work);
 	xfrm_state_walk_init(&walk, IPPROTO_ESP, NULL);
-	xfrm_state_walk(net, &walk, nat_keepalive_work_single, &ctx);
+	err = xfrm_state_walk(net, &walk, nat_keepalive_work_collect, &ctx);
 	xfrm_state_walk_done(&walk, net);
+	list_for_each_entry_safe(state, tmp, &ctx.states, list) {
+		nat_keepalive_work_single(state->x, &ctx);
+		xfrm_state_put(state->x);
+		kfree(state);
+	}
+	if (err == -ENOMEM) {
+		schedule_delayed_work(&net->xfrm.nat_keepalive_work, 0);
+		return;
+	}
 	if (ctx.next_run)
 		schedule_delayed_work(&net->xfrm.nat_keepalive_work,
 				      (ctx.next_run - ctx.now) * HZ);


