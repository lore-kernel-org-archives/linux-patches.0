Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A8C408617;
	Mon, 17 Aug 2026 13:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975181; cv=none; b=myD2/L5pHnwQzIgY93tbSlQUsuS7x7r4ZSMCgCTPv2Idgk8+tphfInZee5V72lf7BpZL9kbQetuFk52T47ylg0Rji1YzlghTnL9JvmJ/RqkdhK0jtY9393vKb4g5Fr+cRFja/mAlPssAZs8NWCPGUQIRPbtqD9MibTNWKif/tss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975181; c=relaxed/simple;
	bh=bt/lzdkzycgDS5suLsfbvvV3dwdK24dSvAVMAm0tkwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqOiA79fktDfHdV/b0BgK5qkkBA9BzjREvJMmCv8WLKMWx/f4Qg/Rwykq8MRuy8cKwUHPkrcxDAvqH+j8elsOsYRquiX6HCrprogDqT8W6V5YUTn45Yc5UaybKH8tp6qJWsaPckiIoEEjdK3Cypb7RmRgTUxmsFBUGhen+FdSbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=md6hiL+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="md6hiL+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619CD1F000E9;
	Mon, 17 Aug 2026 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975179;
	bh=SgmkxlMl4ytLBLIyUDD22vkd4KTBnTpbR2bTGLnvdv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=md6hiL+GcnvRrsjduE+cA6F59DOzf1NNMkY8MUZmL20xH+yuqpCz9iNzw6R+0t+aE
	 pg25GtkcyCayLHV9veHSTarBJPcF/GnrqfZDCqjmD4aWExTiCmEAWW5CDPKn0B+n/t
	 OHjMBNVlbqbOBT7/fiVgF3X6/uRLCj5ln7ptypQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Chillara <aditya.chillara@oss.qualcomm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 6.18 189/250] perf/core: Fix group leader use-after-free after sibling detach
Date: Mon, 17 Aug 2026 15:32:30 +0200
Message-ID: <20260817132544.291284692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Aditya Chillara <aditya.chillara@oss.qualcomm.com>

commit 42c5ca1f0a288a52878bd72a5595b08261057438 upstream.

perf_group_detach() handles leader and sibling detach differently. When the
group leader is detached, all siblings are promoted to singleton events and
their group_leader pointer is reset to themselves. When a sibling is
detached, it is removed from the leader's sibling_list, but its
group_leader pointer is left pointing at the old leader.

That is harmless when the sibling is being closed and freed immediately, as
in the DETACH_DEAD path. It is not safe when the sibling is detached but
kept alive, such as during CPU hotplug with DETACH_GROUP. In that case the
sibling is removed from the context, while its file descriptor can still
keep it alive.

A typical failing sequence is:

  - A group contains leader L and sibling S.
  - CPU hot-unplug detaches S with DETACH_GROUP, removing it from
    L->sibling_list but leaving S->group_leader == L.
  - L is later closed and freed.
  - A PERF_IOC_FLAG_GROUP ioctl on S follows S->group_leader and
    dereferences the freed leader.

This was reproduced by running the perf event fuzzer, CPU hotplug, and a
stress workload concurrently:

  Unable to handle kernel paging request at virtual address 006b6b6b6b6b6cdb
  CPU: 2 PID: 12489 Comm: perf_fuzzer 6.18.7 PREEMPT
  pc : perf_ioctl+0x34c/0xc68
  x20: ffffff89a3fa2c70 x8 : 6b6b6b6b6b6b6b6b
  Code: 943c4a0e 340047a0 f9404a94 f9411e88 (f940b908)
  Call trace:
  perf_ioctl+0x34c/0xc68 (P)
  __arm64_sys_ioctl+0xa0/0xf4
  invoke_syscall+0x58/0xe4
  el0_svc_common+0xa8/0xdc
  do_el0_svc+0x1c/0x28
  el0_svc+0x40/0xc0
  el0t_64_sync_handler+0x68/0xdc
  el0t_64_sync+0x1c4/0x1c8

The fault happened in perf_ioctl(), where perf_event_for_each() follows
the stale group_leader pointer and perf_event_for_each_child() then
dereferences the freed leader's context.

Fix the use-after-free by promoting the detached sibling to a singleton.
Also fix __event_disable() cgroup accounting and event state change.

