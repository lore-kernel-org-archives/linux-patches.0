Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA53494824;
	Wed, 23 Sep 2026 14:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173231; cv=none; b=akYYBWeG7t7webafirndPsrZsyCWCeAxPeU70vOpz9bysPtQIIDZu2ugQ/xH9PVmbnrpXZi3OPYMdLKL9RGF2z+hpKedow1Bpro+3B3aZIpVQ0G6wpK80FBESeepdns/Qe3DXPKJl5I9IcoW6t7IN5C4MXYmFZGYWFhBujix+8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173231; c=relaxed/simple;
	bh=o3DHTPiMv7deMuXjUlkicMbpiUtHcR8+TWPOzqWF1F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mg8siOWH0s0WRoYevWjK5nTcO04MgNiR5v25Lv5m9Lr/y/aLgavb0bZpihAMA53HawKkdZmeG8fkWTlhbsMY+az2ROKlYDUMiWbjOnG8gcJxH4qkiUtYH677MdmhFMthYpY6FBcGBXLH0Yh+xCrGJ2IkDiUYbr3CB5FER75RMRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xts0loG7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xts0loG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD48E1F000FF;
	Wed, 23 Sep 2026 14:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173229;
	bh=0QMZlADmWi93KrmooMOEzpB4mcbg0hVAGd9Nb1l59m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xts0loG7NEWR4Pw3EI49Fp9lDuzPYATBFxKk3cJkWoAO+V+Dd7Dog9sR1/LSAEd+O
	 2CIfmN5u0ttVWS+Z+O8aknYVg/j0xrB3+g+WObHwHRAUFYMeIG+8pSiY6OZwwWwRNy
	 CIz5CO4pYl3PtOydSpdW330u7Ewj/rW6klZjrcnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Burton <jamesburton@meta.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 180/438] af_unix: Unify scc_index when finalising SCC in __unix_walk_scc().
Date: Wed, 23 Sep 2026 16:03:21 +0200
Message-ID: <20260923140649.431153456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 9fcaaf55cba5d..da774f56ca648 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -374,7 +374,7 @@ static bool unix_vertex_dead(struct unix_vertex *vertex)
 static LIST_HEAD(unix_visited_vertices);
 static unsigned long unix_vertex_grouped_index = UNIX_VERTEX_INDEX_MARK2;
 
-static bool unix_scc_dead(struct list_head *scc, bool fast)
+static bool unix_scc_dead(struct list_head *scc)
 {
 	struct unix_vertex *vertex;
 	bool scc_dead = true;
@@ -386,10 +386,6 @@ static bool unix_scc_dead(struct list_head *scc, bool fast)
 		/* Don't restart DFS from this vertex. */
 		list_move_tail(&vertex->entry, &unix_visited_vertices);
 
-		/* Mark vertex as off-stack for __unix_walk_scc(). */
-		if (!fast)
-			vertex->index = unix_vertex_grouped_index;
-
 		if (scc_dead)
 			scc_dead = unix_vertex_dead(vertex);
 	}
@@ -521,6 +517,7 @@ static unsigned long __unix_walk_scc(struct unix_vertex *vertex,
 	}
 
 	if (vertex->index == vertex->scc_index) {
+		struct unix_vertex *v;
 		struct list_head scc;
 
 		/* SCC finalised.
@@ -530,7 +527,13 @@ static unsigned long __unix_walk_scc(struct unix_vertex *vertex,
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



