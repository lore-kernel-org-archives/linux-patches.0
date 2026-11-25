Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623223;
	b=3Fp8JFFerh/2FJEeGlL6PSUf3AWVFcibxkYoNnXUsV9k5cz+Hl5U3Kh3JbE4g3CdS1SX
	 NWzkS4VmQ6TxJvtzo3XkYWA8CyuWX1L7gWt09IvvGp2FqVczg84qkMDIP2apv4tvX/83+
	 8Im3Vv3EBrtUsN/GnE3YeR+I+4YnmdaOj4woIlDD7lMepi/lQgybQ1CBfJ0iToWKye4Dk
	 lmLP16LDK0+1XgWGoHqqhCUNrOiETsHh8LsOQeXwZZ7xNSTrVvq+PVrr5AX9Vn8mXRyva
	 WHbVTf8wa7dCuczshDcu5RRyDGPWGs/G9fYSj5Z8SxHOCDl43j9/dy3Gbkcc3lnTx9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nExfNW+gtgkmejlah2qdrHdtkfKQgV8kzJwz28TWxPA=;
	b=urdBfrz0skX47A0gFgWSrnUEs+rbpgDReNXv6EYXYvjhuYxBUVPh01OSD/n2EkPk+1EK
	 TBrsFHFOs2i/RNM/vsXSubNS4Lb/vlCD9wX06dVVg/YwKcw+zWt4A7x2/1lMXRiPo4nqK
	 az6BpXy6d4s5OOyjx15UMvPCNjK8S7P2AqdK8dMIXjdc18kWE+SDUOXrEr29N2MBbp9wk
	 Wgsgo0zB/XDXwYRZ/DPhA9Q3tv6fa1YF622oEE6n6MFoWmO3AT2qMVBHyCjZkkZIUglgh
	 Tf4DkpN/Th8FBfHKDZnrBCM4HLxjT8/36gJ1B3CiI3ABpZA1xBhR/nDSglcymrlhtJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cpIooOGd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2FF606A321;
	Wed, 25 Nov 2026 16:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cpIooOGd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EE81F000C6;
	Wed, 25 Nov 2026 16:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623223;
	bh=nExfNW+gtgkmejlah2qdrHdtkfKQgV8kzJwz28TWxPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpIooOGdjSoioM2LwhbFyrRpIaW6QJafVSVZA65Io4ZMruZkG14mvLej6CGCuoH5H
	 wLvYqWa/oFiniKfLReyOxVCXtvUyrubsgrpH+boUjQ9QLyh06dTGgme9g7r5zIrmpb
	 9H63vt1oY+yEeTKqQgM/qcDEAJiOzOlmythRj1/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phat Dinh <phatdt1116@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 735/990] perf/core: Do not resurrect cpuctx->cgrp after last cgroup event exit
Date: Wed, 25 Nov 2026 15:35:02 +0100
Message-ID: <20261125143839.285930144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phat Dinh <phatdt1116@gmail.com>

commit 59f1398140869432c7171b9a2a279ca315467c4e upstream.

perf_cgroup_switch() relies on:

    /*
     * cpuctx->cgrp is set when the first cgroup event enabled,
     * and is cleared when the last cgroup event disabled.
     */

It computes the next task's cgroup, schedules out the CPU context and
then assigns cpuctx->cgrp unconditionally:

    ctx_sched_out(&cpuctx->ctx, NULL, EVENT_ALL|EVENT_CGROUP);
    /*
     * must not be done before ctxswout due
     * to update_cgrp_time_from_cpuctx() in
     * ctx_sched_out()
     */
    cpuctx->cgrp = cgrp;

However, ctx_sched_out() can disable events itself. If a cgroup event
has a pending disable from perf_event_disable_inatomic() (e.g. its
PERF_EVENT_IOC_REFRESH limit ran out) that the irq_work has not
handled yet, event_sched_out() consumes it inline:

    if (event->pending_disable) {
        event->pending_disable = 0;
        perf_cgroup_event_disable(event, ctx);
        state = PERF_EVENT_STATE_OFF;
    }

If that was the last cgroup event, perf_cgroup_event_disable() clears
cpuctx->cgrp:

    if (--ctx->nr_cgroups)
        return;

    cpuctx->cgrp = NULL;

and perf_cgroup_switch() then sets it again. cpuctx->cgrp is left
non-NULL with ctx.nr_cgroups == 0, so the NULL check in
perf_cgroup_switch() no longer catches it and the next switch trips:

    WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);

cpuctx->cgrp does not hold a reference on the cgroup. Once that cgroup
is removed, the next ctx_sched_in() dereferences the stale pointer:

  BUG: KASAN: slab-use-after-free in ctx_sched_in+0xb1f/0xfa0
  Read of size 8 at addr ffff8881008972d0 by task swapper/3/0

  Tainted: [W]=WARN
  Call Trace:
   <IRQ>
   ctx_sched_in+0xb1f/0xfa0
   perf_event_sched_in+0x1a/0x70
   ctx_resched+0x32b/0xac0
   __perf_install_in_context+0x475/0xab0
   remote_function+0x105/0x200
   __flush_smp_call_function_queue+0x179/0x8d0
   __sysvec_call_function_single+0x1b/0x1c0
   sysvec_call_function_single+0x66/0x80
   </IRQ>
   <TASK>
   asm_sysvec_call_function_single+0x1a/0x20

Only assign cpuctx->cgrp when cgroup events remain after the context
has been scheduled out, so that it stays NULL as the invariant
requires.

Fixes: e19cd0b6fa59 ("perf/core: Always set cpuctx cgrp when enable cgroup event")
Signed-off-by: Phat Dinh <phatdt1116@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261106101642.494674-1-phatdt1116@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -971,8 +971,13 @@ static void perf_cgroup_switch(struct ta
 	 * must not be done before ctxswout due
 	 * to update_cgrp_time_from_cpuctx() in
 	 * ctx_sched_out()
+	 *
+	 * ctx_sched_out() can consume a pending disable and drop the last cgroup
+	 * event, which clear the cpuctx->cgrp. Cgroup tracking follow active cgroup
+	 * event, so do not resurrect it
 	 */
-	cpuctx->cgrp = cgrp;
+	if (cpuctx->ctx.nr_cgroups)
+		cpuctx->cgrp = cgrp;
 	/*
 	 * set cgrp before ctxsw in to allow
 	 * perf_cgroup_set_timestamp() in ctx_sched_in()


