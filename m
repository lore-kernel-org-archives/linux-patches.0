Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F51939A7FD;
	Sat, 12 Sep 2026 20:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243337; cv=none; b=uoSIpWOqbt8PUdXJh8zJYTSoq7POSbyjrr9aFIgYqapWcHxwwGyEzlp19e66h6tESZXIvvw9vdDs/Grc6w3FizX1hysya1kXoRi414T3lcbInyV2LA/ElWl7xLWr+NBJ0cvjIQES65n7VZTVqy2nS6Ps8zBbhq48/AXJCu24E2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243337; c=relaxed/simple;
	bh=jrMlE5856zleCDaA9MW8gfytSydAWcXT8NgkY6Q2gQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4r/x6BonRbUSL5cB/9a9/AXu5hkNjSPhvWKcrZnP+7loQYwUWakxc/xj1eS0M1Odn7yKmUEX3nv14KPGzXNTedBtQHbrTEXEUgOcMuwcbm24iCvpmqOZGMOzDrUZNzNg7bMsqBfeVut1gIRQprkXiMHD11ZNbFED0QFdlPH8nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/PA6sdc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/PA6sdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4C31F000FF;
	Sat, 12 Sep 2026 20:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243336;
	bh=cetQ9XMPD2CboCRCB+AK5IhpF2AgY6ULRWQxbJv47mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/PA6sdcJzzEc5EWHiN8jC1RkE7EPbOhZISFTx2awCY4slWRBOYFv788eInlGl1bA
	 OoovmVsOFfcmW5dgaRTEEoPQcgbJp2dfmWVu0EIswK5s1JdAKZ5ZN433daC+g1U8nN
	 2p2xBMm6iKg2dp1tw8uaPUI9K0bjS5D6xpSw+ShE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 720/798] NFS: Always clear an invalid mapping when attempting a buffered write
Date: Sat, 12 Sep 2026 09:05:48 +0200
Message-ID: <20260912065533.583585860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 28aa2f9e73e762dbaa28fdca20cccb59c74cc139 ]

If the page cache is invalid, then we can't do read-modify-write, so
ensure that we do clear it when we know it is invalid.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Stable-dep-of: 61461050da42 ("nfs: replace atomic bitops sequence with clear_and_wake_up_bit helper")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/file.c          |  2 +
 fs/nfs/inode.c         | 97 +++++++++++++++++++++++-------------------
 include/linux/nfs_fs.h |  1 +
 3 files changed, 57 insertions(+), 43 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index d35aae47b062b..574af74966ba8 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -641,6 +641,8 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_pos > i_size_read(inode))
 		nfs_revalidate_mapping(inode, file->f_mapping);
 
+	nfs_clear_invalid_mapping(file->f_mapping);
+
 	since = filemap_sample_wb_err(file->f_mapping);
 	nfs_start_io_write(inode);
 	result = generic_write_checks(iocb, from);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 6b800df1df29e..40655b56b6f5e 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1279,55 +1279,19 @@ static int nfs_invalidate_mapping(struct inode *inode, struct address_space *map
 	return 0;
 }
 
-bool nfs_mapping_need_revalidate_inode(struct inode *inode)
-{
-	return nfs_check_cache_invalid(inode, NFS_INO_REVAL_PAGECACHE) ||
-		NFS_STALE(inode);
-}
-
-int nfs_revalidate_mapping_rcu(struct inode *inode)
-{
-	struct nfs_inode *nfsi = NFS_I(inode);
-	unsigned long *bitlock = &nfsi->flags;
-	int ret = 0;
-
-	if (IS_SWAPFILE(inode))
-		goto out;
-	if (nfs_mapping_need_revalidate_inode(inode)) {
-		ret = -ECHILD;
-		goto out;
-	}
-	spin_lock(&inode->i_lock);
-	if (test_bit(NFS_INO_INVALIDATING, bitlock) ||
-	    (nfsi->cache_validity & NFS_INO_INVALID_DATA))
-		ret = -ECHILD;
-	spin_unlock(&inode->i_lock);
-out:
-	return ret;
-}
-
 /**
- * nfs_revalidate_mapping - Revalidate the pagecache
- * @inode: pointer to host inode
+ * nfs_clear_invalid_mapping - Conditionally clear a mapping
  * @mapping: pointer to mapping
+ *
+ * If the NFS_INO_INVALID_DATA inode flag is set, clear the mapping.
  */
