Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87A4611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A473C433C7;
	Mon, 28 Aug 2023 10:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218830;
	bh=J2era8vTEqx6OOkKf1EP/VdcSWCLuzWpK5zzF+T/gXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUrzBDN7FoMzbimB31KOK0+ULKrkjxa3LKVZe9WQP39FqQjMt7NaoLAUmdYyVGJ4G
	 a7S4dVaXrwHKB5MARTi0lK272q9cbTiMWAXfbYwx3vAi23D34mLUdxLgvsyfexE1kl
	 MFDaOb2msveGaXoaPRsLx+J2aoaPBlg+LZ5VvOwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.1 099/122] nfs: use vfs setgid helper
Date: Mon, 28 Aug 2023 12:13:34 +0200
Message-ID: <20230828101159.694722877@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ Harshit: backport to 6.1.y:
  fs/internal.h -- minor conflict due to code change differences.
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
@@ -242,5 +242,3 @@ ssize_t __kernel_write_iter(struct file
 /*
  * fs/attr.c
  */
-int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
-			     const struct inode *inode);
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -717,9 +717,7 @@ void nfs_setattr_update_inode(struct ino
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
@@ -3120,6 +3120,8 @@ extern struct inode *new_inode(struct su
 extern void free_inode_nonrcu(struct inode *inode);
 extern int setattr_should_drop_suidgid(struct user_namespace *, struct inode *);
 extern int file_remove_privs(struct file *);
+int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
+			     const struct inode *inode);
 
 /*
  * This must be used for allocating filesystems specific inodes to set


