Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773940;
	b=pnU+I/7VVwwjI3/s/SYd/6acYbqyeURFd/ixOcMThl4yiRPfqmQdLwIHebUOnRpOXlOH
	 Tsff7o0Dl25NEzz9cil0Iqnsr9y9z2RID1UKy2gg09gkoMe2Vsk1hrvZQWG4yHu7ofUIQ
	 u3OPG936iReQu75FU+9ColnMRx3yaWiZXOPe7Q+phK+MIUK7ZfdYnndlX4042vcqiG0P8
	 Zmby71DlQ/XA0u7fEgnYIrOnb4gdMBQyR9B/XC+zDbYPYRvGY+pgQ2q3397wYjXHjJqLT
	 tGyigDT1dOHzXqKvACeCzRS9VFndjpIZoL5vYrB1wfMERrhupTF4u6oC4Wzq/e1A3zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mHHgwiLzHOHnkHbgiEKea4ckTYeNUXSi/aj0EEpQ1DQ=;
	b=BswCz6/0OmTuPt3AghcKmdxc5LvATKZluC0jgP1CuSthY9RmtRf7WnsrpkwpgXqzpVSm
	 Me+lwG7A8PlA4Z6CGqYcC8yF/xUCHujlNm5PA58hGgyj01xA9neBjUWM/8b6MbiG1JA5A
	 9xZgGJvjnKGu6q5FUtdx2eLW1RGjinViPsjIa2zqCAejwrgFvDWVwi55+I/lu4Bo4c2AF
	 sLrVHB+dAMXprxSxdn58xpGfUGnzytNCQPHOE0WaJ7O4cqYdaqax1LebYovdmCGT0HczH
	 T83kK2k+1FT8roFHf3uyseuot+qDR3e0tlOMdMEjfGnh38ag7u6vBvIQjGfuOAHlSIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgqtBC+Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527BF606A31B;
	Fri, 23 Oct 2026 16:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgqtBC+Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD551F01825;
	Fri, 23 Oct 2026 16:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773939;
	bh=mHHgwiLzHOHnkHbgiEKea4ckTYeNUXSi/aj0EEpQ1DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgqtBC+YYflmwihFBW7AdvpWcDMprBoIGEHAlsjqhMOAdBx0kfX5eE3j/VTWsX6SA
	 s6JooY37l3v2SMyNcUi+1L9vqPF8FUkkgXfeVvHdqkAlGEefspf2SgBD/6VzM9tRL/
	 GKQ4l8IKo5UxKW0lcOSUzPExcpV3N+5GApMQBJ7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haris Okanovic <harisokn@amazon.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/193] perf: Fix perf_pmu_migrate_context() leaving events behind
Date: Fri, 23 Oct 2026 18:35:45 +0200
Message-ID: <20261023163715.811828093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Haris Okanovic <harisokn@amazon.com>

[ Upstream commit e76b36b4be7160eaa14b416681e548b125702395 ]

__perf_pmu_remove() walks the group leaders of a CPU and PMU with
perf_event_groups_for_cpu_pmu(), removing each one as it goes.
perf_remove_from_context() takes the leader out of the groups rbtree,
after which rb_next() on that node returns NULL, prematurely ending the
walk. Other groups stay behind in the source context.

On CPU hotplug, they are then torn down with the dying CPU. They keep
running until teardown, while the PMU's interrupt and migrated events
are on a new CPU, which drivers rely on never happening.

Walk ctx->event_list instead and pick out the PMU's events by their
pmu_ctx.

Fixes: bd2756811766 ("perf: Rewrite core context handling")
Signed-off-by: Haris Okanovic <harisokn@amazon.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20261013185603.1347265-2-harisokn@amazon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 018a1e4ef5b0d..17499b724f852 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -13978,23 +13978,18 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 }
 EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
 
-static void __perf_pmu_remove(struct perf_event_context *ctx,
-			      int cpu, struct pmu *pmu,
-			      struct perf_event_groups *groups,
+static void __perf_pmu_remove(struct perf_event_context *ctx, struct pmu *pmu,
 			      struct list_head *events)
 {
-	struct perf_event *event, *sibling;
+	struct perf_event *event, *tmp;
+
+	list_for_each_entry_safe(event, tmp, &ctx->event_list, event_entry) {
+		if (event->pmu_ctx->pmu != pmu)
+			continue;
 
-	perf_event_groups_for_cpu_pmu(event, groups, cpu, pmu) {
 		perf_remove_from_context(event, 0);
 		put_pmu_ctx(event->pmu_ctx);
 		list_add(&event->migrate_entry, events);
-
-		for_each_sibling_event(sibling, event) {
-			perf_remove_from_context(sibling, 0);
-			put_pmu_ctx(sibling->pmu_ctx);
-			list_add(&sibling->migrate_entry, events);
-		}
 	}
 }
 
@@ -14070,8 +14065,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 	 */
 	mutex_lock_double(&src_ctx->mutex, &dst_ctx->mutex);
 
-	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->pinned_groups, &events);
-	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->flexible_groups, &events);
+	__perf_pmu_remove(src_ctx, pmu, &events);
 
 	if (!list_empty(&events)) {
 		/*
-- 
2.53.0



