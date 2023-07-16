Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A698F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EF5C433C8;
	Sun, 16 Jul 2023 20:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540946;
	bh=fRQh4i6LnxgRyMoPpIGW+g3H6BDcRwr9n2wRsgFvQrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9a1aTjkqBa32E0OJZNQ9sXQxIkQ2PqxocnOubJOEpb8PS2UO2YpIrVZdA3iZUicw
	 8fwj7otFc88suEPjd+zb5wj9ItmDgbtGOVBN1vN05sl8uHtnNX6hWf7FnLUbCax8hJ
	 yGhnPrZjhEPMZBxb0xTFqQ+YELn3A9mMSc6fSHs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 544/591] shmem: use ramfs_kill_sb() for kill_sb method of ramfs-based tmpfs
Date: Sun, 16 Jul 2023 21:51:23 +0200
Message-ID: <20230716194937.935053690@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 36ce9d76b0a93bae799e27e4f5ac35478c676592 upstream.

As the ramfs-based tmpfs uses ramfs_init_fs_context() for the
init_fs_context method, which allocates fc->s_fs_info, use ramfs_kill_sb()
to free it and avoid a memory leak.

Link: https://lkml.kernel.org/r/20230607161523.2876433-1-roberto.sassu@huaweicloud.com
Fixes: c3b1b1cbf002 ("ramfs: add support for "mode=" mount option")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ramfs/inode.c      |    2 +-
 include/linux/ramfs.h |    1 +
 mm/shmem.c            |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -278,7 +278,7 @@ int ramfs_init_fs_context(struct fs_cont
 	return 0;
 }
 
-static void ramfs_kill_sb(struct super_block *sb)
+void ramfs_kill_sb(struct super_block *sb)
 {
 	kfree(sb->s_fs_info);
 	kill_litter_super(sb);
--- a/include/linux/ramfs.h
+++ b/include/linux/ramfs.h
@@ -7,6 +7,7 @@
 struct inode *ramfs_get_inode(struct super_block *sb, const struct inode *dir,
 	 umode_t mode, dev_t dev);
 extern int ramfs_init_fs_context(struct fs_context *fc);
+extern void ramfs_kill_sb(struct super_block *sb);
 
 #ifdef CONFIG_MMU
 static inline int
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4137,7 +4137,7 @@ static struct file_system_type shmem_fs_
 	.name		= "tmpfs",
 	.init_fs_context = ramfs_init_fs_context,
 	.parameters	= ramfs_fs_parameters,
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= ramfs_kill_sb,
 	.fs_flags	= FS_USERNS_MOUNT,
 };
 


