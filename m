Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23973E49C6;
	Tue, 21 Jul 2026 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653901; cv=none; b=FLnsWUucURc2AHtIS5lsuUh404RTvi4xNF8VW9iZoCb5646rGN9k2jhvwqDTI+T8A+cc/pPEQNy3x3XZJJ859a1Irmccf2uR0aSVxNQbbGL1QCd3GpK7+wVYckMsbz4hIgNUFhYqWm6ystWGfDfd+AdID/xeCFcVuvb84soxqME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653901; c=relaxed/simple;
	bh=5HEpCt9RXq8F9NAX1dh+Gp8i4fAeY9vgvow1wyQym8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAPgFz8t5e/ReKRYsYWqsAQhtf4n1rXPYagKc17+KaGTiKiM3aFdZOh7r15ObEO4K+CLcd3UCoz2+hevrbqrfL6sIy9kHnx4mffSvzBn1NVqJHkitIzz/KJ1+te3ibf6Bg0NoiUYPmUq6sg0+oD66xurp+kQlUNCotEZwks+wJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J26GB5Y6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J26GB5Y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8CE1F00AC4;
	Tue, 21 Jul 2026 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653898;
	bh=FXh99GhDnp9VtH7iiQkyBRJvT+K1kQnuwIxtBAErbQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J26GB5Y6l4b8yNB/NhAUTJWug8w8lyHcZ2eFwlYtgGLH8A1BhRSXYPkd/uyMmRLSW
	 5oFWKxmYfKSgsYHZujJLhQRqMcrYCqv0HYvUXRmlzlnBXIdDoEKG3j7tx6a9Xz96DT
	 Ib+ddQ7tgLq7ivSSCcE4Wng4LgJThONlMpm/kagw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1501/2077] smb: client: fix busy dentry warning on unmount after DIO
Date: Tue, 21 Jul 2026 17:19:34 +0200
Message-ID: <20260721152628.190405918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 75f5c412fa867efa0bf9b646bffe0d912109e84a ]

Commit c68337442f03 ("cifs: Fix busy dentry used after unmounting") fixed
the issue in cifs where deferred close of a file led to a dentry reference
count not being released in umount, by flushing deferredclose_wq in
cifs_kill_sb() to solve it.

However, the cifs DIO path suffers from the same busy-dentry problem caused
by a delayed dentry reference-count release:

	[dio]			[cifsd]			[close + umount]
netfs_unbuffered_write_iter_locked
...
				cifs_demultiplex_thread
 netfs_unbuffered_write
  cifs_issue_write
  netfs_wait_for_in_progress_stream [1]
				...
				 netfs_write_subrequest_terminated
				  netfs_subreq_clear_in_progress
				   netfs_wake_collector // wake [1]
				  netfs_put_subrequest
 netfs_put_request
  queue_work(system_dfl_wq, xxx) [2]
 // dio write return					cifs_close
							 _cifsFileInfo_put
							  // cfile->count 2->1
							  --cfile->count [3]

							// umount
							cifs_kill_sb
							 kill_anon_super
							  // warning triggered!
							  shrink_dcache_for_umount [4]
[system_dfl_wq] [5]
netfs_free_request
 ...
 _cifsFileInfo_put
  // cfile->count 1->0
  --cfile->count
  queue_work(fileinfo_put_wq, xxx)

[fileinfo_put_wq] [6]
cifsFileInfo_put_work
 cifsFileInfo_put_final
  dput

If the umount path is triggered before [5], it results warning:
BUG: Dentry 00000000eab1f070{i=9a917b66ae404fec,n=test}  still in use (1)
[unmount of cifs cifs]

The existing per-inode ictx->io_count wait in cifs_evict_inode() does not
help: it lives in the inode eviction path, which runs after
shrink_dcache_for_umount() has already warned about the busy dentries.

Fix it by adding a per-superblock outstanding-rreq counter that is
incremented in cifs_init_request() and decremented in cifs_free_request().
In cifs_kill_sb(), before kill_anon_super(), wait for this counter to reach
0 - which guarantees that all cleanup_work for this sb have run and thus
all relevant cfile puts are queued on fileinfo_put_wq or serverclose_wq.
Then drain the workqueue so the dentry refs are dropped.

This is a targeted wait, not a flush of the system-wide system_dfl_wq.

Fixes: 340cea84f691c ("cifs: open files should not hold ref on superblock")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_fs_sb.h |  1 +
 fs/smb/client/cifsfs.c     | 12 ++++++++++++
 fs/smb/client/connect.c    |  1 +
 fs/smb/client/file.c       |  5 +++++
 4 files changed, 19 insertions(+)

diff --git a/fs/smb/client/cifs_fs_sb.h b/fs/smb/client/cifs_fs_sb.h
index 84e7e366b0ff41..d6494e1d93ccf6 100644
--- a/fs/smb/client/cifs_fs_sb.h
+++ b/fs/smb/client/cifs_fs_sb.h
@@ -56,6 +56,7 @@ struct cifs_sb_info {
 	struct smb3_fs_context *ctx;
 	atomic_t active;
 	atomic_t mnt_cifs_flags;
+	atomic_t outstanding_rreq;	/* nr of rreqs not yet fully deinitialized */
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
 
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index ce23924f01b3a6..d6c30f8552e081 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -309,6 +309,18 @@ static void cifs_kill_sb(struct super_block *sb)
 		/* Wait for all opened files to release */
 		flush_workqueue(deferredclose_wq);
 
+		/*
+		 * Wait for all in-flight netfs I/O requests to finish their
+		 * cleanup_work so that any cifsFileInfo final puts they queue
+		 * to fileinfo_put_wq/serverclose_wq have been queued, then
+		 * drain the workqueue so the cfile dentry refs are dropped to
+		 * avoid the busy dentry warning.
+		 */
+		wait_var_event(&cifs_sb->outstanding_rreq,
+			       !atomic_read(&cifs_sb->outstanding_rreq));
+		flush_workqueue(serverclose_wq);
+		flush_workqueue(fileinfo_put_wq);
+
 		/* finally release root dentry */
 		dput(cifs_sb->root);
 		cifs_sb->root = NULL;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index cbeb5637eeb925..9511deef7084fd 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3479,6 +3479,7 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
 	cifs_sb->tlink_tree = RB_ROOT;
+	atomic_set(&cifs_sb->outstanding_rreq, 0);
 
 	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
 		 ctx->file_mode, ctx->dir_mode);
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b5a61a4a43b85b..a26a464d6242b6 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -288,6 +288,7 @@ static int cifs_init_request(struct netfs_io_request *rreq, struct file *file)
 		return smb_EIO1(smb_eio_trace_not_netfs_writeback, rreq->origin);
 	}
 
+	atomic_inc(&cifs_sb->outstanding_rreq);
 	return 0;
 }
 
@@ -309,9 +310,13 @@ static void cifs_rreq_done(struct netfs_io_request *rreq)
 static void cifs_free_request(struct netfs_io_request *rreq)
 {
 	struct cifs_io_request *req = container_of(rreq, struct cifs_io_request, rreq);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(rreq->inode->i_sb);
 
 	if (req->cfile)
 		cifsFileInfo_put(req->cfile);
+
+	if (atomic_dec_and_test(&cifs_sb->outstanding_rreq))
+		wake_up_var(&cifs_sb->outstanding_rreq);
 }
 
 static void cifs_free_subrequest(struct netfs_io_subrequest *subreq)
-- 
2.53.0



