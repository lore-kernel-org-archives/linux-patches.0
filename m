Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D02E2D839C;
	Tue, 21 Jul 2026 16:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649637; cv=none; b=YxdTKC16E3J17UyhxK8jWokirluVSdyHTEQo0sBVyzJmTlA2Y/9y4EP0wAeDYRv8VGWo46+Jushc9BdIauDgrA0enVeTR/BJYNxh6FlocAiIpB4UdUgu8wDnkpwFDeZa0+xZ9xqvhcfPZ0CKLZtdtnrmmAdeXzhr/JSbbpuA7q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649637; c=relaxed/simple;
	bh=QSTQTjrGE3yRu9UkmorlrZvWs750TIue7JePlbVAIis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYX6EEjHR4LpvMwZKHT8DrQqRaJGd+qVqKOzDat54nrRr6pTnNX9hKVx9CIOqSr0TBU9ITFEzvht+sSXxJvfQDe6pi3urm96k6dnn7PE10f3akzTeNhKgHo/daHAL6W00iXtOoyid8zw5jOKxhvClMNHnLhOpOlFek3i5hmT47s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=piZLlpmA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piZLlpmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D7C1F000E9;
	Tue, 21 Jul 2026 16:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649636;
	bh=fUa3b6dSE7wFSFIQ87yNLkncaPssuF4E+69AGiAuZ0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=piZLlpmAGh/LbTX8kUXLNm2JYRPHpnQoVqD128jSX3FCKVhNvBSougIj5g/J+BdML
	 8T361f9zq2DPHZzJici4aLu9WmYxQiBpCjqxjl5rPoK4RmVgNth7MwnT1q1TlupdJn
	 l+2iPnv90ZI1I5eeG0z/7+I8rfu19BpkE/DH7/eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0653/2077] ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
Date: Tue, 21 Jul 2026 17:05:26 +0200
Message-ID: <20260721152608.208715913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit c143957520c6c9b5cd72e0de8b52b814f0c576fe ]

Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
belong to the same superblock as the original file.  Currently, this
validation is performed inside ext4_move_extents() by
mext_check_validity(), but only after lock_two_nondirectories() has
already acquired the inode locks.  When the donor fd refers to a file
on a different filesystem (e.g., overlayfs), this late validation
creates a circular lock dependency:

  CPU0 (overlayfs write)            CPU1 (ext4 ioctl)
  ----                              ----
  inode_lock(ovl_inode)
                                    mnt_want_write_file(filp)
                                      sb_start_write(ext4_sb)   [sb_writers]
    backing_file_write_iter()
      vfs_iter_write(real_file)
        file_start_write(real_file)
          sb_start_write(ext4_sb)   [blocked by freeze]
                                    lock_two_nondirectories()
                                      inode_lock(ovl_inode)     [blocked]

With a concurrent freeze operation holding sb_writers write side, this
forms a deadlock cycle: CPU0 waits for freeze to complete, freeze waits
for CPU1's sb_writers reader to exit, CPU1 waits for CPU0's inode lock.

Since EXT4_IOC_MOVE_EXT exchanges physical extents between two files,
it fundamentally requires both files to reside on the same ext4
filesystem.  Moving the superblock check before any lock acquisition
is both semantically correct and eliminates the circular dependency
by ensuring that cross-filesystem donor fds are rejected before
sb_writers or inode locks are taken.

Fixes: fcf6b1b729bc ("ext4: refactor ext4_move_extents code base")
Reported-by: syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ad6118a7584b607c67f2
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://patch.msgid.link/20260608152521.1292656-1-yun.zhou@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 110e3fb194ec6b..c8387e6a2c6e90 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1656,6 +1656,9 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (!(fd_file(donor)->f_mode & FMODE_WRITE))
 			return -EBADF;
 
+		if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb)
+			return -EXDEV;
+
 		err = mnt_want_write_file(filp);
 		if (err)
 			return err;
-- 
2.53.0



