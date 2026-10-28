Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207559;
	b=bAqX7lLIjeSiDeJIrLy1gc1Fxgy/RSTQTq4SpbLTM2kPr7DWdD2Oy15qderWh0Y3Ju0z
	 fkJIuhMtSyj4EPhvPD2PMgfo/PEcbhf4anSvOEJ5cagQvLEPWfJ3zANWi2VhvU+WDtCGm
	 PpQWEfKt+LtcyIjrdQf6zb2BFgysz6NHIAgLEHYObFm2vRM6ANbLcRS7Hfalq3SVYOxOy
	 2ZxxVlHnnXl9VHdsNwqfLgf7yM7cfrOWOLdbg5IjYgBHlTsNixSG4Fcm+iGodSefIj7B2
	 laAgfFqKkL4NfZV5JqcfQBAmf3fA8BvSf7aP7Gp2GCoZzHuk2i3zeCe9sRwvA293I+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7fL4T9a12hyGupmRip3sqmxaqxkZQxHd7J4rZqNUkSU=;
	b=CoPDNLWRyfDoAhy9JuVqhPe/Z10h3+wv1um79GGJcmfL7CuX0BZM/ziZb/Hsf3k9cYHc
	 97nL2jY8B9Vwp59Powko9Q8O3kQOnpPLXCRg7KrxMRs0mBNPbKJolh/xUfDmgkbUGFd75
	 oDp6DnpjCBVpEaF7Rz2YeVD9mtfXJd3hZOpkPzxp6vA1ivGSjiMSVpWCc8zTVZCWUMRyj
	 cPdB19bzgxfDlqNnpvB+GFB/7DO/MkNJbpCFPFUz4yq++8B7sGBDc+CEJIC3xyfnFZ9zl
	 BFv8TsXWd898zM9DAh9R+fyi1Xedcf6aylpGvunx6U4NVGNOg9PG9WM+tXjqAhPPDCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmUQPwLg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB78606A320;
	Wed, 28 Oct 2026 17:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmUQPwLg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFD11F01825;
	Wed, 28 Oct 2026 17:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207559;
	bh=7fL4T9a12hyGupmRip3sqmxaqxkZQxHd7J4rZqNUkSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmUQPwLgYcvVSrd4C1ZujV211RHTFaC0QauHrgl+GUL8sYoXfvErKA5dlIRxXA4j9
	 ojMSqSHrnfU+O8Wrg6arZeF0sci1X1seqtpVf3P6OYGqSypBpicYlcRzJsuh9LlbY2
	 PcFnFTWIe5Zg0Di0GQD80ikEcvwF85aO0HX1V6tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haris Okanovic <harisokn@amazon.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/247] perf: Fix perf_pmu_migrate_context() leaving events behind
Date: Wed, 28 Oct 2026 17:57:42 +0100
Message-ID: <20261028165948.780008203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6c9c3bfc0da27..a076236b3a49b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -13326,23 +13326,18 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
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
 
@@ -13418,8 +13413,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 	 */
 	mutex_lock_double(&src_ctx->mutex, &dst_ctx->mutex);
 
-	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->pinned_groups, &events);
-	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->flexible_groups, &events);
+	__perf_pmu_remove(src_ctx, pmu, &events);
 
 	if (!list_empty(&events)) {
 		/*
-- 
2.53.0



