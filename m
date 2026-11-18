Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028168;
	b=4M0oKlV4ryahuZbM6ThAW700PxfFj6PHf4cboqrUePJzf6k3lKYX/KZ1PK59K/CZw/TL
	 6N672yRavVceSIm1gOL4GrFfXDbod2b406LFWy8KwgvngWKNz/n6iOHhxDMRrPdbyBBUk
	 X/eQ4uak5bnnH60nZft0bzgD+0QvnQB7hSBkIYy95o8Mi8zzyyfg23+sKJeXZpiLMx0UU
	 dAyCsaCrpFZh7o+EsVW7bR92ND8WKobW97hpeivYGbUwKb7JBw1Tu4656HU3l8yIO9IDN
	 pLJeTSbmMiesmm6EyT0NWkkg35vi3t1yy9wkxJPGLWkxFJXCKY0jV1prI/muwPWkuUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h2PUD/dXLJmNJmYgxZ0tEtRO0kI7b9/TyBeMIs8fndM=;
	b=3VfEWF46WetOU9lKDT0Nw5Laz8rCRdyAwNFXO50NLu/mC70FUmmZC3CN7fPRJ7DRYVwy
	 KTXErU5uvieTikbdfVEsLZ2u2CJmOSFrdFO/0DYdTrOqa5dB3Zk4xSqSU3kT3FMoTrrY7
	 AeNCj0M/N+yffbNVNsUVM7WIjBw/4m2w6JkjJESD6TNE1Sk5VvUPogEBYMVdsPwslyVs5
	 FWc/ROehyajvaIXYDYBfz705PTvfiYU5D5RdPkU6QxamwcVcqwB1Zn0IOyEEJ3rfqWS7d
	 xgtWBZSMoVKBFcI0emndlh9JGi99V0APmpuwN7Uqj2H5Hc3UabmTHqNzU6sp/hLJHWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8RaXtgM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4F1606A330;
	Wed, 18 Nov 2026 18:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8RaXtgM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498831F000C4;
	Wed, 18 Nov 2026 18:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028168;
	bh=h2PUD/dXLJmNJmYgxZ0tEtRO0kI7b9/TyBeMIs8fndM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8RaXtgM6wrgUo2rJwkHQ2HhIipAwUE6J4BqWKmaKsw535RVKDr9oFFnfx83SaYgS
	 TzX+pkA5ZBulRyHPryGVSOa9ldf73JoC47zTghDOgD3Pif8KAULUXW4iEAhfCaYcdG
	 s58zsV9Jgob+y5qrQ5Vmdbuo4mM2A4pvqZN7hY+A=
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
Subject: [PATCH 6.18 1998/2151] block: fix recursive i_rwsem locking in blkdev_write_iter()
Date: Wed, 18 Nov 2026 16:02:13 +0100
Message-ID: <20261118150234.506398906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 68b55d3c0876e..64e8017cce431 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -845,9 +845,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
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



