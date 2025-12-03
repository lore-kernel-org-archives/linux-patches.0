Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DF035BDBF;
	Wed,  3 Dec 2025 16:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780175; cv=none; b=NR7fhxXfdrva3EuvS6SxmDGwEVnKLlUoZCWyWCVKysVRt8pVE/9QncXX4jWyYaplt/qNNGbebMkEAM0UZGuy9igUQdEYMtNKUQQ+QwCW23dvrbwsUV8nD8fK/I+JBJooi3K2dd7qNaMy/EDrr9IfQtHn+OA5nuA5R2iuWakeATo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780175; c=relaxed/simple;
	bh=woYfBkg+20k7izFpJpzhuDDeNIobMLWLOSbVKIXE8wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZq9fMmfR8c+syCzF6yM3WIQMjSpDITTwAhT+IufU7aVznKj+XmSAwFfdtdunZ5GTh3XvQnUeZXhx+e5T0O1Nk6gGqixw8GKQYL7xTWWAHB+wS3WJsj2Wo6rgSLSFBjcyj2JwZst3CYJhNSrEooAipdrPr5Z25s3XyJRe+fkaZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGaxnKk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGaxnKk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB213C4CEF5;
	Wed,  3 Dec 2025 16:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780175;
	bh=woYfBkg+20k7izFpJpzhuDDeNIobMLWLOSbVKIXE8wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGaxnKk9UDt3bdqbiVm1M2Rnu0Zp4TJvNjdAeRetvirNEcor7nVJsC7mhUEfH+AWI
	 ow+DnVZ8nxHzrdepOsRDcX+zTXrybP26B4uwFCDOE4OIrKOxI6qJBwndWEj/hF4l+d
	 nhF+ZcoXcSuqnzlyIOkRBOo9/6KDjuHOOVkeWaic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 478/568] maple_tree: fix tracepoint string pointers
Date: Wed,  3 Dec 2025 16:28:00 +0100
Message-ID: <20251203152458.204986976@linuxfoundation.org>
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

From: Martin Kaiser <martin@kaiser.cx>

commit 91a54090026f84ceffaa12ac53c99b9f162946f6 upstream.

maple_tree tracepoints contain pointers to function names. Such a pointer
is saved when a tracepoint logs an event. There's no guarantee that it's
still valid when the event is parsed later and the pointer is dereferenced.

The kernel warns about these unsafe pointers.

	event 'ma_read' has unsafe pointer field 'fn'
	WARNING: kernel/trace/trace.c:3779 at ignore_event+0x1da/0x1e4

Mark the function names as tracepoint_string() to fix the events.

One case that doesn't work without my patch would be trace-cmd record
to save the binary ringbuffer and trace-cmd report to parse it in
userspace.  The address of __func__ can't be dereferenced from
userspace but tracepoint_string will add an entry to
/sys/kernel/tracing/printk_formats

Link: https://lkml.kernel.org/r/20251030155537.87972-1-martin@kaiser.cx
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -62,6 +62,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/maple_tree.h>
 
+#define TP_FCT tracepoint_string(__func__)
+
 #define MA_ROOT_PARENT 1
 
 /*
@@ -3165,7 +3167,7 @@ static inline int mas_rebalance(struct m
 	MA_STATE(l_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 
 	/*
 	 * Rebalancing occurs if a node is insufficient.  Data is rebalanced
@@ -3542,7 +3544,7 @@ static int mas_split(struct ma_state *ma
 	MA_STATE(prev_r_mas, mas->tree, mas->index, mas->last);
 	MA_TOPIARY(mat, mas->tree);
 
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 	mas->depth = mas_mt_height(mas);
 	/* Allocation failures will happen early. */
 	mas_node_count(mas, 1 + mas->depth * 2);
@@ -3786,7 +3788,7 @@ static bool mas_is_span_wr(struct ma_wr_
 			return false;
 	}
 
