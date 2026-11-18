Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021911;
	b=AKnHOtnZSzDwmwuTWuFdgZWU1fsk8qbs/mDybfFG4zs0wrA/mj/8kmGJfXrdoW0ar+vH
	 4b2HQZQAeT9+TXcdMCtao8YrIAvK32PBDPrZu9EUh7nfNsCtCyd0mbSizja8bcvaZsO/s
	 E4wFW/+y5fX9z5Vd1kAIV/KbUtJlc5nb0UMr4CfP9Y+vpct1jW8aKpigCR8aLuqdw3jHR
	 39FxiWS+BeRQDon1Qb/RJYabBJa0xPgLM4gXAo5VsOddypkEdVUAFsNz44uteqgNUlYAg
	 ybU1+02oxsqaFBqid1YtzoyN5w96fbA2jZuwKzzzPI7Jcjk7JxBQBybFjAyXKoK74cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9DLeBAWVAj+WkH7ggtC7nM+IqlYEiKz0l+TbPZcb2nU=;
	b=tGlz62wYAWqXOYHKqjsAvBeGBOI+1nnOhVt01B4RjZLTuctl+sJuH+TEMS3Rwb9/XMZZ
	 y+Zr+XcqatfjIqzSTS1BIShtvHjZjOKRV9h+0/vuKtcjNwyL5wLxp1QYvZjdD/DNcKQqw
	 wiYsDvqBDnGyNmvpbEdfez/BD/nRTDfCmUgqPN8Nv+GfCCB5sAQ/tNE5e48bzhXfrj52N
	 K3AnpvrlAKCzu1E4N7xWlaKAlVXirDEFdw3n5bWjSQWrTmdNrGitbzO9CTHHymQDisY98
	 6lqQ8bQxvBRTOLQTwgwMjgQq1+EEQ5VJANXwkQadCIcRSmAwCZFBbslJ+m4z1zlo9kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EF3L4pnZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3226A606A331;
	Wed, 18 Nov 2026 17:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EF3L4pnZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A341F000C5;
	Wed, 18 Nov 2026 17:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021911;
	bh=9DLeBAWVAj+WkH7ggtC7nM+IqlYEiKz0l+TbPZcb2nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EF3L4pnZdFLQCCQ0rS/S0MlV/sd0+fLHxEzGRgccNfh9mnp61gzgMcWCMmOdX9XPk
	 aLcQrvaJRyjBbxNYBGFqL8/haISFgmcV9i3TOEWzmrDky3vAVZsg0J5XAGBXFQc0Zw
	 C6NwGgKn/XSZ/gvQhdOae68F2z2PW75xBF9/X5kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bd975ef54294bec73f0e@syzkaller.appspotmail.com,
	Tal Zussman <tz2294@columbia.edu>,
	Julian Sun <sunjunchao@bytedance.com>,
	Zhenxian Ma <mzx199711@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2475/2651] block: fix recursive i_rwsem locking in blkdev_write_iter()
Date: Wed, 18 Nov 2026 16:01:55 +0100
Message-ID: <20261118150414.062570323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenxian Ma <mzx199711@gmail.com>

[ Upstream commit 21b88cc8bafceee6c6c82503e3b2cc6f1d0c78bf ]

Commit 2fec4fd97cc3 ("block: take i_rwsem for the direct I/O write
fallback") takes i_rwsem around blkdev_buffered_write() in the direct
write fallback to close a race with set_blocksize().  Commit
1b1be9ea4e34 ("block: take the inode lock for buffered write fallback")
fixes the same race by taking i_rwsem inside blkdev_buffered_write()
instead.  With both commits applied, the fallback path takes i_rwsem
recursively:

  blkdev_write_iter()
    inode_lock_shared(bd_inode)
    blkdev_buffered_write()
      inode_lock_shared(inode)

syzbot reports this as:

  WARNING: possible recursive locking detected
  syz.0.40/6005 is trying to acquire lock:
  ffff888024956f68 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: blkdev_buffered_write+0xd7/0x160 block/fops.c:738
  but task is already holding lock:
  ffff888024956f68 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: blkdev_write_iter+0x6c5/0x810 block/fops.c:815

rw_semaphore read locks are not recursive: once a writer is queued,
new readers block behind it.  If set_blocksize() calls inode_lock()
between the two acquisitions, it waits for the first read lock to be
released, while the second inode_lock_shared() waits behind
set_blocksize(), and the task deadlocks.

Drop the outer locking in the fallback.

Fixes: 1b1be9ea4e34 ("block: take the inode lock for buffered write fallback")
Reported-by: syzbot+bd975ef54294bec73f0e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bd975ef54294bec73f0e
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Julian Sun <sunjunchao@bytedance.com>
Assisted-by: LLM
Signed-off-by: Zhenxian Ma <mzx199711@gmail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261022062513.77372-1-mzx199711@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 847db3841ff23..f404ab1bd4d16 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -817,9 +817,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			} else {
 				ssize_t ret2;
 
-				inode_lock_shared(bd_inode);
 				ret2 = blkdev_buffered_write(iocb, from);
-				inode_unlock_shared(bd_inode);
 				ret = direct_write_fallback(iocb, from, ret,
 							    ret2);
 				need_sync = true;
-- 
2.53.0



