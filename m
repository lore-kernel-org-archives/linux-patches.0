Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984A8332913;
	Tue, 21 Jul 2026 18:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660370; cv=none; b=paVqpOzlCZ0Ad+rsgxzANsFGBrnyyx4XsGLKC8lZn9YOwwymVww3vl/i+vHon5OJLCOEtOd1fv5MQ0NkpegLatrNsuTkX4Su48ROF8NRR4sqjb+T71XA9Y+3HuL9Kv36AbYOpNamWq6XDMkdHzrP2N3NJmH83GI8AkhrLMVkZWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660370; c=relaxed/simple;
	bh=1eclTQ/7lusGPj276yEebI6URG2vgsvYsO14oLy5+vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMOv5VFzaLMCkLy2jE8pyaC/tYog8L1MJ23yxSjRUEFu8i2KqtTfes8hiQl3/2JYRqhtMzTI3kFn84MvO2s+0+ELFWEouuOTzHjLfh/Y6NpLutY75KaQfW5CL0EbTHZpM0F3k2yO9v7hYBsHFWarYIYmuE4qk/LfCcScHIpz5Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbdTn+H7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbdTn+H7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFB11F000E9;
	Tue, 21 Jul 2026 18:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660369;
	bh=ojwMDP2jduuqAzOQ3Xdw+pF0sT3+uDuATM5PjukpDCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jbdTn+H7Gh6pGDN4ZkjTaW/L+pOcrJyTRZ/BtcKNV+npb9nlBeaT+cVtGiQ+q8Ez4
	 pJviDWpuGUuYgaDFsHIH93N9yu1HR8BEYHX1u22xz2m4lzvd16K3t9KcqwTbi5AX/l
	 jLNAX7fIuoTbWgkvOsbXlM4nzT3/YXUaJbAeM2fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0953/2077] perf sched: Free callchain nodes in idle thread cleanup
Date: Tue, 21 Jul 2026 17:10:26 +0200
Message-ID: <20260721152615.297157104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit c3e51ed45ffa7547495a851e33ce332f81ef3665 ]

free_idle_threads() relies on the thread priv destructor (free()) to
clean up idle_thread_runtime structs.  But free() doesn't walk the
callchain_cursor linked list or the callchain_root tree allocated
by callchain_cursor__copy() and callchain_append() during --idle-hist
processing.  Every idle thread with callchain data leaks these nodes.

Introduce callchain_cursor_cleanup() to free the cursor's linked list
of callchain_cursor_node entries, and call it together with
free_callchain() in free_idle_threads() before thread__put().

Fixes: 225b24f569980ac9 ("perf sched timehist: Save callchain when entering idle")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c  |  5 ++++-
 tools/perf/util/callchain.c | 15 +++++++++++++++
 tools/perf/util/callchain.h |  1 +
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 70157fcd20f2cc..defbf8dc26073c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2500,8 +2500,11 @@ static void free_idle_threads(void)
 			struct idle_thread_runtime *itr;
 
 			itr = thread__priv(idle);
-			if (itr)
+			if (itr) {
 				thread__put(itr->last_thread);
+				free_callchain(&itr->callchain);
+				callchain_cursor_cleanup(&itr->cursor);
+			}
 
 			thread__put(idle);
 		}
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index f031cbbeeba8b7..5e0498a1faf8a7 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -1578,6 +1578,21 @@ void free_callchain(struct callchain_root *root)
 	free_callchain_node(&root->node);
 }
 
+void callchain_cursor_cleanup(struct callchain_cursor *cursor)
+{
+	struct callchain_cursor_node *node, *next;
+
+	callchain_cursor_reset(cursor);
+
+	for (node = cursor->first; node; node = next) {
+		next = node->next;
+		free(node);
+	}
+	cursor->first = NULL;
+	cursor->last = &cursor->first;
+	cursor->curr = NULL;
+}
+
 static u64 decay_callchain_node(struct callchain_node *node)
 {
 	struct callchain_node *child;
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 06d463ccc7a04f..60008f379b2289 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -290,6 +290,7 @@ int callchain_list_counts__printf_value(struct callchain_list *clist,
 					FILE *fp, char *bf, int bfsize);
 
 void free_callchain(struct callchain_root *root);
+void callchain_cursor_cleanup(struct callchain_cursor *cursor);
 void decay_callchain(struct callchain_root *root);
 int callchain_node__make_parent_list(struct callchain_node *node);
 
-- 
2.53.0



