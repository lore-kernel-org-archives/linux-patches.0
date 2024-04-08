Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AC66A342;
	Mon,  8 Apr 2024 13:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584224; cv=none; b=K0/QK/KdG2cCGBruyiudVCy/i8pkCnO/dijoVB/3wVm5CVfhxe5/NRI/5LWmBEgfSl8yaRz3RkGFZVIy2SkCdm5EPmcLOLdCUDQz1qKDDD21WERmEiC9sl0CoWYZARqCITqkGJEdac3xfOlBuAjHkK7f479hSTTAdZlRyq6Zgg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584224; c=relaxed/simple;
	bh=NSttzSRLwMiUagQ6P1dxt9KXKl6OxuEmepetfEuSquc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koLxrXXV5NA/HWLbc2yrvFA0xKd4L4uB9u1jmLObwPNmpyhMZxPDHyn9zDj/qjoMJK43MXfRQ7ndyWkU2Ezt1AqoxCVwhuDuDoqQVabue143mjGQS3u1xe6bGkWOaVAGo8R0c/gvgyF/5wpwGGCD9RdPne+NhsyRgn0rqonjXzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ympkulr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ympkulr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CDDC433F1;
	Mon,  8 Apr 2024 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584224;
	bh=NSttzSRLwMiUagQ6P1dxt9KXKl6OxuEmepetfEuSquc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ympkulr/vMrAYZvKXEsHL0JDiPQUKA4pyVALvRLCJHVN826pBAwcWWim/yl0J82x5
	 Pay5IQ1pg0B5qQesPmnlFN865k0z4e6zrLgmnCwgAM2gleZT/nVfdu0WizFs6fLbKk
	 oKjVkwzwH3xoOTDA+Zf3p7aB50LtFrv+WSOOt51w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 365/690] NFSD: Refactor __nfsd_file_close_inode()
Date: Mon,  8 Apr 2024 14:53:51 +0200
Message-ID: <20240408125412.795022511@linuxfoundation.org>
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

[ Upstream commit a845511007a63467fee575353c706806c21218b1 ]

The code that computes the hashval is the same in both callers.

To prevent them from going stale, reframe the documenting comments
to remove descriptions of the underlying hash table structure, which
is about to be replaced.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 40 +++++++++++++++++++++-------------------
 fs/nfsd/trace.h     | 44 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 54 insertions(+), 30 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index d7c74b51eabf3..3925df9124c39 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -558,39 +558,44 @@ static struct shrinker	nfsd_file_shrinker = {
 	.seeks = 1,
 };
 
-static void
-__nfsd_file_close_inode(struct inode *inode, unsigned int hashval,
-			struct list_head *dispose)
+/*
+ * Find all cache items across all net namespaces that match @inode and
+ * move them to @dispose. The lookup is atomic wrt nfsd_file_acquire().
+ */
+static unsigned int
+__nfsd_file_close_inode(struct inode *inode, struct list_head *dispose)
 {
+	unsigned int		hashval = (unsigned int)hash_long(inode->i_ino,
+						NFSD_FILE_HASH_BITS);
+	unsigned int		count = 0;
 	struct nfsd_file	*nf;
 	struct hlist_node	*tmp;
 
 	spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
 	hlist_for_each_entry_safe(nf, tmp, &nfsd_file_hashtbl[hashval].nfb_head, nf_node) {
-		if (inode == nf->nf_inode)
+		if (inode == nf->nf_inode) {
 			nfsd_file_unhash_and_release_locked(nf, dispose);
+			count++;
+		}
 	}
 	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
+	return count;
 }
 
 /**
  * nfsd_file_close_inode_sync - attempt to forcibly close a nfsd_file
  * @inode: inode of the file to attempt to remove
  *
- * Walk the whole hash bucket, looking for any files that correspond to "inode".
- * If any do, then unhash them and put the hashtable reference to them and
- * destroy any that had their last reference put. Also ensure that any of the
- * fputs also have their final __fput done as well.
+ * Unhash and put, then flush and fput all cache items associated with @inode.
  */
 void
 nfsd_file_close_inode_sync(struct inode *inode)
 {
-	unsigned int		hashval = (unsigned int)hash_long(inode->i_ino,
-						NFSD_FILE_HASH_BITS);
 	LIST_HEAD(dispose);
+	unsigned int count;
 
-	__nfsd_file_close_inode(inode, hashval, &dispose);
-	trace_nfsd_file_close_inode_sync(inode, !list_empty(&dispose));
+	count = __nfsd_file_close_inode(inode, &dispose);
+	trace_nfsd_file_close_inode_sync(inode, count);
 	nfsd_file_dispose_list_sync(&dispose);
 }
 
