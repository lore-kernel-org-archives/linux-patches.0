Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA6E1B81DC;
	Mon,  2 Jun 2025 14:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874260; cv=none; b=KVSlNOSooCQ5Re03enq/ORq5DRuO3NqhY0nHrdk3vVBp0rR/J/TtNoaTFSW9IbT8714DHlMdFRW33q5ye7CbzNDFfM3oncm3p6kLerWhQyqCTgkXFJrjXjdwG0sDURAtBKv76ZqgoEs6MawJZqF38KnHDnGqVZ3rIKWOYFm1K0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874260; c=relaxed/simple;
	bh=ppFy1zCA6grvT9Nf4jUgCTaDjJfKdoNlR85VKxY4cGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vkmjse5n6VYzfVzyB4Lc8MtPd4jxwzBBisTEWYMTUMWeLFyykoVmYigecRx2uCDJEUcve9yuOid8Vz+fJNu6bW7QUilPMDAvEsKF0jJdMQjAn9JYd0VXEwDCp1sQHeXdfp9ZToz8PQVpZWwepk3mYVOOaS94S7QtR3S2en1sIUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cy1NaPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cy1NaPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888DFC4CEEB;
	Mon,  2 Jun 2025 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874259;
	bh=ppFy1zCA6grvT9Nf4jUgCTaDjJfKdoNlR85VKxY4cGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cy1NaPJWPynt2OOskE4anac8rmYdW5/KHOBEgnrgB0Qu0gq9K6LVhauJZz/2q3WG
	 z1pBWXzQXSpd/EPbMM6DO6de0uXrRgYL1CajfFA3v4x3zmjzadZ0zn/8T3keLKWkYH
	 DlqHXGQCuhRqU477RphvMt3Qq/J8HA/MuogI+pmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 411/444] af_unix: Avoid Tarjans algorithm if unnecessary.
Date: Mon,  2 Jun 2025 15:47:55 +0200
Message-ID: <20250602134357.615782764@linuxfoundation.org>
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

commit ad081928a8b0f57f269df999a28087fce6f2b6ce upstream.

Once a cyclic reference is formed, we need to run GC to check if
there is dead SCC.

However, we do not need to run Tarjan's algorithm if we know that
the shape of the inflight graph has not been changed.

If an edge is added/updated/deleted and the edge's successor is
inflight, we set false to unix_graph_grouped, which means we need
to re-classify SCC.

Once we finalise SCC, we set true to unix_graph_grouped.

While unix_graph_grouped is true, we can iterate the grouped
SCC using vertex->scc_entry in unix_walk_scc_fast().

list_add() and list_for_each_entry_reverse() uses seem weird, but
they are to keep the vertex order consistent and make writing test
easier.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240325202425.60930-12-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/garbage.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -113,6 +113,7 @@ static struct unix_vertex *unix_edge_suc
 }
 
 static bool unix_graph_maybe_cyclic;
+static bool unix_graph_grouped;
 
 static void unix_update_graph(struct unix_vertex *vertex)
 {
@@ -123,6 +124,7 @@ static void unix_update_graph(struct uni
 		return;
 
 	unix_graph_maybe_cyclic = true;
+	unix_graph_grouped = false;
 }
 
 static LIST_HEAD(unix_unvisited_vertices);
@@ -144,6 +146,7 @@ static void unix_add_edge(struct scm_fp_
 		vertex->index = unix_vertex_unvisited_index;
 		vertex->out_degree = 0;
 		INIT_LIST_HEAD(&vertex->edges);
+		INIT_LIST_HEAD(&vertex->scc_entry);
 
 		list_move_tail(&vertex->entry, &unix_unvisited_vertices);
 		edge->predecessor->vertex = vertex;
@@ -418,6 +421,26 @@ static void unix_walk_scc(void)
 
 	list_replace_init(&unix_visited_vertices, &unix_unvisited_vertices);
 	swap(unix_vertex_unvisited_index, unix_vertex_grouped_index);
+
+	unix_graph_grouped = true;
+}
+
+static void unix_walk_scc_fast(void)
+{
+	while (!list_empty(&unix_unvisited_vertices)) {
+		struct unix_vertex *vertex;
+		struct list_head scc;
+
+		vertex = list_first_entry(&unix_unvisited_vertices, typeof(*vertex), entry);
+		list_add(&scc, &vertex->scc_entry);
+
+		list_for_each_entry_reverse(vertex, &scc, scc_entry)
+			list_move_tail(&vertex->entry, &unix_visited_vertices);
+
+		list_del(&scc);
+	}
+
+	list_replace_init(&unix_visited_vertices, &unix_unvisited_vertices);
 }
 
 static LIST_HEAD(gc_candidates);
@@ -570,7 +593,10 @@ static void __unix_gc(struct work_struct
 	if (!unix_graph_maybe_cyclic)
 		goto skip_gc;
 
-	unix_walk_scc();
+	if (unix_graph_grouped)
+		unix_walk_scc_fast();
+	else
+		unix_walk_scc();
 
 	/* First, select candidates for garbage collection.  Only
 	 * in-flight sockets are considered, and from those only ones


