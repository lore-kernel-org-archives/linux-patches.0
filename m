Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715AF11C8D
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57B1C433C7;
	Mon, 28 Aug 2023 10:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219537;
	bh=d4UEUQd81kwTenfdHpOBMpfx6i0iJBIIukrwGH3k3p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUvDkCwjpgsvJHRjeNiqk+kloLR/jS9KkdE18LOca4855FHeOMfa3aOxrYKlrzY7O
	 xm92eM0fWKo/SpvMWuUVmGAWOGw3HygevYKldEbNxbZIK2ZPD7j0KKLs0Io5BJtv1x
	 YhuWPcpIZUBHREMmtWcUhhI9iGCQi0XWyDqw3hlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 71/89] nfs: use vfs setgid helper
Date: Mon, 28 Aug 2023 12:14:12 +0200
Message-ID: <20230828101152.577700935@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
References: <20230828101150.163430842@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 4f704d9a8352f5c0a8fcdb6213b934630342bd44 upstream.

We've aligned setgid behavior over multiple kernel releases. The details
can be found in the following two merge messages:
cf619f891971 ("Merge tag 'fs.ovl.setgid.v6.2')
426b4ca2d6a5 ("Merge tag 'fs.setgid.v6.0')
Consistent setgid stripping behavior is now encapsulated in the
setattr_should_drop_sgid() helper which is used by all filesystems that
strip setgid bits outside of vfs proper. Switch nfs to rely on this
helper as well. Without this patch the setgid stripping tests in
xfstests will fail.

Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Message-Id: <20230313-fs-nfs-setgid-v2-1-9a59f436cfc0@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ Harshit: backport to 5.15.y]
    fs/internal.h -- minor conflcit due to code change differences.
    include/linux/fs.h -- Used struct user_namespace *mnt_userns
                          instead of struct mnt_idmap *idmap
    fs/nfs/inode.c -- Used init_user_ns instead of nop_mnt_idmap ]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c          |    1 +
 fs/internal.h      |    2 --
 fs/nfs/inode.c     |    4 +---
 include/linux/fs.h |    2 ++
 4 files changed, 4 insertions(+), 5 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -47,6 +47,7 @@ int setattr_should_drop_sgid(struct user
 		return ATTR_KILL_SGID;
 	return 0;
 }
+EXPORT_SYMBOL(setattr_should_drop_sgid);
 
 /**
  * setattr_should_drop_suidgid - determine whether the set{g,u}id bit needs to
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -235,5 +235,3 @@ int do_setxattr(struct user_namespace *m
 /*
  * fs/attr.c
  */
-int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
-			     const struct inode *inode);
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -731,9 +731,7 @@ void nfs_setattr_update_inode(struct ino
 		if ((attr->ia_valid & ATTR_KILL_SUID) != 0 &&
 		    inode->i_mode & S_ISUID)
 			inode->i_mode &= ~S_ISUID;
-		if ((attr->ia_valid & ATTR_KILL_SGID) != 0 &&
-		    (inode->i_mode & (S_ISGID | S_IXGRP)) ==
-		     (S_ISGID | S_IXGRP))
+		if (setattr_should_drop_sgid(&init_user_ns, inode))
 			inode->i_mode &= ~S_ISGID;
 		if ((attr->ia_valid & ATTR_MODE) != 0) {
 			int mode = attr->ia_mode & S_IALLUGO;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3135,6 +3135,8 @@ extern struct inode *new_inode(struct su
 extern void free_inode_nonrcu(struct inode *inode);
 extern int setattr_should_drop_suidgid(struct user_namespace *, struct inode *);
 extern int file_remove_privs(struct file *);
+int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
+			     const struct inode *inode);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 static inline void insert_inode_hash(struct inode *inode)