@@ -598,19 +603,16 @@ nfsd_file_close_inode_sync(struct inode *inode)
  * nfsd_file_close_inode - attempt a delayed close of a nfsd_file
  * @inode: inode of the file to attempt to remove
  *
- * Walk the whole hash bucket, looking for any files that correspond to "inode".
- * If any do, then unhash them and put the hashtable reference to them and
- * destroy any that had their last reference put.
+ * Unhash and put all cache item associated with @inode.
  */
 static void
 nfsd_file_close_inode(struct inode *inode)
 {
-	unsigned int		hashval = (unsigned int)hash_long(inode->i_ino,
-						NFSD_FILE_HASH_BITS);
 	LIST_HEAD(dispose);
+	unsigned int count;
 
-	__nfsd_file_close_inode(inode, hashval, &dispose);
-	trace_nfsd_file_close_inode(inode, !list_empty(&dispose));
+	count = __nfsd_file_close_inode(inode, &dispose);
+	trace_nfsd_file_close_inode(inode, count);
 	nfsd_file_dispose_list_delayed(&dispose);
 }
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 655b56c87600b..e82ea1abfbd46 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -847,30 +847,52 @@ TRACE_EVENT(nfsd_file_open,
 
 DECLARE_EVENT_CLASS(nfsd_file_search_class,
 	TP_PROTO(
-		struct inode *inode,
-		int found
+		const struct inode *inode,
+		unsigned int count
 	),
-	TP_ARGS(inode, found),
+	TP_ARGS(inode, count),
 	TP_STRUCT__entry(
-		__field(struct inode *, inode)
-		__field(int, found)
+		__field(const struct inode *, inode)
+		__field(unsigned int, count)
 	),
 	TP_fast_assign(
 		__entry->inode = inode;
-		__entry->found = found;
+		__entry->count = count;
 	),
-	TP_printk("inode=%p found=%d",
-		__entry->inode, __entry->found)
+	TP_printk("inode=%p count=%u",
+		__entry->inode, __entry->count)
 );
 
 #define DEFINE_NFSD_FILE_SEARCH_EVENT(name)				\
 DEFINE_EVENT(nfsd_file_search_class, name,				\
-	TP_PROTO(struct inode *inode, int found),			\
-	TP_ARGS(inode, found))
+	TP_PROTO(							\
+		const struct inode *inode,				\
+		unsigned int count					\
+	),								\
+	TP_ARGS(inode, count))
 
 DEFINE_NFSD_FILE_SEARCH_EVENT(nfsd_file_close_inode_sync);
 DEFINE_NFSD_FILE_SEARCH_EVENT(nfsd_file_close_inode);
-DEFINE_NFSD_FILE_SEARCH_EVENT(nfsd_file_is_cached);
+
+TRACE_EVENT(nfsd_file_is_cached,
+	TP_PROTO(
+		const struct inode *inode,
+		int found
+	),
+	TP_ARGS(inode, found),
+	TP_STRUCT__entry(
+		__field(const struct inode *, inode)
+		__field(int, found)
+	),
+	TP_fast_assign(
+		__entry->inode = inode;
+		__entry->found = found;
+	),
+	TP_printk("inode=%p is %scached",
+		__entry->inode,
+		__entry->found ? "" : "not "
+	)
+);
 
 TRACE_EVENT(nfsd_file_fsnotify_handle_event,
 	TP_PROTO(struct inode *inode, u32 mask),
-- 
2.43.0



