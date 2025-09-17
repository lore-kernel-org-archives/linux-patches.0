Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACCF1E9B19;
	Wed, 17 Sep 2025 12:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113850; cv=none; b=smQz1zdiYIkRBQE6k5iGBrGXZVRmUkVkpMQvg9G5yMA4RHcEp2zoMeIQ8h2OJGRNsmAg0OfomFQKNd+HTJvvdOmoBF4hLQT/AMuUwZ5mwHyIooXlTRf9Oh9AiDW//y30B3zZj4j5S19gMIuvI86UiM3zIO9dQAUnUHdG7J/Ti84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113850; c=relaxed/simple;
	bh=SnrqYQnqjfFu4l2q99QVO8SDyUDU1XOnwkZKNE759IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btoXIGfEIcbMJ2XC2nvAsPic0RYThHNS8pEZoW38ka/OL7nwirkTvgjX4cuEc45NZQQTigawj4heJB7cxqAoY5gOOj50gtbVKmd3/Akyk4ES97iNlknkQvsQ3C1iB4z1FEbQ5i2buQMybqnk+dg2bUi5igeiD56L03NWvIWeW/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKFlSxRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKFlSxRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03252C4CEF0;
	Wed, 17 Sep 2025 12:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113850;
	bh=SnrqYQnqjfFu4l2q99QVO8SDyUDU1XOnwkZKNE759IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKFlSxRVT59o7g8h5V5mGxBqWVvbEGxrhT4ltm36CuGFbXZuCNNfAG2xLUwIie2w9
	 96yumBYeo34cIQEHJ+A8nHvEZQlfYnrz9aHtJ/XXYLq1QGDg1ed1/5p3aJ7N8VMfd4
	 Ila4fmSvC49CI/JCpdGjWqUgXMeRiBleZ2VJ6tjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/101] NFS: Serialise O_DIRECT i/o and truncate()
Date: Wed, 17 Sep 2025 14:34:00 +0200
Message-ID: <20250917123337.277113704@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 9eb90f435415c7da4800974ed943e39b5578ee7f ]

Ensure that all O_DIRECT reads and writes are complete, and prevent the
initiation of new i/o until the setattr operation that will truncate the
file is complete.

Fixes: a5864c999de6 ("NFS: Do not serialise O_DIRECT reads and writes")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c    |  4 +++-
 fs/nfs/internal.h | 10 ++++++++++
 fs/nfs/io.c       | 13 ++-----------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 7e7dd2aab449d..5cd5e4226db36 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -645,8 +645,10 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	trace_nfs_setattr_enter(inode);
 
 	/* Write all dirty data */
-	if (S_ISREG(inode->i_mode))
+	if (S_ISREG(inode->i_mode)) {
+		nfs_file_block_o_direct(NFS_I(inode));
 		nfs_sync_inode(inode);
+	}
 
 	fattr = nfs_alloc_fattr_with_label(NFS_SERVER(inode));
 	if (fattr == NULL) {
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index e78f43a137231..bde81e0abf0ae 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -474,6 +474,16 @@ static inline bool nfs_file_io_is_buffered(struct nfs_inode *nfsi)
 	return test_bit(NFS_INO_ODIRECT, &nfsi->flags) == 0;
 }
 
+/* Must be called with exclusively locked inode->i_rwsem */
+static inline void nfs_file_block_o_direct(struct nfs_inode *nfsi)
+{
+	if (test_bit(NFS_INO_ODIRECT, &nfsi->flags)) {
+		clear_bit(NFS_INO_ODIRECT, &nfsi->flags);
+		inode_dio_wait(&nfsi->vfs_inode);
+	}
+}
+
+
 /* namespace.c */
 #define NFS_PATH_CANONICAL 1
 extern char *nfs_path(char **p, struct dentry *dentry,
diff --git a/fs/nfs/io.c b/fs/nfs/io.c
index 3388faf2acb9f..d275b0a250bf3 100644
--- a/fs/nfs/io.c
+++ b/fs/nfs/io.c
@@ -14,15 +14,6 @@
 
 #include "internal.h"
 
-/* Call with exclusively locked inode->i_rwsem */
-static void nfs_block_o_direct(struct nfs_inode *nfsi, struct inode *inode)
-{
-	if (test_bit(NFS_INO_ODIRECT, &nfsi->flags)) {
-		clear_bit(NFS_INO_ODIRECT, &nfsi->flags);
-		inode_dio_wait(inode);
-	}
-}
-
 /**
  * nfs_start_io_read - declare the file is being used for buffered reads
  * @inode: file inode
@@ -57,7 +48,7 @@ nfs_start_io_read(struct inode *inode)
 	err = down_write_killable(&inode->i_rwsem);
 	if (err)
 		return err;
-	nfs_block_o_direct(nfsi, inode);
+	nfs_file_block_o_direct(nfsi);
 	downgrade_write(&inode->i_rwsem);
 
 	return 0;
@@ -90,7 +81,7 @@ nfs_start_io_write(struct inode *inode)
 
 	err = down_write_killable(&inode->i_rwsem);
 	if (!err)
-		nfs_block_o_direct(NFS_I(inode), inode);
+		nfs_file_block_o_direct(NFS_I(inode));
 	return err;
 }
 
-- 
2.51.0



