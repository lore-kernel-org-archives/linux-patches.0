Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210002;
	b=EeqjbmqV5Jo3xn4lZIwSuJ/2JMvf5wtkL76RG+Hgr/2G7MtinpQeVCWM97GX+t4qM3Oi
	 K0G+gTvY+JNTa/n3bMHewqbxLkQBTliGGPk5wsoQ5TCjJrTaht5rRqbaA9sLV+G3DNzte
	 hhMFb1aSM4fRDn+mqCT5enVZrn5n9HGuMZehFNNGLXdAnkZChfF/cBQUh9dyfNo1KCuna
	 ClH7Uu17jTh55uC7WYj92x8kj2bAIHTwMe85SQrY5N803iNJ+N04y+MLWHe/S/SxMlT4H
	 FXht9ta6GTkv1f8R5z2DS54kJwGrFJ/gQaw+GfAvCLraDG5qtNhBv13nXY69O4BLkEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k9Uktwkcb4dDrqo3CqUhZ5hpGEU7JqSJb5symXMdx6A=;
	b=kFHHAy/l148kXmB/RpQaAQegG7Rdfo44CrYJ7SFE7RFi59R5RDB4zYp++ouGc/0kWEI+
	 OLkWG1zPfgBrj7URI/bJs4dZMoHakVXPgL/D+CY2E+21Nj4ZTbjTe0lotI2jzJA3Nb4lu
	 IY/Og+5wwt4dJN0tVkpi/g7PIphQQtAUgZgZihPnsmaYmGygsyltDcWlgN2KLC/NGkKqh
	 qf0A7ukbsDVZb1OYVUG/ugdSBzy1FehBqjw9XiLcxauRj0H3IA7CRk9NASXZ/fGsJiw89
	 OIBJYatqiuqkmPsFNJ0KxWj1BJpXcljPNTQnYhF9XOnMDH99KKst8qssBA2YRF8y3UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3ftLiEx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA98606A31D;
	Wed, 28 Oct 2026 17:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3ftLiEx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD81E1F01825;
	Wed, 28 Oct 2026 17:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210002;
	bh=k9Uktwkcb4dDrqo3CqUhZ5hpGEU7JqSJb5symXMdx6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3ftLiExXYXmzYK7xf8vVpYhoaQy6lqDjDPXQb+3RLDCK3EVB13DPY6eWnXo7xisM
	 bzNF2qhQFBirWSZy7S8T072KmGSJ/R813K4Tlc1UnYnioiYUFNOP4/l4xpB/93YaEU
	 ijNmNqDINEy63g84iSMSTuayQlZp0737jZ0xQ018=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haris Okanovic <harisokn@amazon.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/168] perf: Fix perf_pmu_migrate_context() leaving events behind
Date: Wed, 28 Oct 2026 17:59:36 +0100
Message-ID: <20261028165944.040799664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a226f908490f0..c891243ddef9b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -13099,23 +13099,18 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
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
 
@@ -13191,8 +13186,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 	 */
 	mutex_lock_double(&src_ctx->mutex, &dst_ctx->mutex);
 
-	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->pinned_groups, &events);
-	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->flexible_groups, &events);
+	__perf_pmu_remove(src_ctx, pmu, &events);
 
 	if (!list_empty(&events)) {
 		/*
-- 
2.53.0



