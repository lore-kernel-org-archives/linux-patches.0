Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5207933A712;
	Fri,  9 Jan 2026 11:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959684; cv=none; b=u9x42vIgArgJPQ+IAXi2znHrpdAG8oRnwaeGIwOUBBPbKS8hF+2YyztH2nWUOIlWWlFZJn4FmlBioCN4uD1Rhs3Opo315UmYXx/ua4pPgNOF0gl2ywrcLbO0O+ppgKU0RPdAqMeImo57Om/cpJesKRzgtIEgIK498syOWzGPUT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959684; c=relaxed/simple;
	bh=0pPPTNZgjSENzBh8/U5kSW78eoas0jnX1DSMH5eB5Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oh6bM0FBa+x9KctD00qE7Q64SXaW3aqPSkXdgqdL3SmW8ZmnPCmmTcX1lrLPx6b4r9u+tVlmGcvdzncgbyqr98G4PTLE0XXI9k3L36FxsrgcIRbytmoj1mBuOj6DAUxGSaAgwv0AeTPWd0LKgMGrCAZKkZnZ/yNdq7gjAfqhlfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tv2qE9GT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tv2qE9GT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60F5C4CEF1;
	Fri,  9 Jan 2026 11:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959684;
	bh=0pPPTNZgjSENzBh8/U5kSW78eoas0jnX1DSMH5eB5Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tv2qE9GTDJpT9+yFKhrb/FCD5Z9oZLKeb8NsBjbGbSsvIhnIY9WQyu29m7fSeyf6N
	 hVNTXZ8tYkb4UhA0FdvCm5hAKWELBa+sOwuHrdgi49d46XylhLdiQ2NYLlgWCLzFm1
	 d+tai+LyEnO2g52FxiZU/DgUbQxuKVwd5ClN8lgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bdeb22a4b9a09ab9aa45@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/737] ntfs3: init run lock for extend inode
Date: Fri,  9 Jan 2026 12:34:36 +0100
Message-ID: <20260109112139.154890263@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index f27e25776b730..76326299ba368 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -465,6 +465,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		/* Records in $Extend are not a files or general directories. */
 		inode->i_op = &ntfs_file_inode_operations;
 		mode = S_IFREG;
+		init_rwsem(&ni->file.run_lock);
 	} else {
 		err = -EINVAL;
 		goto out;
-- 
2.51.0



