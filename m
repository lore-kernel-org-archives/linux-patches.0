Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199437F481;
	Mon,  8 Apr 2024 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584733; cv=none; b=lfkE6mWMMP17wBTHPQ1xbHJZ21Ghv2cjyhdWWQ3NNK0U/ejZ9KQvC6l5e2JZ0zFqO+i811X1ma3K0+09mipa9ir4UwRnB07H4X+igHqDfROoQfeyoiT1Lejab6mj96aSSnqBoDyqwzK6HzuV1ZTz38i6bWrUoJU7kySJiiQLGfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584733; c=relaxed/simple;
	bh=o2qg5pYoBS87sWX2ZIhKZUpmDS6cDoZ/xbXa3uWyew4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/n9HtujQdq7puXLL/rdwldgcnzN5maYN6wcT0oeJGkrGOOucDrdJs4LI1I8/T7mNxcHn9Yhf8XtK3VgrG8hnCNGz6FQHXBNzlW170mebZLYiAf0YMPlBu61VPVoHgif4AXBQ1OlbAg4GpFSWlTveA5pzwzwpWB1fp3BgvKpm2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvApxcwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvApxcwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E6EC43390;
	Mon,  8 Apr 2024 13:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584733;
	bh=o2qg5pYoBS87sWX2ZIhKZUpmDS6cDoZ/xbXa3uWyew4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvApxcwqReNM2/ekszdI+rhExD7DniO9otvByCnU7AfZzTXluIJCygqxFlOLkMKrl
	 VcAOug/7tTnBC240f2YcuIJvWrWRbGypjeuwm7DQ2tQkrgERMH3UJ55zMKU98R7oSC
	 RqQO0zwouBg6y5VZeT3MO93tzlDySx/138hkJT7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 538/690] nfsd: simplify the delayed disposal list code
Date: Mon,  8 Apr 2024 14:56:44 +0200
Message-ID: <20240408125419.151145936@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 92e4a6733f922f0fef1d0995f7b2d0eaff86c7ea ]

When queueing a dispose list to the appropriate "freeme" lists, it
pointlessly queues the objects one at a time to an intermediate list.

Remove a few helpers and just open code a list_move to make it more
clear and efficient. Better document the resulting functions with
kerneldoc comments.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 64 ++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 42 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 52e67ec267965..6b8706f23eaf0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -401,49 +401,26 @@ nfsd_file_dispose_list(struct list_head *dispose)
 	}
 }
 
-static void
-nfsd_file_list_remove_disposal(struct list_head *dst,
-		struct nfsd_fcache_disposal *l)
-{
-	spin_lock(&l->lock);
-	list_splice_init(&l->freeme, dst);
-	spin_unlock(&l->lock);
-}
-
-static void
-nfsd_file_list_add_disposal(struct list_head *files, struct net *net)
-{
-	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-	struct nfsd_fcache_disposal *l = nn->fcache_disposal;
-
-	spin_lock(&l->lock);
-	list_splice_tail_init(files, &l->freeme);
-	spin_unlock(&l->lock);
-	queue_work(nfsd_filecache_wq, &l->work);
-}
-
-static void
-nfsd_file_list_add_pernet(struct list_head *dst, struct list_head *src,
-		struct net *net)
-{
-	struct nfsd_file *nf, *tmp;
-
-	list_for_each_entry_safe(nf, tmp, src, nf_lru) {
-		if (nf->nf_net == net)
-			list_move_tail(&nf->nf_lru, dst);
-	}
-}
-
+/**
+ * nfsd_file_dispose_list_delayed - move list of dead files to net's freeme list
+ * @dispose: list of nfsd_files to be disposed
+ *
+ * Transfers each file to the "freeme" list for its nfsd_net, to eventually
+ * be disposed of by the per-net garbage collector.
+ */
 static void
 nfsd_file_dispose_list_delayed(struct list_head *dispose)
 {
-	LIST_HEAD(list);
-	struct nfsd_file *nf;
-
 	while(!list_empty(dispose)) {
-		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
-		nfsd_file_list_add_pernet(&list, dispose, nf->nf_net);
-		nfsd_file_list_add_disposal(&list, nf->nf_net);
+		struct nfsd_file *nf = list_first_entry(dispose,
+						struct nfsd_file, nf_lru);
+		struct nfsd_net *nn = net_generic(nf->nf_net, nfsd_net_id);
+		struct nfsd_fcache_disposal *l = nn->fcache_disposal;
+
+		spin_lock(&l->lock);
+		list_move_tail(&nf->nf_lru, &l->freeme);
+		spin_unlock(&l->lock);
+		queue_work(nfsd_filecache_wq, &l->work);
 	}
 }
 
@@ -664,8 +641,8 @@ nfsd_file_close_inode_sync(struct inode *inode)
  * nfsd_file_delayed_close - close unused nfsd_files
  * @work: dummy
  *
- * Walk the LRU list and destroy any entries that have not been used since
- * the last scan.
+ * Scrape the freeme list for this nfsd_net, and then dispose of them
+ * all.
  */
 static void
 nfsd_file_delayed_close(struct work_struct *work)
@@ -674,7 +651,10 @@ nfsd_file_delayed_close(struct work_struct *work)
 	struct nfsd_fcache_disposal *l = container_of(work,
 			struct nfsd_fcache_disposal, work);
 
-	nfsd_file_list_remove_disposal(&head, l);
+	spin_lock(&l->lock);
+	list_splice_init(&l->freeme, &head);
+	spin_unlock(&l->lock);
+
 	nfsd_file_dispose_list(&head);
 }
 
-- 
2.43.0



