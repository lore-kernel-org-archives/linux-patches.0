Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D588481672;
	Tue, 25 Aug 2026 13:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666361; cv=none; b=HnG2Dyk9FEETiSKimfNFVkGxWNXLUgUWhUwyS++yQY3eiwVgxRoLiS8H9eCg0sW/ovQbLIOO6WASJKDTmC/9X6mQG6krAz+JVVyb3DyxZ2XNpBF4H0PPTj20WFPkwnU5AC8791yaYUA1gZ8vS1rfOi7ZNsnBrrOK5f039PSgMm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666361; c=relaxed/simple;
	bh=Za5Xo0m9jmbv3PEGxzFq3e757+lrokULs0CSV5gJVp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhO1pJ2cXXINHFujbnqZCeCpTQ/J7yYivVwcG0zlKA+PWC//E8+Dx/2lYKttoz+bh8aCvqj+iPvGlnI87mr+Af9UbrSUVeEOvl81gKnlN3KW0bR8QKPiy4OdvjNe7mr/yN55nIl/DuDSonTFZWGxhEy6QmSlqZ4FXeOmkhdv2jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZWylDtq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZWylDtq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFCA1F000E9;
	Tue, 25 Aug 2026 13:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666359;
	bh=sK25uCPkYG1vq6zuJNh4+L40eGsbXEdrCJkeab+qHlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZWylDtqdtY3EUxnDvZLG5gAbctARcznPqU+Y56A4GA6nrwI+xVZchbMAmg8Cxy4a
	 WNfaQqhKqJ2tgFVovl+purk14MZ9eb5puXuzgg6/Jg0gq4PgoHnLTx6N0OIq2GG+d5
	 855gGferZzury5YljebfIT/P98vSRRo+wl6pkOgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/57] perf: Fix cgroup state vs ERROR
Date: Tue, 25 Aug 2026 15:26:39 +0200
Message-ID: <20260825132541.961771957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 61988e36dc5457cdff7ae7927e8d9ad1419ee998 ]

While chasing down a missing perf_cgroup_event_disable() elsewhere,
Leo Yan found that both perf_put_aux_event() and
perf_remove_sibling_event() were also missing one.

Specifically, the rule is that events that switch to OFF,ERROR need to
call perf_cgroup_event_disable().

Unify the disable paths to ensure this.

Fixes: ab43762ef010 ("perf: Allow normal events to output AUX data")
Fixes: 9f0c4fa111dc ("perf/core: Add a new PERF_EV_CAP_SIBLING event capability")
Reported-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250605123343.GD35970@noisy.programming.kicks-ass.net
Stable-dep-of: 42c5ca1f0a28 ("perf/core: Fix group leader use-after-free after sibling detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   56 +++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2145,14 +2145,13 @@ perf_aux_output_match(struct perf_event
 }
 
 static void put_event(struct perf_event *event);
-static void event_sched_out(struct perf_event *event,
-			    struct perf_cpu_context *cpuctx,
-			    struct perf_event_context *ctx);
+static void __event_disable(struct perf_event *event,
+			    struct perf_event_context *ctx,
+			    enum perf_event_state state);
 
 static void perf_put_aux_event(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
-	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 	struct perf_event *iter;
 
 	/*
@@ -2181,8 +2180,7 @@ static void perf_put_aux_event(struct pe
 		 * state so that we don't try to schedule it again. Note
 		 * that perf_event_enable() will clear the ERROR status.
 		 */
-		event_sched_out(iter, cpuctx, ctx);
-		perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
+		__event_disable(iter, ctx, PERF_EVENT_STATE_ERROR);
 	}
 }
 
@@ -2236,21 +2234,6 @@ static inline struct list_head *get_even
 	return event->attr.pinned ? &ctx->pinned_active : &ctx->flexible_active;
 }
 
-/*
- * Events that have PERF_EV_CAP_SIBLING require being part of a group and
- * cannot exist on their own, schedule them out and move them into the ERROR
- * state. Also see _perf_event_enable(), it will not be able to recover
- * this ERROR state.
- */
-static inline void perf_remove_sibling_event(struct perf_event *event)
-{
-	struct perf_event_context *ctx = event->ctx;
-	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
-
-	event_sched_out(event, cpuctx, ctx);
-	perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
-}
-
 static void perf_group_detach(struct perf_event *event)
 {
 	struct perf_event *leader = event->group_leader;
@@ -2286,8 +2269,15 @@ static void perf_group_detach(struct per
 	 */
 	list_for_each_entry_safe(sibling, tmp, &event->sibling_list, sibling_list) {
 
+		/*
+		 * Events that have PERF_EV_CAP_SIBLING require being part of
+		 * a group and cannot exist on their own, schedule them out
+		 * and move them into the ERROR state. Also see
+		 * _perf_event_enable(), it will not be able to recover this
+		 * ERROR state.
+		 */
 		if (sibling->event_caps & PERF_EV_CAP_SIBLING)
-			perf_remove_sibling_event(sibling);
+			__event_disable(sibling, ctx, PERF_EVENT_STATE_ERROR);
 
 		sibling->group_leader = sibling;
 		list_del_init(&sibling->sibling_list);
@@ -2494,6 +2484,15 @@ static void perf_remove_from_context(str
 	}
 }
 
+static void __event_disable(struct perf_event *event,
+			    struct perf_event_context *ctx,
+			    enum perf_event_state state)
+{
+	event_sched_out(event, __get_cpu_context(ctx), ctx);
+	perf_cgroup_event_disable(event, ctx);
+	perf_event_set_state(event, state);
+}
+
 /*
  * Cross CPU call to disable a performance event
  */
@@ -2510,13 +2509,18 @@ static void __perf_event_disable(struct
 		update_cgrp_time_from_event(event);
 	}
 
+	/*
+	 * When disabling a group leader, the whole group becomes ineligible
+	 * to run, so schedule out the full group.
+	 */
 	if (event == event->group_leader)
 		group_sched_out(event, cpuctx, ctx);
-	else
-		event_sched_out(event, cpuctx, ctx);
 
-	perf_event_set_state(event, PERF_EVENT_STATE_OFF);
-	perf_cgroup_event_disable(event, ctx);
+	/*
+	 * But only mark the leader OFF; the siblings will remain
+	 * INACTIVE.
+	 */
+	__event_disable(event, ctx, PERF_EVENT_STATE_OFF);
 }
 
 /*


