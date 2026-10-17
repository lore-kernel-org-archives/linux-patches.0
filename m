Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFAA3AAF60;
	Sat, 17 Oct 2026 17:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258390; cv=none; b=Kp6ibmN+jNqKHQNWtuqQ6zgoBLQxbGAty18oaju5MCmOsSw6kgLb/EILK3WcHZuC0d5cFR9CqKEI8tajbCqRE4XvuwNm54/HOTqOrIBXhkbDGu2shQNms5UOO0pFVbbfG41MJyiVYAzGLOLMqb7CXmfEoa77Hz4SflD4aH9Wr/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258390; c=relaxed/simple;
	bh=U3h0iqJcDtnwLbiAB7qGQjpYrcAaLRYsWZUUzUzB9X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkb8c85dXIIBQm2Z2PdWdhic05suhQtoaY+l63YSb+9QUg6yIKZzRTJAaCevFAVvK6A6w7FtNsPUKy9IEy5zkE1oAlURB0ndU5D0L1K9GJ3Vlf3rgxFgxwzJ3+llOcHs1cDBpHa5UA6XJg9cwLcJnkOr2aqNw0EmDCMBwXZhsrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jX+00jf7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jX+00jf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F771F000C5;
	Sat, 17 Oct 2026 17:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258388;
	bh=3dtzBaL3oy4p2SDAQZWJ7Krrep7JLMIe5wcZuWBgz3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jX+00jf7co5Ei8ZOAVzVnI4Hro7YhSafqVt/AP3N09/BCsz6jtvFWwooS36iP0k9f
	 NCpsWn0xVkbenjIKubZ9dMGmuUsH0XkNzmxFWpNHKaOqwdo8jPcI1MWd85KWrZQPiY
	 S4Ggox6Ve2MAT33ZklXEuRf+xY25svngUG6u/GgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0868/1674] fs: super_set_uuid()
Date: Sat, 17 Oct 2026 17:52:20 +0200
Message-ID: <20261017160453.393604356@linuxfoundation.org>
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

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit a4af51ce229b1e1eab003966dbfebf9d80093a77 ]

Some weird old filesytems have UUID-like things that we wish to expose
as UUIDs, but are smaller; add a length field so that the new
FS_IOC_(GET|SET)UUID ioctls can handle them in generic code.

And add a helper super_set_uuid(), for setting nonstandard length uuids.

