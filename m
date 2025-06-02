Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BF11FBC90;
	Mon,  2 Jun 2025 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874265; cv=none; b=mi4Z+IAWH3VNle39KY7BMz0gNmXKYRZemvraETAAj+CogL1Y1MsrQoUNwX+qcAFnIiy0UzajtAQ4U97TodBqNF9NIG2p5ton1ivKDwq+MDKKdjKQYoJorB+fG93WKpjAApjJ2nD4/qqZOn+8zv73cYa9Mu/ySOD+GbnLVsJ+g6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874265; c=relaxed/simple;
	bh=BLGMCnWjOHCCXm6u0o+I3SZySbIJ7sz4CTONTHG/4eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krmepsWfqbB96oul08MTMn+FA+N0+T55CiYL6VobPUpq2IAqGG9dptG4DsmJ8IJw/O1UKrbXHwje885jnO7e5febsQVM5+nd38cyNX/feSiCDUpwKHJkwWV7YHQJH/vrNN6cxRBokzImYm6GAkFSzhIErVTw9tvzn4AXV9ppZbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrBqdecm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrBqdecm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548BCC4CEEB;
	Mon,  2 Jun 2025 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874265;
	bh=BLGMCnWjOHCCXm6u0o+I3SZySbIJ7sz4CTONTHG/4eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrBqdecmjGbVrlfKhljvXKosJrXvHFocRQ9pW+h/bZD1HPMQy9NpSEOmeTMWPKLSU
	 ulo7kyP+J4d7ZdBWWEx959VrpWxUBPoYunqYFMfqXraR/mEvh68injmoXQttZbLDfe
	 hxnSjEXF9FSxo2bLaFPe7p10DzTDfY6WAo71A/kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 413/444] af_unix: Detect dead SCC.
Date: Mon,  2 Jun 2025 15:47:57 +0200
Message-ID: <20250602134357.700807080@linuxfoundation.org>
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

commit a15702d8b3aad8ce5268c565bd29f0e02fd2db83 upstream.

When iterating SCC, we call unix_vertex_dead() for each vertex
to check if the vertex is close()d and has no bridge to another
SCC.

If both conditions are true for every vertex in SCC, we can
execute garbage collection for all skb in the SCC.

The actual garbage collection is done in the following patch,
replacing the old implementation.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240325202425.60930-14-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/garbage.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -289,6 +289,39 @@ void unix_destroy_fpl(struct scm_fp_list
 	unix_free_vertices(fpl);
 }
 
+static bool unix_vertex_dead(struct unix_vertex *vertex)
+{
+	struct unix_edge *edge;
+	struct unix_sock *u;
+	long total_ref;
+
+	list_for_each_entry(edge, &vertex->edges, vertex_entry) {
+		struct unix_vertex *next_vertex = unix_edge_successor(edge);
+
+		/* The vertex's fd can be received by a non-inflight socket. */
+		if (!next_vertex)
+			return false;
+
+		/* The vertex's fd can be received by an inflight socket in
+		 * another SCC.
+		 */
+		if (next_vertex->scc_index != vertex->scc_index)
+			return false;
+	}
+
+	/* No receiver exists out of the same SCC. */
+
+	edge = list_first_entry(&vertex->edges, typeof(*edge), vertex_entry);
+	u = edge->predecessor;
+	total_ref = file_count(u->sk.sk_socket->file);
+
+	/* If not close()d, total_ref > out_degree. */
+	if (total_ref != vertex->out_degree)
+		return false;
+
+	return true;
+}
+
 static bool unix_scc_cyclic(struct list_head *scc)
 {
 	struct unix_vertex *vertex;
@@ -377,6 +410,7 @@ prev_vertex:
 
 	if (vertex->index == vertex->scc_index) {
 		struct list_head scc;
+		bool scc_dead = true;
 
 		/* SCC finalised.
 		 *
@@ -391,6 +425,9 @@ prev_vertex:
 
 			/* Mark vertex as off-stack. */
 			vertex->index = unix_vertex_grouped_index;
+
+			if (scc_dead)
+				scc_dead = unix_vertex_dead(vertex);
 		}
 
 		if (!unix_graph_maybe_cyclic)
@@ -431,13 +468,18 @@ static void unix_walk_scc_fast(void)
 	while (!list_empty(&unix_unvisited_vertices)) {
 		struct unix_vertex *vertex;
 		struct list_head scc;
+		bool scc_dead = true;
 
 		vertex = list_first_entry(&unix_unvisited_vertices, typeof(*vertex), entry);
 		list_add(&scc, &vertex->scc_entry);
 
-		list_for_each_entry_reverse(vertex, &scc, scc_entry)
+		list_for_each_entry_reverse(vertex, &scc, scc_entry) {
 			list_move_tail(&vertex->entry, &unix_visited_vertices);
 
+			if (scc_dead)
+				scc_dead = unix_vertex_dead(vertex);
+		}
+
 		list_del(&scc);
 	}
 


