Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215290;
	b=Fm0yME5oNgyhcSpImJF06593JCYIkmWcJTv4BPj2DhgrAAB0GKdNvQgBSmJAs/8hVH14
	 IdKHCL+Q6k+eOOQN50Bx9NK7UPZ+k0hDhCO1P4kEZO+YsECA/AKgF4wNIQN68viEx7z+N
	 IJSVQTupIp83Kw8IBPvuY9twEvJgPUEUQRvgLOg8zdoW4fou87J+qlG7QpsSBnWLB3cUR
	 5YxFDGAPafEkiwav/89mzbRAUStd/Tc8tYeO+OBkd5XRDG/6g+eo1ZnUrvX1CsZjokGaH
	 blLFJVuHapxlbcqkjoIvQgxOkxpKM6JVW1NfYnbH5l3w5O6HKZP6cvmpZ1NIrp3EKFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VIqXL948/FgS6Pynh89ZyPMoNM5PtVy4HunEanjLcAc=;
	b=NFCEJ9PHqTqT0LwkbScKmQX2OReYrjp4yq8LfNx9r6gyd5zKmgviQ8weH94CT9ez1oNl
	 bJgn8G+C6QICFlqaYsGMDmw8RvWg5SGj+0Syiv/W2IHRcBXLv8NNcRMmit7S2kz8AQVqV
	 rtr/WkrORlpAcWNCK9H5E9ug5ti+Xdy4kAVl2NCJwKTeWmCotK7eFN/rvHnYBgexapF1a
	 n+ugaZnGStHda1oJxCIsAN167acteo+YSIUFJoZtAEa8ZMczq+7Z/WCWOpKMv6F3rOrd4
	 s3QOHZUuWud2hVfbKNTiDyS2DP0oWD0K96k4Xk3yFA1WkYEiC3d0YgW2zcSVADj4Lag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EUHyhFR+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117D8606A31A;
	Wed, 28 Oct 2026 19:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EUHyhFR+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F901F01825;
	Wed, 28 Oct 2026 19:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215289;
	bh=VIqXL948/FgS6Pynh89ZyPMoNM5PtVy4HunEanjLcAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUHyhFR+qeTYNOAzq+3aVlK53OuASEPy6anheuYE0dogxLzj7Q2Q5faUFP3UaTkoH
	 VN7R/3WGyCKy8zdHRoWnFxG0wAMAFvpkn2SD94yUrCFTrtsXlJjMTSCUGVuLxDt4xA
	 Xd66/pIC7U3gRvKPSYXgND5fdvVMk+TMjjHK6CPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1159/1887] perf/core: Detach event groups during remove_on_exec
Date: Wed, 28 Oct 2026 17:54:15 +0100
Message-ID: <20261028170525.778805149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taeyang Lee <0wn@theori.io>

[ Upstream commit 037a3c43edfb597665dd34457cd22b14692f2ba3 ]

perf_event_remove_on_exec() removes events by calling
perf_event_exit_event(). For top-level events, this removes the event from
the context with DETACH_EXIT only.

This can leave inconsistent group state when a removed event is a group
leader and the group contains siblings without remove_on_exec. If the group
was active, the surviving siblings can remain active and attached to the
removed leader's sibling list, but are no longer represented by a valid
group leader on the PMU context active lists.

A later close of the removed leader uses DETACH_GROUP and can promote the
still-active siblings from this stale group state. The next schedule-in can
then add an already-linked active_list entry again, corrupting the PMU
context active list.

With DEBUG_LIST enabled, this is caught as a list_add double-add in
merge_sched_in().

Fix this by detaching group relationships when remove_on_exec removes an
event. This preserves the existing task-exit and revoke behavior, while
ensuring surviving siblings are ungrouped before the removed event leaves
the context.

Fixes: 2e498d0a74e5 ("perf: Add support for event removal on exec")
Signed-off-by: Taeyang Lee <0wn@theori.io>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/ai65GgZcC0LAlWLG@Taeyangs-MacBook-Pro.local
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 49b79617723ab..972686eec8125 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4345,7 +4345,8 @@ static void perf_event_enable_on_exec(int ctxn)
 
 static void perf_remove_from_owner(struct perf_event *event);
 static void perf_event_exit_event(struct perf_event *event,
-				  struct perf_event_context *ctx);
+				  struct perf_event_context *ctx,
+				  unsigned long detach_flags);
 
 /*
  * Removes all events from the current task that have been marked
@@ -4376,7 +4377,7 @@ static void perf_event_remove_on_exec(int ctxn)
 
 		modified = true;
 
-		perf_event_exit_event(event, ctx);
+		perf_event_exit_event(event, ctx, DETACH_GROUP);
 	}
 
 	raw_spin_lock_irqsave(&ctx->lock, flags);
@@ -13044,10 +13045,10 @@ static void sync_child_event(struct perf_event *child_event)
 }
 
 static void
-perf_event_exit_event(struct perf_event *event, struct perf_event_context *ctx)
+perf_event_exit_event(struct perf_event *event, struct perf_event_context *ctx,
+		      unsigned long detach_flags)
 {
 	struct perf_event *parent_event = event->parent;
-	unsigned long detach_flags = 0;
 
 	if (parent_event) {
 		/*
@@ -13062,7 +13063,7 @@ perf_event_exit_event(struct perf_event *event, struct perf_event_context *ctx)
 		 * Do destroy all inherited groups, we don't care about those
 		 * and being thorough is better.
 		 */
-		detach_flags = DETACH_GROUP | DETACH_CHILD;
+		detach_flags |= DETACH_GROUP | DETACH_CHILD;
 		mutex_lock(&parent_event->child_mutex);
 	}
 
@@ -13141,7 +13142,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	perf_event_task(child, child_ctx, 0);
 
 	list_for_each_entry_safe(child_event, next, &child_ctx->event_list, event_entry)
-		perf_event_exit_event(child_event, child_ctx);
+		perf_event_exit_event(child_event, child_ctx, 0);
 
 	mutex_unlock(&child_ctx->mutex);
 
-- 
2.53.0



