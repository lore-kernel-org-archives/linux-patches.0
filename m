Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BA9228CB7;
	Mon,  2 Jun 2025 15:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877495; cv=none; b=U9OpicJlHxNxUl76OkzwEGe0aWaCsBAqRkM5IsqUWnVCGZ7ekudtxHIIS80l8ZerbE8N0JGp8BRtonJ4xj/q8A1rRMfbpKv795EVTjjaa64hNTQUNoxTO5z641MDzuetyKrm9IiyG1SePIH11yTF/SAABP9CEDcf0GVLU3JKlw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877495; c=relaxed/simple;
	bh=GfgeLsJ/Y86GduPHRb8gjDC+vqwVC8M6LWnxue8k3YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9cFRX9kZyrjyzosZAMvJPyW+EsWASr2aPt8LSY70AeLOX2JVghed+HzIlBo6/Zr08H0YeZhjEApM5ZtGGeskZCG4UclBA6XDFng2+thWuXbMJS08brLJhPidcXezrgYul+KWzE0Bs1u5uZgGWGKmk8N3zYWlv7GvpaJLUH/Qxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iwQxcZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iwQxcZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21322C4CEEB;
	Mon,  2 Jun 2025 15:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877495;
	bh=GfgeLsJ/Y86GduPHRb8gjDC+vqwVC8M6LWnxue8k3YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0iwQxcZ6GO2eyb8yx20jj1XeN22nYRS/Th0aPPS8atfjymoukKel6djL1PkAQFE52
	 c+kHu+H3SWdBMCGV58lraW9M91t4vFRQpOzqowLD67pBvXFApR4+htDc1iGrAPiH+n
	 k/QSPCwULH/1G7KIOHi+hp7Siap4KMfo2QFeX+l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 295/325] af_unix: Fix up unix_edge.successor for embryo socket.
Date: Mon,  2 Jun 2025 15:49:31 +0200
Message-ID: <20250602134331.889501109@linuxfoundation.org>
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

commit dcf70df2048d27c5d186f013f101a4aefd63aa41 upstream.

To garbage collect inflight AF_UNIX sockets, we must define the
cyclic reference appropriately.  This is a bit tricky if the loop
consists of embryo sockets.

Suppose that the fd of AF_UNIX socket A is passed to D and the fd B
to C and that C and D are embryo sockets of A and B, respectively.
It may appear that there are two separate graphs, A (-> D) and
B (-> C), but this is not correct.

     A --. .-- B
          X
     C <-' `-> D

Now, D holds A's refcount, and C has B's refcount, so unix_release()
will never be called for A and B when we close() them.  However, no
one can call close() for D and C to free skbs holding refcounts of A
and B because C/D is in A/B's receive queue, which should have been
purged by unix_release() for A and B.

So, here's another type of cyclic reference.  When a fd of an AF_UNIX
socket is passed to an embryo socket, the reference is indirectly held
by its parent listening socket.

  .-> A                            .-> B
  |   `- sk_receive_queue          |   `- sk_receive_queue
  |      `- skb                    |      `- skb
  |         `- sk == C             |         `- sk == D
  |            `- sk_receive_queue |           `- sk_receive_queue
  |               `- skb +---------'               `- skb +-.
  |                                                         |
  `---------------------------------------------------------'

Technically, the graph must be denoted as A <-> B instead of A (-> D)
and B (-> C) to find such a cyclic reference without touching each
socket's receive queue.

  .-> A --. .-- B <-.
  |        X        |  ==  A <-> B
  `-- C <-' `-> D --'

We apply this fixup during GC by fetching the real successor by
unix_edge_successor().

When we call accept(), we clear unix_sock.listener under unix_gc_lock
not to confuse GC.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240325202425.60930-9-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    1 +
 net/unix/af_unix.c    |    2 +-
 net/unix/garbage.c    |   20 +++++++++++++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -24,6 +24,7 @@ void unix_inflight(struct user_struct *u
 void unix_notinflight(struct user_struct *user, struct file *fp);
 void unix_add_edges(struct scm_fp_list *fpl, struct unix_sock *receiver);
 void unix_del_edges(struct scm_fp_list *fpl);
+void unix_update_edges(struct unix_sock *receiver);
 int unix_prepare_fpl(struct scm_fp_list *fpl);
 void unix_destroy_fpl(struct scm_fp_list *fpl);
 void unix_gc(void);
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1679,7 +1679,7 @@ static int unix_accept(struct socket *so
 	}
 
 	tsk = skb->sk;
-	unix_sk(tsk)->listener = NULL;
+	unix_update_edges(unix_sk(tsk));
 	skb_free_datagram(sk, skb);
 	wake_up_interruptible(&unix_sk(sk)->peer_wait);
 
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -101,6 +101,17 @@ struct unix_sock *unix_get_socket(struct
 	return NULL;
 }
 
+static struct unix_vertex *unix_edge_successor(struct unix_edge *edge)
+{
+	/* If an embryo socket has a fd,
+	 * the listener indirectly holds the fd's refcnt.
+	 */
+	if (edge->successor->listener)
+		return unix_sk(edge->successor->listener)->vertex;
+
+	return edge->successor->vertex;
+}
+
 static LIST_HEAD(unix_unvisited_vertices);
 
 enum unix_vertex_index {
@@ -209,6 +220,13 @@ out:
 	fpl->inflight = false;
 }
 
+void unix_update_edges(struct unix_sock *receiver)
+{
+	spin_lock(&unix_gc_lock);
+	receiver->listener = NULL;
+	spin_unlock(&unix_gc_lock);
+}
+
 int unix_prepare_fpl(struct scm_fp_list *fpl)
 {
 	struct unix_vertex *vertex;
@@ -268,7 +286,7 @@ next_vertex:
 
 	/* Explore neighbour vertices (receivers of the current vertex's fd). */
 	list_for_each_entry(edge, &vertex->edges, vertex_entry) {
-		struct unix_vertex *next_vertex = edge->successor->vertex;
+		struct unix_vertex *next_vertex = unix_edge_successor(edge);
 
 		if (!next_vertex)
 			continue;


