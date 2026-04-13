Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC0024DCF6;
	Mon, 13 Apr 2026 16:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096449; cv=none; b=Yof8Xd2mVolhCpY+uHQRI2mfjtt8V0f9gkwrtiDamBfMdZLJ2vaBr6KX355QDCW5e3MJxkx2aMVVCNNZbl2rBUHoAMsU8xR0FWl+bmtYR3F2aXRkz7lKzXYXG79krTaYWN5snvVhMoP+uXgfbVPX5bPHaxAoMCVvzSJxys0Rk6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096449; c=relaxed/simple;
	bh=6KsTMiviaFP+KxAth7HqMogLHhCuCM4OCafPsEa/ldo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a032LYrxBoAmOgXvBaMeWkavZv37IKCUHVLrF30bG+rc+qyIj5OAJKkddlSYdXR7lAD9dN3NKriSh6GuKpTZoQDij0MLF34vjND6L2EnL+p75t4o1dIPqAsDlzt8Ew5hnA6IHLXdoHHl2QlQzTdoPdWBUUp5rx0G2hcJe1M2txM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqSAJOEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqSAJOEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F9FC2BCAF;
	Mon, 13 Apr 2026 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096449;
	bh=6KsTMiviaFP+KxAth7HqMogLHhCuCM4OCafPsEa/ldo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqSAJOEN7DUjyi5hP+YlPgAL2W0CnKgAgo3eHln1VBwgVmdGigOO1vo5EtKNiNB8g
	 8COXU9h3It3kwPYgPEYg+elrLtxSWAkA2fzJ/x+k2DjtONtxJIib38OcrFvfpGpqKc
	 R4H/i78I156cZ8uq7lDf52QwdqXDkZ5M8DRt4RkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 16/83] af_unix: Count cyclic SCC.
Date: Mon, 13 Apr 2026 17:59:44 +0200
Message-ID: <20260413155731.633233517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

[ Upstream commit 58b47c713711b8afbf68e3158d4d5acdead00e9b ]

__unix_walk_scc() and unix_walk_scc_fast() call unix_scc_cyclic()
for each SCC to check if it forms a cyclic reference, so that we
can skip GC at the following invocations in case all SCCs do not
have any cycles.

If we count the number of cyclic SCCs in __unix_walk_scc(), we can
simplify unix_walk_scc_fast() because the number of cyclic SCCs
only changes when it garbage-collects a SCC.

So, let's count cyclic SCC in __unix_walk_scc() and decrement it
in unix_walk_scc_fast() when performing garbage collection.

Note that we will use this counter in a later patch to check if a
cycle existed in the previous GC run.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20251115020935.2643121-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e5b31d988a41 ("af_unix: Give up GC if MSG_PEEK intervened.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 65396a4e1b07e..9f62d50979735 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -404,9 +404,11 @@ static bool unix_scc_cyclic(struct list_head *scc)
 static LIST_HEAD(unix_visited_vertices);
 static unsigned long unix_vertex_grouped_index = UNIX_VERTEX_INDEX_MARK2;
 
-static void __unix_walk_scc(struct unix_vertex *vertex, unsigned long *last_index,
-			    struct sk_buff_head *hitlist)
+static unsigned long __unix_walk_scc(struct unix_vertex *vertex,
+				     unsigned long *last_index,
+				     struct sk_buff_head *hitlist)
 {
+	unsigned long cyclic_sccs = 0;
 	LIST_HEAD(vertex_stack);
 	struct unix_edge *edge;
 	LIST_HEAD(edge_stack);
@@ -497,8 +499,8 @@ static void __unix_walk_scc(struct unix_vertex *vertex, unsigned long *last_inde
 			if (unix_vertex_max_scc_index < vertex->scc_index)
 				unix_vertex_max_scc_index = vertex->scc_index;
 
-			if (!unix_graph_maybe_cyclic)
-				unix_graph_maybe_cyclic = unix_scc_cyclic(&scc);
+			if (unix_scc_cyclic(&scc))
+				cyclic_sccs++;
 		}
 
 		list_del(&scc);
@@ -507,13 +509,17 @@ static void __unix_walk_scc(struct unix_vertex *vertex, unsigned long *last_inde
 	/* Need backtracking ? */
 	if (!list_empty(&edge_stack))
 		goto prev_vertex;
+
+	return cyclic_sccs;
 }
 
+static unsigned long unix_graph_cyclic_sccs;
+
 static void unix_walk_scc(struct sk_buff_head *hitlist)
 {
 	unsigned long last_index = UNIX_VERTEX_INDEX_START;
+	unsigned long cyclic_sccs = 0;
 
-	unix_graph_maybe_cyclic = false;
 	unix_vertex_max_scc_index = UNIX_VERTEX_INDEX_START;
 
 	/* Visit every vertex exactly once.
@@ -523,18 +529,20 @@ static void unix_walk_scc(struct sk_buff_head *hitlist)
 		struct unix_vertex *vertex;
 
 		vertex = list_first_entry(&unix_unvisited_vertices, typeof(*vertex), entry);
-		__unix_walk_scc(vertex, &last_index, hitlist);
+		cyclic_sccs += __unix_walk_scc(vertex, &last_index, hitlist);
 	}
 
 	list_replace_init(&unix_visited_vertices, &unix_unvisited_vertices);
 	swap(unix_vertex_unvisited_index, unix_vertex_grouped_index);
 
+	unix_graph_cyclic_sccs = cyclic_sccs;
+	unix_graph_maybe_cyclic = !!unix_graph_cyclic_sccs;
 	unix_graph_grouped = true;
 }
 
 static void unix_walk_scc_fast(struct sk_buff_head *hitlist)
 {
-	unix_graph_maybe_cyclic = false;
+	unsigned long cyclic_sccs = unix_graph_cyclic_sccs;
 
 	while (!list_empty(&unix_unvisited_vertices)) {
 		struct unix_vertex *vertex;
@@ -551,15 +559,18 @@ static void unix_walk_scc_fast(struct sk_buff_head *hitlist)
 				scc_dead = unix_vertex_dead(vertex);
 		}
 
-		if (scc_dead)
+		if (scc_dead) {
+			cyclic_sccs--;
 			unix_collect_skb(&scc, hitlist);
-		else if (!unix_graph_maybe_cyclic)
-			unix_graph_maybe_cyclic = unix_scc_cyclic(&scc);
+		}
 
 		list_del(&scc);
 	}
 
 	list_replace_init(&unix_visited_vertices, &unix_unvisited_vertices);
+
+	unix_graph_cyclic_sccs = cyclic_sccs;
+	unix_graph_maybe_cyclic = !!unix_graph_cyclic_sccs;
 }
 
 static bool gc_in_progress;
-- 
2.53.0



