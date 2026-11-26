Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704910;
	b=Y4ktepcSkuQmmM3Dmh7Y/0jZ09kX+WwlFmU1sUFiLsTCqhuEWX2zsTvcbXvsticjqRTD
	 v+SQkbGwV85wS5JeCv2+xa4imwjFAbHJ7a6BR/qao4W59jiMJxnCSbu28Ul4JcGu1ppqO
	 H7lGOrCJ47xibdigSoC2cXqi9g1iV9UP9rzCm4rtYnIjftFMLkjTjFPyx/3OUS4nzo2nj
	 qTPfGiSjEsf0ZZzl67UNbqKlg31lznEPlVwPDiwQ7awMwiMut6/jBkHEfE/Cdq3cQ6BZW
	 OIPJCp5lA0wpYCDxc3SHsG4+Lf8ZR41Cy+345IQvF7Z30//3F92t84M77nR5ungAMtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WAlWe4JRrSm8BstegTbJoYnv1qhBUivjl/Q8X6+n0LQ=;
	b=ddGHIAs3jDgODRCSDccnGQEsXF1IJBB6W5tL47JXnF1bj6Itl97ORWbF7YIlOLXK0U6B
	 cB/zkMNxOx4SyTO1kIb4xyl6ESS+cef/hmi3KYDsXfK6Yx55s+5EWvid2W0V3KAd2RoyU
	 WOzaRlIAxzW0iI8LTLc/dCayC0TOMMtB7yLr7Y20CnMw5qUUJzounVt+k/R1hmqkE5QPX
	 IaDoJlJCTo2Zj3ExeohARyJ+wEh0vpf/4WSI9HRTJhRUoGrjjTA/Qg2zTEK0XdPTPZgB/
	 JXqjkDjFoI0ZxEqTJ9j4IDZByhCe4Dg1tsix9WaAF5xtp3hZMy1wMUVODoNQjrMhVGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5Ufa0h3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00210606A335;
	Thu, 26 Nov 2026 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5Ufa0h3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429951F000ED;
	Thu, 26 Nov 2026 14:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704909;
	bh=WAlWe4JRrSm8BstegTbJoYnv1qhBUivjl/Q8X6+n0LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5Ufa0h3Z8ulkFJN5kd2jKMDqkz1GWB9o8YVXoUk2qCz13/4DDaUCoY7UqKg2FMo6
	 kpXhQQi9bY5cj5F/rltG86hWYfxW7+BixmhekSKRVTufkHXlwbAN0Ckq+XXxN2G6aX
	 2iccK9TXibdqmlDmlORXEH4H/4ZH4oaw3+blIddc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/319] fs/9p: rework qid2ino logic
Date: Thu, 26 Nov 2026 15:36:26 +0100
Message-ID: <20261126144007.152301179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Van Hensbergen <ericvh@kernel.org>

[ Upstream commit b91a26696ef38eae1442aa03104e60bb49d2ac99 ]

This changes from a function to a macro because we can
figure out if we are 32 or 64 bit at compile time.

Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Stable-dep-of: 8bb0279930cc ("9p: skip intermediate directory entry name copy in p9dirent_read()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/v9fs_vfs.h       |  7 ++++++-
 fs/9p/vfs_dir.c        |  4 ++--
 fs/9p/vfs_inode.c      | 26 ++------------------------
 fs/9p/vfs_inode_dotl.c |  6 ++----
 4 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index bc417da7e9c1d..efdb943a51d7c 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -49,7 +49,12 @@ struct inode *v9fs_get_inode(struct super_block *sb, umode_t mode,
 int v9fs_init_inode(struct v9fs_session_info *v9ses,
 		    struct inode *inode, umode_t mode, dev_t rdev);
 void v9fs_evict_inode(struct inode *inode);
-ino_t v9fs_qid2ino(struct p9_qid *qid);
+#if (BITS_PER_LONG == 32)
+#define QID2INO(q) ((ino_t) (((q)->path+2) ^ (((q)->path) >> 32)))
+#else
+#define QID2INO(q) ((ino_t) ((q)->path+2))
+#endif
+
 void v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 		      struct super_block *sb, unsigned int flags);
 void v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode,
diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 78a9a1838142d..9786fb2c5a99a 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -134,7 +134,7 @@ static int v9fs_dir_readdir(struct file *file, struct dir_context *ctx)
 			}
 
 			over = !dir_emit(ctx, st.name, strlen(st.name),
-					 v9fs_qid2ino(&st.qid), dt_type(&st));
+					QID2INO(&st.qid), dt_type(&st));
 			p9stat_free(&st);
 			if (over)
 				return 0;
