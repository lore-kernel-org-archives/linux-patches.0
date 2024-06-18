Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5AB13C807;
	Tue, 18 Jun 2024 13:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716225; cv=none; b=EHvunC63yEU0fJMPfnqeryxuUVbMyYjUmJhB9KYBs/YbzscFdVVSWpCoTd38IyTAtQPa1Vqk71rOiygCos6e4NlcNsxpYqt16PatTVBIgF9K9GIzp3Hdkfo3bnrc0Qg6VE5ajB1c2iVtmgzrEpV6KZ4Txq+NyeB2kIJ3lMRwj7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716225; c=relaxed/simple;
	bh=SfyelsivfP9vSscDAM6GSk6uui8qYfMm4AsW5MwJkP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKEnoO2mE9Dkmb0utoQDipKeZ82PRK45P2Qpa9CyzoVX1RuKB1M5XZLWQoxq6XbWn+3oLt36PWRXa/8M861lkNfyimVbmu6J1VMxfeL05vWTeoGQI10cJEYJ3g+SCzdPQMijUi3hwYdfHgA+UAq+GiUsdyHLtg/g8dOqWcNrFbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoXPZhDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoXPZhDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85855C3277B;
	Tue, 18 Jun 2024 13:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716224;
	bh=SfyelsivfP9vSscDAM6GSk6uui8qYfMm4AsW5MwJkP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoXPZhDAZvqghs97PcTdutmhiDRyQ7z1q90kLMy26+tfwUoeTe8JY2fX2X9VZOXfG
	 w09yewp/Xq666lGxWzQbbB+fPloJGWV2n/vYLtbOLoceIYPYMlORW1VhJ1dYGIhaXY
	 7dMsFNCe521gNhv9324gjCKUP8DT89sylm3LeCLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 574/770] NFSD: Refactor __nfsd_file_close_inode()
Date: Tue, 18 Jun 2024 14:37:07 +0200
Message-ID: <20240618123429.452380653@linuxfoundation.org>
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

[ Upstream commit a845511007a63467fee575353c706806c21218b1 ]

The code that computes the hashval is the same in both callers.

To prevent them from going stale, reframe the documenting comments
to remove descriptions of the underlying hash table structure, which
is about to be replaced.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 8b34f2a5ad296..f170f07ec0fd2 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -813,30 +813,52 @@ TRACE_EVENT(nfsd_file_open,
 
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



