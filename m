Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A282DFF1E;
	Tue, 17 Jun 2025 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176918; cv=none; b=o34e3AAhveidPCoVzofnfa3luVfC+ZLNcwlA3VnCpWAI4cRe3y5PRRlqPdt6bkKhDRmCGuvDpdpuRIy2AsURV8A2y5QY0OHwtvT4ij2HH190etl+TCOhYykpA+V4BUi/rhsCMH/2cRIFId1GEl16uW/JxY3f7PLTbYk7pGRBjk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176918; c=relaxed/simple;
	bh=vg96rpcWWN1P9P4ZCOvjrIgVb3koJTn4ObMl60DVrQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baBy/tF28eezZ1SHTvYStk88o0JVs1xh9OgBww6joV3o9OkqGXnNNwphARkS/C/aW5OKCAVA2CggJucptvKKzEHaha2D6Y77FSaal5T9soW9PvWhaFFBBu0F61J4gFM+Z3EGDO7rgdi7CtxDb+GiP1xqdyx4K6QeSd11dFkdBg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QO5qGH6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QO5qGH6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C54C4CEE3;
	Tue, 17 Jun 2025 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176918;
	bh=vg96rpcWWN1P9P4ZCOvjrIgVb3koJTn4ObMl60DVrQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QO5qGH6iCeK2w/Xdzocy+1pDAk04el5CpuHZhT0RSqjEJFxCojwDx5e2Jsf9c2T1A
	 0zOTiusEfxIcftKT5NuynzXsxMQYEylr0OsJjSzoAhuKey9mGZILibJykPzweIAt/2
	 +Pw89UfWw6nsEorGG2bP0Zc/ySRjGplRHTfvWP9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 330/356] net_sched: ets: fix a race in ets_qdisc_change()
Date: Tue, 17 Jun 2025 17:27:25 +0200
Message-ID: <20250617152351.429777101@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d92adacdd8c2960be856e0b82acc5b7c5395fddb ]

Gerrard Tai reported a race condition in ETS, whenever SFQ perturb timer
fires at the wrong time.

The race is as follows:

CPU 0                                 CPU 1
[1]: lock root
[2]: qdisc_tree_flush_backlog()
[3]: unlock root
 |
 |                                    [5]: lock root
 |                                    [6]: rehash
 |                                    [7]: qdisc_tree_reduce_backlog()
 |
[4]: qdisc_put()

This can be abused to underflow a parent's qlen.

Calling qdisc_purge_queue() instead of qdisc_tree_flush_backlog()
should fix the race, because all packets will be purged from the qdisc
before releasing the lock.

Fixes: b05972f01e7d ("net: sched: tbf: don't call qdisc_put() while holding tree lock")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Suggested-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250611111515.1983366-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_ets.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 9da86db4d2c2f..3ee46f6e005da 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -661,7 +661,7 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 	for (i = q->nbands; i < oldbands; i++) {
 		if (i >= q->nstrict && q->classes[i].qdisc->q.qlen)
 			list_del_init(&q->classes[i].alist);
-		qdisc_tree_flush_backlog(q->classes[i].qdisc);
+		qdisc_purge_queue(q->classes[i].qdisc);
 	}
 	q->nstrict = nstrict;
 	memcpy(q->prio2band, priomap, sizeof(priomap));
-- 
2.39.5



ded" Error message: "Failed to find required string:'Out-Out;'."
---- end(-1) ----
132: perf script task-analyzer tests                                 : FAILED!
```

The buf_size if always set to phdr->p_filesz, but that may be 0
causing a free and realloc to return NULL. This is treated in
filename__read_build_id like a failure and the buffer is freed again.

To avoid this problem only grow buf, meaning the buf_size will never
be 0. This also reduces the number of memory (re)allocations.

Fixes: b691f64360ecec49 ("perf symbols: Implement poor man's ELF parser")
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250501070003.22251-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-minimal.c | 34 +++++++++++++++++---------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index c6f369b5d893f..d8da3da01fe6b 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -147,18 +147,19 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 			if (phdr->p_type != PT_NOTE)
 				continue;
 
-			buf_size = phdr->p_filesz;
 			offset = phdr->p_offset;
-			tmp = realloc(buf, buf_size);
-			if (tmp == NULL)
-				goto out_free;
-
-			buf = tmp;
+			if (phdr->p_filesz > buf_size) {
+				buf_size = phdr->p_filesz;
+				tmp = realloc(buf, buf_size);
+				if (tmp == NULL)
+					goto out_free;
+				buf = tmp;
+			}
 			fseek(fp, offset, SEEK_SET);
-			if (fread(buf, buf_size, 1, fp) != 1)
+			if (fread(buf, phdr->p_filesz, 1, fp) != 1)
 				goto out_free;
 
-			ret = read_build_id(buf, buf_size, bid, need_swap);
+			ret = read_build_id(buf, phdr->p_filesz, bid, need_swap);
 			if (ret == 0) {
 				ret = bid->size;
 				break;
@@ -199,18 +200,19 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 			if (phdr->p_type != PT_NOTE)
 				continue;
 
-			buf_size = phdr->p_filesz;
 			offset = phdr->p_offset;
-			tmp = realloc(buf, buf_size);
-			if (tmp == NULL)
-				goto out_free;
-
-			buf = tmp;
+			if (phdr->p_filesz > buf_size) {
+				buf_size = phdr->p_filesz;
+				tmp = realloc(buf, buf_size);
+				if (tmp == NULL)
+					goto out_free;
+				buf = tmp;
+			}
 			fseek(fp, offset, SEEK_SET);
-			if (fread(buf, buf_size, 1, fp) != 1)
+			if (fread(buf, phdr->p_filesz, 1, fp) != 1)
 				goto out_free;
 
-			ret = read_build_id(buf, buf_size, bid, need_swap);
+			ret = read_build_id(buf, phdr->p_filesz, bid, need_swap);
 			if (ret == 0) {
 				ret = bid->size;
 				break;
-- 
2.39.5



