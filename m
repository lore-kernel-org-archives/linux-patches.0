Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFB52DC32D;
	Tue,  2 Sep 2025 13:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819347; cv=none; b=jmnwV1k0zpPXhJPI34tyGHhPLYVectMxLrWv8obU60sSW6xDsLX+DziuOEjT+5A1JRJGNc8GrlkaSlM2oKkbcZPT2zU2IRKh5jWhvwCmXGbpJYLH+NT7vrYKgJ4j7CfmkEL/iMpZWJhR6+fOaGbCxarSgV0SUAWxZd/clqq67YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819347; c=relaxed/simple;
	bh=hCmOYYHoGKo7jQ8k4NC0nnI+UNme1MYboiO67WvBW64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHcRtEwGNYIKFl/MXER3ZDAQgnHoZPN9cwYIDnCOSR0Da3a4j3Ye5B4/lbFX5wIieg/1qcks80A1+Dw7sgqVWDmn+VPUlUwSBv97UiCZhQYmx+AJL+lgocTDy2FlbrQdAyZ76HHHd5i+wQ1jPT6wwVnUIfUjOTg15T0S1qrW5fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIgVq8r3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIgVq8r3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE90C4CEED;
	Tue,  2 Sep 2025 13:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819346;
	bh=hCmOYYHoGKo7jQ8k4NC0nnI+UNme1MYboiO67WvBW64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIgVq8r39RdYkUjMkTA/cO6dSqU/QBTb766rbVvnMt9rFxFbE0iUVsBfkF2XkhW0m
	 pO75KClItLWgNDKxNPYvcNlMebZMRxySbd8FIsZzDCDbWTphrE1e+2W5/Q154ZIJta
	 Esx3P20hyUkU7PqErcnMTE/ZJNxX1VlVQSRVqgoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <ysk@kzalloc.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 001/142] perf: Avoid undefined behavior from stopping/starting inactive events
Date: Tue,  2 Sep 2025 15:18:23 +0200
Message-ID: <20250902131948.213881711@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunseong Kim <ysk@kzalloc.com>

[ Upstream commit b64fdd422a85025b5e91ead794db9d3ef970e369 ]

Calling pmu->start()/stop() on perf events in PERF_EVENT_STATE_OFF can
leave event->hw.idx at -1. When PMU drivers later attempt to use this
negative index as a shift exponent in bitwise operations, it leads to UBSAN
shift-out-of-bounds reports.

The issue is a logical flaw in how event groups handle throttling when some
members are intentionally disabled. Based on the analysis and the
reproducer provided by Mark Rutland (this issue on both arm64 and x86-64).

The scenario unfolds as follows:

 1. A group leader event is configured with a very aggressive sampling
    period (e.g., sample_period = 1). This causes frequent interrupts and
    triggers the throttling mechanism.
 2. A child event in the same group is created in a disabled state
    (.disabled = 1). This event remains in PERF_EVENT_STATE_OFF.
    Since it hasn't been scheduled onto the PMU, its event->hw.idx remains
    initialized at -1.
 3. When throttling occurs, perf_event_throttle_group() and later
    perf_event_unthrottle_group() iterate through all siblings, including
    the disabled child event.
 4. perf_event_throttle()/unthrottle() are called on this inactive child
    event, which then call event->pmu->start()/stop().
 5. The PMU driver receives the event with hw.idx == -1 and attempts to
    use it as a shift exponent. e.g., in macros like PMCNTENSET(idx),
    leading to the UBSAN report.

The throttling mechanism attempts to start/stop events that are not
actively scheduled on the hardware.

Move the state check into perf_event_throttle()/perf_event_unthrottle() so
that inactive events are skipped entirely. This ensures only active events
with a valid hw.idx are processed, preventing undefined behavior and
silencing UBSAN warnings. The corrected check ensures true before
proceeding with PMU operations.

The problem can be reproduced with the syzkaller reproducer:

Fixes: 9734e25fbf5a ("perf: Fix the throttle logic for a group")
Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20250812181046.292382-2-ysk@kzalloc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 8060c2857bb2b..872122e074e5f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2665,6 +2665,9 @@ static void perf_log_itrace_start(struct perf_event *event);
 
 static void perf_event_unthrottle(struct perf_event *event, bool start)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return;
+
 	event->hw.interrupts = 0;
 	if (start)
 		event->pmu->start(event, 0);
@@ -2674,6 +2677,9 @@ static void perf_event_unthrottle(struct perf_event *event, bool start)
 
 static void perf_event_throttle(struct perf_event *event)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return;
+
 	event->hw.interrupts = MAX_INTERRUPTS;
 	event->pmu->stop(event, 0);
 	if (event == event->group_leader)
-- 
2.50.1



