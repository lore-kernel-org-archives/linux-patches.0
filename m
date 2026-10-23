Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774707;
	b=xDA+xIdQCRT2dkylR8bL1jPQ+m8Rb4r95a4SMNm8eRVc76NewZoaWSW22hhMrdJKU0Po
	 FRmQJwfZ41eZ+VrB650OwNw2CCMxn3gEbvFiH7IKu/bJP2RCLk5CsrCpi4o9ssF8nydro
	 cLEB6N2mgGf5YPEK2lghSKNoYUAUbM1JaYk65pS2KFDMLaRTAQIqHzZvDSDUO8SOOvEiF
	 d82BhkO5K1TMVaL35d1TBS1dEgdNPwjrVDjymuMqzDjycSzz0iMRQPjFGU3EVWMPDZqkl
	 KpnZHIXYHcY23xQxhu/dwHFeXQyNrk8BRbIyZA8EGfatfBh4mdO4EA04VFyoU317EyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wR93KJ6nQm4C3fLCVEnallhiQTD9CdeO+bmlMNl5AfI=;
	b=vp7PvDgoUntqZFZkuC+CHtVQnzMdaPgtApjQ7iNWemCWFftbOtvvTjUw/gYmJa/F0oZY
	 zVuIteQeWiiWKpW4tLWW18a2ogP/cNO5gzAjuy8bWxQTUum5z/tB8dRhakejcHl1gf+gr
	 BjSj7Xk4iLuSgrGb1JZqHj/vFK0W5L2pMGUGDUZxtqHgZk5HqntCdcFzYw/DxVyBY2R8E
	 8jqBoaNsBVSqMeIJ2eBgjjykt7x54Pu/1y7zSXv2ybspn4k0OogIf/ESIcq5V2yBsSxq8
	 Q8EMy1uS1oX+Xspz7egzUNP3qzwCQSP1MVHDGzVlr0PT4E4RdwGZ9sYdvT5o0+Pw34g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xh0eOMAr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC538606A31A;
	Fri, 23 Oct 2026 16:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xh0eOMAr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3715C1F01825;
	Fri, 23 Oct 2026 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774706;
	bh=wR93KJ6nQm4C3fLCVEnallhiQTD9CdeO+bmlMNl5AfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xh0eOMArWV2gW5dCIqL7c6LP3xI0a64JovtAprgjGjVXPt+5nsuMiVBNaV0SuumRK
	 Hv2zbX5Alee2w07nFe7k2eZWQE+5U7K2OJ8Wfy06BiJPjaefWnssdWS+YT3aqbioxJ
	 hN7m59WNS18DG3MJ3pnzJZkcqwcJr44VXwdPUfzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haris Okanovic <harisokn@amazon.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 093/242] perf: Fix perf_pmu_migrate_context() leaving events behind
Date: Fri, 23 Oct 2026 18:38:55 +0200
Message-ID: <20261023163715.978093027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 4959b287f589d..36c78b7b06a94 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -14370,23 +14370,18 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
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
 
@@ -14462,8 +14457,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 	 */
 	mutex_lock_double(&src_ctx->mutex, &dst_ctx->mutex);
 
-	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->pinned_groups, &events);
-	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->flexible_groups, &events);
+	__perf_pmu_remove(src_ctx, pmu, &events);
 
 	if (!list_empty(&events)) {
 		/*
-- 
2.53.0