Helper is now required for the new FS_IOC_GETUUID ioctl; if
super_set_uuid() hasn't been called, the ioctl won't be supported.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Link: https://lore.kernel.org/r/20240207025624.1019754-2-kent.overstreet@linux.dev
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 3a64125730ca ("ksmbd: use volume UUID in FS_OBJECT_ID_INFORMATION")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c      |    2 +-
 fs/f2fs/super.c      |    2 +-
 fs/gfs2/ops_fstype.c |    2 +-
 fs/kernfs/mount.c    |    4 +++-
 fs/ocfs2/super.c     |    4 ++--
 fs/ubifs/super.c     |    2 +-
 fs/xfs/xfs_mount.c   |    2 +-
 include/linux/fs.h   |    9 +++++++++
 mm/shmem.c           |    4 +++-
 9 files changed, 22 insertions(+), 9 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5381,7 +5381,7 @@ static int __ext4_fill_super(struct fs_c
 		sb->s_qcop = &ext4_qctl_operations;
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 #endif
-	memcpy(&sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
+	super_set_uuid(sb, es->s_uuid, sizeof(es->s_uuid));
 
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
 	mutex_init(&sbi->s_orphan_lock);
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4483,7 +4483,7 @@ try_onemore:
 	sb->s_time_gran = 1;
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sbi, POSIX_ACL) ? SB_POSIXACL : 0);
-	memcpy(&sb->s_uuid, raw_super->uuid, sizeof(raw_super->uuid));
+	super_set_uuid(sb, (void *) raw_super->uuid, sizeof(raw_super->uuid));
 	sb->s_iflags |= SB_I_CGROUPWB;
 
 	/* init f2fs-specific super block info */
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -215,7 +215,7 @@ static void gfs2_sb_in(struct gfs2_sbd *
 
 	memcpy(sb->sb_lockproto, str->sb_lockproto, GFS2_LOCKNAME_LEN);
 	memcpy(sb->sb_locktable, str->sb_locktable, GFS2_LOCKNAME_LEN);
-	memcpy(&s->s_uuid, str->sb_uuid, 16);
+	super_set_uuid(s, str->sb_uuid, 16);
 }
 
 /**
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -360,7 +360,9 @@ int kernfs_get_tree(struct fs_context *f
 		}
 		sb->s_flags |= SB_ACTIVE;
 
-		uuid_gen(&sb->s_uuid);
+		uuid_t uuid;
+		uuid_gen(&uuid);
+		super_set_uuid(sb, uuid.b, sizeof(uuid));
 
 		down_write(&root->kernfs_supers_rwsem);
 		list_add(&info->node, &info->root->supers);
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2030,8 +2030,8 @@ static int ocfs2_initialize_super(struct
 	cbits = le32_to_cpu(di->id2.i_super.s_clustersize_bits);
 	bbits = le32_to_cpu(di->id2.i_super.s_blocksize_bits);
 	sb->s_maxbytes = ocfs2_max_file_offset(bbits, cbits);
-	memcpy(&sb->s_uuid, di->id2.i_super.s_uuid,
-	       sizeof(di->id2.i_super.s_uuid));
+	super_set_uuid(sb, di->id2.i_super.s_uuid,
+		       sizeof(di->id2.i_super.s_uuid));
 
 	osb->osb_dx_mask = (1 << (cbits - bbits)) - 1;
 
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2246,7 +2246,7 @@ static int ubifs_fill_super(struct super
 		goto out_umount;
 	}
 
-	import_uuid(&sb->s_uuid, c->uuid);
+	super_set_uuid(sb, c->uuid, sizeof(c->uuid));
 
 	mutex_unlock(&c->umount_mutex);
 	return 0;
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -62,7 +62,7 @@ xfs_uuid_mount(
 	int			hole, i;
 
 	/* Publish UUID in struct super_block */
-	uuid_copy(&mp->m_super->s_uuid, uuid);
+	super_set_uuid(mp->m_super, uuid->b, sizeof(*uuid));
 
 	if (xfs_has_nouuid(mp))
 		return 0;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1251,6 +1251,7 @@ struct super_block {
 
 	char			s_id[32];	/* Informational name */
 	uuid_t			s_uuid;		/* UUID */
+	u8			s_uuid_len;	/* Default 16, possibly smaller for weird filesystems */
 
 	unsigned int		s_max_links;
 
@@ -2453,6 +2454,14 @@ extern __printf(2, 3)
 int super_setup_bdi_name(struct super_block *sb, char *fmt, ...);
 extern int super_setup_bdi(struct super_block *sb);
 
+static inline void super_set_uuid(struct super_block *sb, const u8 *uuid, unsigned len)
+{
+	if (WARN_ON(len > sizeof(sb->s_uuid)))
+		len = sizeof(sb->s_uuid);
+	sb->s_uuid_len = len;
+	memcpy(&sb->s_uuid, uuid, len);
+}
+
 extern int current_umask(void);
 
 extern void ihold(struct inode * inode);
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4359,7 +4359,9 @@ static int shmem_fill_super(struct super
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	sb->s_flags |= SB_POSIXACL;
 #endif
-	uuid_gen(&sb->s_uuid);
+	uuid_t uuid;
+	uuid_gen(&uuid);
+	super_set_uuid(sb, uuid.b, sizeof(uuid));
 
 #ifdef CONFIG_TMPFS_QUOTA
 	if (ctx->seen & SHMEM_SEEN_QUOTA) {


