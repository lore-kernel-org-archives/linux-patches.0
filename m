Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA0E1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 14:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B90C433D2;
	Mon, 20 Mar 2023 14:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324342;
	bh=bV7u4jV5V5i0aBzT3wvEsfhBr/KuJuR83Td/G6y/8ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2l1FDA6qGxyIs3e3l+ntfYgKs8UGs8W5sN+f1fyCwk+OLIblntFh4hPYNDjQg98mM
	 DWFkORAEyRcVeeZZ9FaRdk4yzudFRpmNHQPzKDA2OCte4W6Ac4E+smj0LEbWefGGuL
	 zYI3CfuqAI/d5UjILmoA0J41o9kg94QfxMO5zGfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
	Theodore Tso <tytso@mit.edu>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/36] ext4: fail ext4_iget if special inode unallocated
Date: Mon, 20 Mar 2023 15:54:50 +0100
Message-Id: <20230320145425.145903002@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 5cd740287ae5e3f9d1c46f5bfe8778972fd6d3fe ]

In ext4_fill_super(), EXT4_ORPHAN_FS flag is cleared after
ext4_orphan_cleanup() is executed. Therefore, when __ext4_iget() is
called to get an inode whose i_nlink is 0 when the flag exists, no error
is returned. If the inode is a special inode, a null pointer dereference
may occur. If the value of i_nlink is 0 for any inodes (except boot loader
inodes) got by using the EXT4_IGET_SPECIAL flag, the current file system
is corrupted. Therefore, make the ext4_iget() function return an error if
it gets such an abnormal special inode.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=199179
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216541
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216539
Reported-by: Luís Henriques <lhenriques@suse.de>
Suggested-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230107032126.4165860-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6e7989b04d2bf..e844d91c461b0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4947,13 +4947,6 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		goto bad_inode;
 	raw_inode = ext4_raw_inode(&iloc);
 
-	if ((ino == EXT4_ROOT_INO) && (raw_inode->i_links_count == 0)) {
-		ext4_error_inode(inode, function, line, 0,
-				 "iget: root inode unallocated");
-		ret = -EFSCORRUPTED;
-		goto bad_inode;
-	}
-
 	if ((flags & EXT4_IGET_HANDLE) &&
 	    (raw_inode->i_links_count == 0) && (raw_inode->i_mode == 0)) {
 		ret = -ESTALE;
@@ -5024,11 +5017,16 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	 * NeilBrown 1999oct15
 	 */
 	if (inode->i_nlink == 0) {
-		if ((inode->i_mode == 0 ||
+		if ((inode->i_mode == 0 || flags & EXT4_IGET_SPECIAL ||
 		     !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) &&
 		    ino != EXT4_BOOT_LOADER_INO) {
-			/* this inode is deleted */
-			ret = -ESTALE;
+			/* this inode is deleted or unallocated */
+			if (flags & EXT4_IGET_SPECIAL) {
+				ext4_error_inode(inode, function, line, 0,
+						 "iget: special inode unallocated");
+				ret = -EFSCORRUPTED;
+			} else
+				ret = -ESTALE;
 			goto bad_inode;
 		}
 		/* The only unlinked inodes we let through here have
-- 
2.39.2



