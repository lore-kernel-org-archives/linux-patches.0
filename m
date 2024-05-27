Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87613168C4;
	Mon, 27 May 2024 19:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837845; cv=none; b=lmwFVFiyxwo7+kRLzxHf38G/uYHxC3fWwCkJpy3QFFUPI5YNtDZUjjyXbBQEZKW1VknbIKkI3oi8gajv5js9Tu0d2i/KMIqOgl7Pm2QAzJ/iHGJ/se5z7FeYlD7hyV6RztPGMqJEPEdK+ggPU1KJiNH70M5yCJNL3dsyGpGl7Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837845; c=relaxed/simple;
	bh=5vE6MmrPDwAXiLkaJGrkmVAPNHFs7XnG/hAsB6Gxoaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swaM7+oqi6G240C6XN0iISg2knRDeWfphPP7gV+qRI8YkI2sevMiPS0ROMR3pFPFNsngALwv8vYebl6vDfdWHBoZfNsUr+e2gxvUAnSrLqwDw4RY+gIngW1efadC+pWa8Oanel2PIQ1iq8qegYwGQtwKioQFhUbi2EXiK/9IRKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElaUZopL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElaUZopL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173CDC2BBFC;
	Mon, 27 May 2024 19:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837845;
	bh=5vE6MmrPDwAXiLkaJGrkmVAPNHFs7XnG/hAsB6Gxoaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElaUZopL79Sxuu4T8F7hInyQx8s4GGzzVUp9c0BtRNDS2E0YrpGBJvtTnich7PXIT
	 D9/mJd2E3ejzP89gBNQB3bhkiOyauGCBAM7D0+8bJgr25tgAJtxvee4gw37tkBvFGM
	 tsuNDRj3ta9F8moRbIBfBaEHaLuKaWje479ti6e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 130/493] libfs: Add simple_offset_empty()
Date: Mon, 27 May 2024 20:52:12 +0200
Message-ID: <20240527185634.735560043@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ecba88a3b32d733d41e27973e25b2bc580f64281 ]

For simple filesystems that use directory offset mapping, rely
strictly on the directory offset map to tell when a directory has
no children.

After this patch is applied, the emptiness test holds only the RCU
read lock when the directory being tested has no children.

In addition, this adds another layer of confirmation that
simple_offset_add/remove() are working as expected.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/170820143463.6328.7872919188371286951.stgit@91.116.238.104.host.secureserver.net
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 23cdd0eed3f1 ("libfs: Fix simple_offset_rename_exchange()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c         | 32 ++++++++++++++++++++++++++++++++
 include/linux/fs.h |  1 +
 mm/shmem.c         |  4 ++--
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index f0045db739df8..f7f92a49a4182 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -313,6 +313,38 @@ void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry)
 	offset_set(dentry, 0);
 }
 
+/**
+ * simple_offset_empty - Check if a dentry can be unlinked
+ * @dentry: dentry to be tested
+ *
+ * Returns 0 if @dentry is a non-empty directory; otherwise returns 1.
+ */
+int simple_offset_empty(struct dentry *dentry)
+{
+	struct inode *inode = d_inode(dentry);
+	struct offset_ctx *octx;
+	struct dentry *child;
+	unsigned long index;
+	int ret = 1;
+
+	if (!inode || !S_ISDIR(inode->i_mode))
+		return ret;
+
+	index = DIR_OFFSET_MIN;
+	octx = inode->i_op->get_offset_ctx(inode);
+	xa_for_each(&octx->xa, index, child) {
+		spin_lock(&child->d_lock);
+		if (simple_positive(child)) {
+			spin_unlock(&child->d_lock);
+			ret = 0;
+			break;
+		}
+		spin_unlock(&child->d_lock);
+	}
+
+	return ret;
+}
+
 /**
  * simple_offset_rename_exchange - exchange rename with directory offsets
  * @old_dir: parent of dentry being moved
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 08ecac9d7b8ba..e684b9fa64819 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3266,6 +3266,7 @@ struct offset_ctx {
 void simple_offset_init(struct offset_ctx *octx);
 int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry);
 void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry);
+int simple_offset_empty(struct dentry *dentry);
 int simple_offset_rename_exchange(struct inode *old_dir,
 				  struct dentry *old_dentry,
 				  struct inode *new_dir,
diff --git a/mm/shmem.c b/mm/shmem.c
index 5853f3ae36e53..0e951fe9f44cc 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3368,7 +3368,7 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
 
 static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	if (!simple_empty(dentry))
+	if (!simple_offset_empty(dentry))
 		return -ENOTEMPTY;
 
 	drop_nlink(d_inode(dentry));
@@ -3425,7 +3425,7 @@ static int shmem_rename2(struct mnt_idmap *idmap,
 		return simple_offset_rename_exchange(old_dir, old_dentry,
 						     new_dir, new_dentry);
 
-	if (!simple_empty(new_dentry))
+	if (!simple_offset_empty(new_dentry))
 		return -ENOTEMPTY;
 
 	if (flags & RENAME_WHITEOUT) {
-- 
2.43.0



