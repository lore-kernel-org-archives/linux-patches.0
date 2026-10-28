Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216606;
	b=yaVvWZFn37sEHcz81PDqyYcoLK0LdMsdr0XPSAJpzkHW4gkfiIQsqZXqry0frRkYC1Sm
	 4QoxqKwFGhweOP0P3OyJi8MZdo+KrcBYHmCKTDedEfoMQE7x84iPDLFQ4dt9uC6phHPvX
	 BpoHejBG7iBzc4cLXqsDAnfn8MvQXDchIehIspMHw7tKvYLgaspVrK6S4tkun2oWfCZOX
	 1FpUn9LneG1WSKWWh3S3Dkr6BIgZ0w2CZMfVH/gNT3L2yFnk+spvnUIVOmgZSF6qUi4bI
	 0arUDG7/8ih1UBvVXtPWfQsH+7Xo/3UKIL6aaY/uOXVJJICw5hLOum5CVTUF5IcopCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0tPcc1NrLUB8kNcoiZLLuachx9BGOD+tqyWB5Lqc2mo=;
	b=mhIUHp8LdrGE9asSM+mRr64uXUwobHdJpIgBxjWfk6UuvYgMgBlMoAfG13ekyZHAHaGq
	 /tBFrF1GCKNYQrzzOWoZ5znDer/OUbTmzm8k3t+km2WW9ztO6SsViLrVY6iZaZCCqDRX1
	 5TPMi/tFhNggH5RTOd8AwOYRqAC9xMphWD6NJU1WP4BVsRjVzT7x4y5JX6xH/PS/1bEL4
	 aAcrAhd+j7o+8Xe6lJFXS7wpZf8P4RGbKUxt2td9z1wWHJVMg5mixBfBeABo2U/W8fZ9D
	 qYhsfsFgEGi23plbV0K7HFH2GpOdPi2vBiYXaQBBrkPw3QQYRcp4ljx0ywYi2h1DkTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXF4r81u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E32606A31A;
	Wed, 28 Oct 2026 19:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXF4r81u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF631F01825;
	Wed, 28 Oct 2026 19:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216605;
	bh=0tPcc1NrLUB8kNcoiZLLuachx9BGOD+tqyWB5Lqc2mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXF4r81uOqepap7VzII2lkf3CnH3Y1/ATF4MzjzADk55DoC2ipALxDboKP5qq8t+r
	 ROQ9muUsbAI5fUQBvXEMxL9YVtjtii4haihc4gUTCjZ6k5Fi6deLo/DXUTzcy1M+c6
	 oPUztbtjejx1SvtvYbpaA0ETimRZ9FzaHwYvjhvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Colin Ian King <colin.i.king@gmail.com>,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1616/1887] ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
Date: Wed, 28 Oct 2026 18:01:52 +0100
Message-ID: <20261028170536.241602789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

[ Upstream commit 03438084a7b8621fb5c762dd3d04cff5f2630fb2 ]

Syzbot/stress-ng reported an ABBA deadlock in ext4 when exercising
concurrent xattr workloads (using the ea_inode mount/format option).

The deadlock occurs between the running transaction and the eviction
thread:
- Task 1 (stress-ng): Holds a reference to a shared mbcache_entry (ce)
  and calls ext4_xattr_inode_cache_find() -> ext4_iget() to retrieve
  the corresponding EA inode. Since the EA inode is currently being
  evicted, ext4_iget() blocks in __wait_on_freeing_inode() waiting for
  eviction to complete.
- Task 2 (eviction thread): Currently evicting the same EA inode in
  ext4_evict_ea_inode(). It calls mb_cache_entry_wait_unused(oe) which
  blocks waiting for Task 1 to release the reference to the mbcache_entry.

To break this deadlock, implement a new ext4_iget() configuration flag
named EXT4_IGET_NOWAIT. When set, perform a non-blocking lookup of the
inode via VFS's find_inode_nowait() API.

If the inode is currently being evicted (marked with I_FREEING or
I_WILL_FREE) or created (I_CREATING), or if it is not present in the VFS
inode cache (cache miss), simply skip it (returning -ENOENT) rather than
waiting for eviction/creation to complete, breaking the ABBA cycle.

Since we return -ENOENT immediately on a cache miss, we never attempt to
allocate a new inode or call iget_locked(), completely eliminating any
TOCTOU race window.

