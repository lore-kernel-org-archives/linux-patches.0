Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424AA1E7C2B;
	Thu, 30 Jan 2025 14:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245606; cv=none; b=WPfoRltCkG2KaMYIzs2XnSCWQoo4lpxpQ7W0/eDKwGcnLXJkSBBdLoLn7DN64kswg/Fyrxi87t7biUK5qPwAv+6Uc669bQhZyuYJekGcWrYJVeAP6kyPaF0+lIXkkJklsT6fM0J5eofG4I7zGPcVu9JkIx28mUNeM/7Xlz8q8YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245606; c=relaxed/simple;
	bh=1s6uZbesre/RkcxH7XUjCFXauYOUSXbRhg5n0Y3r9Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=al3LMu10CiW8SyG1cbbnTYXEuwE+8SpfNDELe8m3SjWW08NN8+aHCc7ZYDPdgpN83whlLDotl8DAszuA+GGF2n30U6P+QkXHs8vifnxEjcMnifwj6LqTNyq05lybVSm4vAq4WxTZ8PMVazr7eavREYLLX7BKOMKSaskAH63X4Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0/wMnLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0/wMnLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617AAC4CED2;
	Thu, 30 Jan 2025 14:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245605;
	bh=1s6uZbesre/RkcxH7XUjCFXauYOUSXbRhg5n0Y3r9Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0/wMnLuIc9Ammr1KAhFGRZTN8qn68iukScC0XscYVpjYtF9ZiS/psJoGTnSvuWDG
	 Mg2RuI5+00RMqGMR5XxB5XZRpRRFt83s5D2SJ36yB8C4U5+TxvXBtB6wr+oQWdYQ7g
	 xqrEycQoUq4TlvxrINwar+rj8yvBb1mc5DVu/ztM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Yang Erkun <yangerkun@huawei.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.13 03/25] Revert "libfs: Add simple_offset_empty()"
Date: Thu, 30 Jan 2025 14:58:49 +0100
Message-ID: <20250130133457.059864667@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit d7bde4f27ceef3dc6d72010a20d4da23db835a32 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c         |   32 --------------------------------
 include/linux/fs.h |    1 -
 mm/shmem.c         |    4 ++--
 3 files changed, 2 insertions(+), 35 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -330,38 +330,6 @@ void simple_offset_remove(struct offset_
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
-	mt_for_each(&octx->mt, child, index, LONG_MAX) {
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
@@ -3468,7 +3468,6 @@ struct offset_ctx {
 void simple_offset_init(struct offset_ctx *octx);
 int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry);
 void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry);
-int simple_offset_empty(struct dentry *dentry);
 int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
 			 struct inode *new_dir, struct dentry *new_dentry);
 int simple_offset_rename_exchange(struct inode *old_dir,
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3821,7 +3821,7 @@ static int shmem_unlink(struct inode *di
 
 static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	if (!simple_offset_empty(dentry))
+	if (!simple_empty(dentry))
 		return -ENOTEMPTY;
 
 	drop_nlink(d_inode(dentry));
@@ -3878,7 +3878,7 @@ static int shmem_rename2(struct mnt_idma
 		return simple_offset_rename_exchange(old_dir, old_dentry,
 						     new_dir, new_dentry);
 
-	if (!simple_offset_empty(new_dentry))
+	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
 	if (flags & RENAME_WHITEOUT) {


