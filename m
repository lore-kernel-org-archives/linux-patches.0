Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44013939A4;
	Sat, 17 Oct 2026 17:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258299; cv=none; b=uU8f06Tea6wm2+x++C3Gdg9SUk7y5kd3ClVxoMt9wWtR0H3WejmoCgYv1/3lEHxMVdnU3WP8nQmnbzYfkYAdu0gbheLjltufl5HrYeJC91ccYcUG5P3cNWa9byxI1KqVjrSoJJbceiBO/34amKx6viK8lK/9wsy8MrL2FPUcpBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258299; c=relaxed/simple;
	bh=UsAiM0BYliurgmlFGVc8a5AzAKouwpHaQ4yqunuLwFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTaImLxau5bpY64AHzYZYv6b+Xws/N2sWeIN2mRVGRsTPn4Kg5v3j64nbHbmmddRS8JJgEi6F/WcSrBQeKm/1U8V6Ttluk39cxPjlOR45QumHQSOoIaFCr89WmsUtEb8GSiXhBwZ1g6zw8/QidgwgzvlYLozHIYs73RUQ0d/haQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xg24SNpC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xg24SNpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED1A1F000C4;
	Sat, 17 Oct 2026 17:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258298;
	bh=OGzFpIPLVNB93Xg5iMzuDEvgoMuTHGz4BPzZYoFpCEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xg24SNpCyTWsMZTW/gDfmPDyI0CeU1gMUMPKZY9D7yDe7z17z6AGBQLPWdDDSxEdu
	 C/XAPyCG8Hz1x6ftldK3Dqwav2svuOHBytiYSzYKELdU6oem7vbu3WwClxn9P/eVIm
	 Aqz82RWEO5j/bM6ZhuNGF9q0lVK24zI0ckQeJV8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0836/1674] shmem: fix recovery on rename failures
Date: Sat, 17 Oct 2026 17:51:48 +0200
Message-ID: <20261017160452.589640137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit e1b4c6a58304fd490124cc2b454d80edc786665c ]

maple_tree insertions can fail if we are seriously short on memory;
simple_offset_rename() does not recover well if it runs into that.
The same goes for simple_offset_rename_exchange().

Moreover, shmem_whiteout() expects that if it succeeds, the caller will
progress to d_move(), i.e. that shmem_rename2() won't fail past the
successful call of shmem_whiteout().

Not hard to fix, fortunately - mtree_store() can't fail if the index we
are trying to store into is already present in the tree as a singleton.

For simple_offset_rename_exchange() that's enough - we just need to be
careful about the order of operations.

For simple_offset_rename() solution is to preinsert the target into the
tree for new_dir; the rest can be done without any potentially failing
operations.

That preinsertion has to be done in shmem_rename2() rather than in
simple_offset_rename() itself - otherwise we'd need to deal with the
possibility of failure after successful shmem_whiteout().

Fixes: a2e459555c5f ("shmem: stable directory offsets")
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c         | 50 +++++++++++++++++++---------------------------
 include/linux/fs.h |  2 +-
 mm/shmem.c         | 18 ++++++++++++-----
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index b913ab238cc15..f839c70616b06 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -344,22 +344,22 @@ void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry)
  * User space expects the directory offset value of the replaced
  * (new) directory entry to be unchanged after a rename.
  *
- * Returns zero on success, a negative errno value on failure.
+ * Caller must have grabbed a slot for new_dentry in the xarray
+ * associated with new_dir, even if dentry is negative.
  */
