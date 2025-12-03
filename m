Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E807B35C185;
	Wed,  3 Dec 2025 16:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779786; cv=none; b=shWomNP41GsDYQtf9/BsWEITqVMODaFXD7IN/9DQDPZYdgpfDv3nTmKtsRLhfQx1qORmlXLsONpMIVypEd9w3/JM6miVrTVroM938CO1p1XP2/pu9zkS+YR7dVfCRT+YZ2Y2KA0MOsABfSUxEdDJIFqh+4SxUXtNXJAHSpl9GAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779786; c=relaxed/simple;
	bh=pzy4ngyhsZnf+fTbptz6JI8FvOEtOCOc4U5Jj8p5iXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4uIVW0cGVERbP6EujprhN5GaCE7vyhlI2vJVp47vKcd4DMqbfurNswLxzRaokXDpeEPYGXSGfTa+Pq1iI3Q9JvEQZKlpS0gWBRKBdocGK4TQU2AY0efjJBQzeFGKb5iiOVetBMtr/mjkn0IJG6jjOf3gaBZ/JKWZtgJi4Vcws8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVSEvP+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVSEvP+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDF9C4CEF5;
	Wed,  3 Dec 2025 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779785;
	bh=pzy4ngyhsZnf+fTbptz6JI8FvOEtOCOc4U5Jj8p5iXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVSEvP+XMxrvg2MC3vYT0n1hzt6kA+kkYd4RK/jpNaxYWk0ycMzjTsZ5urFL15cif
	 owevNYhyWrAm/Ae2RoQGwasfgxeylQidhB/5Ot4cakGg2At9SJHBf0/i7d7w5+r50v
	 t8g36vKXM28XQgIYSxgjybzhyCvcR+Jc/AoRGfm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quang Le <quanglex97@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 361/568] af_unix: Initialise scc_index in unix_add_edge().
Date: Wed,  3 Dec 2025 16:26:03 +0100
Message-ID: <20251203152453.923836073@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 60e6489f8e3b086bd1130ad4450a2c112e863791 ]

Quang Le reported that the AF_UNIX GC could garbage-collect a
receive queue of an alive in-flight socket, with a nice repro.

The repro consists of three stages.

  1)
    1-a. Create a single cyclic reference with many sockets
    1-b. close() all sockets
    1-c. Trigger GC

  2)
    2-a. Pass sk-A to an embryo sk-B
    2-b. Pass sk-X to sk-X
    2-c. Trigger GC

  3)
    3-a. accept() the embryo sk-B
    3-b. Pass sk-B to sk-C
    3-c. close() the in-flight sk-A
    3-d. Trigger GC

As of 2-c, sk-A and sk-X are linked to unix_unvisited_vertices,
and unix_walk_scc() groups them into two different SCCs:

  unix_sk(sk-A)->vertex->scc_index = 2 (UNIX_VERTEX_INDEX_START)
  unix_sk(sk-X)->vertex->scc_index = 3

Once GC completes, unix_graph_grouped is set to true.
Also, unix_graph_maybe_cyclic is set to true due to sk-X's
cyclic self-reference, which makes close() trigger GC.

At 3-b, unix_add_edge() allocates unix_sk(sk-B)->vertex and
links it to unix_unvisited_vertices.

unix_update_graph() is called at 3-a. and 3-b., but neither
unix_graph_grouped nor unix_graph_maybe_cyclic is changed
because both sk-B's listener and sk-C are not in-flight.

3-c decrements sk-A's file refcnt to 1.

Since unix_graph_grouped is true at 3-d, unix_walk_scc_fast()
is finally called and iterates 3 sockets sk-A, sk-B, and sk-X:

  sk-A -> sk-B (-> sk-C)
  sk-X -> sk-X

This is totally fine.  All of them are not yet close()d and
should be grouped into different SCCs.

However, unix_vertex_dead() misjudges that sk-A and sk-B are
in the same SCC and sk-A is dead.

  unix_sk(sk-A)->scc_index == unix_sk(sk-B)->scc_index <-- Wrong!
  &&
  sk-A's file refcnt == unix_sk(sk-A)->vertex->out_degree
                                       ^-- 1 in-flight count for sk-B
  -> sk-A is dead !?

The problem is that unix_add_edge() does not initialise scc_index.

Stage 1) is used for heap spraying, making a newly allocated
vertex have vertex->scc_index == 2 (UNIX_VERTEX_INDEX_START)
set by unix_walk_scc() at 1-c.

Let's track the max SCC index from the previous unix_walk_scc()
call and assign the max + 1 to a new vertex's scc_index.

This way, we can continue to avoid Tarjan's algorithm while
preventing misjudgments.

Fixes: ad081928a8b0 ("af_unix: Avoid Tarjan's algorithm if unnecessary.")
Reported-by: Quang Le <quanglex97@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20251109025233.3659187-1-kuniyu@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 0068e758be4dd..66fd606c43f45 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -136,6 +136,7 @@ enum unix_vertex_index {
 };
 
 static unsigned long unix_vertex_unvisited_index = UNIX_VERTEX_INDEX_MARK1;
+static unsigned long unix_vertex_max_scc_index = UNIX_VERTEX_INDEX_START;
 
 static void unix_add_edge(struct scm_fp_list *fpl, struct unix_edge *edge)
 {
@@ -144,6 +145,7 @@ static void unix_add_edge(struct scm_fp_list *fpl, struct unix_edge *edge)
 	if (!vertex) {
 		vertex = list_first_entry(&fpl->vertices, typeof(*vertex), entry);
 		vertex->index = unix_vertex_unvisited_index;
+		vertex->scc_index = ++unix_vertex_max_scc_index;
 		vertex->out_degree = 0;
 		INIT_LIST_HEAD(&vertex->edges);
 		INIT_LIST_HEAD(&vertex->scc_entry);
@@ -480,10 +482,15 @@ static void __unix_walk_scc(struct unix_vertex *vertex, unsigned long *last_inde
 				scc_dead = unix_vertex_dead(v);
 		}
 
-		if (scc_dead)
+		if (scc_dead) {
 			unix_collect_skb(&scc, hitlist);
-		else if (!unix_graph_maybe_cyclic)
-			unix_graph_maybe_cyclic = unix_scc_cyclic(&scc);
+		} else {
+			if (unix_vertex_max_scc_index < vertex->scc_index)
+				unix_vertex_max_scc_index = vertex->scc_index;
+
+			if (!unix_graph_maybe_cyclic)
+				unix_graph_maybe_cyclic = unix_scc_cyclic(&scc);
+		}
 
 		list_del(&scc);
 	}
@@ -498,6 +505,7 @@ static void unix_walk_scc(struct sk_buff_head *hitlist)
 	unsigned long last_index = UNIX_VERTEX_INDEX_START;
 
 	unix_graph_maybe_cyclic = false;
+	unix_vertex_max_scc_index = UNIX_VERTEX_INDEX_START;
 
 	/* Visit every vertex exactly once.
 	 * __unix_walk_scc() moves visited vertices to unix_visited_vertices.
-- 
2.51.0



