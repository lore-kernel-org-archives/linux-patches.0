Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819635A515C;
	Mon, 31 Aug 2026 13:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184339; cv=none; b=KdLafgCbi/OFk8UjRzF/fnc99BF6J78Ol98seOY+sDud5AsroP/CUcDJiEvPla/aFYQSpYXpvG7Xpfwu2GmVMIXCYqkUwKL67wdPHHmSTFwak0VhgENgqNwxVSRqVlJ5lOgyvGExrUw+cWSEKJu4QmtTk4MHn9pOfWll1hg5v/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184339; c=relaxed/simple;
	bh=aQk0J4f+LeG1gI7ZpmGOWvXbY5LwQhIxr3dU/VnadHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBvxTQodW57Mq10C8dYPJBZDhCNAuPeFRvQz7Wpx55w7nf0IFB0EakZQTQ76LVEgWaXysDdNLp1YzT82kYmGoCqPlBV09BqOO59IGp68oN/h7CISzugeE8p13xUF/8dtdTZxRJ40g/TDyzyK6HHY8YP8XeBXt/wIyhNOT27vdpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXAXF4SQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXAXF4SQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4921F00A3E;
	Mon, 31 Aug 2026 13:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184337;
	bh=SqQVq24lkWxhF5NYhcXzDRCIid4b4R4kAcwo5ohsJt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXAXF4SQ4Xr3tFLatyf1a0F/xha4WcJBPWV5+xBhSblE6QgTqvQ5Sht/HDFtY8r6l
	 +/kCQGLuoyOg7u1/iUwHd1nlCoRaf2D8odh2XzC3u8xxMg/Hoa4Q+HCg2GMxxrp/7B
	 GDUQIt2clGyRdPhK06XIKlJdkuwEkKa/laX+KPKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.12 73/99] xfrm: avoid lock inversion in nat keepalive work
Date: Mon, 31 Aug 2026 15:34:42 +0200
Message-ID: <20260831133403.598076989@linuxfoundation.org>
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
 net/xfrm/xfrm_nat_keepalive.c | 57 +++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 9 deletions(-)

diff --git a/net/xfrm/xfrm_nat_keepalive.c b/net/xfrm/xfrm_nat_keepalive.c
index eb1b6f67739e..8679c68c10a1 100644
--- a/net/xfrm/xfrm_nat_keepalive.c
+++ b/net/xfrm/xfrm_nat_keepalive.c
@@ -156,24 +156,51 @@ static void nat_keepalive_send(struct nat_keepalive *ka)
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
@@ -187,29 +214,41 @@ static int nat_keepalive_work_single(struct xfrm_state *x, int count, void *ptr)
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
-- 
2.55.0



