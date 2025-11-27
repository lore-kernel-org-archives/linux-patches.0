Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B440D296BBC;
	Thu, 27 Nov 2025 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255476; cv=none; b=lHon/UYFICk5XEtvflB8+z6oluSXcYgndqX6crDC+k1GBV5Wg6fjhJOMgEEFPAc2odwFM9mqaBoLu3VoxEFpO8hfntd787/rOgPykuOvwrsKsfaA642WG2DXucM0JAdLhRORKqGzWQArtZoPioQOaB6qwB9xWWHja/zok2xrx5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255476; c=relaxed/simple;
	bh=/8dLBvv3P3bH5nedUBud4SpcDBlBBV5L5ncuhY7nvKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9EBWEYGsJVlCOZP71gwlPn8i/bqCGROs14FSkv+t1U3FX359M9hsYj95+Uz44w1CcGb9TyaRiDO+9qEYFJSHt+n+ZKgho06kpNanYu+8iKCzZMbuBtcWKlWlpD5uMFsbHJfqQoJ0GX4zfyRt18qTTMZHazm4dHAYWUFue4Xj8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSM4TR6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSM4TR6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3941BC4CEF8;
	Thu, 27 Nov 2025 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255476;
	bh=/8dLBvv3P3bH5nedUBud4SpcDBlBBV5L5ncuhY7nvKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSM4TR6NaNi7niJPCw+OOKFuLfhCLDw5j7Os+/ryeflJ7WPXyyeKmhWYbBQabOMs0
	 dzX4tgEvZamNrykxWWdYkdxcoQTvxj8ECy7KGflOkPINEpyEhSdBzgIBf56IXBHaVJ
	 WSMg9lCA1FI6iIs7DWn61kf0+XABBzY9pogrLT9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 104/112] maple_tree: fix tracepoint string pointers
Date: Thu, 27 Nov 2025 15:46:46 +0100
Message-ID: <20251127144036.649131399@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -64,6 +64,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/maple_tree.h>
 
+#define TP_FCT tracepoint_string(__func__)
+
 #define MA_ROOT_PARENT 1
 
 /*
@@ -2949,7 +2951,7 @@ static inline void mas_rebalance(struct
 	MA_STATE(l_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 
 	/*
 	 * Rebalancing occurs if a node is insufficient.  Data is rebalanced
@@ -3314,7 +3316,7 @@ static void mas_split(struct ma_state *m
 	MA_STATE(prev_l_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(prev_r_mas, mas->tree, mas->index, mas->last);
 
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 	mas->depth = mas_mt_height(mas);
 
 	mast.l = &l_mas;
@@ -3487,7 +3489,7 @@ static bool mas_is_span_wr(struct ma_wr_
 			return false;
 	}
 
-	trace_ma_write(__func__, wr_mas->mas, wr_mas->r_max, entry);
+	trace_ma_write(TP_FCT, wr_mas->mas, wr_mas->r_max, entry);
 	return true;
 }
 
@@ -3721,7 +3723,7 @@ static noinline void mas_wr_spanning_sto
 	 * of data may happen.
 	 */
 	mas = wr_mas->mas;
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 
 	if (unlikely(!mas->index && mas->last == ULONG_MAX))
 		return mas_new_root(mas, wr_mas->entry);
@@ -3858,7 +3860,7 @@ done:
 	} else {
 		memcpy(wr_mas->node, newnode, sizeof(struct maple_node));
 	}
-	trace_ma_write(__func__, mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
 	mas->end = new_end;
 	return;
@@ -3903,7 +3905,7 @@ static inline void mas_wr_slot_store(str
 		return;
 	}
 
-	trace_ma_write(__func__, mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	/*
 	 * Only update gap when the new entry is empty or there is an empty
 	 * entry in the original two ranges.
@@ -4024,7 +4026,7 @@ static inline void mas_wr_append(struct
 		mas_update_gap(mas);
 
 	mas->end = new_end;
-	trace_ma_write(__func__, mas, new_end, wr_mas->entry);
+	trace_ma_write(TP_FCT, mas, new_end, wr_mas->entry);
 	return;
 }
 
@@ -4038,7 +4040,7 @@ static void mas_wr_bnode(struct ma_wr_st
 {
 	struct maple_big_node b_node;
 
-	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
 	mas_commit_b_node(wr_mas, &b_node);
@@ -5418,7 +5420,7 @@ void *mas_store(struct ma_state *mas, vo
 	int request;
 	MA_WR_STATE(wr_mas, mas, entry);
 
-	trace_ma_write(__func__, mas, 0, entry);
+	trace_ma_write(TP_FCT, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 	if (MAS_WARN_ON(mas, mas->index > mas->last))
 		pr_err("Error %lX > %lX %p\n", mas->index, mas->last, entry);
@@ -5518,7 +5520,7 @@ void mas_store_prealloc(struct ma_state
 	}
 
 store:
-	trace_ma_write(__func__, mas, 0, entry);
+	trace_ma_write(TP_FCT, mas, 0, entry);
 	mas_wr_store_entry(&wr_mas);
 	MAS_WR_BUG_ON(&wr_mas, mas_is_err(mas));
 	mas_destroy(mas);
@@ -6320,7 +6322,7 @@ void *mtree_load(struct maple_tree *mt,
 	MA_STATE(mas, mt, index, index);
 	void *entry;
 
-	trace_ma_read(__func__, &mas);
+	trace_ma_read(TP_FCT, &mas);
 	rcu_read_lock();
 retry:
 	entry = mas_start(&mas);
@@ -6363,7 +6365,7 @@ int mtree_store_range(struct maple_tree
 	MA_STATE(mas, mt, index, last);
 	int ret = 0;
 
-	trace_ma_write(__func__, &mas, 0, entry);
+	trace_ma_write(TP_FCT, &mas, 0, entry);
 	if (WARN_ON_ONCE(xa_is_advanced(entry)))
 		return -EINVAL;
 
@@ -6586,7 +6588,7 @@ void *mtree_erase(struct maple_tree *mt,
 	void *entry = NULL;
 
 	MA_STATE(mas, mt, index, index);
-	trace_ma_op(__func__, &mas);
+	trace_ma_op(TP_FCT, &mas);
 
 	mtree_lock(mt);
 	entry = mas_erase(&mas);
@@ -6924,7 +6926,7 @@ void *mt_find(struct maple_tree *mt, uns
 	unsigned long copy = *index;
 #endif
 
-	trace_ma_read(__func__, &mas);
+	trace_ma_read(TP_FCT, &mas);
 
 	if ((*index) > max)
 		return NULL;


