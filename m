Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F1B221299;
	Mon,  2 Jun 2025 14:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874340; cv=none; b=d4pY22+6yYEZZ0UPOGiflVK15PIkM00biQgFKfEyFCPdYDA+UHCACKg+m85qekrOhKn9exz+Wm1C0PSl4aI8iOglxtWVRly9ZybVznyIlrk1GEasIt8UD8Kkn8AQKWcgjWPRxb5GC59HFJvNQWzuJQprmrWYY/gqq9yrSb3R/hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874340; c=relaxed/simple;
	bh=6Y3L89GqaJNuDcgU5G6jPWt0hmRIYlgmJJi4Ec/aGzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epVUlG7T9jI5pTCOq8wZFuFfyPKfnacqvL9UQL5WH6tOnfboZgF7u2JahrrfAlP7H7xDkpKZ58bjtRtMvsX1KWGl7tFxiNvFcjZySYkYUuD0E0N3Esgwkibahl1mHkHLLJMipCsnV/V223ZytqMTh6dZGj1U7Xu14tDqWJfZF8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yqx0gSsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yqx0gSsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E79C4CEEB;
	Mon,  2 Jun 2025 14:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874340;
	bh=6Y3L89GqaJNuDcgU5G6jPWt0hmRIYlgmJJi4Ec/aGzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yqx0gSsACc6naOWcxVFrNFuTfw/2qVqSBTjzL3Nzn9ybWOlIkX3Z7uaY8ytpikhwN
	 Mrl2Vk6G/8/r3f29PC7X9CMXvfSiOQBE4DomVFzJuHLhuMtU/OyC72kD2ISq/ntaZt
	 +MFmot6RlFI/DINowiOZdH0ec5jddeDc+X4XWP0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 406/444] af_unix: Detect Strongly Connected Components.
Date: Mon,  2 Jun 2025 15:47:50 +0200
Message-ID: <20250602134357.407345608@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 3484f063172dd88776b062046d721d7c2ae1af7c upstream.

In the new GC, we use a simple graph algorithm, Tarjan's Strongly
Connected Components (SCC) algorithm, to find cyclic references.

The algorithm visits every vertex exactly once using depth-first
search (DFS).

DFS starts by pushing an input vertex to a stack and assigning it
a unique number.  Two fields, index and lowlink, are initialised
with the number, but lowlink could be updated later during DFS.

If a vertex has an edge to an unvisited inflight vertex, we visit
it and do the same processing.  So, we will have vertices in the
stack in the order they appear and number them consecutively in
the same order.

If a vertex has a back-edge to a visited vertex in the stack,
we update the predecessor's lowlink with the successor's index.

After iterating edges from the vertex, we check if its index
equals its lowlink.

If the lowlink is different from the index, it shows there was a
back-edge.  Then, we go backtracking and propagate the lowlink to
its predecessor and resume the previous edge iteration from the
next edge.

If the lowlink is the same as the index, we pop vertices before
and including the vertex from the stack.  Then, the set of vertices
is SCC, possibly forming a cycle.  At the same time, we move the
vertices to unix_visited_vertices.

When we finish the algorithm, all vertices in each SCC will be
linked via unix_vertex.scc_entry.