Fixes: 8a49542c0554 ("perf_events: Fix races in group composition")
Assisted-by: PatchWise:gpt-5.5
Signed-off-by: Aditya Chillara <aditya.chillara@oss.qualcomm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260807-fix-group-leader-uaf-v3-1-b0c2310c9a0d@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   67 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2248,6 +2248,34 @@ static inline struct list_head *get_even
 				    &event->pmu_ctx->flexible_active;
 }
 
+/* @sibling must already be unlinked from its old leader's sibling_list. */
+static void perf_promote_sibling_to_leader(struct perf_event *sibling,
+					   struct perf_event_context *ctx,
+					   int group_caps)
+{
+	/*
+	 * Events that have PERF_EV_CAP_SIBLING require being part of
+	 * a group and cannot exist on their own, schedule them out
+	 * and move them into the ERROR state. Also see
+	 * _perf_event_enable(), it will not be able to recover this
+	 * ERROR state.
+	 */
+	if (sibling->event_caps & PERF_EV_CAP_SIBLING)
+		__event_disable(sibling, ctx, PERF_EVENT_STATE_ERROR);
+
+	sibling->group_leader = sibling;
+	sibling->group_caps = group_caps;
+
+	if (sibling->attach_state & PERF_ATTACH_CONTEXT) {
+		add_event_to_groups(sibling, ctx);
+
+		if (sibling->state == PERF_EVENT_STATE_ACTIVE)
+			list_add_tail(&sibling->active_list, get_event_list(sibling));
+	}
+
+	perf_event__header_size(sibling);
+}
+
 static void perf_group_detach(struct perf_event *event)
 {
 	struct perf_event *leader = event->group_leader;
@@ -2271,8 +2299,9 @@ static void perf_group_detach(struct per
 	 */
 	if (leader != event) {
 		list_del_init(&event->sibling_list);
-		event->group_leader->nr_siblings--;
-		event->group_leader->group_generation++;
+		leader->nr_siblings--;
+		leader->group_generation++;
+		perf_promote_sibling_to_leader(event, ctx, event->event_caps);
 		goto out;
 	}
 
@@ -2282,32 +2311,14 @@ static void perf_group_detach(struct per
 	 * to whatever list we are on.
 	 */
 	list_for_each_entry_safe(sibling, tmp, &event->sibling_list, sibling_list) {
-
-		/*
-		 * Events that have PERF_EV_CAP_SIBLING require being part of
-		 * a group and cannot exist on their own, schedule them out
-		 * and move them into the ERROR state. Also see
-		 * _perf_event_enable(), it will not be able to recover this
-		 * ERROR state.
-		 */
-		if (sibling->event_caps & PERF_EV_CAP_SIBLING)
-			__event_disable(sibling, ctx, PERF_EVENT_STATE_ERROR);
-
-		sibling->group_leader = sibling;
 		list_del_init(&sibling->sibling_list);
 
 		/* Inherit group flags from the previous leader */
-		sibling->group_caps = event->group_caps;
-
-		if (sibling->attach_state & PERF_ATTACH_CONTEXT) {
-			add_event_to_groups(sibling, event->ctx);
-
-			if (sibling->state == PERF_EVENT_STATE_ACTIVE)
-				list_add_tail(&sibling->active_list, get_event_list(sibling));
-		}
+		perf_promote_sibling_to_leader(sibling, ctx, event->group_caps);
 
 		WARN_ON_ONCE(sibling->ctx != event->ctx);
 	}
+	event->nr_siblings = 0;
 
 out:
 	for_each_sibling_event(tmp, leader)
@@ -2494,12 +2505,7 @@ __perf_remove_from_context(struct perf_e
 	if (flags & DETACH_DEAD)
 		state = PERF_EVENT_STATE_DEAD;
 
-	event_sched_out(event, ctx);
-
-	if (event->state > PERF_EVENT_STATE_OFF)
-		perf_cgroup_event_disable(event, ctx);
-
-	perf_event_set_state(event, min(event->state, state));
+	__event_disable(event, ctx, state);
 
 	if (flags & DETACH_GROUP)
 		perf_group_detach(event);
@@ -2568,8 +2574,9 @@ static void __event_disable(struct perf_
 			    enum perf_event_state state)
 {
 	event_sched_out(event, ctx);
-	perf_cgroup_event_disable(event, ctx);
-	perf_event_set_state(event, state);
+	if (event->state > PERF_EVENT_STATE_OFF)
+		perf_cgroup_event_disable(event, ctx);
+	perf_event_set_state(event, min(event->state, state));
 }
 
 /*