If the returned inode is I_NEW, wait for its initialization to clear via
wait_on_new_inode(). If initialization fails and the inode is unhashed
during wait_on_new_inode() waking up (e.g., due to an I/O read error in
another thread), safely drop the reference and return -ENOENT. This
unhashed check is executed unconditionally on all cache-hit pathways to
properly handle concurrent initialization failures.

Finally, standard validation checks (including is_bad_inode,
EXT4_EA_INODE_FL, file_acl, and xattr flags) are executed as normal inside
check_igot_inode() to fully guarantee VFS-layer safety.

In ext4_xattr_inode_cache_find(), invoke ext4_iget() with the new
EXT4_IGET_NOWAIT flag to perform the non-blocking cache search.

Suggested-by: Jan Kara <jack@suse.cz>
Reported-by: Colin Ian King <colin.i.king@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219283
Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Tested-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260626054821.1729-1-aditya.ansh182@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h  |  3 ++-
 fs/ext4/inode.c | 36 +++++++++++++++++++++++++++++++++---
 fs/ext4/xattr.c |  2 +-
 fs/inode.c      |  1 +
 4 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6d3f888f7e556..5ef489c9e73af 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3008,7 +3008,8 @@ typedef enum {
 	EXT4_IGET_SPECIAL =	0x0001, /* OK to iget a system inode */
 	EXT4_IGET_HANDLE = 	0x0002,	/* Inode # is from a handle */
 	EXT4_IGET_BAD =		0x0004, /* Allow to iget a bad inode */
-	EXT4_IGET_EA_INODE =	0x0008	/* Inode should contain an EA value */
+	EXT4_IGET_EA_INODE =	0x0008,	/* Inode should contain an EA value */
+	EXT4_IGET_NOWAIT =	0x0010	/* Non-blocking lookup (skip if freeing) */
 } ext4_iget_flags;
 
 extern struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 25b3844073d44..2739c9a04c8f8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4837,6 +4837,21 @@ static int check_igot_inode(struct inode *inode, ext4_iget_flags flags,
 	return -EFSCORRUPTED;
 }
 
+static int ext4_iget_match(struct inode *inode, unsigned long ino,
+			   void *data)
+{
+	if (inode->i_ino != ino)
+		return 0;
+	spin_lock(&inode->i_lock);
+	if (inode->i_state & (I_FREEING | I_WILL_FREE | I_CREATING)) {
+		spin_unlock(&inode->i_lock);
+		return -1;
+	}
+	__iget(inode);
+	spin_unlock(&inode->i_lock);
+	return 1;
+}
+
 struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 			  ext4_iget_flags flags, const char *function,
 			  unsigned int line)
@@ -4870,9 +4885,24 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
-	inode = iget_locked(sb, ino);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (flags & EXT4_IGET_NOWAIT) {
+		inode = find_inode_nowait(sb, ino, ext4_iget_match, NULL);
+		if (!inode)
+			return ERR_PTR(-ENOENT);
+
+		if (inode->i_state & I_NEW)
+			wait_on_inode(inode);
+
+		if (unlikely(inode_unhashed(inode))) {
+			iput(inode);
+			return ERR_PTR(-ENOENT);
+		}
+	} else {
+		inode = iget_locked(sb, ino);
+		if (!inode)
+			return ERR_PTR(-ENOMEM);
+	}
+
 	if (!(inode->i_state & I_NEW)) {
 		ret = check_igot_inode(inode, flags, function, line);
 		if (ret) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index a944028502f25..e66275a5d83ff 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1497,7 +1497,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 
 	while (ce) {
 		ea_inode = ext4_iget(inode->i_sb, ce->e_value,
-				     EXT4_IGET_EA_INODE);
+				     EXT4_IGET_EA_INODE | EXT4_IGET_NOWAIT);
 		if (IS_ERR(ea_inode))
 			goto next_entry;
 		ext4_xattr_inode_set_class(ea_inode);
diff --git a/fs/inode.c b/fs/inode.c
index 5c46e7bb931db..99e980ddbdceb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -443,6 +443,7 @@ void __iget(struct inode *inode)
 {
 	atomic_inc(&inode->i_count);
 }
+EXPORT_SYMBOL(__iget);
 
 /*
  * get additional reference to inode; caller must already hold one.
-- 
2.53.0