Let's take an example.  We have a graph including five inflight
vertices (F is not inflight):

  A -> B -> C -> D -> E (-> F)
       ^         |
       `---------'

Suppose that we start DFS from C.  We will visit C, D, and B first
and initialise their index and lowlink.  Then, the stack looks like
this:

  > B = (3, 3)  (index, lowlink)
    D = (2, 2)
    C = (1, 1)

When checking B's edge to C, we update B's lowlink with C's index
and propagate it to D.

    B = (3, 1)  (index, lowlink)
  > D = (2, 1)
    C = (1, 1)

Next, we visit E, which has no edge to an inflight vertex.

  > E = (4, 4)  (index, lowlink)
    B = (3, 1)
    D = (2, 1)
    C = (1, 1)

When we leave from E, its index and lowlink are the same, so we
pop E from the stack as single-vertex SCC.  Next, we leave from
B and D but do nothing because their lowlink are different from
their index.

    B = (3, 1)  (index, lowlink)
    D = (2, 1)
  > C = (1, 1)

Then, we leave from C, whose index and lowlink are the same, so
we pop B, D and C as SCC.

Last, we do DFS for the rest of vertices, A, which is also a
single-vertex SCC.

Finally, each unix_vertex.scc_entry is linked as follows:

  A -.  B -> C -> D  E -.
  ^  |  ^         |  ^  |
  `--'  `---------'  `--'

We use SCC later to decide whether we can garbage-collect the
sockets.

Note that we still cannot detect SCC properly if an edge points
to an embryo socket.  The following two patches will sort it out.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240325202425.60930-7-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    3 +++
 net/unix/garbage.c    |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -32,8 +32,11 @@ void wait_for_unix_gc(struct scm_fp_list
 struct unix_vertex {
 	struct list_head edges;
 	struct list_head entry;
+	struct list_head scc_entry;
 	unsigned long out_degree;
 	unsigned long index;
+	unsigned long lowlink;
+	bool on_stack;
 };
 
 struct unix_edge {
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -251,11 +251,19 @@ static LIST_HEAD(unix_visited_vertices);
 static void __unix_walk_scc(struct unix_vertex *vertex)
 {
 	unsigned long index = UNIX_VERTEX_INDEX_START;
+	LIST_HEAD(vertex_stack);
 	struct unix_edge *edge;
 	LIST_HEAD(edge_stack);
 
 next_vertex:
+	/* Push vertex to vertex_stack.
+	 * The vertex will be popped when finalising SCC later.
+	 */
+	vertex->on_stack = true;
+	list_add(&vertex->scc_entry, &vertex_stack);
+
 	vertex->index = index;
+	vertex->lowlink = index;
 	index++;
 
 	/* Explore neighbour vertices (receivers of the current vertex's fd). */
@@ -283,12 +291,46 @@ prev_vertex:
 			edge = list_first_entry(&edge_stack, typeof(*edge), stack_entry);
 			list_del_init(&edge->stack_entry);
 
+			next_vertex = vertex;
 			vertex = edge->predecessor->vertex;
+
+			/* If the successor has a smaller lowlink, two vertices
+			 * are in the same SCC, so propagate the smaller lowlink
+			 * to skip SCC finalisation.
+			 */
+			vertex->lowlink = min(vertex->lowlink, next_vertex->lowlink);
+		} else if (next_vertex->on_stack) {
+			/* Loop detected by a back/cross edge.
+			 *
+			 * The successor is on vertex_stack, so two vertices are
+			 * in the same SCC.  If the successor has a smaller index,
+			 * propagate it to skip SCC finalisation.
+			 */
+			vertex->lowlink = min(vertex->lowlink, next_vertex->index);
+		} else {
+			/* The successor was already grouped as another SCC */
 		}
 	}
 
-	/* Don't restart DFS from this vertex in unix_walk_scc(). */
-	list_move_tail(&vertex->entry, &unix_visited_vertices);
+	if (vertex->index == vertex->lowlink) {
+		struct list_head scc;
+
+		/* SCC finalised.
+		 *
+		 * If the lowlink was not updated, all the vertices above on
+		 * vertex_stack are in the same SCC.  Group them using scc_entry.
+		 */
+		__list_cut_position(&scc, &vertex_stack, &vertex->scc_entry);
+
+		list_for_each_entry_reverse(vertex, &scc, scc_entry) {
+			/* Don't restart DFS from this vertex in unix_walk_scc(). */
+			list_move_tail(&vertex->entry, &unix_visited_vertices);
+
+			vertex->on_stack = false;
+		}
+
+		list_del(&scc);
+	}
 
 	/* Need backtracking ? */
 	if (!list_empty(&edge_stack))