-int nfs_revalidate_mapping(struct inode *inode,
-		struct address_space *mapping)
+int nfs_clear_invalid_mapping(struct address_space *mapping)
 {
+	struct inode *inode = mapping->host;
 	struct nfs_inode *nfsi = NFS_I(inode);
 	unsigned long *bitlock = &nfsi->flags;
 	int ret = 0;
 
-	/* swapfiles are not supposed to be shared. */
-	if (IS_SWAPFILE(inode))
-		goto out;
-
-	if (nfs_mapping_need_revalidate_inode(inode)) {
-		ret = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
-		if (ret < 0)
-			goto out;
-	}
-
 	/*
 	 * We must clear NFS_INO_INVALID_DATA first to ensure that
 	 * invalidations that come in while we're shooting down the mappings
@@ -1358,8 +1322,8 @@ int nfs_revalidate_mapping(struct inode *inode,
 
 	set_bit(NFS_INO_INVALIDATING, bitlock);
 	smp_wmb();
-	nfsi->cache_validity &= ~(NFS_INO_INVALID_DATA|
-			NFS_INO_DATA_INVAL_DEFER);
+	nfsi->cache_validity &=
+		~(NFS_INO_INVALID_DATA | NFS_INO_DATA_INVAL_DEFER);
 	spin_unlock(&inode->i_lock);
 	trace_nfs_invalidate_mapping_enter(inode);
 	ret = nfs_invalidate_mapping(inode, mapping);
@@ -1372,6 +1336,53 @@ int nfs_revalidate_mapping(struct inode *inode,
 	return ret;
 }
 
+bool nfs_mapping_need_revalidate_inode(struct inode *inode)
+{
+	return nfs_check_cache_invalid(inode, NFS_INO_REVAL_PAGECACHE) ||
+		NFS_STALE(inode);
+}
+
+int nfs_revalidate_mapping_rcu(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+	unsigned long *bitlock = &nfsi->flags;
+	int ret = 0;
+
+	if (IS_SWAPFILE(inode))
+		goto out;
+	if (nfs_mapping_need_revalidate_inode(inode)) {
+		ret = -ECHILD;
+		goto out;
+	}
+	spin_lock(&inode->i_lock);
+	if (test_bit(NFS_INO_INVALIDATING, bitlock) ||
+	    (nfsi->cache_validity & NFS_INO_INVALID_DATA))
+		ret = -ECHILD;
+	spin_unlock(&inode->i_lock);
+out:
+	return ret;
+}
+
+/**
+ * nfs_revalidate_mapping - Revalidate the pagecache
+ * @inode: pointer to host inode
+ * @mapping: pointer to mapping
+ */
+int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping)
+{
+	/* swapfiles are not supposed to be shared. */
+	if (IS_SWAPFILE(inode))
+		return 0;
+
+	if (nfs_mapping_need_revalidate_inode(inode)) {
+		int ret = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		if (ret < 0)
+			return ret;
+	}
+
+	return nfs_clear_invalid_mapping(mapping);
+}
+
 static bool nfs_file_has_writers(struct nfs_inode *nfsi)
 {
 	struct inode *inode = &nfsi->vfs_inode;
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 8d4f019b7af8e..8445c3ae18bef 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -383,6 +383,7 @@ extern int nfs_open(struct inode *, struct file *);
 extern int nfs_attribute_cache_expired(struct inode *inode);
 extern int nfs_revalidate_inode(struct nfs_server *server, struct inode *inode);
 extern int __nfs_revalidate_inode(struct nfs_server *, struct inode *);
+extern int nfs_clear_invalid_mapping(struct address_space *mapping);
 extern bool nfs_mapping_need_revalidate_inode(struct inode *inode);
 extern int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping);
 extern int nfs_revalidate_mapping_rcu(struct inode *inode);
-- 
2.53.0



