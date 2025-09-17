Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164CF1EB1AA;
	Wed, 17 Sep 2025 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113388; cv=none; b=uSoV9YIN0LCVKqUL/idstByv5gWQnVA/Y5TeDWn0cjieDZC7we5RM/ahwRcP1tWhhfcJymNdqkOk+S+y9Vlos1c98xeEMYNOC+MptlhKxm6sK/FyEWlpsyrCv7ff2vkk+IP57d/KL8N4yOAIE55qRQSXXXrFkiod3/7GgtW00Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113388; c=relaxed/simple;
	bh=G2KnKmRUNFofYRem/YZ6s2zfLs8+ReJFpl3sTbk7uZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/Des4Uxfgvhktv4OBfVYENdZ/JU+vv235Km06/jvOAnC8idWLbhFeWb8MnUb1H3mqXmTH0xqLLtG4cnsrQTAO2wXGJ38Bc5c9g0fLXuO0U85I1ILJCvx6ONZVc9qzYReuUqw6nMVxYti7ebVMMEPMr0BCFx9Y8No5Id3MelyGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFstNYfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFstNYfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F71C4CEF0;
	Wed, 17 Sep 2025 12:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113387;
	bh=G2KnKmRUNFofYRem/YZ6s2zfLs8+ReJFpl3sTbk7uZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFstNYfMyIrZKKUsQhtJ0lyhs3+OpeRCsivAP8Rl7p2CNjttvRssik5X+FIJjix2G
	 yI8cEuwfDl94oaQFQWYNVzrBs5SvXohQJc3/qMhr1jO52Hydjx5/2gWRIfw2OM/MFk
	 A2urxc4TvIXggOolquRKzQQP4G/qy/1VuzhuNxy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/140] NFS: Serialise O_DIRECT i/o and truncate()
Date: Wed, 17 Sep 2025 14:33:25 +0200
Message-ID: <20250917123345.118798706@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8827cb00f86d5..5bf5fb5ddd34c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -761,8 +761,10 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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
index 4860270f1be04..456b423402814 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -529,6 +529,16 @@ static inline bool nfs_file_io_is_buffered(struct nfs_inode *nfsi)
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



