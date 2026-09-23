Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB02F53A3B3;
	Wed, 23 Sep 2026 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174560; cv=none; b=JTBjGto8uwkEF7zRTP6qMwpIQTzpFko+oGumfc8WdaQCA03nA6yXqt2G0+UUbkt0SellXZ1d76n+31RbVAUzpGAftyxHCAtp5D6oGs0T0I1UqrHkUj+yPvQ0oiZEqY7pnCuZVu34HPZPwBXumfKeeR9oQq7rMmDJ+9Mk+/Sohws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174560; c=relaxed/simple;
	bh=750n2cZmxmtQ5+V5H5IFhDjjpJEF2MEXW6zlTpENhe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5YwDONg5XCortOocrBrkTpJajQAJS2W7XgudLhZYgVYC4Q/yLlQNpAfmguD/eKhlySrRwYjOWUvcg5iIHNFPo3qYyTfVCGFMXMb/o3MD2OKDbBhc8ZKWUfeGkQzJlYCZXOE82p1G6y5ubEbu0G5DCEyRYMhIaTZh6ZDpwPAqAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyTcLtAI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyTcLtAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EF21F000FF;
	Wed, 23 Sep 2026 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174558;
	bh=7mzrN95geTdJmXe2e2DUkfFsBCvc09wD2aCqUg0ChV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyTcLtAIzVkLnciutgkYRRa2/96Z6ra28gWtsmucIu76jQrpAcNiM8HCI/4Um2bqt
	 +6srR6fqS4jUqwuliTA7pTL2050+Hs5aMR5VWeuQDQ738btoluxAnS/baRqfraRLXJ
	 yRSxDsJi5rQOapXRYqBBXHj30Qh4258SsY6lmwxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Burton <jamesburton@meta.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/398] af_unix: Unify scc_index when finalising SCC in __unix_walk_scc().
Date: Wed, 23 Sep 2026 16:03:48 +0200
Message-ID: <20260923140647.421776581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 4a4263dfeabad72f95e8ab6e15146861fa4144dd ]

Commit bfdb01283ee8 ("af_unix: Assign a unique index to SCC.")
changed Tarjan's algorithm to update lowlink with lowlink,
which is called lowpoint (unix_vertex.scc_index).

unix_vertex_dead() assumes all vertices in an SCC share the same
lowpoint, but this is not always true if an SCC has two or more
back edges, depending on the order of DFS.

For example, the graph below has two back edges from B to A
and from C to B.

  A --> B --> C
  ^    | ^    |
  `----' `----'

If DFS walks through A -> B -> C -> B (-> C -> B) -> A (-> B -> A),
each index and scc_index will be updated as follows.

  A --> B --> C    C = (3, 3)  (index, scc_index)
                   B = (2, 2)
                   A = (1, 1)

  A ... B ... C    C = (3, 2)<-.
         ^    |    B = (2, 2) -'
         `----'    A = (1, 1)

  A ... B ... C    C = (3, 2)
  ^    | .    .    B = (2, 1)<-.
  `----'  ....     A = (1, 1) -'

Then, unix_vertex_dead() thinks that B is passed to another
SCC with scc_index 2, and the SCC is not garbage-collected.

This does not happen if DFS walks in a different order below
or starts from B.

    1      3
  A --> B --> C
  ^    | ^    |
  `----' `----'
     2      4

Let's unify scc_index across the SCC when finalising it.

Note that updating v->index was previously done in unix_scc_dead(),
when called from __unix_walk_scc(), just to save one loop.  Since
__unix_walk_scc() now iterates over the SCC anyway, the update is
moved back to __unix_walk_scc() and 'fast' argument is dropped.

Fixes: 4090fa373f0e ("af_unix: Replace garbage collection algorithm.")
Reported-by: James Burton <jamesburton@meta.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260912030852.1467872-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index cad17f639b01b..11b75d37ac03a 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -375,7 +375,7 @@ static bool unix_vertex_dead(struct unix_vertex *vertex)
 static LIST_HEAD(unix_visited_vertices);
 static unsigned long unix_vertex_grouped_index = UNIX_VERTEX_INDEX_MARK2;
 
-static bool unix_scc_dead(struct list_head *scc, bool fast)
+static bool unix_scc_dead(struct list_head *scc)
 {
 	struct unix_vertex *vertex;
 	bool scc_dead = true;
@@ -387,10 +387,6 @@ static bool unix_scc_dead(struct list_head *scc, bool fast)
 		/* Don't restart DFS from this vertex. */
 		list_move_tail(&vertex->entry, &unix_visited_vertices);
 
-		/* Mark vertex as off-stack for __unix_walk_scc(). */
-		if (!fast)
-			vertex->index = unix_vertex_grouped_index;
-
 		if (scc_dead)
 			scc_dead = unix_vertex_dead(vertex);
 	}
@@ -522,6 +518,7 @@ static unsigned long __unix_walk_scc(struct unix_vertex *vertex,
 	}
 
 	if (vertex->index == vertex->scc_index) {
+		struct unix_vertex *v;
 		struct list_head scc;
 
 		/* SCC finalised.
@@ -531,7 +528,13 @@ static unsigned long __unix_walk_scc(struct unix_vertex *vertex,
 		 */
 		__list_cut_position(&scc, &vertex_stack, &vertex->scc_entry);
 
-		if (unix_scc_dead(&scc, false)) {
+		list_for_each_entry_reverse(v, &scc, scc_entry) {
+			/* Mark vertex as off-stack and assign a unique ID. */
+			v->index = unix_vertex_grouped_index;
+			v->scc_index = vertex->scc_index;
+		}
+
+		if (unix_scc_dead(&scc)) {
 			unix_collect_skb(&scc, hitlist);
 		} else {
 			if (unix_vertex_max_scc_index < vertex->scc_index)
@@ -588,7 +591,7 @@ static void unix_walk_scc_fast(struct sk_buff_head *hitlist)
 		vertex = list_first_entry(&unix_unvisited_vertices, typeof(*vertex), entry);
 		list_add(&scc, &vertex->scc_entry);
 
-		if (unix_scc_dead(&scc, true)) {
+		if (unix_scc_dead(&scc)) {
 			cyclic_sccs--;
 			unix_collect_skb(&scc, hitlist);
 		}
-- 
2.53.0



