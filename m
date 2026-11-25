Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619437;
	b=RyUnilEtIS8W3QpiEAxLqbPVEEWZ8Tfp77m72I4hEX3nTOXkHLhZZS5NhHO6iXyQ96gf
	 JnRpDtCN2qLpAXP29M68WufSUur1NtAiDL8DqJNZIaJIOXIL6HKrresgw9uV6nBFhRYwO
	 K9NvWzzTRQsOwdkVkc8ZuOelJmDWoJZxW/DEl5cDZ0jJjxJAtZUkj2PQqqdreGo6X1cMV
	 1KN8WHoEcA+xPb9sIwAsdMLRi1xEL9TO4i2ajdahXv5aKw/xm9D9Y26DHYdm0JzlpHtgV
	 f+Fz294hgZkWGXRhxpMjtc6Nr9AVlEtReDP62L30KnaHgajhTxqUvmjpVOwWd6lEgww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T4Vxr69/Ci0dZlONi4/r27ZK1FVCZuATFXj/NMY8ld8=;
	b=Qx4fI0JFjRf6OrBKtexx2spylSD4V+MorQqd9Sheh9Bv+4Ef7753u52ijy23+feUVP4/
	 L1ARRFKMGGOtBbzKr6+H6/Bp1EKEvoLc5azdKwocbGIYHjckOgcPU0P9Zemcaz6ha8mMT
	 ZvmS52JjsIVQDr4TvYsmlfF6hhDpAyHANcDWWMovx/8LgH9REAd1jDhY1GKcn15/6zwSk
	 D00do7EtneyxUdbtEW5rtISYpAPRsIhVIsgpDnk74pfEkm46hgXSYlTG8txsC5tP7oa61
	 D0yNNfKies2UO/s1mRG047KIH/77oZAEZJYpDdGbr1Ub7BCF1mHvm/R0gyxuHqBI1ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1dbXuZo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23DF606A687;
	Wed, 25 Nov 2026 15:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1dbXuZo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4791F1F000C0;
	Wed, 25 Nov 2026 15:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619436;
	bh=T4Vxr69/Ci0dZlONi4/r27ZK1FVCZuATFXj/NMY8ld8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1dbXuZo7HvvCZyR4OldlHqg3uge6dK1rUYWgH7JqqvSyjAYlfyTYnLGl6xHhIWup
	 lsHRW3SsUDBkCX1/GipdHeuoud22CgSCiq6SNTopQ91TuuPsGrDLv2Gll4VGaxPK+M
	 Dg5OJuH41wDWlCZeg98I7FJczK9z5WmKBBabuCGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0594/1005] libfs: make i_rwsem the lock of the offset tree
Date: Wed, 25 Nov 2026 15:32:12 +0100
Message-ID: <20261125143835.657636456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit e7d73cef9726bea49de97ae1fd76405df4050a75 upstream.

The offset tree of a directory is only changed with the directory's
i_rwsem held exclusive and offset_readdir() walks it with i_rwsem held
shared. But the maple tree doesn't know that. It is set up with its
internal spinlock, which every mtree_*() helper takes, and readdir takes
rcu_read_lock() around each lookup.

The next patch makes readdir keep one ma_state across dir_emit(), which
can sleep. That is safe because no writer can run while readdir holds
i_rwsem. But the maple tree only allows keeping a ma_state across a
sleep if it is protected by the tree's lock. A reader that relies on
rcu_read_lock() has to mas_pause() before it drops it, and that means a
walk from the root for every entry again.

So tell the tree what protects it. Initialize it with
MT_FLAGS_LOCK_EXTERN and the directory's i_rwsem as its lock and switch
the writers from the mtree_*() helpers to the mas_*() api. They all run
with i_rwsem held exclusive already. With lockdep enabled the maple tree
now also checks that every writer holds i_rwsem exclusive.

Nothing can reach the offset tree anymore when the directory inode is
destroyed. So clear the external lock with mt_on_stack() and destroy the
tree with __mt_destroy() instead of taking i_rwsem in ->destroy_inode().

Cc: stable@vger.kernel.org # v6.14+
Link: https://patch.msgid.link/20261101-work-libfs-offset_readdir-v2-1-c621125b56d1@kernel.org
Reviewed-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c         |   46 +++++++++++++++++++++++++++++-----------------
 include/linux/fs.h |    2 +-
 mm/shmem.c         |    2 +-
 3 files changed, 31 insertions(+), 19 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -263,17 +263,18 @@ static long dentry2offset(struct dentry
 	return (long)dentry->d_fsdata;
 }
 
-static struct lock_class_key simple_offset_lock_class;
-
 /**
  * simple_offset_init - initialize an offset_ctx
  * @octx: directory offset map to be initialized
+ * @dir: the directory @octx belongs to
  *
+ * The directory's i_rwsem is the lock of the offset map. Writers hold it
+ * exclusive, offset_readdir() holds it shared.
  */
