Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00682383;
	Thu, 30 Jan 2025 14:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246604; cv=none; b=IHn+TS2GBZmTxFmiiXT71ZpQfD0hnsmOE/URZRqLeMP8eSmL+vhs6FPkGynOouIW1d/SCbPYShn5FRDvqx9rMnMFUB0cK9UXjLpH4T2OnmZeWfdkjZHBrQ45DtAnX6w7aHUtQQY6+Xr1hrfLxabrNAI4yVZBZGm9KEaDvt6NZ9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246604; c=relaxed/simple;
	bh=lGGRZLqQWpMKWjHHCCseM/6AVq1OVYueRK1w2X5uWXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlAcnhv69AKe/0Trrp7fWQLo+xZhQXC6jvcz3kwVrzs9G9QWJk/xDl3KdFD1lVYDylaXT8gaKKCbqcC/H+GlLDLO2BqMdp1b+ZTj9vSp+3XtFfny6NfAe2wFIAdAEtT5ikMx25ackDyW5A2qJgiRff0jmNvyvDqJy0pyp5Al8NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjEY/Dsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjEY/Dsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F955C4CED2;
	Thu, 30 Jan 2025 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246603;
	bh=lGGRZLqQWpMKWjHHCCseM/6AVq1OVYueRK1w2X5uWXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjEY/Dsn5VciAwHFHs/Rull1lpKxTX28hRUe3BWFMqARE56wPpdDN/NoFdPV/ksz8
	 9x2Rr1i5kyDQlif8xrjffvZPM8Q1m4RLVcNeRl4bzh5/tF7MXlqBZb1jm6dlSuMny9
	 FYj1l4kBJqQ2PaZCS9dd3l56AOCxr0E+pZ39nggs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Yang Erkun <yangerkun@huawei.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 22/43] Revert "libfs: Add simple_offset_empty()"
Date: Thu, 30 Jan 2025 14:59:29 +0100
Message-ID: <20250130133459.795421743@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit d7bde4f27ceef3dc6d72010a20d4da23db835a32 ]

simple_empty() and simple_offset_empty() perform the same task.
The latter's use as a canary to find bugs has not found any new
issues. A subsequent patch will remove the use of the mtree for
iterating directory contents, so revert back to using a similar
mechanism for determining whether a directory is indeed empty.

Only one such mechanism is ever needed.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20241228175522.1854234-3-cel@kernel.org
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ cel: adjusted to apply to origin/linux-6.6.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c         |   32 --------------------------------
 include/linux/fs.h |    1 -
 mm/shmem.c         |    4 ++--
 3 files changed, 2 insertions(+), 35 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -325,38 +325,6 @@ void simple_offset_remove(struct offset_
 }
 
 /**
- * simple_offset_empty - Check if a dentry can be unlinked
- * @dentry: dentry to be tested
- *
- * Returns 0 if @dentry is a non-empty directory; otherwise returns 1.
- */
-int simple_offset_empty(struct dentry *dentry)
-{
-	struct inode *inode = d_inode(dentry);
-	struct offset_ctx *octx;
-	struct dentry *child;
-	unsigned long index;
-	int ret = 1;
-
-	if (!inode || !S_ISDIR(inode->i_mode))
-		return ret;
-
-	index = DIR_OFFSET_MIN;
-	octx = inode->i_op->get_offset_ctx(inode);
-	xa_for_each(&octx->xa, index, child) {
-		spin_lock(&child->d_lock);
-		if (simple_positive(child)) {
-			spin_unlock(&child->d_lock);
-			ret = 0;
-			break;
-		}
-		spin_unlock(&child->d_lock);
-	}
-
-	return ret;
-}
-
-/**
  * simple_offset_rename - handle directory offsets for rename
  * @old_dir: parent directory of source entry
  * @old_dentry: dentry of source entry
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3197,7 +3197,6 @@ struct offset_ctx {
 void simple_offset_init(struct offset_ctx *octx);
 int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry);
 void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry);
-int simple_offset_empty(struct dentry *dentry);
 int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
 			 struct inode *new_dir, struct dentry *new_dentry);
 int simple_offset_rename_exchange(struct inode *old_dir,
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3368,7 +3368,7 @@ static int shmem_unlink(struct inode *di
 
 static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	if (!simple_offset_empty(dentry))
+	if (!simple_empty(dentry))
 		return -ENOTEMPTY;
 
 	drop_nlink(d_inode(dentry));
@@ -3425,7 +3425,7 @@ static int shmem_rename2(struct mnt_idma
 		return simple_offset_rename_exchange(old_dir, old_dentry,
 						     new_dir, new_dentry);
 
-	if (!simple_offset_empty(new_dentry))
+	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
 	if (flags & RENAME_WHITEOUT) {


