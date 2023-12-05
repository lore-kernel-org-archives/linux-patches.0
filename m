Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4799C6FB0;
	Tue,  5 Dec 2023 03:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTsyR6ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC14CC433C7;
	Tue,  5 Dec 2023 03:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701748016;
	bh=OldbwNgXntB3IhzqcSPx6orSPXddZDRZj7LCnZOm0go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTsyR6aiYK+Yxb3DMfiFtY1O6u9Lr7ABrAGFD2Nm1vXCuxoI58msSrrQMyDsVrsKb
	 DdoGV7eEMF4HvbKqUVQHPePVjOhkq0MFHrR/cgbw1i4VPsFOa/RkNxg7d+2FKRDXCA
	 iFAqk48To9N4hdX1xhxhcS+2ScF+ibYV0nlBRYMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
	Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 82/94] ovl: skip overlayfs superblocks at global sync
Date: Tue,  5 Dec 2023 12:17:50 +0900
Message-ID: <20231205031527.371888236@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f5cf0938f298d..fcf453f7f4aef 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -263,8 +263,8 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 		return 0;
 
 	/*
-	 * If this is a sync(2) call or an emergency sync, all the super blocks
-	 * will be iterated, including upper_sb, so no need to do anything.
+	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
+	 * All the super blocks will be iterated, including upper_sb.
 	 *
 	 * If this is a syncfs(2) call, then we do need to call
 	 * sync_filesystem() on upper_sb, but enough if we do it when being
@@ -1710,6 +1710,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_xattr = ovl_xattr_handlers;
 	sb->s_fs_info = ofs;
 	sb->s_flags |= SB_POSIXACL;
+	sb->s_iflags |= SB_I_SKIP_SYNC;
 
 	err = -ENOMEM;
 	root_dentry = d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
diff --git a/fs/sync.c b/fs/sync.c
index 4d1ff010bc5af..16c2630ee4bf1 100644
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
index 4b1553f570f2c..fbbd7ef7f6535 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1404,6 +1404,8 @@ extern int send_sigurg(struct fown_struct *fown);
 #define SB_I_IMA_UNVERIFIABLE_SIGNATURE	0x00000020
 #define SB_I_UNTRUSTED_MOUNTER		0x00000040
 
+#define SB_I_SKIP_SYNC	0x00000100	/* Skip superblock at global sync */
+
 /* Possible states of 'frozen' field */
 enum {
 	SB_UNFROZEN = 0,		/* FS is unfrozen */
-- 
2.42.0



