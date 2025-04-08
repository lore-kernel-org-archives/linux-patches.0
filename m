Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E9B207E14;
	Tue,  8 Apr 2025 11:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110801; cv=none; b=ZKK69yuU6wLw5f/mBj9fzu3iZQUQ9Fwd0FWFwH9Lg8KDQYgBGuOpzF25JCElK+ivD7XRrK65yqzlRPU4xfz1vH2JCx5WNScsGgPO5hFt8KTxJ/5cQGXHzEZVZfgXf74dO5rpQ9fiRnSugPvs7YGDW+ySA4BSQ0vSh5QAnjrvFyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110801; c=relaxed/simple;
	bh=h7eS0KGvcm3FZWzjTLSL7Jz9mPWTmyw+gcj0O5nvskY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILYQXVt4UWpv1O+PBmPEXMnA3PNVpExz0F+ZzLxIVaekEWnGrM0xz5e9ufqUdh1Hhfgt4RSWuGOHNH4rlZf7b6ZaWQdedWCI2zZqtIcl1sDVmm/E/YgPMqf/vnx6mdSq6FPgDT8wri+sxeO7lfIAwP2O3mGLFvav03YzwwPor/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sC1ekASm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sC1ekASm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3803AC4CEE5;
	Tue,  8 Apr 2025 11:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110801;
	bh=h7eS0KGvcm3FZWzjTLSL7Jz9mPWTmyw+gcj0O5nvskY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sC1ekASmTrxSpPBdWJsDHW8Eud5QYDvOsUd67G5YDQ4wHT2InkZ5bN/5Dx+W86KaK
	 murk5LvmHfimT8efA1Fi4207pkphSds8u4qdL7Y1MzkuZb1/AIf3uOAE/nU7wGS7e/
	 54o7zyCwr+x8YZtpd4E+OGEQEIRbHj0t2uxjdqmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Brian Foster <bfoster@redhat.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 198/731] ext4: goto right label out_mmap_sem in ext4_setattr()
Date: Tue,  8 Apr 2025 12:41:35 +0200
Message-ID: <20250408104918.885468827@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 7e91ae31e2d264155dfd102101afc2de7bd74a64 ]

Otherwise, if ext4_inode_attach_jinode() fails, a hung task will
happen because filemap_invalidate_unlock() isn't called to unlock
mapping->invalidate_lock. Like this:

EXT4-fs error (device sda) in ext4_setattr:5557: Out of memory
INFO: task fsstress:374 blocked for more than 122 seconds.
      Not tainted 6.14.0-rc1-next-20250206-xfstests-dirty #726
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:fsstress state:D stack:0     pid:374   tgid:374   ppid:373
                                  task_flags:0x440140 flags:0x00000000
Call Trace:
 <TASK>
 __schedule+0x2c9/0x7f0
 schedule+0x27/0xa0
 schedule_preempt_disabled+0x15/0x30
 rwsem_down_read_slowpath+0x278/0x4c0
 down_read+0x59/0xb0
 page_cache_ra_unbounded+0x65/0x1b0
 filemap_get_pages+0x124/0x3e0
 filemap_read+0x114/0x3d0
 vfs_read+0x297/0x360
 ksys_read+0x6c/0xe0
 do_syscall_64+0x4b/0x110
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: c7fc0366c656 ("ext4: partial zero eof block on unaligned inode size extension")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Link: https://patch.msgid.link/20250213112247.3168709-1-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 891bd1e2d19f8..4009f9017a0e9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5477,7 +5477,7 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			    oldsize & (inode->i_sb->s_blocksize - 1)) {
 				error = ext4_inode_attach_jinode(inode);
 				if (error)
-					goto err_out;
+					goto out_mmap_sem;
 			}
 
 			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
-- 
2.39.5



