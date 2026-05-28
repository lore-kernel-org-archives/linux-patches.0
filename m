Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7C9313550;
	Thu, 28 May 2026 20:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000373; cv=none; b=giNyBCoq7UsrL66Uu/R6UMKIaamf9lZrC9FQ6fwpU1dThBLNg7guDV+yhzGlumvP+miSPFe+/KisFbPF412ejwXp33cfWOqxAIB0cRV4rGCMhFv6ampvKgcb5nGg92lnl94IiY3bGEOFGoj/7vQQIqbCNwoRAwgrF2T1apIeCcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000373; c=relaxed/simple;
	bh=hDrnCAymPT8Cm8IHv4OZREWdjTkxwJFnqnawzaqvdNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8e4wVfx0vXpXHEkZUnsITTkOlLG+tPrZKfJ9znC4X/kX9mYGqhGC4wS0sHG1ZZurY/xZ2o7ytLE9pH8YkwWkHtG0kALpZPf0qYgrMOeQxFXBq6QA9ZW6DYAm/dz0MWV7AiS2mZrjsZO7w5hJqNwoYaOQF75+AHRvEvoXzWn5R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8DqZkpe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8DqZkpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DD61F000E9;
	Thu, 28 May 2026 20:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000371;
	bh=TNlBM0L7KM1NdqiC0/OWAgbbhfw05xX0ApT32Vd63+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8DqZkpepOIyGpxb4lvTDz/MObKvt6VnhcReHfYpsfhDaW+qr/3jGZmkReShdP2XI
	 FyuhqmEEruaTbRHQIrXbxN+wwy3b1B+Gu0l0/byt0inKkyZJ/hnkmVF1QbkMx3l+hG
	 l9AUgQW9C1PCpYghRomU1xpAomJSPhsxrjzHhDUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Ushakov <sysroot314@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Leon Chen <leonchen.oss@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/272] af_unix: Give up GC if MSG_PEEK intervened.
Date: Thu, 28 May 2026 21:46:36 +0200
Message-ID: <20260528194630.006513711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit e5b31d988a41549037b8d8721a3c3cae893d8670 ]

Igor Ushakov reported that GC purged the receive queue of
an alive socket due to a race with MSG_PEEK with a nice repro.

This is the exact same issue previously fixed by commit
cbcf01128d0a ("af_unix: fix garbage collect vs MSG_PEEK").

After GC was replaced with the current algorithm, the cited
commit removed the locking dance in unix_peek_fds() and
reintroduced the same issue.

The problem is that MSG_PEEK bumps a file refcount without
interacting with GC.

Consider an SCC containing sk-A and sk-B, where sk-A is
close()d but can be recv()ed via sk-B.