-	trace_ma_write(__func__, wr_mas->mas, piv, entry);
+	trace_ma_write(TP_FCT, wr_mas->mas, piv, entry);
 
 	return true;
 }
@@ -4035,7 +4037,7 @@ static inline int mas_wr_spanning_store(
 	 * of data may happen.
 	 */
 	mas = wr_mas->mas;
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 
 	if (unlikely(!mas->index && mas->last == ULONG_MAX))
 		return mas_new_root(mas, wr_mas->entry);
@@ -4221,7 +4223,7 @@ done:
 	} else {
 		memcpy(wr_mas->node, newnode, sizeof(struct maple_node));
 	}
-	trace_ma_write(__func__, mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
 	return true;
 }
@@ -4276,7 +4278,7 @@ static inline bool mas_wr_slot_store(str
 	mas->offset++; /* Keep mas accurate. */
 
 done:
-	trace_ma_write(__func__, mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
 	return true;
 }
@@ -4377,7 +4379,7 @@ static void mas_wr_bnode(struct ma_wr_st
 {
 	struct maple_big_node b_node;
 
-	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
 	mas_commit_b_node(wr_mas, &b_node, wr_mas->node_end);
@@ -5722,7 +5724,7 @@ void *mas_store(struct ma_state *mas, vo
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
-	trace_ma_write(__func__, mas, 0, entry);
+	trace_ma_write(TP_FCT, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 	if (mas->index > mas->last)
 		pr_err("Error %lu > %lu %p\n", mas->index, mas->last, entry);
@@ -5760,7 +5762,7 @@ int mas_store_gfp(struct ma_state *mas,
 	MA_WR_STATE(wr_mas, mas, entry);
 
 	mas_wr_store_setup(&wr_mas);
-	trace_ma_write(__func__, mas, 0, entry);
+	trace_ma_write(TP_FCT, mas, 0, entry);
 retry:
 	mas_wr_store_entry(&wr_mas);
 	if (unlikely(mas_nomem(mas, gfp)))
@@ -5784,7 +5786,7 @@ void mas_store_prealloc(struct ma_state
 	MA_WR_STATE(wr_mas, mas, entry);
 
 	mas_wr_store_setup(&wr_mas);
-	trace_ma_write(__func__, mas, 0, entry);
+	trace_ma_write(TP_FCT, mas, 0, entry);
 	mas_wr_store_entry(&wr_mas);
 	BUG_ON(mas_is_err(mas));
 	mas_destroy(mas);
@@ -6249,7 +6251,7 @@ void *mtree_load(struct maple_tree *mt,
 	MA_STATE(mas, mt, index, index);
 	void *entry;
 
-	trace_ma_read(__func__, &mas);
+	trace_ma_read(TP_FCT, &mas);
 	rcu_read_lock();
 retry:
 	entry = mas_start(&mas);
@@ -6292,7 +6294,7 @@ int mtree_store_range(struct maple_tree
 	MA_STATE(mas, mt, index, last);
 	MA_WR_STATE(wr_mas, &mas, entry);
 
-	trace_ma_write(__func__, &mas, 0, entry);
+	trace_ma_write(TP_FCT, &mas, 0, entry);
 	if (WARN_ON_ONCE(xa_is_advanced(entry)))
 		return -EINVAL;
 
@@ -6467,7 +6469,7 @@ void *mtree_erase(struct maple_tree *mt,
 	void *entry = NULL;
 
 	MA_STATE(mas, mt, index, index);
-	trace_ma_op(__func__, &mas);
+	trace_ma_op(TP_FCT, &mas);
 
 	mtree_lock(mt);
 	entry = mas_erase(&mas);
@@ -6527,7 +6529,7 @@ void *mt_find(struct maple_tree *mt, uns
 	unsigned long copy = *index;
 #endif
 
-	trace_ma_read(__func__, &mas);
+	trace_ma_read(TP_FCT, &mas);
 
 	if ((*index) > max)
 		return NULL;