-int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
-			 struct inode *new_dir, struct dentry *new_dentry)
+void simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
+			  struct inode *new_dir, struct dentry *new_dentry)
 {
 	struct offset_ctx *old_ctx = old_dir->i_op->get_offset_ctx(old_dir);
 	struct offset_ctx *new_ctx = new_dir->i_op->get_offset_ctx(new_dir);
 	long new_offset = dentry2offset(new_dentry);
 
-	simple_offset_remove(old_ctx, old_dentry);
+	if (WARN_ON(!new_offset))
+		return;
 
-	if (new_offset) {
-		offset_set(new_dentry, 0);
-		return simple_offset_replace(new_ctx, old_dentry, new_offset);
-	}
-	return simple_offset_add(new_ctx, old_dentry);
+	simple_offset_remove(old_ctx, old_dentry);
+	offset_set(new_dentry, 0);
+	WARN_ON(simple_offset_replace(new_ctx, old_dentry, new_offset));
 }
 
 /**
@@ -386,31 +386,23 @@ int simple_offset_rename_exchange(struct inode *old_dir,
 	u32 new_index = dentry2offset(new_dentry);
 	int ret;
 
-	simple_offset_remove(old_ctx, old_dentry);
-	simple_offset_remove(new_ctx, new_dentry);
+	if (WARN_ON(!old_index || !new_index))
+		return -EINVAL;
 
-	ret = simple_offset_replace(new_ctx, old_dentry, new_index);
-	if (ret)
-		goto out_restore;
+	ret = xa_err(xa_store(&new_ctx->xa, new_index, old_dentry, GFP_KERNEL));
+	if (WARN_ON(ret))
+		return ret;
 
-	ret = simple_offset_replace(old_ctx, new_dentry, old_index);
-	if (ret) {
-		simple_offset_remove(new_ctx, old_dentry);
-		goto out_restore;
+	ret = xa_err(xa_store(&old_ctx->xa, old_index, new_dentry, GFP_KERNEL));
+	if (WARN_ON(ret)) {
+		xa_store(&new_ctx->xa, new_index, new_dentry, GFP_KERNEL);
+		return ret;
 	}
 
-	ret = simple_rename_exchange(old_dir, old_dentry, new_dir, new_dentry);
-	if (ret) {
-		simple_offset_remove(new_ctx, old_dentry);
-		simple_offset_remove(old_ctx, new_dentry);
-		goto out_restore;
-	}
+	offset_set(old_dentry, new_index);
+	offset_set(new_dentry, old_index);
+	simple_rename_exchange(old_dir, old_dentry, new_dir, new_dentry);
 	return 0;
-
-out_restore:
-	(void)simple_offset_replace(old_ctx, old_dentry, old_index);
-	(void)simple_offset_replace(new_ctx, new_dentry, new_index);
-	return ret;
 }
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 12ea9af49a89a..c6c642e910f50 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3231,7 +3231,7 @@ struct offset_ctx {
 void simple_offset_init(struct offset_ctx *octx);
 int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry);
 void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry);
-int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
+void simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
 			 struct inode *new_dir, struct dentry *new_dentry);
 int simple_offset_rename_exchange(struct inode *old_dir,
 				  struct dentry *old_dentry,
diff --git a/mm/shmem.c b/mm/shmem.c
index d24398f56660c..43c983423cf7d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3415,6 +3415,7 @@ static int shmem_rename2(struct mnt_idmap *idmap,
 {
 	struct inode *inode = d_inode(old_dentry);
 	int they_are_dirs = S_ISDIR(inode->i_mode);
+	bool had_offset = false;
 	int error;
 
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
@@ -3427,16 +3428,23 @@ static int shmem_rename2(struct mnt_idmap *idmap,
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
+	error = simple_offset_add(shmem_get_offset_ctx(new_dir), new_dentry);
+	if (error == -EBUSY)
+		had_offset = true;
+	else if (unlikely(error))
+		return error;
+
 	if (flags & RENAME_WHITEOUT) {
 		error = shmem_whiteout(idmap, old_dir, old_dentry);
-		if (error)
+		if (error) {
+			if (!had_offset)
+				simple_offset_remove(shmem_get_offset_ctx(new_dir),
+						     new_dentry);
 			return error;
+		}
 	}
 
-	error = simple_offset_rename(old_dir, old_dentry, new_dir, new_dentry);
-	if (error)
-		return error;
-
+	simple_offset_rename(old_dir, old_dentry, new_dir, new_dentry);
 	if (d_really_is_positive(new_dentry)) {
 		(void) shmem_unlink(new_dir, new_dentry);
 		if (they_are_dirs) {
-- 
2.53.0



