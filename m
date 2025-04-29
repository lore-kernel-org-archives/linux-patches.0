Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D2C213E67;
	Tue, 29 Apr 2025 18:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950794; cv=none; b=Ooi9FRoSNYUU1XXNVlRs4hUphacn3zvIff4LJmRpkK5DTj0RuHEeUGSU6yiBeX3IL97fyJNBXn5wECxCIqOu/x2mlPAVq2CsAsA40O/PeEAwSzHXy+gS5BC0B9Rs4RQ95DTj4fFwZOdf/DtB+x8wn9foMH/IQNkmVm2xpPKMqno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950794; c=relaxed/simple;
	bh=br9/zMqFrF4fLmNdP0MG/1pD+4eUNseQ+63JiJHbV3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W0n1tg1Nx0xdzYNx0ArJYphooDUl5nKMy274+JO+ETK3nHeQTIbxO7icKqGTYry6mgc9DiJ0PDafsmZw1w8FnVZiy4wobbsY0uijwz2zpnwiaU6HV00uXzZ9BnOenUQKgrDSN0tsoUKpCmyejWlsoBoG/yaRCzWVGo9IvembLD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GRxHJ1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GRxHJ1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B786EC4CEE9;
	Tue, 29 Apr 2025 18:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950794;
	bh=br9/zMqFrF4fLmNdP0MG/1pD+4eUNseQ+63JiJHbV3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GRxHJ1VzUVrCLy6ryFfq9HY4Aq/3goKPOUcuZJN3HMl7xRRlPw4xkQFPMG5OwriP
	 lcd0NxW/qD/IW+4lDxycD72GjHPaQDJiMwBU9kQy5BfNGNx/BenknBkHEw+NodPV8a
	 CY/3kvSKBW+7iUVsEMf67zu6LcT1bP4pLfwhHYpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Brian Foster <bfoster@redhat.com>,
	Theodore Tso <tytso@mit.edu>,
	=?UTF-8?q?Ricardo=20Ca=C3=B1uelo=20Navarro?= <rcn@igalia.com>
Subject: [PATCH 6.6 195/204] ext4: goto right label out_mmap_sem in ext4_setattr()
Date: Tue, 29 Apr 2025 18:44:43 +0200
Message-ID: <20250429161107.353860567@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5479,7 +5479,7 @@ int ext4_setattr(struct mnt_idmap *idmap
 			    oldsize & (inode->i_sb->s_blocksize - 1)) {
 				error = ext4_inode_attach_jinode(inode);
 				if (error)
-					goto err_out;
+					goto out_mmap_sem;
 			}
 
 			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);


