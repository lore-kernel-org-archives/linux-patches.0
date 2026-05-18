Received: from n169-111.mail.139.com (n169-111.mail.139.com [120.232.169.111])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA0072631;
	Mon, 18 May 2026 04:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779078296; cv=none; b=GyRGPxmVGYxK1Llzz4NzTS0LFlSXpY3Um6tyCRJHQ4ZH0SKtdJqQcnBZrraoQoGB7rxvgbRwA5Tu9qAtiKTRWE3+dQa9flbahUUrpgBEbF9lMhhpO0r+MhSnJWfoTA45Q8M59nmjgBZOrWRitZj/ujn6XZ+LDT6UkdFCqZpRPI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779078296; c=relaxed/simple;
	bh=2kGfG/QFvpPuYLFnnCltNJVHsYdYT4CVHgSM1heSi48=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xqu6q4I+TdXDJFX+XQrTrhnnqZXUH3pcZrrVqJjPppfslnKvOO7gfN2C92uPGJ5RGLjGVAwq2TTdg3zlx7ZMX6SBy3HW3VfnYygSyTtdV6UtYWYJw+if4x4IbRfMiuS2etuQzzLiRQtbT03z3Dl4ShJf1mdv0T8fPZ5rzsXjc3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=H4Ku3cn8; arc=none smtp.client-ip=120.232.169.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="H4Ku3cn8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=H4Ku3cn83CTvT0gGZdYHzvuqWw6KTlM+WopubAziz5I/KBY1fniKCMV7FA0hF5pEsi5aHjB0ilAYa
	 coGxvAqE5Xipay5z6ofVBKPkwx/6tqKvw1vqgv4kHV97Z6STkYM+2wTYZXa1nCx7ZvNW9dRXwYm8Va
	 mhSImpoFcXNDeXJM=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-15-12004 (RichMail) with SMTP id 2ee46a0a93d4435-0144e;
	Mon, 18 May 2026 12:21:41 +0800 (CST)
X-RM-TRANSID:2ee46a0a93d4435-0144e
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	viro@zeniv.linux.org.uk
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	almaz.alexandrovich@paragon-software.com,
	ntfs3@lists.linux.dev
Subject: [PATCH 6.6.y] ntfs: ->d_compare() must not block
Date: Mon, 18 May 2026 12:21:40 +0800
Message-Id: <20260518042140.489545-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
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
Signed-off-by: Li hongliang <1468888505@139.com>
---
 fs/ntfs3/dir.c    |  5 ++---
 fs/ntfs3/fsntfs.c |  4 ++--
 fs/ntfs3/inode.c  | 13 ++++++-------
 fs/ntfs3/namei.c  | 17 ++++++++---------
 fs/ntfs3/xattr.c  |  5 ++---
 5 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 6b93c909bdc9..894fd44164b4 100644
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
index e17d4c1ba06f..a38547bd12bb 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2666,7 +2666,7 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 	struct ntfs_inode *ni = sbi->volume.ni;
 	const u8 max_ulen = 0x80; /* TODO: use attrdef to get maximum length */
 	/* Allocate PATH_MAX bytes. */
-	struct cpu_str *uni = __getname();
+	struct cpu_str *uni = kmalloc(PATH_MAX, GFP_KERNEL);
 
 	if (!uni)
 		return -ENOMEM;
@@ -2709,6 +2709,6 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 		err = _ni_write_inode(&ni->vfs_inode, 0);
 
 out:
-	__putname(uni);
+	kfree(uni);
 	return err;
 }
\ No newline at end of file
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index ce381eafd084..787e15ba0ca4 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1327,7 +1327,7 @@ struct inode *ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 		fa |= FILE_ATTRIBUTE_READONLY;
 
 	/* Allocate PATH_MAX bytes. */
-	new_de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	new_de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!new_de) {
 		err = -ENOMEM;
 		goto out1;
@@ -1733,7 +1733,7 @@ struct inode *ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	ntfs_mark_rec_free(sbi, ino, false);
 
 out2:
-	__putname(new_de);
+	kfree(new_de);
 	kfree(rp);
 
 out1:
@@ -1756,7 +1756,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	struct NTFS_DE *de;
 
 	/* Allocate PATH_MAX bytes. */
-	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -1770,7 +1770,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 
 	err = ni_add_name(ntfs_i(d_inode(dentry->d_parent)), ni, de);
 out:
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
@@ -1793,8 +1793,7 @@ int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry)
 	if (ntfs_is_meta_file(sbi, ni->mi.rno))
 		return -EINVAL;
 
-	/* Allocate PATH_MAX bytes. */
-	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -1830,7 +1829,7 @@ int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry)
 
 out:
 	ni_unlock(ni);
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index f5901c23ab93..1b0c075c1485 100644
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
@@ -304,8 +304,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 			return err;
 	}
 
-	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -350,7 +349,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 	ni_unlock(ni);
 	ni_unlock(dir_ni);
 out:
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
@@ -497,7 +496,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	/*
 	 * Try slow way with current upcase table
 	 */
-	uni = kmem_cache_alloc(names_cachep, GFP_NOWAIT);
+	uni = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni)
 		return -ENOMEM;
 
@@ -519,7 +518,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	err = 0;
 
 out:
-	kmem_cache_free(names_cachep, uni);
+	kfree(uni);
 	return err;
 }
 
@@ -558,7 +557,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	 * Try slow way with current upcase table
 	 */
 	sbi = dentry->d_sb->s_fs_info;
-	uni1 = __getname();
+	uni1 = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni1)
 		return -ENOMEM;
 
@@ -588,7 +587,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	ret = !ntfs_cmp_names_cpu(uni1, uni2, sbi->upcase, false) ? 0 : 1;
 
 out:
-	__putname(uni1);
+	kfree(uni1);
 	return ret;
 }
 
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 72bceb8cd164..a03b4bce5fbf 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -551,8 +551,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	int err;
 	void *buf;
 
-	/* Allocate PATH_MAX bytes. */
-	buf = __getname();
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -583,7 +582,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (!IS_ERR(acl))
 		set_cached_acl(inode, type, acl);
 
-	__putname(buf);
+	kfree(buf);
 
 	return acl;
 }
-- 
2.34.1


