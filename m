Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E63B6A342;
	Mon,  8 Apr 2024 13:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584204; cv=none; b=ETNGsNYVrsZPLiXWYPs+FkSH7W+w6PusYe5lILdIHT0Ty/aSLoelIQIyIWoN7YfjajRJRbBo0cG8jcXmLFQATRIuStkp9dEKpSeogW1BgRQcEBoxwb7W4IIp/+1Uk57lGT5VkZpAQ93qVkERBFxllBTyoEuvBzJa6oCROfeV+7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584204; c=relaxed/simple;
	bh=PBxzUWLfpQUaqRrmcC0i7CA2NudaZ9VsMaF+OuT98IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPoaGgpL5lIla1KfRwbloHFzD1U4rxAtDYNe5GGt4+xBgsm/VrLC0bp2Rx7APiycPjtdDLOcK8oppAxVCqdYGbE98vU/XNikZTDIvmcXP3dIMU0zOisz8zySfpTR4qXrSstMp/B477iok5z0YIOUgfRmQO/+29LQLD9IUOc4LQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWedhqjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWedhqjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63700C433C7;
	Mon,  8 Apr 2024 13:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584203;
	bh=PBxzUWLfpQUaqRrmcC0i7CA2NudaZ9VsMaF+OuT98IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWedhqjHLOfL28UyUZjgsqwWlu3o3AHa85M1Iie6hvhjRdCJnlyF5GuIfpxWc3dSC
	 Rd/FD0rpRaCQePK1TeX/id2rOEvqx1fH+OCqQa5RYrTSRDZKk5pf2sn2wW2zZRhxit
	 MQGtKwK6/+Xn+gm4yFXxsbC5rCAUGbEbSQnqJpFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank van der Linden <fllinden@amazon.com>,
	Wang Yugui <wangyugui@e16-tech.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 359/690] NFSD: Leave open files out of the filecache LRU
Date: Mon,  8 Apr 2024 14:53:45 +0200
Message-ID: <20240408125412.598387531@linuxfoundation.org>
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

[ Upstream commit 4a0e73e635e3f36b616ad5c943e3d23debe4632f ]

There have been reports of problems when running fstests generic/531
against Linux NFS servers with NFSv4. The NFS server that hosts the
test's SCRATCH_DEV suffers from CPU soft lock-ups during the test.
Analysis shows that:

fs/nfsd/filecache.c
 482                 ret = list_lru_walk(&nfsd_file_lru,
 483                                 nfsd_file_lru_cb,
 484                                 &head, LONG_MAX);

causes nfsd_file_gc() to walk the entire length of the filecache LRU
list every time it is called (which is quite frequently). The walk
holds a spinlock the entire time that prevents other nfsd threads
from accessing the filecache.

What's more, for NFSv4 workloads, none of the items that are visited
during this walk may be evicted, since they are all files that are
held OPEN by NFS clients.

Address this by ensuring that open files are not kept on the LRU
list.

Reported-by: Frank van der Linden <fllinden@amazon.com>
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=386
Suggested-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 24 +++++++++++++++++++-----
 fs/nfsd/trace.h     |  2 ++
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index a995a744a7481..5c9e3ff6397b0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -262,6 +262,7 @@ nfsd_file_flush(struct nfsd_file *nf)
 
 static void nfsd_file_lru_add(struct nfsd_file *nf)
 {
+	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
 	if (list_lru_add(&nfsd_file_lru, &nf->nf_lru))
 		trace_nfsd_file_lru_add(nf);
 }
@@ -291,7 +292,6 @@ nfsd_file_unhash(struct nfsd_file *nf)
 {
 	if (test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
 		nfsd_file_do_unhash(nf);
-		nfsd_file_lru_remove(nf);
 		return true;
 	}
 	return false;
@@ -312,6 +312,7 @@ nfsd_file_unhash_and_release_locked(struct nfsd_file *nf, struct list_head *disp
 	if (refcount_dec_not_one(&nf->nf_ref))
 		return true;
 
+	nfsd_file_lru_remove(nf);
 	list_add(&nf->nf_lru, dispose);
 	return true;
 }
@@ -323,6 +324,7 @@ nfsd_file_put_noref(struct nfsd_file *nf)
 
 	if (refcount_dec_and_test(&nf->nf_ref)) {
 		WARN_ON(test_bit(NFSD_FILE_HASHED, &nf->nf_flags));
+		nfsd_file_lru_remove(nf);
 		nfsd_file_free(nf);
 	}
 }
@@ -332,7 +334,7 @@ nfsd_file_put(struct nfsd_file *nf)
 {
 	might_sleep();
 
-	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
+	nfsd_file_lru_add(nf);
 	if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0) {
 		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
@@ -432,8 +434,18 @@ nfsd_file_dispose_list_delayed(struct list_head *dispose)
 	}
 }
 
-/*
+/**
+ * nfsd_file_lru_cb - Examine an entry on the LRU list
+ * @item: LRU entry to examine
+ * @lru: controlling LRU
+ * @lock: LRU list lock (unused)
+ * @arg: dispose list
+ *
  * Note this can deadlock with nfsd_file_cache_purge.
+ *
+ * Return values:
+ *   %LRU_REMOVED: @item was removed from the LRU
+ *   %LRU_SKIP: @item cannot be evicted
  */
 static enum lru_status
 nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
@@ -455,8 +467,9 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 	 * That order is deliberate to ensure that we can do this locklessly.
 	 */
 	if (refcount_read(&nf->nf_ref) > 1) {
+		list_lru_isolate(lru, &nf->nf_lru);
 		trace_nfsd_file_gc_in_use(nf);
-		return LRU_SKIP;
+		return LRU_REMOVED;
 	}
 
 	/*
@@ -1013,6 +1026,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto retry;
 	}
 
+	nfsd_file_lru_remove(nf);
 	this_cpu_inc(nfsd_file_cache_hits);
 
 	status = nfserrno(nfsd_open_break_lease(file_inode(nf->nf_file), may_flags));
@@ -1034,7 +1048,6 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	refcount_inc(&nf->nf_ref);
 	__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
 	__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
-	nfsd_file_lru_add(nf);
 	hlist_add_head_rcu(&nf->nf_node, &nfsd_file_hashtbl[hashval].nfb_head);
 	++nfsd_file_hashtbl[hashval].nfb_count;
 	nfsd_file_hashtbl[hashval].nfb_maxcount = max(nfsd_file_hashtbl[hashval].nfb_maxcount,
@@ -1059,6 +1072,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	 */
 	if (status != nfs_ok || inode->i_nlink == 0) {
 		bool do_free;
+		nfsd_file_lru_remove(nf);
 		spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
 		do_free = nfsd_file_unhash(nf);
 		spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index c47f46d433ddb..cc55a2b32e8cd 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -926,7 +926,9 @@ DEFINE_EVENT(nfsd_file_gc_class, name,					\
 	TP_ARGS(nf))
 
 DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_add);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_add_disposed);
 DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_del);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_del_disposed);
 DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_in_use);
 DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_writeback);
 DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_referenced);
-- 
2.43.0



