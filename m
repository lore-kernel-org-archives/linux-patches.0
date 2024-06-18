Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F661A0739;
	Tue, 18 Jun 2024 13:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716204; cv=none; b=KBQ7DeFSQAXjPSfW82XMKBjAtqqP0EnFlt6ps9ICpwoEKbmfQ/JvSHAIGpiw3C2azQO9ZtHqUsf66eyProOxW3caYTLBAB2+3fgPQ2m45R7DKZyeWf4QUxDOPajvHZhCJZk6sLeT7IA0+kgnqXykypSO0ARq4/FxpBKxFO9pxK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716204; c=relaxed/simple;
	bh=/Og/HnyRZ3T8OnlBEatz2lrdQw4rGnBcKCBvot6eCrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEfdYoqF41YsdRxLCttcp5qHnI+V8VTka9byCalH6oxLtgI19ZKWXnC/pum5/Tk7OMWrhRPG8ZKALFK+qrLRaeg4s4waY6s7+Eomwz8GLxzwmfaR1hTvmk/whpktyfskhzb1hDYwGqiozzAzhyzkPDyoeVWBW2vc0KzPYxxVs6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09qZPMH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09qZPMH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A165DC3277B;
	Tue, 18 Jun 2024 13:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716204;
	bh=/Og/HnyRZ3T8OnlBEatz2lrdQw4rGnBcKCBvot6eCrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09qZPMH9iSre/g93XdgDQlRTwyqesaDfT3D1+wKk2lzOjfkpfzsD5OPg1TZ+ES0z5
	 yXi07+pF+4t7RhYnKJBtM+m8dwAc1CLSMNEaKQy1+x9b2hCzCpr2ck0WxjCwydGwh5
	 tjoyQaLRQ5OSuaNByeD2uSLVTWcgR2baBkMJohkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 567/770] NFSD: Trace filecache LRU activity
Date: Tue, 18 Jun 2024 14:37:00 +0200
Message-ID: <20240618123429.187079008@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c46203acddd9b9200dbc53d0603c97355fd3a03b ]

Observe the operation of garbage collection and the lifetime of
filecache items.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index b373a161e862b..b1aa28c062ac5 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -860,6 +860,45 @@ TRACE_EVENT(nfsd_file_fsnotify_handle_event,
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



