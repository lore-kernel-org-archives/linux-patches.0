Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4131DEFF8;
	Tue,  8 Oct 2024 13:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393689; cv=none; b=R3gH/JsRXvG67FhRckuRpeOeMBzR+KuOXfHqbVnJTtN0OcHw2FXtZk25cm3w42fyXKpPdfngZrJ/zJdQT199RurQjkSH9WDqBNg/X0uixsFBxut4Q3HhqhYes3ObCh19wi4E6CRmdYGQOSzLXmZzcEDEfip3+RcMo/7LGpDSK2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393689; c=relaxed/simple;
	bh=LU2z5CrGw+8u0DlBt0rQfzeN6wL+izQmF6vd7XuxDHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCAzP805w7AIA+vS0rczHY249Wjh+RPK2+HS6JrJJ2/kmPuRXi5CHSwM3YnMjlumZLoTtpva+yJk5OwTnKquMHsqpq+jgc45pNzDV+FvWjhivWAgiYq5PQcMjeBiYF0HVgK1+8Dx+4RfC+/FYRi6frORQEowAdZIjt0a/F+PNP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTCfYHC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTCfYHC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE605C4CEC7;
	Tue,  8 Oct 2024 13:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393689;
	bh=LU2z5CrGw+8u0DlBt0rQfzeN6wL+izQmF6vd7XuxDHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTCfYHC5z8VOob24i81plG6O/Bm6+wACqB12cf5984ZI5ilShA1aQtuzaRbYb15ZO
	 AkWljpuKMlmA/KmD3uoZKAkUR82Jsz3rOTqGlPHNj1OKUTNfvbjOqQI9oooZ7YZzCU
	 1dz9bK3n3fXxC63ERJ3z1tXS0srpWqy90tYRCzFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Anne Macedo <retpolanne@posteo.net>,
	Changbin Du <changbin.du@huawei.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/386] perf callchain: Fix stitch LBR memory leaks
Date: Tue,  8 Oct 2024 14:07:20 +0200
Message-ID: <20241008115637.080343835@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 599c19397b17d197fc1184bbc950f163a292efc9 ]

The 'struct callchain_cursor_node' has a 'struct map_symbol' whose maps
and map members are reference counted. Ensure these values use a _get
routine to increment the reference counts and use map_symbol__exit() to
release the reference counts.

Do similar for 'struct thread's prev_lbr_cursor, but save the size of
the prev_lbr_cursor array so that it may be iterated.

Ensure that when stitch_nodes are placed on the free list the
map_symbols are exited.

Fix resolve_lbr_callchain_sample() by replacing list_replace_init() to
list_splice_init(), so the whole list is moved and nodes aren't leaked.

A reproduction of the memory leaks is possible with a leak sanitizer
build in the perf report command of:

  ```
  $ perf record -e cycles --call-graph lbr perf test -w thloop
  $ perf report --stitch-lbr
  ```

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Fixes: ff165628d72644e3 ("perf callchain: Stitch LBR call stack")
Signed-off-by: Ian Rogers <irogers@google.com>
[ Basic tests after applying the patch, repeating the example above ]
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anne Macedo <retpolanne@posteo.net>
Cc: Changbin Du <changbin.du@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240808054644.1286065-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 17 +++++++++++++++--
 tools/perf/util/thread.c  |  4 ++++
 tools/perf/util/thread.h  |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 7c6874804660e..24dead4e30656 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2536,8 +2536,12 @@ static void save_lbr_cursor_node(struct thread *thread,
 		cursor->curr = cursor->first;
 	else
 		cursor->curr = cursor->curr->next;
+
+	map_symbol__exit(&lbr_stitch->prev_lbr_cursor[idx].ms);
 	memcpy(&lbr_stitch->prev_lbr_cursor[idx], cursor->curr,
 	       sizeof(struct callchain_cursor_node));
+	lbr_stitch->prev_lbr_cursor[idx].ms.maps = maps__get(cursor->curr->ms.maps);
+	lbr_stitch->prev_lbr_cursor[idx].ms.map = map__get(cursor->curr->ms.map);
 
 	lbr_stitch->prev_lbr_cursor[idx].valid = true;
 	cursor->pos++;
@@ -2748,6 +2752,9 @@ static bool has_stitched_lbr(struct thread *thread,
 		memcpy(&stitch_node->cursor, &lbr_stitch->prev_lbr_cursor[i],
 		       sizeof(struct callchain_cursor_node));
 
+		stitch_node->cursor.ms.maps = maps__get(lbr_stitch->prev_lbr_cursor[i].ms.maps);
+		stitch_node->cursor.ms.map = map__get(lbr_stitch->prev_lbr_cursor[i].ms.map);
+
 		if (callee)
 			list_add(&stitch_node->node, &lbr_stitch->lists);
 		else
@@ -2771,6 +2778,8 @@ static bool alloc_lbr_stitch(struct thread *thread, unsigned int max_lbr)
 	if (!thread__lbr_stitch(thread)->prev_lbr_cursor)
 		goto free_lbr_stitch;
 
+	thread__lbr_stitch(thread)->prev_lbr_cursor_size = max_lbr + 1;
+
 	INIT_LIST_HEAD(&thread__lbr_stitch(thread)->lists);
 	INIT_LIST_HEAD(&thread__lbr_stitch(thread)->free_lists);
 
@@ -2826,8 +2835,12 @@ static int resolve_lbr_callchain_sample(struct thread *thread,
 						max_lbr, callee);
 
 		if (!stitched_lbr && !list_empty(&lbr_stitch->lists)) {
-			list_replace_init(&lbr_stitch->lists,
-					  &lbr_stitch->free_lists);
+			struct stitch_list *stitch_node;
+
+			list_for_each_entry(stitch_node, &lbr_stitch->lists, node)
+				map_symbol__exit(&stitch_node->cursor.ms);
+
+			list_splice_init(&lbr_stitch->lists, &lbr_stitch->free_lists);
 		}
 		memcpy(&lbr_stitch->prev_sample, sample, sizeof(*sample));
 	}
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 61e9f449c7258..6817b99e550ba 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -478,6 +478,7 @@ void thread__free_stitch_list(struct thread *thread)
 		return;
 
 	list_for_each_entry_safe(pos, tmp, &lbr_stitch->lists, node) {
+		map_symbol__exit(&pos->cursor.ms);
 		list_del_init(&pos->node);
 		free(pos);
 	}
@@ -487,6 +488,9 @@ void thread__free_stitch_list(struct thread *thread)
 		free(pos);
 	}
 
+	for (unsigned int i = 0 ; i < lbr_stitch->prev_lbr_cursor_size; i++)
+		map_symbol__exit(&lbr_stitch->prev_lbr_cursor[i].ms);
+
 	zfree(&lbr_stitch->prev_lbr_cursor);
 	free(thread__lbr_stitch(thread));
 	thread__set_lbr_stitch(thread, NULL);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 0df775b5c1105..a5423f834dc9d 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -28,6 +28,7 @@ struct lbr_stitch {
 	struct list_head		free_lists;
 	struct perf_sample		prev_sample;
 	struct callchain_cursor_node	*prev_lbr_cursor;
+	unsigned int prev_lbr_cursor_size;
 };
 
 struct thread_rb_node {
-- 
2.43.0



