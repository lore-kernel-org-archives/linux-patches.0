Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B58F31283B;
	Mon, 29 Dec 2025 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025577; cv=none; b=UIJzETc/opygs8A9vRTFjIB203H7gk/ERBdCDL4x+qGNvf/XLZixxL1x6PoRhyiGzqfaHRsby3vJrGTdXPYIQeHHmTYo08O84sAAUWfRHMwz5sQ6iYvSCbaY42K5s7bVjOiQahmwgyT7QvkA+BV+n1O3QMg96cDeOFSoEodXxHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025577; c=relaxed/simple;
	bh=IVDlaOqwKiB739oIKc3JJFjS9BrppUnRqH71iDUVxoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M72RbScDW1b0pLfrI5jpzUG2gBPR/E6Jtjk/1so4QEmPBsV3wjyvRPRh7JfQkAoheTU5N4IuGQY3Yfxpo6QVzbnw5M14bICUjLLSluY7k/3aRlZRLVkM9movsnv1QihOtZFyxnR0G9ItTHfvcUTI9JFE1RJDKjr/23V9knvwllQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWpEEA2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWpEEA2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9226C4CEF7;
	Mon, 29 Dec 2025 16:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025577;
	bh=IVDlaOqwKiB739oIKc3JJFjS9BrppUnRqH71iDUVxoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWpEEA2mXdwVq55QzM1CzGWCmIULZujBpNu9c8eYXjEMmdV8W2I8P8t7IqbU7qtOf
	 xmd0y4m1H8/HB0+Jj67zLJqNZJ3D8ic/7/3hSlWFASmpDgzozpFfCmXvC9XxKaULK1
	 UyTj1cQRW6IuKWapaS+y/VUh1XifUOWF2eSw650Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 262/430] ext4: clear i_state_flags when alloc inode
Date: Mon, 29 Dec 2025 17:11:04 +0100
Message-ID: <20251229160733.995890672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

commit 4091c8206cfd2e3bb529ef260887296b90d9b6a2 upstream.

i_state_flags used on 32-bit archs, need to clear this flag when
alloc inode.
Find this issue when umount ext4, sometimes track the inode as orphan
accidently, cause ext4 mesg dump.

Fixes: acf943e9768e ("ext4: fix checks for orphan inodes")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251104-ext4-v1-1-73691a0800f9@nxp.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ialloc.c |    1 -
 fs/ext4/inode.c  |    1 -
 fs/ext4/super.c  |    1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1293,7 +1293,6 @@ got:
 		ei->i_csum_seed = ext4_chksum(csum, (__u8 *)&gen, sizeof(gen));
 	}
 
-	ext4_clear_state_flags(ei); /* Only relevant on 32-bit archs */
 	ext4_set_inode_state(inode, EXT4_STATE_NEW);
 
 	ei->i_extra_isize = sbi->s_want_extra_isize;
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5288,7 +5288,6 @@ struct inode *__ext4_iget(struct super_b
 	ei->i_projid = make_kprojid(&init_user_ns, i_projid);
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 
-	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
 	ei->i_inline_off = 0;
 	ei->i_dir_start_lookup = 0;
 	ei->i_dtime = le32_to_cpu(raw_inode->i_dtime);
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1396,6 +1396,7 @@ static struct inode *ext4_alloc_inode(st
 
 	inode_set_iversion(&ei->vfs_inode, 1);
 	ei->i_flags = 0;
+	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
 	spin_lock_init(&ei->i_raw_lock);
 	ei->i_prealloc_node = RB_ROOT;
 	atomic_set(&ei->i_prealloc_active, 0);


