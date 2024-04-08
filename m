Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC3B7F7D0;
	Mon,  8 Apr 2024 13:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584727; cv=none; b=Cv9JjzZtepawvWfpkxuYwVeNxpCEJKwG9dg+6/fCR9LkPyhi7ocfW09eGsK7R3m6aLzzUW1xPEz4akmkZTZdujeKqBx4fORuXQj0H4rziLJZLxETW0hPN17vRSKnW4WzkF/Xvoym54O2xFpqOxQ3lsI18dff4KR5x64rp58u8bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584727; c=relaxed/simple;
	bh=1CApaVpIdmsIKUmxK0ArvtWnptCqQGcTtlVBl0sMFGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3w6ynZg54bQX/u/V8A6OKgYqWhnsjGiUFEAwxAPEQBLBjZjU+JEFJhyUqSqNX3lsJlLz85R7hctHtFt/PH4SrJbtKhqzHp8dPCTNFFenkbHX9+zQqaun48yCvEimie0tAwLcI5vZsCbRMVWVpKThjz37rR9ri64aEg55VlFLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEFpZtMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEFpZtMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845A2C433C7;
	Mon,  8 Apr 2024 13:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584726;
	bh=1CApaVpIdmsIKUmxK0ArvtWnptCqQGcTtlVBl0sMFGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEFpZtMr5R+IwSXrtTwWsGmsaYEY57i9mDT8sOZllVc/KQm9SvASqizbxTkpR3lmN
	 dvN8P9PaBRWUA4NGMzs2hA8b/r49Qg7m9wGQvzWajVBSs4SSKmcMDQX/uk9PlZITDA
	 ZMkkPdfaim5uP5JaOZplTOroBtFRK8sVX3J+Q8v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 536/690] nfsd: allow reaping files still under writeback
Date: Mon,  8 Apr 2024 14:56:42 +0200
Message-ID: <20240408125419.079153627@linuxfoundation.org>
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

[ Upstream commit dcb779fcd4ed5984ad15991d574943d12a8693d1 ]

On most filesystems, there is no reason to delay reaping an nfsd_file
just because its underlying inode is still under writeback. nfsd just
relies on client activity or the local flusher threads to do writeback.

The main exception is NFS, which flushes all of its dirty data on last
close. Add a new EXPORT_OP_FLUSH_ON_CLOSE flag to allow filesystems to
signal that they do this, and only skip closing files under writeback on
such filesystems.

Also, remove a redundant NULL file pointer check in
nfsd_file_check_writeback, and clean up nfs's export op flag
definitions.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
[ cel: adjusted to apply to v5.15.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfs/export.c          |  9 ++++++---
 fs/nfsd/filecache.c      | 12 +++++++++++-
 include/linux/exportfs.h |  1 +
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index 37a1a88df7717..eafa9d7b0911b 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -178,7 +178,10 @@ const struct export_operations nfs_export_ops = {
 	.fh_to_dentry = nfs_fh_to_dentry,
 	.get_parent = nfs_get_parent,
 	.fetch_iversion = nfs_fetch_iversion,
-	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|
-		EXPORT_OP_CLOSE_BEFORE_UNLINK|EXPORT_OP_REMOTE_FS|
-		EXPORT_OP_NOATOMIC_ATTR,
+	.flags = EXPORT_OP_NOWCC		|
+		 EXPORT_OP_NOSUBTREECHK		|
+		 EXPORT_OP_CLOSE_BEFORE_UNLINK	|
+		 EXPORT_OP_REMOTE_FS		|
+		 EXPORT_OP_NOATOMIC_ATTR	|
+		 EXPORT_OP_FLUSH_ON_CLOSE,
 };
diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 1d4c0387c4192..080d796547854 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -401,13 +401,23 @@ nfsd_file_check_writeback(struct nfsd_file *nf)
 	struct file *file = nf->nf_file;
 	struct address_space *mapping;
 
-	if (!file || !(file->f_mode & FMODE_WRITE))
+	/* File not open for write? */
+	if (!(file->f_mode & FMODE_WRITE))
 		return false;
+
+	/*
+	 * Some filesystems (e.g. NFS) flush all dirty data on close.
+	 * On others, there is no need to wait for writeback.
+	 */
+	if (!(file_inode(file)->i_sb->s_export_op->flags & EXPORT_OP_FLUSH_ON_CLOSE))
+		return false;
+
 	mapping = file->f_mapping;
 	return mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
 		mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
 }
 
+
 static bool nfsd_file_lru_add(struct nfsd_file *nf)
 {
 	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index fe848901fcc3a..218fc5c54e901 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -221,6 +221,7 @@ struct export_operations {
 #define EXPORT_OP_NOATOMIC_ATTR		(0x10) /* Filesystem cannot supply
 						  atomic attribute updates
 						*/
+#define EXPORT_OP_FLUSH_ON_CLOSE	(0x20) /* fs flushes file data on close */
 	unsigned long	flags;
 };
 
-- 
2.43.0



