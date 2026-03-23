Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663FA27EFEE;
	Mon, 23 Mar 2026 15:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278756; cv=none; b=X9T4VB9QT641y5KUia8hnD59Eyk5pyVT8q8oVAG6LsPUJYILSgXm+xzXJz89Ap2apF1StPyZZbMKBzCDA9rzDCK2wLPlyeoMybW63rzCuMHz7X9IdLozoUzja+FjZf3q+GH42l5zOo7QuRXU7IyexqAXsgD+EiuACQqAzCGXZfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278756; c=relaxed/simple;
	bh=K4NYD5WlrM9PzLa9j6DEROVXmlWuE3/IvGUJ2mT/GE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvkHwOtRyYvaYrkbbEHyQfmA7UCIW3H4mzH+7nw1XCJ+OyqQ8JG82aW0wTF4zzdZYPU8yXKVXEDZ82wnwN96jh3NxypPYodC7kDYO+DpsTTdl5Oel6vh1QKrF+Udf/40uM4VzI0NXFDop1Vk1fGLRPye5ZvAQ45TYNCqraYvpgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+njhh+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+njhh+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4F5C4CEF7;
	Mon, 23 Mar 2026 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278756;
	bh=K4NYD5WlrM9PzLa9j6DEROVXmlWuE3/IvGUJ2mT/GE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+njhh+OLzn1URmUr6PI6y712dZVWKyctM7RWttUMAHR3sIZKl3ZOJFo1pjeAk+Fm
	 WsItL/+D3ZVl6nCGugExhjAMhFRpeHdysmQrKGu8ZoNneSs1e3bEvR+e/bjlwWfmGl
	 2xRTT3/j1jqjehN2QcnSayPseLZhgtUKGlwdD9Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.6 408/567] NFS: Fix a deadlock involving nfs_release_folio()
Date: Mon, 23 Mar 2026 14:45:28 +0100
Message-ID: <20260323134543.973692623@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit cce0be6eb4971456b703aaeafd571650d314bcca ]

Wang Zhaolong reports a deadlock involving NFSv4.1 state recovery
waiting on kthreadd, which is attempting to reclaim memory by calling
nfs_release_folio(). The latter cannot make progress due to state
recovery being needed.

It seems that the only safe thing to do here is to kick off a writeback
of the folio, without waiting for completion, or else kicking off an
asynchronous commit.

Reported-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Fixes: 96780ca55e3c ("NFS: fix up nfs_release_folio() to try to release the page")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/file.c          |    3 ++-
 fs/nfs/nfstrace.h      |    3 +++
 fs/nfs/write.c         |   33 +++++++++++++++++++++++++++++++++
 include/linux/nfs_fs.h |    1 +
 4 files changed, 39 insertions(+), 1 deletion(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -459,7 +459,8 @@ static bool nfs_release_folio(struct fol
 		if ((current_gfp_context(gfp) & GFP_KERNEL) != GFP_KERNEL ||
 		    current_is_kswapd() || current_is_kcompactd())
 			return false;
-		if (nfs_wb_folio(folio_file_mapping(folio)->host, folio) < 0)
+		if (nfs_wb_folio_reclaim(folio_file_mapping(folio)->host, folio) < 0 ||
+		    folio_test_private(folio))
 			return false;
 	}
 	return nfs_fscache_release_folio(folio, gfp);
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -1033,6 +1033,9 @@ DECLARE_EVENT_CLASS(nfs_folio_event_done
 DEFINE_NFS_FOLIO_EVENT(nfs_aop_readpage);
 DEFINE_NFS_FOLIO_EVENT_DONE(nfs_aop_readpage_done);
 
+DEFINE_NFS_FOLIO_EVENT(nfs_writeback_folio_reclaim);
+DEFINE_NFS_FOLIO_EVENT_DONE(nfs_writeback_folio_reclaim_done);
+
 DEFINE_NFS_FOLIO_EVENT(nfs_writeback_folio);
 DEFINE_NFS_FOLIO_EVENT_DONE(nfs_writeback_folio_done);
 
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -2122,6 +2122,39 @@ int nfs_wb_folio_cancel(struct inode *in
 }
 
 /**
+ * nfs_wb_folio_reclaim - Write back all requests on one page
+ * @inode: pointer to page
+ * @folio: pointer to folio
+ *
+ * Assumes that the folio has been locked by the caller
+ */
+int nfs_wb_folio_reclaim(struct inode *inode, struct folio *folio)
+{
+	loff_t range_start = folio_pos(folio);
+	size_t len = folio_size(folio);
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_ALL,
+		.nr_to_write = 0,
+		.range_start = range_start,
+		.range_end = range_start + len - 1,
+		.for_sync = 1,
+	};
+	int ret;
+
+	if (folio_test_writeback(folio))
+		return -EBUSY;
+	if (folio_clear_dirty_for_io(folio)) {
+		trace_nfs_writeback_folio_reclaim(inode, range_start, len);
+		ret = nfs_writepage_locked(folio, &wbc);
+		trace_nfs_writeback_folio_reclaim_done(inode, range_start, len,
+						       ret);
+		return ret;
+	}
+	nfs_commit_inode(inode, 0);
+	return 0;
+}
+
+/**
  * nfs_wb_folio - Write back all requests on one page
  * @inode: pointer to page
  * @folio: pointer to folio
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -608,6 +608,7 @@ extern int  nfs_update_folio(struct file
 extern int nfs_sync_inode(struct inode *inode);
 extern int nfs_wb_all(struct inode *inode);
 extern int nfs_wb_folio(struct inode *inode, struct folio *folio);
+extern int nfs_wb_folio_reclaim(struct inode *inode, struct folio *folio);
 int nfs_wb_folio_cancel(struct inode *inode, struct folio *folio);
 extern int  nfs_commit_inode(struct inode *, int);
 extern struct nfs_commit_data *nfs_commitdata_alloc(void);


