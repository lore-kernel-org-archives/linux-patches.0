Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE61238C21;
	Tue, 29 Apr 2025 17:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948358; cv=none; b=BiHdFd8mNgSlGMlm5QFdqGYGz6JC+vfWd2xdKAt7LMagQkqpJOTrhCDUJPeczXKdMdwtmq4xkcpHRmBuE/gGsFKvK3UAx9N+tzQEnau8Vsj6XnGbpUWrr5BUHeiWkYNtyGYgdn7Mr75AP1qo/fiPy2xdTrgRDJvcEB3M/AB0SYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948358; c=relaxed/simple;
	bh=lOaIqLZr2pim7GrkWJRBsiyka6XVJlj4ZKd4dS8iXZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IDmHYmmdaBU9ERZwG7giqiB5VfeJljU39MGoSbn6YmJAU7Jx4rOjPYsy3mMdzWz26Pb7iuNRO+z6ra+lfVzgzzsUgn0PH/j0HFZtYtjxWbWs+mXGDD6X237eYjEzclciy96tvxhF/wITyc1jK0907vKgbweHszfnpw0Muck6fic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOCyq8j+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOCyq8j+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C900C4CEE3;
	Tue, 29 Apr 2025 17:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948358;
	bh=lOaIqLZr2pim7GrkWJRBsiyka6XVJlj4ZKd4dS8iXZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOCyq8j+dM4ZMVW++Ms/RQ0dtgOy76eKAeRgvvWhHlYK9T/VZ3YslWsqH5q89CcqH
	 5NIHQW7Hp9VfgcinQk7xj2szQdXJLkazuuzUnE4V2V4toLi2yv2G9riUPbk9OjeWin
	 cqnMh4F6d7DeATy7PIYRHsuGgRxdTZKL6RWx47wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Brian Foster <bfoster@redhat.com>,
	Theodore Tso <tytso@mit.edu>,
	=?UTF-8?q?Ricardo=20Ca=C3=B1uelo=20Navarro?= <rcn@igalia.com>
Subject: [PATCH 6.12 262/280] ext4: goto right label out_mmap_sem in ext4_setattr()
Date: Tue, 29 Apr 2025 18:43:23 +0200
Message-ID: <20250429161125.853844998@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit 7e91ae31e2d264155dfd102101afc2de7bd74a64 upstream.

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
Signed-off-by: Ricardo Cañuelo Navarro <rcn@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5468,7 +5468,7 @@ int ext4_setattr(struct mnt_idmap *idmap
 			    oldsize & (inode->i_sb->s_blocksize - 1)) {
 				error = ext4_inode_attach_jinode(inode);
 				if (error)
-					goto err_out;
+					goto out_mmap_sem;
 			}
 
 			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);


