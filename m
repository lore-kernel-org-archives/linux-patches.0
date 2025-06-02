Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D27A22FAE1;
	Mon,  2 Jun 2025 15:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877499; cv=none; b=ISlRcnHJsh6OGcv19VwDiIAIP8rRfvzABAv1GXBnSw0X0GcaE/QcDioIC7/6DUqoMZLNWSB70Tp56sqTnji4h/Iio8Y900hKWIEgafM7adRA+HBRZnBphm67Qh/WStOsPyw661gdrC9YSRfKXDgYE/ue0bFzI8H+sVVn6nMPmSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877499; c=relaxed/simple;
	bh=OpmdVt2bOQ4zqM08YThd2sY25MGfSDGjh41oPThm4oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLshCHIF7nnw+hUaHoVLX2N/WACkD+BV84SUvfD4teNhCxyonuzEV14TKPwNrYU6WCmYlWzDYH7laYyIm6rXJC38YhY2T8lGf+6ldES4cozOkmESC5wDQGtLNBJYKuHuopV0f2PujApYf9R27nl16hxC0+NX9ptVjK+cOAhVnwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+15uNU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+15uNU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66511C4CEEB;
	Mon,  2 Jun 2025 15:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877499;
	bh=OpmdVt2bOQ4zqM08YThd2sY25MGfSDGjh41oPThm4oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+15uNU1Q7CBoyJw+ssqDvMRcAKgRqLG0KvflAnvqbJ/84rq+EsxL+2G0WlvUxhpw
	 fmgzGO90d23JDGxr4yRZ2yR/qQSH2zqmAi3V/6msNezuv481lWBLKskgheDBOW3oQj
	 QFQ79nfO377dDgYi0JI6Y/7Xhub9QBlsb/nldqh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 296/325] af_unix: Save O(n) setup of Tarjans algo.
Date: Mon,  2 Jun 2025 15:49:32 +0200
Message-ID: <20250602134331.930004627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit ba31b4a4e1018f5844c6eb31734976e2184f2f9a upstream.

Before starting Tarjan's algorithm, we need to mark all vertices
as unvisited.  We can save this O(n) setup by reserving two special
indices (0, 1) and using two variables.

The first time we link a vertex to unix_unvisited_vertices, we set
unix_vertex_unvisited_index to index.

During DFS, we can see that the index of unvisited vertices is the
same as unix_vertex_unvisited_index.

When we finalise SCC later, we set unix_vertex_grouped_index to each
vertex's index.

Then, we can know (i) that the vertex is on the stack if the index
of a visited vertex is >= 2 and (ii) that it is not on the stack and
belongs to a different SCC if the index is unix_vertex_grouped_index.

After the whole algorithm, all indices of vertices are set as
unix_vertex_grouped_index.

Next time we start DFS, we know that all unvisited vertices have
unix_vertex_grouped_index, and we can use unix_vertex_unvisited_index
as the not-on-stack marker.

To use the same variable in __unix_walk_scc(), we can swap
unix_vertex_(grouped|unvisited)_index at the end of Tarjan's
algorithm.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240325202425.60930-10-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    1 -
 net/unix/garbage.c    |   26 +++++++++++++++-----------
 2 files changed, 15 insertions(+), 12 deletions(-)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -37,7 +37,6 @@ struct unix_vertex {
 	unsigned long out_degree;
 	unsigned long index;
 	unsigned long lowlink;
-	bool on_stack;
 };
 
 struct unix_edge {
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -115,16 +115,20 @@ static struct unix_vertex *unix_edge_suc
 static LIST_HEAD(unix_unvisited_vertices);
 
 enum unix_vertex_index {
-	UNIX_VERTEX_INDEX_UNVISITED,
+	UNIX_VERTEX_INDEX_MARK1,
+	UNIX_VERTEX_INDEX_MARK2,
 	UNIX_VERTEX_INDEX_START,
 };
 
+static unsigned long unix_vertex_unvisited_index = UNIX_VERTEX_INDEX_MARK1;
+
 static void unix_add_edge(struct scm_fp_list *fpl, struct unix_edge *edge)
 {
 	struct unix_vertex *vertex = edge->predecessor->vertex;
 
 	if (!vertex) {
 		vertex = list_first_entry(&fpl->vertices, typeof(*vertex), entry);
+		vertex->index = unix_vertex_unvisited_index;
 		vertex->out_degree = 0;
 		INIT_LIST_HEAD(&vertex->edges);
 
@@ -265,6 +269,7 @@ void unix_destroy_fpl(struct scm_fp_list
 }
 
 static LIST_HEAD(unix_visited_vertices);
+static unsigned long unix_vertex_grouped_index = UNIX_VERTEX_INDEX_MARK2;
 
 static void __unix_walk_scc(struct unix_vertex *vertex)
 {
@@ -274,10 +279,10 @@ static void __unix_walk_scc(struct unix_
 	LIST_HEAD(edge_stack);
 
 next_vertex:
-	/* Push vertex to vertex_stack.
+	/* Push vertex to vertex_stack and mark it as on-stack
+	 * (index >= UNIX_VERTEX_INDEX_START).
 	 * The vertex will be popped when finalising SCC later.
 	 */
-	vertex->on_stack = true;
 	list_add(&vertex->scc_entry, &vertex_stack);
 
 	vertex->index = index;
@@ -291,7 +296,7 @@ next_vertex:
 		if (!next_vertex)
 			continue;
 
-		if (next_vertex->index == UNIX_VERTEX_INDEX_UNVISITED) {
+		if (next_vertex->index == unix_vertex_unvisited_index) {
 			/* Iterative deepening depth first search
 			 *
 			 *   1. Push a forward edge to edge_stack and set
@@ -317,7 +322,7 @@ prev_vertex:
 			 * to skip SCC finalisation.
 			 */
 			vertex->lowlink = min(vertex->lowlink, next_vertex->lowlink);
-		} else if (next_vertex->on_stack) {
+		} else if (next_vertex->index != unix_vertex_grouped_index) {
 			/* Loop detected by a back/cross edge.
 			 *
 			 * The successor is on vertex_stack, so two vertices are
@@ -344,7 +349,8 @@ prev_vertex:
 			/* Don't restart DFS from this vertex in unix_walk_scc(). */
 			list_move_tail(&vertex->entry, &unix_visited_vertices);
 
-			vertex->on_stack = false;
+			/* Mark vertex as off-stack. */
+			vertex->index = unix_vertex_grouped_index;
 		}
 
 		list_del(&scc);
@@ -357,20 +363,18 @@ prev_vertex:
 
 static void unix_walk_scc(void)
 {
-	struct unix_vertex *vertex;
-
-	list_for_each_entry(vertex, &unix_unvisited_vertices, entry)
-		vertex->index = UNIX_VERTEX_INDEX_UNVISITED;
-
 	/* Visit every vertex exactly once.
 	 * __unix_walk_scc() moves visited vertices to unix_visited_vertices.
 	 */
 	while (!list_empty(&unix_unvisited_vertices)) {
+		struct unix_vertex *vertex;
+
 		vertex = list_first_entry(&unix_unvisited_vertices, typeof(*vertex), entry);
 		__unix_walk_scc(vertex);
 	}
 
 	list_replace_init(&unix_visited_vertices, &unix_unvisited_vertices);
+	swap(unix_vertex_unvisited_index, unix_vertex_grouped_index);
 }
 
 static LIST_HEAD(gc_candidates);


