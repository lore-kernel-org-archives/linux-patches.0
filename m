Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B5E3FA5D5;
	Wed, 20 May 2026 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301555; cv=none; b=UWT14+qRNDl0i4JQTPbPz9YmqQK4YcheSqU3wrnQGNYrEwxnMWClXZDK7F+93rQSk5OMRy/DLOhhbK5VRlUXEynhLjrO0vf9dd0YUvvWI/IZlktYq2VKG4Y38pux+ww4AqKJv0cVMb8XZ3CPi1ripZcbaV5oFBFn6G8VVZAlg1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301555; c=relaxed/simple;
	bh=xd8euNb/V6ba7MqdZ9/GwzOR2nhNd8zDcLW98ncGK3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVD36PQZPvHJ9aYEu26IXQu96ygoXi4RbucVG078oqjynBa9seH8/pvgALr9nLchh7BE6+/yhO5yIxVO4S8y+3xDqxdq6OFWQX5Af4JJyG7a54/00n5e4UxnwikmA/JwrgOSshGkK58xouyVDNNJBe7D/ZByw574r3FvR/blnJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLbipEmJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLbipEmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073561F000E9;
	Wed, 20 May 2026 18:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301554;
	bh=Fiz9+7Z59Igv3fbsrZ/438rpccF6zUd8mlrVjJJ1Zgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WLbipEmJfaf6yALANTE6B3I78QzYwQg3R1GAqOkv02E1riLRgTiAKk+UrZI5BL1zE
	 za24yY8OX6XQ9SNKpZ7GMHPxEQM/lFyGhR5BBN9SX/JBKJOIdZHjFoeH6GaOsL17Nq
	 U6cJBzr5SBBaEc8+MEGuc6beLRTwn3rckGjYQNPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Li hongliang <1468888505@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 598/666] ntfs: ->d_compare() must not block
Date: Wed, 20 May 2026 18:23:29 +0200
Message-ID: <20260520162124.228427208@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit ca2a04e84af79596e5cd9cfe697d5122ec39c8ce ]

... so don't use __getname() there.  Switch it (and ntfs_d_hash(), while
we are at it) to kmalloc(PATH_MAX, GFP_NOWAIT).  Yes, ntfs_d_hash()
almost certainly can do with smaller allocations, but let ntfs folks
deal with that - keep the allocation size as-is for now.

Stop abusing names_cachep in ntfs, period - various uses of that thing
in there have nothing to do with pathnames; just use k[mz]alloc() and
be done with that.  For now let's keep sizes as-in, but AFAICS none of
the users actually want PATH_MAX.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c    |  5 ++---
 fs/ntfs3/fsntfs.c |  4 ++--
 fs/ntfs3/inode.c  | 13 ++++++-------
 fs/ntfs3/namei.c  | 17 ++++++++---------
 fs/ntfs3/xattr.c  |  5 ++---
 5 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 600e66035c1b7..522ebc14b1fbd 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -425,8 +425,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
-	/* Allocate PATH_MAX bytes. */
-	name = __getname();
+	name = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
 
@@ -504,7 +503,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 
 out:
 
-	__putname(name);
+	kfree(name);
 	put_indx_node(node);
 
 	if (err == 1) {
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 37c5d9a1f77b7..5972f160e566e 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2670,7 +2670,7 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 	u32 uni_bytes;
 	struct ntfs_inode *ni = sbi->volume.ni;
 	/* Allocate PATH_MAX bytes. */
-	struct cpu_str *uni = __getname();
+	struct cpu_str *uni = kmalloc(PATH_MAX, GFP_KERNEL);
 
 	if (!uni)
 		return -ENOMEM;
@@ -2714,6 +2714,6 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 		err = _ni_write_inode(&ni->vfs_inode, 0);
 
 out:
-	__putname(uni);
+	kfree(uni);
 	return err;
 }
\ No newline at end of file
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 8113d47b0ceb9..b50c9dff327d2 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1301,7 +1301,7 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 		fa |= FILE_ATTRIBUTE_READONLY;
 
 	/* Allocate PATH_MAX bytes. */
-	new_de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	new_de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!new_de) {
 		err = -ENOMEM;
 		goto out1;
@@ -1713,7 +1713,7 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	ntfs_mark_rec_free(sbi, ino, false);
 
 out2:
-	__putname(new_de);
+	kfree(new_de);
 	kfree(rp);
 
 out1:
@@ -1734,7 +1734,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	struct NTFS_DE *de;
 
 	/* Allocate PATH_MAX bytes. */
-	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -1748,7 +1748,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 
 	err = ni_add_name(ntfs_i(d_inode(dentry->d_parent)), ni, de);
 out:
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
@@ -1771,8 +1771,7 @@ int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry)
 	if (ntfs_is_meta_file(sbi, ni->mi.rno))
 		return -EINVAL;
 
-	/* Allocate PATH_MAX bytes. */
-	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -1808,7 +1807,7 @@ int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry)
 
 out:
 	ni_unlock(ni);
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 71a5a959a48cb..fa4f7d9f38454 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -68,7 +68,7 @@ static struct dentry *ntfs_lookup(struct inode *dir, struct dentry *dentry,
 				  u32 flags)
 {
 	struct ntfs_inode *ni = ntfs_i(dir);
-	struct cpu_str *uni = __getname();
+	struct cpu_str *uni = kmalloc(PATH_MAX, GFP_KERNEL);
 	struct inode *inode;
 	int err;
 
@@ -85,7 +85,7 @@ static struct dentry *ntfs_lookup(struct inode *dir, struct dentry *dentry,
 			inode = dir_search_u(dir, uni, NULL);
 			ni_unlock(ni);
 		}
-		__putname(uni);
+		kfree(uni);
 	}
 
 	/*
@@ -287,8 +287,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 			return err;
 	}
 
-	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -333,7 +332,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 	ni_unlock(ni);
 	ni_unlock(dir_ni);
 out:
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
@@ -391,7 +390,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	/*
 	 * Try slow way with current upcase table
 	 */
-	uni = kmem_cache_alloc(names_cachep, GFP_NOWAIT);
+	uni = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni)
 		return -ENOMEM;
 
@@ -413,7 +412,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	err = 0;
 
 out:
-	kmem_cache_free(names_cachep, uni);
+	kfree(uni);
 	return err;
 }
 
@@ -452,7 +451,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	 * Try slow way with current upcase table
 	 */
 	sbi = dentry->d_sb->s_fs_info;
-	uni1 = __getname();
+	uni1 = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni1)
 		return -ENOMEM;
 
@@ -482,7 +481,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	ret = !ntfs_cmp_names_cpu(uni1, uni2, sbi->upcase, false) ? 0 : 1;
 
 out:
-	__putname(uni1);
+	kfree(uni1);
 	return ret;
 }
 
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index e0055dcf8fe38..6861c09d66d77 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -552,8 +552,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	int err;
 	void *buf;
 
-	/* Allocate PATH_MAX bytes. */
-	buf = __getname();
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -584,7 +583,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (!IS_ERR(acl))
 		set_cached_acl(inode, type, acl);
 
-	__putname(buf);
+	kfree(buf);
 
 	return acl;
 }
-- 
2.53.0



