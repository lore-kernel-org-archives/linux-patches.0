Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51B03603DE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300930; cv=none; b=k2Q/QHR5Jmm7+fK9Hk7zbo5+GKPPZhWsfLTWMNo2803gu0kydHJgUrob+AMCeZ6kDOPxYJ2d8GAInyaLC8MtjPid1EdGuvMu03iEbOxuh5xjxYPTpapTIK/9T+mLnmHGxIAzHIF5Q1bnfMkI66++PoZWAceXXfgIH4dsme3kOoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300930; c=relaxed/simple;
	bh=seIdfybSOVaQLzQVSRKK5DmrZpkB8g7bFk3OaQ5vn8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2QDIfBQBIulBq98GxWPuNVQKQL38XkwOIa3xQM+zDBkpOMo6nYxL2nKGwAAY2HlNQUd4fdg1mdu4B3NgSqiHMNxpxBGQtZuW472pY1VJ0yTcT2K4kFvRSixN4gKmm+f0OjEXd1CMXP2BtTzg7EPZ8AFLw3VeAehsPPjfV20oxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uI2Qxr+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uI2Qxr+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C25C19423;
	Sat, 28 Feb 2026 17:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300930;
	bh=seIdfybSOVaQLzQVSRKK5DmrZpkB8g7bFk3OaQ5vn8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uI2Qxr+2BuOWuxfR5EmdbnUH/EafCAof5xS7TEvNkQFVbGfLRyPP7cAqg0l2uZPND
	 iuC4GsNrxQ+bK35TQ7trTl2IczewqAuOe69j80ub3frsu4JpwghCiHL5jsKNbuyGqI
	 cfd9yR/L2Dmjq2P2tUljFCoXSXJ+i4VdNl/dZyrOBbvhKb8dPZj9ERjKYOcq5L4uCU
	 L+x7ATEOt6i5LrdxvrHIThFv/538sFJMTelC2+0ezbucS7zcRhzWOQZpy+wGuikk8h
	 zNjdRlCAxWUy7KgM2cgLKCZrQ4yCS55+6VFGYif8I1iF0c6/TMTeHibOk3TRjjPBkZ
	 FtKrjV3NJH2FA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/752] ntfs: ->d_compare() must not block
Date: Sat, 28 Feb 2026 12:36:01 -0500
Message-ID: <20260228174750.1542406-50-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c    |  5 ++---
 fs/ntfs3/fsntfs.c |  4 ++--
 fs/ntfs3/inode.c  | 13 ++++++-------
 fs/ntfs3/namei.c  | 17 ++++++++---------
 fs/ntfs3/xattr.c  |  5 ++---
 5 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 1b5c865a0339a..460df046482c7 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -424,8 +424,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
-	/* Allocate PATH_MAX bytes. */
-	name = __getname();
+	name = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
 
@@ -503,7 +502,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 
 out:
 
-	__putname(name);
+	kfree(name);
 	put_indx_node(node);
 
 	if (err == 1) {
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 5ae910e9ecbda..ef0177b5c6cb0 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2640,7 +2640,7 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 	u32 uni_bytes;
 	struct ntfs_inode *ni = sbi->volume.ni;
 	/* Allocate PATH_MAX bytes. */
-	struct cpu_str *uni = __getname();
+	struct cpu_str *uni = kmalloc(PATH_MAX, GFP_KERNEL);
 
 	if (!uni)
 		return -ENOMEM;
@@ -2684,6 +2684,6 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 		err = _ni_write_inode(&ni->vfs_inode, 0);
 
 out:
-	__putname(uni);
+	kfree(uni);
 	return err;
 }
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 164fd63dff40d..205baa791f998 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1279,7 +1279,7 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 		fa |= FILE_ATTRIBUTE_READONLY;
 
 	/* Allocate PATH_MAX bytes. */
-	new_de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	new_de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!new_de) {
 		err = -ENOMEM;
 		goto out1;
@@ -1699,7 +1699,7 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	ntfs_mark_rec_free(sbi, ino, false);
 
 out2:
-	__putname(new_de);
+	kfree(new_de);
 	kfree(rp);
 
 out1:
@@ -1720,7 +1720,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	struct NTFS_DE *de;
 
 	/* Allocate PATH_MAX bytes. */
-	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -1734,7 +1734,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 
 	err = ni_add_name(ntfs_i(d_inode(dentry->d_parent)), ni, de);
 out:
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
@@ -1757,8 +1757,7 @@ int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry)
 	if (ntfs_is_meta_file(sbi, ni->mi.rno))
 		return -EINVAL;
 
-	/* Allocate PATH_MAX bytes. */
-	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -1794,7 +1793,7 @@ int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry)
 
 out:
 	ni_unlock(ni);
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 82c8ae56beee6..612923d93f4dc 100644
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
@@ -303,8 +303,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 			return err;
 	}
 
-	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -349,7 +348,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 	ni_unlock(ni);
 	ni_unlock(dir_ni);
 out:
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
@@ -407,7 +406,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	/*
 	 * Try slow way with current upcase table
 	 */
-	uni = kmem_cache_alloc(names_cachep, GFP_NOWAIT);
+	uni = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni)
 		return -ENOMEM;
 
@@ -429,7 +428,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	err = 0;
 
 out:
-	kmem_cache_free(names_cachep, uni);
+	kfree(uni);
 	return err;
 }
 
@@ -468,7 +467,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	 * Try slow way with current upcase table
 	 */
 	sbi = dentry->d_sb->s_fs_info;
-	uni1 = __getname();
+	uni1 = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni1)
 		return -ENOMEM;
 
@@ -498,7 +497,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	ret = !ntfs_cmp_names_cpu(uni1, uni2, sbi->upcase, false) ? 0 : 1;
 
 out:
-	__putname(uni1);
+	kfree(uni1);
 	return ret;
 }
 
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index e519e21596a70..142ecb3847e59 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -556,8 +556,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (unlikely(is_bad_ni(ni)))
 		return ERR_PTR(-EINVAL);
 
-	/* Allocate PATH_MAX bytes. */
-	buf = __getname();
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -588,7 +587,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (!IS_ERR(acl))
 		set_cached_acl(inode, type, acl);
 
-	__putname(buf);
+	kfree(buf);
 
 	return acl;
 }
-- 
2.51.0

