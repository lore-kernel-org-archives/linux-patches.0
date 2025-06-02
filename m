Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D112222CA;
	Mon,  2 Jun 2025 14:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874280; cv=none; b=FRPZEgv42Xe1cPNkGNB9ngwIMLHBGkSbjJQVmxevfXoodD+gd7J8700+nCdyqGglfr5LtA5EYEXiV0lHkbQtki87ILUEsut0lXmtXAay8R8NSGsuVNz13+i58Z2W/VxNJxay0sn/Cd1fVcfR9WMhujOt3ulSYbVeomYpfIosX98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874280; c=relaxed/simple;
	bh=INvF3psh6b0Q74LMvaI+nxlRDdlPett82R+NJjcnW+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AObHFEbFAVHwA6vOM50TgXMIPoqGs7AV31EaDcQMCHJslYaMW8MFkKPDNmR8PjQfMOM2YyRaok6sE5vK3Wm8DThkaDCtxcW59ESdpsMJQkDX2FLmQxbqRlfk4S7yOE8aw/GJ0UfjaAWxBzRrRKYtevwHyNdPbJCV4vGXQ0GtCgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/wz5vc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/wz5vc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483C5C4CEEB;
	Mon,  2 Jun 2025 14:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874280;
	bh=INvF3psh6b0Q74LMvaI+nxlRDdlPett82R+NJjcnW+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/wz5vc39gnlJb9R5/cSAytDV8udfudLsqg07Hai3ADRdkDCs7NVUM2hKqWvMPeWL
	 GPOPCkq23jSAxj/Uudt8XpjYy0PB/LTR771S4hwTyUvMw8VDqCJLFvdKck9WcLoffm
	 ya6/rkxIFWisNe7jaCWPex26c+kYduH7o1kbOdwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 418/444] af_unix: Add dead flag to struct scm_fp_list.
Date: Mon,  2 Jun 2025 15:48:02 +0200
Message-ID: <20250602134357.908089166@linuxfoundation.org>
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

commit 7172dc93d621d5dc302d007e95ddd1311ec64283 upstream.

Commit 1af2dface5d2 ("af_unix: Don't access successor in unix_del_edges()
during GC.") fixed use-after-free by avoid accessing edge->successor while
GC is in progress.

However, there could be a small race window where another process could
call unix_del_edges() while gc_in_progress is true and __skb_queue_purge()
is on the way.

So, we need another marker for struct scm_fp_list which indicates if the
skb is garbage-collected.

This patch adds dead flag in struct scm_fp_list and set it true before
calling __skb_queue_purge().

Fixes: 1af2dface5d2 ("af_unix: Don't access successor in unix_del_edges() during GC.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240508171150.50601-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/scm.h  |    1 +
 net/core/scm.c     |    1 +
 net/unix/garbage.c |   14 ++++++++++----
 3 files changed, 12 insertions(+), 4 deletions(-)

--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -32,6 +32,7 @@ struct scm_fp_list {
 	short			max;
 #ifdef CONFIG_UNIX
 	bool			inflight;
+	bool			dead;
 	struct list_head	vertices;
 	struct unix_edge	*edges;
 #endif
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -91,6 +91,7 @@ static int scm_fp_copy(struct cmsghdr *c
 		fpl->user = NULL;
 #if IS_ENABLED(CONFIG_UNIX)
 		fpl->inflight = false;
+		fpl->dead = false;
 		fpl->edges = NULL;
 		INIT_LIST_HEAD(&fpl->vertices);
 #endif
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -158,13 +158,11 @@ static void unix_add_edge(struct scm_fp_
 	unix_update_graph(unix_edge_successor(edge));
 }
 
-static bool gc_in_progress;
-
 static void unix_del_edge(struct scm_fp_list *fpl, struct unix_edge *edge)
 {
 	struct unix_vertex *vertex = edge->predecessor->vertex;
 
-	if (!gc_in_progress)
+	if (!fpl->dead)
 		unix_update_graph(unix_edge_successor(edge));
 
 	list_del(&edge->vertex_entry);
@@ -240,7 +238,7 @@ void unix_del_edges(struct scm_fp_list *
 		unix_del_edge(fpl, edge);
 	} while (i < fpl->count_unix);
 
-	if (!gc_in_progress) {
+	if (!fpl->dead) {
 		receiver = fpl->edges[0].successor;
 		receiver->scm_stat.nr_unix_fds -= fpl->count_unix;
 	}
@@ -559,9 +557,12 @@ static void unix_walk_scc_fast(struct sk
 	list_replace_init(&unix_visited_vertices, &unix_unvisited_vertices);
 }
 
+static bool gc_in_progress;
+
 static void __unix_gc(struct work_struct *work)
 {
 	struct sk_buff_head hitlist;
+	struct sk_buff *skb;
 
 	spin_lock(&unix_gc_lock);
 
@@ -579,6 +580,11 @@ static void __unix_gc(struct work_struct
 
 	spin_unlock(&unix_gc_lock);
 
+	skb_queue_walk(&hitlist, skb) {
+		if (UNIXCB(skb).fp)
+			UNIXCB(skb).fp->dead = true;
+	}
+
 	__skb_queue_purge(&hitlist);
 skip_gc:
 	WRITE_ONCE(gc_in_progress, false);


