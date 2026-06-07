Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9C92D8378;
	Sun,  7 Jun 2026 10:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827918; cv=none; b=hFO1q3JyRO3uyOviUUnkzXKxhkBpHhQQwHFCGJknw3gU0rlxl4g0kYRHFtVP9RcyFIopZg4sHshT54566hXVHXZrbcXCJG2bJFt7O8QQz1tuQDwMRUAcl+pFuUOWuboU+ubDpPVMkL1CxXHO/BwYatvjTO6Fwdu+XY9p4/6PXP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827918; c=relaxed/simple;
	bh=eMT5nf4HoFlAaO/6WFMrNxR/fyCM2ZtyJhWBHesHb4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0WmVG291E4zivE/AD3w9G8kByx8ybI70lNSgC1PvDHHhbjZBrEttpM7gJWZioquanesZZbubRLyg/0jpwzxFY64KaZArIcNUu/9hW98OJeMxT07ekogwyj5QMPSnK9WyWsNH+eY0xnyT+M3I4ehhher9irWasBWX+Mq7AiwNrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/WRBVT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/WRBVT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686691F00893;
	Sun,  7 Jun 2026 10:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827917;
	bh=01FM/Vxw/X1FFEyM5u1rMXFPnVgswHj7YCHXGtcT/gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/WRBVT41OErr3CXH7Be0eQYO7ozvcHql/rjwVv7n/uk6R0nJb+j7T1jO3bYFqfQc
	 5c4xJDjVUrJDCVahzljPJQ/1PprXzG45W1UbYtEo1GDiG2973ZvDt85DIi68Fq/0GK
	 u6RzHCAknJJPJh4JMo7SgxstGOYaTZW6pxDM4xAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	David Wang <00107082@163.com>,
	Ian Klatzco <iklatzco@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/307] perf: Fix dangling cgroup pointer in cpuctx
Date: Sun,  7 Jun 2026 11:58:13 +0200
Message-ID: <20260607095731.302394407@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 3b7a34aebbdf2a4b7295205bf0c654294283ec82 ]

Commit a3c3c6667("perf/core: Fix child_total_time_enabled accounting
bug at task exit") moves the event->state update to before
list_del_event(). This makes the event->state test in list_del_event()
always false; never calling perf_cgroup_event_disable().

As a result, cpuctx->cgrp won't be cleared properly; causing havoc.

Fixes: a3c3c6667("perf/core: Fix child_total_time_enabled accounting bug at task exit")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: David Wang <00107082@163.com>
Link: https://lore.kernel.org/all/aD2TspKH%2F7yvfYoO@e129823.arm.com/
Signed-off-by: Ian Klatzco <iklatzco@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6fce2bac6dae52..9099c0cc933be2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2096,18 +2096,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (event->group_leader == event)
 		del_event_from_groups(event, ctx);
 
-	/*
-	 * If event was in error state, then keep it
-	 * that way, otherwise bogus counts will be
-	 * returned on read(). The only way to get out
-	 * of error state is by explicit re-enabling
-	 * of the event
-	 */
-	if (event->state > PERF_EVENT_STATE_OFF) {
-		perf_cgroup_event_disable(event, ctx);
-		perf_event_set_state(event, PERF_EVENT_STATE_OFF);
-	}
-
 	ctx->generation++;
 	event->pmu_ctx->nr_events--;
 }
@@ -2457,6 +2445,10 @@ __perf_remove_from_context(struct perf_event *event,
 		state = PERF_EVENT_STATE_DEAD;
 	}
 	event_sched_out(event, ctx);
+
+	if (event->state > PERF_EVENT_STATE_OFF)
+		perf_cgroup_event_disable(event, ctx);
+
 	perf_event_set_state(event, min(event->state, state));
 	if (flags & DETACH_GROUP)
 		perf_group_detach(event);
-- 
2.53.0



