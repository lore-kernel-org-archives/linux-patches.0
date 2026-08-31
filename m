Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7CB4B53F8;
	Mon, 31 Aug 2026 13:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184347; cv=none; b=FmH0wiybqQyJviYw0j2FxxfjupEB/9HMheVfCQrWGbzHvX3GlFd3tQnN/fNbgGH9aF098mSbJ+tpU0E/KwtXIr0o2HBJAoyhTmjGxBf0uk8lBnRiBteSigqS0+4Y4gULvOQLxc+6KczRrfZxCcRWIWhJp7GMcD5hwxoW2PpZNFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184347; c=relaxed/simple;
	bh=G2VEtoRAwewj1f6xP5rqTSX4udqPDufR6MKFR80DjlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGaMk+3wtvl5rc2/Ouait/FxVnskZ/o9iqiU5PfyUTkN+BAiE/6Z8vd1SIN2QYqV+zccOIHgMtTMJq4N8nH/gkUGlvgjgQrr7asL+/Yi7YExziNtKmfcxSPpTH6SCsjeURSF40ZNjfY5yXuiOzZ7kHj+/fpQuKFj/st8UVxPY/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F87dZLJQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F87dZLJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5301F00A3D;
	Mon, 31 Aug 2026 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184346;
	bh=pvc1xK+6XkDNmakBZsKos1Netw3y3omjqbKPyT+Wxe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F87dZLJQMTssZurdKL+vmQmFUzPqJ8pqRBlryz8UoPEgQbZv/oo+DNVVRqhFOYrMn
	 mLxJbhdFpHThEgU5OpSXzu1pZKcePPq+J2uBs8rAX6Yp1uWvnXTmbRWcvsTjxHCDQ1
	 cDa8FhqhljXzKlactRjSOn7tZEEZOk7GhvXOD9uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eyal Birger <eyal.birger@gmail.com>,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.12 76/99] xfrm: bound nat keepalive state collection
Date: Mon, 31 Aug 2026 15:34:45 +0200
Message-ID: <20260831133403.719466731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit 4e9442ce551ebd84b52ad649df721e2dc28af95a upstream.

The v1 nat keepalive fix allocates a GFP_ATOMIC object for every state
while collecting references for phase two. This makes the worker's
temporary memory use depend on the number of states and lets -ENOMEM abort
the scan.

Replace the allocated list with a fixed-size batch. When the batch is full,
return a private walk status so xfrm_state_walk() leaves a cursor; drain
the references after the walk releases xfrm_state_lock and resume from
the cursor. This bounds temporary memory use and avoids the allocation
failure path.

The v1 fix also moved nat_keepalive_send() out of the walk callback. Keep
the phase-two drain BH-disabled, as required by local_lock_nested_bh()
used by the keepalive sockets.

Fixes: 763fe700b7c5 ("xfrm: avoid lock inversion in nat keepalive work")
Cc: stable@vger.kernel.org
Cc: Eyal Birger <eyal.birger@gmail.com>
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_nat_keepalive.c |   46 +++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

--- a/net/xfrm/xfrm_nat_keepalive.c
+++ b/net/xfrm/xfrm_nat_keepalive.c
@@ -155,32 +155,30 @@ static void nat_keepalive_send(struct na
 	}
 }
 
+enum {
+	NAT_KEEPALIVE_BATCH_SIZE = 16,
+	NAT_KEEPALIVE_BATCH_FULL = 1,
+};
+
 struct nat_keepalive_work_ctx {
-	struct list_head states;
+	struct xfrm_state *batch[NAT_KEEPALIVE_BATCH_SIZE];
+	unsigned int nr;
 	time64_t next_run;
 	time64_t now;
 };
 
-struct nat_keepalive_state {
-	struct list_head list;
-	struct xfrm_state *x;
-};
-
 static int nat_keepalive_work_collect(struct xfrm_state *x, int count, void *ptr)
 {
 	struct nat_keepalive_work_ctx *ctx = ptr;
-	struct nat_keepalive_state *state;
 
 	if (!READ_ONCE(x->nat_keepalive_interval))
 		return 0;
 
-	state = kmalloc_obj(*state, GFP_ATOMIC);
-	if (!state)
-		return -ENOMEM;
+	if (ctx->nr == ARRAY_SIZE(ctx->batch))
+		return NAT_KEEPALIVE_BATCH_FULL;
 
 	xfrm_state_hold(x);
-	state->x = x;
-	list_add_tail(&state->list, &ctx->states);
+	ctx->batch[ctx->nr++] = x;
 	return 0;
 }
 
@@ -226,29 +224,27 @@ out:
 
 static void nat_keepalive_work(struct work_struct *work)
 {
-	struct nat_keepalive_state *state, *tmp;
 	struct nat_keepalive_work_ctx ctx;
 	struct xfrm_state_walk walk;
 	struct net *net;
-	int err;
+	int err, i;
 
-	INIT_LIST_HEAD(&ctx.states);
 	ctx.next_run = 0;
 	ctx.now = ktime_get_real_seconds();
 
 	net = container_of(work, struct net, xfrm.nat_keepalive_work.work);
 	xfrm_state_walk_init(&walk, IPPROTO_ESP, NULL);
-	err = xfrm_state_walk(net, &walk, nat_keepalive_work_collect, &ctx);
+	do {
+		ctx.nr = 0;
+		err = xfrm_state_walk(net, &walk, nat_keepalive_work_collect, &ctx);
+		local_bh_disable();
+		for (i = 0; i < ctx.nr; i++) {
+			nat_keepalive_work_single(ctx.batch[i], &ctx);
+			xfrm_state_put(ctx.batch[i]);
+		}
+		local_bh_enable();
+	} while (err == NAT_KEEPALIVE_BATCH_FULL);
 	xfrm_state_walk_done(&walk, net);
-	list_for_each_entry_safe(state, tmp, &ctx.states, list) {
-		nat_keepalive_work_single(state->x, &ctx);
-		xfrm_state_put(state->x);
-		kfree(state);
-	}
-	if (err == -ENOMEM) {
-		schedule_delayed_work(&net->xfrm.nat_keepalive_work, 0);
-		return;
-	}
 	if (ctx.next_run)
 		schedule_delayed_work(&net->xfrm.nat_keepalive_work,
 				      (ctx.next_run - ctx.now) * HZ);


