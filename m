Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A65C144D21;
	Thu, 13 Jun 2024 12:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281142; cv=none; b=tEB5IkWyTLIRehaoZX9xUmlaXucQwuFJ9wgjo1ZKRr6kY7sszLHYwKlPaeW6MQxZXOvC/aTrzBh8O6fwv0Lgmv9q++Ifc29H1ilCODnVUMmEfwBdnN3JzcYPFg5Ut+7VZfof1OWe1xPIM8+K3zWCJgGlDk2C/vTGnbTc5OTOsF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281142; c=relaxed/simple;
	bh=h+l3s/CKLUSbTQX3C4oAYF9ODRdTB4v3Zbu2oVXF4og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcmXhr5HUzHdtlbCL7u/SuYic1mrpceC5l0pHve6uB/TDfRdqHlrnWg7BHevIxIfFi0cvc9Hskb+Qq1tsVkouriiOHEVvC1kEct1i5u62CdIr1s5VzqJlWlFr6kRg/aErJrgvabdONze4mlBSuEuZpHkCPCilxjF8qQ7BBNEXEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWmXrLaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWmXrLaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1288BC2BBFC;
	Thu, 13 Jun 2024 12:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281142;
	bh=h+l3s/CKLUSbTQX3C4oAYF9ODRdTB4v3Zbu2oVXF4og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWmXrLaLX3LNj1OvoptoubC0akkBeTh/olq/Xfit9TqgVoGBRwbQo3Ro79JmcO+B6
	 A+L4u8bU6U/sFqpX6meViGvbP53RJeVGDuo4Eeyd4urZvTd/PUxunIdiSZ+KmsB42W
	 Yl4ZPdBgYF2DJ3TIO/W5YytW3HFL8dy0KcbCgFgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <yuchao0@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/317] f2fs: introduce FI_COMPRESS_RELEASED instead of using IMMUTABLE bit
Date: Thu, 13 Jun 2024 13:32:52 +0200
Message-ID: <20240613113253.521877248@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit c61404153eb683da9c35aad133131554861ed561 ]

Once we release compressed blocks, we used to set IMMUTABLE bit. But it turned
out it disallows every fs operations which we don't need for compression.

Let's just prevent writing data only.

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 7c5dffb3d90c ("f2fs: compress: fix to relocate check condition in f2fs_{release,reserve}_compress_blocks()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c      |  3 ++-
 fs/f2fs/f2fs.h          |  6 ++++++
 fs/f2fs/file.c          | 18 ++++++++++++------
 include/linux/f2fs_fs.h |  1 +
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 388ed7052d9b6..be6f2988ac7fc 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -902,7 +902,8 @@ static int __f2fs_cluster_blocks(struct inode *inode,
 		}
 
 		f2fs_bug_on(F2FS_I_SB(inode),
-			!compr && ret != cluster_size && !IS_IMMUTABLE(inode));
+			!compr && ret != cluster_size &&
+			!is_inode_flag_set(inode, FI_COMPRESS_RELEASED));
 	}
 fail:
 	f2fs_put_dnode(&dn);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6a9f4dcea06d6..4380df9b2d70a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -683,6 +683,7 @@ enum {
 	FI_COMPRESS_CORRUPT,	/* indicate compressed cluster is corrupted */
 	FI_MMAP_FILE,		/* indicate file was mmapped */
 	FI_ENABLE_COMPRESS,	/* enable compression in "user" compression mode */
+	FI_COMPRESS_RELEASED,	/* compressed blocks were released */
 	FI_MAX,			/* max flag, never be used */
 };
 
@@ -2650,6 +2651,7 @@ static inline void __mark_inode_dirty_flag(struct inode *inode,
 	case FI_DATA_EXIST:
 	case FI_INLINE_DOTS:
 	case FI_PIN_FILE:
+	case FI_COMPRESS_RELEASED:
 		f2fs_mark_inode_dirty_sync(inode, true);
 	}
 }
@@ -2771,6 +2773,8 @@ static inline void get_inline_info(struct inode *inode, struct f2fs_inode *ri)
 		set_bit(FI_EXTRA_ATTR, fi->flags);
 	if (ri->i_inline & F2FS_PIN_FILE)
 		set_bit(FI_PIN_FILE, fi->flags);
+	if (ri->i_inline & F2FS_COMPRESS_RELEASED)
+		set_bit(FI_COMPRESS_RELEASED, fi->flags);
 }
 
 static inline void set_raw_inline(struct inode *inode, struct f2fs_inode *ri)
@@ -2791,6 +2795,8 @@ static inline void set_raw_inline(struct inode *inode, struct f2fs_inode *ri)
 		ri->i_inline |= F2FS_EXTRA_ATTR;
 	if (is_inode_flag_set(inode, FI_PIN_FILE))
 		ri->i_inline |= F2FS_PIN_FILE;
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED))
+		ri->i_inline |= F2FS_COMPRESS_RELEASED;
 }
 
 static inline int f2fs_has_extra_attr(struct inode *inode)
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8b136f2dc2d22..cdd2630f4860f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -63,6 +63,9 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return VM_FAULT_SIGBUS;
 
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED))
+		return VM_FAULT_SIGBUS;
+
 	if (unlikely(f2fs_cp_error(sbi))) {
 		err = -EIO;
 		goto err;
@@ -3551,7 +3554,7 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (IS_IMMUTABLE(inode)) {
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -3560,8 +3563,7 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 	if (ret)
 		goto out;
 
-	F2FS_I(inode)->i_flags |= F2FS_IMMUTABLE_FL;
-	f2fs_set_inode_flags(inode);
+	set_inode_flag(inode, FI_COMPRESS_RELEASED);
 	inode->i_ctime = current_time(inode);
 	f2fs_mark_inode_dirty_sync(inode, true);
 
@@ -3727,7 +3729,7 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 
 	inode_lock(inode);
 
-	if (!IS_IMMUTABLE(inode)) {
+	if (!is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto unlock_inode;
 	}
@@ -3772,8 +3774,7 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 	up_write(&F2FS_I(inode)->i_mmap_sem);
 
 	if (ret >= 0) {
-		F2FS_I(inode)->i_flags &= ~F2FS_IMMUTABLE_FL;
-		f2fs_set_inode_flags(inode);
+		clear_inode_flag(inode, FI_COMPRESS_RELEASED);
 		inode->i_ctime = current_time(inode);
 		f2fs_mark_inode_dirty_sync(inode, true);
 	}
@@ -4130,6 +4131,11 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		goto unlock;
 	}
 
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+		ret = -EPERM;
+		goto unlock;
+	}
+
 	ret = generic_write_checks(iocb, from);
 	if (ret > 0) {
 		bool preallocated = false;
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 7dc2a06cf19a1..9a6082c572199 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -229,6 +229,7 @@ struct f2fs_extent {
 #define F2FS_INLINE_DOTS	0x10	/* file having implicit dot dentries */
 #define F2FS_EXTRA_ATTR		0x20	/* file having extra attribute */
 #define F2FS_PIN_FILE		0x40	/* file should not be gced */
+#define F2FS_COMPRESS_RELEASED	0x80	/* file released compressed blocks */
 
 struct f2fs_inode {
 	__le16 i_mode;			/* file mode */
-- 
2.43.0



