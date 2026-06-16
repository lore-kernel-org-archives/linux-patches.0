Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A9035DA6A;
	Tue, 16 Jun 2026 16:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628191; cv=none; b=tIYadx+5OMgrzxVnpKYWEnYtapP7C7UwcDTX2aE36vZKY5D2rR03zKxtobz42u/z7/dcg0Br9ceAd7+ia/Lzs6BibxXwEZp+DHXT3EAwpoZIAwC9GdXYnrCTyIKXjrETG/pFekFR7qS/Xf8D7gIBLrab66BGJdzcVPM+kgGcFh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628191; c=relaxed/simple;
	bh=lgf8N2EDsS7HZa44lJSLHlEnai3qL1TIGTUGZYXWBYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udXd91dLyFmCffcBNrbw41xuE6R0+og/4sUJiO7itBeFmrCrUwHF0Kqyu6JaCLouKsZdS1crT/VS9raFkS2UGqwBGUQhUWaZmDwYlT8nRnMpbmLg1B/Abpr97PC966mpFcNPRX1k4xUtJ1LCG2o3v1OFTor198bRW8AVq/zftDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFMc2Ztr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFMc2Ztr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FF51F000E9;
	Tue, 16 Jun 2026 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628190;
	bh=5hrsMiN/LJm35TWAge8LU0/5KdPGgUmNrajQ10Z1o1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFMc2Ztrt79pfU8riIx4YloZaPALZf+h7sSFxRebM4XV1QWhuQk0NOuJ6BhlWdDxJ
	 UNWBINjQwVo5JdcIr08HyA4d/qbWlEw1/SX7af/Yms5zoY5eb1r7yIDgqlXaloNd7p
	 z+BFwU5DLENUefsTGXTktgDGBv3rqv5/ycgAxii4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	David Wang <00107082@163.com>,
	Ian Klatzco <iklatzco@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/452] perf: Fix dangling cgroup pointer in cpuctx
Date: Tue, 16 Jun 2026 20:24:36 +0530
Message-ID: <20260616145120.525872058@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index eba5eb6fcb8762..a4187dea6402a7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2056,18 +2056,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
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
@@ -2401,6 +2389,10 @@ __perf_remove_from_context(struct perf_event *event,
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



