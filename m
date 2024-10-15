Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB86210C3A;
	Tue, 15 Oct 2024 13:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998244; cv=none; b=tdIAAFkqN977+HX5uGSKKU6/AcsLl/DOY+PRXfatKC3Lr1XArhBKsi+RPO7PQds5Vtn/TNRkE59htvdi+4T2KtFtLCVbN93POFgosZV/m858+d3BYjohC9/nJ2wBXVxlt/IDKWnsUJ8lkXCyu4rNIbIf99+tiTK4LN60mpmSss4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998244; c=relaxed/simple;
	bh=ed/RI/HP50o34Aokjalet+9D7Fzldu19OZdBUT986eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlEFKtYgL5lZk/D97mO/W35+TCFuc2CYUmL6uLLJSjYjzP6uKo6SNI5VmjJ0Xu2EVXgVLyxDheu5XYI7xd6JxZorKbWXe2/Khrh3+qP2hLvj0FgJQd4Hd4QgSPjqyNNeawluPq8IjGE9bUy0uOGv5TA7rzZyAXyGa7ju4eypD3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uowrYgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uowrYgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2ABC4CEC6;
	Tue, 15 Oct 2024 13:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998244;
	bh=ed/RI/HP50o34Aokjalet+9D7Fzldu19OZdBUT986eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uowrYgiYl0iWqQ1CfGPJh6gUnVmeoRx+R/OoFKy0MPc3zmyyhRRrd3uN1v3SaFd2
	 trrrGWpiKtk3DQFNoO9LAdfzJsHp72wrUlLx650pUxL+9nvnImFWwLuSPHp/uvH/j5
	 EfHyvE+RwJfN39Ddqx9OoqOAve1ZC/SzM0+d8KCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 421/518] ext4: dax: fix overflowing extents beyond inode size when partially writing
Date: Tue, 15 Oct 2024 14:45:25 +0200
Message-ID: <20241015123933.245226074@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit dda898d7ffe85931f9cca6d702a51f33717c501e ]

The dax_iomap_rw() does two things in each iteration: map written blocks
and copy user data to blocks. If the process is killed by user(See signal
handling in dax_iomap_iter()), the copied data will be returned and added
on inode size, which means that the length of written extents may exceed
the inode size, then fsck will fail. An example is given as:

dd if=/dev/urandom of=file bs=4M count=1
 dax_iomap_rw
  iomap_iter // round 1
   ext4_iomap_begin
    ext4_iomap_alloc // allocate 0~2M extents(written flag)
  dax_iomap_iter // copy 2M data
  iomap_iter // round 2
   iomap_iter_advance
    iter->pos += iter->processed // iter->pos = 2M
   ext4_iomap_begin
    ext4_iomap_alloc // allocate 2~4M extents(written flag)
  dax_iomap_iter
   fatal_signal_pending
  done = iter->pos - iocb->ki_pos // done = 2M
 ext4_handle_inode_extension
  ext4_update_inode_size // inode size = 2M

fsck reports: Inode 13, i_size is 2097152, should be 4194304.  Fix?

Fix the problem by truncating extents if the written length is smaller
than expected.

Fixes: 776722e85d3b ("ext4: DAX iomap write support")
CC: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219136
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://patch.msgid.link/20240809121532.2105494-1-chengzhihao@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 15f45499f491a..62c4073b0e568 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -308,10 +308,10 @@ static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
  * Clean up the inode after DIO or DAX extending write has completed and the
  * inode size has been updated using ext4_handle_inode_extension().
  */
-static void ext4_inode_extension_cleanup(struct inode *inode, ssize_t count)
+static void ext4_inode_extension_cleanup(struct inode *inode, bool need_trunc)
 {
 	lockdep_assert_held_write(&inode->i_rwsem);
-	if (count < 0) {
+	if (need_trunc) {
 		ext4_truncate_failed_write(inode);
 		/*
 		 * If the truncate operation failed early, then the inode may
@@ -548,7 +548,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		 * writeback of delalloc blocks.
 		 */
 		WARN_ON_ONCE(ret == -EIOCBQUEUED);
-		ext4_inode_extension_cleanup(inode, ret);
+		ext4_inode_extension_cleanup(inode, ret < 0);
 	}
 
 out:
@@ -632,7 +632,7 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (extend) {
 		ret = ext4_handle_inode_extension(inode, offset, ret);
-		ext4_inode_extension_cleanup(inode, ret);
+		ext4_inode_extension_cleanup(inode, ret < (ssize_t)count);
 	}
 out:
 	inode_unlock(inode);
-- 
2.43.0



