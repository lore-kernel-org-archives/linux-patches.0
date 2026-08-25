Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6283FAE19;
	Tue, 25 Aug 2026 13:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665901; cv=none; b=P/yeMW18n1WIIpRIvSxcC0Pscr06ejJ8L7wsx2SZ8A/tEgSuybFb+jvmdxjqWsuRtdrhv22z3LbYSow4LTLnR2lckNeMv5AHpm2FWh8+pnaabzUMc1NQYdDmd28d/PEh97zpz+5vY2LRfVhARzv3GZDnc5rqsck4FQD0C4c/by8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665901; c=relaxed/simple;
	bh=KmQfg11IWIpuDBQKTQTyI5AAmwWIV0UoIaWbClElVfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrVmfQZcYWPNU0eixNcZ9GKynIQzBJTQJz3KPqa/XGTi0oLTkOftxqggjWjlBlpADf+frE/g1WhyRjFjEuikjZeLDQTn8Af/hnqHLqisijY2pLqM/YVfrUAd8SQM1tDj6ZTX/VRQy665vqw+hvEi1pwbwoF3Ji/BxIzl6bNuDeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oxEcJC8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oxEcJC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0AF1F000E9;
	Tue, 25 Aug 2026 13:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665900;
	bh=VaVPhwsIWhH+a0oZ1oiwFzl/uKCoXbELEddCLm3Apj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2oxEcJC8Y1rsgdK2Bw/fi2s/n/8QQVzqhXzmPe0DvfLVZFQzWH8GxSbet+ypj2277
	 T7/b11kbPfS1Ny8+RuLUtpkFAMryAPW4b4yOHLIB2vEJRc8Xrl1RrXZAYU5+7TCG9h
	 ZekYzPunct98vXmQG+ydVRohFR9uADZ/xQZJMYTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	David Wang <00107082@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/79] perf: Fix dangling cgroup pointer in cpuctx
Date: Tue, 25 Aug 2026 15:25:57 +0200
Message-ID: <20260825132542.348550048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 42c5ca1f0a28 ("perf/core: Fix group leader use-after-free after sibling detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2031,18 +2031,6 @@ list_del_event(struct perf_event *event,
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
 }
 
@@ -2396,6 +2384,10 @@ __perf_remove_from_context(struct perf_e
 		state = PERF_EVENT_STATE_DEAD;
 	}
 	event_sched_out(event, cpuctx, ctx);
+
+	if (event->state > PERF_EVENT_STATE_OFF)
+		perf_cgroup_event_disable(event, ctx);
+
 	perf_event_set_state(event, min(event->state, state));
 	if (flags & DETACH_GROUP)
 		perf_group_detach(event);


