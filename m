Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD6D2D9787;
	Thu, 28 May 2026 20:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999952; cv=none; b=a52cO3UHOTdM6pYqU09yLXMMvkRugXJIf1RtXwXyUHdUklqNA4kCpci/KRhzekveqZucawo36ZXkfyfkYYKGb2zdEbE78z5FmOnZDTgHVn6Oa9CohmD/q2cg1zx1FUjxdMDWpQoHky2NK+wgqvUi6gYze3CVpzItSJtmrdyIbuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999952; c=relaxed/simple;
	bh=XzWzasvIYYijoHV5ephMxXdo7ygWi7jcH+mlOHO6+oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAJX01yyBmL9zFa20Z61PPTuK0BowXYHVzdBJ2kYOGwEKGtkmkUwUKuL/nDEEC3WjZkBU5Rvc5JOkY9nQtSE3oeO4TYUE5Xtq5bObPZDn2fdMQwI2UjEdRDnew2dryI+yQOwgx7SLLBNjSL3TS/VV4sG5XnYdhnxS3/KzfxbmSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xxkltqw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xxkltqw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397341F000E9;
	Thu, 28 May 2026 20:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999950;
	bh=wUozUQ4l5E6B/QabXv/09OHOijH4N4hybBpp36SmrmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xxkltqw+izbEgGJ+3erglFMMjyY9KHXOdkvNP4/RDtfH3r9Is9OkidMYgkKqjP1La
	 bwjyjea+JNiUzK7/cvYeMxmIRr9ZaGzHPlkJPapvLsRFqcy1r9DGxaL2kRTF3XuYf4
	 F0mrmbUw5YRptZ0SUbkEch+xJZIT2YpdNh0dnnfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 249/377] netfs, afs: Fix write skipping in dir/link writepages
Date: Thu, 28 May 2026 21:48:07 +0200
Message-ID: <20260528194645.588721456@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 9871938f99cc6cb266a77265491660e2375271f5 ]

Fix netfs_write_single() and afs_single_writepages() to better handle a
write that would be skipped due to lock contention and WB_SYNC_NONE by
returning 1 from netfs_write_single() if it skipped and making
afs_single_writepages() skip also.  If a skip occurs, the inode must be
re-marked as the VFS may have cleared the mark.

This is really only theoretical for directories in netfs_write_single() as
the only path to that is through afs_single_writepages() that takes the
->validate_lock around it, thereby serialising it.

Fixes: 6dd80936618c ("afs: Use netfslib for directories")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-24-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c           | 11 ++++++++++-
 fs/netfs/write_issue.c |  7 ++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 89d36e3e5c799..fa84610e0b0d9 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -2207,7 +2207,14 @@ int afs_single_writepages(struct address_space *mapping,
 	/* Need to lock to prevent the folio queue and folios from being thrown
 	 * away.
 	 */
-	down_read(&dvnode->validate_lock);
+	if (!down_read_trylock(&dvnode->validate_lock)) {
+		if (wbc->sync_mode == WB_SYNC_NONE) {
+			/* The VFS will have undirtied the inode. */
+			netfs_single_mark_inode_dirty(&dvnode->netfs.inode);
+			return 0;
+		}
+		down_read(&dvnode->validate_lock);
+	}
 
 	if (is_dir ?
 	    test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags) :
@@ -2215,6 +2222,8 @@ int afs_single_writepages(struct address_space *mapping,
 		iov_iter_folio_queue(&iter, ITER_SOURCE, dvnode->directory, 0, 0,
 				     i_size_read(&dvnode->netfs.inode));
 		ret = netfs_writeback_single(mapping, wbc, &iter);
+		if (ret == 1)
+			ret = 0; /* Skipped write due to lock conflict. */
 	}
 
 	up_read(&dvnode->validate_lock);
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 9bf05099155dc..03d170b9022b7 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -829,6 +829,9 @@ static int netfs_write_folio_single(struct netfs_io_request *wreq,
  *
  * Write a monolithic, non-pagecache object back to the server and/or
  * the cache.
+ *
+ * Return: 0 if successful; 1 if skipped due to lock conflict and WB_SYNC_NONE;
+ * or a negative error code.
  */
 int netfs_writeback_single(struct address_space *mapping,
 			   struct writeback_control *wbc,
@@ -845,8 +848,10 @@ int netfs_writeback_single(struct address_space *mapping,
 
 	if (!mutex_trylock(&ictx->wb_lock)) {
 		if (wbc->sync_mode == WB_SYNC_NONE) {
+			/* The VFS will have undirtied the inode. */
+			netfs_single_mark_inode_dirty(&ictx->inode);
 			netfs_stat(&netfs_n_wb_lock_skip);
-			return 0;
+			return 1;
 		}
 		netfs_stat(&netfs_n_wb_lock_wait);
 		mutex_lock(&ictx->wb_lock);
-- 
2.53.0



