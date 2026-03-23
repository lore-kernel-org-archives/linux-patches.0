Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF4E3B2FD4;
	Mon, 23 Mar 2026 14:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275004; cv=none; b=dO2gYhjgFZWdSL861NV28G8pNWVUbr8IkJd3kap7pN2t49lc1RlOD6IIuIgAb4Ni80H786UGVxk17TbnHBTpRdSAEysWiQSetjUy9r9JP2OEpHIoXmjMejAO32h9CdOnCG3ixYLj6ZH/avuIOjFrsFwyrtT52ufm0gfYyokNbyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275004; c=relaxed/simple;
	bh=7CGcG6Ba1/Hue0o67wba5zg7Okg0eQm70Gj10wRxfpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdoGXVBQKhmD7wLtLUvik20rHlGdSExzvByoY3Ac2MeGm4a/JjyA7cowbHRrHXQVerqXNGSESk4vxJSR+pbFjSDLKkx7pp5NE7OeNf5YdTyUfYyQXNdszj9qUn5Zy2AfhPKrNLZEpLCGuTGPMkKZd9q0CAH6nFrCoLzEuBOIxEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEnGKHMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEnGKHMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C22C2BCB1;
	Mon, 23 Mar 2026 14:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275004;
	bh=7CGcG6Ba1/Hue0o67wba5zg7Okg0eQm70Gj10wRxfpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEnGKHMQi/kBTUB8YoUEzhXdOvZ7I9/ASCQvolbalugrglDDrg/G3IJdCkfOiUNp1
	 O+tRKiguPkCk2p+zEFsdanKKqQ++8sb+iREmVmWKkSjV+NfDqVc0No6LlxSRTGkgII
	 z9qbgXZD4Dz2j8Wvik/laVuz00gUC/qikMy1VnUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 190/212] perf/x86: Move event pointer setup earlier in x86_pmu_enable()
Date: Mon, 23 Mar 2026 14:46:51 +0100
Message-ID: <20260323134509.740691924@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 8d5fae6011260de209aaf231120e8146b14bc8e0 upstream.

A production AMD EPYC system crashed with a NULL pointer dereference
in the PMU NMI handler:

  BUG: kernel NULL pointer dereference, address: 0000000000000198
  RIP: x86_perf_event_update+0xc/0xa0
  Call Trace:
   <NMI>
   amd_pmu_v2_handle_irq+0x1a6/0x390
   perf_event_nmi_handler+0x24/0x40

The faulting instruction is `cmpq $0x0, 0x198(%rdi)` with RDI=0,
corresponding to the `if (unlikely(!hwc->event_base))` check in
x86_perf_event_update() where hwc = &event->hw and event is NULL.

drgn inspection of the vmcore on CPU 106 showed a mismatch between
cpuc->active_mask and cpuc->events[]:

  active_mask: 0x1e (bits 1, 2, 3, 4)
  events[1]:   0xff1100136cbd4f38  (valid)
  events[2]:   0x0                 (NULL, but active_mask bit 2 set)
  events[3]:   0xff1100076fd2cf38  (valid)
  events[4]:   0xff1100079e990a90  (valid)

The event that should occupy events[2] was found in event_list[2]
with hw.idx=2 and hw.state=0x0, confirming x86_pmu_start() had run
(which clears hw.state and sets active_mask) but events[2] was
never populated.

Another event (event_list[0]) had hw.state=0x7 (STOPPED|UPTODATE|ARCH),
showing it was stopped when the PMU rescheduled events, confirming the
throttle-then-reschedule sequence occurred.

The root cause is commit 7e772a93eb61 ("perf/x86: Fix NULL event access
and potential PEBS record loss") which moved the cpuc->events[idx]
assignment out of x86_pmu_start() and into step 2 of x86_pmu_enable(),
after the PERF_HES_ARCH check. This broke any path that calls
pmu->start() without going through x86_pmu_enable() -- specifically
the unthrottle path:

  perf_adjust_freq_unthr_events()
    -> perf_event_unthrottle_group()
      -> perf_event_unthrottle()
        -> event->pmu->start(event, 0)
          -> x86_pmu_start()     // sets active_mask but not events[]

The race sequence is:

  1. A group of perf events overflows, triggering group throttle via
     perf_event_throttle_group(). All events are stopped: active_mask
     bits cleared, events[] preserved (x86_pmu_stop no longer clears
     events[] after commit 7e772a93eb61).

  2. While still throttled (PERF_HES_STOPPED), x86_pmu_enable() runs
     due to other scheduling activity. Stopped events that need to
     move counters get PERF_HES_ARCH set and events[old_idx] cleared.
     In step 2 of x86_pmu_enable(), PERF_HES_ARCH causes these events
     to be skipped -- events[new_idx] is never set.

  3. The timer tick unthrottles the group via pmu->start(). Since
     commit 7e772a93eb61 removed the events[] assignment from
     x86_pmu_start(), active_mask[new_idx] is set but events[new_idx]
     remains NULL.

  4. A PMC overflow NMI fires. The handler iterates active counters,
     finds active_mask[2] set, reads events[2] which is NULL, and
     crashes dereferencing it.

Move the cpuc->events[hwc->idx] assignment in x86_pmu_enable() to
before the PERF_HES_ARCH check, so that events[] is populated even
for events that are not immediately started. This ensures the
unthrottle path via pmu->start() always finds a valid event pointer.

Fixes: 7e772a93eb61 ("perf/x86: Fix NULL event access and potential PEBS record loss")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260310-perf-v2-1-4a3156fce43c@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1359,6 +1359,8 @@ static void x86_pmu_enable(struct pmu *p
 			else if (i < n_running)
 				continue;
 
+			cpuc->events[hwc->idx] = event;
+
 			if (hwc->state & PERF_HES_ARCH)
 				continue;
 
@@ -1366,7 +1368,6 @@ static void x86_pmu_enable(struct pmu *p
 			 * if cpuc->enabled = 0, then no wrmsr as
 			 * per x86_pmu_enable_event()
 			 */
-			cpuc->events[hwc->idx] = event;
 			x86_pmu_start(event, PERF_EF_RELOAD);
 		}
 		cpuc->n_added = 0;


