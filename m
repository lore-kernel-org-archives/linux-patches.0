Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BB086334;
	Thu, 15 Jan 2026 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497458; cv=none; b=N0a6v2uQNdZU1zeZtl3//0P036CckxA+qH6bsAQqW3dglHqB2PD8qrn7YucfvwyO+V24tAoStuBLor4EBzqLbgLB80we3bbW9uXxQzS0aBXRAgDVpy6wzFH0pvlagBmCXoR3lN7jbVAMwjV365jhCl1dEhUfYSlWPmI/p5JDQzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497458; c=relaxed/simple;
	bh=Alg9ozhXDNyJ/NkPSRWU5FiHvYeKlY0YqvuYnYDMXiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+YuDtLjUfVK4amOOynxIKnKXJggfVThLKKN7FQQEMVFcryAnWjX5HS/cBYz50MJgHI4X4+9fvDDpe0/jKpnXuG4VyjLfToARaYUrLOLeUqZZ+2tDL/n4+bb5g1GS//zW+O8nYLH4lx2yzhvxuJUuMRcobz7nU49QAKjRXRVHeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NU0OuEjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NU0OuEjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F422C116D0;
	Thu, 15 Jan 2026 17:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497458;
	bh=Alg9ozhXDNyJ/NkPSRWU5FiHvYeKlY0YqvuYnYDMXiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NU0OuEjlrWLC/XMf/KQlV2ebeNWrLAngC4V9Mt9GL8fg/+n2LNImt5/aLIeFeR+jY
	 vyzdmd7SnABOOSHZ+qKJrD2U/9kCz7dr8rTy7Go+PSCNPAnZ/xS8XLlRDKnIc27iGz
	 uPWBXESh1t3JLe8wwuTacYMLOQlvwzUKTB9NQPHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bdeb22a4b9a09ab9aa45@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/554] ntfs3: init run lock for extend inode
Date: Thu, 15 Jan 2026 17:42:34 +0100
Message-ID: <20260115164249.433081015@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit be99c62ac7e7af514e4b13f83c891a3cccefaa48 ]

After setting the inode mode of $Extend to a regular file, executing the
truncate system call will enter the do_truncate() routine, causing the
run_lock uninitialized error reported by syzbot.

Prior to patch 4e8011ffec79, if the inode mode of $Extend was not set to
a regular file, the do_truncate() routine would not be entered.

Add the run_lock initialization when loading $Extend.

syzbot reported:
INFO: trying to register non-static key.
Call Trace:
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
 register_lock_class+0x105/0x320 kernel/locking/lockdep.c:1299
 __lock_acquire+0x99/0xd20 kernel/locking/lockdep.c:5112
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
 ntfs_set_size+0x140/0x200 fs/ntfs3/inode.c:860
 ntfs_extend+0x1d9/0x970 fs/ntfs3/file.c:387
 ntfs_setattr+0x2e8/0xbe0 fs/ntfs3/file.c:808

Fixes: 4e8011ffec79 ("ntfs3: pretend $Extend records as regular files")
Reported-by: syzbot+bdeb22a4b9a09ab9aa45@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bdeb22a4b9a09ab9aa45
Tested-by: syzbot+bdeb22a4b9a09ab9aa45@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 7797e35364495..0f4e166112de1 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -457,6 +457,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		/* Records in $Extend are not a files or general directories. */
 		inode->i_op = &ntfs_file_inode_operations;
 		mode = S_IFREG;
+		init_rwsem(&ni->file.run_lock);
 	} else {
 		err = -EINVAL;
 		goto out;
-- 
2.51.0