The bad thing happens if sk-A is recv()ed with MSG_PEEK from
sk-B and sk-B is close()d while GC is checking unix_vertex_dead()
for sk-A and sk-B.

  GC thread                    User thread
  ---------                    -----------
  unix_vertex_dead(sk-A)
  -> true   <------.
                    \
                     `------   recv(sk-B, MSG_PEEK)
              invalidate !!    -> sk-A's file refcount : 1 -> 2

                               close(sk-B)
                               -> sk-B's file refcount : 2 -> 1
  unix_vertex_dead(sk-B)
  -> true

Initially, sk-A's file refcount is 1 by the inflight fd in sk-B
recvq.  GC thinks sk-A is dead because the file refcount is the
same as the number of its inflight fds.

However, sk-A's file refcount is bumped silently by MSG_PEEK,
which invalidates the previous evaluation.

At this moment, sk-B's file refcount is 2; one by the open fd,
and one by the inflight fd in sk-A.  The subsequent close()
releases one refcount by the former.

Finally, GC incorrectly concludes that both sk-A and sk-B are dead.

One option is to restore the locking dance in unix_peek_fds(),
but we can resolve this more elegantly thanks to the new algorithm.

The point is that the issue does not occur without the subsequent
close() and we actually do not need to synchronise MSG_PEEK with
the dead SCC detection.

When the issue occurs, close() and GC touch the same file refcount.
If GC sees the refcount being decremented by close(), it can just
give up garbage-collecting the SCC.

Therefore, we only need to signal the race during MSG_PEEK with
a proper memory barrier to make it visible to the GC.

Let's use seqcount_t to notify GC when MSG_PEEK occurs and let
it defer the SCC to the next run.

This way no locking is needed on the MSG_PEEK side, and we can
avoid imposing a penalty on every MSG_PEEK unnecessarily.

Note that we can retry within unix_scc_dead() if MSG_PEEK is
detected, but we do not do so to avoid hung task splat from
abusive MSG_PEEK calls.

Fixes: 118f457da9ed ("af_unix: Remove lock dance in unix_peek_fds().")
Reported-by: Igor Ushakov <sysroot314@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260311054043.1231316-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Using include/net/af_unix.h instead of net/unix/af_unix.h on 6.12.y ]
Signed-off-by: Leon Chen <leonchen.oss@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/af_unix.h |  1 +
 net/unix/af_unix.c    |  2 ++
 net/unix/garbage.c    | 79 ++++++++++++++++++++++++++++---------------
 3 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 63129c79b8cbc..8cacc5290d8bb 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -23,6 +23,7 @@ void unix_del_edges(struct scm_fp_list *fpl);
 void unix_update_edges(struct unix_sock *receiver);
 int unix_prepare_fpl(struct scm_fp_list *fpl);
 void unix_destroy_fpl(struct scm_fp_list *fpl);
+void unix_peek_fpl(struct scm_fp_list *fpl);
 void unix_gc(void);
 void wait_for_unix_gc(struct scm_fp_list *fpl);
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 77976f36c4aa4..9c5a812bd6813 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1878,6 +1878,8 @@ static void unix_detach_fds(struct scm_cookie *scm, struct sk_buff *skb)
 static void unix_peek_fds(struct scm_cookie *scm, struct sk_buff *skb)
 {
 	scm->fp = scm_fp_dup(UNIXCB(skb).fp);
+
+	unix_peek_fpl(scm->fp);
 }
 
 static void unix_destruct_scm(struct sk_buff *skb)
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 66fd606c43f45..1cdb54c61619f 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -306,6 +306,25 @@ void unix_destroy_fpl(struct scm_fp_list *fpl)
 	unix_free_vertices(fpl);
 }
 
+static bool gc_in_progress;
+static seqcount_t unix_peek_seq = SEQCNT_ZERO(unix_peek_seq);
+
+void unix_peek_fpl(struct scm_fp_list *fpl)
+{
+	static DEFINE_SPINLOCK(unix_peek_lock);
+
+	if (!fpl || !fpl->count_unix)
+		return;
+
+	if (!READ_ONCE(gc_in_progress))
+		return;
+
+	/* Invalidate the final refcnt check in unix_vertex_dead(). */
+	spin_lock(&unix_peek_lock);
+	raw_write_seqcount_barrier(&unix_peek_seq);
+	spin_unlock(&unix_peek_lock);
+}
+
 static bool unix_vertex_dead(struct unix_vertex *vertex)
 {
 	struct unix_edge *edge;
@@ -339,6 +358,36 @@ static bool unix_vertex_dead(struct unix_vertex *vertex)
 	return true;
 }
 
+static LIST_HEAD(unix_visited_vertices);
+static unsigned long unix_vertex_grouped_index = UNIX_VERTEX_INDEX_MARK2;
+
+static bool unix_scc_dead(struct list_head *scc, bool fast)
+{
+	struct unix_vertex *vertex;
+	bool scc_dead = true;
+	unsigned int seq;
+
+	seq = read_seqcount_begin(&unix_peek_seq);
+
+	list_for_each_entry_reverse(vertex, scc, scc_entry) {
+		/* Don't restart DFS from this vertex. */
+		list_move_tail(&vertex->entry, &unix_visited_vertices);
+
+		/* Mark vertex as off-stack for __unix_walk_scc(). */
+		if (!fast)
+			vertex->index = unix_vertex_grouped_index;
+
+		if (scc_dead)
+			scc_dead = unix_vertex_dead(vertex);
+	}
+
+	/* If MSG_PEEK intervened, defer this SCC to the next round. */
+	if (read_seqcount_retry(&unix_peek_seq, seq))
+		return false;
+
+	return scc_dead;
+}
+
 static void unix_collect_skb(struct list_head *scc, struct sk_buff_head *hitlist)
 {
 	struct unix_vertex *vertex;
@@ -392,9 +441,6 @@ static bool unix_scc_cyclic(struct list_head *scc)
 	return false;
 }
 
-static LIST_HEAD(unix_visited_vertices);
-static unsigned long unix_vertex_grouped_index = UNIX_VERTEX_INDEX_MARK2;
-
 static void __unix_walk_scc(struct unix_vertex *vertex, unsigned long *last_index,
 			    struct sk_buff_head *hitlist)
 {
@@ -460,9 +506,7 @@ static void __unix_walk_scc(struct unix_vertex *vertex, unsigned long *last_inde
 	}
 
 	if (vertex->index == vertex->scc_index) {
-		struct unix_vertex *v;
 		struct list_head scc;
-		bool scc_dead = true;
 
 		/* SCC finalised.
 		 *
@@ -471,18 +515,7 @@ static void __unix_walk_scc(struct unix_vertex *vertex, unsigned long *last_inde
 		 */
 		__list_cut_position(&scc, &vertex_stack, &vertex->scc_entry);
 
-		list_for_each_entry_reverse(v, &scc, scc_entry) {
-			/* Don't restart DFS from this vertex in unix_walk_scc(). */
-			list_move_tail(&v->entry, &unix_visited_vertices);
-
-			/* Mark vertex as off-stack. */
-			v->index = unix_vertex_grouped_index;
-
-			if (scc_dead)
-				scc_dead = unix_vertex_dead(v);
-		}
-
-		if (scc_dead) {
+		if (unix_scc_dead(&scc, false)) {
 			unix_collect_skb(&scc, hitlist);
 		} else {
 			if (unix_vertex_max_scc_index < vertex->scc_index)
@@ -530,19 +563,11 @@ static void unix_walk_scc_fast(struct sk_buff_head *hitlist)
 	while (!list_empty(&unix_unvisited_vertices)) {
 		struct unix_vertex *vertex;
 		struct list_head scc;
-		bool scc_dead = true;
 
 		vertex = list_first_entry(&unix_unvisited_vertices, typeof(*vertex), entry);
 		list_add(&scc, &vertex->scc_entry);
 
-		list_for_each_entry_reverse(vertex, &scc, scc_entry) {
-			list_move_tail(&vertex->entry, &unix_visited_vertices);
-
-			if (scc_dead)
-				scc_dead = unix_vertex_dead(vertex);
-		}
-
-		if (scc_dead)
+		if (unix_scc_dead(&scc, true))
 			unix_collect_skb(&scc, hitlist);
 		else if (!unix_graph_maybe_cyclic)
 			unix_graph_maybe_cyclic = unix_scc_cyclic(&scc);
@@ -553,8 +578,6 @@ static void unix_walk_scc_fast(struct sk_buff_head *hitlist)
 	list_replace_init(&unix_visited_vertices, &unix_unvisited_vertices);
 }
 
-static bool gc_in_progress;
-
 static void __unix_gc(struct work_struct *work)
 {
 	struct sk_buff_head hitlist;
-- 
2.53.0