-void simple_offset_init(struct offset_ctx *octx)
+void simple_offset_init(struct offset_ctx *octx, struct inode *dir)
 {
-	mt_init_flags(&octx->mt, MT_FLAGS_ALLOC_RANGE);
-	lockdep_set_class(&octx->mt.ma_lock, &simple_offset_lock_class);
+	mt_init_flags(&octx->mt, MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN);
+	mt_set_external_lock(&octx->mt, &dir->i_rwsem);
 	octx->next_offset = DIR_OFFSET_MIN;
 }
 
@@ -296,12 +297,13 @@ int simple_offset_add(struct offset_ctx
 	unsigned long offset;
 	int ret;
 
+	MA_STATE(mas, &octx->mt, 0, 0);
+
 	if (dentry2offset(dentry) != 0)
 		return -EBUSY;
 
-	ret = mtree_alloc_cyclic(&octx->mt, &offset, dentry, DIR_OFFSET_MIN,
-				 DIR_OFFSET_MAX, &octx->next_offset,
-				 GFP_KERNEL);
+	ret = mas_alloc_cyclic(&mas, &offset, dentry, DIR_OFFSET_MIN,
+			       DIR_OFFSET_MAX, &octx->next_offset, GFP_KERNEL);
 	if (unlikely(ret < 0))
 		return ret == -EBUSY ? -ENOSPC : ret;
 
@@ -314,7 +316,9 @@ static int simple_offset_replace(struct
 {
 	int ret;
 
-	ret = mtree_store(&octx->mt, offset, dentry, GFP_KERNEL);
+	MA_STATE(mas, &octx->mt, offset, offset);
+
+	ret = mas_store_gfp(&mas, dentry, GFP_KERNEL);
 	if (ret)
 		return ret;
 	offset_set(dentry, offset);
@@ -329,13 +333,14 @@ static int simple_offset_replace(struct
  */
 void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry)
 {
-	long offset;
+	long offset = dentry2offset(dentry);
+
+	MA_STATE(mas, &octx->mt, offset, offset);
 
-	offset = dentry2offset(dentry);
 	if (offset == 0)
 		return;
 
-	mtree_erase(&octx->mt, offset);
+	mas_erase(&mas);
 	offset_set(dentry, 0);
 }
 
@@ -393,16 +398,20 @@ int simple_offset_rename_exchange(struct
 	long new_index = dentry2offset(new_dentry);
 	int ret;
 
+	MA_STATE(old_mas, &old_ctx->mt, old_index, old_index);
+	MA_STATE(new_mas, &new_ctx->mt, new_index, new_index);
+
 	if (WARN_ON(!old_index || !new_index))
 		return -EINVAL;
 
-	ret = mtree_store(&new_ctx->mt, new_index, old_dentry, GFP_KERNEL);
+	ret = mas_store_gfp(&new_mas, old_dentry, GFP_KERNEL);
 	if (WARN_ON(ret))
 		return ret;
 
-	ret = mtree_store(&old_ctx->mt, old_index, new_dentry, GFP_KERNEL);
+	ret = mas_store_gfp(&old_mas, new_dentry, GFP_KERNEL);
 	if (WARN_ON(ret)) {
-		mtree_store(&new_ctx->mt, new_index, new_dentry, GFP_KERNEL);
+		mas_set(&new_mas, new_index);
+		mas_store_gfp(&new_mas, new_dentry, GFP_KERNEL);
 		return ret;
 	}
 
@@ -417,11 +426,14 @@ int simple_offset_rename_exchange(struct
  * @octx: directory offset ctx that is about to be destroyed
  *
  * During fs teardown (eg. umount), a directory's offset map might still
- * contain entries. xa_destroy() cleans out anything that remains.
+ * contain entries. __mt_destroy() cleans out anything that remains.
+ * Nothing can reach the map of a directory that is being destroyed, so
+ * this runs without the directory's i_rwsem.
  */
 void simple_offset_destroy(struct offset_ctx *octx)
 {
-	mtree_destroy(&octx->mt);
+	mt_on_stack(octx->mt);
+	__mt_destroy(&octx->mt);
 }
 
 /**
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3328,7 +3328,7 @@ struct offset_ctx {
 	unsigned long		next_offset;
 };
 
-void simple_offset_init(struct offset_ctx *octx);
+void simple_offset_init(struct offset_ctx *octx, struct inode *dir);
 int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry);
 void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry);
 void simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3131,7 +3131,7 @@ static struct inode *__shmem_get_inode(s
 		inode->i_size = 2 * BOGO_DIRENT_SIZE;
 		inode->i_op = &shmem_dir_inode_operations;
 		inode->i_fop = &simple_offset_dir_operations;
-		simple_offset_init(shmem_get_offset_ctx(inode));
+		simple_offset_init(shmem_get_offset_ctx(inode), inode);
 		break;
 	case S_IFLNK:
 		/*