@@ -196,7 +196,7 @@ static int v9fs_dir_readdir_dotl(struct file *file, struct dir_context *ctx)
 
 			if (!dir_emit(ctx, curdirent.d_name,
 				      strlen(curdirent.d_name),
-				      v9fs_qid2ino(&curdirent.qid),
+				      QID2INO(&curdirent.qid),
 				      curdirent.d_type))
 				return 0;
 
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 6b9c6590a2659..9b35a9f6f86a7 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -442,7 +442,6 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
 	dev_t rdev;
 	int retval;
 	umode_t umode;
-	unsigned long i_ino;
 	struct inode *inode;
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
 	int (*test)(struct inode *inode, void *data);
@@ -452,8 +451,7 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
 	else
 		test = v9fs_test_inode;
 
-	i_ino = v9fs_qid2ino(qid);
-	inode = iget5_locked(sb, i_ino, test, v9fs_set_inode, st);
+	inode = iget5_locked(sb, QID2INO(qid), test, v9fs_set_inode, st);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
@@ -463,7 +461,7 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
 	 * FIXME!! we may need support for stale inodes
 	 * later.
 	 */
-	inode->i_ino = i_ino;
+	inode->i_ino = QID2INO(qid);
 	umode = p9mode2unixmode(v9ses, st, &rdev);
 	retval = v9fs_init_inode(v9ses, inode, umode, rdev);
 	if (retval)
@@ -1212,26 +1210,6 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 	v9inode->cache_validity &= ~V9FS_INO_INVALID_ATTR;
 }
 
-/**
- * v9fs_qid2ino - convert qid into inode number
- * @qid: qid to hash
- *
- * BUG: potential for inode number collisions?
- */
-
-ino_t v9fs_qid2ino(struct p9_qid *qid)
-{
-	u64 path = qid->path + 2;
-	ino_t i = 0;
-
-	if (sizeof(ino_t) == sizeof(path))
-		memcpy(&i, &path, sizeof(ino_t));
-	else
-		i = (ino_t) (path ^ (path >> 32));
-
-	return i;
-}
-
 /**
  * v9fs_vfs_get_link - follow a symlink path
  * @dentry: dentry for symlink
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 0f73aa26ddf4b..619c62f564e57 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -104,7 +104,6 @@ static struct inode *v9fs_qid_iget_dotl(struct super_block *sb,
 					int new)
 {
 	int retval;
-	unsigned long i_ino;
 	struct inode *inode;
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
 	int (*test)(struct inode *inode, void *data);
@@ -114,8 +113,7 @@ static struct inode *v9fs_qid_iget_dotl(struct super_block *sb,
 	else
 		test = v9fs_test_inode_dotl;
 
-	i_ino = v9fs_qid2ino(qid);
-	inode = iget5_locked(sb, i_ino, test, v9fs_set_inode_dotl, st);
+	inode = iget5_locked(sb, QID2INO(qid), test, v9fs_set_inode_dotl, st);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
@@ -125,7 +123,7 @@ static struct inode *v9fs_qid_iget_dotl(struct super_block *sb,
 	 * FIXME!! we may need support for stale inodes
 	 * later.
 	 */
-	inode->i_ino = i_ino;
+	inode->i_ino = QID2INO(qid);
 	retval = v9fs_init_inode(v9ses, inode,
 				 st->st_mode, new_decode_dev(st->st_rdev));
 	if (retval)
-- 
2.53.0



