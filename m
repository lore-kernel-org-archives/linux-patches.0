Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8746FAF;
	Tue,  5 Dec 2023 03:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npa7/jiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EA2C433C8;
	Tue,  5 Dec 2023 03:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746910;
	bh=L6nsT5Wy/896KbcP4TrgQtT0Fr8NtWbQNW1DHDCsdNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npa7/jiWeg1DUpVVdFWtOPggv5II6OfTV6X+c8YyDf2eh1pAQqik43tMVSXhctlKW
	 9eORWLJ9C9LhRDFw/HL4lCdG5G3ZyPf9w+weUNfMrx81epD4IPID69GHURRifCu25a
	 xWE9U4eYCwwKxNi7QwE0T1PS612w/aNUqG6/3GMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
	Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 63/71] ovl: skip overlayfs superblocks at global sync
Date: Tue,  5 Dec 2023 12:17:01 +0900
Message-ID: <20231205031521.539334896@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

[ Upstream commit 32b1924b210a70dcacdf65abd687c5ef86a67541 ]

Stacked filesystems like overlayfs has no own writeback, but they have to
forward syncfs() requests to backend for keeping data integrity.

During global sync() each overlayfs instance calls method ->sync_fs() for
backend although it itself is in global list of superblocks too.  As a
result one syscall sync() could write one superblock several times and send
multiple disk barriers.

This patch adds flag SB_I_SKIP_SYNC into sb->sb_iflags to avoid that.

Reported-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: b836c4d29f27 ("ima: detect changes to the backing overlay file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 5 +++--
 fs/sync.c            | 3 ++-
 include/linux/fs.h   | 2 ++
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1a7a1e2988855..1c1eb873e6ecc 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -268,8 +268,8 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 		return 0;
 
 	/*
-	 * If this is a sync(2) call or an emergency sync, all the super blocks
-	 * will be iterated, including upper_sb, so no need to do anything.
+	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
+	 * All the super blocks will be iterated, including upper_sb.
 	 *
 	 * If this is a syncfs(2) call, then we do need to call
 	 * sync_filesystem() on upper_sb, but enough if we do it when being
@@ -1664,6 +1664,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_xattr = ovl_xattr_handlers;
 	sb->s_fs_info = ofs;
 	sb->s_flags |= SB_POSIXACL;
+	sb->s_iflags |= SB_I_SKIP_SYNC;
 
 	err = -ENOMEM;
 	root_dentry = d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
diff --git a/fs/sync.c b/fs/sync.c
index b54e0541ad899..917ebd12c2515 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -76,7 +76,8 @@ static void sync_inodes_one_sb(struct super_block *sb, void *arg)
 
 static void sync_fs_one_sb(struct super_block *sb, void *arg)
 {
-	if (!sb_rdonly(sb) && sb->s_op->sync_fs)
+	if (!sb_rdonly(sb) && !(sb->s_iflags & SB_I_SKIP_SYNC) &&
+	    sb->s_op->sync_fs)
 		sb->s_op->sync_fs(sb, *(int *)arg);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 95b8ef09b76cf..f89748aac8c32 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1351,6 +1351,8 @@ extern int send_sigurg(struct fown_struct *fown);
 #define SB_I_IMA_UNVERIFIABLE_SIGNATURE	0x00000020
 #define SB_I_UNTRUSTED_MOUNTER		0x00000040
 
+#define SB_I_SKIP_SYNC	0x00000100	/* Skip superblock at global sync */
+
 /* Possible states of 'frozen' field */
 enum {
 	SB_UNFROZEN = 0,		/* FS is unfrozen */
-- 
2.42.0



