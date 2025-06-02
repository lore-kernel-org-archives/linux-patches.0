Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5938023372E;
	Mon,  2 Jun 2025 15:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877505; cv=none; b=OEEdX6fh7BAvA7mg39sIT/e5M6dWXw7HLuAFgzwVbJDqGtC/7ofnf9G97TlOJ20lkATHnfD4BMB7hlAGS2dTANIBfgd/yD7u3N8SJoF+zpYCJOS7479dcRX2PWJZM4Q06ebUSYC5zsfRanhD8kXpdSq3G2UbYBo8uwHVvEX1oj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877505; c=relaxed/simple;
	bh=tgcvdyLV0GAiyPg5FyrWFYCTQqnPrCAMKwYcF3pXnns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tg/P21cg8kkBXk1MhRIgG1ML3+Va7+Wx6zfjui/pIxdtpqA0hjrStJ4jztOPIKVrpPN9Dj9k0eqixm0bFl/BKJ0jxAbmdfhQjCtY0nAbHu95IwwbktXnoHfnd1H6OkhvKFfNeaZblYRXMnQFbeydTJUn3c9Ey++/VtmzfApC7XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Am3g96Kv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Am3g96Kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D323FC4CEEB;
	Mon,  2 Jun 2025 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877505;
	bh=tgcvdyLV0GAiyPg5FyrWFYCTQqnPrCAMKwYcF3pXnns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Am3g96KvmOUa5RYYXPqem+Jb1uM2g8S1l6rXWhxe7V+ynlFRsOykfsbYN6CpcIH6Q
	 F8Tbjz8C7wwMZv8r6dE6rEKmSWHZo7Cz+iVdAqS3RyCb01vGFXaFgQU5mqrSVPplk4
	 eWnG9ZON187xUCdxmwKIYzBP6LSZCFvBlBuSWRJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 298/325] af_unix: Avoid Tarjans algorithm if unnecessary.
Date: Mon,  2 Jun 2025 15:49:34 +0200
Message-ID: <20250602134332.017183505@linuxfoundation.org>
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


