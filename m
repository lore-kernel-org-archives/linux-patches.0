Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FFD1FB40
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6299EC433CA;
	Fri, 21 Jul 2023 16:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956042;
	bh=yVeDTtFFxi8GBgPgEqcOhBYrDk5WORFEKZysrdQXkMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wpy7VeIEwMik2O/cfQYb32M1zHczplqYKNzjV1VZvD3//bPugiNCLJFD9q9sc+QU2
	 rmNOZPMuCY+f1Gbl8P9yqOo2p+RmJUYpWGyWp7DbY3T0pFTLvY+MGbvZZ7ndjyP7Yz
	 tVGdaBvEe7p362Ysxx7gk+vbZ5ZkbkS5mxzvVbJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.4 113/292] f2fs: fix deadlock in i_xattr_sem and inode page lock
Date: Fri, 21 Jul 2023 18:03:42 +0200
Message-ID: <20230721160533.678136355@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 5eda1ad1aaffdfebdecf7a164e586060a210f74f upstream.

Thread #1:

[122554.641906][   T92]  f2fs_getxattr+0xd4/0x5fc
    -> waiting for f2fs_down_read(&F2FS_I(inode)->i_xattr_sem);

[122554.641927][   T92]  __f2fs_get_acl+0x50/0x284
[122554.641948][   T92]  f2fs_init_acl+0x84/0x54c
[122554.641969][   T92]  f2fs_init_inode_metadata+0x460/0x5f0
[122554.641990][   T92]  f2fs_add_inline_entry+0x11c/0x350
    -> Locked dir->inode_page by f2fs_get_node_page()

[122554.642009][   T92]  f2fs_do_add_link+0x100/0x1e4
[122554.642025][   T92]  f2fs_create+0xf4/0x22c
[122554.642047][   T92]  vfs_create+0x130/0x1f4

Thread #2:

[123996.386358][   T92]  __get_node_page+0x8c/0x504
    -> waiting for dir->inode_page lock

[123996.386383][   T92]  read_all_xattrs+0x11c/0x1f4
[123996.386405][   T92]  __f2fs_setxattr+0xcc/0x528
[123996.386424][   T92]  f2fs_setxattr+0x158/0x1f4
    -> f2fs_down_write(&F2FS_I(inode)->i_xattr_sem);

[123996.386443][   T92]  __f2fs_set_acl+0x328/0x430
[123996.386618][   T92]  f2fs_set_acl+0x38/0x50
[123996.386642][   T92]  posix_acl_chmod+0xc8/0x1c8
[123996.386669][   T92]  f2fs_setattr+0x5e0/0x6bc
[123996.386689][   T92]  notify_change+0x4d8/0x580
[123996.386717][   T92]  chmod_common+0xd8/0x184
[123996.386748][   T92]  do_fchmodat+0x60/0x124
[123996.386766][   T92]  __arm64_sys_fchmodat+0x28/0x3c

Cc: <stable@vger.kernel.org>
Fixes: 27161f13e3c3 "f2fs: avoid race in between read xattr & write xattr"
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c   |    9 ++++++++-
 fs/f2fs/xattr.c |    6 ++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -775,8 +775,15 @@ int f2fs_add_dentry(struct inode *dir, c
 {
 	int err = -EAGAIN;
 
-	if (f2fs_has_inline_dentry(dir))
+	if (f2fs_has_inline_dentry(dir)) {
+		/*
+		 * Should get i_xattr_sem to keep the lock order:
+		 * i_xattr_sem -> inode_page lock used by f2fs_setxattr.
+		 */
+		f2fs_down_read(&F2FS_I(dir)->i_xattr_sem);
 		err = f2fs_add_inline_entry(dir, fname, inode, ino, mode);
+		f2fs_up_read(&F2FS_I(dir)->i_xattr_sem);
+	}
 	if (err == -EAGAIN)
 		err = f2fs_add_regular_entry(dir, fname, inode, ino, mode);
 
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -528,10 +528,12 @@ int f2fs_getxattr(struct inode *inode, i
 	if (len > F2FS_NAME_LEN)
 		return -ERANGE;
 
-	f2fs_down_read(&F2FS_I(inode)->i_xattr_sem);
+	if (!ipage)
+		f2fs_down_read(&F2FS_I(inode)->i_xattr_sem);
 	error = lookup_all_xattrs(inode, ipage, index, len, name,
 				&entry, &base_addr, &base_size, &is_inline);
-	f2fs_up_read(&F2FS_I(inode)->i_xattr_sem);
+	if (!ipage)
+		f2fs_up_read(&F2FS_I(inode)->i_xattr_sem);
 	if (error)
 		return error;
 


