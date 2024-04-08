Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00FB7B3EB;
	Mon,  8 Apr 2024 13:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584200; cv=none; b=d5NVjUwl4sAKmp3xSyP0AjltG6xy5Fka38/zZ5thOMJlT+vSbHhn4HG2wxhZdWl8mZ9O2RXvnYN05yxb93Fo5VTiY7YvDATKuw8GeHYWhTjbhrxfKzPfFeOdDwoZs4km6/K7j3O1RZTAYug1GnK7dKxoB4N6yAgS2mYkLVLYpBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584200; c=relaxed/simple;
	bh=q7E3B4qCgmD0MxbxmcXCKPj0B2WKloOsAMtKNSThj1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eF52RoWMTSD4kst8rOx9K/IXbY2VTGZFbtDUZsSJ4hy/psq1xN9g7Jscze3XSavjlqHaHGL4IIr/de/QVXHX1FFVRuKZNvhkAyD9rpMTRaJW17juCkAQzXdCbUxtJgh3il4GsEWwrEbj3EoSZKHYXXUu7UHK9jAYj0dPTW+wrw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGNpIS1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGNpIS1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595D2C433F1;
	Mon,  8 Apr 2024 13:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584200;
	bh=q7E3B4qCgmD0MxbxmcXCKPj0B2WKloOsAMtKNSThj1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGNpIS1uww+KBSjrhjfYNC7Dx8nfrFfGV0SmqhoP3DdQRsyJ5MRoWEI0H5KfKuvUB
	 Jao4dtop52nJhsWScHcWA5YT9i/EjIN57S13Vuh4zJUPXFOiMabevYTWVFoTakbYCC
	 Jh671wTcFOqjLpJOulzE6ab/9vaLgjyg4SAzgaJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 358/690] NFSD: Trace filecache LRU activity
Date: Mon,  8 Apr 2024 14:53:44 +0200
Message-ID: <20240408125412.566793498@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c46203acddd9b9200dbc53d0603c97355fd3a03b ]

Observe the operation of garbage collection and the lifetime of
filecache items.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 44 +++++++++++++++++++++++++++++++-------------
 fs/nfsd/trace.h     | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index d9b5f1e183976..a995a744a7481 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -260,6 +260,18 @@ nfsd_file_flush(struct nfsd_file *nf)
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
 }
 
+static void nfsd_file_lru_add(struct nfsd_file *nf)
+{
+	if (list_lru_add(&nfsd_file_lru, &nf->nf_lru))
+		trace_nfsd_file_lru_add(nf);
+}
+
+static void nfsd_file_lru_remove(struct nfsd_file *nf)
+{
+	if (list_lru_del(&nfsd_file_lru, &nf->nf_lru))
+		trace_nfsd_file_lru_del(nf);
+}
+
 static void
 nfsd_file_do_unhash(struct nfsd_file *nf)
 {
@@ -279,8 +291,7 @@ nfsd_file_unhash(struct nfsd_file *nf)
 {
 	if (test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
 		nfsd_file_do_unhash(nf);
-		if (!list_empty(&nf->nf_lru))
-			list_lru_del(&nfsd_file_lru, &nf->nf_lru);
+		nfsd_file_lru_remove(nf);
 		return true;
 	}
 	return false;
@@ -443,27 +454,34 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 	 * counter. Here we check the counter and then test and clear the flag.
 	 * That order is deliberate to ensure that we can do this locklessly.
 	 */
-	if (refcount_read(&nf->nf_ref) > 1)
-		goto out_skip;
+	if (refcount_read(&nf->nf_ref) > 1) {
+		trace_nfsd_file_gc_in_use(nf);
+		return LRU_SKIP;
+	}
 
 	/*
 	 * Don't throw out files that are still undergoing I/O or
 	 * that have uncleared errors pending.
 	 */
-	if (nfsd_file_check_writeback(nf))
-		goto out_skip;
+	if (nfsd_file_check_writeback(nf)) {
+		trace_nfsd_file_gc_writeback(nf);
+		return LRU_SKIP;
+	}
 
-	if (test_and_clear_bit(NFSD_FILE_REFERENCED, &nf->nf_flags))
-		goto out_skip;
+	if (test_and_clear_bit(NFSD_FILE_REFERENCED, &nf->nf_flags)) {
+		trace_nfsd_file_gc_referenced(nf);
+		return LRU_SKIP;
+	}
 
-	if (!test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags))
-		goto out_skip;
+	if (!test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
+		trace_nfsd_file_gc_hashed(nf);
+		return LRU_SKIP;
+	}
 
 	list_lru_isolate_move(lru, &nf->nf_lru, head);
 	this_cpu_inc(nfsd_file_evictions);
+	trace_nfsd_file_gc_disposed(nf);
 	return LRU_REMOVED;
-out_skip:
-	return LRU_SKIP;
 }
 
 /*
@@ -1016,7 +1034,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	refcount_inc(&nf->nf_ref);
 	__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
 	__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
-	list_lru_add(&nfsd_file_lru, &nf->nf_lru);
+	nfsd_file_lru_add(nf);
 	hlist_add_head_rcu(&nf->nf_node, &nfsd_file_hashtbl[hashval].nfb_head);
 	++nfsd_file_hashtbl[hashval].nfb_count;
 	nfsd_file_hashtbl[hashval].nfb_maxcount = max(nfsd_file_hashtbl[hashval].nfb_maxcount,
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 71919f7a31dc8..c47f46d433ddb 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -894,6 +894,45 @@ TRACE_EVENT(nfsd_file_fsnotify_handle_event,
 			__entry->nlink, __entry->mode, __entry->mask)
 );
 
+DECLARE_EVENT_CLASS(nfsd_file_gc_class,
+	TP_PROTO(
+		const struct nfsd_file *nf
+	),
+	TP_ARGS(nf),
+	TP_STRUCT__entry(
+		__field(void *, nf_inode)
+		__field(void *, nf_file)
+		__field(int, nf_ref)
+		__field(unsigned long, nf_flags)
+	),
+	TP_fast_assign(
+		__entry->nf_inode = nf->nf_inode;
+		__entry->nf_file = nf->nf_file;
+		__entry->nf_ref = refcount_read(&nf->nf_ref);
+		__entry->nf_flags = nf->nf_flags;
+	),
+	TP_printk("inode=%p ref=%d nf_flags=%s nf_file=%p",
+		__entry->nf_inode, __entry->nf_ref,
+		show_nf_flags(__entry->nf_flags),
+		__entry->nf_file
+	)
+);
+
+#define DEFINE_NFSD_FILE_GC_EVENT(name)					\
+DEFINE_EVENT(nfsd_file_gc_class, name,					\
+	TP_PROTO(							\
+		const struct nfsd_file *nf				\
+	),								\
+	TP_ARGS(nf))
+
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_add);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_del);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_in_use);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_writeback);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_referenced);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_hashed);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_disposed);
+
 DECLARE_EVENT_CLASS(nfsd_file_lruwalk_class,
 	TP_PROTO(
 		unsigned long removed,
-- 
2.43.0



