Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7671D271473;
	Mon, 13 Oct 2025 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367896; cv=none; b=cM4aiJv6CI33ePKe2QCJGqLblVWDCDExUguu6kAZ6AwZ2LdxjX7Leqr5SIyw+JpxIUmpKBat9cd/vxkmhL2nnsrxPaAOBm0Wy3LIOTSfK2d4fvucEX36tkicqbcHp+dYY395JpdqZeZPpakWSHDxHyZr+YiIMlwCFA9YcCGwdno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367896; c=relaxed/simple;
	bh=dZu26VoAE+LTUbZr45Yhr0w0OM//u3hzUqs/IHrYqho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWdJx186Wj6e4nXG1130f0N+n4V+4KGJs9MAMrV0YOSviLAuXYEXZSTbMqPBMA8r/5pPcIWqPAX/YShI872v1oPmU40gIVpFvazMNgXlXBxboJ5uaaZCdYDULcqyT0ZhysYPB7bgOeeY068+pNHDQcnEoNmMum89nSsNFicfIag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTxMtqEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTxMtqEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041C6C4CEE7;
	Mon, 13 Oct 2025 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367896;
	bh=dZu26VoAE+LTUbZr45Yhr0w0OM//u3hzUqs/IHrYqho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTxMtqElVzFV0gK49Fks9FcHq95wKa8/ZwFSDxNpUXwYCAwrxCVj3eTRz5uh+fN/v
	 GYQkDPH2TfQauau/xoxOhaM5BgIkqig78KhqRVc50bk9JmYDlModE5/I0fraJb2KVV
	 j8HCXg3nMrURHAdOgevMLHpwsvkHFvZdO9BWYN4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	syzbot+157bdef5cf596ad0da2c@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 169/196] Squashfs: fix uninit-value in squashfs_get_parent
Date: Mon, 13 Oct 2025 16:46:00 +0200
Message-ID: <20251013144321.423625005@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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


