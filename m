Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E919C31CA7F;
	Mon, 27 Oct 2025 18:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590595; cv=none; b=edrb5bWvK1Qr8xrp731pjVvX3QLq8L2mnvlYAo0/qe2ww/0xgT4LaVX3My6TKaC9L1t3rO/OFtGSR9gSoPeifolkq+9QYvMMY7y5VW/+nO4Yz0sEIEl0wRdeCU1d6z+cZ7pYt582DsgXqolE+5NVsKicSBwNbDm4lkmujWppsqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590595; c=relaxed/simple;
	bh=OfraTs7VLVumO0CwOH0JmzW0lfsxEDqE2Pcej7dsuyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeCXDBCRwZqKRtWzpfQ4Hj6gJnRS5MOfE/6bEtLxSIa4nvI6IE5vXE3IaWJWCS16KQVZA2PX/liEIw3OKKoB796s43bQMK0AZermOlDen9+N0aMXHpA/Yr4B5UhuowgLfN4eHhWOKcUJ1E1zKRjTJXpqOJHekeJXjpTSEks77Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+IkvipG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+IkvipG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C5EC4CEF1;
	Mon, 27 Oct 2025 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590594;
	bh=OfraTs7VLVumO0CwOH0JmzW0lfsxEDqE2Pcej7dsuyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+IkvipGQ6xud7eWJrIpLdZ2pOtz1XTl/uqzfdFGa3bN2Z23x//pH2/xChbXv0cB2
	 5kqFebjydm6yKz1JE+wh8zHu2SZTHi9y30SrU6wa3M/+LSl5M/xXvWz7gJmjferxHh
	 q+ndcbVACyK90XdZnW19H29PyPkpkhFKGqLNRrP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	syzbot+157bdef5cf596ad0da2c@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 073/224] Squashfs: fix uninit-value in squashfs_get_parent
Date: Mon, 27 Oct 2025 19:33:39 +0100
Message-ID: <20251027183510.955734909@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

commit 74058c0a9fc8b2b4d5f4a0ef7ee2cfa66a9e49cf upstream.

Syzkaller reports a "KMSAN: uninit-value in squashfs_get_parent" bug.

This is caused by open_by_handle_at() being called with a file handle
containing an invalid parent inode number.  In particular the inode number
is that of a symbolic link, rather than a directory.

Squashfs_get_parent() gets called with that symbolic link inode, and
accesses the parent member field.

	unsigned int parent_ino = squashfs_i(inode)->parent;

Because non-directory inodes in Squashfs do not have a parent value, this
is uninitialised, and this causes an uninitialised value access.

The fix is to initialise parent with the invalid inode 0, which will cause
an EINVAL error to be returned.

Regular inodes used to share the parent field with the block_list_start
field.  This is removed in this commit to enable the parent field to
contain the invalid inode number 0.

Link: https://lkml.kernel.org/r/20250918233308.293861-1-phillip@squashfs.org.uk
Fixes: 122601408d20 ("Squashfs: export operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+157bdef5cf596ad0da2c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68cc2431.050a0220.139b6.0001.GAE@google.com/
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/inode.c         |    7 +++++++
 fs/squashfs/squashfs_fs_i.h |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -165,6 +165,7 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->start = le32_to_cpu(sqsh_ino->start_block);
 		squashfs_i(inode)->block_list_start = block;
 		squashfs_i(inode)->offset = offset;
+		squashfs_i(inode)->parent = 0;
 		inode->i_data.a_ops = &squashfs_aops;
 
 		TRACE("File inode %x:%x, start_block %llx, block_list_start "
@@ -212,6 +213,7 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->start = le64_to_cpu(sqsh_ino->start_block);
 		squashfs_i(inode)->block_list_start = block;
 		squashfs_i(inode)->offset = offset;
+		squashfs_i(inode)->parent = 0;
 		inode->i_data.a_ops = &squashfs_aops;
 
 		TRACE("File inode %x:%x, start_block %llx, block_list_start "
@@ -292,6 +294,7 @@ int squashfs_read_inode(struct inode *in
 		inode->i_mode |= S_IFLNK;
 		squashfs_i(inode)->start = block;
 		squashfs_i(inode)->offset = offset;
+		squashfs_i(inode)->parent = 0;
 
 		if (type == SQUASHFS_LSYMLINK_TYPE) {
 			__le32 xattr;
@@ -329,6 +332,7 @@ int squashfs_read_inode(struct inode *in
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		rdev = le32_to_cpu(sqsh_ino->rdev);
 		init_special_inode(inode, inode->i_mode, new_decode_dev(rdev));
+		squashfs_i(inode)->parent = 0;
 
 		TRACE("Device inode %x:%x, rdev %x\n",
 				SQUASHFS_INODE_BLK(ino), offset, rdev);
@@ -353,6 +357,7 @@ int squashfs_read_inode(struct inode *in
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		rdev = le32_to_cpu(sqsh_ino->rdev);
 		init_special_inode(inode, inode->i_mode, new_decode_dev(rdev));
+		squashfs_i(inode)->parent = 0;
 
 		TRACE("Device inode %x:%x, rdev %x\n",
 				SQUASHFS_INODE_BLK(ino), offset, rdev);
@@ -373,6 +378,7 @@ int squashfs_read_inode(struct inode *in
 			inode->i_mode |= S_IFSOCK;
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		init_special_inode(inode, inode->i_mode, 0);
+		squashfs_i(inode)->parent = 0;
 		break;
 	}
 	case SQUASHFS_LFIFO_TYPE:
@@ -392,6 +398,7 @@ int squashfs_read_inode(struct inode *in
 		inode->i_op = &squashfs_inode_ops;
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		init_special_inode(inode, inode->i_mode, 0);
+		squashfs_i(inode)->parent = 0;
 		break;
 	}
 	default:
--- a/fs/squashfs/squashfs_fs_i.h
+++ b/fs/squashfs/squashfs_fs_i.h
@@ -16,6 +16,7 @@ struct squashfs_inode_info {
 	u64		xattr;
 	unsigned int	xattr_size;
 	int		xattr_count;
+	int		parent;
 	union {
 		struct {
 			u64		fragment_block;
@@ -27,7 +28,6 @@ struct squashfs_inode_info {
 			u64		dir_idx_start;
 			int		dir_idx_offset;
 			int		dir_idx_cnt;
-			int		parent;
 		};
 	};
 	struct inode	vfs_inode;


