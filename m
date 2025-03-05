Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF182517BC;
	Wed,  5 Mar 2025 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198112; cv=none; b=Kp3x7CRB9NzC3vVlTTSFfRn/vIrmRQY7SHGzz8D4pRISKKfwSgIsZdOoB0f5Upi+g/V8dciwQTA9Sy4J2tMKSWoA7CnHskmSWjRS5hoi1ntKIngaxOXhljtd3xaK8f+jm3/etQWrODWf112dNzK6WlPoD4aZFwsu3qtgt66Or7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198112; c=relaxed/simple;
	bh=YFcPFqGJJ2mrwbdUZqmK+X6WJFpV6g5RXKlODTX1hCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iq8zCKrFwYS1kUAQvicCU52gnlqrLW1d9cCx0U9ng2WxFFXIy75oR43p2AM0+dwBipMlnBcS59oITehnYDmipQoJPgU07/on3jU2CYI6pptf9TGKQa6TjnszEulnu9KMuoB3Qpq8/q5/3nvrUutuI4H+PcIWcS6Pac7OWWnEd7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASmP39Qk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASmP39Qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7A2C4CED1;
	Wed,  5 Mar 2025 18:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198111;
	bh=YFcPFqGJJ2mrwbdUZqmK+X6WJFpV6g5RXKlODTX1hCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASmP39QkM34iDatdzc3y8rHZqOS3ngjbd/6dsdlGb4VELoyyb+e9EzEbWh1Z/eH4F
	 tZBwU8kHkl1Pnyce7HYVpYubktdiYwQlRBMHyUV5ccQogFV15Q8SLtHRbv4KBNaIcO
	 GsDlZsTwDdJv+vJXmpI25280vOAnbB68WpBRvZnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/150] perf/core: Order the PMU list to fix warning about unordered pmu_ctx_list
Date: Wed,  5 Mar 2025 18:48:17 +0100
Message-ID: <20250305174506.549043891@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Gengkun <luogengkun@huaweicloud.com>

[ Upstream commit 2016066c66192a99d9e0ebf433789c490a6785a2 ]

Syskaller triggers a warning due to prev_epc->pmu != next_epc->pmu in
perf_event_swap_task_ctx_data(). vmcore shows that two lists have the same
perf_event_pmu_context, but not in the same order.

The problem is that the order of pmu_ctx_list for the parent is impacted by
the time when an event/PMU is added. While the order for a child is
impacted by the event order in the pinned_groups and flexible_groups. So
the order of pmu_ctx_list in the parent and child may be different.

To fix this problem, insert the perf_event_pmu_context to its proper place
after iteration of the pmu_ctx_list.

The follow testcase can trigger above warning:

 # perf record -e cycles --call-graph lbr -- taskset -c 3 ./a.out &
 # perf stat -e cpu-clock,cs -p xxx // xxx is the pid of a.out

 test.c

 void main() {
        int count = 0;
        pid_t pid;

        printf("%d running\n", getpid());
        sleep(30);
        printf("running\n");

        pid = fork();
        if (pid == -1) {
                printf("fork error\n");
                return;
        }
        if (pid == 0) {
                while (1) {
                        count++;
                }
        } else {
                while (1) {
                        count++;
                }
        }
 }

The testcase first opens an LBR event, so it will allocate task_ctx_data,
and then open tracepoint and software events, so the parent context will
have 3 different perf_event_pmu_contexts. On inheritance, child ctx will
insert the perf_event_pmu_context in another order and the warning will
trigger.

[ mingo: Tidied up the changelog. ]

Fixes: bd2756811766 ("perf: Rewrite core context handling")
Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20250122073356.1824736-1-luogengkun@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 501d8c2fedff4..07cd2dbab0e88 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4957,7 +4957,7 @@ static struct perf_event_pmu_context *
 find_get_pmu_context(struct pmu *pmu, struct perf_event_context *ctx,
 		     struct perf_event *event)
 {
-	struct perf_event_pmu_context *new = NULL, *epc;
+	struct perf_event_pmu_context *new = NULL, *pos = NULL, *epc;
 	void *task_ctx_data = NULL;
 
 	if (!ctx->task) {
@@ -5014,12 +5014,19 @@ find_get_pmu_context(struct pmu *pmu, struct perf_event_context *ctx,
 			atomic_inc(&epc->refcount);
 			goto found_epc;
 		}
+		/* Make sure the pmu_ctx_list is sorted by PMU type: */
+		if (!pos && epc->pmu->type > pmu->type)
+			pos = epc;
 	}
 
 	epc = new;
 	new = NULL;
 
-	list_add(&epc->pmu_ctx_entry, &ctx->pmu_ctx_list);
+	if (!pos)
+		list_add_tail(&epc->pmu_ctx_entry, &ctx->pmu_ctx_list);
+	else
+		list_add(&epc->pmu_ctx_entry, pos->pmu_ctx_entry.prev);
+
 	epc->ctx = ctx;
 
 found_epc:
-- 
2.39.5



